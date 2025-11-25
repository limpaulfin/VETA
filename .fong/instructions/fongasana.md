# fongasana.md - Asana CRUD Operations Guide

## 📅 Date Created: 2025-09-03
## 👤 Author: Fong & Asi
## 🎯 Purpose: Hướng dẫn CRUD operations với Asana API
## 🔖 Version: d8f77c67-59ed-4dc2-9e66-9f4e66ffd76a

---

## 🔑 Authentication

```bash
# Asana Personal Access Token
ASANA_TOKEN="2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d"

# Multiple Workspaces - CRITICAL: Check all workspaces for tasks
# NOTE: Quick reference for workspace IDs:
# - Self (1159540075171841)
# - Irontan Vietnam (276640063815812)
# - Deutschfuns (1211300418667644)
# - FinHUB (1211300406536801)

WORKSPACE_SELF="1159540075171841"        # Self workspace (main)
WORKSPACE_IRONTAN="276640063815812"      # Irontan Vietnam  
WORKSPACE_DEUTSCHFUNS="1211300418667644" # Deutschfuns
WORKSPACE_FINHUB="1211300406536801"      # FinHUB

# Example Project IDs (còn nhiều projects khác)
# Lấy full list: curl -s -H "Authorization: Bearer $ASANA_TOKEN" \
#                "https://app.asana.com/api/1.0/projects?workspace=1159540075171841" | jq '.data'

# Ví dụ một số projects hiện có:
PROJECT_DEUTSCHFUNS="1207752493335914"   # 🇩🇪 Deutschfuns
PROJECT_READ="1208349044334838"          # 📚 Read (books & researches)  
PROJECT_IOS="1208349044335057"           # 📱 iOS APP (test)
PROJECT_EGGS="1202934442782236"          # 🍳 QTG-quyentrungga.com-eggs
# ... và nhiều projects khác nữa trong workspace
```

## ⚠️ CRITICAL: Multi-Workspace Task Hierarchy

### Task Structure Discovery
**THỰC TẾ**: Asana có cấu trúc phức tạp hơn dự kiến:

```
WORKSPACE
├── PROJECTS (optional - tasks có thể không thuộc project nào)
│   └── TASKS
│       └── SUBTASKS
└── WORKSPACE-ONLY TASKS (không thuộc project cụ thể)
    └── SUBTASKS
```

### ⚠️ API Limitations Discovered

1. **Search API**: `tasks/search` endpoint **CHỈ** dành cho premium users
   ```bash
   # ❌ SẼ FAIL với free accounts:
   curl "https://app.asana.com/api/1.0/workspaces/WORKSPACE_ID/tasks/search?text=keyword"
   # Response: {"errors": [{"message": "Search is only available to premium users."}]}
   ```

2. **Alternative Search Strategy** (for free accounts):
   ```bash
   # ✅ USE: Get all tasks rồi filter locally
   curl "https://app.asana.com/api/1.0/tasks?workspace=WORKSPACE_ID&assignee=me" | \
   jq '.data[] | select(.name | contains("keyword"))'
   ```

## 📋 Asana Structure Tracking (MANDATORY)

**QUAN TRỌNG**: Mỗi lần làm việc với Asana, PHẢI CRUD vào file `/home/fong/Dropbox/pool-memory/asana-fong.json`

### ⚠️ CRITICAL: TASKS & SUBTASKS RELATIONSHIP
**LƯU Ý**: Asana tasks thường có cấu trúc hierarchical với subtasks:
- **Mỗi task có thể có nhiều subtasks** (parent-child relationship)
- **Khi tìm task** → PHẢI tìm cả subtasks của nó
- **Khi CRUD task** → PHẢI xem xét cả parent task và subtasks
- **Nhìn tổng quát trước** → hiểu structure → rồi mới update
- **Subtasks inheritance**: Subtasks thường kế thừa properties từ parent task

### ⚠️ CRITICAL: CRUD ON-THE-FLY
**KHÔNG BAO GIỜ** đọc hết rồi mới update. PHẢI update ngay khi query:
- Query project → Update project info + LIST ALL TASKS → Update tasks
- Query task → Update task info immediately  
- Create task → Add to file immediately
- Update task → Update file immediately
- **LUÔN LUÔN** phải có cả TASKS, không chỉ projects!

### Workflow bắt buộc:
1. **Đọc file** `asana-fong.json` trước mọi thao tác
2. **Kiểm tra** xem element cần tìm có trong file không
3. **Nếu có** → verify trên Asana → nếu đúng: làm tiếp, nếu sai: update file NGAY
4. **Nếu không có** → search trên Asana → add vào file NGAY → làm tiếp  
5. **Update file NGAY** sau MỖI query/operation (không đợi xong hết)

### File structure (PHẢI CÓ ĐẦY ĐỦ TASKS):
```json
{
  "last_updated": "YYYY-MM-DD HH:MM:SS",
  "workspaces": {
    "1159540075171841": {
      "name": "Main Workspace",
      "projects_count": 0
    }
  },
  "projects": {
    "PROJECT_ID": {
      "name": "Project Name",
      "workspace": "WORKSPACE_ID",
      "archived": false,
      "tasks_count": 15,  // PHẢI track số lượng tasks
      "last_tasks_fetch": "2025-09-09 16:00:00"  // Track lần cuối fetch tasks
    }
  },
  "tasks": {
    "TASK_ID": {
      "name": "Task Name",
      "project": "PROJECT_ID",
      "parent": "PARENT_ID or null",
      "completed": false,
      "due_on": "YYYY-MM-DD",
      "due_at": "YYYY-MM-DDTHH:MM:SS.000Z",
      "assignee": "user_id",
      "created_at": "YYYY-MM-DDTHH:MM:SS.000Z",
      "notes": "Task description"
    }
  }
}
```

**⚠️ LƯU Ý**: Mỗi khi query 1 project PHẢI fetch ALL TASKS của project đó và update NGAY!

