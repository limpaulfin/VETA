---
title: "Textor - Quick Reference"
subtitle: "TL;DR and Comparison Tables"
version: "3.0.0"
updated: "2025-11-15"
---


# Quick Reference - Textor Doc Converter


**Breadcrumb**: [Main Index](./00-instructions-textor-doc-converter-mermaid-plantuml.md) > Quick Reference


---


## TL;DR


**Export to PDF:**


```bash
/home/fong/Projects/textor-doc-converter/run-807f321188c6.sh '{"command":"export-md-to-pdf","data":"/absolute/path/file.md"}'
```


**Show Help:**


```bash
/home/fong/Projects/textor-doc-converter/run-807f321188c6.sh --help
```


---


## Reference Documentation Files


**Absolute Paths for Direct Reading:**


```bash
# PlantUML Salt Reference (UI Mockups & Wireframes)
cat /home/fong/Projects/textor-doc-converter/docs/plantuml-salt-reference.md

# Mermaid Reference (All 13 Diagram Types)
cat /home/fong/Projects/textor-doc-converter/docs/mermaid-reference.md

# Or use less for paginated reading
less /home/fong/Projects/textor-doc-converter/docs/plantuml-salt-reference.md
```


**File Sizes:**


- `plantuml-salt-reference.md`: 6.9K (compact reference)
- `mermaid-reference.md`: 14K (comprehensive guide)


---


## Test Files Available


```
tests/
├── test-mermaid.md          # Mermaid examples
├── test-plantuml-fail.md    # PlantUML error cases
├── plantuml-mermaid.md      # Mixed diagrams (PlantUML + Mermaid)
├── mermaid-all-types.md     # All 13 Mermaid diagram types
```


**Quick Test:**


```bash
# Test mixed diagrams
/home/fong/Projects/textor-doc-converter/run-807f321188c6.sh '{"command":"export-md-to-pdf","data":"tests/plantuml-mermaid.md"}'

# Test all Mermaid types
/home/fong/Projects/textor-doc-converter/run-807f321188c6.sh '{"command":"export-md-to-pdf","data":"tests/mermaid-all-types.md"}'
```


---


## Mermaid vs PlantUML - Khi nào dùng gì?


| Criteria | Mermaid | PlantUML |
|----------|---------|----------|
| **Syntax** | Simple, readable | More verbose |


---


**Back to**: [Main Index](./00-instructions-textor-doc-converter-mermaid-plantuml.md)
