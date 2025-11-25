---
description: "Context initialization command for Deutschfuns LMS - rebuilds AI context from rules, memory, and project state"
argument-hint: "[context request or question]"
version: "2025-08-12T10:00:00Z"
---

# ⚠️ PHẢI LÀM THEO ĐÚNG CHỈ THỊ TRONG FILE fonginit.md
**YÊU CẦU BẮT BUỘC - KHÔNG ĐƯỢC BỎ XÓT**

> Tất cả các bước trong file này phải được thực hiện đầy đủ và chính xác theo đúng quy trình được mô tả.  
> Không được skip hoặc modify bất kỳ bước nào mà không có sự cho phép rõ ràng.  
> Đây là yêu cầu vận hành cắt cốt - vi phạm sẽ ảnh hưởng đến chất lượng kết quả.

# Deutschfuns LMS Context Initialization Command

## Purpose | Mục đích

Giải quyết vấn đề "stateless AI" bằng cách tự động khởi tạo ngữ cảnh toàn diện từ:
- Project rules (.mdc files)  
- Memory system (.memory/)
- Current system state
- User intent analysis

## Core Problem | Vấn đề cốt lõi

> **AI như người có trí nhớ kém**: Mỗi lần gọi là "mới tinh" hoàn toàn, không biết:
> - Mình là ai?
> - Dự án này làm gì? 
> - User đang hỏi gì?
> - Cần tìm kiếm thông tin gì để hiểu?

## Automatic Context Reconstruction | Tái tạo ngữ cảnh tự động

### 1. **5W1H Intent Analysis**
Phân tích prompt của user theo framework 5W1H:
- **What**: User đang hỏi/yêu cầu gì?
- **Where**: Phần nào của hệ thống?  
- **When**: Thời gian/độ ưu tiên?
- **Why**: Mục đích thực sự là gì?
- **Who**: Đối tượng target?
- **How**: Phương pháp cần thiết?

### 2. **Rules Auto-Discovery**
```bash
# Scan tất cả rules có sẵn
tree /home/fong/Projects/de/public/.cursor/rules/ -P "*.mdc"

# Đọc manifest để hiểu overview
cat /home/fong/Projects/de/public/.cursor/rules/manifest.json

# Extract 3-9 keywords từ user prompt (Vietnamese-English)
# Search rules liên quan với ripgrep
rg -i "keyword1|keyword2|keyword3" /home/fong/Projects/de/public/.cursor/rules/ --type mdc

# Smart reading của rule files được tìm thấy
wc -l rule_file.mdc
# Nếu < 200 LOC: cat rule_file.mdc | tr -d '[:space:]'
# Nếu >= 200 LOC: sed -n '1,200p' rule_file.mdc (tiếp tục với sections khác)
```

### 3. **Memory System Integration**
```bash
# Kiểm tra memory structure
tree /home/fong/Projects/de/public/.memory/

# Search memory với multiple keyword strategies:
# Strategy 1: Direct keywords từ prompt
# Strategy 2: Semantic keywords và synonyms  
# Strategy 3: Domain-specific technical terms
# Sử dụng MCP tool: DeutschfunsMemorySearch với different keyword sets

# Search thêm supplementary sources:
smart-search-fz-rg-bm25 "relevant keywords" /home/fong/Projects/de/public/CHANGELOGS/ --show-content
smart-search-fz-rg-bm25 "relevant keywords" /home/fong/Projects/de/public/.fong/ --show-content
rg "relevant_keywords" /home/fong/Projects/de/public/CHANGELOGS/ --type md  # fallback
rg "relevant_keywords" /home/fong/Projects/de/public/.fong/ --type md       # fallback
```

