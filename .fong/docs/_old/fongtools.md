---
description: "Smart tool selector with auto-scan rules for Deutschfuns LMS development tasks"
argument-hint: "[natural language request]"
version: "2025-08-05T08:30:00Z"
---

# Available Development Tools for Deutschfuns LMS

## Tool Catalog | Danh Mục Công Cụ

1. [🔍 **Log Reader**](#log-reader) - `UUID: a1b2c3d4-e5f6-7890-abcd-ef1234567890`
2. [⚡ **Modern CLI Tools Guide**](#modern-cli-tools-guide) - `UUID: k1l2m3n4-o5p6-7890-klmn-123456789012`
3. [🧠 **Memory Files Search**](#memory-files-search) - `UUID: g7h8i9j0-k1l2-3456-ghij-789012345678`
4. [🖼️ **Image Reader**](#image-reader) - `UUID: i9j0k1l2-m3n4-5678-ijkl-901234567890`

## Environment Context | Ngữ cảnh Môi trường
**Target Environment**: Xubuntu Guest Machine | **Môi trường Mục tiêu**: Máy Guest Xubuntu
**SSH Access Pattern**: `ssh fong@192.168.122.1 'command'` | **Mẫu Truy cập SSH**

## Tool Usage Examples | Ví dụ Sử dụng Công cụ

**Content Search**:
- "find backup information in memory files" → Use Memory Files Search
- "search for previous solutions in rules" → Use Memory Files Search

**Image Analysis**:
- "what's in this screenshot: /path/to/image.png" → Use Image Reader
- "extract text from changelog image" → Use Image Reader

## Log Reader
**UUID**: `a1b2c3d4-e5f6-7890-abcd-ef1234567890`

Tool chuyên dụng để đọc và phân tích log files của hệ thống Deutschfuns LMS.

### Các loại log chính
- WordPress Debug Log: `wp-content/debug.log`
- Fong LMS Text Debug Log: `wp-content/plugins/fong_de_lms/fong-debug/logs/fong-debug-php.log`
- Fong LMS JSONL Debug Log: `wp-content/plugins/fong_de_lms/fong-debug/logs/fong-debug-php.jsonl`

### Nguyên tắc đọc log hiệu quả
1. **Đọc từ dưới lên** - log mới nhất ở cuối file
2. **Giới hạn số dòng** - sử dụng `tail -n 300` để lấy 300 dòng cuối
3. **Ưu tiên `jq` cho JSONL files** - chính xác hơn grep/sed/awk cho JSON data
4. **Sử dụng filter phù hợp** - kết hợp grep, sed, awk cho text logs

### Lệnh cơ bản
```bash
# Đọc log mới nhất (300 dòng cuối)
tail -n 300 wp-content/plugins/fong_de_lms/fong-debug/logs/fong-debug-php.log | cat

# Đọc JSONL với jq
tail -n 300 wp-content/plugins/fong_de_lms/fong-debug/logs/fong-debug-php.jsonl | jq '.'

# ✅ Filter theo error level (ripgrep + jq)
rg '"level":"ERROR"' wp-content/plugins/fong_de_lms/fong-debug/logs/fong-debug-php.jsonl | tail -n 50 | jq '.'

# ✅ Tìm log theo label cụ thể (ripgrep + jq)
rg "TEMPLATE_ACCESS_CONTROL_DEBUG" wp-content/plugins/fong_de_lms/fong-debug/logs/fong-debug-php.jsonl | jq '.'

# ✅ Theo dõi real-time (ripgrep)
tail -f wp-content/plugins/fong_de_lms/fong-debug/logs/fong-debug-php.log | rg "ERROR"
```

### Ví dụ phân tích log quyền truy cập
```bash
# ✅ Tìm log debug của template chi tiết khóa học (ripgrep + jq)
rg "TEMPLATE_ACCESS_CONTROL_DEBUG" wp-content/plugins/fong_de_lms/fong-debug/logs/fong-debug-php.jsonl | jq '.data | {course_id, user_id, final_has_access, access_granted_by}'

# ✅ Tìm theo course_id cụ thể (ripgrep + jq)
rg "course_id.*27861" wp-content/plugins/fong_de_lms/fong-debug/logs/fong-debug-php.jsonl | jq '.'
```

**Khi nào sử dụng**: Debug lỗi, phân tích quyền truy cập, theo dõi hoạt động hệ thống, tìm hiểu luồng xử lý.

---

## Modern CLI Tools Guide
**UUID**: `k1l2m3n4-o5p6-7890-klmn-123456789012`

Hướng dẫn sử dụng các công cụ command line hiện đại thay thế cho các lệnh Unix truyền thống để tăng hiệu suất và trải nghiệm.

### ⚠️ NGUYÊN TẮC BẮT BUỘC
**LUÔN LUÔN** sử dụng modern tools thay cho traditional tools:
- **smart-search-fz-rg-bm25** thay cho `grep` (fallback: ripgrep)
- **fd** thay cho `find`
- **bat** thay cho `cat`
- **exa** thay cho `ls`
- **tree** cho cấu trúc thư mục
- **jq** cho JSON processing

### Danh sách công cụ thay thế

> 📦 **Archive Note (2025-11-03):** Tài liệu này thuộc thư mục `_old/`. Luôn ưu tiên `.fong/instructions/fongtools.md` và `.fong/instructions/smartsearch.md` để lấy hướng dẫn mới nhất. Các lệnh `rg` bên dưới giờ đóng vai trò fallback cho regex/pipeline automation.

#### 1. smart-search-fz-rg-bm25 → thay cho grep (fallback: ripgrep)
```bash
# ❌ KHÔNG dùng
grep -r "function" .

# ✅ Primary hybrid search (fuzzy + BM25)
smart-search-fz-rg-bm25 "function" . --show-content
smart-search-fz-rg-bm25 "TODO" . --top-k 5

# 🔄 Ripgrep fallback (regex/piping)
rg "function"
rg "TODO" -A 3 -B 1
rg "error" --type js --json | jq .
```

#### 2. fd → thay cho find
```bash
# ❌ KHÔNG dùng
find . -name "*.js" -type f

# ✅ DÙNG thay thế
fd "\.js$"
fd "config" --type f
fd "test" --extension py
fd . --exclude node_modules
```

#### 3. bat → thay cho cat
```bash
# ❌ KHÔNG dùng  
cat file.js

# ✅ DÙNG thay thế
bat file.js
bat package.json
bat --style=numbers,changes file.py
bat --paging=never short-file.txt
```

#### 4. exa → thay cho ls
```bash
# ❌ KHÔNG dùng
ls -la

# ✅ DÙNG thay thế
exa -la
exa -la --icons
exa --tree --level=2
exa -l --sort=modified
```

#### 5. tree → hiển thị cấu trúc
```bash
# ✅ LUÔN dùng cho cấu trúc thư mục
tree -L 3 --gitignore
tree -a -I "node_modules|.git"
```

#### 6. jq → xử lý JSON
```bash
# ❌ KHÔNG dùng grep cho JSON
grep "name" config.json

# ✅ DÙNG jq
jq '.' config.json
jq '.data[]' api-response.json  
jq -r '.name' config.json
```

### Performance Benefits
- **smart-search-fz-rg-bm25**: Hybrid fuzzy+BM25 ranking với output giàu ngữ cảnh (fallback ripgrep vẫn nhanh hơn grep 5-10x)
- **fd**: 3-7x nhanh hơn find
- **bat**: syntax highlighting + git integration
- **exa**: colors, icons, git status  
- **jq**: JSON parsing chuyên nghiệp

### Kết hợp tools với pipes
```bash
# Tìm và hiển thị files
fd "\.json$" | head -5 | xargs bat

# Search và parse JSON (primary)
smart-search-fz-rg-bm25 "TODO" . --show-content

# Fallback ripgrep JSON parsing
rg "TODO" --json | jq -r '.data.lines.text'

# Interactive file selection
exa -1 | fzf | xargs bat
```

### Availability Check & Fallback
```bash
# Kiểm tra availability trước khi dùng
if command -v smart-search-fz-rg-bm25 >/dev/null; then
  smart-search-fz-rg-bm25 "pattern" . --show-content
elif command -v rg >/dev/null; then
  rg "pattern"
else
  grep -r "pattern"
fi
which fd > /dev/null && fd "\.js$" || find . -name "*.js"
which bat > /dev/null && bat file.txt || cat file.txt
```

### Installation Status
✅ **Đã cài đặt:** jq, tree, htop, exa  
⚠️ **Cần cài thêm:** smart-search-fz-rg-bm25 (alias + script), ripgrep (fallback), fzf, bat, fd-find, ncdu

**Khi nào sử dụng**: Tất cả các thao tác command line, file search, text search, JSON processing, directory listing. Modern tools PHẢI được ưu tiên tuyệt đối; `smart-search-fz-rg-bm25` là mặc định, `rg` chỉ dùng khi cần regex/pipeline.

---

## Memory Files Search
**UUID**: `g7h8i9j0-k1l2-3456-ghij-789012345678`

Tool thông minh để tìm kiếm thông tin trong memory files, knowledge base và development artifacts của dự án Deutschfuns LMS.

### Core Search Capabilities

- **Memory Search**: Tìm kiếm trong `.memory/` directory với patterns thông minh
- **Knowledge Base**: Scan qua CHANGELOGS/, rules/, và development notes
- **Multi-Pattern Search**: Kết hợp multiple search terms với logical operations
- **Context-Aware**: Hiểu được conversation context và codebase relationships

### Usage Patterns

#### Basic Search
```bash
# Tìm trong memory về chức năng cụ thể
/fmemory em tìm trong memory coi có gì về user authentication không?

# Lookup thông tin debug 
/fmemory search memory for database connection issues

# Kiểm tra có thông tin về function
/fmemory check memory for information about fong_get_user_avatar_html function
```

#### Advanced Search
```bash
# Tìm kiếm multi-keyword với context
/fmemory find information about "PHP strict typing" and "compatibility issues"

# Search patterns trong memory và rules
/fmemory search for solutions related to "database timeout" in memory files
```

### Search Strategy

1. **Primary Sources**: `.memory/` directory với comprehensive search
2. **Changelog Context**: Recent changes trong `CHANGELOGS/` folder
3. **Development Notes**: Personal notes trong `.fong/` folder  
4. **Efficient Search**: Sử dụng `smart-search-fz-rg-bm25` cho text search (fallback: `rg`/ripgrep)
5. **Structured Results**: Trả về kết quả có cấu trúc và context

### Advanced Features

- **Keyword Prioritization**: English keywords first, Vietnamese fallback
- **Relevance Scoring**: Automatic relevance assessment cho search results
- **Context Extraction**: Extract relevant context around matches
- **Cross-Reference**: Link giữa memory files và current codebase
- **Smart Filtering**: Filter out noise và focus vào relevant information

### Memory Location (SSoT)
**Single Source**: `/home/fong/Projects/de/public/.memory/`

**Khi nào sử dụng**: Khi cần tìm hiểu về codebase, ưu tiên `smart-search-fz-rg-bm25`; dùng `rg` nếu cần regex chính xác. Đồng thời đọc thêm memory nội bộ để có context đầy đủ về các solutions, patterns, và knowledge đã accumulated.

---

## Image Reader
**UUID**: `i9j0k1l2-m3n4-5678-ijkl-901234567890`

Tool OCR và phân tích hình ảnh chuyên dụng cho việc đọc screenshot, changelog images, và UI analysis trong quá trình development.

### Supported Formats
- **Screenshots**: PNG, JPG, JPEG, WebP
- **Documentation**: PDF pages, images
- **UI Analysis**: Interface screenshots, error screenshots

### Usage Examples - Xubuntu SSH Proxy

```bash
# Analyze screenshot and describe content
/home/fong/Projects/MCPs/fong_image_reader-core/run.sh /path/to/screenshot.png

# Extract text from changelog image
/home/fong/Projects/MCPs/fong_image_reader-core/run.sh /path/to/changelog.png

# UI bug analysis with detailed description
/home/fong/Projects/MCPs/fong_image_reader-core/run.sh /path/to/ui-bug.png
```

### Advanced Features
- ✅ **OCR Text Extraction**: High accuracy text recognition
- ✅ **UI Element Detection**: Identify buttons, forms, navigation
- ✅ **Error Analysis**: Describe error messages and UI issues
- ✅ **Documentation Reading**: Extract info from PDF/image docs
- ✅ **Multi-language Support**: Vietnamese/German/English text

**Khi nào sử dụng**: Phân tích screenshot bugs, extract text từ hình ảnh, document analysis, UI/UX review, error investigation.

Refer to `/home/fong/Projects/de/public/.fong/ubuntu-host.json` for detailed SSH configuration and troubleshooting.
