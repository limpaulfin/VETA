# Single-File Skeleton - Template for Simple Instructions

**[⬅️ Back to Main Index](./00-instructions-documentation-principles-for-ai.md)**

---

## Overview

Complete template for single-file instructions (<150 LOC). Copy-paste and customize.

**Use When**: Simple, linear workflow with <150 LOC total

---

## Template Structure

### 1. Mandatory Frontmatter

```yaml
---
title: "Instruction Title - Concise Descriptor"
version: "X.Y.Z"
created: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
author: "Author Name"
purpose: "One-sentence purpose statement"
scope: "What this covers and what it doesn't"
dependencies: ["tool1", "tool2"]  # Optional
max_loc: 150  # Self-documenting constraint
---
```

**Required Fields**:
- `title`: Clear, descriptive title
- `version`: Semantic versioning (X.Y.Z)
- `created`: ISO date (YYYY-MM-DD)
- `updated`: ISO date (YYYY-MM-DD)
- `author`: Author name
- `purpose`: One-sentence purpose
- `scope`: Included/excluded scope
- `max_loc`: LOC limit (150 for single-file)

**Optional Fields**:
- `dependencies`: List of required tools/files

---

### 2. Core Sections (Mandatory)

```markdown
# {Title}

**Purpose**: {One sentence describing what this achieves}

**Scope**: {What's included and what's excluded}

**Prerequisites**: {Tools, knowledge, files required}

---

## ⚠️ CRITICAL RULES (if applicable)

1. {Safety-critical rule 1}
2. {Non-negotiable constraint 2}
3. {Common failure mode 3}

---

## Core Workflow

### Step 1: {Action Verb + Object}

**Goal**: {What this step achieves}

**Command**:
```bash
tool --flag argument
```

**Verification**: {How to confirm success}
```bash
verification-command
# Expected output: {what you should see}
```

**Rollback**: {How to undo if needed}
```bash
rollback-command
```

### Step 2: {Action Verb + Object}

{Repeat structure for each step}

---

## Examples

### Example 1: {Common Use Case}

```bash
# Setup
cd /path/to/project

# Execute
command --option value

# Expected output
output text
```

### Example 2: {Edge Case}

```bash
# Handle special scenario
command --special-flag
```

---

## Troubleshooting

| Issue | Symptom | Solution |
|-------|---------|----------|
| {Problem 1} | {Observable behavior} | {Fix with command} |
| {Problem 2} | {Observable behavior} | {Fix with command} |

---

## Related Files

- **Scripts**: `/absolute/path/to/script.py`
- **Memory**: `.fong/.memory/YYYY-MM-DD-{topic}.md`
- **Dependencies**: `instructions-{related-topic}.md`

---

## Version History

- **vX.Y.Z** (YYYY-MM-DD): {Change description}
- **vX.Y.0** (YYYY-MM-DD): {Initial version}
```

---

### 3. Optional Sections (Add if needed, keep <150 LOC total)

```markdown
## Configuration

**Environment Variables**:
```bash
export VAR_NAME=value
```

**Config File**: `/path/to/config.yml`
```yaml
key: value
```

---

## Edge Cases

### Case 1: {Rare Scenario}
{Description and handling}

### Case 2: {Special Condition}
{Description and handling}

---

## Performance Notes

- {Optimization tip 1}
- {Scaling consideration 2}
- {Resource usage note 3}
```

---

## Complete Example

