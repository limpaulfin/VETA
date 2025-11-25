<!--
INSTRUCTION FILE NOTICE:
This is an instruction/guidance file. Modification is not recommended.
Only modify this file when explicitly requested by the prompter.
-->

---
description: "Túc Mạng Minh - TypeScript Tool for File History Search (Local + Git)"
argument-hint: "[file_path] [options]"
version: "2025-10-10T15:45:00Z"
tool-location: "/home/fong/Projects/MCPs/ts-tuc-mang-minh/"
mcp-wrapper: "/home/fong/Projects/MCPs/ts-tuc-mang-minh-mcp/"
---

# Túc Mạng Minh - File History Search Tool (TypeScript)

## 📍 Tool Location (HARDCODED PATH - Universal)

### CLI Tool (Direct Use)
```bash
/home/fong/Projects/MCPs/ts-tuc-mang-minh/
```

### MCP Wrapper (For AI Assistants)
```bash
/home/fong/Projects/MCPs/ts-tuc-mang-minh-mcp/
```

⚠️ **CRITICAL**:
- CLI tool location: `/home/fong/Projects/MCPs/ts-tuc-mang-minh/` (direct bash commands)
- MCP wrapper location: `/home/fong/Projects/MCPs/ts-tuc-mang-minh-mcp/` (for AI integration)

## 🎯 What It Is

TypeScript CLI tool for searching file history from **TWO sources**:
1. **Local History**: VSCode/Cursor native local history (uncommitted saves)
2. **Git History**: All commits across all branches (includes remote)

## 🚀 Usage

### Option 1: MCP Tool (Recommended for AI Assistants)

**Available via MCP Protocol** - Prefer this method when working with AI assistants (Claude, Cursor):

```typescript
// MCP Tool: searchFileHistory
{
  "file_path": "/absolute/path/to/file",
  "source": "both",  // "local", "git", or "both"
  "text": "search text",  // optional
  "limit": 50  // optional
}
```

**MCP Configuration** (already set up globally):
- **Location**: `/home/fong/Projects/MCPs/ts-tuc-mang-minh-mcp/`
- **Status**: ✅ Connected globally
- **Tool Name**: `searchFileHistory`
- **See**: `.fong/.memory/20251010-ts-tuc-mang-minh-mcp-global-setup.md`

### Option 2: CLI Direct Use (Bash Commands)

**Primary Command Pattern**:
```bash
/home/fong/Projects/MCPs/ts-tuc-mang-minh/tuc-mang-minh.sh <absolute_file_path> [options]
```

⚠️ **ABSOLUTE PATH REQUIRED**: File path MUST be absolute (e.g., `/home/fong/Projects/...`), NOT relative.

### Create Alias (Optional)
```bash
# Add to ~/.bashrc or ~/.zshrc
alias tuc-mang-minh='/home/fong/Projects/MCPs/ts-tuc-mang-minh/tuc-mang-minh.sh'

# Usage after alias
tuc-mang-minh /absolute/path/to/file.ts
```

## 📋 Command Options

### Required
- `<file_path>`: **Absolute path** to the file (e.g., `/home/fong/Projects/de/public/wp-content/plugins/fong_de_lms/config/fong-config.php`)

### Optional Flags
- `--source <type>`: History source - `local`, `git`, or `both` (default: `both`)
- `--text <search>`: Search text within file versions
- `--start-date <date>`: Start date (YYYY-MM-DD HH:MM:SS)
- `--end-date <date>`: End date (YYYY-MM-DD HH:MM:SS)
- `--context <lines>`: Context lines around match (default: 5)
- `--limit <number>`: Limit to N recent versions (default: 50)
- `--history-path <path>`: Custom history path (for local source)

## 📝 Usage Examples

### MCP Usage (Preferred for AI)

**Example 1: Basic Search (Both Sources)**
```json
{
  "name": "searchFileHistory",
  "arguments": {
    "file_path": "/home/fong/Projects/MCPs/CLAUDE.md"
  }
}
```

