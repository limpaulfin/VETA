---
description: "Triết lý auto-debug cho Jupyter Notebook với logging, vòng lặp sửa lỗi và kiểm định thủ công"
version: "2025-10-19T21:22:00+07:00"
context: "General notebook auto-debug mindset"
---

# 📓 Auto-Debug Notebook Playbook

## 1. Philosophy — Tư duy cốt lõi
- **Human-in-the-loop**: Notebook tự chạy để tạo ra log, còn người đọc log và outputs để quyết định sửa đổi. Không kỳ vọng 100% tự động; thay vào đó, duy trì vòng lặp *Run → Observe → Fix → Repeat*.
- **Log-first debugging**: Luôn coi `debug.log` là nguồn sự thật. Mỗi cell quan trọng phải ghi rõ trạng thái, dữ liệu đầu ra và cảnh báo. Log tốt giúp nhận diện lỗi nhanh mà không cần chạy lại toàn notebook quá nhiều lần.
- **Reproducible experiments**: Notebook phải chạy được từ đầu đến cuối trong cùng môi trường. Mọi fix phải giữ nguyên cấu trúc dữ liệu/ngõ ra để lần chạy sau tái hiện y hệt.
- **Collective knowledge**: Sau mỗi vòng debug, dùng MCP Perplexity (theo hướng dẫn ở `.fong/instructions/fongperplexicity.md`) để kiểm tra best practice, đặt câu hỏi về lý do lỗi, cách tối ưu biểu đồ/output. Tinh thần: không dừng ở việc “chạy được”, mà cần “chạy đúng & chuẩn”.
- **Design over implementation**: Notebook là bề mặt thực thi; logic thật nằm ở các module Python tái sử dụng. Điều này giúp log tập trung, fix ít nơi và giảm copy/paste.

## 2. Technique — Vòng lặp 6 bước
1. **Viết notebook**: Thiết kế cell rõ ràng (Chuẩn bị dữ liệu → Phân tích → Tổng kết). Tách code reusable sang `src/` để notebook chỉ gọi hàm.
2. **Ghi log có cấu trúc**: Trong notebook hoặc module, dùng logger chung (`logging` hoặc wrapper riêng) với định dạng thống nhất, ghi vào `notebook_stem-output/logs/debug.log` và từng `cell_xx.log`. Nội dung tối thiểu: mô tả cell, kích thước dữ liệu, cảnh báo bất thường.
3. **Chạy trong Jupyter Notebook**: Mở notebook bằng `jupyter notebook` hoặc `jupyter lab`, sau đó run all/từng cell trong UI. Khi cần automation (CI hoặc CLI), có thể dùng `jupyter nbconvert --execute` hoặc script Python; luôn cấu hình đầu ra (ví dụ `--output "_$(basename notebook)"` hoặc rename sau khi convert) để mọi notebook xuất/convert đều mang tiền tố `_` và dễ xoá khi housekeeping.
4. **Đọc log & fix**: Sau mỗi lần chạy, mở `debug.log` (vd. `tail -f` hoặc `bat`). Định vị `ERROR`/`WARNING`, xem chi tiết trong log cell. Sửa notebook hoặc module, ghi chú lý do, rồi chạy lại cell liên quan. Lặp cho tới khi log sạch.
5. **Rà soát output**: Kiểm tra JSON/CSV/PNG sinh ra ở `notebook_stem-output/`. Đánh giá dữ liệu có hợp lý, biểu đồ có truyền tải đúng thông điệp, kích thước file đạt chuẩn (>5KB cho hình). Nếu thấy bất thường, quay lại bước 4.
6. **Review với Perplexity**: Sau khi log sạch và output ổn, mở Perplexity qua MCP để:
   - Kiểm chứng chuẩn mực (ví dụ “best practice for seaborn heatmap color scaling”)
   - Hỏi cách diễn giải kết quả hoặc cải thiện phần trình bày
   - Đối chiếu với guidelines mới. Điều này giúp notebook luôn cập nhật và tránh lặp lại lỗi cũ.

## 3. Design Pattern — Tổ chức notebook & log
- **Header cell**: Thiết lập môi trường, import logger, khai báo đường dẫn output bằng `Path` tương đối. Khởi tạo logger ngay tại đây.
- **Cell phân tích**: Mỗi cell bắt đầu bằng thông điệp logger (`logger.info("Start ...")`), ghi nhận input chính, và kết thúc bằng tóm tắt kết quả. Tránh xử lý bí mật trong cell im lặng.
- **Output directory**: Duy trì cấu trúc chuẩn `notebook_stem-output/{data,charts,logs,temp}`. Không ghi đè file ngoài thư mục này; các notebook được export/convert song song nên đặt tiền tố `_` (ví dụ `_analysis.ipynb`, `_analysis.html`) để dễ nhận biết và xóa trước khi commit.
- **Validation cell**: Cuối notebook, tạo cell kiểm tra tối thiểu (ví dụ số dòng > 0, cột quan trọng tồn tại, file ảnh > 5KB). Log kết quả để truy vết nhanh và lưu lại trạng thái sau mỗi lần fix.
- **Knowledge checkpoints**: Đặt markdown cell nhắc “Tham khảo Perplexity” sau mỗi phần lớn (EDA, Modeling…) để đảm bảo thói quen hỏi lại nguồn tri thức.

## 4. Checklist nhanh
- **Trước khi chạy**
  - Kích hoạt virtualenv phù hợp với dự án
  - Kiểm tra logger tạo đúng output path
  - Bảo đảm dữ liệu đầu vào cập nhật
- **Trong khi chạy**
  - Đọc notebook theo thứ tự cell → kiểm tra log realtime hoặc sau mỗi cell lớn
  - Ghi chú bất thường vào markdown cell hoặc memory riêng
- **Sau khi chạy**
  - Đọc lại `debug.log` → không còn `ERROR`
  - Soát các file JSON/CSV/PNG
  - Gửi truy vấn Perplexity để rà best practice/ý nghĩa kết quả
  - Cập nhật `.fong/.memory` nếu có bài học mới

## 5. Tài liệu liên quan
- `.fong/instructions/fongperplexicity.md`: Cách gửi truy vấn Perplexity qua MCP.
- `.fong/instructions/instructions-notebook-ipynb-creator.md`: Framework chi tiết cho cấu trúc notebook và validation nâng cao.
- `.fong/instructions/fongmemory.md`: Quy trình lưu lại phát hiện quan trọng sau mỗi vòng debug.

**Nhớ:** Auto-debug không chỉ là “chạy notebook”. Đó là quy trình tư duy gồm logging, đọc log, sửa lỗi, kiểm tra output và cập nhật hiểu biết liên tục thông qua Perplexity.
