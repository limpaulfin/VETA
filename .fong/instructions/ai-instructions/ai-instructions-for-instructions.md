---
title: "How to Write Instruction Files"
subtitle: "Guide for AI Agents: Creating Documentation in .fong/instructions/"
author: "DE Administrative Tasks Team"
date: "2025-11-06"
version: "2.2.0"
documentclass: article
geometry: "top=2.5cm, bottom=2.5cm, left=3cm, right=3cm"
fontsize: 11pt
linestretch: 1.3
---

> **Purpose**: Teach AI agents HOW to write instruction files for `.fong/instructions/` directory.

> **Skeleton Template**: Always clone `ai-instructions/instruction-skeleton.md` as starting point.

> **Scope**: This is a META-GUIDE for CREATING instruction documentation, NOT for executing tasks.

---

## Quick Start

When asked to create an instruction file:

1. **Read mandatory files**:
   - `.fong/instructions/init-prompt.json`
   - `.fong/instructions/fongtools.json`
   - `ai-instructions/instruction-skeleton.md` (WBS template)

2. **Clone skeleton**:
   ```bash
   cp ai-instructions/instruction-skeleton.md .fong/instructions/instructions-[tool-name].md
   ```

3. **Follow this guide** to fill in instruction-specific content.

4. **Apply verification** from skeleton's WBS template.

---

## When to Create an Instruction File

| Trigger | Example | File Pattern |
|---------|---------|--------------|
| New MCP/tool integration | mem0 API, Autochrome | `instructions-[tool].md` |
| New process/workflow | Memory CRUD, Task management | `fong[process].md` |
| Complex operation (3+ steps, repeatable) | Paper analysis workflow | `instructions-[process].md` |
| Legacy doc replacement | Outdated/incomplete existing file | Same filename, increment version |

---

## Instruction File Pattern (`.fong/instructions/`)

### Structure Analysis (from existing files)

**Studied**: `fongmemory.md`, `instructions-mem0.md`

**Pattern discovered**:

```markdown
# [Emoji] [Tool/Process Name]

**Version**: YYYY-MM-DD-[short-description]
**Maintainers**: [Names]
**Scope**: [One-line purpose]
**Last Updated**: [Date]

---

## 📑 Table of Contents (if > 200 lines)

---

## 🎯 Core Principles ⚠️ MANDATORY

**Critical Rule #1**: [Non-negotiable constraint with ⚠️ emoji]
**Critical Rule #2**: [Another critical rule]

**Pitfalls to Avoid**:
- ❌ [Common mistake]
- ❌ [Another mistake]

---

## [Operation 1]

### Step 1: [Action]
[Explanation]

```bash
# Copy-paste-ready command with ABSOLUTE paths
command --flag value
```

### Step 2: [Next Action]
...

---

## Troubleshooting (Optional)

**Error**: [Error message]
**Solution**: [Fix]

---

## Related Documentation
- [Link to related instruction file]
```

---

## Critical Requirements for Instruction Files

### 1. Header Metadata Format

```markdown
# [Emoji] [Tool Name]

**Version**: YYYY-MM-DD-[description]
**Maintainers**: Fong & Codex CLI
**Scope**: [One-line purpose]
**Last Updated**: [Date with context]
```

**Why**:
- Emoji makes scanning easier
- Version tracks evolution
- Maintainers enable follow-up questions
- Scope prevents scope creep

### 2. Core Principles Section (MANDATORY)

**THIS IS THE MOST IMPORTANT SECTION**

Place BEFORE any instructions. Use ⚠️ or 🚨 for critical rules.

**Example** (from `fongmemory.md`):
```markdown
## 🎯 Nguyên Tắc Cơ Bản

**Quy tắc vàng:** Mọi thông tin quan trọng đều được lưu vào `.fong/.memory/` (Single Source of Truth)

**⚠️ QUAN TRỌNG - MEMORY FILE LOCATION RULES:**
- **WRITE LOCATION:** `/home/fong/Projects/de/administrative-tasks/.fong/.memory/` (project-specific)
- **KHÔNG TẠO SUBFOLDER:** Tất cả files phải nằm TRỰC TIẾP trong `.memory/`
```

**Why**:
- Readers scan for critical rules first
- Prevents costly mistakes before they happen
- Emoji markers increase visibility

### 3. Copy-Paste-Ready Code Examples

**Requirements**:
- Use ABSOLUTE paths (never relative)
- Include parameter explanations as comments
- Show expected output when relevant
- No placeholders like `YOUR_TOKEN` without context