**Example 2: Git History Only**
```json
{
  "name": "searchFileHistory",
  "arguments": {
    "file_path": "/home/fong/Projects/MCPs/ts-tuc-mang-minh/README.md",
    "source": "git",
    "limit": 10
  }
}
```

**Example 3: Text Search**
```json
{
  "name": "searchFileHistory",
  "arguments": {
    "file_path": "/home/fong/Projects/de/public/wp-content/plugins/fong_de_lms/config/fong-config.php",
    "text": "JWT",
    "limit": 5
  }
}
```

### CLI Usage (Direct Bash)

#### 1. Basic Search (Both Local + Git)
```bash
/home/fong/Projects/MCPs/ts-tuc-mang-minh/tuc-mang-minh.sh /home/fong/Projects/de/public/wp-content/plugins/fong_de_lms/config/fong-config.php
```

### 2. Git History Only
```bash
/home/fong/Projects/MCPs/ts-tuc-mang-minh/tuc-mang-minh.sh /home/fong/Projects/de/public/wp-content/plugins/fong_de_lms/bootstrap/fong-version-config.php --source git
```

### 3. Local History Only
```bash
/home/fong/Projects/MCPs/ts-tuc-mang-minh/tuc-mang-minh.sh /home/fong/Projects/de/public/wp-content/plugins/fong_de_lms/includes/enqueue/fong-3-tu-dien-enqueue.php --source local
```

### 4. Limit Results
```bash
/home/fong/Projects/MCPs/ts-tuc-mang-minh/tuc-mang-minh.sh /home/fong/Projects/MCPs/ts-tuc-mang-minh/README.md --limit 10
```

### 5. Search with Text
```bash
/home/fong/Projects/MCPs/ts-tuc-mang-minh/tuc-mang-minh.sh /home/fong/Projects/de/public/wp-content/plugins/fong_de_lms/includes/classes/Fong_JWT_Handler-class.php --text "JWT" --limit 5
```

### 6. Date Range Search
```bash
/home/fong/Projects/MCPs/ts-tuc-mang-minh/tuc-mang-minh.sh /home/fong/Projects/de/public/wp-content/plugins/fong_de_lms/config/fong-config.php --start-date "2025-01-01 00:00:00" --end-date "2025-12-31 23:59:59"
```

## 📤 Output Format

### Console Output Structure
```
--- Túc Mạng Minh: History Search ---
File: /absolute/path/to/file.php
Source: both
History Path: /home/fong/.config/Code/User/History

--- How to read file content from Git commit ---
git show <SHA>:<file_path>

Examples:
  git show 45fe0bfd:/absolute/path/to/file.php

Found X version(s) (Local: Y, Git: Z):

=== Local History ===
2025-10-05T11:54:36.865Z - /home/fong/.config/Code/User/History/-740e8c3c/ft3m.php
2025-08-27T06:36:25.059Z - /home/fong/.config/Code/User/History/-740e8c3c/Wzfy.php

=== Git History ===
2025-10-09T11:56:40.000Z - 45fe0bfd
  Author: Lim Paul (Fong)
  Message: FIX: Add chu_de_tu_vung post type to lookup whitelist
  Branch: main

2025-10-05T12:08:15.000Z - 44243863
  Author: Lim Paul (Fong)
  Message: WIP: Affiliate Dashboard improvements
  Branch: feature/affiliate

Results saved to: /home/fong/Projects/MCPs/ts-tuc-mang-minh/log/output-2025-10-10_152857.txt (50 lines)
```

### Output Files Location
- **Path**: `/home/fong/Projects/MCPs/ts-tuc-mang-minh/log/`
- **Format**: `output-YYYY-MM-DD_HHMMSS.txt`
- **Debug Log**: `/home/fong/Projects/MCPs/ts-tuc-mang-minh/log/debug.log`

## 🔍 How to Read Git Commit Content

Tool provides instructions at the **top of output** (not at the end):

