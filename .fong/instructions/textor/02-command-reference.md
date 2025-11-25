---
title: "Textor - Command Reference"
subtitle: "Usage and Command Examples"
version: "3.0.0"
updated: "2025-11-15"
---


# Command Reference - Textor Doc Converter


**Breadcrumb**: [Main Index](./00-instructions-textor-doc-converter-mermaid-plantuml.md) > Command Reference


---


## Usage


### Gọi Script với Absolute Path


```bash
/home/fong/Projects/textor-doc-converter/run-807f321188c6.sh '<JSON_PARAMS>'
```


### Xem Full Help


```bash
# Show complete documentation
/home/fong/Projects/textor-doc-converter/run-807f321188c6.sh --help

# hoặc
/home/fong/Projects/textor-doc-converter/run-807f321188c6.sh '{"command":"help"}'
```


---


## Command Examples


**LƯU Ý:** Các examples dưới đây chỉ là **minh họa**. Còn nhiều commands và options khác. Chạy `--help` để xem **FULL DOCUMENTATION**.


### 1. Validate PlantUML Code


```bash
/home/fong/Projects/textor-doc-converter/run-807f321188c6.sh '{"command":"validate-plantuml","data":"@startuml\nAlice->Bob\n@enduml"}'
```


### 2. Validate Mermaid Code


```bash
/home/fong/Projects/textor-doc-converter/run-807f321188c6.sh '{"command":"validate-mermaid","data":"graph LR\nA-->B"}'
```


### 3. Validate Markdown với PlantUML


```bash
/home/fong/Projects/textor-doc-converter/run-807f321188c6.sh '{"command":"validate-md-plantuml","data":"docs/example.md"}'
```


### 4. Validate Markdown với Mermaid


```bash
/home/fong/Projects/textor-doc-converter/run-807f321188c6.sh '{"command":"validate-md-mermaid","data":"tests/test-mermaid.md"}'
```


### 5. Export Markdown to PDF


```bash
# Default A4 portrait
/home/fong/Projects/textor-doc-converter/run-807f321188c6.sh '{"command":"export-md-to-pdf","data":"docs/example.md"}'

# A4 landscape
/home/fong/Projects/textor-doc-converter/run-807f321188c6.sh '{"command":"export-md-to-pdf","data":"docs/example.md","page_size":"A4","orientation":"landscape"}'

# Mixed diagrams (PlantUML + Mermaid)
/home/fong/Projects/textor-doc-converter/run-807f321188c6.sh '{"command":"export-md-to-pdf","data":"tests/plantuml-mermaid.md"}'
```


---


**Next Step**: Choose diagram type - [Mermaid](./03-mermaid-guide.md) or [PlantUML](./06-plantuml-guide.md) →
