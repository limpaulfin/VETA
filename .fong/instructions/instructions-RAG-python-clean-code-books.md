# 📚 RAG Query Guide - Python Clean Code Books Collection

**📅 Created:** 2025-09-29  
**🎯 Purpose:** Hướng dẫn query RAG cho 9 cuốn sách Python & Clean Code
**📁 Collection Path:** `/home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books`

## 🚀 Quick Start - Query Ngay

```bash
# Syntax cơ bản - LUÔN dùng absolute path
/home/fong/Projects/mini-rag/run.sh "QUERY_TIẾNG_ANH" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books
```

## 📚 Danh Sách 9 Cuốn Sách Trong Collection

### 📂 Đường dẫn: `/home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books/`

### 📗 Clean Code & Software Engineering (3 cuốn)
1. **clean-code-martin.pdf** (3.0M) - Robert C. Martin - Clean Code: A Handbook of Agile Software Craftsmanship
2. **pragmatic-programmer.pdf** (4.3M) - Andrew Hunt & David Thomas - The Pragmatic Programmer: Your Journey to Mastery
3. **code-complete.pdf** (54M) - Steve McConnell - Code Complete: A Practical Handbook of Software Construction

### 📘 Data Science & Machine Learning (4 cuốn)
4. **data-science-beginners.pdf** (3.1M) - Andrew Park - Data Science for Beginners
5. **advanced-ml-python.pdf** (4.1M) - John Hearty - Advanced Machine Learning with Python
6. **python-data-science-williams.pdf** (4.0M) - Ethan Williams - Python for Data Science: The Ultimate Beginners' Guide
7. **python-data-science-clark.pdf** (1.5M) - Kevin Clark - Python for Data Science: The Ultimate Comprehensive Guide

### 📙 Python Basics & Research (2 cuốn)
8. **python-3-books-basics.pdf** (2.4M) - Python: 3 Books in 1 - Python Basics for Beginners
9. **code-gen-benchmarks.pdf** (168K) - Benchmarks and Metrics for Evaluations of Code Generation: A Critical Review

### 📊 Tổng quan Collection
- **Tổng số sách:** 9 files PDF
- **Tổng dung lượng:** ~76MB
- **Định dạng bổ sung:** Mỗi PDF đều có file .md tương ứng (đã convert)
- **RAG Index:** Đã build với 4,458 chunks từ 3,494 documents

## ⚡ Nguyên Tắc Query Hiệu Quả

### ✅ ĐÚNG - Query Ngắn, Cụ Thể, Nhiều Lần

```bash
# Query 1: Tìm SOLID principles
/home/fong/Projects/mini-rag/run.sh "SOLID principles single responsibility" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books

# Query 2: Tìm Open-Closed principle  
/home/fong/Projects/mini-rag/run.sh "open closed principle OCP" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books

# Query 3: Tìm Dependency Inversion
/home/fong/Projects/mini-rag/run.sh "dependency inversion principle DIP" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books
```

### ❌ SAI - Query Gộp, Phức Tạp

```bash
# TRÁNH query gộp nhiều concepts
/home/fong/Projects/mini-rag/run.sh "SOLID DRY KISS YAGNI all principles together" /path

# TRÁNH boolean operators phức tạp  
/home/fong/Projects/mini-rag/run.sh "Python AND (ML OR AI) NOT basic" /path
```

## 🎯 Query Templates Theo Từng Cuốn

### 1️⃣ Clean Code (Robert Martin)

```bash
# SOLID principles - query từng principle
/home/fong/Projects/mini-rag/run.sh "single responsibility principle SRP" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books
/home/fong/Projects/mini-rag/run.sh "interface segregation principle ISP" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books

# Clean functions
/home/fong/Projects/mini-rag/run.sh "clean functions small functions" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books
/home/fong/Projects/mini-rag/run.sh "function arguments parameters" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books

# Naming conventions
/home/fong/Projects/mini-rag/run.sh "meaningful names variable naming" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books
```

### 2️⃣ Pragmatic Programmer

```bash
# DRY principle
/home/fong/Projects/mini-rag/run.sh "DRY dont repeat yourself" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books

# Refactoring
/home/fong/Projects/mini-rag/run.sh "refactoring code smells" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books

# Debugging
/home/fong/Projects/mini-rag/run.sh "debugging techniques rubber duck" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books
```