```bash
# Read specific commit content
git show <SHA>:<absolute_file_path>

# Example (from tool output)
git show 45fe0bfd:/home/fong/Projects/de/public/wp-content/plugins/fong_de_lms/includes/enqueue/fong-3-tu-dien-enqueue.php
```

## 🛠️ Git Features

### Automatic Features
- ✅ Tracks file across **all commits** and **all branches**
- ✅ Follows file through **renames** (`git log --follow`)
- ✅ Displays commit SHA, author, message, branch
- ✅ Auto-fetches remote updates (`git fetch --all`)

### Branch Information
Tool shows which branch each commit belongs to:
- `main` - Main branch
- `feature/git-history` - Feature branch
- `(origin/main` - Remote tracking branch

## 📊 Test Results (Verified 2025-10-10)

### Files Tested
1. **fong-version-config.php**: 3 Git versions found
2. **De_Database_Query_API-class.php**: 1 Git version found
3. **fong-3-tu-dien-enqueue.php**: 10 versions (2 Local + 8 Git)
4. **fong-config.php**: 15 Git versions found (with --source git)
5. **fong-performance-optimizer.php**: No local history (test --source local)
6. **Fong_JWT_Handler-class.php**: 3 Git versions with --text "JWT"

### Performance
- **Speed**: < 2 seconds for most queries
- **Git fetch**: Automatic remote sync
- **Path handling**: Correctly uses `dirname(filePath)` for Git cwd
- **Output**: Instructions appear at **top** of output (as required)

## ⚙️ Development Mode (Optional)

For development/testing only (NOT recommended for production use):

```bash
# From tool directory
cd /home/fong/Projects/MCPs/ts-tuc-mang-minh

# Run with npm
npm start -- /absolute/path/to/file.ts --limit 20

# Build TypeScript
npm run build
```

## 🔑 Key Principles

### Usage Priority
1. **MCP Tool (PREFERRED)**: Use `searchFileHistory` MCP tool when available
2. **CLI Direct**: Use bash script `/home/fong/Projects/MCPs/ts-tuc-mang-minh/tuc-mang-minh.sh` for manual/debugging

**Why MCP First?**
- ✅ Integrated in AI workflow
- ✅ Automatic parameter validation
- ✅ Structured JSON output
- ✅ Already configured globally

### Path Requirements
- ✅ **MUST use absolute paths** (e.g., `/home/fong/Projects/...`)
- ❌ **NEVER use relative paths** (e.g., `./README.md` is INVALID)
- ✅ Tool validates path format (rejects relative paths)

### Tool Locations (Hardcoded)
- ✅ **MCP wrapper**: `/home/fong/Projects/MCPs/ts-tuc-mang-minh-mcp/` (AI integration)
- ✅ **CLI tool**: `/home/fong/Projects/MCPs/ts-tuc-mang-minh/tuc-mang-minh.sh` (direct bash)
- ✅ **Consistent across all projects**
- ✅ **No need to check if tools exist** - they're standard tools

### History Sources Priority
1. **Git History** (Primary): All commits, all branches, remote-synced
2. **Local History** (Secondary): VSCode/Cursor uncommitted saves
3. **Combined** (Default): Both sources merged by timestamp

### Default History Paths
- **Cursor** (Primary): `~/.config/Cursor/User/History`
- **VSCode** (Fallback): `~/.config/Code/User/History`

## 🚨 Common Issues & Solutions

### Issue 1: "File path must be absolute"
**Solution**: Use absolute path starting with `/`
```bash
# ❌ Wrong
/home/fong/Projects/MCPs/ts-tuc-mang-minh/tuc-mang-minh.sh README.md

# ✅ Correct
/home/fong/Projects/MCPs/ts-tuc-mang-minh/tuc-mang-minh.sh /home/fong/Projects/MCPs/ts-tuc-mang-minh/README.md
```

### Issue 2: "Not a Git repository"
**Solution**: Tool automatically uses file's directory for Git operations
- No action needed - tool handles this correctly

