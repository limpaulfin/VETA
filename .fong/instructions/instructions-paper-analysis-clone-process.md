# Instructions: Paper Analysis Clone Process

## Mục đích
Hướng dẫn chi tiết quy trình "clone" một paper PDF thành cấu trúc phân tích có tổ chức, bao gồm việc tách chapters, extract tables, và tổ chức images.

## Tổng quan quy trình
1. Tạo folder structure
2. Move PDF vào folder mới
3. Convert PDF sang text/markdown
4. Split thành các chapters riêng
5. Convert pages sang PNG
6. Extract và tổ chức images (manual crop BY USER)
7. Extract tables sang MD và CSV
8. Tạo documentation
9. **REQUIRED**: Create references với links
10. **REQUIRED**: Cross-check với smart-search-fz-rg-bm25 (fallback: rg)

> **Search Priority:** Sử dụng `smart-search-fz-rg-bm25` cho việc kiểm tra toàn bộ nội dung paper. Các lệnh `rg` bên dưới đóng vai trò fallback để chạy regex chính xác hoặc pipelines phức tạp.
>
> **Setup reminder:** Xem `.fong/instructions/smartsearch.md` để thiết lập alias và hiểu các tham số `--top-k`, `--show-content`, `--limit-tokens`.

## ⚠️ IMPORTANT: Working Directory
**LUÔN LUÔN cd vào folder paper trước khi làm việc:**
```bash
cd /path/to/paper-analysis-folder/
pwd  # Verify đúng folder
```

## Chi tiết từng bước

### 1. Tạo Folder Structure
```bash
# Tạo folder chính với tên phù hợp paper
mkdir -p /home/fong/Projects/hub-ris-ppnckh-ca-nhan/assignments/[paper-name-analysis]/

# Tạo subfolders
cd /home/fong/Projects/hub-ris-ppnckh-ca-nhan/assignments/[paper-name-analysis]/
mkdir -p {chapters,images/figures,images/diagrams,pages,tables,references}
```

**Cấu trúc folders FINAL (44+ files expected):**
```
paper-name-analysis/
├── ANALYSIS_PLAN.md         # Plan chi tiết
├── README.md                 # Overview và summary
├── full-paper.md             # Full text extracted
├── *.pdf                     # Original PDF
├── chapters/                 # 7 files expected
│   ├── 01-abstract.md
│   ├── 02-introduction.md
│   ├── 03-methods.md
│   ├── 04-results.md
│   ├── 05-discussion.md
│   ├── 06-conclusion.md
│   └── 07-references.md
├── images/
│   ├── IMAGE_LOCATIONS.md   # Documentation
│   ├── figures/             # 6+ cropped figures
│   └── diagrams/            # If any
├── pages/                   # 10+ PNG files (300 DPI)
│   ├── page-01.png
│   ├── page-02.png
│   └── ...
├── tables/                  # Pairs of MD + CSV
│   ├── table1-*.md
│   ├── table1-*.csv
│   └── ...
└── references/              # 17+ reference files
    ├── README.md
    ├── ref-01-*.md
    ├── ref-02-*.md
    └── ...
```

### 2. Move PDF File
```bash
# Move PDF từ location cũ vào folder mới
mv /path/to/original/paper.pdf /home/fong/Projects/hub-ris-ppnckh-ca-nhan/assignments/[paper-name-analysis]/
```

### 3. Convert PDF sang Text/Markdown
```bash
# Sử dụng pdftotext với layout option để giữ format
pdftotext -layout paper.pdf full-paper.txt

# Rename thành markdown
mv full-paper.txt full-paper.md
```

**Lưu ý:**
- `pandoc` không convert được từ PDF, chỉ convert TO PDF
- `pdftotext -layout` giữ được cấu trúc bảng và format tốt hơn

### 4. Convert Pages sang PNG (300 DPI)
```bash
# Convert tất cả pages sang PNG với độ phân giải cao
pdftoppm -png -r 300 paper.pdf pages/page
```

**Kết quả:** 
- Files: `page-01.png`, `page-02.png`, ...
- Resolution: 300 DPI cho chất lượng in ấn

### 5. Split Markdown thành Chapters

#### 5.1. Xác định sections trong paper
```bash
# Tìm các section headers (ưu tiên smart-search, fallback rg)
smart-search-fz-rg-bm25 "abstract introduction methods results discussion conclusion references" full-paper.md --show-content
rg -i "abstract|introduction|methods|results|discussion|conclusion|references" full-paper.md
```

#### 5.2. Tách từng section
Sử dụng line numbers để extract chính xác:

