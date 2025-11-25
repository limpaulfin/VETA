# Core Principles - Documentation for AI

**[⬅️ Back to Main Index](./00-instructions-documentation-principles-for-ai.md)**

---

## Overview

Six fundamental principles for creating AI-readable technical documentation. These principles ensure modularity, maintainability, and semantic clarity.

**Key Rule**: All principles work together - apply holistically, not in isolation.

---

## 1. DRY (Don't Repeat Yourself)

**Definition**: Each piece of knowledge must have a single, unambiguous representation

**Core Rule**: Never copy-paste content. Extract and reference instead.

### Application

- **Extract common content** to separate files
  - Example: `01-critical-rules.md` (used by multiple workflows)

- **Use cross-references** instead of duplication
  - Example: "See [Naming Convention](./03-naming-convention.md)" instead of repeating rules

- **Strategic redundancy** ONLY for critical safety rules
  - Example: "⚠️ CRITICAL: Verify file count" repeated in multiple places for safety
  - Justification: Safety > DRY in critical contexts

### Example

**Bad** (violates DRY):
```markdown
# File A
Naming format: YYYY-Title-Author.PDF

# File B
Naming format: YYYY-Title-Author.PDF

# File C
Naming format: YYYY-Title-Author.PDF
```

**Good** (follows DRY):
```markdown
# 03-naming-convention.md
Naming format: YYYY-Title-Author.PDF

# File A
See [Naming Convention](./03-naming-convention.md)

# File B
See [Naming Convention](./03-naming-convention.md)
```

---

## 2. SSoT (Single Source of Truth)

**Definition**: One authoritative location for each piece of information

**Core Rule**: Each fact lives in exactly one place. All references point to that place.

### Application

- **Main index file** (e.g., `00-*.md`) acts as navigation hub
  - Contains navigation, overview, quick start
  - Does NOT contain detailed content

- **Detailed content** lives in dedicated files
  - Example: `03-naming-convention.md` is the SSoT for naming rules
  - All other files link to it, never duplicate it

- **Version tracking** in frontmatter
  - Each file has own version
  - Folder has overall architecture version

### Example

**Structure**:
```
00-main-index.md          # SSoT for navigation
01-critical-rules.md      # SSoT for safety rules
03-naming-convention.md   # SSoT for naming format
```

**Navigation pattern**:
- Main index → points to all topics
- Topic files → self-contained, single responsibility
- Cross-references → bidirectional (parent ↔ child)

---

## 3. Modularity

**Definition**: Decompose complex documentation into focused, self-contained units

**Core Rule**: One file = one responsibility. Strict LOC limits enforce decomposition.

### Metrics

- **Single-file instructions**: <150 LOC (strict), <100 LOC (optimal)
- **Folder-based files**: Each file <150 LOC
- **Total folder size**: No limit (decompose as needed)

### Application

**When to split**:
1. File approaching 150 LOC → refactor
2. Multiple distinct topics in one file → split by topic
3. Long workflow → split by steps

**Example refactor**:
```
Before: instructions-pdf-workflow.md (2069 LOC) ❌
After:  instructions-pdf-workflow/ (14 files, 81-134 LOC each) ✅
```

### Enforcement

Add to frontmatter:
```yaml
max_loc: 150
```

Check before commit:
```bash
wc -l instructions-{topic}.md
```

---

## 4. WBS (Work Breakdown Structure)

**Definition**: Hierarchical decomposition of documentation deliverables

**Core Rule**: Organize by logical hierarchy, mutually exclusive, collectively exhaustive.

### Levels

- **L0**: Project/system overview (`README.md`)
- **L1**: Main index with navigation (`00-*.md`)
- **L2**: Core concepts (`01-05-*.md`)
- **L3**: Detailed workflows (`06-10-*.md`)
- **L4**: Reference materials (`99-*.md`)

### Principles

1. **Mutually exclusive**: No overlap between files
2. **Collectively exhaustive**: All topics covered
3. **Logical grouping**: Related content together
4. **Numbering convention**: `XX-descriptive-name.md`

