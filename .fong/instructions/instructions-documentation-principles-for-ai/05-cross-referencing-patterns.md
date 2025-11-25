# Cross-Referencing Patterns - Linking Documentation

**[⬅️ Back to Main Index](./00-instructions-documentation-principles-for-ai.md)**

---

## Overview

Six patterns for linking documentation files, scripts, memory, and code. Enables traceability and navigation.

**Principle**: Every concept should trace to its source.

---

## 1. Internal Links (Within Same Folder)

**Use**: Link between files in same `instructions-{topic}/` folder

**Pattern**: Relative links with `./` prefix

### Examples

```markdown
See [Critical Rules](./01-critical-rules.md) for safety requirements.

For naming conventions, refer to [Section 3](./03-naming-convention.md).

Detailed workflow: [Steps 1-3](./07-workflow-steps-1-3.md)

⬅️ [Back to Main Index](./00-instructions-{topic}.md)
```

### Best Practices

- Always use relative path `./XX-file.md`
- Include descriptive link text (not "click here")
- Add back-links at bottom of each file: `[⬅️ Back to Main Index](...)`

---

## 2. External Links (To Other Instruction Files)

**Use**: Link to instructions in different folders

**Pattern**: Absolute paths from `.fong/instructions/`

### Examples

```markdown
Prerequisites: See `.fong/instructions/instructions-mem0.md` for memory setup.

Related workflow: `.fong/instructions/instructions-autodebug-python.md`

Alternative approach: `/home/fong/Projects/mini-rag/.fong/instructions/instructions-perplexity.md`
```

### Best Practices

- Use absolute paths for clarity
- Mention context: "Prerequisites:", "Related:", "See also:"
- Verify path exists before committing

---

## 3. Script References

**Use**: Link to executable scripts, tools, or programs

**Pattern**: Absolute paths with command examples

### Examples

```markdown
**Script**: `/home/fong/Projects/mini-rag/tools/rename-pdfs-year-first.py`

**Run**:
\`\`\`bash
python /home/fong/Projects/mini-rag/tools/rename-pdfs-year-first.py \\
  --input /path/to/pdfs \\
  --output /path/to/renamed
\`\`\`

**Tool**: `/usr/bin/pdftotext`
\`\`\`bash
pdftotext -f 1 -l 5 input.pdf output.txt
\`\`\`
```

### Best Practices

- Always use absolute paths
- Include command-line examples
- Show expected flags/arguments
- Link to tool documentation if needed

---

## 4. Memory File References

**Use**: Link to historical context, decisions, completed tasks

**Pattern**: Absolute or relative paths to `.fong/.memory/`

### Examples

```markdown
**Memory**: `.fong/.memory/2025-11-12-pdf-workflow-v4-modular.md`

**Historical context**: `.fong/.memory/pdf-batch-processing/2025-11-10-*.md`

**Decision log**: See `.fong/.memory/2025-10-28-architecture-decision-modular.md`
```

### Best Practices

- Use ISO date format: `YYYY-MM-DD-{topic}.md`
- Group related memories in subdirectories
- Include brief context in link text

---

## 5. Code Location References (Traceability)

**Use**: Point to specific functions, classes, or lines in codebase

**Pattern**: `file_path:line_number` or `file_path:start-end`

### Examples

```markdown
Function definition: `src/services/process.ts:712`

Error handling: `pipeline.py:45-67`

Class implementation: `embedder.py:23-89` (OpenAIEmbeddings class)

Clients marked as failed in the \`connectToServer\` function in src/services/process.ts:712.
```

### Best Practices

- Use format `file:line` or `file:start-end`
- Include function/class name in parentheses
- Update if code refactored

---

## 6. Breadcrumb Navigation

**Use**: Show user's location in documentation hierarchy

**Pattern**: Path-like navigation links

### Examples

```markdown
**Path**: [Main Index](./00-*.md) > [Core Concepts](./02-*.md) > Current Section

**Navigation**: Home > Documentation > PDF Workflow > Step 3

**Breadcrumb**:
[00-Index](./00-*.md) → [01-Rules](./01-*.md) → [03-Naming](./03-*.md)
```

### Best Practices

- Place at top of file (after frontmatter)
- Use hierarchy levels: L0 → L1 → L2 → Current
- Make all levels clickable

---

## Complete Example (All Patterns Combined)

```markdown
# Step 1: Rename PDFs

**[⬅️ Back to Main Index](./00-instructions-pdf-batch-processing-workflow.md)**

**Path**: [00-Index](./00-*.md) → [Workflows](./05-*.md) → Step 1

---

## Overview

Rename PDFs to year-first format following [Naming Convention](./03-naming-convention.md).

**Prerequisites**:
- Python 3.8+ installed
- See `.fong/instructions/instructions-autodebug-python.md` for debug setup

---

## Execution

**Script**: `/home/fong/Projects/mini-rag/tools/rename-pdfs-year-first.py`

**Implementation**: Function `extract_year_from_pdf()` at `tools/rename-pdfs-year-first.py:45-89`

**Run**:
\`\`\`bash
python /home/fong/Projects/mini-rag/tools/rename-pdfs-year-first.py \\
  --input /path/to/pdfs \\
  --method filename,pages1-5,pages6-9
\`\`\`

---

## Related Files

- **[Naming Convention](./03-naming-convention.md)** - Format rules (internal link)
- **[Tools & Scripts](./04-tools-scripts.md)** - All available scripts (internal link)
- **Memory**: `.fong/.memory/2025-11-12-pdf-rename-100pct.md` (memory link)
- **Autodebug**: `.fong/instructions/instructions-autodebug-python.md` (external link)

---

**Next Step**: [Step 2: Convert EPUB/MOBI](./08-workflow-step-2.md) →
```

---

## Link Syntax Quick Reference

| Type | Syntax | Example |
|------|--------|---------|
| Internal (same folder) | `[Text](./file.md)` | `[Rules](./01-rules.md)` |
| External (other folder) | `[Text](/abs/path/file.md)` | `[Mem0](/home/.../mem0.md)` |
| Script | \`\`\`bash\npath/to/script\n\`\`\` | See example above |
| Memory | `.fong/.memory/YYYY-MM-DD-*.md` | See example above |
| Code location | \`file:line\` | \`process.ts:712\` |
| Breadcrumb | `A > B > C` or `A → B → C` | See example above |

---

## Testing Links

Before committing, test all links:

```bash
# Check internal links (same folder)
for file in *.md; do
  grep -o '\[.*\](\.\/.*\.md)' "$file" | while read link; do
    path=$(echo "$link" | sed 's/.*(\.\///' | sed 's/).*//')
    if [ ! -f "$path" ]; then
      echo "Broken link in $file: $path"
    fi
  done
done

# Verify external scripts exist
grep -r "Script.*:" *.md | grep -o '/.*\.py' | while read script; do
  if [ ! -f "$script" ]; then
    echo "Script not found: $script"
  fi
done
```

---

## Related Documents

- **[Core Principles](./01-core-principles.md)** - Principle #6: Traceability
- **[AI-Readability Guidelines](./06-ai-readability-guidelines.md)** - Link formatting
- **[Folder-Based Skeleton](./04-folder-based-skeleton.md)** - Where to place links
- **[Main Index](./00-instructions-documentation-principles-for-ai.md)** - Return to navigation