### 3.1. **Task Context Alignment (Mandatory when task context detected)**
```bash
# AUTO-DETECT: Scan user prompt for task context mentions
# Patterns: "/home/fong/Projects/de/public/.fong/docs/0-fong-todo/[task-name]/*"
# Keywords: "task context", "context window", "align với context"

# MANDATORY SEQUENCE when task context detected:

# Step 1: Read task directory structure
tree "/home/fong/Projects/de/public/.fong/docs/0-fong-todo/[task-name]" -I "*.md"

# Step 2: Load task context files (JSON only - machine readable)
# Read: related-files.json (file registry với priorities và actions)
# Read: technical-context.json (current technical state và findings)
# Read: workflow-state.json (execution progress và tool usage)

# Step 3: Cross-reference với project memory (bidirectional alignment)
# Search .memory/ directory cho patterns discovered trong task context
# Query DKM for relevant solutions và technical knowledge
# Extract established patterns and solutions for current work

# Step 4: Context-Memory CRUD synchronization
# UPDATE task context files với insights from project memory
# CREATE new memory entries from unique task findings
# DELETE outdated task context entries
# ALIGN technical metadata between both systems

# Step 5: File analysis integration (when task involves code files)
# For PHP files: Use /home/fong/Projects/de/public/.fong/tools/fong-php-reader.sh
# For JS files: Use /home/fong/Projects/de/public/.fong/tools/fong-js-reader.sh
# Update both task context và memory với technical relationships
```

### 4. **Current System State Assessment**
```bash
# Git status và branch hiện tại (using /fonggit protocols)
/home/fong/Projects/de/public/.fong/script-sh/fgitx.sh "git status"
/home/fong/Projects/de/public/.fong/script-sh/fgitx.sh "git branch --show-current"
/home/fong/Projects/de/public/.fong/script-sh/fgitx.sh "git log --oneline -5"

# System health check using Database Query Tool (from /fongtoolsx)
/home/fong/Projects/de/public/.fong/tools/dbqueryx.sh "SELECT COUNT(*) as system_status FROM wp_users LIMIT 1"
```

### 5. **Context Synthesis & Presentation**

Sau khi gather information, trình bày:

```
🔄 **DEUTSCHFUNS LMS CONTEXT INITIALIZED**

📍 **Current State**: 
  - Branch: [current_branch]
  - Recent: [last_5_commits_summary]  
  - System: [health_status]

📋 **Rules Applied**: [list_of_mdc_files_read]
🧠 **Memory Context**: [relevant_knowledge_found]
🎯 **User Intent**: [5W1H_analysis_result]

✅ **Ready for**: [specific_action_plan]
🛠️ **Recommended Tools**: [most_relevant_tools]
```

## Implementation Logic | Logic triển khai

### **Context Gathering Triggers:**
- "ngữ cảnh", "context", "hiểu", "understand", "setup", "init"
- "mình là ai", "who am I", "current state", "trạng thái"  
- "project", "dự án", "system", "hệ thống"
- "tìm hiểu", "research", "investigate"

### **Task Context Alignment Triggers:**
- File path patterns: `/home/fong/Projects/de/public/.fong/docs/0-fong-todo/[task-name]/*`
- Keywords: "task context", "context window", "align với context"
- Task directory mentions: Any reference to `.fong/docs/0-fong-todo/`
- Context file references: "related-files.json", "technical-context.json", "workflow-state.json"
- CRUD alignment requests: "align dkm", "sync context", "update context"

### **Automatic Workflow:**
1. **Intent Analysis**: Phân tích thực sự user muốn gì
2. **Task Context Detection**: Check for task directory patterns và alignment triggers
3. **Rules Discovery**: Tìm 3-5 rules liên quan nhất
4. **Memory Search**: Execute 3+ searches với different strategies
5. **Task Context Alignment**: Load và sync context files với memory (if applicable)
6. **State Assessment**: Check git, system, recent changes
7. **Tool Identification**: Identify tools cần thiết cho task
8. **Context Summary**: Present synthesized understanding

## Integration với Existing Commands | Tích hợp với lệnh có sẵn

### **Available Commands Reference:**
- **`/fongtoolsx`** - Tool catalog và usage examples (12 available tools)
- **`/fmemory`** - Memory management operations (search/alignment/storage)
- **`/fonggit`** - Git operations với fgitx.sh script (double-check protocols)
- **`/fworkspace-init`** - Workspace initialization và setup
- **`/fongtask`** - Task management và planning
- **`/fprompt`** - Prompt engineering assistance
- **`/ftools`** - Basic tools reference
- **`/fmachine`** - Machine learning operations
- **`/jscleanup`** - JavaScript code cleanup standards  
- **`/phpcleanup`** - PHP code cleanup standards

### **Memory Management Integration:**
- Uses `/fmemory` patterns cho memory operations
- Search `.memory/`, `CHANGELOGS/`, `.fong/` directories
- English keywords priority, Vietnamese fallback
- Automatic memory alignment với current codebase state
- **Task Context Integration**: Follows `/fongtask` protocols cho context files
- **Alignment Rules**: Implements `instructions-align-memory.md` protocols

