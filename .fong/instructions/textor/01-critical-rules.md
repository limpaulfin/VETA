---
title: "Textor - Critical Rules (Part 1)"
subtitle: "Emoji, Heading, Spacing"
version: "3.0.0"
updated: "2025-11-15"
---


# Critical Rules - Part 1


**Breadcrumb**: [Main Index](./00-instructions-textor-doc-converter-mermaid-plantuml.md) > Critical Rules


---


## Rule 1: Emoji Usage


**BẮT BUỘC - MANDATORY:** KHÔNG TỰ Ý DÙNG EMOJI trong markdown content.


**Quy tắc:**


- ❌ KHÔNG tự ý thêm emoji vào document content
- ❌ KHÔNG dùng emoji trong headings, body text, examples
- ✅ CHỈ DÙNG khi user EXPLICITLY yêu cầu
- ✅ EXCEPTION: Technical warnings/notes trong instructions


**Lý do:**


- XeLaTeX engine không render emoji
- Professional documentation không nên có emoji


**Áp dụng cho:** PRD, Technical specs, API docs, Changelogs


---


## Rule 2: Markdown Heading Depth


**BẮT BUỘC - MANDATORY:** Tối đa 3 cấp heading (H1, H2, H3).


**Quy tắc:**


- H1 (#): YAML title only - KHÔNG dùng trong content
- H2 (##): Main sections
- H3 (###): Sub-sections
- KHÔNG DÙNG H4 (####) trở xuống


**Thay thế H4:** Use **bold text**


---


## Rule 3: Markdown Spacing


**BẮT BUỘC - MANDATORY:** 2 newlines giữa headers/bold text và content.


**Quy tắc:**


- ✅ Header → 2 newlines → Content
- ✅ Bold text → 2 newlines → Content
- ❌ Chỉ 1 newline (SAI)


---


**Next Step**: [Critical Rules Part 2](./01b-critical-rules-diagrams.md) →
