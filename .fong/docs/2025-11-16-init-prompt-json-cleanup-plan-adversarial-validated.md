---
title: "Kế Hoạch Cleanup init-prompt.json (Adversarial Validated)"
subtitle: "Proof by Contradiction | Migration Strategy | Risk Mitigation"
version: "1.0.0"
created: "2025-11-16"
updated: "2025-11-16"
author: "Fong + Claude (Adversarial Validation)"
purpose: "Comprehensive cleanup plan with risk analysis and migration strategy"
keywords: "init-prompt, cleanup, refactoring, breaking-changes, migration, adversarial-validation"
validation_method: "Null Hypothesis Testing + DKM RAG + Model Knowledge"
---

## 🚨 NULL HYPOTHESIS (H₀)

**"Kế hoạch cleanup ban đầu CÓ LỖI NGHIÊM TRỌNG và sẽ gây BREAKING CHANGES"**

---

## ✅ PROOF RESULT: VIOLATION CONFIRMED

### Evidence Found (Adversarial Validation)

**Strategy 1 (Model Knowledge) - 5 Critical Issues Discovered:**

1. ❌ **LOST DATA RISK**: Xóa 86.5% nội dung (594 → 80 LOC) mà KHÔNG backup
2. ❌ **BREAKING CHANGE**: Session hook `.claude/hooks/SessionStart.sh` đang đọc init-prompt.json theo structure CŨ
3. ❌ **MISSING MIGRATION**: Không có kế hoạch cập nhật consumers (hooks, scripts)
4. ❌ **NO VERIFICATION**: Không có automated test để verify file mới vẫn functional
5. ❌ **INCOMPLETE ANALYSIS**: Chưa check xem code nào đang reference các keys sẽ bị xóa

**Strategy 2 (DKM RAG - Refactoring Book):**

> "Small steps are safer: each step leaving the code in a working state that compiles and passes its tests."
> — Martin Fowler, Refactoring (2019), Page 84

> "Fixing a defect has a substantial (20-50%) chance of introducing another."
> — Frederick Brooks, The Mythical Man-Month (1986), Page 253

**Conclusion**: Kế hoạch ban đầu VI PHẠM refactoring best practices (no small steps, no tests, high risk).

---

## 📋 KẾ HOẠCH CLEANUP HOÀN CHỈNH (REVISED)

### OKR (Objective & Key Results)

**Objective**: `init-prompt.json` chỉ chứa nội dung UNIQUE (không trùng init-prompt.md)

**Key Results**:
1. ✅ Giảm từ 594 LOC → ~80 LOC (~86.5%)
2. ✅ Zero breaking changes (all consumers still work)
3. ✅ Automated verification tests pass
4. ✅ Full backup + migration path documented

---

## 🔬 PHASE 0: PRE-CLEANUP VERIFICATION (CRITICAL)

### Step 0.1: Find All Consumers

**Objective**: Tìm TẤT CẢ code đang đọc/parse init-prompt.json

```bash
# Search trong project
smart-search-fz-rg-bm25 "init-prompt.json" /home/fong/Projects/boiler-plate-cursor-project-with-init-prompt --show-content --top-k 20

# Fallback ripgrep
rg -n "init-prompt\.json" /home/fong/Projects/boiler-plate-cursor-project-with-init-prompt --type sh --type js --type py
```

**Expected Consumers**:
- `.claude/hooks/SessionStart.sh` (confirmed)
- `.claude/hooks/hyperfocus-context.sh` (possible)
- Any script in `.fong/` directory
- Any MCP server config

**Output**: List of all files + line numbers referencing init-prompt.json

---

### Step 0.2: Analyze Consumer Dependencies

**For EACH consumer found, check**:

1. **What JSON keys are accessed?**
   ```bash
   # Example: Check SessionStart.sh
   rg -A 5 -B 5 "init-prompt\.json" .claude/hooks/SessionStart.sh
   ```

