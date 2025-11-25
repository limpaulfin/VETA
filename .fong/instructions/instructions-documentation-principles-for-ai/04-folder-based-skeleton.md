# Folder-Based Skeleton - Template for Complex Instructions

**[⬅️ Back to Main Index](./00-instructions-documentation-principles-for-ai.md)**

---

## Overview

Complete template for folder-based modular instructions (>150 LOC total). Use when single-file would exceed LOC limit.

**Use When**: Complex, multi-step workflows with >150 LOC total

---

## Directory Structure Template

```
instructions-{topic}/
├── README.md                           # ~100 LOC
├── 00-instructions-{topic}.md          # ~100 LOC
├── 01-critical-rules.md                # ~80 LOC (if applicable)
├── 02-{concept-1}.md                   # <150 LOC
├── 03-{concept-2}.md                   # <150 LOC
├── 04-{tools-scripts}.md               # <150 LOC
├── 05-{workflow-overview}.md           # <150 LOC
├── 06-{workflow-step-1}.md             # <150 LOC
├── 07-{workflow-step-2}.md             # <150 LOC
├── 0N-{workflow-step-N}.md             # <150 LOC
└── 99-quick-reference.md               # ~100 LOC
```

---

## README.md Template

```markdown
# {Topic} - Modular Documentation

**Version**: X.Y.Z (Modular Architecture)
**Created**: YYYY-MM-DD
**Purpose**: {One-sentence purpose}

---

## 📂 Documentation Structure

This directory contains modular documentation (vX.Y.Z) with focused components (<150 LOC each).

### Core Files (Read in Order)

| # | File | LOC | Purpose |
|---|------|-----|---------|
| 00 | \`00-instructions-{topic}.md\` | ~100 | Main index & navigation hub |
| 01 | \`01-critical-rules.md\` | ~80 | Critical rules (⚠️ READ FIRST) |
| 02 | \`02-{concept}.md\` | <150 | {Concept description} |
| 99 | \`99-quick-reference.md\` | ~100 | TL;DR for experienced users |

### Architecture Principles

Following **Google SWE** documentation best practices:
1. **SSoT** - Each concept lives in one place
2. **Strategic Redundancy** - Critical rules repeated where needed
3. **Self-Contained** - Each file understandable standalone
4. **Cross-Referenced** - Rich navigation between related topics
5. **Focused** - Each file <150 LOC, single responsibility

---

## 🚀 Quick Start

**New users**: Start with \`00-instructions-{topic}.md\`
**Experienced users**: Jump to \`99-quick-reference.md\`
**Troubleshooting**: See \`01-critical-rules.md\`

---

## 🔗 Related Files

- **Scripts**: \`/path/to/scripts/\`
- **Memory**: \`.fong/.memory/{topic}/\`
- **Parent**: \`../instructions-{topic}.md\` (original, if exists)

---

**Start Reading**: [00-instructions-{topic}.md](./00-instructions-{topic}.md)
```

---

## 00-Main-Index.md Template

```markdown
---
title: "{Topic} - Modular Guide"
subtitle: "{One-line description}"
version: "X.Y.Z"
updated: "YYYY-MM-DD"
architecture: "Modular documentation with cross-referenced components"
---

# {Topic} - Main Index

**Version**: X.Y.Z (Modular Architecture)
**Created**: YYYY-MM-DD
**Last Updated**: YYYY-MM-DD
**Author**: {Name}
**Purpose**: {Purpose statement}

---

## 📋 NAVIGATION INDEX

### 🎯 Core Documentation

1. **[Critical Rules](./01-critical-rules.md)** ⚠️ **READ FIRST**
   - {Key rule 1}
   - {Key rule 2}

2. **[{Concept 1}](./02-{concept-1}.md)**
   - {What this covers}

3. **[{Concept 2}](./03-{concept-2}.md)**
   - {What this covers}

### 📝 Workflow Steps (Detailed)

4. **[Step 0: {Pre-check}](./06-{step-0}.md)** (MANDATORY)
   - {What to verify}

5. **[Steps 1-3: {Actions}](./07-{steps-1-3}.md)**
   - {Summary}

### 📚 Reference Materials

N. **[Quick Reference](./99-quick-reference.md)**
   - TL;DR commands
   - Common workflows

---

## 🎯 Overview

{2-3 paragraphs: What this is, input/output, processing pipeline}

**Input**: {What goes in}
**Output**: {What comes out}
**Processing Pipeline**: {High-level flow diagram}

---

## 🚀 Quick Start

1. Read **[Critical Rules](./01-critical-rules.md)** first ⚠️
2. Run **[Step 0](./06-{step-0}.md)** (MANDATORY)
3. Follow steps sequentially
4. For experienced users: **[Quick Reference](./99-quick-reference.md)**

---

## 📊 Version History

- **vX.Y.Z** (YYYY-MM-DD): {Change description}
```

---

## 01-Critical-Rules.md Template

