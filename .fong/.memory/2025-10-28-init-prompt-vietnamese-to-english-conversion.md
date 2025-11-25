# init-prompt.json Vietnamese to English Conversion

**Date**: 2025-10-28
**Version**: 2025-10-28--migration-mcp-dkm-newrag-integration
**Task**: Convert Vietnamese text to precise English terminology

## Summary

Converted all Vietnamese text in init-prompt.json to precise English terminology while preserving technical accuracy and meaning.

## Changes Made

### 1. CRITICAL_NOTICE (line 8)
- **Before**: `"⚠️ PHẢI ĐỌC VÀ THỰC HIỆN THEO TỪNG BƯỚC TRONG FILE NÀY - MANDATORY EXECUTION REQUIRED"`
- **After**: `"⚠️ MUST READ AND EXECUTE EACH STEP IN THIS FILE - MANDATORY EXECUTION REQUIRED"`

### 2. timing_usage.dkm_mcp (line 98)
- **Before**: `"Use QueryRAG/NewRAG/Perplexity/ArXiv BEFORE + DURING work (trước - trong khi làm task)"`
- **After**: `"Use QueryRAG/NewRAG/Perplexity/ArXiv BEFORE + DURING task execution"`

### 3. timing_usage.memory_mem0 (line 99)
- **Before**: `"Use .memory/ + mem0 BEFORE + DURING + AFTER work (trước - trong - sau khi làm task) - Always align"`
- **After**: `"Use .memory/ + mem0 BEFORE + DURING + AFTER task execution - Always align"`

### 4. usage_rules (line 120)
- **Before**: `"⚠️ CRITICAL: ALWAYS use mem0 MCP VERY FREQUENTLY for memory CRUD (trước-trong-sau tasks)"`
- **After**: `"⚠️ CRITICAL: ALWAYS use mem0 MCP VERY FREQUENTLY for memory CRUD (before-during-after task execution)"`

### 5. QUERY_PHILOSOPHY (line 132)
- **Before**: `"Query BEFORE-DURING work (trước-trong khi làm task) - Query SHORT, FREQUENTLY - NEVER complex multi-level logical structure queries"`
- **After**: `"Query BEFORE-DURING task execution - Query SHORT, FREQUENTLY - NEVER complex multi-level logical structure queries"`

### 6. CRITICAL_RULES (line 235)
- **Before**: `"⚠️ Query BEFORE-DURING work (trước-trong khi làm task, not just once)"`
- **After**: `"⚠️ Query BEFORE-DURING task execution (not just once)"`

### 7. timing in WHY_NEWRAG_IS_EXPERT_DSS (line 243)
- **Before**: `"timing": "Query BEFORE-DURING work (trước-trong khi làm task)"`
- **After**: `"timing": "Query BEFORE-DURING task execution"`

## Terminology Mapping

| Vietnamese | English Terminology |
|-----------|---------------------|
| trước | BEFORE |
| trong khi | DURING |
| sau | AFTER |
| làm task | task execution |
| PHẢI ĐỌC VÀ THỰC HIỆN THEO TỪNG BƯỚC | MUST READ AND EXECUTE EACH STEP |

## Validation

- ✅ JSON syntax valid (jq empty passed)
- ✅ No Vietnamese text remaining (rg search returned no results)
- ✅ All technical meanings preserved
- ✅ Precise English terminology used throughout

## Files Updated

- `.fong/instructions/init-prompt.json` (6 Vietnamese phrases converted)

## Related Information

- Previous migration: 2025-10-28-init-prompt-migration-plan.md
- Commit: "Convert Vietnamese to precise English terminology"
- Total conversions: 7 locations
- Line count: 509 (unchanged)

## Key Learning

- User requires "precise/terminology English" for all instruction files
- Vietnamese translations in parentheses should be converted to standard English technical terms
- "task execution" is the precise terminology for "làm task"
- BEFORE-DURING-AFTER pattern is the standard timing terminology
