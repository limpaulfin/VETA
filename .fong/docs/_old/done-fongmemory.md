# Memory CRUD & Alignment Command

This command provides comprehensive memory management for `.memory/` directory including Create, Read, Update, Delete operations and alignment between actual codebase and memory documentation.

## Core Operations

### CREATE - Memory Documentation
- "em ghi vào memory..."
- "document in memory"
- "save to memory"
- "create memory entry"

### READ - Memory Search & Retrieval
- "em tìm trong memory..."
- "search memory for..."
- "lookup in memory"
- "kiểm tra memory có gì về..."

### UPDATE - Memory Alignment & Synchronization
- "align memory với codebase"
- "sync memory"
- "calibrate memory"
- "update memory"

### DELETE - Memory Cleanup
- "remove outdated memory"
- "clean obsolete entries"
- "delete orphaned memory"

## Memory Alignment Protocol

### Alignment Triggers
- Periodic alignment cycles after codebase modifications
- Post-refactoring operations that alter structure or logic
- User requests with keywords: "align memory", "sync memory", "calibrate memory"
- When users provide code files and request analysis

### Core Alignment Principles
1. **SSoT (Single Source of Truth)**: Memory must accurately reflect current codebase
2. **DRY (Don't Repeat Yourself)**: Eliminate redundant information storage
3. **KISS (Keep It Simple)**: Store only essential, comprehensible information (80/20 principle)

## Systematic Alignment Workflow

### Phase 1: Discovery & Assessment
1. **Identify Target Files**: Find oldest memory files requiring alignment
   ```bash
   find .memory/ -type f \( -name "*.json" -o -name "*.md" \) -printf '%T@ %p\n' | sort -n | head -10
   ```

2. **Priority Assessment**: Categorize files by importance
   - **Critical**: Security modules, core data processing, database schemas
   - **High**: Core modules, API endpoints, essential configurations
   - **Medium**: Frequently used modules and functions
   - **Low**: Support modules, rarely used components

### Phase 2: Systematic Verification
1. **Content Analysis**: Read current memory file content and create backup
2. **Codebase Verification**: Compare memory documentation with actual code
3. **Alignment Assessment**: Determine status (ALIGNED/OUTDATED/MISSING/ORPHANED)
4. **Corrective Actions**: Update, create, or remove memory files as needed

### Phase 3: Documentation & Logging
1. **Session Documentation**: Log all activities in `.memory/alignment-calibration-log.json`
2. **Metadata Updates**: Add alignment metadata to processed files
3. **Status Report**: Generate comprehensive session summary

## Memory CRUD Operations

### CREATE Operations
- **Memory Tier Selection**: Determine short-term vs long-term storage
- **Metadata Schema**: Include timestamps, importance, tags, relationships
- **Content Requirements**: Focus on logic, design decisions, metadata
- **File Naming**: Use descriptive names with feature/component prefixes

### READ Operations  
- **Search Pattern**:
  ```bash
  rg -i --type json --type md "keyword1|keyword2" .memory/
  ```
- **Cross-Reference Search**: Use keywords from one file to find related ones
- **Context-Driven Search**: Use task context to identify relevant memory areas

### UPDATE Operations
- **Alignment Verification**: Compare memory with current codebase
- **Content Synchronization**: Update outdated information
- **Metadata Refresh**: Update timestamps and verification status
- **English Conversion**: Convert Vietnamese content to English terminology

### DELETE Operations
- **Orphaned Memory**: Remove files referencing non-existent code
- **Obsolete Content**: Clean up deprecated or consolidated information
- **Backup Before Delete**: Always create backup copies

### PHP/JS File Analysis Integration

When storing or aligning PHP/JS files in memory, the command automatically uses specialized readers for accurate metadata extraction:

**For PHP Files:**
```bash
# Uses Fong PHP Reader for comprehensive analysis
.fong/tools/fong-php-reader.sh path/to/file.php
```

**For JavaScript Files:**
```bash
# Uses Fong JS Reader for comprehensive analysis
.fong/tools/fong-js-reader.sh path/to/file.js
```

**Metadata Extracted:**
- **Function definitions and relationships**
- **Dependencies and includes/imports**
- **WordPress hooks (PHP) or event listeners (JS)**
- **Class definitions and namespaces**
- **Cross-file relationships and usage patterns**
- **Custom vs built-in function classification**

**Storage Benefits:**
- More accurate file relationships documentation
- Better dependency tracking in memory
- Precise function usage patterns
- Improved cross-reference capabilities
- Enhanced debugging information for future sessions

## Examples

### Search Example
```
/fmemory em tìm trong memory coi có gì liên quan tới user authentication không?
```
Result: Searches memory for authentication-related information using English keywords

### Alignment Example
```
/fmemory em align conversation hiện tại với DKM của dự án
```
Result: Synchronizes current conversation context with project memory

### Storage Example
```
/fmemory em ghi vào DKM về cách fix lỗi database connection timeout
```
Result: Creates new memory entry documenting the database timeout solution

### PHP File Storage Example
```
/fmemory em ghi helper function mới này vào memory: /path/to/helper.php
```
Result: Uses Fong PHP Reader to extract metadata and relationships, then stores comprehensive information

### JS File Storage Example
```
/fmemory em ghi file JS này với dependencies vào DKM: /path/to/script.js
```
Result: Uses Fong JS Reader to analyze functions, dependencies, and relationships before storage

## Memory Location
All operations target: `.memory/`

## Critical Rules

### ❌ NEVER DO THESE:
- **DO NOT use `find` commands** - ALWAYS use `rg` (ripgrep) for all search operations
- **DO NOT add entries to manifest.json** - Memory files exist independently of manifest tracking
- **DO NOT modify manifest structure** - Only create/edit individual memory files

### ✅ ALLOWED OPERATIONS:
- Use `rg` exclusively for all file and content searching operations
- **Use `tree` command instead of `ls`** to view directory structure before operations
- **MANDATORY**: Check directory contents with `tree` before creating or modifying any files
- Create new memory files in appropriate directories (short-term/, long-term/, etc.)
- Edit existing memory files for updates/corrections
- Delete outdated or consolidated memory files using `rg` to find targets first
- Search and retrieve information from memory files using `rg` patterns

## Directory Exploration Protocol

### Before Any Memory Operations
**ALWAYS use `tree` command instead of `ls`** to examine directory structure:

```bash
# View .memory/ directory structure
tree .memory/ -L 2

# View with file permissions  
tree .memory/ -p

# View with file sizes
tree .memory/ -s

# Exclude backup files
tree .memory/ -I "*.bak|*.backup"
```

### Directory Structure Assessment
1. **Pre-CREATE**: Use `tree` to understand existing organization before adding new files
2. **Pre-READ**: Use `tree` to locate target directories efficiently
3. **Pre-UPDATE**: Use `tree` to identify files that need alignment
4. **Pre-DELETE**: Use `tree` to visualize impact of removals

## Integration
Seamlessly integrates with project's existing memory management rules and maintains Single Source of Truth (SSoT) principle. Memory files are self-contained and do not require manifest registration.