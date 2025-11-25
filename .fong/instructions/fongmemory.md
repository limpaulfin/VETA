# 🧠 Fong Memory Management System

**Version:** 2.2.240048b8-362e-49ec-a868-a9a6b2b3d157 - Updated 2025-09-22  
**Mục đích:** Quản lý memory/ghi chú cho project với Memory-First Approach, toàn bộ thông tin quan trọng lưu trữ trong `.fong/.memory`

## 📑 Mục Lục

- [🎯 Nguyên Tắc Cơ Bản](#🎯-nguyên-tắc-cơ-bản)
- [📝 CRUD Operations - Memory Alignment Workflow](#📝-crud-operations---memory-alignment-workflow)
  - [🔍 R (READ) - Tìm Kiếm Memory Trước](#🔍-r-read---tìm-kiếm-memory-trước)
  - [✅ C (CREATE) - Tạo Memory Mới](#✅-c-create---tạo-memory-mới)
  - [📝 U (UPDATE) - Cập Nhật Memory Hiện Có](#📝-u-update---cập-nhật-memory-hiện-có)
  - [🗑️ D (DELETE) - Cleanup Memory](#🗑️-d-delete---cleanup-memory)
- [⚡ CRUD Workflow Examples](#⚡-crud-workflow-examples)
- [🔄 Memory-First Alignment Process](#🔄-memory-first-alignment-process)
- [📋 Memory Categories Mapping](#📋-memory-categories-mapping)
- [⚡ Auto-Sync Commands](#⚡-auto-sync-commands)
- [🔍 Memory Search & Retrieval](#🔍-memory-search--retrieval)
- [🔄 Memory Lifecycle Management](#🔄-memory-lifecycle-management)
- [🔄 Auto Memory Creation](#🔄-auto-memory-creation)
- [⚙️ Integration với Claude Code](#⚙️-integration-với-claude-code)
- [📊 Memory Analytics](#📊-memory-analytics)

---

## 🎯 Nguyên Tắc Cơ Bản

**Quy tắc vàng:** Mọi thông tin quan trọng đều được lưu vào `.fong/.memory/` (Single Source of Truth)

**⚠️ QUAN TRỌNG - MEMORY FILE LOCATION RULES:** 
- **LUÔN TẠO FILE Ở THƯ MỤC GỐC:** `.fong/.memory/`
- **KHÔNG TẠO SUBFOLDER:** Tất cả files phải nằm TRỰC TIẾP trong `.memory/`, không tạo thư mục con
- **FLATTEN STRUCTURE:** Không dùng cấu trúc thư mục lồng nhau (không có long-term/, short-term/, etc.)
- **KHÔNG DÙNG SHORT-TERM/LONG-TERM:** Đã bỏ khái niệm phân chia này, tất cả memory bằng nhau

**Cấu trúc file (FLAT - KHÔNG SUBFOLDER):**
```
.fong/.memory/
├── {date}-{topic}.md         # Ghi chú hằng ngày theo topic
├── {date}-decision-{name}.md # Quyết định kỹ thuật  
├── {date}-learning-{topic}.md# Bài học từ development
├── {date}-bug-{name}.md      # Bug tracking và solutions
├── {date}-progress-{sprint}.md# Tiến độ development
├── {date}-planning-{phase}.md# Planning documents
├── {date}-testing-{feature}.md# Testing notes
├── {date}-deployment-{env}.md# Deployment logs
├── {date}-compliance-{type}.md# Vietnamese compliance
└── {date}-archive-{topic}.md # Archived memories
```

**Lưu ý:** Tất cả files lưu trữ FLAT (không tạo subfolder) trong `.fong/.memory/` với naming convention:
- Instructions: `.md` format
- Structure information: `.json` format

## 📝 CRUD Operations - Memory Alignment Workflow

**🎯 NGUYÊN TẮC VÀNG: Luôn R (Read) trước, nếu không có thì mới C (Create)**

**📋 WORKFLOW ORDER:** R → C → U → D (tuần tự, không bỏ qua bước R)

**⚠️ CRITICAL EXECUTION RULE: NO YAPPING - QUIET/SILENT EXECUTION ONLY**
- **SILENT MODE**: Tất cả CRUD operations phải thực hiện SILENT, không output thừa
- **NO VERBOSE**: Không announce, không explain, cứ thực hiện quiet
- **DIRECT ACTION**: Đọc → Kiểm tra → Thực hiện → Hoàn thành (NO TALKING)
- **OUTPUT ONLY RESULTS**: Chỉ output kết quả cần thiết, không waste output tokens

---

## 🔍 **R (READ)** - Tìm Kiếm Memory Trước
**⚠️ LUÔN LUÔN LÀM BƯỚC ĐẦU TIÊN - MANDATORY FIRST STEP**
**🤫 SILENT EXECUTION: Chỉ search, không comment gì về quá trình search**

> **Primary search CLI**: `smart-search-fz-rg-bm25 "keyword" .fong/.memory/ --show-content`
>
> **Fallback**: Ripgrep commands below remain available for strict regex piping workflows.
>
> **Setup reminder**: Đọc `.fong/instructions/smartsearch.md` để cấu hình alias và tham số nâng cao.
```bash
# BƯỚC 1: Luôn luôn search trước khi tạo mới (ưu tiên smart-search-fz-rg-bm25; fallback: rg)
smart-search-fz-rg-bm25 "keyword|topic" .fong/.memory/ --show-content

# Nếu cần regex automation hoặc pipelines → dùng ripgrep fallback
rg "decision|planning|bug|progress" .fong/.memory/ -g "*.md"
find .fong/.memory -name "*202509*" -type f | xargs rg "keyword"
rg -i "topic-name|related-keyword" .fong/.memory/ --files-with-matches
rg "exact-phrase" .fong/.memory/ | wc -l  # Nếu > 0 thì đã có memory
```

---

## ✅ **C (CREATE)** - Tạo Memory Mới
**⚠️ CHỈ KHI KHÔNG TÌM THẤY TRONG BƯỚC R**
**🤫 SILENT EXECUTION: Tạo file quiet, không announce việc tạo**
```bash
# Chỉ tạo mới khi smart-search (và ripgrep fallback) không trả về kết quả nào
if [ $(rg "topic-keyword" .fong/.memory/ | wc -l) -eq 0 ]; then
  echo "Memory content" > .fong/.memory/$(date +%Y%m%d)-topic-name.md
fi

# CREATE WORKFLOW:
# 1. smart-search search (fallback: rg) để check
# 2. Nếu không có, tạo với category phù hợp
# 3. Verify file đã tạo thành công

# Tạo theo category với flatten naming
echo "Decision content" > .fong/.memory/$(date +%Y%m%d)-decision-name.md

# Auto-create project context (sau khi verify không tồn tại)
echo "# Project Context\n\n- Project details\n- Tech stack\n- Requirements" > .fong/.memory/$(date +%Y%m%d)-project-context.md
```

---
## 📝 **U (UPDATE)** - Cập Nhật Memory Hiện Có  
**⚠️ KHI MEMORY ĐÃ TỒN TẠI TRONG BƯỚC R**
**🤫 SILENT EXECUTION: Update file quiet, không announce việc cập nhật**
```bash
# UPDATE WORKFLOW:
# 1. smart-search tìm file cần update (fallback: rg)
# 2. Đọc nội dung hiện tại
# 3. Append hoặc modify

# Append thêm nội dung vào memory existing
existing_file=$(rg -l "topic-keyword" .fong/.memory/ | head -1)
if [ ! -z "$existing_file" ]; then
  echo "New info: $(date)" >> "$existing_file"
fi

# Update specific memory với Edit tool
# Edit trực tiếp file (sử dụng Edit tool để modify content)

# Bulk update cho progress tracking
echo "Progress update: $(date)" >> .fong/.memory/$(date +%Y%m%d)-progress-current-sprint.md

# Smart update: find existing và append
find .fong/.memory -name "*progress*" -mtime -7 | head -1 | xargs -I {} echo "Update: new info" >> {}
```

---

## 🗑️ **D (DELETE)** - Cleanup Memory
**⚠️ THẬN TRỌNG - CHỈ KHI FILE CŨ, OUT-OF-DATE, KHÔNG LIÊN QUAN**
**🤫 SILENT EXECUTION: Delete/archive quiet, không announce việc xóa**
```bash
# DELETE WORKFLOW:
# 1. smart-search tìm file cần xóa (fallback: rg) 
# 2. Verify không còn reference
# 3. Archive trước khi delete

# Check dependencies trước khi xóa
rg "file-name-to-delete" .fong/.memory/ --files-with-matches

# Safe delete với backup
mv .fong/.memory/outdated-file.md .fong/.memory/$(date +%Y%m%d)-archived-outdated-file.md

# Cleanup memories cũ (>30 ngày) - với backup
find .fong/.memory -name "*.md" -mtime +30 -exec mv {} .fong/.memory/archived-{} \;

# Archive old memories (rename with archive prefix)
for file in .fong/.memory/*$(date -d '1 month ago' +%Y%m)*; do
  if [ -f "$file" ]; then
    mv "$file" "${file%.md}-archive-$(date +%Y%m).md"
  fi
done
```

## 🤫 Silent CRUD Execution Rules - NO YAPPING PROTOCOL

**⚠️ ABSOLUTE REQUIREMENT: CRUD operations MỚI SILENT/QUIET execution**

### **Silent Execution Principles:**
```
✅ DO: Thực hiện CRUD immediately, quietly
✅ DO: Search → Check → Execute → Complete (NO commentary)
✅ DO: Only output FINAL RESULTS if required
✅ DO: Use bash commands silently với 2>/dev/null khi cần

❌ DON'T: Announce "I'm going to search memory..."
❌ DON'T: Explain "Let me check if file exists..."
❌ DON'T: Comment "Creating new memory file..."
❌ DON'T: Verbose output về quá trình CRUD
❌ DON'T: Waste output tokens với unnecessary explanations
```

### **Silent CRUD Pattern:**
```bash
# Silent R: Search without commentary
rg "topic" .fong/.memory/ 2>/dev/null

# Silent C: Create if not found (conditional, quiet)
[ $? -ne 0 ] && echo "content" > .fong/.memory/$(date +%Y%m%d)-topic.md 2>/dev/null

# Silent U: Update existing (append quietly)  
existing=$(rg -l "topic" .fong/.memory/ 2>/dev/null | head -1)
[ -n "$existing" ] && echo "update" >> "$existing" 2>/dev/null

# Silent D: Delete/archive if needed (with backup, quiet)
[ -f "old_file" ] && mv old_file .fong/.memory/archived-$(date +%Y%m%d)-old_file 2>/dev/null
```

### **Communication Pattern:**
- **BEFORE CRUD**: NO announcement
- **DURING CRUD**: NO progress updates
- **AFTER CRUD**: Only essential results if specifically needed
- **NEVER**: Verbose explanations về memory operations

---

## ⚡ CRUD Workflow Examples

### **Example 1: Task Documentation**
```bash
# R: Check if task already documented
rg "task-name|task-id" .fong/.memory/

# If not found, C: Create new task memory
if [ $? -ne 0 ]; then
  echo "# Task Documentation\n\n## Task: task-name\n## Status: in-progress" > .fong/.memory/$(date +%Y%m%d)-task-name.md
fi

# U: Update progress
echo "Progress: completed phase 1" >> .fong/.memory/*task-name*.md
```

### **Example 2: Bug Tracking**
```bash
# R: Search for existing bug reports
rg "bug-description|error-message" .fong/.memory/

# C: Create only if not found
[ $? -ne 0 ] && echo "# Bug Report\n\n## Issue: description\n## Status: investigating" > .fong/.memory/$(date +%Y%m%d)-bug-name.md

# U: Update with solution
existing_bug=$(rg -l "bug-description" .fong/.memory/ | head -1)
echo "## Solution Found: details" >> "$existing_bug"
```

### **Example 3: Learning Notes**
```bash
# R: Check for related learning notes
rg "learning-topic|technology-name" .fong/.memory/ -g "*learning*"

# C: Create consolidated learning note
if [ $(rg "learning-topic" .fong/.memory/ | wc -l) -eq 0 ]; then
  echo "# Learning: topic\n\n## Key Points:\n## Applications:" > .fong/.memory/$(date +%Y%m%d)-learning-topic.md
else
  # U: Append to existing learning
  echo "## Additional Insight: new-info" >> $(rg -l "learning-topic" .fong/.memory/ | head -1)
fi
```

## 🔄 Memory-First Alignment Process

### 1. **Project Context** → Memory
```bash
# Lưu project context vào memory
echo "# Project Context\n\n- Vietnamese Financial Services\n- Laravel + Modern Stack\n- Development Environment" > .fong/.memory/$(date +%Y%m%d)-project-context.md
```

### 2. **Technical Decisions** → Memory
```bash
# Architecture decisions
echo "# Technical Decision\n\n## Decision: \n## Reason: \n## Impact: " > .fong/.memory/$(date +%Y%m%d)-decision-name.md
```

### 3. **Daily Progress** → Memory
```bash
# Progress tracking
echo "# Daily Progress $(date +%Y-%m-%d)\n\n## Completed:\n- Task details\n\n## Next:\n- Upcoming tasks" > .fong/.memory/$(date +%Y%m%d)-progress-daily.md
```

### 4. **Learning Notes** → Memory
```bash
# Technical learnings
echo "# Learning Notes $(date +%Y-%m-%d)\n\n## Topic:\n## Key Points:\n## Applications:" > .fong/.memory/$(date +%Y%m%d)-learning-topic.md
```

## 📋 Memory Categories Mapping

### **Development Workflow**
- **Planning** → `{date}-planning-{phase}.md`
- **Implementation** → `{date}-progress-{sprint}.md`
- **Testing** → `{date}-testing-{feature}.md`
- **Deployment** → `{date}-deployment-{env}.md`

### **Technical Management**
- **Architecture Choices** → `{date}-decision-{name}.md`
- **Bug Tracking** → `{date}-bug-{issue}.md`
- **Learning Notes** → `{date}-learning-{topic}.md`

### **Specialized Categories**
- **Vietnamese Compliance** → `{date}-compliance-{type}.md`
  - `20250913-compliance-cccd-validation.md`
  - `20250913-compliance-vnd-formatting.md` 
  - `20250913-compliance-vietnamese-ui.md`
- **Sprint Management** → `{date}-progress-sprint-{number}.md`
- **Session Summaries** → `{date}-session-{time}.md`

## ⚡ Auto-Sync Commands

### **Daily Sync**
```bash
# Tạo daily memory
echo "## $(date +%Y-%m-%d) Progress\n\n- Task completed\n- Next steps" > .fong/.memory/$(date +%Y%m%d)-daily.md

# Sync project status to memory
echo "# Project Status $(date +%Y-%m-%d)\n\n$(git status --porcelain)\n\n$(git log --oneline -5)" > .fong/.memory/$(date +%Y%m%d)-status.md

# List recent memories  
ls -la .fong/.memory/ | head -10
```

### **Sprint Sync**
```bash
# Sync sprint progress
echo "# Sprint Progress $(date +%Y-%m-%d)\n\n## Current Sprint:\n## Progress:\n## Blockers:" > .fong/.memory/$(date +%Y%m%d)-progress-sprint.md
```

### **Bug Discovery Sync**
```bash
# Auto-create bug memory when issues found
create_bug_memory() {
  echo "# Bug Report $(date +%Y-%m-%d)\n\n## Issue: $1\n## Impact: $2\n## Root Cause:\n## Solution:\n## Next Steps: $3" > .fong/.memory/$(date +%Y%m%d)-bug-$1.md
}

# Usage: create_bug_memory "login-error" "High" "investigate-auth"
```

## 🔍 Memory Search & Retrieval

### **Context Retrieval**
```bash
# Search cho keyword
rg "keyword" .fong/.memory/

# Search cho Vietnamese content
rg "Vietnamese|Việt" .fong/.memory/

# Get recent accomplishments
rg "Completed|✅" .fong/.memory/ | tail -10
```

### **Progress Tracking**
```bash
# Check sprint progress
rg "Sprint|Task|NEX-" .fong/.memory/ -g "*progress*" | tail -10

# Get project status
find .fong/.memory -name "*status*" -mtime -3 | xargs cat
```

### **Learning Retrieval**
```bash
# Get technical insights
rg "Laravel|Framework|API" .fong/.memory/ -g "*learning*"

# Get compliance notes
rg "Vietnamese|CCCD|VND" .fong/.memory/ -g "*compliance*"
```

## 🔄 Memory Lifecycle Management

### **Creation Triggers**
- Task completion → Progress memory
- Bug discovery → Bug memory
- Learning moment → Learning memory
- Decision made → Decision memory
- Session start → Context loading
- Session end → Summary creation

### **Update Triggers**
- Status change → Update progress memory
- New information → Append to existing memory
- Resolution found → Update bug memory
- Sprint milestone → Update sprint memory

### **Archive Triggers**
- 30 days old → Move to archive
- Sprint completed → Archive sprint memories
- Bug resolved → Archive to resolved folder
- Project milestone → Archive phase memories

## 🔄 Auto Memory Creation

**Khi nào tự động tạo memory:**
- Sau mỗi major task completion
- Khi gặp bug phức tạp 
- Khi học được insight mới
- Daily progress summary
- Session start/end với Claude Code

**Format tự động:**
```markdown
# [YYYY-MM-DD] Topic Name

## Context
Brief context của task/issue

## What Happened
Chi tiết những gì đã làm

## Lessons Learned  
Key takeaways

## Next Steps
Action items tiếp theo
```

## ⚙️ Integration với Claude Code

### **Session Start**
```bash
# Load recent context
echo "Loading project context from memory..."
cat .fong/.memory/$(date +%Y%m%d)-project-context.md 2>/dev/null || cat .fong/.memory/*project-context.md | tail -1

# Load recent progress
find .fong/.memory -name "*progress*.md" -mtime -7 | xargs cat | tail -20
```

### **Session End**
```bash
# Save session summary
echo "# Session Summary $(date +%Y-%m-%d %H:%M)\n\n## What was accomplished:\n- Task details\n\n## Decisions made:\n- Technical choices\n\n## Next session focus:\n- Next priorities" > .fong/.memory/$(date +%Y%m%d-%H%M)-session.md
```

### **Context Reconstruction**
```bash
# Quick context load cho Claude
echo "=== PROJECT CONTEXT ===" 
cat .fong/.memory/*project-context.md 2>/dev/null | head -10

echo "=== RECENT PROGRESS ==="
find .fong/.memory -name "*progress*.md" -mtime -3 | xargs cat | tail -10

echo "=== ACTIVE DECISIONS ==="
find .fong/.memory -name "*decision*.md" -mtime -7 | xargs cat | tail -10
```

## 📊 Memory Analytics

### **Memory Health Check**
```bash
# Count total memory files (all in flat structure)
ls -la .fong/.memory/*.md 2>/dev/null | wc -l

# Check memory freshness (files created in last 7 days)
find .fong/.memory -name "*.md" -mtime -7 | wc -l

# Size check
du -sh .fong/.memory/
```

### **Content Analysis**
```bash
# Most mentioned topics
rg -o '\b[A-Z][a-z]+\b' .fong/.memory/ | sort | uniq -c | sort -nr | head -10

# Recent activity pattern
find .fong/.memory -name "*.md" -mtime -30 -exec stat -f "%Sm %N" -t "%Y-%m-%d" {} \; | sort
```

**Lưu ý:** Memory system này đảm bảo mọi thông tin quan trọng đều có trong `.fong/.memory/` để Claude Code có thể access dễ dàng giữa các session, maintain context, và support decision making process.