```markdown
# Critical Rules - {Topic}

**[⬅️ Back to Main Index](./00-instructions-{topic}.md)**

---

## ⚠️ CRITICAL RULES (MANDATORY)

1. **{Rule 1 Title}**: {Description}
2. **{Rule 2 Title}**: {Description}
3. **{Rule 3 Title}**: {Description}

---

## {Special Rule Section (if applicable)}

### Example: "NO QUIT RULE" - 100% OKR Philosophy

**Philosophy**: {Principle description}

**Rules**:
1. {Sub-rule 1}
2. {Sub-rule 2}

---

## 📋 Related Documents

- **[{Related File 1}](./XX-{related}.md)** - {Description}
- **[Main Index](./00-instructions-{topic}.md)** - Return to navigation
```

---

## 02-0N-Content-Files.md Template

```markdown
# {Title} - {Descriptive Subtitle}

**[⬅️ Back to Main Index](./00-instructions-{topic}.md)**

---

## Overview

{2-3 sentences describing what this file covers}

---

## {Section 1}

{Content}

---

## {Section 2}

{Content}

---

## Examples

### Example 1: {Use Case}

\`\`\`bash
command --flag value
\`\`\`

---

## Related Documents

- **[{Related File 1}](./XX-{related}.md)** - {Description}
- **[Main Index](./00-instructions-{topic}.md)** - Return to navigation
```

---

## 99-Quick-Reference.md Template

```markdown
# Quick Reference - {Topic}

**[⬅️ Back to Main Index](./00-instructions-{topic}.md)**

---

## TL;DR Principles

1. **{Principle 1}**: {One-line summary}
2. **{Principle 2}**: {One-line summary}
3. **{Principle 3}**: {One-line summary}

---

## Common Commands

\`\`\`bash
# {Task 1}
command1 --flag value

# {Task 2}
command2 --option arg

# {Task 3}
command3 /path/to/file
\`\`\`

---

## Pattern Decision Tree

1. {Condition} → Use {Pattern A}
2. {Condition} → Use {Pattern B}
3. {Condition} → Use {Pattern C}

---

## Troubleshooting

| Issue | Quick Fix |
|-------|-----------|
| {Problem 1} | \`command --fix\` |
| {Problem 2} | \`command --reset\` |

---

## Cheatsheet

| Task | Command | Notes |
|------|---------|-------|
| {Task 1} | \`cmd1\` | {Note} |
| {Task 2} | \`cmd2\` | {Note} |

---

**Full Details**: [Main Index](./00-instructions-{topic}.md)
```

---

## File Naming Convention

### Numbering Scheme

- `00-` : Main index (navigation hub)
- `01-` : Critical rules (if safety-critical)
- `02-05-` : Core concepts (naming, tools, workflows)
- `06-10-` : Detailed workflow steps
- `11-20-` : Additional workflows (if needed)
- `99-` : Quick reference (TL;DR)

### Descriptive Names

- **Good**: `03-naming-convention.md`
- **Bad**: `03-names.md`, `03-file3.md`

### Hyphenation

- Use hyphens for multi-word names: `07-workflow-steps-1-3.md`
- Avoid underscores: `07_workflow_steps_1_3.md` ❌

---

## Complete Example (PDF Batch Processing Workflow)

```
instructions-pdf-batch-processing-workflow/
├── README.md                                               # 117 LOC
├── 00-instructions-pdf-batch-processing-workflow.md        # 148 LOC
├── 01-critical-rules.md                                    # 81 LOC
├── 02-file-count-checklist.md                              # 75 LOC
├── 03-naming-convention.md                                 # 83 LOC
├── 04-tools-scripts.md                                     # 119 LOC
├── 05-filter-workflows.md                                  # 134 LOC
├── 06-workflow-step-0-precheck.md                          # 85 LOC
├── 07-workflow-steps-1-3-rename-convert-archive.md         # NEW
├── 08-workflow-step-4-scanned-detection.md                 # NEW
├── 09-workflow-steps-5-6-duplicate-tree.md                 # NEW
├── 10a-workflow-step-7a-smart-search.md                    # NEW
├── 10b-workflow-step-7b-hash-comparison.md                 # NEW
└── 99-quick-reference.md                                   # 110 LOC
```

**Total**: 14 files, 81-148 LOC each (average ~100 LOC)

---

## Checklist Before Committing

- [ ] All files have frontmatter (if applicable)
- [ ] Each file <150 LOC (`wc -l *.md`)
- [ ] README.md present with architecture overview
- [ ] 00-main-index.md present with navigation
- [ ] All cross-references valid (test links)
- [ ] Numbering convention consistent
- [ ] Quick reference (99-*.md) present
- [ ] Version history updated in affected files
- [ ] Memory file created (`.fong/.memory/YYYY-MM-DD-{topic}.md`)

---

## Related Documents

- **[Architecture Patterns](./02-architecture-patterns.md)** - When to use folder-based
- **[Single-File Skeleton](./03-single-file-skeleton.md)** - Template for simple docs
- **[Cross-Referencing Patterns](./05-cross-referencing-patterns.md)** - How to link files
- **[Main Index](./00-instructions-documentation-principles-for-ai.md)** - Return to navigation
