# HƯỚNG DẪN DỊCH THUẬT NGỮ TIẾNG ANH SANG TIẾNG VIỆT HỌC THUẬT

**File**: `instructions-vietnamese-academic-translation.md`  
**Version**: 2025-09-14  
**Purpose**: Quy trình hệ thống để dịch thuật ngữ tiếng Anh sang tiếng Việt học thuật trong manuscript  

---

## 1. OVERVIEW - TỔNG QUAN

### 1.1. Mục đích
Chuyển đổi manuscript từ trạng thái pha lẫn tiếng Anh-Việt sang **tiếng Việt học thuật hoàn toàn**, đảm bảo:
- ✅ Không còn thuật ngữ tiếng Anh không cần thiết
- ✅ Giữ nguyên độ chính xác khoa học  
- ✅ Tuân thủ chuẩn viết học thuật Việt Nam
- ✅ Bảo mật nội bộ (remove RAG references)

### 1.2. Nguyên tắc THINK ULTRA
- **Systematic Approach**: Tiếp cận có hệ thống, không bỏ sót
- **Multiple Verification**: Kiểm tra nhiều lần, nhiều cách
- **Quality First**: Chất lượng quan trọng hơn tốc độ
- **Double Check Always**: Luôn double check mọi bước

---

## 2. WORKFLOW - QUY TRÌNH 7 BƯỚC

### Step 1: Setup & Preparation
```bash
# 1.1. Tạo backup file
cp target-file.md target-file.md.bak

# 1.2. Khởi tạo TodoWrite tracking
TodoWrite: [
  ☐ Scan lần 1: Tìm tất cả thuật ngữ tiếng Anh
  ☐ Dịch thuật ngữ từ scan lần 1  
  ☐ Scan lần 2: Tìm thuật ngữ còn sót lại
  ☐ Dịch thuật ngữ từ scan lần 2
  ☐ Scan lần 3: Kiểm tra cuối cùng
  ☐ Dịch thuật ngữ từ scan lần 3  
  ☐ Double check: Xác nhận không còn tiếng Anh
]
```

### Step 2: Sliding Window Reading (Scan Round 1)
```bash
# Đọc file theo chunks 100-200 LOC
Read(file_path, offset=0, limit=100)
Read(file_path, offset=100, limit=100) 
Read(file_path, offset=200, limit=100)
# ... cho đến hết file
```

**Mục tiêu**: Tìm tất cả thuật ngữ tiếng Anh trong file

### Step 3: Translation Round 1
```bash
# Sử dụng MultiEdit cho nhiều thuật ngữ cùng lúc
MultiEdit(file_path, edits=[
  {old_string: "Critical Success Factors", new_string: "Các Yếu tố Thành công Quan trọng"},
  {old_string: "governance", new_string: "quản trị"},
  {old_string: "benchmarking", new_string: "đánh giá so sánh"},
  # ... thêm các thuật ngữ khác
])
```

**Update TodoWrite**: ✅ Mark completed

### Step 4: Scan Round 2 (Verification)
```bash
# Đọc lại file để tìm thuật ngữ còn sót
Read(file_path, offset=0, limit=100)
# Tìm các thuật ngữ mới hoặc bị miss trong lần 1
```

### Step 5: Translation Round 2
```bash
# Dịch các thuật ngữ tìm được trong scan lần 2
MultiEdit(file_path, edits=[...])
```

### Step 6: Final Scan & Quality Check
```bash
# Scan lần cuối bằng Grep để tìm tất cả thuật ngữ tiếng Anh
Grep(pattern="[A-Za-z]+", path=file_path, output_mode="content", head_limit=50)

# Hoặc tìm thuật ngữ cụ thể
Grep(pattern="RAG|Evidence|Framework", path=file_path, output_mode="content")
```

### Step 7: Final Translation & Verification  
```bash
# Dịch các thuật ngữ cuối cùng
Edit/MultiEdit(file_path, ...)

# Double check không còn thuật ngữ tiếng Anh
Grep(pattern="\\b[A-Za-z]{3,}\\b", path=file_path, output_mode="content")
```

---

## 3. TRANSLATION STANDARDS - CHUẨN DỊCH THUẬT

### 3.1. Thuật ngữ Quản lý Chất lượng

| English | Vietnamese Academic | 
|---------|-------------------|
| Critical Success Factors | Các Yếu tố Thành công Quan trọng |
| governance | quản trị | 
| benchmarking | đánh giá so sánh |
| peer-reviewed | được đánh giá đồng nghiệp |
| evidence-based | dựa trên bằng chứng khoa học |
| best practices | thực hành tốt nhất |
| compliance level | mức độ tuân thủ |
| risk mitigation | giảm thiểu rủi ro |
| success metrics | chỉ số thành công |
| KPI framework | khung chỉ số hiệu suất |

### 3.2. Thuật ngữ ISO & Standards

| English | Vietnamese Academic |
|---------|-------------------|
| HACCP | HACCP (Phân tích Mối nguy hại và Điểm Kiểm soát Tới hạn) |
| GMP | GMP (Thực hành Sản xuất Tốt) |
| ISO 22000 | ISO 22000 (Hệ thống Quản lý An toàn Thực phẩm) |
| WHO | Tổ chức Y tế Thế giới |
| FAO | Tổ chức Lương thực và Nông nghiệp Liên hợp quốc |

### 3.3. Thuật ngữ Kinh doanh & Tài chính

| English | Vietnamese Academic |
|---------|-------------------|
| ROI | ROI (Tỷ suất Hoàn vốn Đầu tư) |
| CAGR | Tốc độ tăng trưởng kép hàng năm |
| SMART principles | nguyên tắc SMART |
| Enhanced | Nâng cao |
| USD | đôla Mỹ |
| VND | đồng |