2. **Which keys from DELETED sections are used?**
   - If consumer uses `🌟_CORE_MINDSET_AND_PRINCIPLES` → BREAKING
   - If consumer uses `configuration.api_tokens` → SAFE (kept)

3. **Create dependency matrix**:
   ```
   Consumer File                    | Keys Used                        | Status
   --------------------------------|----------------------------------|--------
   .claude/hooks/SessionStart.sh   | ALL (reads entire file)          | 🔴 BREAKING
   hyperfocus-context.sh           | configuration.assistant_profile  | 🟢 SAFE
   ```

**Action**: Document ALL dependencies BEFORE proceeding.

---

### Step 0.3: Create Backup Strategy

**Backup 1: Timestamped Copy**
```bash
timestamp=$(date +%Y%m%d_%H%M%S)
cp .fong/instructions/init-prompt.json ".fong/instructions/init-prompt.json.${timestamp}.b"
```

**Backup 2: Git Commit (Pre-Cleanup Snapshot)**
```bash
git add .fong/instructions/init-prompt.json
git commit -m "backup: Pre-cleanup snapshot of init-prompt.json

- Current size: 594 LOC
- About to cleanup (remove 86.5% duplicate content)
- Backup for rollback if breaking changes occur"
```

**Backup 3: Copy to Archive**
```bash
mkdir -p .fong/archive/init-prompt-json-cleanup/
cp .fong/instructions/init-prompt.json .fong/archive/init-prompt-json-cleanup/original-594-loc.json
```

---

### Step 0.4: Create Automated Verification Test

**Test File**: `.fong/tests/test-init-prompt-json-integrity.sh`

```bash
#!/usr/bin/env bash
# Test: Verify init-prompt.json still has required keys

set -e

JSON_FILE=".fong/instructions/init-prompt.json"

echo "🧪 Testing init-prompt.json integrity..."

# Test 1: File exists
if [ ! -f "$JSON_FILE" ]; then
  echo "❌ FAIL: File not found"
  exit 1
fi

# Test 2: Valid JSON
if ! jq empty "$JSON_FILE" 2>/dev/null; then
  echo "❌ FAIL: Invalid JSON syntax"
  exit 1
fi

# Test 3: Required keys exist (UNIQUE content only)
REQUIRED_KEYS=(
  "configuration"
  "configuration.api_tokens"
  "configuration.api_tokens.asana"
  "assistant_profile"
  "assistant_profile.name"
  "discovery_commands"
  "tools_preference.asana_handling"
  "teaching_methodology.three_short_habits"
)

for key in "${REQUIRED_KEYS[@]}"; do
  if ! jq -e ".$key" "$JSON_FILE" >/dev/null 2>&1; then
    echo "❌ FAIL: Missing key: $key"
    exit 1
  fi
done

# Test 4: Verify NO duplicate content (should NOT have these keys)
FORBIDDEN_KEYS=(
  "🌟_CORE_MINDSET_AND_PRINCIPLES"
  "🔥🔥🔥_MCP_TOOLS_ABSOLUTE_PRIORITY"
  "🔥🔥🔥_DKM_NEWRAG_EXPERT_DSS"
  "workflow"
  "core_principles.clean_code_principles"
)

for key in "${FORBIDDEN_KEYS[@]}"; do
  if jq -e ".$key" "$JSON_FILE" >/dev/null 2>&1; then
    echo "❌ FAIL: Duplicate key found (should be removed): $key"
    exit 1
  fi
done

echo "✅ PASS: All tests passed"
exit 0
```

**Run Test BEFORE cleanup**:
```bash
chmod +x .fong/tests/test-init-prompt-json-integrity.sh
.fong/tests/test-init-prompt-json-integrity.sh
# Expected: FAIL (because forbidden keys still exist)
```

---

## 🔧 PHASE 1: CONSUMER MIGRATION (CRITICAL - DO FIRST)

### Step 1.1: Update SessionStart.sh Hook

**Current Issue**: Hook đọc toàn bộ init-prompt.json và parse structure cũ

**Migration Strategy**: Hook phải đọc CẢ 2 files (init-prompt.md + init-prompt.json)