### Bash functions for ON-THE-FLY tracking:
```bash
# Read tracking file
read_asana_tracking() {
    cat /home/fong/Dropbox/pool-memory/asana-fong.json | jq '.'
}

# CRITICAL: Fetch project WITH ALL TASKS and update immediately
fetch_and_update_project_with_tasks() {
    local project_id="$1"
    echo "=== FETCHING PROJECT $project_id WITH ALL TASKS ==="
    
    # Get project info
    local project_info=$(curl -s \
        -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
        "https://app.asana.com/api/1.0/projects/$project_id")
    
    # Update project in file IMMEDIATELY
    local project_name=$(echo "$project_info" | jq -r '.data.name')
    local workspace_id=$(echo "$project_info" | jq -r '.data.workspace.gid')
    
    # Update project info
    jq --arg pid "$project_id" \
       --arg pname "$project_name" \
       --arg wid "$workspace_id" \
       '.projects[$pid] = {name: $pname, workspace: $wid, archived: false} | 
        .last_updated = (now | strftime("%Y-%m-%d %H:%M:%S"))' \
       /home/fong/Dropbox/pool-memory/asana-fong.json > /tmp/asana-temp.json && \
       mv /tmp/asana-temp.json /home/fong/Dropbox/pool-memory/asana-fong.json
    
    # NOW FETCH ALL TASKS AND UPDATE ON-THE-FLY
    echo "Fetching all tasks for project..."
    local tasks=$(curl -s \
        -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
        "https://app.asana.com/api/1.0/projects/$project_id/tasks?opt_fields=name,completed,due_on,due_at,assignee,parent,notes,created_at&limit=100")
    
    # Process each task and update IMMEDIATELY
    echo "$tasks" | jq -c '.data[]' | while read task; do
        local task_id=$(echo "$task" | jq -r '.gid')
        local task_name=$(echo "$task" | jq -r '.name')
        local completed=$(echo "$task" | jq -r '.completed')
        local due_on=$(echo "$task" | jq -r '.due_on // null')
        local notes=$(echo "$task" | jq -r '.notes // ""')
        
        # Update task in file IMMEDIATELY (on-the-fly)
        jq --arg tid "$task_id" \
           --arg tname "$task_name" \
           --arg pid "$project_id" \
           --argjson completed "$completed" \
           --arg due "$due_on" \
           --arg notes "$notes" \
           '.tasks[$tid] = {name: $tname, project: $pid, completed: $completed, due_on: $due, notes: $notes}' \
           /home/fong/Dropbox/pool-memory/asana-fong.json > /tmp/asana-temp.json && \
           mv /tmp/asana-temp.json /home/fong/Dropbox/pool-memory/asana-fong.json
           
        echo "  ✅ Updated task: $task_name"
    done
    
    # Update task count
    local task_count=$(echo "$tasks" | jq '.data | length')
    jq --arg pid "$project_id" \
       --argjson count "$task_count" \
       --arg fetch_time "$(date '+%Y-%m-%d %H:%M:%S')" \
       '.projects[$pid].tasks_count = $count | 
        .projects[$pid].last_tasks_fetch = $fetch_time' \
       /home/fong/Dropbox/pool-memory/asana-fong.json > /tmp/asana-temp.json && \
       mv /tmp/asana-temp.json /home/fong/Dropbox/pool-memory/asana-fong.json
       
    echo "✅ Project $project_name updated with $task_count tasks"
}

# Update tracking after creating task (ON-THE-FLY)
update_tracking_new_task() {
    local task_id="$1"
    local task_name="$2"
    local project_id="$3"
    
    # Update IMMEDIATELY
    jq --arg id "$task_id" \
       --arg name "$task_name" \
       --arg project "$project_id" \
       '.tasks[$id] = {name: $name, project: $project, completed: false} | 
        .last_updated = (now | strftime("%Y-%m-%d %H:%M:%S"))' \
       /home/fong/Dropbox/pool-memory/asana-fong.json > /tmp/asana-temp.json && \
       mv /tmp/asana-temp.json /home/fong/Dropbox/pool-memory/asana-fong.json
       
    echo "✅ Task added to tracking: $task_name"
}

# Check if task exists in tracking
check_task_exists() {
    local search_term="$1"
    cat /home/fong/Dropbox/pool-memory/asana-fong.json | \
        jq -r --arg term "$search_term" '.tasks | to_entries[] | select(.value.name | contains($term)) | "\(.key): \(.value.name)"'
}

# MANDATORY: Before ANY Asana operation
pre_operation_check() {
    local operation_type="$1"  # create/update/delete/read
    local element_name="$2"
    
    echo "=== PRE-OPERATION CHECK: $operation_type - $element_name ==="
    
    # 1. Check in tracking file FIRST
    local exists=$(check_task_exists "$element_name")
    
    if [ -n "$exists" ]; then
        echo "✅ Found in tracking: $exists"
        echo "Verifying on Asana..."
        # Verify and update if needed
    else
        echo "❌ Not in tracking. Searching on Asana..."
        # Search on Asana and update tracking ON-THE-FLY
    fi
}
```

---

## 📝 CRUD Operations

### 1️⃣ **CREATE - Tạo Task Mới**

```bash
# Basic create task
curl -X POST \
  -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
  -H "Content-Type: application/json" \
  -d '{
    "data": {
      "name": "Task name here",
      "notes": "Task description/notes",
      "workspace": "1159540075171841",
      "projects": ["1207752493335914"],
      "assignee": "me",
      "due_on": "2025-09-10"
    }
  }' \
  "https://app.asana.com/api/1.0/tasks"
```

**PHP Function:**
```php
function fong_create_asana_task($name, $notes = '', $due_date = null, $project_id = null) {
    $token = '2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d';
    $workspace = '1159540075171841';
    $project = $project_id ?: '1207752493335914'; // Default to Deutschfuns if not specified
    
    $data = [
        'name' => $name,
        'notes' => $notes,
        'workspace' => $workspace,
        'projects' => [$project],
        'assignee' => 'me'
    ];
    
    if ($due_date) {
        $data['due_on'] = $due_date; // Format: YYYY-MM-DD
    }
    
    $response = wp_remote_post('https://app.asana.com/api/1.0/tasks', [
        'headers' => [
            'Authorization' => 'Bearer ' . $token,
            'Content-Type' => 'application/json'
        ],
        'body' => json_encode(['data' => $data])
    ]);
    
    return json_decode(wp_remote_retrieve_body($response), true);
}
```

**Bash Function:**
```bash
create_asana_task() {
    local name="$1"
    local notes="${2:-}"
    local due_date="${3:-}"
    
    local data='{
        "data": {
            "name": "'"$name"'",
            "notes": "'"$notes"'",
            "workspace": "1159540075171841",
            "projects": ["1207752493335914"],
            "assignee": "me"
    '
    
    if [ -n "$due_date" ]; then
        data+=', "due_on": "'"$due_date"'"'
    fi
    
    data+='}}'
    
    curl -s -X POST \
        -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
        -H "Content-Type: application/json" \
        -d "$data" \
        "https://app.asana.com/api/1.0/tasks" | jq '.data'
}

# Usage:
# create_asana_task "Bug: Login not working" "Steps to reproduce..." "2025-09-05"
```

