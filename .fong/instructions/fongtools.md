---
description: "Smart tool selector with auto-scan rules for Deutschfuns LMS development tasks"
argument-hint: "[natural language request]"
version: "2025-08-05T08:30:00Z"
---

# Available Development Tools for QTDND Duy Thành

## Tool Catalog | Danh Mục Công Cụ

1. [⚡ **Modern CLI Tools Guide**](#modern-cli-tools-guide) - `UUID: k1l2m3n4-o5p6-7890-klmn-123456789012`
2. [🧠 **Memory Files Search**](#memory-files-search) - `UUID: g7h8i9j0-k1l2-3456-ghij-789012345678`
3. [🖼️ **Image Reader**](#image-reader) - `UUID: i9j0k1l2-m3n4-5678-ijkl-901234567890`
4. [📜 **JS/TS File Reader**](#js-ts-file-reader) - `UUID: j1s2t3s4-r5e6-7890-jsts-234567890123`

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

#### 1. smart-search-fz-rg-bm25 → thay cho grep (fallback: ripgrep)
> Xem thêm: `.fong/instructions/smartsearch.md` để thiết lập alias và tham số nâng cao (`--top-k`, `--show-content`, `--weight`).
```bash
# ❌ KHÔNG dùng
grep -r "function" .

# ✅ Primary hybrid search (fuzzy + BM25)
smart-search-fz-rg-bm25 "function" . --show-content
smart-search-fz-rg-bm25 "TODO" . --top-k 5

# 🔄 Fallback ripgrep (regex/piping)
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
- **smart-search-fz-rg-bm25**: Hybrid fuzzy+BM25 ranking với context-rich output (fallback ripgrep vẫn nhanh hơn grep 5-10x)
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

**Khi nào sử dụng**: Tất cả các thao tác command line, file search, text search, JSON processing, directory listing. Modern tools PHẢI được ưu tiên tuyệt đối.

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

**Khi nào sử dụng**: Khi cần tìm hiểu về codebase, ưu tiên `smart-search-fz-rg-bm25` để khai thác memory; sử dụng `rg` chỉ như fallback để bổ sung kết quả và đọc thêm memory nội bộ cho đầy đủ context.

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

---

## JS/TS File Reader
**UUID**: `j1s2t3s4-r5e6-7890-jsts-234567890123`

Tool chuyên dụng để đọc và phân tích files JavaScript (.js) và TypeScript (.ts) với dependency tracking và code analysis capabilities.

### Supported Formats
- **JavaScript**: `.js` files - ES5, ES6+, CommonJS, ESM modules
- **TypeScript**: `.ts` files - với type definitions và interfaces
- **React/Vue**: JSX/TSX components
- **Node.js**: Server-side JavaScript files

### Core Features
- ✅ **Dependency Analysis**: Track imports/exports và module dependencies
- ✅ **Function Extraction**: Identify và document functions/methods
- ✅ **Class Analysis**: Parse classes, constructors, methods
- ✅ **Variable Tracking**: Track variables và constants
- ✅ **Comment Extraction**: Extract JSDoc comments và inline documentation
- ✅ **Module Detection**: Identify CommonJS vs ESM modules

### Usage Examples
```bash
# Analyze JavaScript file
/home/fong/Projects/MCPs/fong_js_file_reader-core/js-analyzer.sh /path/to/file.js

# Analyze TypeScript file  
/home/fong/Projects/MCPs/fong_js_file_reader-core/js-analyzer.sh /path/to/file.ts

# Deep analysis với dependency tree
/home/fong/Projects/MCPs/fong_js_file_reader-core/js-analyzer.sh /path/to/module.js --deep
```

### Advanced Capabilities
- **Import/Export Mapping**: Full dependency graph generation
- **Type Analysis** (for TS): Extract type definitions và interfaces
- **React Component Detection**: Identify components và props
- **API Endpoint Discovery**: Find API routes và endpoints
- **Code Metrics**: LOC, complexity, coupling analysis

**Khi nào sử dụng**: Khi cần đọc và phân tích code JavaScript/TypeScript, track dependencies, understand module structure, analyze React/Vue components, debug import issues.

Refer to `/home/fong/Projects/de/public/.fong/ubuntu-host.json` for detailed SSH configuration and troubleshooting.