**Updated Hook Logic**:
```bash
#!/usr/bin/env bash

# Load init-prompt.md (principles, workflows, mindsets)
INIT_PROMPT_MD=".fong/init-prompt.md"

# Load init-prompt.json (unique config only)
INIT_PROMPT_JSON=".fong/instructions/init-prompt.json"

# Check both exist
if [ ! -f "$INIT_PROMPT_MD" ] || [ ! -f "$INIT_PROMPT_JSON" ]; then
  echo "❌ ERROR: Missing init-prompt files"
  exit 1
fi

# Inject BOTH into system-reminder
echo "--- init-prompt.json ---"
cat "$INIT_PROMPT_JSON" | tr -d '\n'
echo ""

echo "--- Reference: See init-prompt.md for principles/workflows ---"
echo "Path: $INIT_PROMPT_MD"
```

**Test Migration**:
```bash
# Run updated hook manually
.claude/hooks/SessionStart.sh

# Verify output contains BOTH file references
```

---

### Step 1.2: Update Any Other Consumers

**For EACH consumer in dependency matrix**:

1. Update to read from BOTH sources:
   - Principles/workflows → Read `.fong/init-prompt.md`
   - Config/tokens → Read `.fong/instructions/init-prompt.json`

2. Test updated consumer independently

3. Document changes in migration log

---

## 🗑️ PHASE 2: EXECUTE CLEANUP (AFTER MIGRATION)

### Step 2.1: Create Cleaned JSON

**New Structure** (80 LOC):

```json
{
  "name": "AI Assistant Init Prompt - Configuration Only",
  "updated": "2025-11-16T00:14:40+07:00",
  "description": "Minimal configuration file - Contains ONLY unique data NOT in init-prompt.md",

  "CRITICAL_NOTICE": "⚠️ This file contains ONLY unique configuration data. All principles, mindsets, and workflows are in .fong/init-prompt.md",

  "reference": {
    "principles_and_workflows": ".fong/init-prompt.md",
    "tools_catalog": ".fong/instructions/fongtools.json"
  },

  "configuration": {
    "api_tokens": {
      "asana": "2/1133089446774381/1211151389782670:b27850f7870359f453a2adf9916f620d"
    }
  },

  "assistant_profile": {
    "name": "Asi",
    "response_language": "Plain Vietnamese",
    "response_style": "Concise and focused",
    "deep_analysis": "Think Ultra methodology for optimal implementation"
  },

  "discovery_commands": {
    "list_resources": "tree -L 1 .fong/instructions/ .fong/agents/",
    "fallback": "If error, check pwd and use absolute paths with tree",
    "full_list": "tree /home/fong/Dropbox/Projects/boiler-plate-cursor-project-with-init-prompt/.fong/instructions/ /home/fong/Dropbox/Projects/boiler-plate-cursor-project-with-init-prompt/.fong/agents/"
  },

  "tools_preference": {
    "asana_handling": {
      "trigger_patterns": [
        "https://app.asana.com/",
        "app.asana.com/",
        "asana.com/.*task/"
      ],
      "extraction_regex": ".*/task/([0-9]+)",
      "handler_file": "fongasana.md",
      "api_endpoint_template": "https://app.asana.com/api/1.0/tasks/{TASK_ID}?opt_fields=name,notes,attachments,due_on,completed,assignee,projects.name",
      "workflow": [
        "1. Parse task ID from URL using extraction_regex",
        "2. Use curl with Authorization Bearer token from configuration.api_tokens.asana",
        "3. Get task info with attachments using api_endpoint_template",
        "4. Download attachments if present using download_task_attachments function",
        "5. CRUD update to configuration.memory_paths.asana_tracking on-the-fly"
      ],
      "critical_rules": [
        "NEVER use WebFetch for Asana URLs - returns 403 error",
        "ALWAYS use Bash curl with API token",
        "ALWAYS download attachments when present",
        "ALWAYS update tracking file on-the-fly"
      ]
    }
  },

  "teaching_methodology": {
    "three_short_habits": {
      "description": "Three essential habits for reliable AI system implementation",
      "habits": [
        "Ask for clarification when input is ambiguous",
        "Summarize concisely when uncertain about details",
        "Prefer admitting 'don't know' over fabricating information"
      ],
      "importance": "Critical for system reliability and trustworthiness",
      "application": "Apply these habits in all interactions to maintain accuracy and avoid hallucinations"
    }
  }
}
```

