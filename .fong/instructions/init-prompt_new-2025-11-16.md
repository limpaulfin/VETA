---
title: "Changelog - init-prompt.json Cleanup (DRY Compliance)"
date: 2025-11-16
version: 1.0.0
author: Fong
purpose: "Ghi nhận quá trình giảm init-prompt.json từ 594 LOC → 71 LOC do vi phạm DRY với init-prompt.md"
keywords: [DRY, SSoT, cleanup, init-prompt, refactoring]
---

## Tổng quan


**Vấn đề:** File `init-prompt.json` (594 LOC) vi phạm nguyên tắc DRY với `/home/fong/Projects/boiler-plate-cursor-project-with-init-prompt/.fong/init-prompt.md` (378 LOC)

**Giải pháp:** Loại bỏ duplicate content, chỉ giữ lại configuration data độc nhất trong JSON

**Kết quả:** 594 LOC → 71 LOC (giảm 88%)


---


## So sánh Before/After


### Before (594 LOC) - Vi phạm DRY

File `init-prompt.json` chứa:
- ✅ Configuration data (api_tokens, assistant_profile)
- ❌ Core Principles (DUPLICATE với init-prompt.md)
- ❌ Development Principles (DUPLICATE)
- ❌ Code Standards (DUPLICATE)
- ❌ Tools & Workflow (DUPLICATE)
- ❌ Memory & Documentation (DUPLICATE)

**Vấn đề:**
- Duplicate 90% nội dung với `init-prompt.md`
- Vi phạm SSoT (Single Source of Truth)
- Khó maintain (phải update 2 nơi)
- Token waste (AI phải đọc duplicate content)


### After (71 LOC) - Tuân thủ DRY

File `init-prompt.json` CHỈ chứa:
1. **Configuration data** (UNIQUE):
   - `api_tokens.asana`: API token cho Asana integration
2. **Assistant profile** (UNIQUE):
   - `name`: "Asi"
   - `response_language`: "Plain Vietnamese"
   - `response_style`: "Very concise and focused"
   - `deep_analysis`: "Think Ultra methodology"
3. **Tools preference** (UNIQUE):
   - `asana_handling`: Workflow và rules cho Asana URLs
4. **Teaching methodology** (UNIQUE):
   - `three_short_habits`: 3 thói quen cốt lõi

**Reference pointer** (quan trọng):
```json
"reference": {
  "principles_and_workflows": "/home/fong/Projects/boiler-plate-cursor-project-with-init-prompt/.fong/init-prompt.md",
  "tools_catalog": ".fong/instructions/fongtools.json"
}
```


---


## Content đã loại bỏ (moved to init-prompt.md)


### 1. Core Principles & Mindset
- Zero Trust - Adversarial Thinking
- Autonomous Automation - No Quit Rule
- Scientific Methodology

→ **Đã có trong** `/home/fong/Projects/boiler-plate-cursor-project-with-init-prompt/.fong/init-prompt.md` (lines 110-136)


### 2. Development Principles
- Execution Strategy (Think Big, Take Baby Steps)
- Prioritization & Counting
- Verification rules

→ **Đã có trong** `/home/fong/Projects/boiler-plate-cursor-project-with-init-prompt/.fong/init-prompt.md` (lines 141-171)


### 3. Code Standards
- KISS, YAGNI, SOLID, DRY, SSoT
- File Standards (120 LOC max)
- Function Standards
- Time Architecture
- Memory Management
- Backup Before Edit

→ **Đã có trong** `/home/fong/Projects/boiler-plate-cursor-project-with-init-prompt/.fong/init-prompt.md` (lines 177-216)


### 4. Calculation & Verification
- Absolute Calculation Rule
- Reading Long Files Strategy

→ **Đã có trong** `/home/fong/Projects/boiler-plate-cursor-project-with-init-prompt/.fong/init-prompt.md` (lines 221-234)


### 5. Tools & Workflow
- MCP Tools priority list
- Modern CLI Rules
- DKM Query Strategy (80-90%)
- Search & Analysis

