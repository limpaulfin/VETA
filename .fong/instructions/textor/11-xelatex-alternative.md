---
title: "Textor - XeLaTeX Alternative"
subtitle: "For files WITHOUT diagrams"
version: "3.0.0"
updated: "2025-11-15"
---


# XeLaTeX Alternative - For No-Diagram Files


**Breadcrumb**: [Main Index](./00-instructions-textor-doc-converter-mermaid-plantuml.md) > XeLaTeX Alternative


---


## Alternative: Direct Pandoc with XeLaTeX (No Diagrams)

**Use Case**: Khi file .md **KHÔNG có** Mermaid hoặc PlantUML diagrams, có thể dùng Pandoc trực tiếp với xelatex engine.

### When to Use

✅ **Dùng XeLaTeX khi:**
- File .md không có code blocks: `````mermaid` hoặc `````plantuml`
- Chỉ có text, headings, images, tables, code blocks thông thường
- Cần convert nhanh không cần validate diagrams
- File có ảnh embedded (JPEG, PNG) - xelatex handle rất tốt

❌ **KHÔNG dùng XeLaTeX khi:**
- File có Mermaid diagrams → Dùng Textor Doc Converter
- File có PlantUML diagrams → Dùng Textor Doc Converter
- File có mixed diagrams → Dùng Textor Doc Converter

### Command Pattern

```bash
cd /path/to/directory

pandoc input-file.md \
  -o output-file.pdf \
  --pdf-engine=xelatex \
  -V geometry:margin=1in \
  -V fontsize=11pt \
  --toc
```

### Real Example

```bash
# Example: Convert changelog with images
cd /home/fong/Projects/de/public/CHANGELOGS

pandoc CHANGELOG-2025-10-23_15-55-Claude.md \
  -o CHANGELOG-2025-10-23_15-55-Claude.pdf \
  --pdf-engine=xelatex \
  -V geometry:margin=1in \
  -V fontsize=11pt \
  --toc
```

**Result**: 191KB PDF with 4 embedded JPEG images (11 pages)

### Options Explained

| Option | Purpose |
|--------|---------|
| `--pdf-engine=xelatex` | Unicode support, handles images well |
| `-V geometry:margin=1in` | Set margins to 1 inch |
| `-V fontsize=11pt` | Base font size 11pt |
| `--toc` | Generate Table of Contents |

### Expected Warnings

⚠️ **Normal warnings** (can ignore):
```
[WARNING] Missing character: There is no ✅ (U+2705) in font...
[WARNING] Missing character: There is no 🎯 (U+1F3AF) in font...
```
- Emojis not in default font (cosmetic only)
- PDF still generates successfully
- Text content and images unaffected

### Comparison: Textor vs XeLaTeX

| Feature | Textor Doc Converter | Direct XeLaTeX |
|---------|---------------------|----------------|
| Mermaid support | ✅ Yes | ❌ No |
| PlantUML support | ✅ Yes | ❌ No |
| Images (JPEG/PNG) | ✅ Yes | ✅ Yes |
| Tables | ✅ Yes | ✅ Yes |
| Code blocks | ✅ Yes | ✅ Yes |
| Validation | ✅ Real errors | ❌ None |
| Speed | 🟡 Medium | 🟢 Fast |
| Use when | Has diagrams | No diagrams |


---

**Back to**: [Main Index](./00-instructions-textor-doc-converter-mermaid-plantuml.md) | [Quick Reference](./99-quick-reference.md)
