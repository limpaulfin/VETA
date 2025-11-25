# PDF Naming Convention Rename - Year-First Format

**Version**: 2.0.0
**Created**: 2025-10-26
**Author**: Fong
**Purpose**: Standardize PDF book file naming with year-first format for chronological sorting

---

## 🎯 Format Chuẩn (Standard Format)

```
{năm xuất bản}-{tựa sách}-{tác giả - optional}-{nhà xuất bản - optional}.PDF
```

### **Quy Tắc (Rules):**

1. **Năm Xuất Bản (Publication Year)** - **MANDATORY, FIRST POSITION**
   - Format: `YYYY` (4 chữ số)
   - Luôn đứng đầu filename
   - Nếu không có trong filename cũ: Đọc vài trang đầu của PDF để tìm năm xuất bản
   - Nếu vẫn không tìm thấy: dùng `Unknown`
   - Mục đích: Sắp xếp chronological, dễ tìm kiếm theo thời gian
   - **Tools để đọc PDF**: `pdftotext`, `PyPDF2`, hoặc `pdfplumber`

2. **Tên Sách (Book Title)** - **MANDATORY**
   - Viết hoa chữ cái đầu mỗi từ (Title Case)
   - Thay dấu cách (spaces) bằng dấu gạch ngang `-`
   - **Loại bỏ TẤT CẢ ký tự đặc biệt**: `/ \ : * ? " < > | , ; ! . & ' () [] {} ~`
   - **Chỉ giữ**: Chữ cái (A-Z, a-z), số (0-9), dấu gạch ngang `-`, dấu gạch dưới `_`
   - **OS-friendly**: Filename phải tương thích với Windows, macOS, Linux

3. **Tác Giả (Author)** - **OPTIONAL**
   - Format: `Họ-Tên` (Last-Name-First-Name)
   - Nhiều tác giả: `Tác-Giả-1_Tác-Giả-2` (dùng `_` để ngăn cách)
   - Tối đa 3 tác giả, sau đó dùng `et-al`
   - Có thể bỏ qua nếu không có thông tin

4. **Nhà Xuất Bản (Publisher)** - **OPTIONAL**
   - Tên đầy đủ hoặc viết tắt phổ biến
   - Ví dụ: `OReilly`, `Manning`, `Packt`, `Springer`, `MIT-Press`
   - Có thể bỏ qua nếu không có thông tin

5. **Ngăn Cách (Separator)**
   - Giữa các thành phần: `-` (dash only, no spaces)
   - Trong tên các phần: `-` (dash)

6. **Extension**
   - Luôn dùng `.PDF` (uppercase) để nhất quán

---

## ✅ Ví Dụ Đúng (Correct Examples)

### **1. Full Information (Year-Title-Author-Publisher)**
```
2023-Causal-Inference-and-Discovery-in-Python-Aleksander-Molak_Ajit-Jaokar-Packt.PDF
```

### **2. No Publisher**
```
2020-Hands-on-design-patterns-with-Julia-Tom-Kwong.PDF
```

### **3. No Author and Publisher (Title only)**
```
2024-Python-Automation-Bible-The-Lazy-Persons-Guide.PDF
```

### **4. Multiple Authors (3+)**
```
2009-Causality-models-reasoning-and-inference-Judea-Pearl-Cambridge-University-Press.PDF
```

### **5. Unknown Year**
```
Unknown-Programming-Collective-Intelligence-Toby-Segaran-OReilly.PDF
```

### **6. Complex Title with Subtitle**
```
2023-Elements-of-Causal-Inference-Foundations-and-Learning-Jonas-Peters_Dominik-Janzing-MIT-Press.PDF
```

---

## ❌ Ví Dụ Sai (Incorrect Examples)

### **Lỗi 1: Year không đứng đầu**
```
❌ Causal-Inference-2023-Aleksander-Molak-Packt.PDF
✅ 2023-Causal-Inference-and-Discovery-in-Python-Aleksander-Molak-Packt.PDF
```

### **Lỗi 2: Dùng dấu cách thay vì dash**
```
❌ 2023 Causal Inference and Discovery in Python.PDF
✅ 2023-Causal-Inference-and-Discovery-in-Python.PDF
```

### **Lỗi 3: Dùng ký tự đặc biệt**
```
❌ 2020-Machine-Learning:-Theory-&-Practice.PDF
✅ 2020-Machine-Learning-Theory-and-Practice.PDF

❌ 2023-Python-Automation-Bible-The-Lazy-Person's-Guide.PDF
✅ 2023-Python-Automation-Bible-The-Lazy-Persons-Guide.PDF

❌ 2019-Julia-High-Performance:-optimizations,-distributed.PDF
✅ 2019-Julia-High-Performance-optimizations-distributed.PDF
```

### **Lỗi 4: Extension lowercase**
```
❌ 2023-Python-Automation.pdf
✅ 2023-Python-Automation.PDF
```

### **Lỗi 5: Nhiều dash liên tiếp**
```
❌ 2023--Causal--Inference.PDF
✅ 2023-Causal-Inference.PDF
```

---