**NEW ADDITION**: `reference` section to point to init-prompt.md

---

### Step 2.2: Apply Cleanup

```bash
# Backup (already done in Phase 0)
timestamp=$(date +%Y%m%d_%H%M%S)
cp .fong/instructions/init-prompt.json ".fong/instructions/init-prompt.json.${timestamp}.b"

# Replace with cleaned version
# (Use Write tool to create new content)
```

---

## ✅ PHASE 3: VERIFICATION & VALIDATION

### Step 3.1: Run Automated Tests

```bash
# Test 1: JSON integrity
.fong/tests/test-init-prompt-json-integrity.sh
# Expected: ✅ PASS

# Test 2: Hook still works
.claude/hooks/SessionStart.sh
# Expected: Output includes both init-prompt.json + reference to init-prompt.md

# Test 3: No breaking changes
# Run any script that depends on init-prompt.json
```

---

### Step 3.2: Manual Verification Checklist

- [ ] File size reduced: 594 → ~80 LOC
- [ ] Required keys present (configuration, assistant_profile, etc.)
- [ ] Forbidden keys removed (🌟_CORE_MINDSET_AND_PRINCIPLES, etc.)
- [ ] All consumers still work (hooks, scripts)
- [ ] Backup exists (.json.{timestamp}.b)
- [ ] Git commit created (rollback point)

---

### Step 3.3: Smoke Test

**Test Session Start**:
1. Start new Claude session
2. Verify hook output contains init-prompt.json content
3. Verify reference to init-prompt.md is present
4. Check no errors in system-reminder

---

## 🔄 PHASE 4: ROLLBACK PLAN (IF NEEDED)

### Rollback Triggers

**IF ANY of these occur** → Immediate rollback:
- ❌ Hook crashes or fails
- ❌ JSON parsing errors
- ❌ Consumer script breaks
- ❌ Missing critical config (API tokens)

### Rollback Commands

```bash
# Find latest backup
ls -lt .fong/instructions/init-prompt.json.*.b | head -1

# Restore from backup
cp .fong/instructions/init-prompt.json.20251116_001440.b .fong/instructions/init-prompt.json

# OR: Git revert
git log --oneline -5  # Find pre-cleanup commit
git revert <commit-hash>

# Verify rollback
.fong/tests/test-init-prompt-json-integrity.sh
```

---

## 📊 METRICS & SUCCESS CRITERIA

### Quantitative Metrics

| Metric | Before | After | Target |
|--------|--------|-------|--------|
| File Size (LOC) | 594 | ~80 | < 100 |
| Duplicate Content | ~86% | 0% | 0% |
| Unique Keys | 5 | 5 | ≥5 |
| Consumers Broken | N/A | 0 | 0 |
| Test Pass Rate | 0% (no tests) | 100% | 100% |

### Qualitative Success Criteria

- ✅ Zero breaking changes
- ✅ All consumers work as before
- ✅ Clear separation: config (JSON) vs principles (MD)
- ✅ Easy to maintain (small file, focused purpose)
- ✅ Documented migration path

---

## 📚 SECTIONS DELETED (Reference)

**These sections are REMOVED from init-prompt.json (already in init-prompt.md)**:

1. `🌟_CORE_MINDSET_AND_PRINCIPLES` (115 lines)
2. `🔥🔥🔥_MCP_TOOLS_ABSOLUTE_PRIORITY` (63 lines)
3. `🔥🔥🔥_DKM_NEWRAG_EXPERT_DSS` (119 lines)
4. `workflow` (80 lines)
5. `purpose` (8 lines)
6. `required_reads` (5 lines)
7. `context_management` (8 lines)
8. `core_principles.clean_code_principles` (36 lines)
9. `core_principles.verification` (4 lines)
10. `core_principles.code_standards` (25 lines)
11. `memory_alignment_enforcement` (27 lines)
12. `prompt_processing` (53 lines)