### 3️⃣ Code Complete

```bash
# Software construction
/home/fong/Projects/mini-rag/run.sh "software construction phases" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books

# Code quality
/home/fong/Projects/mini-rag/run.sh "code quality metrics" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books

# Testing strategies
/home/fong/Projects/mini-rag/run.sh "testing strategies unit testing" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books
```

### 4️⃣ Data Science & ML Books

```bash
# NumPy basics
/home/fong/Projects/mini-rag/run.sh "numpy array operations" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books

# Pandas dataframes
/home/fong/Projects/mini-rag/run.sh "pandas dataframe manipulation" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books

# Machine learning
/home/fong/Projects/mini-rag/run.sh "supervised learning classification" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books
/home/fong/Projects/mini-rag/run.sh "neural networks deep learning" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books

# Data visualization
/home/fong/Projects/mini-rag/run.sh "matplotlib plotting graphs" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books
```

### 5️⃣ Python Basics

```bash
# Python fundamentals
/home/fong/Projects/mini-rag/run.sh "Python variables data types" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books
/home/fong/Projects/mini-rag/run.sh "Python functions parameters" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books
/home/fong/Projects/mini-rag/run.sh "Python classes objects OOP" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books

# Control structures
/home/fong/Projects/mini-rag/run.sh "Python loops for while" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books
/home/fong/Projects/mini-rag/run.sh "Python conditional if else" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books
```

## 🔀 Cross-Topic Queries

```bash
# Clean Code + Machine Learning
/home/fong/Projects/mini-rag/run.sh "clean code machine learning" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books
/home/fong/Projects/mini-rag/run.sh "testing ML models" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books

# Software Engineering + Data Science  
/home/fong/Projects/mini-rag/run.sh "software engineering data science" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books
/home/fong/Projects/mini-rag/run.sh "best practices data pipelines" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books
```

## 💡 Tips & Best Practices

### 1. **Query Nhiều Lần, Góc Độ Khác**
```bash
# Thay vì 1 query phức tạp, chia thành 3 query đơn giản
Query 1: "unit testing basics"
Query 2: "test driven development TDD"  
Query 3: "testing best practices"
```

### 2. **Dùng Technical Terms Cụ Thể**
```bash
# Tốt: Technical terms
"singleton pattern implementation"
"dependency injection container"

# Kém: Generic terms
"design patterns"
"good code"
```

### 3. **Kết Hợp Keywords Liên Quan**
```bash
# Tốt: Related keywords
"pandas dataframe merge join"
"numpy array broadcasting vectorization"

# Kém: Single keyword
"pandas"
"numpy"
```

## 🚨 Troubleshooting

### Không tìm thấy kết quả?
```bash
# 1. Thử query broader
/home/fong/Projects/mini-rag/run.sh "Python programming" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books

# 2. Check index exists
ls -la /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books/.mini_rag_index/

# 3. Force rebuild nếu cần
/home/fong/Projects/mini-rag/run.sh "test" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books --force-rebuild
```

### Query chậm?
```bash
# Check cache hoạt động
# Lần đầu: ~45s (build index)
# Lần sau: ~7-13s (dùng cache)
```

## 📊 Performance Stats

- **Index Size:** 4,458 chunks từ 3,494 documents
- **Query Time (cached):** ~7-13 seconds
- **First Run:** ~45 seconds (build index)
- **Cache Location:** `.mini_rag_index/`

## 🔧 Test Script

```bash
# Chạy test suite đầy đủ
bash /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books/test-rag-all-books.sh
```

## 📝 Quick Reference Card

```bash
# Alias cho tiện
alias ragpy='/home/fong/Projects/mini-rag/run.sh "$1" /home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books'

# Sử dụng
ragpy "SOLID principles"
ragpy "pandas dataframe"
ragpy "clean functions"
```

---

**Remember:** 
- ✅ Query ngắn, cụ thể, nhiều lần
- ✅ Technical terms chính xác
- ✅ Absolute paths
- ❌ Không query gộp phức tạp
- ❌ Không boolean operators