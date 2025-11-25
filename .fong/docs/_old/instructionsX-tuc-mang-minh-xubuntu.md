---
description: "Túc Mạng Minh - Quy trình Phân tích Lịch sử Toàn diện"
argument-hint: "[file_path] [options]"
version: "2025-08-06T19:30:00Z"
---

# Rule: Túc Mạng Minh - Quy trình Phân tích Lịch sử Toàn diện (Xubuntu)

## Environment Context | Ngữ cảnh Môi trường
**Target Environment**: Xubuntu Guest Machine | **Môi trường Mục tiêu**: Máy Guest Xubuntu  
**Use Case**: When running on Xubuntu guest machine | **Trường hợp Sử dụng**: Khi chạy trên máy guest Xubuntu  
**SSH Pattern**: `ssh fong@192.168.122.1 'command'` | **Mẫu SSH**: `ssh fong@192.168.122.1 'lệnh'`

### Environment Variables
- `$DE_PROJECT_ROOT`: Points to `/home/fong/Projects/de/public` (DE project root directory)
- `$HOME`: User home directory (typically `/home/fong`)

⚠️ **Instructions này chỉ áp dụng cho máy ảo Xubuntu**

## Description
This rule outlines the comprehensive process for analyzing a file's history. It combines using the `Túc Mạng Minh` tool for local, uncommitted changes and `git log` for official commit history in the repository. This dual approach provides a complete timeline of a file's evolution, from minor saves to major commits.

**Lưu ý quan trọng:** Hướng dẫn này được thiết kế cho môi trường Xubuntu guest machine với SSH proxy pattern. Tất cả các lệnh git phải sử dụng fgitx.sh script và main.py phải được gọi với absolute path.

## 1. How to Use `Túc Mạng Minh` (For Local History) - Xubuntu

The tool is executed via the `main.py` script with **absolute path**. The results are always displayed in the console and saved to a timestamped file in `.fong/tools/tuc-mang-minh/tmp/`.

### Command Structure - Xubuntu SSH Proxy
```bash
ssh fong@192.168.122.1 'python3 $DE_PROJECT_ROOT/.fong/tools/tuc-mang-minh/main.py <file_path> [options]'
```

⚠️ **BẮT BUỘC**: Trong môi trường Xubuntu, tool phải chạy qua SSH để truy cập host machine data:
- **SSH Pattern**: `ssh fong@192.168.122.1 'command'`
- **Absolute Path**: `$DE_PROJECT_ROOT/.fong/tools/tuc-mang-minh/main.py`
- **Lý do**: Dữ liệu history được lưu trên host machine, không phải trong Xubuntu guest

### Arguments
- `file_path`: (Required) The original path of the file to search for (e.g., `src/core/main.py`).
  - **Note:** If the file path contains spaces, you **must** enclose it in quotes (e.g., `"my folder/my file.py"`).
  - **Quan trọng:** Luôn sử dụng đường dẫn tương đối từ thư mục gốc của dự án, KHÔNG sử dụng đường dẫn tuyệt đối.

### Options
- `--text <search_text>`: The text to search for within the file versions.
  - **Brainstorm:** Nên sử dụng nhiều từ khóa khác nhau và chạy công cụ nhiều lần với các từ khóa khác nhau để có kết quả toàn diện. Không nhất thiết chỉ gọi một lần.
- `--start-date "<YYYY-MM-DD HH:MM:SS>"`: The start date/time for the search period.
- `--end-date "<YYYY-MM-DD HH:MM:SS>"`: The end date/time for the search period.
- `--context <lines>`: Number of context lines to show around a match (default: 5).
- `--limit <number>`: Limit the search to the N most recent versions (default: 50).
- `--history-path <path>`: The path to the `.history` directory (default: `./.history`).

### Examples - Xubuntu SSH Proxy

**1. Basic file history search:**
```bash
ssh fong@192.168.122.1 'python3 $DE_PROJECT_ROOT/.fong/tools/tuc-mang-minh/main.py "wp-content/plugins/fong_de_lms/modules/streak/src/autoload-models/Fong_User_Last_Online_Manager-class.php" --limit 5'
```

**2. Text search with context:**
```bash
ssh fong@192.168.122.1 'python3 $DE_PROJECT_ROOT/.fong/tools/tuc-mang-minh/main.py "src/app.js" --text "important function" --context 3'
```

