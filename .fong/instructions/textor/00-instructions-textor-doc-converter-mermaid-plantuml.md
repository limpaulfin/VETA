---
title: "Textor Doc Converter - Main Index"
subtitle: "Mermaid & PlantUML Documentation Converter"
version: "3.0.0"
updated: "2025-11-15"
architecture: "Modular documentation with cross-referenced components"
tool: "Document Converter CLI"
script_path: "/home/fong/Projects/textor-doc-converter/run-807f321188c6.sh"
---


# Textor Doc Converter - Main Index


**Version**: 3.0.0 (Modular Architecture - 20 files, <115 LOC each)
**Script Path**: `/home/fong/Projects/textor-doc-converter/run-807f321188c6.sh`


---


## NAVIGATION INDEX


### Critical Reading (MUST READ FIRST)


1. **[Critical Rules Part 1](./01-critical-rules.md)** - Emoji, Heading, Spacing
2. **[Critical Rules Part 2](./01b-critical-rules-diagrams.md)** - Diagram Title, PlantUML Styling


### Command Reference


3. **[Command Reference](./02-command-reference.md)** - Usage, Examples 1-5


### Mermaid Diagrams


4. **[Mermaid Guide](./03-mermaid-guide.md)** - 13 Supported Types
5. **[Mermaid Examples - Basic](./04-mermaid-examples.md)** - Flowchart, Class, Sequence
6. **[Mermaid Examples - ER & State](./04b-mermaid-examples-er-state.md)** - ER, State
7. **[Mermaid Advanced Part 1](./05-mermaid-examples-advanced.md)** - Gantt, Git, Pie
8. **[Mermaid Advanced Part 2](./05b-mermaid-mindmap-timeline.md)** - Mindmap, Timeline, User Journey


### PlantUML Diagrams


9. **[PlantUML Guide](./06-plantuml-guide.md)** - 11 Supported Types
10. **[PlantUML Examples Part 1](./07-plantuml-examples.md)** - Sequence, Use Case, Class
11. **[PlantUML Examples Part 2](./07b-plantuml-activity-component.md)** - Activity, Component


### PlantUML Salt (UI Mockups)


12. **[Salt Guide Part 1](./08-plantuml-salt-guide.md)** - What is Salt, Basic Widgets
13. **[Salt Guide Part 2](./08b-plantuml-salt-grid.md)** - Grid Layout, Modifiers
14. **[Salt Advanced Part 1](./09-plantuml-salt-advanced.md)** - Text Area, Tree, Separators
15. **[Salt Advanced Part 2](./09b-plantuml-salt-tabs-menu.md)** - Tabs, Menu, Colors
16. **[Salt Examples](./10-plantuml-salt-examples.md)** - Complete Examples, Best Practices


### Alternative Methods


17. **[XeLaTeX Alternative](./11-xelatex-alternative.md)** - For files WITHOUT diagrams


### Quick Reference


18. **[Quick Reference](./99-quick-reference.md)** - TL;DR, Comparison Tables


---


## Quick Start


**Export to PDF:**


```bash
/home/fong/Projects/textor-doc-converter/run-807f321188c6.sh '{"command":"export-md-to-pdf","data":"/absolute/path/file.md"}'
```


**Show Help:**


```bash
/home/fong/Projects/textor-doc-converter/run-807f321188c6.sh --help
```


---


## Troubleshooting with DKM RAG


**When to Use:** Rendering issues, syntax errors, or diagram best practices needed.


**Critical Rule:** NEVER rely solely on outdated trained knowledge. ALWAYS query RAG for up-to-date PlantUML/BPMN/Mermaid best practices.


**Workflow:**


1. **Identify Issue**: Syntax error, layout problem, or styling challenge
2. **Brainstorm Keywords**: Extract 2-4 technical terms (e.g., "PlantUML sequence diagram arrow types", "BPMN gateway syntax")
3. **Query DKM RAG**:
   - **First Priority**: `queryNewRAG` - Query PlantUML/BPMN books from collection
   - **Fallback**: `queryRAG` - Broader search across all technical books
   - **Reference**: `/home/fong/Projects/hub-fong-nckh-2025-1/.fong/instructions/instructions-dkm-sources-knowledgebase.md`
4. **Apply Best Practices**: Use book-sourced solutions, not assumptions from training data
5. **Verify**: Test syntax, check rendering, validate against examples


**RAG Collections for Diagrams:**


| Collection | Coverage | Use When |
|------------|----------|----------|
| Python Clean Code Books | General diagram principles | Architecture patterns, design clarity |
| DE-RAG PHP/WordPress | Software engineering diagrams | UML, component diagrams |
| NASA/Google Clean Code | Documentation standards | Code review diagrams, style guides |


**Example Query Pattern:**


```bash
# Query for PlantUML sequence diagram best practices
mcp__dkm-knowledgebase__queryNewRAG({
  "queries": ["PlantUML sequence diagram syntax", "UML interaction patterns"],
  "source_hashes": "838cc6ac...,41d80961..." # Relevant book hashes
})
```


**Benefits:**


- **Accurate Syntax**: Book-verified examples, not hallucinated code
- **Best Practices**: Industry-standard patterns from authoritative sources
- **Troubleshooting**: Specific error solutions from comprehensive references
- **Version-Aware**: Latest syntax for PlantUML/BPMN/Mermaid standards


---


## When to Use Which Tool


| Feature | Textor (with diagrams) | XeLaTeX (no diagrams) |
|---------|------------------------|----------------------|
| Mermaid support | Yes | No |
| PlantUML support | Yes | No |
| Images | Yes | Yes |
| Speed | Medium | Fast |
| Use when | Has diagrams | No diagrams |


---


**Next Step**: Read [Critical Rules Part 1](./01-critical-rules.md) →