---

### 2️⃣ **READ - Đọc Task**

```bash
# Get single task
curl -s \
  -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
  "https://app.asana.com/api/1.0/tasks/{TASK_ID}?opt_fields=name,notes,completed,assignee.name,due_on,projects.name"

# Get all tasks for today
curl -s \
  -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
  "https://app.asana.com/api/1.0/tasks?workspace=1159540075171841&assignee=me&due_on=2025-09-03&opt_fields=name,due_on,completed,projects.name"

# Get incomplete tasks
curl -s \
  -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
  "https://app.asana.com/api/1.0/tasks?workspace=1159540075171841&assignee=me&completed_since=now&opt_fields=name,due_on,notes,projects.name"
```

**PHP Function:**
```php
function fong_get_asana_tasks_today() {
    $token = '2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d';
    $today = date('Y-m-d');
    
    $url = 'https://app.asana.com/api/1.0/tasks?' . http_build_query([
        'workspace' => '1159540075171841',
        'assignee' => 'me',
        'due_on' => $today,
        'opt_fields' => 'name,due_on,completed,notes,projects.name'
    ]);
    
    $response = wp_remote_get($url, [
        'headers' => [
            'Authorization' => 'Bearer ' . $token
        ]
    ]);
    
    return json_decode(wp_remote_retrieve_body($response), true);
}
```

---

### 3️⃣ **UPDATE - Cập Nhật Task**

```bash
# Update task
curl -X PUT \
  -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
  -H "Content-Type: application/json" \
  -d '{
    "data": {
      "name": "Updated task name",
      "notes": "Updated description",
      "due_on": "2025-09-10",
      "completed": false
    }
  }' \
  "https://app.asana.com/api/1.0/tasks/{TASK_ID}"

# Mark task as completed
curl -X PUT \
  -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
  -H "Content-Type: application/json" \
  -d '{"data": {"completed": true}}' \
  "https://app.asana.com/api/1.0/tasks/{TASK_ID}"
```

**Bash Function:**
```bash
complete_asana_task() {
    local task_id="$1"
    
    curl -s -X PUT \
        -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
        -H "Content-Type: application/json" \
        -d '{"data": {"completed": true}}' \
        "https://app.asana.com/api/1.0/tasks/$task_id" | jq '.data.completed'
}

update_asana_task() {
    local task_id="$1"
    local name="$2"
    local notes="$3"
    local due_date="$4"
    
    curl -s -X PUT \
        -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
        -H "Content-Type: application/json" \
        -d '{
            "data": {
                "name": "'"$name"'",
                "notes": "'"$notes"'",
                "due_on": "'"$due_date"'"
            }
        }' \
        "https://app.asana.com/api/1.0/tasks/$task_id" | jq '.data'
}
```

---

### 4️⃣ **DELETE - Xóa Task**

```bash
# Delete task
curl -X DELETE \
  -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
  "https://app.asana.com/api/1.0/tasks/{TASK_ID}"
```

**Bash Function:**
```bash
delete_asana_task() {
    local task_id="$1"
    
    curl -s -X DELETE \
        -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
        "https://app.asana.com/api/1.0/tasks/$task_id" \
        -w "\nStatus: %{http_code}\n"
}
```

---

## 🔍 Helper Functions

### List All Available Projects
```bash
# Bash function to list all projects
list_asana_projects() {
    echo "=== ALL ASANA PROJECTS ==="
    curl -s \
        -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
        "https://app.asana.com/api/1.0/projects?workspace=1159540075171841&opt_fields=name,archived" \
        | jq -r '.data[] | select(.archived == false) | "[\(.gid)] \(.name)"'
    echo ""
    echo "Note: Đây chỉ là một phần projects. Workspace có thể có nhiều projects khác."
}
```

### PHP Function to Get All Projects
```php
function fong_get_asana_projects() {
    $token = '2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d';
    $workspace = '1159540075171841';
    
    $response = wp_remote_get("https://app.asana.com/api/1.0/projects?workspace=$workspace", [
        'headers' => ['Authorization' => 'Bearer ' . $token]
    ]);
    
    $data = json_decode(wp_remote_retrieve_body($response), true);
    $projects = [];
    
    foreach ($data['data'] as $project) {
        $projects[$project['gid']] = $project['name'];
    }
    
    return $projects; // Returns array: gid => name
}
```

---

## 🎯 Best Practices & Principles

### DRY & SSoT Principles
```bash
# WORKSPACE-AWARE search for tasks/subtasks (compatible với free accounts)
search_existing_tasks() {
    local search_term="$1"
    local workspace_ids=("1159540075171841" "276640063815812" "1211300418667644" "1211300406536801")
    local workspace_names=("Self" "Irontan Vietnam" "Deutschfuns" "FinHUB")
    
    echo "=== MULTI-WORKSPACE SEARCH: '$search_term' ==="
    
    for i in "${!workspace_ids[@]}"; do
        local workspace_id="${workspace_ids[$i]}"
        local workspace_name="${workspace_names[$i]}"
        
        echo ""
        echo "🏢 Workspace: $workspace_name ($workspace_id)"
        
        # Get all tasks from workspace (free account compatible)
        local all_tasks=$(curl -s \
            -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
            "https://app.asana.com/api/1.0/tasks?workspace=$workspace_id&assignee=me&opt_fields=gid,name,due_on,parent.name,parent.gid,projects.name")
        
        # Filter locally for search term (case insensitive)
        local matching_tasks=$(echo "$all_tasks" | jq --arg term "$search_term" '
            .data[] | select(.name | ascii_downcase | contains($term | ascii_downcase))')
        
        if [ -n "$matching_tasks" ] && [ "$matching_tasks" != "null" ]; then
            echo "   📋 Found matching tasks:"
            echo "$matching_tasks" | jq -r '"\(.name) (Due: \(.due_on // "No date")) [Parent: \(.parent.name // "MAIN TASK")] [Projects: \((.projects | map(.name)) | join(", ") // "WORKSPACE-ONLY")]"'
            
            # Check subtasks for each matching task
            echo "$matching_tasks" | jq -r '.gid' | while read task_id; do
                if [ -n "$task_id" ]; then
                    local subtasks=$(curl -s \
                        -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
                        "https://app.asana.com/api/1.0/tasks/$task_id/subtasks?opt_fields=name,due_on,completed" | jq '.data')
                    
                    local subtask_count=$(echo "$subtasks" | jq 'length // 0')
                    if [ "$subtask_count" -gt 0 ]; then
                        local task_name=$(echo "$matching_tasks" | jq -r "select(.gid == \"$task_id\") | .name")
                        echo "     └── Task '$task_name' has $subtask_count subtasks:"
                        echo "$subtasks" | jq -r '.[] | "         • \(.name) \(if .completed then "✅" else "⏳" end) (Due: \(.due_on // "No date"))"'
                    fi
                fi
            done
        else
            echo "   ❌ No tasks matching '$search_term' in this workspace"
        fi
    done
    
    echo ""
    echo "✅ Search completed across all workspaces"
}

# Usage: Always check before creating
# search_existing_tasks "interview"
# search_existing_tasks "CV tech"
```

