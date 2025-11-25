# FWorkspace Init - Khởi tạo Context Workspace

## Mục đích
Khởi tạo workspace có cấu trúc chuẩn cho các task phát triển, với context machine-readable và plan template.

## Cấu trúc Workspace Chuẩn

### Thư mục gốc
```
/home/fong/Projects/de/public/.fong/docs/0-fong-todo/{task-name-timestamp}/
```

### Files bắt buộc

#### 1. main-context.json (Entry Point)
```json
{
  "workspace_id": "task-name-timestamp",
  "task_name": "Mô tả ngắn gọn task",
  "created_at": "2025-01-08T16:15:00+07:00",
  "updated_at": "2025-01-08T16:15:00+07:00", 
  "status": "in_progress|pending|completed",
  "priority": "high|medium|low",
  
  "problem_statement": {
    "description": "Mô tả vấn đề cần giải quyết",
    "affected_component": "Component bị ảnh hưởng",
    "current_behavior": "Hành vi hiện tại",
    "expected_behavior": "Hành vi mong muốn"
  },
  
  "phases": {
    "phase_1": {"name": "Investigation", "status": "pending", "tasks": []},
    "phase_2": {"name": "Analysis", "status": "pending", "tasks": []},
    "phase_3": {"name": "Implementation", "status": "pending", "tasks": []},
    "phase_4": {"name": "Deployment", "status": "pending", "tasks": []}
  },
  
  "success_criteria": [],
  "related_files": [],
  "context": {
    "project": "Deutschfuns LMS",
    "component": "Component name",
    "technology": "Tech stack",
    "git_branch": "current branch"
  }
}
```

#### 2. machine-{phase}.json Files
Mỗi phase có 1 file riêng:
- `machine-investigation.json` - Phase 1 metadata
- `machine-analysis.json` - Phase 2 metadata  
- `machine-implementation.json` - Phase 3 metadata
- `machine-deployment.json` - Phase 4 metadata (tùy chọn)

**Cấu trúc machine file**:
```json
{
  "phase_name": "phase_name",
  "phase_status": "pending|in_progress|completed",
  "created_at": "timestamp",
  "updated_at": "timestamp",
  
  "objectives": [],
  "findings": {},
  "tools_used": [],
  "next_actions": [],
  
  "dependencies": {
    "required_from_previous": [],
    "blocks_next_phase": true|false
  },
  
  "metadata": {
    "parent_workspace": "workspace_id",
    "linked_phases": [],
    "estimated_completion": "pending|date"
  }
}
```

#### 3. plan-{timestamp}.md
Plan file với timestamp format `YYYYMMDD-HHMM`:
```markdown
# Task Name - Implementation Plan
**Created**: 2025-01-08 16:15
**Updated**: 2025-01-08 16:15  
**Status**: Ready to execute

## 🎯 Objective
Mô tả mục tiêu chính

## 📋 Current Status
- [x] Setup hoàn thành
- [ ] Phase tiếp theo

## 🔄 Execution Phases
### Phase 1: Name (Status)
**Goal**: Mục tiêu phase
**Tasks**: 
- [ ] Task 1
- [ ] Task 2

## ⚡ Next Action
Action tiếp theo cần thực hiện

## 📊 Progress Tracking
- Overall: X%
- Phase 1: Y%

---
*Auto-updated by workspace management system*
```

## Quy trình Khởi tạo

### Bước 1: Tạo TodoWrite cho workspace init
```json
[
  {
    "id": "init-workspace-structure", 
    "content": "Khởi tạo cấu trúc workspace chuẩn với main-context.json",
    "status": "in_progress", 
    "priority": "high"
  },
  {
    "id": "create-machine-files",
    "content": "Tạo các file machine*.json để lưu metadata task", 
    "status": "pending",
    "priority": "high"
  },
  {
    "id": "setup-plan-template",
    "content": "Tạo plan template với timestamp format",
    "status": "pending", 
    "priority": "medium"
  }
]
```

### Bước 2: Tạo main-context.json
- Entry point cho toàn bộ workspace
- Chứa overview task và links đến các files khác
- Update liên tục theo tiến độ

### Bước 3: Tạo machine-*.json files
- 1 file cho mỗi phase của task
- Chứa metadata chi tiết, findings, tools used
- Structured data cho automation

### Bước 4: Tạo plan với timestamp
- Format: `plan-YYYYMMDD-HHMM.md`
- Human-readable plan với progress tracking
- Update on-the-fly khi làm

## Best Practices

### Naming Convention
- Workspace folder: `{task-name}-{YYYYMMDD-HHMM}`
- Plan files: `plan-{YYYYMMDD-HHMM}.md`
- Machine files: `machine-{phase-name}.json`

### Update Strategy
- Main context: Update sau mỗi phase completion
- Machine files: Update realtime khi có findings
- Plan files: Update khi có major changes

### Dependencies Management  
- Phases có dependencies rõ ràng
- Không thể skip phase mà không hoàn thành dependencies
- Machine files track dependency status

## Tools Integration

### TodoWrite Integration
- Workspace init tạo todos cho setup process
- Mark completed khi hoàn thành từng bước
- Track progress throughout task execution

### Git Integration
- Backup strategy trước khi modify files
- Commit workspace setup as first step
- Track changes trong machine files

### File Readers Integration
- Use specialized readers cho PHP/JS analysis
- Store findings trong machine files
- Link file paths trong main context

## Example Usage

```bash
# Tạo workspace mới
mkdir -p "/home/fong/Projects/de/public/.fong/docs/0-fong-todo/fix-user-level-display-20250108-1615/"

# Chạy fworkspace-init với context
# - Task name: Fix User Level Display  
# - Problem: Hardcode A1 cần thay bằng dynamic value
# - Components: User profile, database integration
```

## Lưu ý Quan trọng

1. **Main Context là Entry Point**: Luôn bắt đầu từ main-context.json
2. **Machine Files Auto-Update**: Update findings realtime khi thực hiện phases
3. **Plan Files Human-Readable**: Để tracking progress và communication
4. **Dependencies Strict**: Không thể skip phases, phải complete dependencies
5. **Backup Strategy**: Luôn backup trước khi modify code
6. **Git Integration**: Track workspace changes trong git history

---
*Documented: 2025-01-08 16:30*  
*Version: 1.0*