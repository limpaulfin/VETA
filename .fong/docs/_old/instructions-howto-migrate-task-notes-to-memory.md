
# Quy tắc Di trú Ghi chú Công việc vào Bộ nhớ Dài hạn (Task Notes to Memory Migration Rule)

- **ID:** `howto-migrate-task-notes-to-memory`
- **Tác giả:** Asi
- **Ngày tạo:** 2025-06-23
- **Version:** 1.0.0

## 1. Mục Đích

Quy tắc này chuẩn hóa quy trình dọn dẹp thư mục chứa các ghi chú của một công việc đã hoàn thành (ví dụ: `.fong/docs/01-active-tasks/current/*`) và di trú những kiến thức quan trọng, đã được đúc kết vào hệ thống bộ nhớ dài hạn (`.memory/long-term/`).

Mục tiêu là biến những ghi chú tạm thời, có thể lộn xộn, thành các tài sản tri thức có cấu trúc, dễ tìm kiếm và có thể tái sử dụng, đồng thời giữ cho thư mục công việc gọn gàng.

## 2. Khi nào Áp dụng

Quy trình này được kích hoạt khi một task lập trình đã hoàn thành và người dùng yêu cầu:
- "dọn dẹp" (cleanup) thư mục task.
- "di trú" (migrate) các ghi chú vào memory.
- "lưu trữ" (archive) các kết quả của task.

## 3. Quy Trình Thực Hiện

Quy trình gồm 3 giai đoạn chính: **Phân tích**, **Di trú**, và **Hoàn tất**.

---

### Giai đoạn 1: Đọc và Alignment On-the-fly

Mục tiêu: **Đọc tới đâu -> làm tới đó** (không đọc hết mới làm)

1.  **Liệt kê files trong thư mục Task:**
    -   Sử dụng `LS` để xem tất cả files trong task folder
    
2.  **Đọc và Alignment ngay lập tức:**
    -   **Đọc từng file một** bằng `Read` tool
    -   **Ngay sau khi đọc xong 1 file** → tạo memory file tương ứng
    -   **Không chờ đọc hết** → alignment từng file riêng biệt
    
3.  **Pattern thực hiện:**
    ```
    Read file 1 → Write memory 1 → Read file 2 → Write memory 2
    ```
    **KHÔNG ĐƯỢC:**
    ```  
    Read all files → Plan → Write all memories
    ```

---

### Giai đoạn 2: On-the-fly Memory Creation

Tạo memory file ngay sau khi đọc từng file task.

1.  **Immediate Alignment Pattern:**
    -   **Read 1 file** → **Write 1 memory** → **Next file**
    -   Sử dụng `Write` tool để tạo file `.json` trong `.memory/long-term/`
    -   Tuân thủ `howto-dkm-set-memory.mdc` format
    
2.  **ALIGNMENT - KHÔNG TÓM TẮT:** 
    * Chuyển **toàn bộ** logic, code, findings từ task notes
    * Giữ nguyên technical details, code snippets, file paths
    * Preserve **tất cả** related files và dependencies 
    * **Alignment = đồng bộ hoàn toàn knowledge**, không mất thông tin
    * Chỉ cấu trúc hóa format JSON, **không rút gọn nội dung**

3.  **Workflow thực tế:**
    ```
    LS task_folder → Read file1.md → Write memory1.json
                  → Read file2.json → Write memory2.json  
                  → Read file3.md → Write memory3.json
    ```

4.  **QUAN TRỌNG - Loại trừ Files:**
    -   **KHÔNG BAO GIỜ MIGRATE** hình ảnh (*.png, *.jpg, *.gif, etc.)
    -   **KHÔNG COPY** các files binary vào memory
    -   **CHỈ MIGRATE** text-based files (.md, .json, .txt)

---

### Giai đoạn 3: Dọn dẹp & Hoàn tất

**QUAN TRỌNG: XÓA HẾT FOLDER, KHÔNG TẠO README**

1.  **Xóa toàn bộ thư mục task:**
    -   Sử dụng lệnh `rm -rf` để xóa toàn bộ thư mục task sau khi đã migrate xong.
    -   Ví dụ: `rm -rf .fong/docs/01-active-tasks/current/[task-id]/`
    -   **KHÔNG** tạo file README.md hay bất kỳ file nào khác.
    -   **KHÔNG** để lại gì cả trong thư mục.

## Lưu ý Quan trọng

**Từ kinh nghiệm thực tế:** Người dùng muốn migrate xong thì xóa hết folder, không tạo README. Tuyệt đối không tạo lại bất kỳ file nào sau khi migrate hoàn tất.

## 4. Tham Chiếu

- `@howto-dkm-set-memory.mdc`: Để biết quy tắc tạo file memory.
- `@rule-align-memory.mdc`: Để hiểu về tầm quan trọng của việc đồng bộ memory và code.