### Double Check After Operations
```bash
# ALWAYS verify after any operation
verify_task_operation() {
    local task_id="$1"
    local expected_parent="${2:-}"
    
    echo "=== VERIFYING TASK $task_id ==="
    local result=$(curl -s \
        -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
        "https://app.asana.com/api/1.0/tasks/$task_id?opt_fields=name,parent.gid,parent.name,completed,due_on,due_at")
    
    echo "$result" | jq '.data | {name, parent: .parent.name, due_on, due_at, completed}'
    
    # Verify parent if expected
    if [ -n "$expected_parent" ]; then
        local actual_parent=$(echo "$result" | jq -r '.data.parent.gid // "none"')
        if [ "$actual_parent" = "$expected_parent" ]; then
            echo "✅ Parent verified: $expected_parent"
        else
            echo "❌ Parent mismatch! Expected: $expected_parent, Actual: $actual_parent"
        fi
    fi
}
```

### Due Time Configuration
```bash
# Create task with specific due time (not just date)
create_task_with_time() {
    local name="$1"
    local notes="$2"
    local due_date="$3"      # Format: YYYY-MM-DD
    local due_time="${4:-}"  # Format: HH:MM (Vietnam time, optional)
    
    local data='{
        "data": {
            "name": "'"$name"'",
            "notes": "'"$notes"'",
            "workspace": "1159540075171841",
            "projects": ["1207752493335914"],
            "assignee": "me"'
    
    if [ -n "$due_time" ]; then
        # Convert Vietnam time (UTC+7) to UTC
        local utc_time=$(date -d "$due_date $due_time +0700" -u '+%Y-%m-%dT%H:%M:%S.000Z')
        data+=', "due_at": "'"$utc_time"'"'
    else
        data+=', "due_on": "'"$due_date"'"'
    fi
    
    data+='}}'
    
    curl -s -X POST \
        -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
        -H "Content-Type: application/json" \
        -d "$data" \
        "https://app.asana.com/api/1.0/tasks" | jq '.data.gid'
}

# Usage examples:
# create_task_with_time "Meeting" "Discussion" "2025-09-05" "14:30"  # With specific time
# create_task_with_time "Review" "Check docs" "2025-09-05"           # Date only
```

## 🔄 Subtask Management

### Create Subtask
```bash
# Create a subtask directly under a parent task
create_subtask() {
    local parent_id="$1"
    local name="$2"
    local notes="${3:-}"
    local due_date="${4:-}"
    local due_time="${5:-}"  # Optional: HH:MM format
    
    local data='{
        "data": {
            "name": "'"$name"'",
            "notes": "'"$notes"'",
            "parent": "'"$parent_id"'",
            "assignee": "me"'
    
    if [ -n "$due_date" ]; then
        if [ -n "$due_time" ]; then
            # Convert to UTC if time provided
            local utc_time=$(date -d "$due_date $due_time +0700" -u '+%Y-%m-%dT%H:%M:%S.000Z')
            data+=', "due_at": "'"$utc_time"'"'
        else
            data+=', "due_on": "'"$due_date"'"'
        fi
    fi
    
    data+='}}'
    
    local new_task=$(curl -s -X POST \
        -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
        -H "Content-Type: application/json" \
        -d "$data" \
        "https://app.asana.com/api/1.0/tasks")
    
    local task_id=$(echo "$new_task" | jq -r '.data.gid')
    echo "Created subtask: $task_id"
    
    # ALWAYS verify after creation
    verify_task_operation "$task_id" "$parent_id"
}
```

### Move Task to Subtask
```bash
# Move existing task to become subtask of another task
move_to_subtask() {
    local task_id="$1"
    local parent_id="$2"
    
    echo "Moving task $task_id to be subtask of $parent_id..."
    
    # Use setParent endpoint
    local result=$(curl -s -X POST \
        -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
        -H "Content-Type: application/json" \
        -d '{"data": {"parent": "'"$parent_id"'"}}' \
        "https://app.asana.com/api/1.0/tasks/$task_id/setParent")
    
    # ALWAYS double check
    echo "=== VERIFYING MOVE OPERATION ==="
    verify_task_operation "$task_id" "$parent_id"
}

# Usage:
# move_to_subtask "1211221223438206" "1211220798247694"
```

### List All Subtasks
```bash
# Get all subtasks of a parent task
list_subtasks() {
    local parent_id="$1"
    
    echo "=== SUBTASKS OF $parent_id ==="
    curl -s \
        -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
        "https://app.asana.com/api/1.0/tasks/$parent_id/subtasks?opt_fields=name,due_on,due_at,completed" \
        | jq '.data[] | "\(if .completed then "✅" else "⏳" end) \(.name) (Due: \(.due_on // .due_at // "No date"))"'
}
```

## ⚠️ Critical Rules

1. **DRY Principle**: ALWAYS search existing tasks AND subtasks before creating
2. **SSoT**: Maintain single source of truth - no duplicate tasks/subtasks
3. **Hierarchical Awareness**: NHÌN TỔNG QUÁT - understand task structure before CRUD
4. **Subtask Priority**: When finding task → immediately check for subtasks
5. **Double Check**: ALWAYS verify operations actually succeeded
6. **Due Time Support**: Can specify exact time, not just date
7. **Parent Verification**: Always confirm subtask relationships
8. **Context First**: Understand parent-child relationships before making changes
9. **Never Assume**: Don't trust operation success without verification