---

## 4. SECURITY & PRIVACY - BẢO MẬT

### 4.1. Remove Internal References
**PHẢI REMOVE** các tham chiếu nội bộ:
- ❌ `RAG system` 
- ❌ `cơ sở tri thức RAG`
- ❌ `hệ thống tri thức RAG`
- ❌ `từ RAG database`

**REPLACE WITH**:
- ✅ `nguồn nghiên cứu chuyên ngành`
- ✅ `dữ liệu nghiên cứu`  
- ✅ `nghiên cứu ngành`

### 4.2. Data Validation
Kiểm tra các năm/dữ liệu cũ:
```bash
# Tìm các năm trong file
Grep(pattern="\\b(19|20)\\d{2}\\b", path=file_path)

# Xác nhận tất cả năm đều phù hợp (2019-2030)
```

---

## 5. TOOLS & COMMANDS - CÔNG CỤ

### 5.1. File Operations
```bash
# Backup
cp file.md file.md.bak

# Read with sliding window  
Read(file_path, offset=X, limit=100)

# Multiple edits
MultiEdit(file_path, edits=[...])

# Single edit
Edit(file_path, old_string="...", new_string="...")
```

### 5.2. Search & Verification
```bash
# Tìm thuật ngữ tiếng Anh
Grep(pattern="[A-Za-z]+", path=file_path, output_mode="content")

# Tìm thuật ngữ cụ thể
Grep(pattern="RAG|Evidence|Framework", path=file_path)

# Tìm năm
Grep(pattern="\\b(19|20)\\d{2}\\b", path=file_path)
```

### 5.3. Progress Tracking
```bash
# Khởi tạo tracking
TodoWrite(todos=[...])

# Cập nhật progress
TodoWrite(todos=[
  {content: "Task 1", status: "completed"},
  {content: "Task 2", status: "in_progress"},
  ...
])
```

---

## 6. QUALITY CHECKLIST - DANH SÁCH KIỂM TRA

### 6.1. Before Starting
- [ ] File được backup (.bak)
- [ ] TodoWrite được khởi tạo
- [ ] Hiểu rõ yêu cầu dịch thuật

### 6.2. During Process
- [ ] Đọc file theo sliding window (100-200 LOC)
- [ ] Scan ít nhất 3 lần
- [ ] Dịch thuật ngữ theo chuẩn học thuật
- [ ] Update TodoWrite theo progress

### 6.3. After Completion
- [ ] Double check không còn thuật ngữ tiếng Anh
- [ ] Remove hết RAG references
- [ ] Kiểm tra dữ liệu/năm hợp lệ
- [ ] Verify file integrity

---

## 7. TROUBLESHOOTING - XỬ LÝ LỖI

### 7.1. Common Issues
**Problem**: MultiEdit báo "No changes to make"
**Solution**: Check old_string và new_string khác nhau

**Problem**: String not found trong file  
**Solution**: Đọc lại context xung quanh, check exact matching

**Problem**: Too many matches cho replace
**Solution**: Thêm context hoặc dùng `replace_all: true`

### 7.2. Best Practices
- Luôn đọc file trước khi edit (Read tool requirement)
- Dùng MultiEdit cho nhiều changes cùng lúc
- Backup file quan trọng
- Track progress với TodoWrite
- Double check cuối cùng

---

## 8. EXAMPLE WORKFLOW - VÍ DỤ THỰC TẾ

```bash
# Step 1: Setup
cp 0-loi-mo-dau-enhanced.md 0-loi-mo-dau-enhanced.md.bak

# Step 2: Initialize tracking  
TodoWrite([
  {content: "Scan lần 1", status: "pending"},
  {content: "Dịch lần 1", status: "pending"},
  # ...
])

# Step 3: Sliding window scan
Read(file_path, offset=0, limit=100)
Read(file_path, offset=100, limit=100)
# Identify: "Critical Success Factors", "governance", etc.

# Step 4: Translate round 1
MultiEdit(file_path, edits=[
  {old_string: "Critical Success Factors", new_string: "Các Yếu tố Thành công Quan trọng"},
  {old_string: "governance", new_string: "quản trị"},
])

# Step 5: Update progress
TodoWrite([
  {content: "Scan lần 1", status: "completed"},
  {content: "Dịch lần 1", status: "completed"},
  {content: "Scan lần 2", status: "in_progress"},
])

# Step 6: Continue with scan round 2...
# Step 7: Final verification
Grep(pattern="\\b[A-Za-z]{3,}\\b", path=file_path)
```

---

## 9. SUCCESS METRICS - THƯỚC ĐO THÀNH CÔNG

### 9.1. Completion Criteria
- ✅ 0 thuật ngữ tiếng Anh không cần thiết
- ✅ 100% thuật ngữ được dịch đúng chuẩn
- ✅ 0 tham chiếu RAG/nội bộ  
- ✅ Tất cả TodoWrite tasks completed
- ✅ File integrity được bảo toàn

### 9.2. Quality Indicators
- **Accuracy**: Thuật ngữ dịch chính xác về mặt nghĩa
- **Consistency**: Cùng thuật ngữ, cùng cách dịch
- **Academic Style**: Tuân thủ chuẩn viết học thuật
- **Completeness**: Không bỏ sót thuật ngữ nào

---

**📝 Note**: File này được tạo dựa trên quy trình thực tế đã áp dụng thành công cho việc dịch manuscript Vinamilk ISO 9001:2015. Tuân thủ nghiêm ngặt quy trình này để đảm bảo chất lượng cao và tính nhất quán.p