**3. Date range search:**
```bash
ssh fong@192.168.122.1 'python3 $DE_PROJECT_ROOT/.fong/tools/tuc-mang-minh/main.py "CLAUDE.md" --start-date "2025-08-06 15:00:00" --limit 10'
```

## 2. Comprehensive Analysis Workflow (Túc Mạng Minh + Git Diff) - Xubuntu

To ensure a thorough analysis of a file's history without missing any changes, it is highly recommended to combine `Túc Mạng Minh` with `git diff`.

### Workflow Steps - Xubuntu

1.  **Find All Historical Versions**: Run `Túc Mạng Minh` via SSH without any text search to get a complete list of all available historical versions for the file. This provides a high-level overview of all save points.
    ```bash
    ssh fong@192.168.122.1 'python3 $DE_PROJECT_ROOT/.fong/tools/tuc-mang-minh/main.py "path/to/your/file.py"'
    ```
    The tool will output a list of historical file paths, for example:
    - `.history/path/to/your/file_20250530100000.py`
    - `.history/path/to/your/file_20250530113000.py`
    - `.history/path/to/your/file_20250530120000.py`

2.  **Analyze Changes with `git diff`**: Use the paths from the previous step to run a `git diff` command. The `--no-index` flag is crucial as these files are not in the Git index. This allows for a detailed, line-by-line comparison between any two points in time.

    **To compare two historical versions:**
    ```bash
    git diff --no-index .history/path/to/your/file_20250530100000.py .history/path/to/your/file_20250530113000.py
    ```

    **To compare a historical version with the current file:**
    ```bash
    git diff --no-index .history/path/to/your/file_20250530113000.py path/to/your/file.py
    ```

This combined workflow ensures you have both a broad overview and a detailed analysis, leaving no gaps in the file's history.

## 3. Quy trình Phân tích Lịch sử Toàn diện (Local + Git) - Dòng thời gian đầy đủ - Xubuntu

Để có được một dòng thời gian lịch sử thực sự hoàn chỉnh cho một tệp tin, việc kết hợp cả các lần lưu cục bộ (chưa commit) và các commit chính thức trên Git là cực kỳ quan trọng. Đây là **phương pháp tốt nhất và được khuyến nghị**.

### Các bước thực hiện - Xubuntu

1.  **Lấy Lịch sử Cục bộ (Local History)**: Sử dụng `Túc Mạng Minh` qua SSH để liệt kê tất cả các phiên bản được lưu cục bộ. Thao tác này cho thấy các thay đổi chi tiết, chưa được commit.
    ```bash
    ssh fong@192.168.122.1 'python3 $DE_PROJECT_ROOT/.fong/tools/tuc-mang-minh/main.py "path/to/your/file.py"'
    ```

2.  **Lấy Lịch sử Git (Git History)**: ⚠️ **BẮT BUỘC**: Sử dụng `fgitx.sh` script cho git commands trong môi trường Xubuntu:
    ```bash
    $DE_PROJECT_ROOT/.fong/script-sh/fgitx.sh "git log --oneline --follow -- path/to/your/file.py"
    ```

3.  **Tổng hợp Kết quả**: Bằng cách xem xét dấu thời gian (timestamp) từ `Túc Mạng Minh` và ngày commit từ `git log`, bạn có thể xây dựng một lịch sử hoàn chỉnh, theo thứ tự thời gian của tệp tin.

Quy trình hai bước này cung cấp cái nhìn chi tiết và chính xác nhất về toàn bộ vòng đời của một tệp.

## 4. Git Commands - Xubuntu SSH Proxy Pattern

⚠️ **BẮT BUỘC**: Tất cả git commands phải sử dụng fgitx.sh script:

```bash
# Git status
$DE_PROJECT_ROOT/.fong/script-sh/fgitx.sh "git status"

# Add files
$DE_PROJECT_ROOT/.fong/script-sh/fgitx.sh "git add ."

# Commit
$DE_PROJECT_ROOT/.fong/script-sh/fgitx.sh "git commit -m 'message'"

# Push
$DE_PROJECT_ROOT/.fong/script-sh/fgitx.sh "git push"

# Git log for file
$DE_PROJECT_ROOT/.fong/script-sh/fgitx.sh "git log --oneline --follow -- path/to/file"
```