### Pre-Creation Checklist
```bash
# Run this before creating any new task - INCLUDES SUBTASK CHECK
pre_create_checklist() {
    local task_name="$1"
    
    echo "=== PRE-CREATION CHECKLIST (TASKS & SUBTASKS) ==="
    echo "1. Searching for similar tasks and their subtasks..."
    search_existing_tasks "$task_name"
    
    echo ""
    echo "2. Checking recent tasks and their subtask structure..."
    local recent_tasks=$(curl -s \
        -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
        "https://app.asana.com/api/1.0/tasks?workspace=1159540075171841&assignee=me&opt_fields=gid,name,parent.name" \
        | jq '.data[:10]')
    
    echo "$recent_tasks" | jq -r '.[] | "\(.name) [Parent: \(.parent.name // "None")]"'
    
    echo ""
    echo "3. NHÌN TỔNG QUÁT: Checking task structure context..."
    echo "$recent_tasks" | jq -r '.[].gid' | while read task_id; do
        if [ -n "$task_id" ]; then
            local task_name_temp=$(echo "$recent_tasks" | jq -r ".[] | select(.gid == \"$task_id\") | .name")
            local subtask_count=$(curl -s \
                -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
                "https://app.asana.com/api/1.0/tasks/$task_id/subtasks" | jq '.data | length')
            
            if [ "$subtask_count" -gt 0 ]; then
                echo "   📋 '$task_name_temp' → có $subtask_count subtasks"
            fi
        fi
    done
    
    echo ""
    echo "✅ If no duplicates found and context understood, safe to create new task"
    echo "💡 Consider: Should this be a main task or subtask of existing task?"
}
```

---

## 🌳 Hierarchical Task Management Approach

### NHÌN TỔNG QUÁT TRƯỚC KHI ACTION
**Workflow bắt buộc khi làm việc với Asana tasks:**

```bash
# 1️⃣ FIRST: Get overview of task landscape (MULTI-WORKSPACE)
get_task_overview() {
    local keyword="${1:-}"
    local workspace_ids=("1159540075171841" "276640063815812" "1211300418667644" "1211300406536801")
    local workspace_names=("Self" "Irontan Vietnam" "Deutschfuns" "FinHUB")
    
    echo "=== MULTI-WORKSPACE TASK LANDSCAPE OVERVIEW ==="
    
    for i in "${!workspace_ids[@]}"; do
        local workspace_id="${workspace_ids[$i]}"
        local workspace_name="${workspace_names[$i]}"
        
        echo ""
        echo "🏢 WORKSPACE: $workspace_name ($workspace_id)"
        
        # Get projects in this workspace
        echo "  📊 Projects & Task Counts:"
        local projects=$(curl -s \
            -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
            "https://app.asana.com/api/1.0/projects?workspace=$workspace_id&opt_fields=name,archived")
        
        echo "$projects" | jq -r '.data[] | select(.archived == false) | .gid' | while read project_id; do
            local project_name=$(echo "$projects" | jq -r ".data[] | select(.gid == \"$project_id\") | .name")
            local task_count=$(curl -s \
                -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
                "https://app.asana.com/api/1.0/projects/$project_id/tasks" | jq '.data | length // 0')
            
            echo "     📋 $project_name: $task_count tasks"
        done
        
        # Get workspace-only tasks (không thuộc project nào)
        echo ""
        echo "  🌳 Task Hierarchy Overview (recent 10 tasks):"
        local workspace_tasks=$(curl -s \
            -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
            "https://app.asana.com/api/1.0/tasks?workspace=$workspace_id&assignee=me&opt_fields=gid,name,parent.name,completed,projects.name")
        
        echo "$workspace_tasks" | jq -r '.data[:10][] | "\(.name) [Parent: \(.parent.name // "MAIN TASK")] [Projects: \((.projects | map(.name)) | join(", ") // "WORKSPACE-ONLY")] \(if .completed then "✅" else "⏳" end)"'
        
        # Count workspace-only tasks
        local workspace_only_count=$(echo "$workspace_tasks" | jq '[.data[] | select(.projects == [] or .projects == null)] | length')
        echo "  📌 Workspace-only tasks: $workspace_only_count"
    done
    
    if [ -n "$keyword" ]; then
        echo ""
        echo "🔍 Specific search for: '$keyword'"
        search_existing_tasks "$keyword"
    fi
}

# 2️⃣ SECOND: Understand context before action
understand_task_context() {
    local task_id="$1"
    
    echo "=== CONTEXT ANALYSIS FOR TASK: $task_id ==="
    
    # Get task details
    local task_info=$(curl -s \
        -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
        "https://app.asana.com/api/1.0/tasks/$task_id?opt_fields=name,parent,projects.name,created_at,completed,due_on")
    
    echo "📝 Task Info:"
    echo "$task_info" | jq '.data | {name, parent: .parent.name, project: .projects[0].name, due_on, completed}'
    
    # Check if this task has subtasks
    local subtasks=$(curl -s \
        -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
        "https://app.asana.com/api/1.0/tasks/$task_id/subtasks?opt_fields=name,completed,due_on")
    
    local subtask_count=$(echo "$subtasks" | jq '.data | length')
    if [ "$subtask_count" -gt 0 ]; then
        echo ""
        echo "📋 This task has $subtask_count subtasks:"
        echo "$subtasks" | jq -r '.data[] | "   • \(.name) \(if .completed then "✅" else "⏳" end) (Due: \(.due_on // "No date"))"'
    fi
    
    # Check if this is a subtask
    local parent_id=$(echo "$task_info" | jq -r '.data.parent.gid // empty')
    if [ -n "$parent_id" ]; then
        echo ""
        echo "⬆️ This is a SUBTASK. Parent task details:"
        curl -s \
            -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
            "https://app.asana.com/api/1.0/tasks/$parent_id?opt_fields=name,due_on,completed" \
            | jq '.data | "   Parent: \(.name) \(if .completed then "✅" else "⏳" end) (Due: \(.due_on // "No date"))"'
        
        # Show sibling subtasks
        echo "🤝 Sibling subtasks:"
        curl -s \
            -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
            "https://app.asana.com/api/1.0/tasks/$parent_id/subtasks?opt_fields=name,completed,due_on" \
            | jq -r '.data[] | "   • \(.name) \(if .completed then "✅" else "⏳" end) (Due: \(.due_on // "No date"))"'
    fi
}

# 3️⃣ THIRD: Action with full context
smart_task_action() {
    local action="$1"  # create/update/delete
    local target="$2"  # task_name or task_id
    
    echo "=== SMART ACTION: $action on '$target' ==="
    
    # Step 1: Overview
    get_task_overview "$target"
    
    echo ""
    echo "⚠️ PAUSE: Review above information before proceeding"
    echo "💡 Questions to ask:"
    echo "   - Should this be main task or subtask?"
    echo "   - Are there related tasks/subtasks?"
    echo "   - What's the proper parent-child relationship?"
    echo "   - Will this create duplicates?"
    
    # Step 2: Context (if action is on existing task)
    if [ "$action" != "create" ]; then
        understand_task_context "$target"
    fi
    
    echo ""
    echo "✅ Ready for informed action on '$target'"
}
```