```bash
# Ví dụ extract Abstract (lines 21-47)
sed -n '21,47p' full-paper.md > chapters/01-abstract.md

# Hoặc dùng awk
awk 'NR>=21 && NR<=47' full-paper.md > chapters/01-abstract.md
```

#### 5.3. Cấu trúc chapters điển hình
- `01-abstract.md` - Abstract và keywords
- `02-introduction.md` - Background và objectives
- `03-methods.md` - Methodology và data
- `04-results.md` - Kết quả và findings
- `05-discussion.md` - Thảo luận và phân tích
- `06-conclusion.md` - Kết luận
- `07-references.md` - Tài liệu tham khảo

### 6. Extract và Crop Images

#### 6.1. Xác định vị trí figures trong pages
1. Mở từng page PNG để xem
2. Ghi nhận page number và vị trí của mỗi figure
3. Tạo documentation về image locations

#### 6.2. Manual Crop Process (REQUIRED - USER MUST DO THIS)
**⚠️ CẢNH BÁO CỰC KỲ QUAN TRỌNG:** 
- **AI KHÔNG THỂ CROP CHÍNH XÁC** - Luôn có sai số lớn về vị trí
- **USER/PROMPTER (FONG) PHẢI TỰ CROP THỦ CÔNG 100%**
- **AI CHỈ ĐƯỢC PHÉP:**
  - Nhắc user về việc cần crop
  - Hướng dẫn naming convention
  - Move và rename files SAU KHI user crop xong

Quy trình manual (USER/FONG tự làm):
1. User mở page PNG trong image editor
2. User tự crop và save với pattern `page-XX Y.png`
3. AI chỉ move và rename theo naming convention:
   - `fig-01a-description.png`
   - `fig-01b-description.png`
   - `fig-02-description.png`

#### 6.3. Naming Convention cho Figures
```
fig-[number][letter]-[description].png

Ví dụ:
- fig-01a-lasso-cv.png
- fig-01b-lasso-coefficients.png
- fig-01c-feature-importance.png
- fig-01d-pca-3d.png
- fig-02-roc-curves.png
- fig-03-confusion-matrices.png
```

#### 6.4. Move cropped images
```bash
# Sau khi crop manual, files thường được save với pattern "page-XX Y.png"
# Move và rename chúng:
mv "pages/page-05 1.png" "images/figures/fig-01a-lasso-cv.png"
mv "pages/page-05 2.png" "images/figures/fig-01b-lasso-coefficients.png"
# ... tiếp tục cho các figures khác
```

### 7. Extract Tables sang MD và CSV

#### 7.1. Tìm tables trong text
```bash
# Search for table indicators
rg -i "table [0-9]" full-paper.md -A 20
```

#### 7.2. Format Markdown Table
```markdown
# Table 1: Title

| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Data 1   | Data 2   | Data 3   |
| Data 4   | Data 5   | Data 6   |
```

#### 7.3. Create CSV Version
```csv
Column1,Column2,Column3
Data1,Data2,Data3
Data4,Data5,Data6
```

#### 7.4. File naming
- `table1-description.md`
- `table1-description.csv`
- `table2-description.md`
- `table2-description.csv`

### 8. Create Documentation Files

#### 8.1. ANALYSIS_PLAN.md
Tạo file plan với structure:
- Paper information
- Folder organization
- Processing steps
- Expected outputs
- Quality checks

#### 8.2. README.md
Comprehensive overview bao gồm:
- Paper summary
- Repository structure (tree diagram)
- Key findings
- Quick links to sections
- Data tables summary
- Figures description
- Citation format

#### 8.3. IMAGE_LOCATIONS.md
Document vị trí của mỗi figure:
- Figure number và description
- Page location
- Content description
- Cropped file location

### 9. Quality Checks

#### 9.1. Verify Structure
```bash
# Check overall structure
tree -L 2 [paper-folder]/

# Count files
find . -type f | wc -l
```

#### 9.2. Verify Content
- [ ] PDF file present
- [ ] Full markdown readable
- [ ] All chapters extracted
- [ ] Page PNGs complete
- [ ] Figures cropped correctly
- [ ] Tables in both MD and CSV
- [ ] References complete
- [ ] Documentation files created

#### 9.3. Cross-check Images
```bash
# List all figures
ls -la images/figures/

# Verify each image opens correctly
# Check resolution and clarity
```

### 10. Memory Sync
Tạo memory file để track progress:
```bash
# Create memory file
touch .fong/.memory/[date]-paper-analysis-[name].md
```

