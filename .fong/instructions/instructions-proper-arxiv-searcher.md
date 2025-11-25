# Hướng dẫn sử dụng ArXiv Searcher CLI

## 1. File thực thi chính
```bash
/home/fong/Projects/arxiv-searcher/arxiv-searcher.sh
```

Script này tự động:
- Kích hoạt môi trường venv
- Gọi file Python `/home/fong/Projects/arxiv-searcher/main-32ac0bad4380.py`
- Truyền tất cả arguments
- Deactivate venv sau khi xong

## 2. Cú pháp cơ bản
```bash
/home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "QUERY" [OPTIONS]
```

## 3. Chi tiết từng Endpoint/Parameters

### 3.1. QUERY (Bắt buộc)
- **Mô tả**: Từ khóa tìm kiếm papers trên ArXiv
- **Vị trí**: Argument đầu tiên
- **Ví dụ**:
  ```bash
  /home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "machine learning"
  /home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "transformer attention mechanism"
  /home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "quantum computing cat:quant-ph"
  ```

### 3.2. -n, --max-results
- **Mô tả**: Giới hạn số lượng papers trả về
- **Mặc định**: 10 (từ file `.env`)
- **Giá trị**: Integer (1-100 recommended)
- **Ví dụ**:
  ```bash
  /home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "neural networks" -n 20
  /home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "deep learning" --max-results 50
  ```

### 3.3. -s, --sort
- **Mô tả**: Cách sắp xếp kết quả
- **Mặc định**: SubmittedDate (từ file `.env`)
- **Giá trị hợp lệ**:
  - `SubmittedDate`: Ngày submit (mới nhất trước)
  - `Relevance`: Độ liên quan với query
  - `LastUpdatedDate`: Ngày cập nhật gần nhất
- **Order**: Luôn DESCENDING
- **Ví dụ**:
  ```bash
  /home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "GNN" -s Relevance
  /home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "NLP" --sort LastUpdatedDate
  ```

### 3.4. -o, --output
- **Mô tả**: Export kết quả sang file với UUID tự động
- **Giá trị hợp lệ**:
  - `json`: Export sang JSON
  - `csv`: Export sang CSV
  - `markdown`: Export sang Markdown
  - `bibtex`: Export sang BibTeX cho citation
- **Output directory**: `/home/fong/Projects/arxiv-searcher/output/`
- **Filename pattern**: `arxiv_{UUID}.{extension}`
- **Ví dụ**:
  ```bash
  /home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "reinforcement learning" -o json
  /home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "computer vision" -n 30 -o markdown
  /home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "LLM" -o bibtex
  ```

### 3.5. -d, --download
- **Mô tả**: Download PDF files của papers
- **Kiểu**: Flag (không cần giá trị)
- **Default directory**: `/home/fong/Projects/arxiv-searcher/downloads/`
- **Ví dụ**:
  ```bash
  /home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "transformer" -d
  /home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "attention mechanism" -n 5 -d
  ```

### 3.6. --download-limit
- **Mô tả**: Giới hạn số PDFs được download
- **Yêu cầu**: Phải dùng với flag `-d`
- **Giá trị**: Integer
- **Ví dụ**:
  ```bash
  /home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "context engineering" -d --download-limit 3
  /home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "AI ethics" -n 20 -d --download-limit 5
  ```

### 3.7. --download-dir
- **Mô tả**: Thay đổi thư mục lưu PDF
- **Mặc định**: `/home/fong/Projects/arxiv-searcher/downloads/`
- **Giá trị**: Absolute path
- **Ví dụ**:
  ```bash
  /home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "quantum" -d --download-dir /tmp/papers
  /home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "ML" -d --download-dir /home/fong/Documents/research
  ```

### 3.8. -q, --quiet
- **Mô tả**: Quiet mode - chỉ output JSON, không in thông tin khác
- **Kiểu**: Flag
- **Use case**: Cho scripts hoặc pipeline processing
- **Ví dụ**:
  ```bash
  /home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "federated learning" -q
  /home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "privacy AI" -n 100 -q > results.json
  /home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "GPT" -q | jq '.[] | .title'
  ```

## 4. Các ví dụ sử dụng thực tế

