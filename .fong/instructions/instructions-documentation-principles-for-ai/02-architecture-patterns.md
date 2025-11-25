# Architecture Patterns - Documentation Structures

**[⬅️ Back to Main Index](./00-instructions-documentation-principles-for-ai.md)**

---

## Overview

Three architecture patterns for organizing technical documentation. Choose based on complexity and LOC count.

**Decision Tree**:
1. <150 LOC, simple → **Single-File**
2. >150 LOC, complex → **Folder-Based**
3. Main <150 LOC but extensive examples → **Hybrid** (rare)

---

## Pattern 1: Single-File Instructions

### When to Use

- **LOC**: <150 (strict limit)
- **Complexity**: Simple, linear workflow
- **Sub-workflows**: 0-1
- **Maintenance**: Low frequency

### Structure

```
instructions-{topic}.md
  ├── Frontmatter (YAML)
  ├── Purpose & Scope
  ├── Critical Rules (⚠️ sections)
  ├── Main Content (workflow steps)
  ├── Examples
  ├── Troubleshooting
  ├── Related Files
  └── Version History
```

### Examples

- `instructions-mem0.md` - Mem0 API usage (87 LOC)
- `instructions-autodebug-python.md` - Python debugging automation (95 LOC)
- `instructions-read-long-file.md` - Large file processing (72 LOC)

### Template

See **[Single-File Skeleton](./03-single-file-skeleton.md)** for complete template.

---

## Pattern 2: Folder-Based Modular Instructions

### When to Use

- **LOC**: >150 (would exceed single-file limit)
- **Complexity**: Multi-step, branching workflows
- **Sub-workflows**: 2+ distinct workflows
- **Maintenance**: High frequency, multiple contributors

### Structure

```
instructions-{topic}/
├── README.md                           # ~100 LOC, overview + quick start
├── 00-instructions-{topic}.md          # ~100 LOC, main index, navigation
├── 01-critical-rules.md                # ~80 LOC, safety rules
├── 02-{concept-1}.md                   # <150 LOC, focused topic
├── 03-{concept-2}.md                   # <150 LOC, focused topic
├── 04-{tools-scripts}.md               # <150 LOC, tool reference
├── 05-{workflow-overview}.md           # <150 LOC, high-level flow
├── 06-{workflow-step-1}.md             # <150 LOC, detailed step
├── 07-{workflow-step-2}.md             # <150 LOC, detailed step
├── 0N-{workflow-step-N}.md             # <150 LOC, detailed step
└── 99-quick-reference.md               # ~100 LOC, TL;DR cheatsheet
```

### File Responsibilities

| File | Responsibility | LOC Target |
|------|----------------|------------|
| `README.md` | Overview, quick start, architecture principles | ~100 |
| `00-*.md` | Main index, navigation hub, decision tree | ~100 |
| `01-*.md` | Critical rules, safety constraints | ~80 |
| `02-05-*.md` | Core concepts (naming, tools, filters, workflows) | <150 each |
| `06-10-*.md` | Detailed step-by-step workflows | <150 each |
| `99-*.md` | Quick reference, TL;DR, cheatsheet | ~100 |

### Examples

- `instructions-pdf-batch-processing-workflow/` (14 files, 81-134 LOC each)
  - Original: 2069 LOC monolithic file
  - Refactored: v4.0.0 modular architecture

### Template

See **[Folder-Based Skeleton](./04-folder-based-skeleton.md)** for complete template.

---

## Pattern 3: Hybrid (Main + Appendices)

### When to Use

- **LOC**: Main workflow <150, but extensive reference tables/examples
- **Complexity**: Medium complexity with detailed appendices
- **Sub-workflows**: 1-2 with comprehensive examples
- **Maintenance**: Medium frequency

### Structure

```
instructions-{topic}.md          # Main file <150 LOC
appendix-{topic}-examples.md     # Examples, edge cases
appendix-{topic}-reference.md    # Tables, schemas, specs
appendix-{topic}-api.md          # API reference (if applicable)
```

### When NOT to Use

- If main file >150 LOC → use **Folder-Based** instead
- If <5 examples → include in main file (no appendix needed)
- If multiple workflows → use **Folder-Based** for better organization

### Example (Hypothetical)

```
instructions-api-integration.md              # 120 LOC - main workflow
appendix-api-integration-examples.md         # 200 LOC - 20 examples
appendix-api-integration-reference.md        # 150 LOC - endpoint specs
```

**Note**: This pattern is rare. Most cases use **Single-File** or **Folder-Based**.

---

## Comparison Table

| Criteria | Single-File | Folder-Based | Hybrid |
|----------|-------------|--------------|--------|
| **LOC** | <150 | >150 | Main <150 + appendices |
| **Complexity** | Simple, linear | Multi-step, branching | Medium complexity |
| **Sub-workflows** | 0-1 | 2+ | 1-2 with extensive examples |
| **Files** | 1 | 10-20 | 2-4 |
| **Maintenance** | Low | High | Medium |
| **Navigation** | Single scroll | Cross-links | Main + appendix links |
| **AI Parsing** | Easy | Easy (if cross-referenced) | Medium |
| **Examples** | mem0, autodebug | pdf-batch-workflow | (rare) |

---

## Decision Tree

```
Start
  ↓
Is LOC <150?
  ↓
Yes → Single-File Pattern
  |
  ↓
Does it have extensive tables/examples?
  ↓
  Yes → Consider Hybrid Pattern
  No  → Use Single-File Pattern

No (LOC >150)
  ↓
Folder-Based Pattern
  ↓
How many sub-workflows?
  ↓
  0-1  → Reconsider: Can you simplify to <150 LOC?
  2-5  → Use 10-15 files
  6+   → Use 15-20 files
```

---

## Migration Path

### Single-File → Folder-Based (When to Refactor)

**Triggers**:
1. File approaching 150 LOC
2. Adding 3+ sub-workflows
3. Multiple contributors need to edit different sections
4. Becoming hard to navigate

**Steps**:
1. Create folder `instructions-{topic}/`
2. Create `README.md` (extract overview)
3. Create `00-main-index.md` (extract navigation)
4. Split content by topic into `01-0N-*.md` files
5. Extract quick reference to `99-quick-reference.md`
6. Update all cross-references
7. Test navigation
8. Archive original file (rename to `_archived-instructions-{topic}.md`)

**Example**: PDF batch workflow v3.0 (2069 LOC) → v4.0 (14 files, 81-134 LOC each)

---

## Best Practices

### For All Patterns

1. **Frontmatter**: Always include YAML frontmatter with version, purpose, scope
2. **LOC Tracking**: Add `max_loc` to frontmatter, check with `wc -l`
3. **Cross-References**: Use relative links `./XX-file.md` (folder) or absolute paths (external)
4. **Version History**: Track changes at bottom of each file

### For Folder-Based

1. **Numbering**: Use `00-`, `01-`, `02-`, ..., `99-` prefix for ordering
2. **README First**: Always start with `README.md` (overview + navigation)
3. **Main Index**: `00-*.md` is navigation hub, not detailed content
4. **Critical Rules**: If safety-critical, create `01-critical-rules.md`
5. **Quick Reference**: Always include `99-quick-reference.md` for experienced users

---

## Related Documents

- **[Single-File Skeleton](./03-single-file-skeleton.md)** - Template for Pattern 1
- **[Folder-Based Skeleton](./04-folder-based-skeleton.md)** - Template for Pattern 2
- **[Core Principles](./01-core-principles.md)** - Why these patterns exist
- **[Main Index](./00-instructions-documentation-principles-for-ai.md)** - Return to navigation
