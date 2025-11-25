# Terminology Standards - Consistent Language Usage

**[⬅️ Back to Main Index](./00-instructions-documentation-principles-for-ai.md)**

---

## Overview

Standard terminology for technical documentation. Ensures consistent usage across all instruction files.

**Principle**: One term = one concept. No synonyms. No ambiguity.

---

## File Path References

### Standards

- **Always use absolute paths** for script references
  - Example: `/home/fong/Projects/mini-rag/tools/rename-pdfs.py`

- **Never use relative paths** in instructions (ambiguous)
  - Bad: `../tools/script.py`

- **Exception**: Cross-references within same folder
  - Example: `./01-rules.md` (clear context)

### Examples

```markdown
# Good
**Script**: `/home/fong/Projects/mini-rag/tools/rename-pdfs-year-first.py`
**Memory**: `.fong/.memory/2025-11-12-pdf-workflow.md`

# Bad
**Script**: `../tools/rename-pdfs.py` (which parent directory?)
**Memory**: `../../.memory/pdf-workflow.md` (confusing)
```

---

## Version Notation

### Semantic Versioning

**Format**: `X.Y.Z` (major.minor.patch)

- **Major (X)**: Breaking changes, incompatible API
  - Example: v3.0.0 → v4.0.0 (modular refactor)

- **Minor (Y)**: New features, backward compatible
  - Example: v3.2.0 → v3.3.0 (add filterDKM workflow)

- **Patch (Z)**: Bug fixes, typo corrections
  - Example: v3.3.0 → v3.3.1 (fix typo in Step 8)

### Date Format

**Format**: `YYYY-MM-DD` (ISO 8601)

- **Good**: `2025-11-12`
- **Bad**: `11/12/2025`, `12-11-2025`, `Nov 12, 2025`

### Examples

```markdown
---
version: "4.0.0"
created: "2025-10-28"
updated: "2025-11-12"
---

## Version History

- **v4.0.0** (2025-11-12): Modular architecture refactor
- **v3.3.0** (2025-11-10): Added filterDKM workflow
- **v3.2.0** (2025-10-29): Updated destinations
```

---

## Action Verbs (Consistent Usage)

### Command Execution

| Verb | Meaning | Example |
|------|---------|---------|
| **Execute** | Run a command or script | "Execute rename script" |
| **Run** | Start a program or process | "Run Python script" |
| **Call** | Invoke a function or API | "Call OpenAI API" |

### Verification

| Verb | Meaning | Example |
|------|---------|---------|
| **Verify** | Check if condition is true | "Verify file count matches" |
| **Validate** | Confirm correctness/format | "Validate naming convention" |
| **Confirm** | Double-check result | "Confirm no duplicates" |

### Data Operations

| Verb | Meaning | Example |
|------|---------|---------|
| **Generate** | Create new output from scratch | "Generate index.json" |
| **Extract** | Pull data from source | "Extract year from filename" |
| **Transform** | Modify format/structure | "Transform EPUB to PDF" |
| **Archive** | Move to long-term storage | "Archive original files" |

### Examples

```markdown
# Good (consistent)
## Step 1: Execute Rename Script
Run the script to transform filenames.

## Step 2: Verify File Count
Validate that all files were renamed.

# Bad (inconsistent)
## Step 1: Run/Execute/Start the Script
Do the thing to change names.

## Step 2: Check/Verify/Validate Count
Make sure files match.
```

---

## Constraint Indicators

### Priority Levels

| Indicator | Meaning | Usage |
|-----------|---------|-------|
| **MANDATORY** | Must do, no exceptions | Critical safety rules |
| **RECOMMENDED** | Best practice, strongly suggested | Code style, patterns |
| **OPTIONAL** | Nice to have | Performance optimizations |
| **FORBIDDEN** | Never do | Anti-patterns, security risks |

### Examples