Content bao gồm:
- Task overview
- Location paths
- Processing status
- Tools used
- Key findings

## Common Issues và Solutions

### Issue 1: PDF không convert được với pandoc
**Solution:** Use `pdftotext -layout` instead

### Issue 2: Images crop sai vị trí
**Solution:** Manual crop recommended, AI crop thường không chính xác

### Issue 3: Tables format bị lỗi
**Solution:** Manual format trong markdown, use proper table syntax

### Issue 4: Missing sections
**Solution:** Check với `smart-search-fz-rg-bm25` (fallback: `rg`) và extract manual với sed/awk

## Tools Required
- `pdftotext` - Convert PDF to text
- `pdftoppm` - Convert PDF pages to images
- `smart-search-fz-rg-bm25` - Search text patterns (fallback: `rg`/ripgrep)
- `sed/awk` - Text processing
- Python (optional) - For automation scripts
- Image editor - For manual cropping

## Example Commands Sequence
```bash
# 1. Setup
mkdir -p assignments/paper-analysis/{chapters,images/figures,pages,tables}
cd assignments/paper-analysis/

# 2. Move PDF
mv ../old-location/paper.pdf ./

# 3. Convert
pdftotext -layout paper.pdf full-paper.md
pdftoppm -png -r 300 paper.pdf pages/page

# 4. Search sections
rg -n "abstract|introduction|methods" full-paper.md

# 5. Extract chapters (adjust line numbers)
sed -n '21,47p' full-paper.md > chapters/01-abstract.md

# 6. Manual crop images in image editor

# 7. Move cropped images
mv "pages/page-05 1.png" "images/figures/fig-01a.png"

# 8. Create documentation
touch README.md ANALYSIS_PLAN.md images/IMAGE_LOCATIONS.md

# 9. Final check
tree -L 2
```

## Best Practices
1. **Always backup original PDF** trước khi process
2. **Use descriptive names** cho folders và files
3. **Document everything** trong README và ANALYSIS_PLAN
4. **Manual crop preferred** cho images quan trọng
5. **Cross-check extracted content** với PDF gốc
6. **Keep consistent naming** convention throughout
7. **Create memory files** để track progress

## 11. 🔴 CROSS-CHECK VỚI RG (QUAN TRỌNG NHẤT)

**⚠️ ĐÂY LÀ BƯỚC QUAN TRỌNG NHẤT - KHÔNG ĐƯỢC BỎ QUA**

Sau khi hoàn thành tất cả các bước trên, PHẢI thực hiện cross-check độc lập bằng `smart-search-fz-rg-bm25` (fallback: `rg`) để đảm bảo KHÔNG CÓ HALLUCINATION.

Chi tiết quy trình cross-check: Xem file `./.fong/instructions/instructions-paper-analysis-cross-check-process.md`

### Quick Cross-Check Commands
```bash
# Verify authors
smart-search-fz-rg-bm25 "tên tác giả" full-paper.md --show-content
rg "tên-tác-giả" full-paper.md

# Verify key results
smart-search-fz-rg-bm25 "accuracy" full-paper.md --show-content
rg "accuracy.*[0-9]\.[0-9]+" full-paper.md

# Count references
rg "^[0-9]+\." chapters/07-references.md | wc -l

# Verify tables match text
smart-search-fz-rg-bm25 "model name score" full-paper.md --show-content
rg "model-name.*score" full-paper.md
smart-search-fz-rg-bm25 "model-name,score" tables/ --show-content
rg "model-name,score" tables/*.csv

# Check all components exist
ls chapters/*.md | wc -l  # Should match expected chapters
ls tables/*.csv | wc -l    # Should have all tables
ls images/figures/*.png | wc -l  # Should have all figures
```

### Validation Script
```bash
#!/bin/bash
# Run comprehensive validation
echo "=== Cross-Check Validation ==="

# Check structure
[ -f "full-paper.pdf" ] && echo "✓ PDF" || echo "✗ PDF missing"
[ -f "full-paper.md" ] && echo "✓ Markdown" || echo "✗ Markdown missing"
[ -d "chapters" ] && echo "✓ Chapters" || echo "✗ Chapters missing"

# Check content accuracy
rg -q "key-term" full-paper.md && echo "✓ Content verified" || echo "✗ Content issue"

echo "=== Validation Complete ==="
```

## 12. References Enhancement với Perplexity (REQUIRED - KHÔNG OPTIONAL)

**⚠️ QUAN TRỌNG: PHẢI TẠO ĐỦ SỐ LƯỢNG REFERENCE FILES**

