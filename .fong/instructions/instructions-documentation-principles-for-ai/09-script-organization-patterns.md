# Script Organization Patterns for Instructions

**[⬅️ Back to Main Index](./00-instructions-documentation-principles-for-ai.md)**

**Version**: 1.0.0
**Date**: 2025-11-12
**Purpose**: Standard patterns for organizing scripts within instruction documentation

---

## 🎯 Core Principle

**Rule**: Scripts (.sh, .py, etc.) should live in dedicated `scripts/` subfolder with own venv, NOT scattered in documentation root.

**Why**:
- **Separation of concerns**: Documentation vs. executable code
- **Self-contained**: Each scripts folder has own venv + dependencies
- **Reusability**: Scripts can be called from multiple docs
- **Maintainability**: Clear structure for updates

---

## 📁 Standard Structure

### Pattern 1: Scripts Within Instruction Folder

```
instructions-{topic}/
├── 00-instructions-{topic}.md          # Main index
├── 01-core-concept.md                  # Documentation files
├── 02-workflow.md
├── 0N-algorithm-spec.md                # Algorithm documentation with pseudocode
├── scripts/                             # ⭐ Scripts subfolder
│   ├── venv/                           # Python virtual environment
│   ├── requirements.txt                # Python dependencies
│   ├── README.md                       # Script-specific README
│   ├── {script_name}.py                # Main script
│   ├── {script_name}.sh                # Shell script (if needed)
│   └── lib/                            # Supporting modules (if needed)
│       └── utils.py
└── 99-quick-reference.md
```

### Pattern 2: Shared Scripts (Project-Level)

```
project-root/
├── .fong/
│   ├── instructions/
│   │   ├── instructions-topic-1/
│   │   │   ├── 00-main.md
│   │   │   └── (references ../../../scripts/shared/)
│   │   └── instructions-topic-2/
│   │       ├── 00-main.md
│   │       └── (references ../../../scripts/shared/)
│   └── scripts/                        # Shared scripts
│       ├── shared/
│       │   ├── venv/
│       │   ├── requirements.txt
│       │   ├── README.md
│       │   └── utility.py
│       └── README.md
```

---

## 📋 Requirements for scripts/ Folder

### MUST Have

