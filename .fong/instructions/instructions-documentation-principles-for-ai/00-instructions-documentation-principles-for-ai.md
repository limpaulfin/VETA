---
title: "Documentation Principles for AI - Main Index"
subtitle: "Guide for creating AI-readable technical documentation"
version: "1.0.0"
updated: "2025-11-12"
architecture: "Modular documentation with cross-referenced components"
---

# Documentation Principles for AI - Main Index

**Version**: 1.0.0 (Modular Architecture)
**Created**: 2025-11-12
**Last Updated**: 2025-11-12
**Author**: Fong
**Purpose**: Core principles for creating AI-readable technical documentation and instructions

---

## 📋 NAVIGATION INDEX

### 🎯 Core Documentation

1. **[Core Principles](./01-core-principles.md)** ⚠️ **READ FIRST**
   - DRY (Don't Repeat Yourself)
   - SSoT (Single Source of Truth)
   - Modularity (<150 LOC per file)
   - WBS (Work Breakdown Structure)
   - Progressive Disclosure
   - Traceability

2. **[Architecture Patterns](./02-architecture-patterns.md)**
   - Single-file instructions (<150 LOC)
   - Folder-based modular (v4.0.0 style)
   - Hybrid (main + appendices)

### 📝 Templates & Skeletons

3. **[Single-File Skeleton](./03-single-file-skeleton.md)**
   - Frontmatter template
   - Core sections structure
   - Optional sections
   - Example workflow

4. **[Folder-Based Skeleton](./04-folder-based-skeleton.md)**
   - Directory structure
   - README.md template
   - 00-main-index.md template
   - Modular file templates

### 📚 Best Practices

5. **[Cross-Referencing Patterns](./05-cross-referencing-patterns.md)**
   - Internal links (same folder)
   - External links (other instructions)
   - Script references
   - Memory file references
   - Code location references
   - Breadcrumb navigation

6. **[AI-Readability Guidelines](./06-ai-readability-guidelines.md)**
   - 10 rules for AI-friendly writing
   - Structured formats
   - Explicit constraints
   - Example patterns

7. **[Terminology Standards](./07-terminology-standards.md)**
   - File path conventions
   - Version notation
   - Action verbs
   - Constraint indicators
   - Status indicators

8. **[Anti-Patterns to Avoid](./08-anti-patterns.md)**
   - Yapping (excessive verbosity)
   - Ambiguous instructions
   - Missing verification steps
   - Copy-paste duplication
   - And more...

9. **[Script Organization Patterns](./09-script-organization-patterns.md)** 🆕
   - Scripts subfolder with venv
   - README requirements
   - Algorithm documentation (pseudocode + diagrams)
   - Cross-reference patterns
   - Real-world examples

### 🚀 Quick Access

10. **[Quick Reference](./99-quick-reference.md)**
   - TL;DR principles
   - Pattern decision tree
   - Common templates
   - Cheatsheet

---

## 🎯 Overview

This guide provides **core principles and patterns** for creating technical documentation that AI can:
- **Read** accurately (structured, unambiguous)
- **Understand** semantically (clear terminology, explicit constraints)
- **Execute** effectively (actionable steps, verifiable outcomes)
- **Trace** dependencies (cross-references, breadcrumbs)

**Audience**: AI agents (Claude, GPT, etc.), not humans

**Key Constraint**: Balance brevity (Pareto 80/20) with completeness. No yapping. Precise terminology only.

**Processing Pipeline**:
```
Define Purpose → Choose Pattern → Apply Skeleton → Write Content → Cross-Reference → Verify LOC → Commit
```

---

## 🚀 Quick Start

### For New Documentation Writers

1. Read **[Core Principles](./01-core-principles.md)** first ⚠️
2. Choose pattern: **[Architecture Patterns](./02-architecture-patterns.md)**
3. Apply skeleton: **[Single-File](./03-single-file-skeleton.md)** or **[Folder-Based](./04-folder-based-skeleton.md)**
4. Follow best practices: **[AI-Readability](./06-ai-readability-guidelines.md)**
5. Verify: LOC limit, cross-references, terminology

### For Experienced Writers

- Jump to **[Quick Reference](./99-quick-reference.md)** for TL;DR
- Use **[Templates](./03-single-file-skeleton.md)** directly
- Check **[Anti-Patterns](./08-anti-patterns.md)** before committing

---

## 📊 When to Use Which Pattern

| Criteria | Single-File | Folder-Based | Hybrid |
|----------|-------------|--------------|--------|
| **LOC** | <150 | >150 | Main <150 + appendices |
| **Complexity** | Simple, linear | Multi-step, branching | Medium complexity |
| **Sub-workflows** | 0-1 | 2+ | 1-2 with extensive examples |
| **Maintenance** | Low | High | Medium |
| **Example** | `instructions-mem0.md` | `instructions-pdf-batch-processing-workflow/` | N/A (rare) |

**Decision Rule**:
1. Start with **single-file**
2. If approaching 150 LOC → refactor to **folder-based**
3. If extensive tables/examples → consider **hybrid**

---

## 📂 Standard Folder Structure (Folder-Based Pattern)

```
instructions-{topic}/
├── README.md                           # ~100 LOC, overview + quick start
├── 00-instructions-{topic}.md          # ~100 LOC, main index
├── 01-critical-rules.md                # ~80 LOC, safety rules (if applicable)
├── 02-{concept-1}.md                   # <150 LOC, focused topic
├── 03-{concept-2}.md                   # <150 LOC, focused topic
├── 04-{tools-scripts}.md               # <150 LOC, tool reference
├── 05-{workflow-overview}.md           # <150 LOC, high-level flow
├── 06-{workflow-step-1}.md             # <150 LOC, detailed step
├── 07-{workflow-step-2}.md             # <150 LOC, detailed step
├── 0N-{workflow-step-N}.md             # <150 LOC, detailed step
└── 99-quick-reference.md               # ~100 LOC, TL;DR cheatsheet
```

---

## 📝 Version History

- **v1.0.0** (2025-11-12): Modular architecture - split from 620 LOC monolithic file into 10 focused files (60-120 LOC each)

---

**Next Step**: Read [Core Principles](./01-core-principles.md) →
