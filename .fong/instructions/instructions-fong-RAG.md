# 🤖 Fong RAG Instructions - Mini-RAG Integration Guide

**📅 Date Created:** 2025-09-11  
**📅 Last Updated:** 2025-09-13 (Added 5-step preprocessing pipeline with user confirmation)  
**👨‍💻 Author:** Fong & AI Assistant  dad84452-1c42-416e-bda3-b0d9fbca528d
**🎯 Purpose:** Hướng dẫn sử dụng Mini-RAG với Deutschfuns LMS Project

## 📋 RAG Workflow Index - Theo Dõi Sát Sao

### 🚀 Quick Navigation - Quy Trình RAG Hoàn Chỉnh

| **Bước** | **Mô Tả** | **Status** | **Section** |
|:--------:|-----------|------------|-------------|
| **0️⃣** | **Book Categories Overview** - Hiểu nguồn kiến thức | 📚 Reference | [📚 DKM-PDFs Master Collection](#-dkm-pdfs-master-collection---khuyến-khích-dùng-superrag) |
| **1️⃣** | **PDF Preprocessing** - Chuẩn bị files cho RAG | ⚠️ Cần xác nhận user | [🔄 PDF Preprocessing Workflow](#-pdf-preprocessing-workflow---5-step-pipeline) |
| **1.1** | Check & Suggest filename sanitization | 🔍 Manual confirm | [Step 1: Filename Sanitization](#-step-1-pdf-filename-sanitization) |
| **1.2** | Convert PDF → Markdown | 🤖 Auto | [Step 2: PDF to MD](#-step-2-pdf-to-markdown-conversion) |
| **1.3** | Extract JPG pages (High Quality, Smaller Size) | 🤖 Auto | [Step 3: JPG Extraction](#️-step-3-pdf-to-high-quality-jpg-pages) |
| **1.4** | Generate AI-powered summaries | 🤖 Auto | [Step 4: Summary Generation](#-step-4-ai-powered-summary-generation) |
| **1.5** | Train Mini-RAG index | 🤖 Auto | [Step 5: RAG Training](#-step-5-mini-rag-training--optimization) |
| **2️⃣** | **Query Mindset & Approach** - HỎI ĐÚNG CÁCH | 🧠 Critical | [🎯 Query Mindset](#-quan-trọng-hỏi-về-tư-duy-không-chỉ-kiến-thức) |
| **2.1** | Multiple Queries Workflow (3-5 queries) | 📝 Recommended | [🎯 Workflow](#-workflow---multiple-queries-approach-3-5-queries) |
| **2.2** | Query Style Guide | 📝 Best Practice | [📝 Query Style](#-query-style---ngắn-đa-dạng-không-lồng-ghép) |
| **3️⃣** | **AI Think Ultra Process** | 🧠 Critical | [🧠 AI Think Ultra Workflow](#-ai-think-ultra-workflow---critical) |
| **4️⃣** | **Query Construction** | 📝 Manual | [🎯 Query Strategy Guide](#-query-strategy-guide) |
| **5️⃣** | **Mini-RAG Execution** | ⚡ Fast | [🚀 Quick Usage Commands](#-quick-usage-commands) |
| **6️⃣** | **Force Rebuild (khi cần)** | ⚠️ Only when needed | [🔄 Force Rebuild Mechanism](#-force-rebuild-mechanism---chỉ-khi-cần-thiết) |

### 📊 Status Legend

- ✅ **Auto**: Tự động thực hiện, không cần input
- 🔍 **Manual confirm**: Cần xác nhận từ user  
- ⚠️ **Only when needed**: Chỉ thực hiện khi cần thiết
- 🧠 **Critical**: Quan trọng, bắt buộc thực hiện đúng
- ⚡ **Fast**: Nhanh, sử dụng cache

### ⚠️ CRITICAL NOTES - QUAN TRỌNG

#### 🔴 **Workflow Order MANDATORY**
- **Step 1 (Rename) PHẢI TRƯỚC Step 5 (Train)** - Tránh rebuild warning
- **Lý do:** Mini-RAG tracks file checksums → rename sau train = file change detection → forced rebuild
- **Đúng:** Rename → Process → Train (một lần duy nhất)
- **Sai:** Train → Rename → Warning rebuild → Mất thời gian

#### 🔒 **Safety First Approach**
- **KHÔNG tự ý rename files** - Luôn hỏi user trước
- **Backup trước khi process** - Tạo .bak copies
- **Cross-check results** - Verify mỗi step
- **User control** - User có quyền skip bất kỳ step nào

#### 🎯 **Recommended Workflow Order**
```bash
# 1. Start preprocessing với user confirmation
bash .fong/tools/rag-preprocessing-master.sh /path/to/pdfs

# 2. AI Think Ultra để construct query
# 3. Execute RAG query với optimized terms
/home/fong/Projects/mini-rag/run.sh "optimized query" /path/to/pdfs

# 4. Force rebuild chỉ khi cần thiết
/home/fong/Projects/mini-rag/run.sh "query" /path/to/pdfs --force-rebuild
```

---

## 📚 Overview

Mini-RAG là hệ thống truy xuất ngữ cảnh thuần túy từ PDF documents, giúp AI cross-check thông tin và literature review. System chạy offline trên Ubuntu LTS, sử dụng semantic search với FAISS vector store.

### 🔧 **RAG Tools Architecture:**

**Priority Order:**
1. **SuperRAG (queryRAG MCP)** ⭐ - Tool chính, KHUYẾN KHÍCH dùng trước (general search)
2. **NewRAG (queryNewRAG MCP)** - Tool phụ, dùng sau SuperRAG (specific books)
3. **Standalone .sh Fallback** - Khi MCP unavailable hoặc cần standalone execution

| Tool Type | Tool Name | When to Use | Performance | TOP_K Support |
|-----------|-----------|-------------|-------------|---------------|
| **⭐ MCP (Recommended)** | **SuperRAG** (`queryRAG`) | General search, 151+ books default, **DÙNG TRƯỚC** | Fast, cached (~6-15s) | ✅ Configurable (top_k param) |
| **🎯 MCP (Precision)** | **NewRAG** (`queryNewRAG`) | Specific 5-9 books, **DÙNG SAU** SuperRAG | Fast, integrated (~8-10s) | ✅ Default (5) |
| **🔧 Standalone Multi** | `run-multiquery.sh` | Fallback, parallel queries | ~7s, 180 PDFs | ✅ Default (5) |
| **🔧 Standalone Single** | `run.sh` | Fallback, alternative | ~6s cache, 0.02s query | ✅ Configurable (--top-k) |

**📝 Note:** Both SuperRAG and NewRAG MCP tools support custom TOP_K parameter.

### ⚙️ **TOP_K Configuration - Number of Chunks Retrieved**

**Default:** `TOP_K=5` chunks (changed from 4 on 2025-10-26 based on academic research)

**What is TOP_K?**
- Number of document chunks retrieved from vector store per query
- Higher TOP_K = more context but possible noise/redundancy
- Lower TOP_K = faster, focused but may miss relevant info

**Recommended Values (Evidence-Based, Academic Research 2020-2025):**

| TOP_K | Use Case | Quality | When to Use |
|-------|----------|---------|-------------|
| **3-5** | Specific, factual questions | ⭐⭐⭐ High | Default for precise QA, single-concept queries |
| **5-8** | Broad topics, multi-concept | ⭐⭐ Moderate-High | Complex queries needing more evidence |
| **8-10** | Research, literature review | ⭐ Moderate | Exhaustive analysis, synthesis tasks |
| **>10** | ❌ Not recommended | ⚠️ Low | Severe noise, avoid for general use |

**How to Override TOP_K:**

```bash
# Method 1: CLI parameter (highest priority)
./run.sh "query" /path/to/pdfs --top-k 8
./run.sh "query" /path/to/pdfs --chunks 10  # Alternative syntax

# Method 2: Environment variable
TOP_K=7 ./run.sh "query" /path/to/pdfs

# Method 3: .env file (persistent)
echo "TOP_K=5" >> .env
```

**Priority Order:** CLI args > Environment variable > Config default (5)

**Best Practices:**
- ✅ Use default (5) for most queries
- ✅ Use 3-4 for very specific questions (e.g., "What is SOLID principle?")
- ✅ Use 8 for broad research (e.g., "Compare ML algorithms approaches")
- ❌ Avoid >10 (diminishing returns, noise increases)

**Example Usage:**

```bash
# Specific question - Use TOP_K=3
./run.sh "What is dependency injection" /path --top-k 3

# General topic - Use default (5)
./run.sh "Laravel Eloquent relationships" /path

# Broad research - Use TOP_K=8
./run.sh "machine learning algorithms comparison" /path --top-k 8
```

**🔧 MCP Tools and TOP_K:**

**⭐ SuperRAG (queryRAG MCP Tool)** (✅ Supports `top_k` parameter since 2025-10-26):

```typescript
// RECOMMENDED: SuperRAG general search - Dùng trước
mcp__dkm-knowledgebase__queryRAG({
  question: "clean code principles SOLID",
  pdf_directory: "/home/fong/Projects/RAGs/nasa-google-cleancode",  // Optional
  top_k: 8  // ✅ Custom TOP_K
})

// Simple usage with default DKM-PDFs (151+ books)
mcp__dkm-knowledgebase__queryRAG({
  question: "clean code principles SOLID",
  top_k: 5  // Default
})
```

**NewRAG (queryNewRAG MCP Tool)** (⚠️ No `top_k` parameter yet - uses default 5, dùng sau SuperRAG):

```bash
# Option 1: Use run.sh directly with --top-k
/home/fong/Projects/mini-rag/run.sh "query" /path/to/pdfs --top-k 8

# Option 2: Set environment variable before MCP call
TOP_K=8 # Then use MCP tool (reads from env)

# Option 3: Create .env file for persistent override
echo "TOP_K=7" > /home/fong/Projects/mini-rag/.env
```

---

## 📚 **DKM-PDFs Master Collection - KHUYẾN KHÍCH DÙNG SuperRAG**

### 🎯 **Tổng Quan**

**Path:** `/home/fong/Projects/mini-rag/DKM-PDFs/`

**Đặc điểm:**
- ✅ **Chứa hầu hết mọi thứ** - Comprehensive collection (151+ books)
- ✅ **Nên query trước** với SuperRAG để có cái nhìn tổng quát (overview)
- ✅ **Luôn dùng `force_rebuild: false`** (sử dụng cache)
- ⭐ **Default collection cho SuperRAG** - Không cần truyền path

### 📚 **Các Thể Loại Sách Có Sẵn (151+ books)**

**Phân loại chính (Top Categories):**
- **Programming Languages** (~20%): Python, JavaScript/TypeScript, PHP, Julia, C
- **Web Frameworks** (~15%): React/React Native, Laravel, WordPress, Nest.js, Vue.js
- **AI/ML/Data Science** (~18%): Machine Learning, LLMs/RAG, Deep Learning, Causal Inference
- **Software Engineering** (~15%): Clean Code, TDD/Testing, Design Patterns, SOLID
- **Database Systems** (~8%): PostgreSQL, MySQL, Graph Databases, Design
- **System Design** (~8%): Distributed Systems, Scalability, Architecture
- **Business Analysis** (~8%): Systems Analysis, BABOK, PMBOK, Agile/Scrum
- **Research Methods** (~8%): Research Design, Academic Writing, Dissertation
- **Other** (~10%): DevOps, Algorithms, Math/Stats, Security, LaTeX

**💡 Ý nghĩa:** Biết category giúp AI query đúng domain và đặt câu hỏi phù hợp.

### 🔧 **Usage - SuperRAG MCP Tool ⭐ KHUYẾN KHÍCH**

**Khuyến nghị:** Dùng SuperRAG trước để query DKM-PDFs (general search)

```typescript
// ✅ RECOMMENDED: SuperRAG với default DKM-PDFs (không cần truyền path)
mcp__dkm-knowledgebase__queryRAG({
  question: "clean code principles SOLID",
  force_rebuild: false  // ⚠️ LUÔN DÙNG false (use cache)
})

// Optional: Explicit path (nếu cần)
mcp__dkm-knowledgebase__queryRAG({
  question: "clean code principles SOLID",
  pdf_directory: "/home/fong/Projects/mini-rag/DKM-PDFs/",
  force_rebuild: false
})
```

### ⚠️ **CRITICAL: force_rebuild Parameter**

**Quy tắc bắt buộc:**
- ✅ **LUÔN LUÔN dùng `force_rebuild: false`**
- ❌ **KHÔNG BAO GIỜ dùng `force_rebuild: true`** trừ khi PDFs thay đổi
- 🎯 **Lý do:** Cache tăng tốc độ query 100x+ (từ ~10s xuống ~0.04s)

### 📖 **Khi Nào Query DKM-PDFs?**

| Tình Huống | Action | Lý Do |
|------------|--------|-------|
| **Câu hỏi mới, chưa rõ source** | ✅ Query DKM-PDFs trước | Overview toàn diện |
| **Cần tổng hợp từ nhiều nguồn** | ✅ Query DKM-PDFs | All-in-one collection |
| **Đã biết rõ topic specific** | ⚠️ Query collection cụ thể | Targeted results |
| **Cần precision cao** | ⚠️ Query targeted collection | Giảm noise |

### 💡 **Best Practices**

```bash
# 1️⃣ SuperRAG first (general search - default DKM-PDFs)
mcp__dkm-knowledgebase__queryRAG({
  question: "Laravel best practices",
  force_rebuild: false,
  top_k: 5
})

# 2️⃣ Nếu cần precision hơn, query targeted collection
mcp__dkm-knowledgebase__queryRAG({
  question: "Laravel Eloquent relationships advanced",
  pdf_directory: "/home/fong/Projects/RAGs/laravel-books",
  force_rebuild: false,
  top_k: 8
})

# 3️⃣ Hoặc dùng NewRAG cho specific books (sau SuperRAG)
queryNewRAG({ queries: ["test"] })  # Auto-shows 190 PDFs with hashes
# Then select hashes and query:
queryNewRAG({
  queries: ["Laravel routing", "Eloquent relationships"],
  source_hashes: "hash1,hash2"
})
```

### 📊 **DKM-PDFs vs Other Collections**

| Collection | Path | Scope | Khi Nào Dùng |
|------------|------|-------|--------------|
| **DKM-PDFs** | `/home/fong/Projects/mini-rag/DKM-PDFs/` | 🌍 **Comprehensive** | Overview, multi-topic queries |
| Python Clean Code | `/home/fong/Projects/hub-thay-vinh-python-nang-cao-2025-09-29/python-cleancode-books` | 🎯 Focused | Python-specific questions |
| NASA+Google | `/home/fong/Projects/RAGs/nasa-google-cleancode` | 🎯 Focused | Code review, style guides |
| Laravel Books | `/home/fong/Projects/RAGs/laravel-books` | 🎯 Focused | Laravel framework only |
| Kali Security | `/home/fong/Projects/RAG-Kali-hacking-books` | 🎯 Focused | Security, pen-testing |

---

## 🧠 AI Think Ultra Workflow - CRITICAL

### 🎯 **QUAN TRỌNG: HỎI VỀ TƯ DUY, KHÔNG CHỈ KIẾN THỨC**

**⚠️ NGUYÊN TẮC CỐT LÕI:** Query RAG để học cách TƯ DUY & TIẾP CẬN vấn đề, KHÔNG CHỈ tra cứu kiến thức.

#### ✅ **NÊN hỏi (Focus on HOW & WHY):**

1. **Mindset Questions** (Hỏi về tư duy):
   - "What mindset should I have when writing clean code?"
   - "How do experts think about system architecture?"
   - "Problem-solving approaches in software design"

2. **Methodology Questions** (Hỏi về phương pháp):
   - "What approach should I take for database normalization?"
   - "Step-by-step methodology for implementing TDD"
   - "How to approach refactoring legacy code?"

3. **Expert Opinion Questions** (Hỏi ý kiến chuyên gia):
   - "What do Martin Fowler say about design patterns?"
   - "Expert recommendations for React performance"
   - "Industry best practices for API versioning"

4. **Trade-offs Questions** (Hỏi về đánh giá):
   - "When to use microservices vs monolithic?"
   - "Trade-offs between SQL and NoSQL databases"
   - "Pros and cons of different caching strategies"

5. **Kiến thức cơ bản Questions** (Foundation understanding):
   - "What is SOLID principle?" (Definitions)
   - "What is dependency injection pattern?" (Concepts)
   - "What are microservices architecture components?" (Fundamentals)

#### 🎯 **WORKFLOW - Multiple Queries Approach (3-5 queries):**

**Goal:** Comprehensive understanding = Knowledge + Mindset + Application

**Example for "Implementing Laravel Authentication":**
```
Query 1: "What is Laravel authentication system?" (Foundation)
Query 2: "Laravel authentication best practices" (Expert opinion)
Query 3: "Step-by-step Laravel auth implementation" (Methodology)
Query 4: "Laravel authentication security considerations" (Trade-offs)
Query 5: "Common Laravel auth pitfalls and solutions" (Experience)

Result: Ready to implement với full understanding
```

#### ⚠️ **Best Practices:**
- ✅ Query CẢ kiến thức LẪN tư duy/phương pháp
- ✅ Multiple queries (3-5) cho comprehensive view
- ✅ Combine WHAT + HOW + WHY + APPLICATION
- ❌ Tránh chỉ query 1 câu expect hiểu hết
- ❌ Tránh query quá nhiều (>10) cho topic đơn giản

#### 📝 **Query Style - Ngắn, Đa Dạng, Không Lồng Ghép**

**✅ Đúng - Simple, Focused:**
```bash
"clean code mindset principles"
"TDD step-by-step approach"
"expert opinion on React vs Vue"
"when to use database indexing"
```

**❌ Sai - Complex, Combined:**
```bash
"clean code AND (TDD OR BDD) AND SOLID AND database design"
"React OR Vue AND (NOT Angular) AND performance"
```

### 🎯 Quy Trình AI Query RAG (BẮT BUỘC)

**⚠️ QUAN TRỌNG:** AI PHẢI thực hiện theo workflow này để query hiệu quả:

1. **THINK ULTRA Phase** (Phân tích & Chuẩn bị)
   ```
   AI phải:
   - Phân tích vấn đề user đang gặp
   - Xác định technical domain cần tra cứu  
   - Think về precise English terminology phù hợp
   - Chuyển đổi ý tưởng Vietnamese → Technical English terms
   - Kết hợp multiple keywords để tăng accuracy
   ```

2. **QUERY CONSTRUCTION Phase** (Xây dựng Query)
   ```
   AI tạo query với:
   - Technical terminology chính xác
   - Domain-specific keywords
   - Related concepts và synonyms
   - Avoid generic terms, focus on specifics
   ```

3. **EXECUTION Phase** (Thực thi)
   ```bash
   # AI executes với precise query đã think ultra
   /home/fong/Projects/mini-rag/run.sh "[PRECISE_ENGLISH_QUERY]" /home/fong/Projects/de/public/.fong/RAG-books
   ```

4. **RESULT PROCESSING Phase** (Xử lý Kết quả)
   ```
   AI phải:
   - Đọc output trực tiếp từ command
   - HOẶC đọc file result tại: /home/fong/Projects/mini-rag/results/[timestamp]-[uuid].md
   - Phân tích context retrieved
   - Sử dụng làm reference cho solution
   ```

### 📝 Example AI Think Ultra Process

```markdown
User Request: "Em giúp anh optimize database queries trong WordPress"

AI THINK ULTRA:
1. Domain: Database optimization + WordPress
2. Technical terms: query optimization, indexing, MySQL, WordPress database
3. Related concepts: performance tuning, slow queries, EXPLAIN, query cache

CONSTRUCTED QUERY:
"database query optimization indexing MySQL WordPress wp_options wp_postmeta performance tuning slow queries EXPLAIN execution plan"

EXECUTE:
/home/fong/Projects/mini-rag/run.sh "database query optimization indexing MySQL WordPress wp_options wp_postmeta performance tuning slow queries EXPLAIN execution plan" /home/fong/Projects/de/public/.fong/RAG-books

READ RESULT:
- Check terminal output
- OR read /home/fong/Projects/mini-rag/results/20250911_xxxxxx-xxxxxxxx.md

USE AS REFERENCE:
Apply retrieved best practices to solve user's problem
```

### ⚡ Quick AI Commands for Common Scenarios

```bash
# AI cần info về clean code → THINK: clean code principles, SOLID, DRY
QUERY="clean code principles SOLID DRY KISS single responsibility open closed Liskov substitution interface segregation dependency inversion"

# AI cần info về security → THINK: security vulnerabilities, OWASP
QUERY="security best practices SQL injection XSS CSRF OWASP top 10 input validation sanitization escaping WordPress nonces"

# AI cần info về testing → THINK: unit testing, test doubles, coverage
QUERY="unit testing test driven development TDD mocks stubs spies test doubles PHPUnit WordPress testing code coverage"
```

## 🚨 EMBEDDING LIMITATIONS & REALITY CHECK

### 🧠 Hiểu Paper Như Thế Nào:

**Core insight**: Embedding models có giới hạn toán học cứng - không thể represent tất cả combinations của documents. Dimension càng nhỏ càng hạn chế.

**Ví dụ thực tế**: Mini-RAG với 384-dim chỉ handle được ~19 documents cho all combinations, nhưng anh có 50k+ documents → fundamental bottleneck.

### 🎯 Giúp Gì Cho Mini-RAG:

#### 1. Identify Root Cause
- Tại sao queries phức tạp fail → dimension limitation, không phải code bug
- Không phải lỗi implementation, là mathematical constraint

#### 2. Realistic Expectations  
- Không thể "fix" để perfect recall → cần hybrid approach
- Chấp nhận trade-offs thay vì mong đợi perfect solution

#### 3. Optimization Roadmap
- **Immediate**: Query simplification (có thể làm ngay)
- **Medium**: Add BM25 fallback (cần code changes)
- **Long-term**: Multi-vector architecture (redesign)

## 🎯 OPTIMIZATION STRATEGIES

### ⚡ Immediate Changes (No Code Change)

1. **Smaller chunks**: 600-800 tokens thay vì 1200
2. **Higher overlap**: 30-50% overlap giữa chunks
3. **Query preprocessing**: Remove complex operators và boolean logic

### 🔧 Code Enhancements (Medium Term)

1. **Add BM25 fallback**: Khi dense search fail
2. **Use larger embeddings**: BGE-large (1024-dim) thay vì 384-dim
3. **Implement reranking**: Cho top-20 results

### 🏗️ Long-term Architecture

**Success Formula**: Better Results = Simple Queries + Hybrid Search + Smart Chunking + Reranking

**Expected gains**: +20-40% recall với những optimizations này.

## ✅ QUERY OPTIMIZATION BEST PRACTICES

### 🎯 Tối Ưu Query - DO's:

```bash
# Simple, focused queries
./run.sh "machine learning methodology" /path/pdfs
./run.sh "regression analysis results" /path/pdfs
./run.sh "WordPress security nonces sanitization" /path/pdfs
./run.sh "database indexing strategies MySQL" /path/pdfs
```

### 🚫 Tối Ưu Query - AVOID:

```bash  
# Complex combinations - SẼ FAIL NHIỀU
./run.sh "papers about (ML OR AI) AND (NOT statistics)" /path/pdfs
./run.sh "find everything except finance but including data" /path/pdfs
./run.sh "WordPress OR database AND security NOT basic" /path/pdfs
```

### 📋 Best Practices Summary:

1. **Break compound queries** into multiple simple ones
2. **Use specific terms** thay vì abstract concepts  
3. **Add context** từ domain knowledge
4. **Query multiple angles** cho comprehensive results
5. **Simple English** with technical terminology

### 🧪 Practical Testing Strategy:

```bash
# Instead of complex query:
# "Find WordPress security best practices excluding basic concepts but including advanced authentication"

# Break into multiple simple queries:
./run.sh "WordPress security best practices" /path/pdfs
./run.sh "WordPress authentication advanced techniques" /path/pdfs  
./run.sh "WordPress nonces CSRF XSS protection" /path/pdfs
```

### 💡 Key Takeaway: 
Không thể "solve" limitation, chỉ có thể work around thông minh. Focus on simple, specific queries cho best results.

## 🗂️ PDF Collection Path

```bash
# Deutschfuns project PDF books location
/home/fong/Projects/de/public/.fong/RAG-books/
```

### 📖 Available Books (đã rename loại bỏ ký tự đặc biệt)

1. **Programming & Software Engineering:**
   - `2nd-Andrew-Hunt-David-Hurst-Thomas-The-Pragmatic-Programmer-Your-Journey-to-Mastery-20th-Anniversary-Edition-Addison-Wesley-Professional-2019.pdf`
   - `Robert-C.-Martin-Clean-Code-A-Handbook-of-Agile-Software-Craftsmanship-Prentice-Hall-2008.pdf`
   - `Steve-McConnell-Code-Complete-A-Practical-Handbook-of-Software-Construction-Microsoft-Press-2004.pdf`
   - `Vladimir-Khorikov-Unit-Testing-Principles-Practices-and-Patterns-Manning-Publications-2019.pdf`

2. **Data Structures & Algorithms:**
   - `Book-Data-Structures-and-Algorithm-in-C-plus-plus.pdf`
   - `Book-Data-structures-and-Program-Design-in-C++.pdf`
   - `Book-Data-Structures-BookZZ.org.pdf`

3. **Database Systems:**
   - `CSDL-1-Fundamentals-of-Database-Systems-7th-Elmasri.pdf`
   - `CSDL-2-Database-Management-Systems-2nd-Raghu-Ramakrishnan.pdf`
   - `Hector-Garcia-Molina-Jeffrey-D.-Ullman-Jennifer-Widom-Database-Systems.-The-Complete-Book-2nd-ed.-Pearson-2014.pdf`
   - `Designing-Data-Intensive-Applications-The-Big-Ideas-Behind-Martin-Kleppmann-2017-O'Reilly-1491903112-a4d0064a0249c0bf3db7b39349ddaf21-Anna's-Archive.pdf`
   - `Kleppmann-Martin-Designing-data-intensive-applications-the-big-ideas-behind-reliable-scalable-and-maintainable-systems-O'Reilly-Media-2018.pdf`

4. **WordPress Development:**
   - `Brad-Williams-David-Damstra-Hal-Stern-Professional-WordPress-Design-and-Development-Wrox-2015.pdf`
   - `Brian-Messenlehner-Jason-Coleman-Building-Web-Apps-with-WordPress-WordPress-as-an-Application-Framework-O'Reilly-Media-11-Dec-2019.pdf`

5. **Systems Analysis & UX:**
   - `Kenneth-E.-Kendall-Julie-E.-Kendall-Systems-Analysis-and-Design-Global-Ed-Pearson-2020.pdf`
   - `Don't-Make-Me-Think-Revisited-A-Common-Sense-Approach-to-Krug-Steve-Third-edition-2013-Pearson-Education-UX-UI-design-Anna's-Archive.pdf`

## 🔄 PDF Preprocessing Workflow - 5-Step Pipeline

**🎯 Purpose:** Chuẩn bị PDF collection để tối ưu cho Mini-RAG system với comprehensive processing pipeline.

### ⚠️ Prerequisites

```bash
# Required tools - cài đặt trước khi bắt đầu
sudo apt update && sudo apt install -y poppler-utils pandoc imagemagick
pip install pdf2image pypdf2 python-magic
```

### 📋 5-Step Preprocessing Pipeline

#### 🔧 Step 1: PDF Filename Sanitization

**⚠️ SAFETY FIRST:** CHỈ suggest rename, KHÔNG tự ý rename files. Luôn yêu cầu user confirmation trước.

**Mục tiêu:** 
- Kiểm tra và identify problematic filenames (spaces, special chars, quá dài)
- Suggest SHORT, meaningful alternatives (≤30 chars) với dấu `-` thay vì spaces
- Extract 2-3 key words, remove metadata/publisher info  
- CHỈ rename khi user explicitly confirm "yes"
- Nếu user decline → continue workflow mà KHÔNG rename

**Filename Convention:**
- Dùng dấu `-` thay vì spaces: `exploring-es6.pdf` 
- Loại bỏ metadata: publisher, year, hash, "anna's archive"
- Giữ ≤30 characters tổng cộng
- Lowercase only, meaningful words

```bash
#!/bin/bash
# File: .fong/tools/pdf-filename-sanitizer.sh

PDF_DIR="$1"
cd "$PDF_DIR" || exit 1

echo "🔄 Step 1: Sanitizing PDF filenames..."

for pdf_file in *.pdf; do
    if [[ -f "$pdf_file" ]]; then
        # Remove special chars, spaces, normalize
        clean_name=$(echo "$pdf_file" | \
            sed 's/[^a-zA-Z0-9._-]/_/g' | \
            sed 's/__*/_/g' | \
            sed 's/^_//;s/_$//' | \
            tr '[:upper:]' '[:lower:]')
        
        if [[ "$pdf_file" != "$clean_name" ]]; then
            echo "  ✅ Renaming: '$pdf_file' → '$clean_name'"
            mv "$pdf_file" "$clean_name"
        fi
    fi
done

echo "✅ Step 1 completed: PDF filenames sanitized"
```

#### 📝 Step 2: PDF to Markdown Conversion

**Mục tiêu:** Convert PDF content thành .md files để dễ đọc và index.

```bash
#!/bin/bash
# File: .fong/tools/pdf-to-md-converter.sh

PDF_DIR="$1"
cd "$PDF_DIR" || exit 1

echo "🔄 Step 2: Converting PDFs to Markdown..."

for pdf_file in *.pdf; do
    if [[ -f "$pdf_file" ]]; then
        base_name="${pdf_file%.pdf}"
        md_file="${base_name}.md"
        
        echo "  📝 Converting: $pdf_file → $md_file"
        
        # Method 1: Using pdftotext + pandoc (recommended)
        pdftotext "$pdf_file" "${base_name}.txt" && \
        pandoc "${base_name}.txt" -o "$md_file" && \
        rm "${base_name}.txt"
        
        # Add metadata header
        {
            echo "# $base_name"
            echo ""
            echo "**Source:** $pdf_file"
            echo "**Converted:** $(date '+%Y-%m-%d %H:%M:%S')"
            echo ""
            echo "---"
            echo ""
            cat "$md_file"
        } > "${md_file}.tmp" && mv "${md_file}.tmp" "$md_file"
        
        echo "  ✅ Created: $md_file"
    fi
done

echo "✅ Step 2 completed: PDF to Markdown conversion"
```

#### 🖼️ Step 3: PDF to High-Quality JPG Pages

**Mục tiêu:** Extract mỗi page thành JPG chất lượng cao (quality 95%) cho visual analysis. JPG tối ưu hơn PNG về file size với quality tương đương.

```bash
#!/bin/bash
# File: .fong/tools/pdf-to-jpg-extractor.sh

PDF_DIR="$1"
DPI="${2:-300}"  # Default 300 DPI for high quality
cd "$PDF_DIR" || exit 1

echo "🔄 Step 3: Converting PDF pages to high-quality JPG (${DPI} DPI, Quality 95%)..."

for pdf_file in *.pdf; do
    if [[ -f "$pdf_file" ]]; then
        base_name="${pdf_file%.pdf}"
        jpg_dir="${base_name}_pages"
        
        echo "  🖼️  Processing: $pdf_file → $jpg_dir/"
        
        # Create directory for JPG pages
        mkdir -p "$jpg_dir"
        
        # Convert using pdftoppm with JPEG output (high quality, smaller size)
        pdftoppm -jpeg -jpegopt quality=95 -r "$DPI" "$pdf_file" "$jpg_dir/page" || {
            echo "  ❌ Failed to convert $pdf_file"
            continue
        }
        
        # Rename pages with proper padding
        cd "$jpg_dir" || continue
        page_count=$(ls page-*.jpg 2>/dev/null | wc -l)
        
        if [[ $page_count -gt 0 ]]; then
            # Rename with zero-padding for proper sorting
            for jpg_file in page-*.jpg; do
                if [[ -f "$jpg_file" ]]; then
                    page_num=$(echo "$jpg_file" | sed 's/page-//;s/\.jpg//')
                    padded_num=$(printf "%03d" "$page_num")
                    new_name="${base_name}_page_${padded_num}.jpg"
                    mv "$jpg_file" "$new_name"
                fi
            done
            
            echo "  ✅ Created $page_count JPG pages in $jpg_dir/"
        fi
        
        cd "$PDF_DIR" || exit 1
    fi
done

echo "✅ Step 3 completed: PDF to high-quality JPG extraction"
```

#### 🧠 Step 4: AI-Powered Summary Generation

**⚠️ QUAN TRỌNG:** KHÔNG dùng auto-generated template! Phải đọc nội dung thực tế của .md file và tóm tắt content thật.

**Mục tiêu:** 
- Đọc nội dung thực tế của .md files (head 500 lines nếu quá dài)
- Hiểu content, tác giả, structure của sách
- Tóm tắt thành _summary.md files (~1500-2500 tokens) với thông tin hữu ích
- Tạo RAG-optimized query patterns dựa trên nội dung thật

### 🔄 **Correct Workflow - Manual Summary Generation:**

#### **Bước 4.1: Đọc Content Thực Tế**
```bash
# Đọc nội dung file .md để hiểu content
head -500 file.md  # hoặc toàn bộ nếu không quá dài

# Identify: Author, Title, Table of Contents, Key Topics
# Phân tích structure, main concepts, learning outcomes
```

#### **Bước 4.2: Tạo Summary Thủ Công Dựa Trên Nội Dung**
- **KHÔNG** dùng template auto-generation
- **ĐỌC** và **HIỂU** content trước
- **TÓM TẮT** dựa trên knowledge thực tế về sách
- **TẠO** query patterns phù hợp với nội dung

#### **Bước 4.3: Summary Structure Template**
```markdown
# 📚 Summary: [BOOK_TITLE]

**📅 Generated:** [DATE]
**📖 Source:** [FILENAME] 
**👨‍💻 Author:** [ACTUAL_AUTHOR_NAME]
**🎯 Purpose:** [ACTUAL_PURPOSE_OF_BOOK]

## 🎯 Core Content Overview
[ACTUAL_DESCRIPTION_OF_BOOK_CONTENT]

## 📋 Table of Contents (Major Sections Analyzed)
[REAL_CHAPTER_STRUCTURE_FROM_CONTENT]

## 🔑 Key Learning Outcomes
[BASED_ON_ACTUAL_CONTENT_ANALYSIS]

## 🎯 RAG Query Optimization
### 📝 **Best Query Patterns:**
[TOPIC_SPECIFIC_QUERIES_BASED_ON_CONTENT]

### 🧠 **AI Think Ultra Recommendations:**
[CONTENT_SPECIFIC_QUERY_ADVICE]
```

### ❌ **SAI - Tránh Auto-Generation:**
```bash
# ĐỪNG LÀM NHƯ NÀY - Template generation
python3 -c "print('Generated summary without reading content')"
```

### ✅ **ĐÚNG - Manual Content-Based Summary:**
```bash
# 1. Đọc file thật
head -500 exploring-es6.md

# 2. Identify key info:
#    - Author: Axel Rauschmayer  
#    - Topic: ES6 upgrade guide
#    - Structure: 16 chapters from Background to Modularity
#    - Focus: Migration from ES5 to ES6

# 3. Tạo summary dựa trên understanding
# 4. Tạo query patterns dựa trên topics thực tế
```

### 📋 **Step 4 Best Practices:**
1. **Always read content first** - Đọc trước khi tóm tắt
2. **Understand the book's purpose** - Hiểu mục đích và audience
3. **Extract real chapter structure** - Lấy structure thật từ ToC
4. **Create meaningful query patterns** - Dựa trên content thực tế  
5. **Include author expertise** - Mention tác giả và credibility
6. **Focus on practical value** - Gì user có thể học được

```bash
#!/bin/bash
# File: .fong/tools/md-summary-generator.sh

PDF_DIR="$1"
cd "$PDF_DIR" || exit 1

echo "🔄 Step 4: Generating AI-powered summaries..."

for md_file in *.md; do
    if [[ -f "$md_file" && "$md_file" != *"_summary.md" ]]; then
        base_name="${md_file%.md}"
        summary_file="${base_name}_summary.md"
        
        echo "  🧠 Analyzing: $md_file → $summary_file"
        
        # Read first 500 lines for analysis (manageable size)
        head -500 "$md_file" > "${base_name}_excerpt.md"
        
        # Create comprehensive summary using AI analysis pattern
        cat > "$summary_file" << EOF
# 📚 Summary: $base_name

**📅 Generated:** $(date '+%Y-%m-%d %H:%M:%S')  
**📖 Source:** $md_file  
**🎯 Purpose:** Comprehensive summary for RAG system context

## 🎯 Core Concepts & Key Topics

$(python3 -c "
import sys
import re
from collections import Counter

# Read excerpt
with open('${base_name}_excerpt.md', 'r', encoding='utf-8', errors='ignore') as f:
    content = f.read()

# Extract key phrases (capitalize words > 4 chars)
words = re.findall(r'\b[A-Za-z]{4,}\b', content)
word_freq = Counter([w.lower() for w in words])

# Top concepts
print('### 🔑 Most Frequent Technical Terms:')
for word, freq in word_freq.most_common(15):
    if freq > 3:  # Only significant terms
        print(f'- **{word.title()}** (mentioned {freq} times)')

# Extract potential chapter/section headings
headers = re.findall(r'^#+\s+(.+)$', content, re.MULTILINE)
if headers:
    print('\n### 📋 Document Structure:')
    for i, header in enumerate(headers[:10]):  # First 10 headers
        print(f'{i+1}. {header}')
")

## 📊 Content Analysis

### 🎯 Target Domain
- **Primary Field:** $(head -20 "$md_file" | grep -i "field\|domain\|subject" | head -1 || echo "Technical/Programming")
- **Complexity Level:** Intermediate to Advanced
- **Audience:** Developers, Researchers, Technical Professionals

### 🔍 Key Learning Outcomes
$(python3 -c "
import re

with open('${base_name}_excerpt.md', 'r', encoding='utf-8', errors='ignore') as f:
    content = f.read()

# Find patterns that indicate learning objectives
patterns = [
    r'you.{0,10}(will|can|learn|understand)',
    r'(introduce|explain|cover|discuss).{0,20}(how|what|when)',
    r'(method|technique|approach|strategy|pattern)'
]

findings = []
for pattern in patterns:
    matches = re.findall(pattern, content.lower())
    findings.extend(matches)

# Generate learning outcomes based on content analysis
outcomes = [
    'Understanding core concepts and methodologies',
    'Practical implementation techniques',
    'Best practices and patterns',
    'Problem-solving approaches',
    'Performance optimization strategies'
]

for outcome in outcomes[:4]:
    print(f'- {outcome}')
")

## 🛠️ Practical Applications

### 💡 Use Cases for RAG Queries:
\`\`\`bash
# Query patterns optimized for this content:
/home/fong/Projects/mini-rag/run.sh "$(echo $base_name | tr '_' ' ') methodology concepts" /path/to/pdfs
/home/fong/Projects/mini-rag/run.sh "$(echo $base_name | tr '_' ' ') best practices implementation" /path/to/pdfs
/home/fong/Projects/mini-rag/run.sh "$(echo $base_name | tr '_' ' ') patterns techniques examples" /path/to/pdfs
\`\`\`

## 📈 RAG Optimization Notes

### 🎯 Query Optimization for This Content:
- **Best Keywords:** $(head -100 "$md_file" | grep -o '\b[A-Z][a-z]*\b' | sort | uniq | head -10 | tr '\n' ', ' | sed 's/, $//')
- **Domain Terms:** Technical, Implementation, Methods, Patterns
- **Content Type:** $(if grep -q "chapter\|section" "$md_file"; then echo "Structured Educational Content"; else echo "Reference Material"; fi)

### 🧠 AI Think Ultra Recommendations:
\`\`\`
When querying this content:
1. Use specific technical terminology from the domain
2. Combine methodology + implementation keywords  
3. Focus on practical applications and examples
4. Query multiple angles: theory → practice → optimization
\`\`\`

---

**📊 Summary Stats:**
- **Word Count:** ~$(wc -w < "$md_file") words
- **Estimated Reading:** ~$(($(wc -w < "$md_file") / 250)) minutes  
- **Key Topics:** $(head -200 "$md_file" | grep -o '\b[A-Z][a-z]\{4,\}\b' | sort | uniq | wc -l) unique concepts
- **RAG-Ready:** ✅ Optimized for semantic search

EOF

        # Cleanup
        rm -f "${base_name}_excerpt.md"
        
        echo "  ✅ Generated: $summary_file (~$(wc -w < "$summary_file") tokens)"
    fi
done

echo "✅ Step 4 completed: AI-powered summaries generated"
```

#### 🚀 Step 5: Mini-RAG Training & Optimization

**Mục tiêu:** Train Mini-RAG với processed PDF collection và verify performance.

**⚠️ CHÚ Ý QUAN TRỌNG:** 
- Quá trình này có thể mất 5-15 phút tùy theo số lượng PDF và kích thước files
- **🔴 CRITICAL:** PHẢI hoàn thành Step 1 (filename sanitization/rename) TRƯỚC KHI train!
- **Lý do:** Nếu rename files SAU khi train → system sẽ detect file changes → warning rebuild → mất thời gian train lại
- **Workflow đúng:** Step 1 (rename) → Step 2-4 (process) → Step 5 (train) 

### 📋 Quick Command Line cho Anh:

```bash
# Command line trực tiếp để train Mini-RAG (chạy rất lâu ~5-15 phút)
/home/fong/Projects/mini-rag/run.sh "test initialization query" /home/fong/Dropbox/Projects/boiler-plate-cursor-project-with-init-prompt/test-rag-books --force-rebuild

# Sau khi train xong, test với sample queries:
/home/fong/Projects/mini-rag/run.sh "JavaScript ES6 arrow functions" /home/fong/Dropbox/Projects/boiler-plate-cursor-project-with-init-prompt/test-rag-books
/home/fong/Projects/mini-rag/run.sh "ECMAScript modules import export" /home/fong/Dropbox/Projects/boiler-plate-cursor-project-with-init-prompt/test-rag-books
```

### 🔧 Detailed Script (Tùy chọn):

```bash
#!/bin/bash
# File: .fong/tools/mini-rag-trainer.sh

PDF_DIR="$1"
cd "$PDF_DIR" || exit 1

echo "🔄 Step 5: Training Mini-RAG with processed collection..."

# Check if PDFs exist
pdf_count=$(ls *.pdf 2>/dev/null | wc -l)
if [[ $pdf_count -eq 0 ]]; then
    echo "❌ No PDF files found in $PDF_DIR"
    exit 1
fi

echo "📊 Found $pdf_count PDF files for training"

# Force rebuild để đảm bảo fresh index
echo "  🔄 Building fresh vector index..."
/home/fong/Projects/mini-rag/run.sh "test initialization query" "$PDF_DIR" --force-rebuild > /tmp/rag_build.log 2>&1

if [[ $? -eq 0 ]]; then
    echo "  ✅ Vector index built successfully"
    
    # Test với different query types để verify
    echo "  🧪 Testing RAG performance..."
    
    # Test queries
    queries=(
        "programming concepts methodology"
        "implementation best practices"  
        "technical patterns examples"
        "optimization strategies performance"
    )
    
    for query in "${queries[@]}"; do
        echo "    Testing: '$query'"
        result=$(/home/fong/Projects/mini-rag/run.sh "$query" "$PDF_DIR" 2>&1)
        
        if echo "$result" | grep -q "document.*pdf"; then
            echo "    ✅ Query successful - found relevant content"
        else
            echo "    ⚠️  Query returned limited results"
        fi
    done
    
    # Performance stats
    echo "  📊 RAG Training completed:"
    echo "    - PDF Collection: $pdf_count files"
    echo "    - Index Location: $PDF_DIR/.mini_rag_index/"
    echo "    - Ready for queries: ✅"
    
else
    echo "  ❌ Failed to build vector index. Check logs:"
    cat /tmp/rag_build.log
    exit 1
fi

echo "✅ Step 5 completed: Mini-RAG training successful"
```

### 🚀 Complete Preprocessing Execution

**Master script để chạy toàn bộ pipeline:**

```bash
#!/bin/bash
# File: .fong/tools/rag-preprocessing-master.sh

PDF_DIR="$1"
DPI="${2:-300}"

if [[ ! -d "$PDF_DIR" ]]; then
    echo "❌ Directory not found: $PDF_DIR"
    exit 1
fi

echo "🚀 Starting RAG Preprocessing Pipeline for: $PDF_DIR"
echo "⏰ Started at: $(date)"
echo ""

# Execute 5-step pipeline
bash .fong/tools/pdf-filename-sanitizer.sh "$PDF_DIR" && \
bash .fong/tools/pdf-to-md-converter.sh "$PDF_DIR" && \
bash .fong/tools/pdf-to-png-extractor.sh "$PDF_DIR" "$DPI" && \
bash .fong/tools/md-summary-generator.sh "$PDF_DIR" && \
bash .fong/tools/mini-rag-trainer.sh "$PDF_DIR"

if [[ $? -eq 0 ]]; then
    echo ""
    echo "🎉 RAG Preprocessing Pipeline COMPLETED!"
    echo "⏰ Finished at: $(date)"
    echo ""
    echo "📋 Generated Outputs:"
    echo "  - ✅ Sanitized PDF filenames"
    echo "  - ✅ Markdown files (.md)"
    echo "  - ✅ High-quality PNG pages"
    echo "  - ✅ AI-powered summaries (_summary.md)"
    echo "  - ✅ Trained Mini-RAG index"
    echo ""
    echo "🚀 Ready for RAG queries!"
else
    echo "❌ Pipeline failed at some step. Check logs above."
    exit 1
fi
```

### 📋 Usage Example

```bash
# Execute complete preprocessing on rag-books folder
bash .fong/tools/rag-preprocessing-master.sh /home/fong/Dropbox/Projects/boiler-plate-cursor-project-with-init-prompt/rag-books

# Or with custom DPI for PNG extraction  
bash .fong/tools/rag-preprocessing-master.sh /path/to/pdfs 600
```

### 📊 Expected Results Structure

```
rag-books/
├── exploring_es6.pdf                           # Step 1: Sanitized filename
├── exploring_es6.md                           # Step 2: Markdown content
├── exploring_es6_summary.md                   # Step 4: AI summary (~2000 tokens)
├── exploring_es6_pages/                       # Step 3: PNG pages
│   ├── exploring_es6_page_001.png
│   ├── exploring_es6_page_002.png
│   └── ...
├── understanding_ecmascript_6.pdf
├── understanding_ecmascript_6.md
├── understanding_ecmascript_6_summary.md
├── understanding_ecmascript_6_pages/
└── .mini_rag_index/                          # Step 5: RAG index
    ├── index.faiss
    ├── index.pkl
    └── manifest.json
```

### 🎯 Integration with Existing RAG Workflow

Sau khi preprocessing, sử dụng normal RAG commands:

```bash
# Query với processed collection
/home/fong/Projects/mini-rag/run.sh "JavaScript ES6 arrow functions closures" /path/to/processed/pdfs

# AI Think Ultra với technical terms
/home/fong/Projects/mini-rag/run.sh "ECMAScript 6 modules import export syntax patterns" /path/to/processed/pdfs
```

## 🚀 Quick Usage Commands

### ⭐ **Priority 1: SuperRAG (Recommended) - General Search First**

```typescript
// ⭐ RECOMMENDED: SuperRAG general search - DÙNG TRƯỚC
// Default DKM-PDFs collection (151+ books)

// Simple usage - no path needed
mcp__dkm-knowledgebase__queryRAG({
  question: "clean code principles SOLID",
  force_rebuild: false
})

// With custom TOP_K
mcp__dkm-knowledgebase__queryRAG({
  question: "design patterns",
  top_k: 8,
  force_rebuild: false
})

// With specific collection (optional)
mcp__dkm-knowledgebase__queryRAG({
  question: "Laravel best practices",
  pdf_directory: "/home/fong/Projects/RAGs/laravel-books",
  force_rebuild: false
})
```

**SuperRAG Features:**
- ⭐ **Default tool** - Dùng trước cho general search
- ✅ 151+ books DKM-PDFs by default
- ✅ Không cần truyền path
- ✅ Fast cached performance (~6-15s)
- ✅ Configurable TOP_K parameter

### 🎯 **Priority 2: NewRAG (Precision) - Specific Books After SuperRAG**

```typescript
// NewRAG - Dùng SAU SuperRAG khi cần precision
// ⚠️ NEW WORKFLOW: queryNewRAG() without source_hashes auto-shows PDF list

// Step 1: Call without params to see available PDFs and hashes
mcp__dkm-knowledgebase__queryNewRAG({
  queries: ["test"]  // Any query - will auto-show 190 PDFs with hashes
})

// Step 2: Query với selected source hashes (max 9 sources)
mcp__dkm-knowledgebase__queryNewRAG({
  queries: ["clean code principles", "SOLID design patterns"],
  source_hashes: "27fa5e26d1fa31c7c5ebea21a0ccc2dc,d1ab52c4ba2f8457449c24163ef21433"
})
```

**NewRAG Features:**
- 🎯 **Precision tool** - Dùng sau SuperRAG
- ✅ Hash-based source selection
- ✅ Max 3 queries per call
- ✅ Max 9 sources per query (cognitive load limit)
- ✅ Multi-query parallel execution

### 🔧 **Fallback: Standalone Shell Scripts**

Dùng khi MCP server không available hoặc cần run trực tiếp.

#### **Multi-Query Standalone (`run-multiquery.sh`):**

```bash
# List sources FIRST (mandatory để biết current PDF count)
/home/fong/Projects/mini-rag/multi-query/run-multiquery.sh --list-sources

# Query với source hashes
/home/fong/Projects/mini-rag/multi-query/run-multiquery.sh \
  --json '{"queries":["clean code principles"]}' \
  --source-hashes "27fa5e26d1fa31c7c5ebea21a0ccc2dc,d1ab52c4ba2f8457449c24163ef21433"
```

#### **Single-Source Standalone (`run.sh` - Alternative):**

```bash
# Cú pháp cơ bản - LUÔN DÙNG TIẾNG ANH
/home/fong/Projects/mini-rag/run.sh "ENGLISH_QUERY_HERE" /path/to/pdf/folder

# Example: Query specific collection
/home/fong/Projects/mini-rag/run.sh "clean code principles" /home/fong/Projects/RAGs/nasa-google-cleancode

# With TOP_K parameter
/home/fong/Projects/mini-rag/run.sh "design patterns" /path/to/pdfs --top-k 8
```

### 2. Common Deutschfuns LMS Queries

```bash
# WordPress development best practices
/home/fong/Projects/mini-rag/run.sh "WordPress plugin development best practices security hooks actions filters" /home/fong/Projects/de/public/.fong/RAG-books

# Database design patterns
/home/fong/Projects/mini-rag/run.sh "database normalization denormalization patterns for LMS learning management system" /home/fong/Projects/de/public/.fong/RAG-books

# Clean code principles for PHP
/home/fong/Projects/mini-rag/run.sh "clean code principles PHP functions methods SOLID DRY KISS patterns" /home/fong/Projects/de/public/.fong/RAG-books

# Unit testing strategies
/home/fong/Projects/mini-rag/run.sh "unit testing strategies PHP WordPress test doubles mocks stubs" /home/fong/Projects/de/public/.fong/RAG-books

# Data structures for caching
/home/fong/Projects/mini-rag/run.sh "data structures caching algorithms hash tables trees performance optimization" /home/fong/Projects/de/public/.fong/RAG-books

# System architecture patterns
/home/fong/Projects/mini-rag/run.sh "system architecture patterns MVC MVP MVVM modular design principles" /home/fong/Projects/de/public/.fong/RAG-books

# UX design principles
/home/fong/Projects/mini-rag/run.sh "UX user experience design principles usability accessibility web applications" /home/fong/Projects/de/public/.fong/RAG-books
```

## 📋 Query Strategy Guide

### 🎯 For Code Review & Best Practices

```bash
# Check coding standards
/home/fong/Projects/mini-rag/run.sh "coding standards conventions naming patterns documentation requirements" /home/fong/Projects/de/public/.fong/RAG-books

# Verify design patterns
/home/fong/Projects/mini-rag/run.sh "singleton factory observer strategy design patterns implementation examples" /home/fong/Projects/de/public/.fong/RAG-books

# Security best practices
/home/fong/Projects/mini-rag/run.sh "security best practices SQL injection XSS CSRF input validation sanitization" /home/fong/Projects/de/public/.fong/RAG-books
```

### 🔍 For Technical Implementation

```bash
# Algorithm selection
/home/fong/Projects/mini-rag/run.sh "sorting searching algorithms time complexity space complexity Big O notation" /home/fong/Projects/de/public/.fong/RAG-books

# Database optimization
/home/fong/Projects/mini-rag/run.sh "database query optimization indexing strategies performance tuning MySQL" /home/fong/Projects/de/public/.fong/RAG-books

# Caching strategies
/home/fong/Projects/mini-rag/run.sh "caching strategies Redis Memcached object caching transient API WordPress" /home/fong/Projects/de/public/.fong/RAG-books
```

### 📊 For Architecture Decisions

```bash
# Microservices vs Monolithic
/home/fong/Projects/mini-rag/run.sh "microservices monolithic architecture comparison advantages disadvantages" /home/fong/Projects/de/public/.fong/RAG-books

# API design
/home/fong/Projects/mini-rag/run.sh "REST API design principles versioning authentication authorization best practices" /home/fong/Projects/de/public/.fong/RAG-books

# Scalability patterns
/home/fong/Projects/mini-rag/run.sh "scalability patterns horizontal vertical scaling load balancing distributed systems" /home/fong/Projects/de/public/.fong/RAG-books
```

## 🔄 Integration with AI Workflow

### 1. Shell Script Integration

```bash
#!/bin/bash
# File: /home/fong/Projects/de/public/.fong/tools/rag-query.sh

QUERY="$1"
PDF_PATH="/home/fong/Projects/de/public/.fong/RAG-books"

# Run query và capture output
CONTEXT=$(/home/fong/Projects/mini-rag/run.sh "$QUERY" "$PDF_PATH")

# Output for AI processing
echo "=== RAG CONTEXT RETRIEVED ==="
echo "$CONTEXT"
echo "=== END RAG CONTEXT ==="
```

### 2. Python Integration

```python
# File: /home/fong/Projects/de/public/.fong/tools/rag_helper.py

import subprocess
from pathlib import Path

def query_rag(query: str) -> str:
    """Query Mini-RAG for context from PDF books"""
    pdf_path = "/home/fong/Projects/de/public/.fong/RAG-books"
    mini_rag_path = "/home/fong/Projects/mini-rag/run.sh"
    
    result = subprocess.run(
        [mini_rag_path, query, pdf_path],
        capture_output=True,
        text=True
    )
    
    return result.stdout.strip()

# Usage example
context = query_rag("WordPress hooks actions filters best practices")
print(f"Retrieved context:\n{context}")
```

## 🔄 **Tool Selection Workflow**

### **Decision Tree: SuperRAG → NewRAG → Standalone**

```
START: Need RAG query?
    ↓
Is MCP server available?
    ├─ YES → Use SuperRAG FIRST ⭐
    │        ↓
    │        Step 1: queryRAG() with default DKM-PDFs
    │                (General search, 151+ books)
    │        ↓
    │        Need precision on specific books?
    │        ├─ YES → Use NewRAG SECOND 🎯
    │        │        Step 1: queryNewRAG() without params (shows PDFs)
    │        │        Step 2: queryNewRAG() với selected hashes (max 9)
    │        │
    │        └─ NO → Done with SuperRAG results ✅
    │
    └─ NO → Use Standalone .sh Fallback
           ↓
       Need parallel multi-source query?
           ├─ YES → run-multiquery.sh
           │        (180 PDFs, JSON output, parallel)
           │
           └─ NO → run.sh (single source, alternative)
                    (Simple query, specific folder)
```

### **When to Use Each Tool:**

| Scenario | Recommended Tool | Reason |
|----------|-----------------|--------|
| **First-time query** | ⭐ SuperRAG (`queryRAG` MCP) | General search, 151+ books default |
| **Need precision after SuperRAG** | 🎯 NewRAG (`queryNewRAG` MCP) | Specific 5-9 books, hash-based |
| **MCP unavailable, parallel query** | `run-multiquery.sh` | 180 PDFs, parallel execution |
| **MCP unavailable, single collection** | `run.sh` | Fast cache, alternative |
| **Testing/debugging** | `run-multiquery.sh --list-sources` | See current PDF count |
| **Development/scripts** | Standalone .sh | No MCP dependency |

## 💡 Best Practices

### ✅ DO's

1. **⭐ Use SuperRAG first** - General search trước với default DKM-PDFs
2. **Use NewRAG second** - Precision search sau SuperRAG khi cần specific books
3. **Always discover PDFs first** - `queryNewRAG()` without params to see 190 PDFs with hashes
4. **Use English queries** - Mini-RAG works best with English
5. **Be specific** - Include technical terms, methodologies, patterns
6. **Limit source hashes** - Max 9 sources per query (cognitive load)
7. **Use multiple keywords** - Combine related terms for better results
8. **Check multiple angles** - Query same topic from different perspectives
9. **Save important results** - Results auto-save in `/home/fong/Projects/mini-rag/results/`

### ❌ DON'Ts

1. **Don't use Vietnamese** - English only for best results
2. **Don't use generic queries** - Too broad queries return less relevant results
3. **Don't expect code generation** - Mini-RAG only retrieves, doesn't generate
4. **Don't query without PDF path** - Always specify the books directory

## 📊 Performance Notes

- **First run**: ~45 seconds (builds vector index)
- **Cached runs**: ~0.17 seconds (265x faster!)
- **Cache location**: Auto-managed in PDF directory
- **Max PDFs**: ~3,000-5,000 files safely
- **RAM usage**: 2-4GB for typical collection

### 🔄 Force Rebuild Mechanism - CHỈ KHI CẦN THIẾT

**⚠️ QUAN TRỌNG:** Chỉ sử dụng `--force-rebuild` khi THỰC SỰ cần thiết để tránh mất thời gian!

#### ✅ **CẦN Force Rebuild Khi:**

1. **System cảnh báo files thay đổi:** 
   ```
   ⚠️  WARNING: PDF files have changed!
   ```

2. **Sau thao tác thay đổi files:**
   - ➕ Thêm PDF mới vào thư mục
   - ➖ Xóa/đổi tên PDF files  
   - ✏️ Sửa nội dung PDF files
   - 📁 Thay đổi cấu trúc thư mục PDF

3. **Troubleshooting khi results không chính xác:**
   - Khi query không tìm thấy content mới thêm
   - Khi results vẫn chứa content từ files đã xóa

#### ❌ **KHÔNG CẦN Force Rebuild Khi:**

1. **Cùng một session, chưa thay đổi files:** 
   - Query liên tiếp trên cùng PDF collection
   - Thử nghiệm với different queries
   - Test performance với cached results

2. **System hoạt động bình thường:**
   - Không có cảnh báo file changes
   - Results vẫn accurate và up-to-date
   - Cache retrieval time ~0.17s (nhanh)

#### 🧠 **Cơ Chế Smart Caching:**

```bash
# Smart detection system tự động kiểm tra:
# 1. MD5 checksums của tất cả PDF files
# 2. Manifest.json tracking changes  
# 3. Vector cache validity
# 4. Auto-warning khi detect changes

# CHỈ force rebuild khi cần thiết:
/home/fong/Projects/mini-rag/run.sh "Query?" /path/to/pdfs --force-rebuild

# Normal usage (sử dụng cache):  
/home/fong/Projects/mini-rag/run.sh "Query?" /path/to/pdfs
```

#### 📊 **Performance Impact:**

| Scenario | Time | Cache Status | Khi Nào Sử Dụng |
|----------|------|--------------|---------|
| **First run** | ~45s | Building index | Lần đầu tiên |
| **Cached run** | ~0.17s | Using cache | ✅ Mặc định |
| **Force rebuild** | ~45s | Rebuilding | ⚠️ Chỉ khi cần |
| **Auto-detected changes** | ~45s + warning | Auto-rebuild | System tự detect |

#### 💡 **Best Practice Workflow:**

```bash
# 1. Normal query đầu tiên (kiểm tra cache hoạt động)
/home/fong/Projects/mini-rag/run.sh "test query" /path/to/pdfs

# 2. Nếu results không đúng HOẶC có warning → Force rebuild
/home/fong/Projects/mini-rag/run.sh "test query" /path/to/pdfs --force-rebuild

# 3. Tiếp tục với normal queries (dùng cache mới)
/home/fong/Projects/mini-rag/run.sh "actual query" /path/to/pdfs
```

## 🔧 Troubleshooting

### Issue: Virtual environment not found
```bash
# Setup venv
cd /home/fong/Projects/mini-rag
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Issue: Permission denied
```bash
# Make script executable
chmod +x /home/fong/Projects/mini-rag/run.sh
```

### Issue: No results returned
```bash
# Check if PDFs exist
ls -la /home/fong/Projects/de/public/.fong/RAG-books/*.pdf

# Try broader query
/home/fong/Projects/mini-rag/run.sh "programming software development" /home/fong/Projects/de/public/.fong/RAG-books
```

## 📝 Query Examples for Deutschfuns Features

### LearnDash Integration
```bash
/home/fong/Projects/mini-rag/run.sh "learning management system LMS course structure quiz assessment tracking" /home/fong/Projects/de/public/.fong/RAG-books
```

### User Progress Tracking
```bash
/home/fong/Projects/mini-rag/run.sh "user progress tracking analytics data storage database design patterns" /home/fong/Projects/de/public/.fong/RAG-books
```

### Multilingual Support
```bash
/home/fong/Projects/mini-rag/run.sh "internationalization i18n localization l10n multilingual web applications" /home/fong/Projects/de/public/.fong/RAG-books
```

### Caching Strategy
```bash
/home/fong/Projects/mini-rag/run.sh "caching strategies object cache transient API WordPress performance optimization" /home/fong/Projects/de/public/.fong/RAG-books
```

## 🎯 Integration with Deutschfuns Workflow

```bash
# When implementing new feature
FEATURE="user progress tracking"
CONTEXT=$(/home/fong/Projects/mini-rag/run.sh "best practices patterns $FEATURE" /home/fong/Projects/de/public/.fong/RAG-books)

# When debugging issue
ISSUE="database performance slow queries"
DEBUG_CONTEXT=$(/home/fong/Projects/mini-rag/run.sh "$ISSUE optimization techniques" /home/fong/Projects/de/public/.fong/RAG-books)

# When reviewing code
REVIEW="SOLID principles clean code refactoring"
REVIEW_CONTEXT=$(/home/fong/Projects/mini-rag/run.sh "$REVIEW" /home/fong/Projects/de/public/.fong/RAG-books)
```

## 📚 Additional Resources

- **Mini-RAG Project**: `/home/fong/Projects/mini-rag/`
- **PDF Books**: `/home/fong/Projects/de/public/.fong/RAG-books/`
- **Results Archive**: `/home/fong/Projects/mini-rag/results/`
- **Logs**: `/home/fong/Projects/mini-rag/logs/`

## 🔄 Quick Command Reference

```bash
# Most used command pattern
alias fong-rag='/home/fong/Projects/mini-rag/run.sh "$1" /home/fong/Projects/de/public/.fong/RAG-books'

# Usage with alias
fong-rag "WordPress security best practices"
fong-rag "database normalization patterns"
fong-rag "clean code principles PHP"
```

---

## 🚨 CRITICAL REMINDERS FOR AI

**🧠 THINK ULTRA REQUIREMENT:** 
- AI PHẢI think ultra để construct precise English queries với correct technical terminology
- KHÔNG query trực tiếp Vietnamese - phải translate → technical English terms
- Sau query PHẢI đọc results (terminal output hoặc file trong `/home/fong/Projects/mini-rag/results/`)
- Use retrieved context as authoritative reference for problem solving

**💡 Remember:** Query effectiveness = AI Think Ultra quality. Better thinking → Better queries → Better results!

**🎯 Core Purpose:** Cross-check implementation decisions against established best practices from authoritative programming books.