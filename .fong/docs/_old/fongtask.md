# Task Management System for Deutschfuns LMS

## Environment Variables
- `$DE_PROJECT_ROOT`: Points to `/home/fong/Projects/de/public` (DE project root directory)

## Overview
Complete task management system guiding AI through creation, execution, and alignment of development tasks with both local context files and project memory (DKM) integration.

## Standard Task Folder Structure

### Naming Convention
- Folder name: `task-name-in-kebab-case`
- Example: `debug-user-registration-proficiency-assignment`, `fix-user-login-bug`, `add-dashboard-analytics-widget`

### Required Files in Each Task Folder

#### 1. `plan.md` - Task Plan
**Purpose**: Main planning document (human-readable)
**Content**: 
- Task overview and objectives
- Implementation phases
- Step-by-step approach
- Success criteria

#### 2. `doing.md` - Working Notes (Temporary)
**Purpose**: Temporary working file for AI
**Content**: 
- Current progress notes
- Ideas and thoughts during implementation
- Quick notes and observations
- Auto-generated during work session

#### 3. Context Files (Machine-Readable JSON) - **MANDATORY**
**Purpose**: Machine-readable technical state representation
**Requirements**:
- **Machine readable**: Valid JSON format
- **Present tense only**: Reflects current state, not historical logs
- **Technical notes**: Precise technical terminology
- **Precise English**: Standard terminology, avoid ambiguous language
- **Living documents**: Updated during task execution

**Core Context Files:**

##### 3.1 `related-files.json` - File Registry
```json
{
  "task_id": "task-name-kebab-case",
  "created_date": "YYYY-MM-DD",
  "priority_files": {
    "high_priority": [
      {
        "file": "relative/path/to/file.php",
        "description": "Technical function description",
        "action": "Specific action required",
        "impact": "Expected technical impact",
        "status": "pending|in_progress|completed"
      }
    ],
    "medium_priority": [...],
    "low_priority": [...]
  },
  "backup_files": [
    {
      "backup_name": "backup-filename.sql",
      "timestamp": "ISO-8601",
      "purpose": "Technical backup purpose"
    }
  ],
  "testing_requirements": [],
  "rollback_files": []
}
```

##### 3.2 `technical-context.json` - Current Technical State
```json
{
  "task_id": "task-name-kebab-case",
  "current_state": {
    "database_status": "backed_up|modified|restored",
    "affected_systems": ["authentication", "course_assignment", "user_management"],
    "current_branch": "feature/task-name",
    "environment": "development|staging|production"
  },
  "key_findings": {
    "root_cause": "Technical description",
    "affected_components": [],
    "potential_solutions": []
  },
  "dependencies": {
    "php_files": [],
    "js_files": [],
    "database_tables": [],
    "external_apis": []
  }
}
```

##### 3.3 `workflow-state.json` - Execution State
```json
{
  "task_id": "task-name-kebab-case",
  "current_phase": "investigation|implementation|testing|completion",
  "completed_steps": [],
  "next_actions": [],
  "blockers": [],
  "tools_used": {
    "fong_php_reader": ["file1.php", "file2.php"],
    "fong_js_reader": ["file1.js"],
    "database_tools": ["dbbackupx.sh", "dbqueryx.sh"]
  },
  "time_tracking": {
    "start_time": "ISO-8601",
    "estimated_completion": "ISO-8601",
    "actual_time_spent_minutes": 120
  }
}
```

## Task Execution Workflow

### Phase 1: Pre-Task Context Loading
**MANDATORY**: Before starting any task work:

1. **Read Context Files** using `tree` command:
```bash
tree $DE_PROJECT_ROOT/.fong/docs/0-fong-todo/[task-name] -I "*.md"
```

2. **Search Related Keywords** using `rg`:
```bash
rg -i "keyword1|keyword2|keyword3" $DE_PROJECT_ROOT/.fong/docs/0-fong-todo/[task-name] --type json
```

3. **Load DKM Context** (Project Memory):
```bash
# Use fongmemory.md rules to search project memory
# Extract relevant context from .memory/ directory
```

### Phase 2: During Task Execution
**Continuous Alignment**: Throughout task execution:

1. **When Encountering Difficulties**:
   - Re-read context files for guidance
   - Search project memory (DKM) for similar solutions
   - Update `workflow-state.json` with current blockers

