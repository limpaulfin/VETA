# FongTrace - Methodology Tracing Files & Dependencies

## Mục đích
Trace và phân tích tất cả files liên quan đến một trang/feature cụ thể trong Deutschfuns LMS.

## 🔗 Tool Integration Map

### Related Tools & Files
- **📋 Command Reference**: `/home/fong/Projects/de/public/.claude/commands/fongtoolsx.md`
- **🧠 Memory Commands**: `/home/fong/Projects/de/public/.claude/commands/fongmemory.md`
- **🔧 PHP Reader**: `/home/fong/Projects/de/public/.fong/tools/fong-php-reader.sh`
- **📜 JS Reader**: `/home/fong/Projects/de/public/.fong/tools/fong-js-reader.sh`  
- **🗄️ DB Query**: `/home/fong/Projects/de/public/.fong/tools/dbqueryx.sh`
- **📊 Git Operations**: `/home/fong/Projects/de/public/.fong/script-sh/fgitx.sh`
- **🌐 Web Testing**: `/home/fong/Projects/de/public/.fong/script-sh/curlx.sh`

### Cross-Reference Pattern
```bash
# Use fonttoolsx.md để chọn tool tự động
/ftools trace this page: wp-admin/tools.php?page=target-page

# Use fongmemory.md để search/save context  
/ftools search memory for: cron-status
/ftools save to memory: trace-results-summary
```

## Quy trình Trace (7 bước)

### 1. Identify Target
- URL hoặc trang cần trace
- Capture DOM reference (nếu có)
- Note: page parameter, hooks, actions

### 2. PHP Files Discovery
```bash
# Tìm page handler chính
rg -i "page=target-page" --type php

# Tìm theo menu slug hoặc page name  
rg -i "fong-cron-status" --type php

# 🔧 Sử dụng PHP reader cho phân tích sâu (maps to fong-php-reader.sh)
/home/fong/Projects/de/public/.fong/tools/fong-php-reader.sh /absolute/path/main-file.php

# Alternative: Use fonttoolsx.md auto-selection
# /ftools analyze this PHP file: /path/to/file.php
```

### 2.1 PHP Dependencies Tracing
```bash
# Tìm classes được sử dụng
rg -i "new [A-Z].*_.*" --type php

# Tìm function calls
rg -i "fong_[a-z_]+" --type php

# Tìm WordPress hooks
rg -i "add_action|add_filter|wp_ajax" --type php
```

### 3. JavaScript Files Discovery  
```bash
# Tìm JS được enqueue hoặc inline
rg -i "fong.*cron|cron.*status" --type js

# Tìm inline JS trong PHP
rg -i "function.*checkCron|runCron" --type php

# 📜 Phân tích JS dependencies (maps to fong-js-reader.sh)
/home/fong/Projects/de/public/.fong/tools/fong-js-reader.sh /absolute/path/script.js

# Alternative: Use fonttoolsx.md auto-selection  
# /ftools analyze this JS file: /path/to/file.js
```

### 3.1 AJAX & Frontend Integration
```bash
# Tìm AJAX calls
rg -i "wp_ajax_|ajaxurl|fetch.*ajaxurl" --type php

# Tìm enqueued scripts
rg -i "wp_enqueue_script|wp_localize_script" --type php
```

### 4. CSS Files Discovery
```bash
# Tìm CSS styles
rg -i "fong.*cron|cron.*status" --type css

# Tìm inline styles trong PHP
rg -i "style.*cron" --type php
```

### 5. Database Investigation
```bash
# 🗄️ Query liên quan (maps to dbqueryx.sh)  
/home/fong/Projects/de/public/.fong/tools/dbqueryx.sh "SELECT * FROM wp_options WHERE option_name LIKE '%cron%' LIMIT 10"

# Query hooks, actions
/home/fong/Projects/de/public/.fong/tools/dbqueryx.sh "SELECT * FROM wp_options WHERE option_name LIKE '%fong%cron%'"

# Alternative: Use fonttoolsx.md auto-selection
# /ftools query database: how many users are active?
# /ftools backup database before changes
```