### Usage Examples:
```bash
# Before doing ANYTHING with Asana:
smart_task_action "create" "interview process"
smart_task_action "update" "1211305175850729" 
smart_task_action "delete" "1211305175850730"

# Quick landscape overview:
get_task_overview
get_task_overview "bug"

# Deep dive on specific task:
understand_task_context "1211305175850729"
```

---

## 🏢 Multi-Workspace Helper Functions

### List All Workspaces
```bash
list_all_workspaces() {
    echo "=== ALL ASANA WORKSPACES ==="
    curl -s \
        -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
        "https://app.asana.com/api/1.0/workspaces" \
        | jq -r '.data[] | "🏢 \(.name) (\(.gid))"'
}
```

### Get Workspace-Only Tasks (No Project Assignment)
```bash
get_workspace_only_tasks() {
    local workspace_id="${1:-1159540075171841}"  # Default to Self workspace
    
    echo "=== WORKSPACE-ONLY TASKS (NO PROJECT) ==="
    local all_tasks=$(curl -s \
        -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
        "https://app.asana.com/api/1.0/tasks?workspace=$workspace_id&assignee=me&opt_fields=gid,name,due_on,completed,projects.name,parent.name")
    
    # Filter tasks with empty projects array
    local workspace_only=$(echo "$all_tasks" | jq '.data[] | select(.projects == [] or .projects == null)')
    
    if [ -n "$workspace_only" ] && [ "$workspace_only" != "null" ]; then
        echo "📋 Tasks belonging only to workspace:"
        echo "$workspace_only" | jq -r '"\(.name) \(if .completed then "✅" else "⏳" end) (Due: \(.due_on // "No date")) [Parent: \(.parent.name // "MAIN TASK")]"'
        
        local count=$(echo "$workspace_only" | jq -s 'length')
        echo ""
        echo "📊 Total workspace-only tasks: $count"
    else
        echo "❌ No workspace-only tasks found"
    fi
}

# Usage: 
# get_workspace_only_tasks                    # Default Self workspace
# get_workspace_only_tasks "1211300418667644" # Deutschfuns workspace
```

### Cross-Workspace Task Summary
```bash
get_cross_workspace_summary() {
    local workspace_ids=("1159540075171841" "276640063815812" "1211300418667644" "1211300406536801")
    local workspace_names=("Self" "Irontan Vietnam" "Deutschfuns" "FinHUB")
    
    echo "=== CROSS-WORKSPACE TASK SUMMARY ==="
    
    local total_tasks=0
    local total_workspace_only=0
    local total_completed=0
    
    for i in "${!workspace_ids[@]}"; do
        local workspace_id="${workspace_ids[$i]}"
        local workspace_name="${workspace_names[$i]}"
        
        echo ""
        echo "🏢 $workspace_name:"
        
        local tasks=$(curl -s \
            -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
            "https://app.asana.com/api/1.0/tasks?workspace=$workspace_id&assignee=me&opt_fields=completed,projects.name")
        
        local task_count=$(echo "$tasks" | jq '.data | length // 0')
        local completed_count=$(echo "$tasks" | jq '[.data[] | select(.completed == true)] | length')
        local workspace_only_count=$(echo "$tasks" | jq '[.data[] | select(.projects == [] or .projects == null)] | length')
        local incomplete_count=$((task_count - completed_count))
        
        echo "   📊 Total: $task_count tasks"
        echo "   ✅ Completed: $completed_count"
        echo "   ⏳ Incomplete: $incomplete_count"
        echo "   📌 Workspace-only: $workspace_only_count"
        
        total_tasks=$((total_tasks + task_count))
        total_completed=$((total_completed + completed_count))
        total_workspace_only=$((total_workspace_only + workspace_only_count))
    done
    
    echo ""
    echo "🌍 GRAND TOTAL:"
    echo "   📊 All tasks: $total_tasks"
    echo "   ✅ Completed: $total_completed"
    echo "   ⏳ Incomplete: $((total_tasks - total_completed))"
    echo "   📌 Workspace-only tasks: $total_workspace_only"
    echo "   📈 Completion rate: $(( (total_completed * 100) / (total_tasks == 0 ? 1 : total_tasks) ))%"
}
```

---

## 🚀 Practical Examples

### Example 1: Create Bug Report
```bash
# Create bug report from error
create_bug_task() {
    local error_msg="$1"
    local stack_trace="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    create_asana_task \
        "BUG: $error_msg" \
        "Timestamp: $timestamp\nStack trace:\n$stack_trace" \
        "$(date -d '+1 day' '+%Y-%m-%d')"
}
```

### Example 2: Daily Tasks Report
```bash
# Get today's tasks
get_today_tasks() {
    curl -s \
        -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
        "https://app.asana.com/api/1.0/tasks?workspace=1159540075171841&assignee=me&due_on=$(date '+%Y-%m-%d')&opt_fields=name,completed" \
        | jq -r '.data[] | "\(.completed | if . then "✅" else "⏳" end) \(.name)"'
}
```

### Example 3: WordPress Integration
```php
// Auto create task when error occurs
add_action('wp_error_added', function($error) {
    if (fong_is_critical_error($error)) {
        fong_create_asana_task(
            'WordPress Error: ' . $error->get_error_message(),
            'Code: ' . $error->get_error_code() . "\n" . 
            'Data: ' . json_encode($error->get_error_data()),
            date('Y-m-d', strtotime('+1 day'))
        );
    }
});
```

### Example 4: Git Hook Integration
```bash
#!/bin/bash
# .git/hooks/post-commit
# Create Asana task for each commit

commit_msg=$(git log -1 --pretty=%B)
commit_hash=$(git rev-parse HEAD)

if [[ $commit_msg == *"BUG"* ]]; then
    create_asana_task \
        "Fix: $commit_msg" \
        "Commit: $commit_hash\nBranch: $(git branch --show-current)" \
        "$(date -d '+2 days' '+%Y-%m-%d')"
fi
```

