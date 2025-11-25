# Anti-Patterns - Common Mistakes to Avoid

**[⬅️ Back to Main Index](./00-instructions-documentation-principles-for-ai.md)**

---

## Overview

Eight common anti-patterns in technical documentation. Learn what NOT to do.

**Principle**: Learning from bad examples is as valuable as learning from good ones.

---

## ❌ 1. Yapping (Excessive Verbosity)

### Bad Example

```markdown
So, like, when you're working with files, it's really important to make sure
that you check the file count because, you know, sometimes files can get lost
during processing and that would be bad because then you wouldn't have all your
files anymore. So what you should do is count them before and after to make sure
everything is there. This is a really critical step that you shouldn't skip
because data loss is a serious problem.
```

### Good Example

```markdown
**CRITICAL**: Verify file count before/after each operation to detect data loss.

**Command**:
\`\`\`bash
ls -1 *.pdf | wc -l
# Expected: Same count before and after
\`\`\`
```

### Rule

- **Max**: 2-3 sentences per paragraph
- **Prefer**: Bullet points, tables, code blocks
- **No**: Filler words ("really", "you know", "so", "like")

---

## ❌ 2. Ambiguous Instructions

### Bad Example

```markdown
Process the files appropriately and make sure everything is done correctly.
```

### Good Example

```markdown
**Rename files to YYYY-Title-Author.PDF format**:

\`\`\`bash
python /home/fong/Projects/mini-rag/tools/rename-pdfs-year-first.py \\
  --input /path/to/pdfs \\
  --method filename,pages1-5,pages6-9

# Verification
ls -1 *.PDF | head -3
# Expected: 2020-Clean-Code-Martin.PDF
\`\`\`
```

### Rule

- **Always**: Specify exact commands
- **Always**: Define expected outcomes
- **Never**: Use vague verbs ("process", "handle", "deal with")

---

## ❌ 3. Missing Verification Steps

### Bad Example

```markdown
## Step 1: Rename Files

\`\`\`bash
python rename.py
\`\`\`

## Step 2: Continue to Next Step
```

### Good Example

```markdown
## Step 1: Rename Files

**Command**:
\`\`\`bash
python rename.py --input /path/to/pdfs
\`\`\`

**Verification**:
\`\`\`bash
# Check count matches
before=$(cat /tmp/count-before.txt)
after=$(ls -1 *.PDF | wc -l)

if [ "$before" -eq "$after" ]; then
    echo "✅ All files renamed ($after/$before)"
else
    echo "❌ File count mismatch (expected $before, got $after)"
    exit 1
fi
\`\`\`

**Rollback**:
\`\`\`bash
git restore .  # Undo all changes
\`\`\`
```

### Rule

- **Every step** needs:
  1. Goal (what it achieves)
  2. Command (how to execute)
  3. Verification (how to confirm success)
  4. Rollback (how to undo if failed)

---

## ❌ 4. Mixing Concerns in One File

### Bad Example

```markdown
# PDF Batch Processing (2069 lines)

## Critical Rules
...

## Naming Convention
...

## Tools & Scripts
...

## Workflow Step 1
...

## Workflow Step 2
...

## Examples
...

## Troubleshooting
...
```

**Problem**: Single 2069-line monolithic file, hard to navigate

### Good Example

```markdown
instructions-pdf-batch-processing-workflow/
├── README.md                    # Overview
├── 00-main-index.md             # Navigation
├── 01-critical-rules.md         # Safety rules (81 LOC)
├── 03-naming-convention.md      # Naming format (83 LOC)
├── 04-tools-scripts.md          # Tool reference (119 LOC)
├── 07-workflow-steps-1-3.md     # Steps 1-3 (detailed)
└── 99-quick-reference.md        # TL;DR (110 LOC)
```

**Solution**: Split into 14 focused files (81-134 LOC each)

### Rule

- **Single-file**: <150 LOC (strict)
- **If exceeds**: Refactor to folder-based modular structure
- **Each file**: Single responsibility, one topic

---

## ❌ 5. Copy-Paste Duplication

### Bad Example

```markdown
# File A: Step 1
Naming format: YYYY-Title-Author.PDF

# File B: Step 2
Naming format: YYYY-Title-Author.PDF

# File C: Step 5
Naming format: YYYY-Title-Author.PDF

# File D: Quick Reference
Naming format: YYYY-Title-Author.PDF
```