**Features của fgitx.sh**:
- ✅ **Auto SSH**: Tự động kết nối tới `fong@192.168.122.1`
- ✅ **Auto Navigation**: Tự động chuyển tới đúng project directory
- ✅ **Safety Confirmation**: Xác nhận cho các lệnh nguy hiểm
- ✅ **Clean Output**: Output sạch, không spam SSH warnings

## 5. Handling Large Output Files - Xubuntu

The output files (`output-*.txt`) can become very large. To avoid overwhelming your terminal or exceeding token limits, use command-line utilities to read them in manageable chunks.

### Best Practices (Limit: 200 LOC) - Xubuntu

-   **Read the first 200 lines:**
    ```bash
    head -n 200 .fong/tools/tuc-mang-minh/tmp/output-*.txt
    ```
-   **Read the last 200 lines:**
    ```bash
    tail -n 200 .fong/tools/tuc-mang-minh/tmp/output-*.txt
    ```
-   **Read a specific range (e.g., lines 201 to 400):**
    ```bash
    sed -n '201,400p' .fong/tools/tuc-mang-minh/tmp/output-*.txt
    ```
-   **Filter for a specific keyword:**
    ```bash
    grep "your_keyword" .fong/tools/tuc-mang-minh/tmp/output-*.txt
    ```
By following these guidelines, you can efficiently analyze even very large history logs.

## 6. Complete Xubuntu Workflow Example

### Verified Test Results - Multiple File Types

**✅ Test Results (2025-08-06 19:27-19:28):**
1. **Markdown Files**: `.fong/docs/.../prompt1.md` → Found 3 versions (17:13-17:14)
2. **PHP Templates**: `profile-general-info.php` → Found 2 versions (18:10-18:36) 
3. **PHP Classes**: `Fong_User_Last_Online_Manager-class.php` → Found 2 versions (18:54)
4. **Text Search**: Successfully found "private function" with context
5. **Error Handling**: Properly handles non-existent files
6. **Date Ranges**: Works with `--start-date` filtering

### Complete Workflow Example

```bash
# Step 1: Get local history via SSH
ssh fong@192.168.122.1 'python3 $DE_PROJECT_ROOT/.fong/tools/tuc-mang-minh/main.py "wp-content/plugins/fong_de_lms/modules/streak/src/autoload-models/Fong_User_Last_Online_Manager-class.php" --limit 5'

# Step 2: Search for specific code patterns
ssh fong@192.168.122.1 'python3 $DE_PROJECT_ROOT/.fong/tools/tuc-mang-minh/main.py "wp-content/plugins/fong_de_lms/modules/streak/src/autoload-models/Fong_User_Last_Online_Manager-class.php" --text "private function" --context 2'

# Step 3: Get git history using fgitx
$DE_PROJECT_ROOT/.fong/script-sh/fgitx.sh "git log --oneline --follow -- wp-content/plugins/fong_de_lms/modules/streak/src/autoload-models/Fong_User_Last_Online_Manager-class.php"

# Step 4: Read saved output
head -n 50 .fong/tools/tuc-mang-minh/tmp/output-*.txt
```

## Key Principles - Xubuntu Environment

- **SSH Proxy Required**: Tool PHẢI chạy qua `ssh fong@192.168.122.1` từ Xubuntu guest
- **Absolute Paths**: Luôn sử dụng absolute path cho main.py
- **History Location**: Tool tự động tìm Cursor history trước, sau đó VSCode history
- **File Matching**: Tool hỗ trợ flexible filename matching (tìm được file dù đổi tên/di chuyển)
- **Git Integration**: Kết hợp với fgitx.sh để có timeline hoàn chỉnh
- **Output Management**: Kết quả lưu trong `.fong/tools/tuc-mang-minh/tmp/`

**🔧 Tool Configuration Updated (2025-08-06):**
- ✅ Cursor History Priority: `$HOME/.config/Cursor/User/History` (Primary)
- ✅ VSCode History Fallback: `$HOME/.config/Code/User/History` (Secondary)
- ✅ Flexible File Matching: Filename-based fallback when exact path fails
- ✅ SSH Proxy Ready: Optimized for Xubuntu guest → host communication

Remember: This guide is specifically optimized for Xubuntu guest machine environment with SSH proxy access to host machine timeline data.