**Example** (from `instructions-mem0.md`):
```bash
# Get token from https://app.mem0.ai/settings/api-keys
# Fire-and-forget pattern (non-blocking, < 0.1s)
nohup curl --max-time 3 -sS -X POST https://api.mem0.ai/v1/memories/ \
  -H "Authorization: Token m0-abc123..." \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [{"role": "user", "content": "CONTENT_HERE"}],
    "user_id": "de-administrative-tasks"
  }' > /dev/null 2>&1 &
```

**Why**:
- Reduces cognitive load (reader doesn't guess)
- Shows performance considerations (fire-and-forget)
- Absolute paths prevent "file not found" errors

### 4. Document Failure Modes

For each operation, document common errors.

**Pattern**:
```markdown
## [Operation Name]

```bash
command
```

**⚠️ Common Errors:**
- `404 Not Found`: [Reason] → [Solution]
- `405 Method Not Allowed`: [Reason] → [Solution]
```

**Why**:
- Saves debugging time
- Builds confidence (reader knows what to expect)

---

## Common Mistakes & Fixes

### ❌ Mistake 1: Burying Critical Rules

**Bad**:
```markdown
## How to Use Tool

First, do X. Then do Y. Note: Never do Z with production data.
```

**Good**:
```markdown
## 🎯 Core Principles

**🚨 CRITICAL: NEVER USE WITH PRODUCTION DATA**
- Use staging environment for testing
- Backup before running commands
```

### ❌ Mistake 2: Relative Paths

**Bad**:
```bash
python scripts/process.py
```

**Good**:
```bash
# From project root: /home/fong/Projects/de/administrative-tasks
python /home/fong/Projects/de/administrative-tasks/scripts/process.py
```

### ❌ Mistake 3: Placeholders Without Context

**Bad**:
```bash
curl -H "Authorization: Token YOUR_TOKEN"
```

**Good**:
```bash
# Get token: https://app.example.com/settings/api-keys
# Replace TOKEN below with your actual token
curl -H "Authorization: Token sk-abc123..."
```

### ❌ Mistake 4: No Failure Documentation

**Bad**:
```markdown
## Delete Item

```bash
curl -X DELETE https://api.example.com/items/{id}
```
```

**Good**:
```markdown
## Delete Item

```bash
curl -X DELETE https://api.example.com/items/{id}
```

**⚠️ Common Errors:**
- `404`: Item not found or already deleted
- `403`: Insufficient permissions
```

---

## Workflow: Writing an Instruction File

### Phase 1: Research (20%)

**Use skeleton's WBS template**. See `instruction-skeleton.md` for full template.

Example tasks:
- WBS-01-01: Read init-prompt.json & fongtools.json
- WBS-01-02: Search .memory for related instructions
- WBS-01-03: Query DKM RAG for tool documentation
- WBS-01-04: Analyze 2-3 similar files in `.fong/instructions/`

**Key Question**: "What are the CRITICAL RULES users must know?"

### Phase 2: Planning (10%)

- Identify target audience
- Define scope (what operations to cover?)
- List critical rules/constraints
- Draft section outline

### Phase 3: Writing (50%)

**Use this order**:
1. Fill header metadata
2. Write Core Principles section (critical rules)
3. Write Step 1 with code example
4. Write Step 2 with code example
5. ... (repeat for each operation)
6. Add troubleshooting section
7. Add related documentation links

**For each code example**:
- Test if possible
- Use absolute paths
- Add comments explaining parameters
- Show expected output

### Phase 4: Verification (20%)

**Use skeleton's WBS template** for verification steps:
- Independent double-check (pre)
- Continuous cross-check (during)
- Critical thinking retrospective (post)

**Specific checks for instructions**:
- [ ] All code examples copy-paste-ready?
- [ ] Absolute paths used?
- [ ] Critical rules with emoji markers?
- [ ] Failure modes documented?
- [ ] No jargon without definition?

---

## Quality Checklist

Before committing:

### Structure ✅
- [ ] File name: `instructions-[tool].md` or `fong[process].md`
- [ ] Header metadata complete
- [ ] Core Principles section exists and is FIRST
- [ ] Step-by-step instructions use numbered lists
- [ ] Code examples use syntax highlighting

### Content ✅
- [ ] All code examples copy-paste-ready
- [ ] Absolute paths used
- [ ] Critical rules with ⚠️ or 🚨
- [ ] At least 1 concrete example per operation
- [ ] Troubleshooting addresses common errors

### Integration ✅
- [ ] File added to `.fong/instructions/`
- [ ] `fongtools.json` updated (if new tool)
- [ ] `.memory` note created
- [ ] Mem0 synced (fire-and-forget pattern from instructions-mem0.md)

---

## After Writing

### 1. Update fongtools.json

```json
{
  "instructions": [
    {
      "name": "[Tool Name] - [Description]",
      "file": ".fong/instructions/instructions-[tool].md"
    }
  ]
}
```

### 2. Create Memory Note

Template: `.fong/.memory/YYYY-MM-DD-instruction-[tool]-created.md`

Include:
- Why instruction was needed
- Sources consulted (DKM RAG, Perplexity)
- Key decisions made
- Related instruction files

### 3. Sync Mem0 (Fire-and-Forget)

```bash
# Use pattern from instructions-mem0.md
nohup curl --max-time 3 -sS -X POST https://api.mem0.ai/v1/memories/ \
  -H "Authorization: Token m0-6kfefCvs5TdX3X2vhLNqNLxF35v4uIxbqjjbqKjVG6" \
  -d "{\"messages\": [{\"role\": \"user\", \"content\": \"Created instructions-[tool].md: [operations covered]. Sources: [DKM/Perplexity]\"}], \"user_id\": \"de-administrative-tasks\"}" > /dev/null 2>&1 &
```

### 4. Cross-Reference

Add references in related instruction files:

```markdown
## Related Documentation
- [New Instruction](instructions-[tool].md)
```

---

## Examples of Good Instruction Files

### Example 1: Tool Integration

**File**: `instructions-mem0.md`

**What makes it good**:
- ✅ Version clearly states what's tested ("fire-and-forget-tested")
- ✅ Scope is one clear sentence
- ✅ Critical auth info upfront
- ✅ Fire-and-forget pattern explained (addresses performance)
- ✅ Copy-paste curl examples with full tokens (safe demo tokens)
- ✅ User ID naming convention documented
- ✅ Verified status of EACH endpoint (working/broken)
- ✅ Broken endpoints documented (saves debugging time)

**Key insight**: Document what DOESN'T work to save time.

### Example 2: Process Documentation

**File**: `fongmemory.md`

**What makes it good**:
- ✅ Critical location rules upfront with ⚠️
- ✅ CRUD workflow clearly ordered (R → C → U → D)
- ✅ "Silent execution" rule (no yapping)
- ✅ Flat structure mandate (no subfolders)
- ✅ Search-before-create principle enforced
- ✅ Absolute paths everywhere

**Key insight**: Prevent common mistakes by stating rules upfront.

---

## Research Sources Before Writing

### Query DKM RAG

```bash
mcp__dkm-knowledgebase__queryRAG "technical documentation clarity API reference"
mcp__dkm-knowledgebase__queryRAG "[tool name] usage patterns best practices"
```

### Query Perplexity

```bash
mcp__dkm-knowledgebase__queryPerplexity \
  --role "Technical Writer Expert" \
  --context "Writing instruction doc for [tool]" \
  --instructions "Best practices for API documentation" \
  --output_format "Bullet points" \
  --question "How to write clear API instructions?"
```

### Analyze Existing Files

Read these as examples:
- Tool integration: `instructions-mem0.md`, `instructions-autochrome.md`
- Process doc: `fongmemory.md`, `fongtask.md`

---

## Maintenance

### When to Update
- Tool/API version changes
- New operations added
- Bug discovered in examples
- User feedback indicates confusion

### Update Process
1. Increment version: `YYYY-MM-DD-[description]`
2. Update "Last Updated" field
3. Test all code examples
4. Update `.memory` note
5. Sync mem0

### Deprecation
If instruction becomes obsolete:
1. Add `[DEPRECATED]` to title
2. Add deprecation notice at top
3. Link to replacement
4. Do NOT delete (preserve history)

---

## Summary: Instruction Writing Checklist

**Before writing**:
- [ ] Clone `instruction-skeleton.md`
- [ ] Read 2-3 similar files in `.fong/instructions/`
- [ ] Query DKM RAG for tool docs
- [ ] List critical rules

**While writing**:
- [ ] Core Principles section FIRST
- [ ] Copy-paste-ready examples
- [ ] Absolute paths only
- [ ] Document failure modes
- [ ] Use WBS from skeleton for task breakdown

**After writing**:
- [ ] Run verification from skeleton
- [ ] Update `fongtools.json`
- [ ] Create `.memory` note
- [ ] Sync mem0
- [ ] Commit & push

---

**Reference**: See `ai-instructions/instruction-skeleton.md` for:
- YAML front matter template
- WBS micro-task template (with Context, Prerequisites, Input, Output, Tools, Verification, Execution Steps, Rollback Plan)
- Triple verification framework (Independent double-check, Continuous cross-check, Critical thinking retrospective)