### **Tool Selection Integration:**
- Leverage `/fongtoolsx` catalog cho comprehensive tool recommendations
- 12 specialized tools: PHP/JS readers, DB tools, log analyzers, etc.
- Smart tool selection based on user intent và context
- Use specialized readers khi cần (fong-php-reader.sh, fong-js-reader.sh)

### **Git Operations Integration:**
- Integrate với `/fonggit` protocols cho safe git operations
- Uses fgitx.sh script với mandatory double-check procedures
- Branch switching verification (before/after checks)
- Commit/push reporting với detailed information extraction

### **Rule Compliance:**
- Follow tất cả core principles từ rule-mottos.mdc
- Implement "Think Big, Do Baby Steps" approach
- "Always Double-Check" với verification steps từ `/fonggit`
- "Measure Twice, Cut Once" cho any system changes

## Usage Examples | Ví dụ sử dụng

### **Basic Context Initialization:**
```
/fonginit em cần hiểu dự án này để debug authentication issues
```

### **Project State Recovery:**
```  
/fonginit what is the current state and what should I know about recent changes?
```

### **Domain-Specific Context:**
```
/fonginit em cần ngữ cảnh về database schema và user roles system
```

### **Problem-Solving Context:**
```
/fonginit user không thể access course content, em cần context để debug
```

## Expected Output Format | Format đầu ra mong đợi

### **Comprehensive Context Report:**

1. **Project Identity**: Deutschfuns LMS - German Learning Platform
2. **Current State**: Branch, commits, system status, active features
3. **Applied Rules**: List of .mdc files read với key guidance points
4. **Memory Context**: Relevant information từ project memory system
5. **User Intent Analysis**: Clear understanding của user's actual needs
6. **Action Plan**: Specific next steps based on gathered context
7. **Tool Readiness**: Most relevant tools identified và ready
8. **Knowledge Gaps**: Areas where more info might be needed

### **Success Metrics:**
- ✅ Rules found và applied (≥3 relevant .mdc files)
- ✅ Memory context retrieved (≥2 relevant memory files)  
- ✅ System state assessed (git + health check)
- ✅ User intent clarified (5W1H analysis complete)
- ✅ Tools identified (specific recommendations)
- ✅ Action plan defined (clear next steps)

## Critical Success Factors | Yếu tố then chốt

### **Comprehensive Search Strategy:**
- **Never Assume**: Always search rules và memory actively
- **Multi-Source**: Combine rules + memory + changelogs + system state
- **Deep Understanding**: Read content, không chỉ scan filenames
- **Intent Focus**: Understand what user really wants accomplish

### **Safety & Quality:**
- **Read-Only Operations**: Tất cả context gathering là safe
- **Verification Steps**: Double-check information accuracy  
- **Error Handling**: Grace degradation khi sources unavailable
- **Performance**: Efficient searches, avoid information overload

## When to Use | Khi nào sử dụng

### **Mandatory Usage:**
- **Session Start**: Beginning work trên Deutschfuns LMS
- **After Breaks**: Returning to work after time away
- **Context Switches**: Changing between system areas
- **Problem Solving**: Stuck và cần broader context
- **Complex Tasks**: Multi-step work requiring full understanding

### **Optional But Recommended:**
- **Before Major Changes**: Understanding impact trước khi modify
- **Learning New Areas**: Exploring unfamiliar parts của system
- **Troubleshooting**: When standard approach không work

## Memory Location (SSoT) | Vị trí bộ nhớ (nguồn duy nhất)
All operations target: `/home/fong/Projects/de/public/.memory/`

## Philosophy | Triết lý

> **"Artificial Intelligence shouldn't be artificially ignorant."**
> 
> Mỗi AI session nên bắt đầu với complete understanding của project context, 
> không phải từ "blank slate". Context initialization là foundation cho 
> quality work và accurate solutions.

## Technical Implementation Notes | Ghi chú kỹ thuật

- **Performance**: Context initialization should complete trong <30 seconds
- **Caching**: Leverage existing memory system cho frequently accessed info
- **Modularity**: Each component (rules, memory, state) can run independently  
- **Extensibility**: Easy to add new context sources as project grows
- **Reliability**: Graceful fallback when individual components fail