**Problem**: Violates DRY - same content in 4 places

### Good Example

```markdown
# 03-naming-convention.md (SSoT)
Naming format: YYYY-Title-Author.PDF

# File A: Step 1
See [Naming Convention](./03-naming-convention.md) for format rules.

# File B: Step 2
Follow [Naming Convention](./03-naming-convention.md).

# File C: Step 5
Apply [Naming Convention](./03-naming-convention.md).
```

**Solution**: Define once, reference everywhere

### Rule

- **DRY**: Don't Repeat Yourself
- **SSoT**: Single Source of Truth
- **Exception**: Critical safety rules (strategic redundancy)

---

## ❌ 6. Relative Paths Without Context

### Bad Example

```markdown
**Script**: `../tools/script.py`
**Memory**: `../../.memory/pdf-workflow.md`
```

**Problem**: Which parent directory? Ambiguous.

### Good Example

```markdown
**Script**: `/home/fong/Projects/mini-rag/tools/rename-pdfs-year-first.py`
**Memory**: `.fong/.memory/2025-11-12-pdf-workflow.md`
```

**Solution**: Absolute paths (no ambiguity)

### Rule

- **Always**: Use absolute paths for scripts, memory, external files
- **Exception**: Cross-references within same folder (`./01-rules.md`)

---

## ❌ 7. Vague Constraints

### Bad Example

```markdown
- Files should be reasonably small
- Use appropriate naming
- Don't make files too big
- Keep things organized
```

**Problem**: "Reasonably"? "Appropriate"? "Too big"? No metrics.

### Good Example

```markdown
**Constraints**:
- File size: <10MB (strict limit)
- Naming: YYYY-Title-Author.PDF (exact format)
- LOC: <150 per file (strict), <100 (optimal)
- Timeout: 30 seconds (network requests)
```

**Solution**: Quantify everything

### Rule

- **Always**: Use numbers, ranges, exact formats
- **Never**: Use "reasonable", "appropriate", "good", "small", "large"

---

## ❌ 8. Missing LOC Budget

### Bad Example

```markdown
---
title: "Instruction Title"
version: "1.0.0"
---

# Content
... (500 lines later)
```

**Problem**: No awareness of file size, violates modularity

### Good Example

```markdown
---
title: "Instruction Title"
version: "1.0.0"
max_loc: 150  # Self-documenting constraint
---

# Content
... (120 lines total)
```

**Verification**:
```bash
wc -l instructions-topic.md
# 120 instructions-topic.md ✅ (under 150 limit)
```

### Rule

- **Add**: `max_loc: 150` to frontmatter
- **Check**: `wc -l file.md` before committing
- **If exceeds**: Refactor to folder-based structure

---

## Summary Table

| Anti-Pattern | Impact | Solution | Priority |
|--------------|--------|----------|----------|
| 1. Yapping | Wastes tokens, hard to parse | Use bullet points, tables | High |
| 2. Ambiguous instructions | AI cannot execute | Exact commands + verification | Critical |
| 3. Missing verification | No error detection | Add verification + rollback | Critical |
| 4. Mixing concerns | Hard to navigate | Split into focused files | High |
| 5. Copy-paste duplication | Maintenance nightmare | DRY + SSoT + cross-references | High |
| 6. Relative paths | Ambiguous, brittle | Use absolute paths | Medium |
| 7. Vague constraints | Unclear expectations | Quantify everything | Medium |
| 8. Missing LOC budget | Violates modularity | Add `max_loc` to frontmatter | Medium |

---

## Checklist Before Committing

- [ ] No yapping (concise, bullet points, tables)
- [ ] No ambiguous instructions (exact commands specified)
- [ ] All steps have verification + rollback
- [ ] No mixing concerns (single responsibility per file)
- [ ] No copy-paste (DRY + SSoT applied)
- [ ] No relative paths (absolute paths used)
- [ ] No vague constraints (all quantified)
- [ ] LOC budget tracked (`max_loc` in frontmatter)
- [ ] File count <150 LOC (`wc -l` verified)

---

## Related Documents

- **[Core Principles](./01-core-principles.md)** - Positive principles (what to do)
- **[AI-Readability Guidelines](./06-ai-readability-guidelines.md)** - Best practices
- **[Terminology Standards](./07-terminology-standards.md)** - Consistent language
- **[Main Index](./00-instructions-documentation-principles-for-ai.md)** - Return to navigation