---

## 📊 Useful Queries

### Get All Projects (Dynamic List)
```bash
# Lấy toàn bộ danh sách projects trong workspace
curl -s \
  -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
  "https://app.asana.com/api/1.0/projects?workspace=1159540075171841" \
  | jq '.data[] | {gid, name}'

# Output example (danh sách thực tế có thể khác):
# {
#   "gid": "1207752493335914",
#   "name": "🇩🇪 Deutschfuns"
# }
# {
#   "gid": "1208349044334838",
#   "name": "📚 Read (books & researches)"
# }
# {
#   "gid": "1208349044335057",
#   "name": "📱 iOS APP (test)"
# }
# ... và nhiều projects khác

# Lưu project IDs vào variable
PROJECTS=$(curl -s \
  -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
  "https://app.asana.com/api/1.0/projects?workspace=1159540075171841" \
  | jq -r '.data[] | "\(.gid):\(.name)"')
```

### Get Tasks by Project
```bash
# Replace PROJECT_ID với actual project ID từ danh sách projects
PROJECT_ID="1207752493335914"  # Example: Deutschfuns project

curl -s \
  -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
  "https://app.asana.com/api/1.0/projects/$PROJECT_ID/tasks?opt_fields=name,completed,due_on" \
  | jq '.data'
```

### Search Tasks
```bash
curl -s \
  -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
  "https://app.asana.com/api/1.0/workspaces/1159540075171841/tasks/search?text=bug&opt_fields=name,notes" \
  | jq '.data'
```

---

## 🔧 Automation Scripts

### Daily Standup Generator
```bash
#!/bin/bash
# daily-standup.sh

echo "=== DAILY STANDUP $(date '+%Y-%m-%d') ==="
echo ""
echo "📅 TODAY'S TASKS:"
get_today_tasks

echo ""
echo "✅ COMPLETED YESTERDAY:"
curl -s \
  -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
  "https://app.asana.com/api/1.0/tasks?workspace=1159540075171841&assignee=me&completed_on=$(date -d '-1 day' '+%Y-%m-%d')&opt_fields=name" \
  | jq -r '.data[].name' | sed 's/^/- /'
```

### Deployment Checklist Creator
```bash
create_deployment_checklist() {
    local version="$1"
    local tasks=(
        "Backup database"
        "Run tests"
        "Build assets"
        "Deploy to staging"
        "Smoke test"
        "Deploy to production"
        "Verify deployment"
        "Update documentation"
    )
    
    for task in "${tasks[@]}"; do
        create_asana_task \
            "Deploy v$version: $task" \
            "Part of deployment checklist for version $version" \
            "$(date '+%Y-%m-%d')"
    done
}
```

---

## 📎 Attachments & Images

### Get Attachments from Task
```bash
# Get list of attachments for a task
TASK_ID="1207949523587622"
curl -s \
  -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
  "https://app.asana.com/api/1.0/tasks/$TASK_ID/attachments" | jq '.data'
```

### Get Attachment Download URL
```bash
# Get download URL for specific attachment
ATTACHMENT_ID="1207752493335968"
curl -s \
  -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
  "https://app.asana.com/api/1.0/attachments/$ATTACHMENT_ID" \
  | jq '.data | {name, download_url, view_url, created_at}'
```

### Download Attachment to Local
```bash
# Download attachment to .fong/_tmp folder
download_asana_attachment() {
    local attachment_id="$1"
    local output_dir="./.fong/_tmp"
    
    # Create directory if not exists
    mkdir -p "$output_dir"
    
    # Get attachment info
    local attachment_info=$(curl -s \
        -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
        "https://app.asana.com/api/1.0/attachments/$attachment_id")
    
    local filename=$(echo "$attachment_info" | jq -r '.data.name')
    local download_url=$(echo "$attachment_info" | jq -r '.data.download_url')
    
    # Download file
    local output_path="$output_dir/asana-$attachment_id-$filename"
    curl -s -L -o "$output_path" "$download_url"
    
    echo "Downloaded: $output_path"
    return 0
}

# Usage:
# download_asana_attachment "1207752493335968"
```

### Batch Download All Attachments
```bash
# Download all attachments from a task
download_task_attachments() {
    local task_id="$1"
    local output_dir="./.fong/_tmp/asana-task-$task_id"
    
    mkdir -p "$output_dir"
    
    # Get all attachments
    local attachments=$(curl -s \
        -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
        "https://app.asana.com/api/1.0/tasks/$task_id/attachments" | jq -r '.data[].gid')
    
    # Download each attachment
    for attachment_id in $attachments; do
        echo "Downloading attachment: $attachment_id"
        
        # Get attachment details
        local attachment_info=$(curl -s \
            -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
            "https://app.asana.com/api/1.0/attachments/$attachment_id")
        
        local filename=$(echo "$attachment_info" | jq -r '.data.name')
        local download_url=$(echo "$attachment_info" | jq -r '.data.download_url')
        
        # Download to folder
        curl -s -L -o "$output_dir/$filename" "$download_url"
        echo "  → Saved: $output_dir/$filename"
    done
    
    echo "All attachments saved to: $output_dir"
}
```

### PHP Function for Attachments
```php
function fong_download_asana_attachments($task_id) {
    $token = '2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d';
    $output_dir = './.fong/_tmp/asana-task-' . $task_id;
    
    // Create directory
    if (!file_exists($output_dir)) {
        mkdir($output_dir, 0755, true);
    }
    
    // Get attachments list
    $response = wp_remote_get(
        "https://app.asana.com/api/1.0/tasks/$task_id/attachments",
        ['headers' => ['Authorization' => 'Bearer ' . $token]]
    );
    
    $attachments = json_decode(wp_remote_retrieve_body($response), true);
    $downloaded_files = [];
    
    foreach ($attachments['data'] as $attachment) {
        // Get attachment details with download URL
        $detail_response = wp_remote_get(
            "https://app.asana.com/api/1.0/attachments/{$attachment['gid']}",
            ['headers' => ['Authorization' => 'Bearer ' . $token]]
        );
        
        $details = json_decode(wp_remote_retrieve_body($detail_response), true);
        $download_url = $details['data']['download_url'];
        $filename = $details['data']['name'];
        
        // Download file
        $file_content = wp_remote_retrieve_body(wp_remote_get($download_url));
        $save_path = "$output_dir/$filename";
        
        file_put_contents($save_path, $file_content);
        $downloaded_files[] = $save_path;
    }
    
    return $downloaded_files;
}
```