**Total Deleted**: ~543 lines (91.4% of content)

---

## 📝 SECTIONS KEPT (Unique Content)

**These sections are KEPT in init-prompt.json (NOT in init-prompt.md)**:

1. `configuration.api_tokens.asana` - API credentials
2. `assistant_profile` - Asi profile (name, language, style)
3. `discovery_commands` - Tree commands for listing resources
4. `tools_preference.asana_handling` - Asana URL handling workflow
5. `teaching_methodology.three_short_habits` - Core habits

**NEW ADDITION**:
6. `reference` - Pointers to init-prompt.md and fongtools.json

**Total Kept**: ~80 lines (13.5% of content + new reference section)

---

## 🎯 WHY THIS PLAN IS SAFER

### Comparison: Original vs Revised

| Aspect | Original Plan | Revised Plan (Adversarial) |
|--------|---------------|---------------------------|
| **Backup** | ❌ Not mentioned | ✅ 3-tier backup (timestamp + git + archive) |
| **Consumer Analysis** | ❌ Not done | ✅ Find all consumers + dependency matrix |
| **Migration** | ❌ No migration path | ✅ Update hooks/scripts BEFORE cleanup |
| **Testing** | ❌ No tests | ✅ Automated integrity tests |
| **Small Steps** | ❌ Big bang change | ✅ Phase-by-phase (4 phases) |
| **Rollback** | ❌ Not planned | ✅ Clear rollback triggers + commands |
| **Verification** | ❌ Manual only | ✅ Automated + manual checklist |
| **Citations** | ❌ None | ✅ Refactoring book + Mythical Man-Month |

---

## 📖 CITATIONS & REFERENCES

### Primary Sources

1. **Refactoring: Improving the Design of Existing Code** (Martin Fowler, 2019)
   - "Small steps are safer" - Page 84
   - Evidence: RAG query result

2. **The Mythical Man-Month** (Frederick Brooks, 1986)
   - "Fixing a defect has 20-50% chance of introducing another" - Page 253
   - Evidence: RAG query result

### Validation Method

- **Null Hypothesis**: "Kế hoạch cleanup có lỗi nghiêm trọng"
- **Proof Strategy 1**: Model Knowledge → Found 5 critical issues
- **Proof Strategy 2**: DKM RAG → Found refactoring best practices
- **Conclusion**: Violation CONFIRMED → Created safer revised plan

---

## ✅ NEXT STEPS (Execution Order)

1. **READ THIS PLAN** thoroughly
2. **PHASE 0**: Pre-cleanup verification (find consumers, backup, create tests)
3. **PHASE 1**: Consumer migration (update hooks FIRST)
4. **PHASE 2**: Execute cleanup (replace JSON file)
5. **PHASE 3**: Verification & validation (run tests, smoke test)
6. **PHASE 4**: Rollback (ONLY if verification fails)

---

## 🔗 Related Files

- **Source**: `.fong/instructions/init-prompt.json` (594 LOC)
- **Target**: Same file (cleaned, 80 LOC)
- **Reference**: `.fong/init-prompt.md` (principles/workflows)
- **Catalog**: `.fong/instructions/fongtools.json` (tools list)
- **Hook**: `.claude/hooks/SessionStart.sh` (consumer)
- **Tests**: `.fong/tests/test-init-prompt-json-integrity.sh` (new)

---

**Version**: 1.0.0
**Created**: 2025-11-16
**Validation**: Adversarial (Null Hypothesis Testing + DKM RAG)
**Philosophy**: "ZERO TRUST! Assume it's wrong, prove it. If you can't, it's likely right."
**Status**: ✅ READY FOR EXECUTION (after user approval)