Để làm giàu thông tin references, sử dụng perplexity tool:

Chi tiết: Xem file `./.fong/instructions/fongperplexicity.md`

### Process CHÍNH XÁC
1. **Đếm số references** trong `chapters/07-references.md`
   ```bash
   rg "^[0-9]+\." chapters/07-references.md | wc -l
   ```

2. **PHẢI TẠO ĐỦ FILES** - Nếu có 17 references → phải có 17 files ref-XX-*.md

3. **Sử dụng perplexity để tìm CHÍNH XÁC**:
   ```bash
   # Tìm với title đầy đủ và tác giả
   ./.fong/perplexity/phd-research-tools.sh "full title author year" "year" 1
   ```

4. **Tạo file riêng cho MỖI reference**:
   ```
   references/
   ├── ref-01-author-year.md
   ├── ref-02-author-year.md
   └── ...
   ```

### Reference File Template REQUIRED
```markdown
# Reference [N]: [Title]

## Full Citation
[Exact citation from paper - KHÔNG THAY ĐỔI]

## Journal Information
- **Journal**: [Name]
- **Quartile**: [Q1/Q2 if found]
- **Year**: [Year]
- **DOI**: [DOI if found]

## Abstract Summary
[From perplexity search or manual search]

## Key Findings
- [Main findings]
- [Important results]

## Links (REQUIRED - ÍT NHẤT PHẢI CÓ Google Scholar)
- **DOI**: https://doi.org/[doi]
- **PubMed**: https://pubmed.ncbi.nlm.nih.gov/[id]
- **Google Scholar**: [Search "exact title in quotes"](https://scholar.google.com/scholar?q="exact+title")
```

### Verification Steps (MANDATORY)
```bash
# 1. Verify số lượng files = số references
ls references/ref-*.md | wc -l

# 2. Check mỗi file có links
for file in references/ref-*.md; do
    echo "=== $file ==="
    grep -E "DOI|Google Scholar" "$file"
done

# 3. Cross-check với original references
diff <(rg "^[0-9]+\." chapters/07-references.md | wc -l) \
     <(ls references/ref-*.md | wc -l)
```

## 13. File Content Structure Examples

### Chapter File Structure (chapters/01-abstract.md)
```markdown
# Abstract

Background: [Background text...]

Methods: [Methods text...]

Results: [Results text...]

Conclusion: [Conclusion text...]

Keywords: [keywords]
```

### Table Files Structure
**Markdown (tables/table1-*.md):**
```markdown
# Table 1: [Title]

## [Description]

| Model | Accuracy | Recall | Precision | F1 | AUC |
|-------|----------|--------|-----------|-----|-----|
| LR    | 0.78     | 0.78   | 0.78      | 0.78| 0.78|
```

**CSV (tables/table1-*.csv):**
```csv
Model,Accuracy_CV,Recall_CV,Precision_CV,F1_score_CV,AUC_CV
Logistic regression,0.78,0.78,0.78,0.78,0.78
```

### Reference File Structure (references/ref-XX-*.md)
```markdown
# Reference [N]: [Title]

## Full Citation
[Exact citation from paper]

## Journal Information
- **Journal**: [Name]
- **Quartile**: Q1/Q2
- **Year**: [Year]
- **DOI**: [DOI]

## Abstract Summary
[Summary text]

## Key Findings
- [Finding 1]
- [Finding 2]

## Links
- **DOI**: https://doi.org/[doi]
- **PubMed**: https://pubmed.ncbi.nlm.nih.gov/[id]
- **Google Scholar**: [Search title](link)

@article{author2022title,
  title={},
  author={},
  journal={},
  year={2022}
}
```

## Checklist Final (Updated)
- [ ] Folder structure created
- [ ] PDF moved and backed up
- [ ] Full text extracted
- [ ] Chapters split correctly
- [ ] Pages converted to PNG
- [ ] Images cropped BY USER (manual)
- [ ] Images moved and renamed by AI
- [ ] Tables extracted (MD + CSV)
- [ ] References separated
- [ ] Documentation complete
- [ ] Memory file updated
- [ ] **✅ CROSS-CHECK WITH smart-search-fz-rg-bm25 COMPLETED** (fallback: `rg`)
- [ ] **✅ NO HALLUCINATION VERIFIED**
- [ ] References enhanced (optional)
- [ ] Final structure verified

---
*Created: 2025-09-10*
*Updated: Added cross-check process and manual crop requirement*
*Purpose: Standardized process for paper analysis with accuracy validation*