```markdown
---
title: "Python Script Autodebug - Automated Error Detection and Fix"
version: "1.2.0"
created: "2025-10-15"
updated: "2025-11-12"
author: "Fong"
purpose: "Automate Python script debugging with error detection and fix suggestions"
scope: "Python scripts only (not notebooks)"
dependencies: ["python3", "ruff", "mypy"]
max_loc: 150
---

# Python Script Autodebug

**Purpose**: Automate Python script debugging with error detection, linting, type checking, and fix suggestions.

**Scope**: Covers Python scripts (`.py` files). For notebooks, see `instructions-autodebug-notebook.md`.

**Prerequisites**:
- Python 3.8+
- `ruff` linter installed (`pip install ruff`)
- `mypy` type checker installed (`pip install mypy`)

---

## ⚠️ CRITICAL RULES

1. **ALWAYS run in sandbox branch** (git checkout -b sandbox-YYYYMMDD-HHMMSS)
2. **NEVER auto-commit to main** without user approval
3. **ALWAYS verify fix** before applying (dry-run first)

---

## Core Workflow

### Step 1: Run Script and Capture Error

**Goal**: Execute script and capture full error traceback

**Command**:
```bash
python script.py 2>&1 | tee /tmp/error.log
```

**Verification**:
```bash
cat /tmp/error.log
# Expected: Full traceback with line numbers
```

**Rollback**: N/A (read-only operation)

### Step 2: Analyze Error with Ruff

**Goal**: Lint code and identify issues

**Command**:
```bash
ruff check script.py --output-format=json > /tmp/ruff.json
```

**Verification**:
```bash
cat /tmp/ruff.json | jq '.[] | {line, code, message}'
# Expected: JSON array of linting issues
```

### Step 3: Type Check with Mypy

**Goal**: Identify type errors

**Command**:
```bash
mypy script.py --show-error-codes > /tmp/mypy.log
```

**Verification**:
```bash
cat /tmp/mypy.log
# Expected: List of type errors with line numbers
```

### Step 4: Generate Fix Suggestions

**Goal**: AI analyzes errors and suggests fixes

{AI reads error.log, ruff.json, mypy.log and generates fixes}

### Step 5: Apply Fix (Dry-run First)

**Goal**: Preview changes before applying

**Command**:
```bash
diff -u script.py script.py.fixed
```

**Verification**: Review diff output

**Apply**:
```bash
cp script.py script.py.backup
mv script.py.fixed script.py
```

**Rollback**:
```bash
mv script.py.backup script.py
```

---

## Examples

### Example 1: NameError

```bash
# Error
python script.py
# NameError: name 'foo' is not defined

# Auto-fix detected: typo 'foo' → 'food'
ruff check script.py
# → F821: Undefined name 'foo'

# Apply fix
# Change line 42: foo → food
```

---

## Troubleshooting

| Issue | Symptom | Solution |
|-------|---------|----------|
| Ruff not found | `command not found: ruff` | `pip install ruff` |
| Mypy not found | `command not found: mypy` | `pip install mypy` |
| Permission denied | `/tmp/error.log: Permission denied` | `chmod 777 /tmp` |

---

## Related Files

- **Scripts**: `/home/fong/Projects/mini-rag/tools/autodebug.py`
- **Memory**: `.fong/.memory/2025-11-12-autodebug-python.md`
- **Dependencies**: `instructions-read-long-file.md` (for large tracebacks)

---

## Version History

- **v1.2.0** (2025-11-12): Added mypy type checking
- **v1.1.0** (2025-10-20): Added ruff linting
- **v1.0.0** (2025-10-15): Initial version with basic error capture
```

---

## Checklist Before Committing

- [ ] Frontmatter complete (all required fields)
- [ ] LOC count <150 (`wc -l instructions-{topic}.md`)
- [ ] All steps have Goal, Command, Verification, Rollback
- [ ] At least 1 example included
- [ ] Troubleshooting table present
- [ ] Related files linked (scripts, memory, dependencies)
- [ ] Version history updated
- [ ] All commands tested

---

## Related Documents

- **[Architecture Patterns](./02-architecture-patterns.md)** - When to use single-file vs folder
- **[Folder-Based Skeleton](./04-folder-based-skeleton.md)** - Template for complex docs
- **[AI-Readability Guidelines](./06-ai-readability-guidelines.md)** - How to write AI-friendly content
- **[Main Index](./00-instructions-documentation-principles-for-ai.md)** - Return to navigation