### Upload Attachment to Task with Description
```bash
# Upload file as attachment to task WITH DESCRIPTION COMMENT
# ⚠️ NOTE: Asana API không support .tar.gz files - dùng .zip thay thế
# ⚠️ IMPORTANT: LUÔN thêm comment mô tả file sau khi upload
upload_attachment_with_description() {
    local task_id="$1"
    local file_path="$2"
    local file_description="$3"  # REQUIRED: Mô tả file là gì, chứa gì, dùng làm gì
    
    # Check if description provided
    if [ -z "$file_description" ]; then
        echo "❌ ERROR: File description is REQUIRED"
        echo "Usage: upload_attachment_with_description TASK_ID FILE_PATH \"Description\""
        return 1
    fi
    
    # Check if file is tar.gz and warn
    if [[ "$file_path" == *.tar.gz ]]; then
        echo "⚠️ WARNING: Asana không support .tar.gz files"
        echo "Suggest: Convert to .zip format first"
        echo "Example: tar -xzf file.tar.gz && zip -r file.zip extracted_folder/"
        return 1
    fi
    
    # Upload file
    echo "Uploading: $file_path"
    local upload_result=$(curl -s -X POST \
        -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
        -F "file=@$file_path" \
        -F "parent=$task_id" \
        "https://app.asana.com/api/1.0/attachments")
    
    local attachment_gid=$(echo "$upload_result" | jq -r '.data.gid')
    local filename=$(basename "$file_path")
    
    # Add comment describing the file
    echo "Adding description comment..."
    curl -s -X POST \
        -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
        -H "Content-Type: application/json" \
        -d "{
            \"data\": {
                \"text\": \"📎 File: $filename\\n📝 Description: $file_description\"
            }
        }" \
        "https://app.asana.com/api/1.0/tasks/$task_id/stories" > /dev/null
    
    echo "✅ Uploaded: $filename (GID: $attachment_gid)"
    echo "✅ Description added: $file_description"
}

# Usage Examples:
# upload_attachment_with_description "1211305175850729" "./report.pdf" "Monthly sales report for Q3 2024, includes revenue breakdown by region"
# upload_attachment_with_description "1211305175850729" "./backup.zip" "Complete project backup including source code, docs, and configs"
# upload_attachment_with_description "1211305175850729" "./phd-tools.sh" "Main script for searching Q1/Q2 academic papers using Perplexity API"
```

### Legacy Upload (without description - NOT RECOMMENDED)
```bash
# Old function - kept for backward compatibility
# ⚠️ DEPRECATED: Use upload_attachment_with_description instead
upload_attachment_to_task() {
    local task_id="$1"
    local file_path="$2"
    
    echo "⚠️ WARNING: This function is deprecated. Use upload_attachment_with_description"
    echo "Example: upload_attachment_with_description \"$task_id\" \"$file_path\" \"Your file description here\""
    
    # Check if file is tar.gz and warn
    if [[ "$file_path" == *.tar.gz ]]; then
        echo "❌ ERROR: Asana doesn't support .tar.gz files - use .zip instead"
        return 1
    fi
    
    curl -X POST \
        -H "Authorization: Bearer 2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d" \
        -F "file=@$file_path" \
        -F "parent=$task_id" \
        "https://app.asana.com/api/1.0/attachments"
}
```

### Read Downloaded Images with Claude/Tools
```bash
# After downloading, read image with image reader tool
read_asana_image() {
    local image_path="$1"
    
    # Option 1: Use Claude Code built-in Read tool
    echo "Image path for Claude: $image_path"
    
    # Option 2: Use fong image reader (if available)
    if [ -f "/home/fong/Projects/MCPs/fong_image_reader-core/run.sh" ]; then
        /home/fong/Projects/MCPs/fong_image_reader-core/run.sh "$image_path"
    fi
}
```

---

## ⚠️ Important Notes - Updated with Multi-Workspace Findings

1. **Multiple Workspaces**: Account có 4 workspaces - ALWAYS check all workspaces
   - Self (1159540075171841) - Main workspace
   - Irontan Vietnam (276640063815812) 
   - Deutschfuns (1211300418667644)
   - FinHUB (1211300406536801)

2. **Task Hierarchy Reality**:
   ```
   WORKSPACE
   ├── PROJECTS (optional)
   │   └── TASKS
   │       └── SUBTASKS
   └── WORKSPACE-ONLY TASKS (common pattern - tasks không thuộc project)
       └── SUBTASKS
   ```

3. **API Limitations DISCOVERED**:
   - **Search API**: tasks/search endpoint CHỈ cho premium users
   - **Alternative**: Get all tasks → filter locally với jq
   - **Free Account Compatible**: All functions in this guide work với free accounts

4. **Rate Limits:** 150 requests per minute
5. **Token Security:** Store token in environment variables for production
6. **Error Handling:** Always check HTTP status codes
7. **Workspace Context:** All operations require workspace ID - use multi-workspace functions
8. **Date Format:** Always use YYYY-MM-DD for dates
9. **Attachment URLs:** Download URLs expire after 30 minutes (1800 seconds)
10. **Default Download Path:** `./.fong/_tmp/` (relative path for reusability)
11. **Image Reading:** Use Claude Code Read tool or fong image reader from fongtoolsx.md
12. **File Upload Formats:** 
    - ✅ Supported: .zip, .pdf, .png, .jpg, .doc, .docx, .xls, .xlsx, .txt, .md, .sh, .py, .js
    - ❌ NOT Supported: .tar.gz (use .zip instead)
    - Recommendation: Luôn dùng .zip cho compressed files khi upload lên Asana

13. **Best Practice**: Use multi-workspace functions để avoid missing tasks across workspaces

---

## 📚 Quick Reference

```bash
# Environment setup
export ASANA_TOKEN="2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d"
export ASANA_WORKSPACE="1159540075171841"
export ASANA_PROJECT="1207752493335914"

# Quick commands
alias asana-today='curl -s -H "Authorization: Bearer $ASANA_TOKEN" "https://app.asana.com/api/1.0/tasks?workspace=$ASANA_WORKSPACE&assignee=me&due_on=$(date +%Y-%m-%d)" | jq .data'
alias asana-create='create_asana_task'
alias asana-complete='complete_asana_task'
```

---

**Last Updated:** 2025-09-03
**Status:** Active & Tested
**Token Valid:** Yes