1. ✅ **venv/** - Python virtual environment
   - Create: `python3 -m venv venv`
   - Never commit venv to git (add to .gitignore)

2. ✅ **requirements.txt** - Dependency list
   - Even if empty (stdlib only), create file
   - Comment: `# No external dependencies - stdlib only`

3. ✅ **README.md** - Usage instructions
   - Quick Start section
   - Usage examples
   - Parameter documentation
   - Troubleshooting section

4. ✅ **Executable permission** - Scripts must be executable
   - `chmod +x script.py`

### SHOULD Have

1. ✅ **Shebang line** - For direct execution
   ```python
   #!/usr/bin/env python3
   ```

2. ✅ **Docstrings** - Module, class, function docs
   ```python
   """
   Brief description

   Author: Name
   Date: YYYY-MM-DD
   Version: X.Y.Z
   """
   ```

3. ✅ **Type hints** - For Python 3.5+
   ```python
   def func(param: str) -> List[Dict]:
   ```

---

## 📝 Documentation Requirements

### In scripts/README.md

**Required sections**:

1. **Purpose** - What problem does this solve?
2. **Quick Start** - Setup + basic usage
3. **Usage Examples** - Concrete commands
4. **Parameters** - All arguments documented
5. **Algorithm** - Link to algorithm spec .md file
6. **Troubleshooting** - Common issues

**Template**:
```markdown
# {Script Name}

Version: X.Y.Z
Purpose: {one-line description}

## Quick Start

\`\`\`bash
# Setup (first time)
cd /path/to/scripts
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Run
python script.py --arg value
\`\`\`

## Usage Examples

\`\`\`bash
# Example 1: Basic usage
python script.py /path/to/input

# Example 2: With options
python script.py /path/to/input --threshold 0.8
\`\`\`

## Parameters

- `input_path` (required): Description
- `--threshold` (optional, default 0.7): Description

## Algorithm

See: `../0N-algorithm-spec.md` for detailed algorithm documentation

## Troubleshooting

**Issue**: Error message
**Fix**: Solution
```

### In Parent Documentation (0N-algorithm-spec.md)

**Required sections for algorithm docs**:

1. **Overview** - Problem + solution summary
2. **Algorithm Choice** - Why this algorithm?
3. **Algorithm Details** - Step-by-step logic
4. **Data Flow Diagram** - Mermaid flowchart
5. **Process Flow** - BPMN-style workflow
6. **Pseudocode** - Readable pseudo-code
7. **Performance** - Complexity analysis
8. **Configuration** - Parameters explained
9. **References** - Links to scripts/README.md

**Required diagrams**:

- ✅ **Data Flow Diagram (DFD)**: Mermaid flowchart
  ```mermaid
  flowchart TD
      A[Input] --> B[Process]
      B --> C[Output]
  ```

- ✅ **Process Flow (BPMN-style)**: Sequential steps
  ```mermaid
  flowchart LR
      Start([Start]) --> Step1[Step 1]
      Step1 --> Decision{Check?}
      Decision -->|Yes| Step2[Step 2]
      Decision -->|No| End([End])
  ```

- ✅ **Logic Diagram** (optional): Complex branching
- ✅ **ERD** (optional): If data modeling involved

---

## 🔗 Cross-Reference Pattern

### From Documentation to Script

```markdown
## Step N: Run Duplicate Detection

**Script**: `scripts/detect_duplicates.py`
**Algorithm**: See [Algorithm Spec](./12-duplicate-detection-algorithm.md)

\`\`\`bash
cd scripts
source venv/bin/activate
python detect_duplicates.py /path/to/pdfs
\`\`\`

For detailed usage: See [scripts/README.md](./scripts/README.md)
```

### From Script README to Documentation

```markdown
## Algorithm

This script implements the Jaccard + Token Set Ratio algorithm.

**Detailed specification**: `../12-duplicate-detection-algorithm.md`
**Workflow usage**: `../10a-workflow-step-7a-smart-search.md`
**Parent documentation**: `../00-instructions-pdf-batch-processing-workflow.md`
```

---

## 🎨 Example: PDF Duplicate Detection

### Directory Structure

```
instructions-pdf-batch-processing-workflow/
├── 00-instructions-pdf-batch-processing-workflow.md
├── 10a-workflow-step-7a-smart-search.md
├── 12-duplicate-detection-algorithm.md     # ⭐ Algorithm spec
├── scripts/                                 # ⭐ Scripts folder
│   ├── venv/                               # Python venv
│   ├── requirements.txt                    # Dependencies
│   ├── README.md                           # Usage guide
│   └── detect_duplicates.py                # Implementation
└── 99-quick-reference.md
```

### Cross-References

**In 12-duplicate-detection-algorithm.md**:
```markdown
**Implementation**: `/scripts/detect_duplicates.py`

## Algorithm Details
[Pseudocode here]

## Data Flow Diagram
[Mermaid diagram here]
```

**In scripts/README.md**:
```markdown
## Algorithm

See: `../12-duplicate-detection-algorithm.md` for:
- Detailed pseudocode
- Data flow diagrams
- Complexity analysis
```

**In 10a-workflow-step-7a-smart-search.md**:
```markdown
## Step 7a: Detect Duplicates

**New Method** (recommended): Use Python script with Jaccard algorithm

\`\`\`bash
cd scripts
source venv/bin/activate
python detect_duplicates.py /path/to/pdfs 0.7
\`\`\`

Details: [scripts/README.md](./scripts/README.md)
Algorithm: [12-duplicate-detection-algorithm.md](./12-duplicate-detection-algorithm.md)
```

---

## ⚠️ Anti-Patterns to Avoid

### ❌ Don't: Scatter Scripts in Root

```
instructions-topic/
├── 00-main.md
├── script1.py          # ❌ Bad: Mixed with docs
├── script2.sh          # ❌ Bad: No organization
└── helper.py           # ❌ Bad: Where's the venv?
```

### ❌ Don't: Inline Large Scripts in Markdown

```markdown
## Solution

\`\`\`python
# ❌ Bad: 200 lines of code inline
def complex_function():
    # ... 200 lines ...
\`\`\`
```

**Fix**: Move to `scripts/` folder, link from markdown

### ❌ Don't: Missing Documentation

```
scripts/
├── venv/
├── script.py           # ❌ Bad: No README
└── requirements.txt    # ❌ Bad: No algorithm spec
```

### ❌ Don't: No Pseudocode/Diagrams

```markdown
## Algorithm

The algorithm works by comparing files.  # ❌ Bad: Vague

\`\`\`python
# ❌ Bad: Jump straight to code without explanation
def detect_duplicates(files):
    ...
\`\`\`
```

**Fix**: Add pseudocode, DFD, BPMN diagrams BEFORE code

---

## ✅ Checklist for Script Organization

When adding scripts to instruction documentation:

- [ ] Created `scripts/` subfolder
- [ ] Created `venv/` in scripts folder
- [ ] Created `requirements.txt` (even if empty)
- [ ] Created `scripts/README.md` with all required sections
- [ ] Made scripts executable (`chmod +x`)
- [ ] Added shebang line (`#!/usr/bin/env python3`)
- [ ] Added docstrings (module, class, function)
- [ ] Created algorithm spec .md file in parent folder
- [ ] Added pseudocode to algorithm spec
- [ ] Added DFD (Mermaid flowchart) to algorithm spec
- [ ] Added process flow (BPMN-style) to algorithm spec
- [ ] Cross-referenced script ↔ algorithm spec ↔ workflow
- [ ] Documented all parameters
- [ ] Added usage examples
- [ ] Added troubleshooting section
- [ ] Updated parent documentation to reference script

---

## 📚 Related Documents

- **[Core Principles](./01-core-principles.md)** - SSoT, DRY, Modularity
- **[Folder-Based Skeleton](./04-folder-based-skeleton.md)** - Directory structure
- **[Cross-Referencing Patterns](./05-cross-referencing-patterns.md)** - Linking patterns
- **[Main Index](./00-instructions-documentation-principles-for-ai.md)** - Return to overview

---

## 📖 Real-World Example

**See**: `/home/fong/Projects/mini-rag/.fong/instructions/customs/instructions-pdf-batch-processing-workflow/`

This folder demonstrates complete script organization:
- `12-duplicate-detection-algorithm.md` - Algorithm spec with pseudocode + diagrams
- `scripts/README.md` - Usage guide
- `scripts/detect_duplicates.py` - Implementation
- Full cross-references between all files
