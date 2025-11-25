---
title: "Textor Doc Converter - README"
subtitle: "Mermaid & PlantUML Documentation Converter"
version: "3.0.0"
updated: "2025-11-15"
architecture: "Modular documentation (v3.0.0 split from 1487 LOC monolith)"
tool: "Document Converter CLI"
script_path: "/home/fong/Projects/textor-doc-converter/run-807f321188c6.sh"
---


# Textor Doc Converter - README


**Tool**: Document Converter CLI
**Script Path**: `/home/fong/Projects/textor-doc-converter/run-807f321188c6.sh`
**Version**: 3.0.0 - Modular Documentation Architecture
**Date**: 2025-11-15


**CRITICAL**: Read **[00-instructions-textor-doc-converter-mermaid-plantuml.md](./00-instructions-textor-doc-converter-mermaid-plantuml.md)** for complete navigation index.


---


## Overview


Textor Doc Converter là CLI tool để validate và convert markdown documents với diagram support (PlantUML + Mermaid) sang PDF format.


**Key Features:**


- Validate PlantUML diagrams (real errors từ PlantUML server)
- Validate Mermaid diagrams (real errors từ mermaid-cli)
- Export markdown to PDF with embedded diagrams
- Support mixed PlantUML + Mermaid trong cùng 1 document


---


## Quick Start


**Basic Export:**


```bash
/home/fong/Projects/textor-doc-converter/run-807f321188c6.sh '{"command":"export-md-to-pdf","data":"/absolute/path/file.md"}'
```


**Show Full Help:**


```bash
/home/fong/Projects/textor-doc-converter/run-807f321188c6.sh --help
```


---


## Documentation Structure


```
textor/
├── README.md                                  # This file - Overview + Quick Start
├── 00-instructions-textor-doc-converter-mermaid-plantuml.md  # Main index (NAVIGATION)
├── 01-critical-rules.md                       # Emoji, Heading, Spacing, Diagram Title, PlantUML Styling
├── 02-command-reference.md                    # Usage, Command Examples 1-5
├── 03-mermaid-guide.md                        # 13 Mermaid diagram types overview
├── 04-mermaid-examples.md                     # Flowchart, Class, Sequence, ER, State
├── 05-mermaid-examples-advanced.md            # Gantt, Git, Pie, Mindmap, Timeline, User Journey
├── 06-plantuml-guide.md                       # 11 PlantUML diagram types overview
├── 07-plantuml-examples.md                    # Sequence, Use Case, Class, Activity, Component
├── 08-plantuml-salt-guide.md                  # What is Salt, Basic Widgets, Grid Layout
├── 09-plantuml-salt-advanced.md               # Advanced Salt features (Text Area, Tabs, Menu, Colors)
├── 10-plantuml-salt-examples.md               # Complete examples, Best Practices
├── 11-xelatex-alternative.md                  # Alternative for no-diagram files
└── 99-quick-reference.md                      # TL;DR, Mermaid vs PlantUML comparison
```


---


## Navigation


**Start Here**: [00-instructions-textor-doc-converter-mermaid-plantuml.md](./00-instructions-textor-doc-converter-mermaid-plantuml.md) - Complete navigation index
