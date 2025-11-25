# AI-Readability Guidelines - Writing for Machine Parsing

**[⬅️ Back to Main Index](./00-instructions-documentation-principles-for-ai.md)**

---

## Overview

10 rules for writing documentation that AI can parse, understand, and execute effectively.

**Target Audience**: AI agents (Claude, GPT, etc.), not humans

**Optimization Goal**: Machine parsing and semantic understanding

---

## 1. Use Precise English

**Rule**: Technical accuracy > colloquial clarity

### Examples

**Good**:
- "Execute command with absolute path"
- "Calculate SHA256 hash of file"
- "Extract metadata from PDF pages 3-30"

**Bad**:
- "Run the thing with full path"
- "Get the file's checksum"
- "Pull out info from the PDF"

---

## 2. Use Technical Terminology Consistently

**Rule**: One term = one concept. No synonyms.

### Term Dictionary

| Concept | Correct Term | Avoid |
|---------|--------------|-------|
| Hash function | SHA256 hash | checksum, fingerprint, digest |
| Search method | Semantic search | smart search, AI search |
| Vector storage | FAISS vector store | vector DB, embedding store |
| LLM output | Completion, generation | response, answer, result |

**Example**:
```markdown
# Good (consistent)
Calculate SHA256 hash, compare SHA256 hashes, store SHA256 hash in manifest.

# Bad (inconsistent)
Calculate checksum, compare hashes, store fingerprint in manifest.
```

---

## 3. Use Structured Formats

**Rule**: Tables, lists, and code blocks > prose paragraphs

### Tables for Parameters

```markdown
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| path | string | Yes | - | Absolute path to file |
| force | boolean | No | false | Skip confirmation prompts |
| top_k | number | No | 4 | Number of results to return |
```

### Lists for Steps

```markdown
1. Clone repository
2. Install dependencies
3. Configure environment variables
4. Run migrations
5. Start server
```

### Code Blocks for Commands

````markdown
```bash
python script.py --input /path/to/data --output /path/to/results
```

```python
def process_file(path: str) -> dict:
    return {"status": "success"}
```
````

---

## 4. Use Action Verbs in Headings

**Rule**: Imperative mood > descriptive mood

### Examples

**Good**:
- `## Verify File Count`
- `## Execute Rename Script`
- `## Extract Metadata from PDF`

**Bad**:
- `## About File Counting`
- `## Renaming Process`
- `## PDF Metadata`

---

## 5. Use Explicit Constraints

**Rule**: Quantify all limits, ranges, and expectations

### Examples

**Good**:
```markdown
**Constraints**:
- File size: <10MB (strict limit)
- Format: PDF only (no EPUB/MOBI)
- Naming: YYYY-Title-Author.PDF (exact format)
- LOC: <150 per file (strict), <100 (optimal)
- Timeout: 30 seconds (network requests)
```

**Bad**:
```markdown
- Files should be reasonably small
- Use PDF format
- Follow naming convention
- Keep files small
- Don't wait too long
```

---

## 6. Use Warning/Info Callouts

**Rule**: Visual markers for importance levels

### Callout Types

```markdown
⚠️ **CRITICAL**: {Safety-critical information, non-negotiable}

✅ **RECOMMENDED**: {Best practice, strongly suggested}

❌ **FORBIDDEN**: {Anti-pattern, never do this}

📋 **NOTE**: {Additional context, FYI}

🔄 **IN PROGRESS**: {Currently executing, status update}
```

---

## 7. Use Code Blocks with Language Hints

**Rule**: Always specify language for syntax highlighting and parsing

### Examples

````markdown
```bash
# Bash command
ls -la | grep '\.pdf$'
```

```python
# Python code
def extract_year(filename: str) -> int:
    return int(filename[:4])
```

```yaml
# YAML config
database:
  host: localhost
  port: 5432
```

```json
{
  "name": "example",
  "version": "1.0.0"
}
```
````

---

## 8. Use Tables for Comparisons

**Rule**: Decision matrices > prose comparisons

### Example: Pattern Comparison