## 🔧 Quy Trình Rename (Rename Process)

### **Bước 1: Thu thập thông tin**
- Năm xuất bản (bắt buộc, dùng Unknown nếu không có)
- Tên sách đầy đủ
- Tên tác giả (optional, 1-3 người)
- Nhà xuất bản (optional)

### **Bước 2: Chuẩn hóa**
```bash
# Năm xuất bản
YEAR="2023"

# Loại bỏ ký tự đặc biệt từ title
TITLE="Causal Inference & Discovery in Python"
CLEAN_TITLE="Causal-Inference-and-Discovery-in-Python"

# Format tác giả
AUTHOR="Aleksander Molak, Ajit Jaokar"
CLEAN_AUTHOR="Aleksander-Molak_Ajit-Jaokar"

# Nhà xuất bản
PUBLISHER="Packt Publishing, Birmingham"
CLEAN_PUBLISHER="Packt"

# Filename
FILENAME="${YEAR}-${CLEAN_TITLE}-${CLEAN_AUTHOR}-${CLEAN_PUBLISHER}.PDF"
```

### **Bước 3: Rename**
```bash
mv "old-filename.pdf" "$FILENAME"
```

---

## 📝 Python Script Tự Động (Automated Script)

```python
#!/usr/bin/env python3
"""
Rename PDF files to year-first format:
{year}-{title}-{author-optional}-{publisher-optional}.PDF
"""

import os
import re
from pathlib import Path

def clean_component(text):
    """Remove ALL special chars, keep only alphanumeric, dash, underscore"""
    # Replace & with 'and' before cleaning
    text = text.replace('&', 'and')
    # Replace apostrophe variants with empty string
    text = text.replace("'", '').replace("'", '')  # ASCII and curly quote
    # Replace all spaces with dash
    text = re.sub(r'\s+', '-', text)
    # Remove ALL special characters - keep only: A-Z, a-z, 0-9, -, _
    text = re.sub(r'[^A-Za-z0-9\-_]', '', text)
    # Remove multiple consecutive dashes
    text = re.sub(r'-+', '-', text)
    # Strip leading/trailing dashes
    text = text.strip('-')
    return text

def parse_annas_archive_filename(filename):
    """
    Parse Anna's Archive format:
    Title -- Author -- Edition, Location, Year -- Publisher -- ISBN -- Hash -- Anna's Archive.pdf

    Returns: (year, title, author, publisher)
    """
    parts = filename.split(' -- ')

    if len(parts) < 3:
        return None, None, None, None

    # Extract title
    title = clean_component(parts[0])

    # Extract author
    author = clean_component(parts[1]) if len(parts) > 1 else ""
    # Multiple authors separated by comma
    if ',' in author:
        authors = [a.strip() for a in author.split(',')]
        author = '_'.join([clean_component(a) for a in authors[:3]])  # Max 3 authors

    # Extract year from edition field (parts[2])
    year = "Unknown"
    if len(parts) > 2:
        year_match = re.search(r'\b(19|20)\d{2}\b', parts[2])
        if year_match:
            year = year_match.group(0)

    # Extract publisher
    publisher = ""
    if len(parts) > 3:
        pub = parts[3].split(',')[0]  # Get first part before comma
        publisher = clean_component(pub)

    return year, title, author, publisher

def rename_pdf(old_path, dry_run=True):
    """Rename PDF file to year-first format"""
    old_name = old_path.name

    # Skip if already renamed
    if re.match(r'^\d{4}-', old_name):
        print(f"⏭️  Skip (already renamed): {old_name}")
        return False

    # Parse filename
    year, title, author, publisher = parse_annas_archive_filename(old_name)

    if not title:
        print(f"❌ Cannot parse: {old_name}")
        return False

    # Build new filename
    components = [year, title]
    if author:
        components.append(author)
    if publisher:
        components.append(publisher)

    new_name = '-'.join(components) + '.PDF'
    new_path = old_path.parent / new_name

    # Check if target exists
    if new_path.exists():
        print(f"⚠️  Target exists: {new_name}")
        return False

    if dry_run:
        print(f"🔍 Would rename:")
        print(f"   Old: {old_name}")
        print(f"   New: {new_name}")
    else:
        old_path.rename(new_path)
        print(f"✅ Renamed:")
        print(f"   Old: {old_name}")
        print(f"   New: {new_name}")

    return True

def main():
    import sys

    if len(sys.argv) < 2:
        print("Usage: python rename-pdfs-year-first.py <folder> [--execute]")
        sys.exit(1)

    folder = Path(sys.argv[1])
    dry_run = '--execute' not in sys.argv

    if not folder.is_dir():
        print(f"Error: {folder} is not a directory")
        sys.exit(1)

    pdf_files = sorted(folder.glob('*.pdf'))

    if not pdf_files:
        print(f"No PDF files found in {folder}")
        sys.exit(0)

    print(f"Found {len(pdf_files)} PDF files")
    print(f"Mode: {'DRY RUN (preview only)' if dry_run else 'EXECUTE (will rename)'}")
    print("-" * 80)

    renamed = 0
    for pdf_file in pdf_files:
        if rename_pdf(pdf_file, dry_run):
            renamed += 1

    print("-" * 80)
    print(f"Summary: {renamed}/{len(pdf_files)} files {'would be' if dry_run else 'were'} renamed")

    if dry_run and renamed > 0:
        print("\n⚠️  This was a DRY RUN. Run with --execute to actually rename files.")

if __name__ == '__main__':
    main()
```