### 5.1 WordPress Specific Queries
```bash
# Check scheduled events
/home/fong/Projects/de/public/.fong/tools/dbqueryx.sh "SELECT option_value FROM wp_options WHERE option_name = 'cron'"

# Check transients
/home/fong/Projects/de/public/.fong/tools/dbqueryx.sh "SELECT * FROM wp_options WHERE option_name LIKE '_transient_%fong%'"

# Check user capabilities
/home/fong/Projects/de/public/.fong/tools/dbqueryx.sh "SELECT * FROM wp_usermeta WHERE meta_key LIKE '%capabilit%' LIMIT 5"
```

### 6. Memory Search
```bash
# 🧠 Tìm trong project memory (maps to fongmemory.md)
rg -i "cron.*status|fong.*cron" /home/fong/Projects/de/public/.memory/ --type json

# Alternative: Use fongmemory.md commands
# /ftools search memory for: cron-status implementation
# /ftools get from memory: cronjob-system-migration

# Search specific memory sections
rg -i "target.*pattern" /home/fong/Projects/de/public/.memory/long-term/ --type json
rg -i "target.*pattern" /home/fong/Projects/de/public/.memory/short-term/ --type json
```

### 6.1 Memory Integration Commands
```bash
# Save current trace to memory (via fongmemory.md)
# /ftools save to memory: trace-results-fong-cron-status-2025-08-12

# Align memory with findings
# /ftools align memory with latest discoveries

# Search related traces
# /ftools search memory for: previous traces of admin pages
```

### 7. Report Generation & Integration
```bash
# 📊 Git operations during trace (maps to fgitx.sh)
/home/fong/Projects/de/public/.fong/script-sh/fgitx.sh "status"
/home/fong/Projects/de/public/.fong/script-sh/fgitx.sh "log --oneline -5"

# 🌐 Web testing related endpoints (maps to curlx.sh) 
/home/fong/Projects/de/public/.fong/script-sh/curlx.sh 'curl -s -k "https://tiengduc2fong.com/wp-admin/tools.php?page=fong-cron-status"'

# Save final report to memory
# /ftools save to memory: complete-trace-report-[feature-name]
```

### 7.1 Report Structure & Integration
- **Tổng hợp**: Files được map với tools đã dùng
- **Dependencies**: Cross-reference với fonttoolsx.md tools
- **Logic flow**: Include tool command patterns
- **Memory integration**: Link to fongmemory.md saves
- **Git context**: Current branch và changes status

## 📁 Output Structure
```
/home/fong/Projects/de/public/.fong/_tmp/trace-reports/
├── trace-YYYY-MM-DD-HHMMSS-[feature-name]/
│   ├── trace-summary.md              # 📋 Main report
│   ├── php-files-analysis.json       # 🔧 PHP analysis results  
│   ├── js-files-analysis.json        # 📜 JS analysis results
│   ├── css-files-analysis.json       # 🎨 CSS analysis results (optional)
│   ├── database-queries.json         # 🗄️ DB queries results
│   ├── tools-used.json              # 🔗 Tools mapping record
│   └── memory-refs.json             # 🧠 Memory references used
```

## 🔗 Integration Matrix

| Step | Primary Tool | Alt Tool (fonttoolsx.md) | Memory Save |
|------|-------------|-------------------------|-------------|
| PHP Analysis | fong-php-reader.sh | `/ftools analyze PHP file` | ✅ |
| JS Analysis | fong-js-reader.sh | `/ftools analyze JS file` | ✅ |
| DB Queries | dbqueryx.sh | `/ftools query database` | ✅ |
| Memory Search | rg commands | `/ftools search memory` | ✅ |
| Git Context | fgitx.sh | `/ftools git status` | ✅ |
| Web Testing | curlx.sh | `/ftools test endpoint` | ✅ |

## ⚠️ Safety Rules & Tool Mapping
- **Backup**: Use fgitx.sh for git status before trace
- **Read-only**: All analysis tools are non-destructive  
- **Memory save**: Auto-save important findings via fongmemory.md
- **Cross-reference**: Always check fonttoolsx.md for alternative commands
- **Documentation**: Each trace creates complete tool usage record