### Example

```
instructions-pdf-batch-workflow/
├── L0: README.md                    # Overview
├── L1: 00-main-index.md             # Navigation
├── L2: 01-critical-rules.md         # Concepts
├── L2: 02-file-count-checklist.md   # Concepts
├── L2: 03-naming-convention.md      # Concepts
├── L3: 06-workflow-step-0.md        # Workflows
├── L3: 07-workflow-steps-1-3.md     # Workflows
└── L4: 99-quick-reference.md        # Reference
```

---

## 5. Progressive Disclosure

**Definition**: Present essential information first, details on-demand

**Core Rule**: Critical → Common → Detailed → Reference

### Ordering Strategy

1. **Critical rules first** (`01-critical-rules.md`)
   - Safety-critical
   - Non-negotiable constraints
   - Common failure modes

2. **Core concepts** (`02-05-*.md`)
   - Naming conventions
   - Tool references
   - Workflow overview

3. **Detailed workflows** (`06-10-*.md`)
   - Step-by-step procedures
   - Edge cases
   - Troubleshooting

4. **Quick reference** (`99-quick-reference.md`)
   - TL;DR for experienced users
   - Command cheatsheet

### Example

User journey:
1. Read `01-critical-rules.md` (81 LOC, 2 min) → understand constraints
2. Skim `00-main-index.md` (100 LOC, 3 min) → understand structure
3. Deep-dive `06-workflow-step-0.md` (85 LOC, 5 min) → execute first step
4. Reference `99-quick-reference.md` (110 LOC, 1 min) → quick commands

---

## 6. Traceability

**Definition**: Clear links between documentation units and related artifacts

**Core Rule**: Every concept traces to source (code, memory, related docs)

### Types of Links

1. **Documentation → Code**
   - Example: `Script: /home/fong/Projects/mini-rag/tools/rename-pdfs.py`

2. **Documentation → Memory**
   - Example: `Memory: .fong/.memory/2025-11-12-pdf-workflow.md`

3. **Documentation → Documentation**
   - Example: `See [Naming Convention](./03-naming-convention.md)`

4. **Code → Documentation**
   - Example: Function comment `# See instructions-pdf-workflow/07-*.md:45`

5. **Bidirectional navigation**
   - Parent → Child: "See detailed steps in [Workflow](./06-*.md)"
   - Child → Parent: "[⬅️ Back to Main Index](./00-*.md)"

### Example

```markdown
## Step 1: Rename PDFs

**Script**: `/home/fong/Projects/mini-rag/tools/rename-pdfs-year-first.py`
**Memory**: `.fong/.memory/2025-11-12-pdf-rename-100pct.md`
**Related**: See [Naming Convention](./03-naming-convention.md) for format rules

[⬅️ Back to Main Index](./00-instructions-pdf-batch-workflow.md)
```

---

## How Principles Work Together

**Example**: PDF Batch Processing Workflow v4.0.0

1. **DRY**: Naming convention defined once in `03-naming-convention.md`
2. **SSoT**: All files reference `03-naming-convention.md`, never duplicate
3. **Modularity**: 2069 LOC → 14 files (81-134 LOC each)
4. **WBS**: L0 (README) → L1 (00-index) → L2 (concepts) → L3 (workflows) → L4 (reference)
5. **Progressive Disclosure**: Critical rules (01) → Concepts (02-05) → Workflows (06-10) → Reference (99)
6. **Traceability**: Each workflow links to scripts, memory, related docs

**Result**: Maintainable, navigable, AI-readable documentation

---

## Related Documents

- **[Architecture Patterns](./02-architecture-patterns.md)** - How to structure docs
- **[Single-File Skeleton](./03-single-file-skeleton.md)** - Template for simple docs
- **[Folder-Based Skeleton](./04-folder-based-skeleton.md)** - Template for complex docs
- **[Main Index](./00-instructions-documentation-principles-for-ai.md)** - Return to navigation