---

## 🎯 Lợi Ích (Benefits)

### **1. Chronological Sorting**
- ✅ Files tự động sắp xếp theo thời gian (year first)
- ✅ Dễ dàng tìm sách mới nhất / cũ nhất
- ✅ Theo dõi evolution of knowledge

### **2. OS Compatibility**
- ✅ Works on Windows, macOS, Linux
- ✅ No spaces in filename
- ✅ Safe for cloud sync (Dropbox, Google Drive)

### **3. Searchability**
- ✅ Easy to find by year: `smart-search-fz-rg-bm25 "2023" PDFs/ --show-content` (fallback: `rg "2023-" PDFs/`)
- ✅ Easy to find by title: `smart-search-fz-rg-bm25 "Causal Inference" PDFs/ --top-k 5` (fallback: `rg "Causal-Inference" PDFs/`)
- ✅ Easy to find by author: `smart-search-fz-rg-bm25 "Aleksander Molak" PDFs/ --show-content` (fallback: `rg "Aleksander-Molak" PDFs/`)

### **4. Flexibility**
- ✅ Author optional (for anonymous/collective works)
- ✅ Publisher optional (for self-published/unknown)
- ✅ Graceful handling of missing info

### **5. Script-Friendly**
- ✅ Predictable structure for parsing
- ✅ Year always at position 0
- ✅ Easy regex matching: `^\d{4}-`

---

## 📂 Folder Organization

### **Recommended Structure:**
```
PDFs/
├── Science-ML-AI-Books/
│   ├── README.md (naming convention)
│   ├── 2023-Causal-Inference-and-Discovery-in-Python-Aleksander-Molak-Packt.PDF
│   ├── 2022-Hands-On-Machine-Learning-3rd-Ed-Aurelien-Geron-OReilly.PDF
│   ├── 2020-Hands-on-design-patterns-with-Julia-Tom-Kwong-Packt.PDF
│   └── ...
├── Business-Books/
│   ├── README.md
│   └── ...
└── NAMING_CONVENTION_YEAR_FIRST.md (this file)
```

---

## 🚨 Special Cases

### **1. Multiple Editions**
```
2020-Clean-Code-2nd-Edition-Robert-Martin-Prentice-Hall.PDF
2008-Clean-Code-1st-Edition-Robert-Martin-Prentice-Hall.PDF
```

### **2. Translated Books**
```
2018-Lược-Sử-Loài-Người-Vietnamese-Yuval-Noah-Harari-Tre.PDF
```

### **3. Unknown Year**
```
Unknown-Machine-Learning-Basics-John-Doe.PDF
```

### **4. No Author or Publisher**
```
2024-Python-Automation-Bible.PDF
```

### **5. Very Long Titles (> 100 chars)**
```
2023-Deep-Learning-and-XAI-Techniques-for-Anomaly-Detection-Cher-Simon_Jeff-Barr-Packt.PDF
```

---

## 📋 Checklist Before Rename

- [ ] Xác định năm xuất bản (bắt buộc)
- [ ] Xác định tên sách chính xác
- [ ] Xác định tác giả (optional, tối đa 3 người)
- [ ] Xác định nhà xuất bản (optional)
- [ ] Loại bỏ ký tự đặc biệt
- [ ] Thay dấu cách bằng dấu gạch ngang
- [ ] Year đứng đầu filename
- [ ] Extension là `.PDF` (uppercase)
- [ ] Kiểm tra tên file < 255 ký tự
- [ ] Test script với --dry-run trước khi execute

---

## 🔗 References

- **Project**: mini-rag
- **Location**: `/home/fong/Projects/mini-rag/PDFs/`
- **Related**: `.fong/instructions/instructions-dkm-sources-knowledgebase.md`
- **Old convention**: `.fong/instructions/instructions-pdf-naming-convention.md`

---

## 📝 Comparison with Old Format

### **Old Format (v1.0.0)**
```
Title - Author - Publisher - Year.pdf
```
Example:
```
Causal-Inference-and-Discovery-in-Python - Aleksander-Molak_Ajit-Jaokar - Packt - 2023.pdf
```

### **New Format (v2.0.0)**
```
Year-Title-Author-Publisher.PDF
```
Example:
```
2023-Causal-Inference-and-Discovery-in-Python-Aleksander-Molak_Ajit-Jaokar-Packt.PDF
```

### **Key Differences:**
1. Year moved to first position for chronological sorting
2. Author and Publisher are now optional
3. No spaces in separator (dash only)
4. Extension changed to uppercase `.PDF`
5. More flexible for incomplete metadata

---

**Last Updated**: 2025-10-26
**Maintained by**: Fong