### Issue 3: "No historical versions found"
**Causes**:
- File never saved in Local History (new file or auto-save disabled)
- File never committed to Git
- Using wrong `--source` flag

**Solution**: Try with `--source both` (default)

## 📚 Related Files

### MCP Wrapper Structure (Preferred)
```
/home/fong/Projects/MCPs/ts-tuc-mang-minh-mcp/
├── dist/
│   └── index.js              # MCP server entry (compiled)
├── src/
│   └── index.ts              # MCP server implementation
├── README.md                 # MCP usage guide
├── INTEGRATION.md            # Integration details
├── SUMMARY.md                # Project summary
└── package.json              # Dependencies
```

### CLI Tool Structure
```
/home/fong/Projects/MCPs/ts-tuc-mang-minh/
├── tuc-mang-minh.sh          # Portable script (CLI)
├── dist/                      # Compiled TypeScript
├── src/
│   ├── cli.ts                # CLI argument parsing
│   ├── git-history.ts        # Git integration (uses dirname)
│   ├── orchestrator.ts       # Main logic
│   ├── printer.ts            # Output formatting
│   └── types.ts              # TypeScript types
├── log/
│   ├── output-*.txt          # Query results
│   └── debug.log             # Debug logging
└── README.md                 # Tool documentation
```

### Key Implementation Details
- **Git cwd fix**: Uses `dirname(filePath)` instead of `process.cwd()` (critical fix 2025-10-10)
- **Path validation**: Enforces absolute paths in `src/cli.ts`
- **Output order**: Git instructions appear at **top** (not end) in `src/printer.ts`
- **Portable script**: `tuc-mang-minh.sh` handles build check and execution

## 🔗 Integration with Other Projects

### WordPress Plugin Example
```bash
# Search in DE plugin
/home/fong/Projects/MCPs/ts-tuc-mang-minh/tuc-mang-minh.sh /home/fong/Projects/de/public/wp-content/plugins/fong_de_lms/config/fong-config.php --limit 15

# Search enqueue file with text
/home/fong/Projects/MCPs/ts-tuc-mang-minh/tuc-mang-minh.sh /home/fong/Projects/de/public/wp-content/plugins/fong_de_lms/includes/enqueue/fong-3-tu-dien-enqueue.php --text "nonce" --limit 10
```

### TypeScript/Node.js Projects
```bash
# Search tool's own files
/home/fong/Projects/MCPs/ts-tuc-mang-minh/tuc-mang-minh.sh /home/fong/Projects/MCPs/ts-tuc-mang-minh/src/git-history.ts --source git

# Search with Git only
/home/fong/Projects/MCPs/ts-tuc-mang-minh/tuc-mang-minh.sh /home/fong/Projects/MCPs/ts-tuc-mang-minh/README.md --source git --limit 5
```

## 📖 References

### Locations
- **MCP Wrapper**: `/home/fong/Projects/MCPs/ts-tuc-mang-minh-mcp/` (⭐ PREFERRED)
- **CLI Tool**: `/home/fong/Projects/MCPs/ts-tuc-mang-minh/`
- **Git Branch**: `feature/git-history` (Git integration), `main` (stable)

### Documentation
- **MCP Setup**: `.fong/.memory/20251010-ts-tuc-mang-minh-mcp-global-setup.md`
- **CLI Guide**: `ts-tuc-mang-minh/README.md`
- **MCP Integration**: `ts-tuc-mang-minh-mcp/INTEGRATION.md`

### Version Info
- **Version**: 1.0.0 (TypeScript rewrite)
- **Original**: Python version (deprecated)
- **Last Updated**: 2025-10-10

---

**Remember**:
- ⭐ **PREFER MCP tool** `searchFileHistory` when working with AI
- 🔧 **Use CLI** `/home/fong/Projects/MCPs/ts-tuc-mang-minh/tuc-mang-minh.sh` for manual/debugging
- 📍 **Always use hardcoded absolute paths** for consistency across all projects