### 4.1. Tìm kiếm cơ bản
```bash
# Tìm 10 papers mặc định về machine learning
/home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "machine learning"
```

### 4.2. Tìm với category filter
```bash
# Tìm papers về GNN trong category cs.LG
/home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "graph neural network cat:cs.LG" -n 20
```

### 4.3. Export và download cùng lúc
```bash
# Tìm 30 papers, export JSON và download 5 PDFs đầu
/home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "transformer attention" -n 30 -o json -d --download-limit 5
```

### 4.4. Custom download directory
```bash
# Download papers về quantum computing vào thư mục riêng
/home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "quantum computing" -d --download-dir /home/fong/quantum-papers
```

### 4.5. Pipeline processing với jq
```bash
# Lấy tất cả PDF URLs của papers về NLP
/home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "NLP" -n 50 -q | jq -r '.[] | .pdf_url'

# Lấy papers published trong 2024
/home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "AI safety" -n 100 -q | jq '.[] | select(.published | startswith("2024"))'
```

### 4.6. Tìm papers theo author
```bash
# Tìm papers của Yoshua Bengio
/home/fong/Projects/arxiv-searcher/arxiv-searcher.sh 'au:"Yoshua Bengio"' -n 20
```

### 4.7. Tìm papers với multiple categories
```bash
# Papers về AI trong cả cs.AI và cs.LG
/home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "artificial intelligence (cat:cs.AI OR cat:cs.LG)" -n 30
```

### 4.8. Export tất cả formats
```bash
# Export sang JSON với quiet mode để script processing
/home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "federated learning" -o json -q

# Export sang BibTeX cho citation
/home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "vision transformer" -o bibtex

# Export sang Markdown cho documentation
/home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "BERT" -o markdown
```

## 5. Logging

Mọi operations đều được log tự động:
- **Log directory**: `/home/fong/Projects/arxiv-searcher/logs/`
- **Log filename**: `arxiv_YYYYMMDD_HHMMSS_sessionID.log`
- **Logged operations**:
  - SEARCH operations với query, results count, sort method
  - EXPORT operations với format, file path, papers count
  - DOWNLOAD operations với success/failure status

Xem log mới nhất:
```bash
ls -lt /home/fong/Projects/arxiv-searcher/logs/ | head -2
tail -f /home/fong/Projects/arxiv-searcher/logs/arxiv_*.log
```

## 6. Configuration (.env)

File cấu hình: `/home/fong/Projects/arxiv-searcher/.env`
```
DOWNLOAD_DIR=/home/fong/Projects/arxiv-searcher/downloads
OUTPUT_DIR=/home/fong/Projects/arxiv-searcher/output
MAX_RESULTS_DEFAULT=10
SORT_BY_DEFAULT=SubmittedDate
```

## 7. Troubleshooting

### Lỗi permission denied
```bash
chmod +x /home/fong/Projects/arxiv-searcher/arxiv-searcher.sh
```

### Lỗi venv không tìm thấy
```bash
cd /home/fong/Projects/arxiv-searcher
python3 -m venv venv
source venv/bin/activate
pip install arxiv python-dotenv requests
```

### Kiểm tra dependencies
```bash
/home/fong/Projects/arxiv-searcher/venv/bin/pip list
```

## 8. Advanced Usage

### Combine với other tools
```bash
# Download papers và analyze với pdftotext
/home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "LLM optimization" -d --download-limit 5
for pdf in /home/fong/Projects/arxiv-searcher/downloads/*.pdf; do
    pdftotext "$pdf" - | head -100
done

# Tạo reading list
/home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "recent advances NLP" -n 20 -o markdown
cat /home/fong/Projects/arxiv-searcher/output/arxiv_*.md >> reading_list.md
```

### Monitoring new papers
```bash
# Cron job để check papers mới hàng ngày
0 9 * * * /home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "machine learning" -n 10 -o json -q >> /home/fong/ml-papers-daily.jsonl
```

## 9. Return Codes
- `0`: Success - found results
- `1`: No results found
- Other: System errors

## 10. Notes
- ArXiv API rate limit: ~3 requests/second
- Recommended max results: < 100 for performance
- PDF downloads are saved with sanitized filenames
- All outputs have UUID to prevent overwrites
- Logs are kept indefinitely unless manually cleaned