2. **After Each Significant Step**:
   - Update `technical-context.json` with new findings
   - Add completed actions to `workflow-state.json`
   - Sync with DKM if new knowledge discovered

3. **File Analysis Integration**:
   - For PHP files: Use `fong-php-reader.sh` before updating context
   - For JS files: Use `fong-js-reader.sh` before updating context
   - Extract technical relationships for context files

### Phase 3: Post-Task Alignment
**MANDATORY**: After task completion:

1. **Final Context Update**:
   - Update all JSON files with final state
   - Mark completed steps in `workflow-state.json`
   - Document outcomes in `technical-context.json`

2. **DKM Synchronization**:
   - Store new knowledge in project memory using fongmemory.md rules
   - Document lessons learned for future tasks
   - Update memory with technical solutions discovered

3. **Git Integration**:
```bash
# Commit context files along with code changes
$DE_PROJECT_ROOT/.fong/script-sh/fgitx.sh "git add ."
$DE_PROJECT_ROOT/.fong/script-sh/fgitx.sh "git commit -m 'Task: [task-name] - complete with context alignment and DKM sync'"
```

## Context File Management Rules

### JSON File Principles
1. **Present Tense Only**: JSON files reflect current reality, not history
2. **Technical Precision**: Use precise technical terminology
3. **Machine Readable**: Valid JSON, no comments or explanations
4. **Living Documents**: Updated as task progresses
5. **English Standard**: Consistent terminology across files

### Context Alignment Triggers
- **Before Task**: Read existing context
- **During Difficulties**: Re-read and search context
- **After Analysis**: Update with new findings
- **Task Completion**: Final alignment and DKM sync

### Integration with Project Memory (DKM)
Following `$DE_PROJECT_ROOT/.claude/commands/fongmemory.md`:

1. **Search Operations**: Query project memory for relevant solutions
2. **Storage Operations**: Store new technical knowledge in DKM
3. **Alignment Operations**: Sync task context with project memory
4. **File Analysis**: Use specialized readers for accurate metadata

## Modern CLI Tools Requirements
- **Use `tree` instead of `ls`** for directory structure
- **Use `rg` instead of `grep`** for keyword searches
- **Use `bat` instead of `cat`** for file display
- **Use `fd` instead of `find`** for file searches

## Task Folder Creation Process

### Step 1: Create Task Structure
```bash
mkdir -p "$DE_PROJECT_ROOT/.fong/docs/0-fong-todo/[task-name]"
cd "$DE_PROJECT_ROOT/.fong/docs/0-fong-todo/[task-name]"
```

### Step 2: Initialize Core Files
```bash
# Create planning document
touch plan.md
touch doing.md

# Create context files (JSON)
touch related-files.json
touch technical-context.json  
touch workflow-state.json
```

### Step 3: Populate with Templates
Use templates provided above for each JSON file, ensuring:
- Valid JSON syntax
- Present tense descriptions
- Technical precision
- Machine readability

## Git Workflow Integration

### MANDATORY: After Task Setup Complete
1. **Commit Task Setup**:
```bash
$DE_PROJECT_ROOT/.fong/script-sh/fgitx.sh "git add ."
$DE_PROJECT_ROOT/.fong/script-sh/fgitx.sh "git commit -m 'Setup task: [task-name] - create context framework with DKM alignment'"
```

2. **Push Setup**:
```bash
$DE_PROJECT_ROOT/.fong/script-sh/fgitx.sh "git push origin [current-branch]"
```

3. **Create Feature Branch**:
```bash
$DE_PROJECT_ROOT/.fong/script-sh/fgitx.sh "git checkout -b feature/[task-name]"
```

## Integration with Development Ecosystem

### File Analysis Integration
- **PHP Files**: Automatic analysis with `fong-php-reader.sh`
- **JS Files**: Automatic analysis with `fong-js-reader.sh`  
- **Context Updates**: Technical metadata extracted and stored

### Memory Management Integration
- **Search**: Query DKM for relevant knowledge
- **Store**: Save new solutions and patterns
- **Align**: Maintain consistency between task context and project memory

### Quality Assurance
- JSON validation before commits
- Context file consistency checks
- DKM synchronization verification

This system ensures comprehensive task management with technical precision, machine readability, and seamless integration with project memory and development tools.