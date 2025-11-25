# VETA (Viet-Eng-Term-Analyzer)

**Phân tích Ngôn ngữ Đa Ngữ (Anh-Việt)** - Mixed Language Analysis với OpenAI API

## Mô tả

VETA là công cụ phân tích văn bản đa ngôn ngữ (Anh-Việt), sử dụng OpenAI API để:
- Đếm số từ tiếng Anh và tiếng Việt
- Xác định các từ tiếng Anh **KHÔNG thể Việt hóa** (untranslatable English words)
- Phân tích code-switching - cách sử dụng pha trộn 2 ngôn ngữ

## Cấu trúc Project

```
VETA/
├── main-fc70324b.sh        # Entry point (bash wrapper)
├── main-fc70324b.py        # Entry point (Python)
├── requirements.txt        # Dependencies
├── .env.example            # Environment variables template
├── README.md               # This file
├── .venv/                  # Virtual environment (auto-created)
├── src/                    # Source modules
│   └── veta_analyzer.py    # Core analyzer module
├── tests/                  # Test cases
└── docs/                   # Documentation
```

## Setup

### 1. Clone và cài đặt

```bash
cd /home/fong/Projects/VETA
cp .env.example .env
# Chỉnh sửa .env và thêm OPENAI_API_KEY
```

### 2. Chạy

```bash
./main-fc70324b.sh 'Hiện tại, tôi đang học về Prompt Engineering để tối ưu hóa việc call API của OpenAI'
```

## Output Format

```json
{
  "total_words": 40,
  "english_word_count": 14,
  "vietnamese_word_count": 26,
  "untranslatable_english_words": [
    {
      "word": "Prompt Engineering",
      "reason": "Là một thuật ngữ chuyên môn mới trong lĩnh vực AI..."
    },
    {
      "word": "API",
      "reason": "Viết tắt của Application Programming Interface..."
    }
  ],
  "mixed_language_analysis": "Văn bản sử dụng code-switching một cách hiệu quả..."
}
```

## Tính năng

- ✅ Phân tích code-switching
- ✅ Đếm từ chính xác
- ✅ Xác định thuật ngữ không thể Việt hóa với lý do
- ✅ JSON mode output (structured)
- ✅ Error handling toàn diện

## Requirements

- Python 3.10+
- OpenAI API Key
- pip dependencies: `openai`, `python-dotenv`

## Tham khảo

- Pattern: `/home/fong/Projects/boiler-plate-cursor-project-with-init-prompt/docs/python-boilerplate-guide/`
- Note gốc: `/home/fong/Projects/dropbox-obsidian/FongObsidian/00/VETA.md`
- Model: gpt-4o-mini (default) hoặc gpt-4o

## License

MIT
