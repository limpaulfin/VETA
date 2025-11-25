# Hướng dẫn Cập nhật File Cụ thể từ Nhánh Remote Khác về Nhánh Chính

Tài liệu này hướng dẫn quy trình an toàn để lấy các file cụ thể từ một nhánh khác (ví dụ: `origin/feature-branch`) về nhánh chính (ví dụ: `fong`), thông qua việc tạo nhánh trung gian và sao lưu dữ liệu.

## Quy trình chuẩn

### 1. Tạo nhánh mới từ nhánh chính (thường là `fong`)

```bash
# Chuyển về nhánh chính và cập nhật
git checkout fong
git pull origin fong

# Tạo nhánh mới (đặt tên theo mẫu fong-merging-{timestamp})
git checkout -b fong-merging-$(date +%Y%m%d-%H%M%S)
```

### 2. Kiểm tra và tạo backup cho các file cần cập nhật

Đối với mỗi file cần cập nhật, kiểm tra sự tồn tại và tạo bản sao lưu:

```bash
# Kiểm tra file có tồn tại không
find ./[đường_dẫn_đến_file] -type f

# Nếu file tồn tại, tạo bản sao lưu
cp ./[đường_dẫn_đến_file] ./[đường_dẫn_đến_file]_fong.bak
```

### 3. Pull các file cụ thể từ nhánh khác vào nhánh trung gian

```bash
# Đảm bảo đã fetch tất cả các thay đổi từ remote
git fetch --all

# Checkout từng file cụ thể từ nhánh nguồn
git checkout origin/[tên_nhánh_nguồn] -- ./[đường_dẫn_đến_file]
```

### 4. Kiểm tra kỹ lưỡng các thay đổi

```bash
# Xem trạng thái các file đã thay đổi
git status

# Kiểm tra nội dung thay đổi chi tiết
git diff

# Kiểm tra chỉ tên file thay đổi
git diff --name-only
```

### 5. Commit thay đổi và merge vào nhánh chính

```bash
# Thêm tất cả thay đổi vào staging
git add .

# Commit với thông điệp rõ ràng
git commit -m "Merge các file từ nhánh [tên_nhánh_nguồn] - [mô tả ngắn]"

# Chuyển về nhánh chính và merge
git checkout fong
git merge [tên_nhánh_trung_gian]

# Đẩy lên remote
git push origin fong
```

## Ví dụ thực tế

Giả sử cần cập nhật các file JS từ nhánh `feature-navigation` vào nhánh `fong`:

```bash
# 1. Tạo nhánh mới
git checkout fong
git pull origin fong
git checkout -b fong-merging-20240530

# 2. Kiểm tra và backup file
find ./wp-content/plugins/fong_de_lms/public/js/navigation.js -type f && \
cp ./wp-content/plugins/fong_de_lms/public/js/navigation.js ./wp-content/plugins/fong_de_lms/public/js/navigation.js_fong.bak

# 3. Checkout file từ nhánh khác
git fetch --all
git checkout origin/feature-navigation -- ./wp-content/plugins/fong_de_lms/public/js/navigation.js

# 4. Kiểm tra thay đổi
git status
git diff --name-only

# 5. Commit và merge
git add .
git commit -m "Merge navigation.js từ nhánh feature-navigation - Cải tiến UI điều hướng"
git checkout fong
git merge fong-merging-20240530
git push origin fong
```

---

**Lưu ý quan trọng:**

- Luôn đặt tên rõ ràng cho nhánh trung gian, bao gồm timestamp
- Backup tất cả file trước khi ghi đè
- Kiểm tra kỹ thay đổi trước khi merge vào nhánh chính
- Nếu có xung đột, giải quyết cẩn thận và có thể cần tham vấn với người phát triển