```markdown
| Approach | Pros | Cons | Use When |
|----------|------|------|----------|
| Single-file | Simple, easy to read | LOC limited (<150) | Simple workflows |
| Folder-based | Modular, scalable | More complex structure | Complex workflows |
| Hybrid | Balance | Rare use case | Medium complexity |
```

---

## 9. Avoid Ambiguity

**Rule**: Quantify, specify, enumerate

### Examples

**Good**:
- "Rename 100% of files (OKR = 100%)"
- "Extract from pages 1-5, then pages 6-9, then pages 10-15"
- "Timeout after exactly 30 seconds"

**Bad**:
- "Rename files as much as possible"
- "Extract from early pages, then later pages"
- "Wait a reasonable amount of time"

---

## 10. Use Examples Liberally

**Rule**: Every abstract concept needs a concrete example

### Example Pattern

```markdown
## Concept: SHA256 Hash Comparison

**Definition**: Compare cryptographic hashes to detect duplicates

**Abstract**:
```
if hash(file_a) == hash(file_b):
    files_are_identical
```

**Concrete**:
```bash
# Calculate hashes
sha256sum file_a.pdf  # → abc123...
sha256sum file_b.pdf  # → abc123...

# Compare
if [ "abc123..." = "abc123..." ]; then
    echo "Duplicate detected"
fi
```

**Real-world**:
```bash
# In practice
sha256sum *.pdf | sort | uniq -w 64 -D
# Output: Lists duplicate PDFs by hash
```
```

---

## Complete Example (All Guidelines Applied)

```markdown
## Step 3: Calculate SHA256 Hashes

**[⬅️ Back to Main Index](./00-instructions-pdf-batch-workflow.md)**

---

### Overview

Calculate SHA256 hashes for duplicate detection. See [Duplicate Detection](./09-duplicate-detection.md) for comparison logic.

---

### Constraints

| Parameter | Value | Type | Notes |
|-----------|-------|------|-------|
| Algorithm | SHA256 | Fixed | Not MD5 or SHA1 |
| File size | <100MB | Soft limit | Larger files may timeout |
| Timeout | 60 seconds | Hard limit | Per file |
| Output format | `{hash} {filename}` | Fixed | Standard sha256sum format |

---

### Execution

**Command**:
```bash
sha256sum *.pdf > hashes.txt
```

**Expected Output**:
```
abc123def456...  2020-Title-Author.PDF
789ghi012jkl...  2021-Book-Writer.PDF
```

**Verification**:
```bash
wc -l hashes.txt
# Expected: Line count = PDF count
```

---

### Examples

#### Example 1: Single File

```bash
sha256sum 2020-Clean-Code-Martin.PDF
# Output: e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855  2020-Clean-Code-Martin.PDF
```

#### Example 2: Batch Processing

```bash
# Process all PDFs
sha256sum *.pdf | tee hashes.txt

# Verify
if [ $(wc -l < hashes.txt) -eq $(ls -1 *.pdf | wc -l) ]; then
    echo "✅ All files hashed"
else
    echo "⚠️ Hash count mismatch"
fi
```

---

### Troubleshooting

| Issue | Symptom | Solution |
|-------|---------|----------|
| Timeout | Hangs on large file | Skip files >100MB: `find . -size -100M -name '*.pdf' -exec sha256sum {} \;` |
| Permission denied | `sha256sum: *.pdf: Permission denied` | `chmod 644 *.pdf` |
| Command not found | `sha256sum: command not found` | Install coreutils: `apt install coreutils` |

---

⚠️ **CRITICAL**: Do NOT use MD5 or SHA1 (collision-prone). Use SHA256 only.

✅ **RECOMMENDED**: Save hashes to `hashes.txt` for reuse in duplicate detection.

---

**Next Step**: [Step 4: Detect Duplicates](./09-duplicate-detection.md) →
```

---

## Related Documents

- **[Terminology Standards](./07-terminology-standards.md)** - Consistent term usage
- **[Single-File Skeleton](./03-single-file-skeleton.md)** - Where to apply these rules
- **[Anti-Patterns](./08-anti-patterns.md)** - What to avoid
- **[Main Index](./00-instructions-documentation-principles-for-ai.md)** - Return to navigation
