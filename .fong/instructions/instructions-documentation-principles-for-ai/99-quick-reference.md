# Quick Reference - TL;DR Cheatsheet

**[⬅️ Back to Main Index](./00-instructions-documentation-principles-for-ai.md)**

---

## TL;DR Core Principles

1. **DRY**: Don't Repeat Yourself - Extract common content, use cross-references
2. **SSoT**: Single Source of Truth - One authoritative location per concept
3. **Modularity**: <150 LOC per file (strict), <100 LOC (optimal)
4. **WBS**: Hierarchical decomposition (L0→L1→L2→L3→L4)
5. **Progressive Disclosure**: Critical → Common → Detailed → Reference
6. **Traceability**: Link docs ↔ code ↔ scripts ↔ memory

---

## Pattern Decision Tree

```
LOC <150?
├─ Yes → Single-File Pattern
│  └─ Has extensive tables/examples?
│     ├─ Yes → Consider Hybrid Pattern
│     └─ No → Use Single-File Pattern
└─ No (LOC >150) → Folder-Based Pattern
   └─ How many sub-workflows?
      ├─ 0-1 → Simplify to <150 LOC?
      ├─ 2-5 → Use 10-15 files
      └─ 6+ → Use 15-20 files
```

---

## Common Templates

### Single-File Frontmatter

```yaml
---
title: "Instruction Title - Descriptor"
version: "X.Y.Z"
created: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
author: "Author Name"
purpose: "One-sentence purpose"
scope: "What's included/excluded"
max_loc: 150
---
```

### Folder-Based Directory Structure

```
instructions-{topic}/
├── README.md                    # ~100 LOC
├── 00-instructions-{topic}.md   # ~100 LOC
├── 01-critical-rules.md         # ~80 LOC
├── 02-05-{concepts}.md          # <150 LOC each
├── 06-10-{workflows}.md         # <150 LOC each
└── 99-quick-reference.md        # ~100 LOC
```

---

## Cross-Referencing Patterns

| Type | Syntax | Example |
|------|--------|---------|
| Internal (same folder) | `[Text](./file.md)` | `[Rules](./01-rules.md)` |
| External (other folder) | Full path | `.fong/instructions/mem0.md` |
| Script | Absolute path | `/home/.../tools/script.py` |
| Memory | Relative to .fong | `.fong/.memory/YYYY-MM-DD-*.md` |
| Code location | `file:line` | `process.ts:712` |
| Breadcrumb | `A → B → C` | `[Index](./00-*.md) → Current` |

---

## AI-Readability Rules

1. **Precise English** - "Execute command" not "Run the thing"
2. **Consistent Terminology** - One term = one concept, no synonyms
3. **Structured Formats** - Tables, lists, code blocks > paragraphs
4. **Action Verbs** - "Verify File Count" not "About Counting"
5. **Explicit Constraints** - Quantify all limits (<10MB, <150 LOC)
6. **Callouts** - ⚠️ CRITICAL, ✅ RECOMMENDED, ❌ FORBIDDEN
7. **Language Hints** - \`\`\`bash, \`\`\`python, \`\`\`yaml
8. **Comparison Tables** - Pros/cons/use-when tables
9. **No Ambiguity** - "100% OKR" not "as much as possible"
10. **Examples** - Every abstract concept needs concrete example

---

## Terminology Standards

### Action Verbs

- **Execute** - Run commands
- **Verify** - Check conditions
- **Validate** - Confirm correctness
- **Generate** - Create new output
- **Extract** - Pull data from source
- **Transform** - Modify format/structure
- **Archive** - Move to storage

### Status Indicators

- ✅ DONE - Completed
- ⚠️ CRITICAL - Requires attention
- ❌ FAILED - Error state
- 🔄 IN PROGRESS - Currently executing
- 📋 NOTE - Additional context

### Constraints

- **MANDATORY** - Must do, no exceptions
- **RECOMMENDED** - Best practice
- **OPTIONAL** - Nice to have
- **FORBIDDEN** - Never do

---

## Common Commands

### Check LOC Count

```bash
wc -l instructions-{topic}.md
# Output: 120 instructions-{topic}.md ✅
```

### Test Internal Links

```bash
for file in *.md; do
  grep -o '\[.*\](\.\/.*\.md)' "$file" | while read link; do
    path=$(echo "$link" | sed 's/.*(\.\///' | sed 's/).*//')
    if [ ! -f "$path" ]; then
      echo "Broken link in $file: $path"
    fi
  done
done
```

### Verify Scripts Exist

```bash
grep -r "Script.*:" *.md | grep -o '/.*\.py' | while read script; do
  if [ ! -f "$script" ]; then
    echo "Script not found: $script"
  fi
done
```

---

## Anti-Patterns Checklist

- [ ] No yapping (concise, structured)
- [ ] No ambiguous instructions (exact commands)
- [ ] All steps have verification + rollback
- [ ] No mixing concerns (single responsibility)
- [ ] No copy-paste (DRY + SSoT)
- [ ] No relative paths (absolute paths)
- [ ] No vague constraints (quantified)
- [ ] LOC budget tracked (<150 per file)

---

## File Naming Convention

```
XX-descriptive-multi-word-name.md

00- = Main index
01- = Critical rules
02-05- = Core concepts
06-10- = Detailed workflows
99- = Quick reference
```

---

## Version History Format

```markdown
## Version History

- **vX.Y.Z** (YYYY-MM-DD): {Change description}
  - {Sub-change 1}
  - {Sub-change 2}
- **vX.Y.0** (YYYY-MM-DD): {Initial version}
```

---

## Complete Minimal Example

```markdown
---
title: "Python Autodebug - Error Detection"
version: "1.0.0"
created: "2025-11-12"
updated: "2025-11-12"
author: "Fong"
purpose: "Automate Python error detection and fix suggestions"
scope: "Python scripts only (not notebooks)"
max_loc: 150
---

# Python Autodebug

**Purpose**: Automate Python script debugging.

**Prerequisites**: python3, ruff, mypy

---

## Step 1: Capture Error

\`\`\`bash
python script.py 2>&1 | tee /tmp/error.log
\`\`\`

**Verification**: `cat /tmp/error.log`

---

## Step 2: Lint with Ruff

\`\`\`bash
ruff check script.py
\`\`\`

---

## Related Files

- **Scripts**: `/home/fong/Projects/mini-rag/tools/autodebug.py`
- **Memory**: `.fong/.memory/2025-11-12-autodebug.md`

---

## Version History

- **v1.0.0** (2025-11-12): Initial version
```

---

## When in Doubt

1. **Is it >150 LOC?** → Refactor to folder-based
2. **Am I repeating content?** → Extract to separate file + cross-reference
3. **Is it ambiguous?** → Add exact commands + verification
4. **Missing examples?** → Add concrete examples
5. **Vague constraint?** → Quantify it

---

**Full Details**: [Main Index](./00-instructions-documentation-principles-for-ai.md)