→ **Đã có trong** `/home/fong/Projects/boiler-plate-cursor-project-with-init-prompt/.fong/init-prompt.md` (lines 240-322)


### 6. Git & Safety
- Commit rules
- Sandbox workflow
- Debug practices

→ **Đã có trong** `/home/fong/Projects/boiler-plate-cursor-project-with-init-prompt/.fong/init-prompt.md` (lines 326-333)


### 7. Memory & Documentation
- Memory Management rules
- Hyperfocus System
- Markdown Documentation standards
- Prompt Processing

→ **Đã có trong** `/home/fong/Projects/boiler-plate-cursor-project-with-init-prompt/.fong/init-prompt.md` (lines 339-365)


---


## Workflow cho AI


### Khi đọc init-prompt.json

**Step 1:** Đọc `init-prompt.json` để lấy:
- Configuration data (api_tokens)
- Assistant profile (name, response_language)
- Tools preference (asana_handling)

**Step 2:** Đọc reference pointer:
```json
"reference": {
  "principles_and_workflows": "/home/fong/Projects/boiler-plate-cursor-project-with-init-prompt/.fong/init-prompt.md"
}
```

**Step 3:** Đọc `/home/fong/Projects/boiler-plate-cursor-project-with-init-prompt/.fong/init-prompt.md` để lấy:
- Core Principles (lines 110-136)
- Development Principles (lines 141-171)
- Code Standards (lines 177-216)
- Tools & Workflow (lines 240-322)
- Memory & Documentation (lines 339-365)


### Lợi ích


**1. DRY Compliance:**
- Mỗi principle chỉ xuất hiện 1 nơi
- Update tại 1 chỗ → reflect everywhere

**2. Token Efficiency:**
- Giảm 88% token consumption cho config file
- AI đọc compact JSON (71 LOC) thay vì bloated version (594 LOC)

**3. Maintainability:**
- Principles trong `.md` (human-readable, dễ edit)
- Configuration trong `.json` (machine-readable, structured)

**4. SSoT (Single Source of Truth):**
- Markdown = source of truth cho principles
- JSON = source of truth cho configuration


---


## Critical Notice trong JSON


File `init-prompt.json` có CRITICAL_NOTICE rõ ràng:

```json
"CRITICAL_NOTICE": "⚠️ This file contains ONLY unique configuration data. All principles, mindsets, and workflows are in `/home/fong/Projects/boiler-plate-cursor-project-with-init-prompt/.fong/init-prompt.md`"
```

**Mục đích:** Ngăn AI hiểu nhầm rằng JSON chứa đầy đủ instructions. AI PHẢI đọc cả `.md` file để có complete context.


---


## Verification Checklist


- [x] Loại bỏ duplicate content từ JSON
- [x] Giữ lại ONLY unique configuration data
- [x] Add reference pointer đến `init-prompt.md`
- [x] Add CRITICAL_NOTICE
- [x] Verify `init-prompt.md` chứa đầy đủ principles
- [x] Test workflow: JSON → read reference → read MD
- [x] Giảm từ 594 LOC → 71 LOC (88%)
- [x] Tuân thủ DRY + SSoT


---


## Tham chiếu


**File locations:**
- Configuration (UNIQUE data): `.fong/instructions/init-prompt.json` (71 LOC)
- Principles & Workflows: `/home/fong/Projects/boiler-plate-cursor-project-with-init-prompt/.fong/init-prompt.md` (378 LOC)
- Tools Catalog: `.fong/instructions/fongtools.json`

**Related commits:**
- `d5a0531` - feat: cleanup init-prompt.json - 88% size reduction (594 → 71 LOC)


---


**Tóm tắt:**

File `init-prompt.json` đã được refactor theo DRY principle. Chỉ giữ unique configuration data, reference pointer đến `init-prompt.md` cho principles. Kết quả: giảm 88% size, dễ maintain, tuân thủ SSoT.