```markdown
⚠️ **MANDATORY**: Verify file count before and after each operation

✅ **RECOMMENDED**: Use year-first naming convention (YYYY-Title-Author.PDF)

📋 **OPTIONAL**: Add publisher name for disambiguation

❌ **FORBIDDEN**: Never use MD5 hashes (collision-prone)
```

---

## Status Indicators

### Emoji Markers

| Emoji | Status | Context |
|-------|--------|---------|
| ✅ | DONE / SUCCESS | Completed task |
| ⚠️ | CRITICAL / WARNING | Requires attention |
| ❌ | FAILED / ERROR | Error state |
| 🔄 | IN PROGRESS | Currently executing |
| 📋 | NOTE / INFO | Additional context |
| 🚀 | READY / START | Ready to execute |

### Examples

```markdown
✅ **DONE**: 31/31 files renamed (100% OKR)

⚠️ **CRITICAL**: File count mismatch detected (expected 31, got 29)

❌ **FAILED**: pdftotext extraction failed for scanned-2020-Book.PDF

🔄 **IN PROGRESS**: Processing file 18/31 (58% complete)

📋 **NOTE**: This step may take 5-10 minutes for large datasets

🚀 **READY**: All prerequisites verified, starting Step 1
```

---

## Technical Terms Dictionary

### File Processing

| Term | Definition | Example |
|------|------------|---------|
| **SHA256 hash** | Cryptographic hash function | `e3b0c442...` |
| **Vector embedding** | Numerical representation of text | `[0.123, -0.456, ...]` |
| **Semantic search** | Meaning-based search | Query: "cat" → matches "feline" |
| **FAISS vector store** | Facebook AI Similarity Search | `faiss.IndexFlatL2(dim)` |

### Workflow Terms

| Term | Definition | Example |
|------|------------|---------|
| **Year-first naming** | YYYY-Title-Author.PDF format | `2020-Clean-Code-Martin.PDF` |
| **Text-scanned PDF** | Scanned with OCR layer | Readable but low quality |
| **Image-only PDF** | Scanned without OCR | Not searchable |
| **OKR** | Objective and Key Results | 100% OKR = all files renamed |

### Architecture Terms

| Term | Definition | Example |
|------|------------|---------|
| **Modular architecture** | Decomposed into focused files | 14 files <150 LOC each |
| **Monolithic file** | Single large file | 2069 LOC file |
| **SSoT** | Single Source of Truth | One place for naming rules |
| **DRY** | Don't Repeat Yourself | Extract to separate file |

---

## Avoid Synonyms

### Bad (Ambiguous)

```markdown
# Multiple terms for same concept
Calculate checksum of file
Compare hashes to detect duplicates
Store fingerprint in manifest
Verify file digest matches
```

### Good (Consistent)

```markdown
# One term = one concept
Calculate SHA256 hash of file
Compare SHA256 hashes to detect duplicates
Store SHA256 hash in manifest
Verify SHA256 hash matches
```

---

## Capitalization Rules

### File Extensions

- **Uppercase** when referring to format: `PDF`, `EPUB`, `MOBI`
- **Lowercase** in filenames: `.pdf`, `.epub`, `.mobi`

```markdown
# Good
Convert EPUB files to PDF format.
Rename all `.pdf` files.

# Bad
Convert epub files to pdf format.
Rename all `.PDF` files.
```

### Acronyms

- **Always uppercase**: `API`, `CLI`, `JSON`, `YAML`, `SQL`, `HTTP`
- **Exception**: Standard commands: `npm`, `git`, `curl`

```markdown
# Good
Query the API with JSON payload.
Use git CLI to commit changes.

# Bad
Query the api with json payload.
Use GIT cli to commit changes.
```

---

## Related Documents

- **[AI-Readability Guidelines](./06-ai-readability-guidelines.md)** - How to apply terminology
- **[Core Principles](./01-core-principles.md)** - Why consistent terminology matters
- **[Anti-Patterns](./08-anti-patterns.md)** - Common terminology mistakes
- **[Main Index](./00-instructions-documentation-principles-for-ai.md)** - Return to navigation
