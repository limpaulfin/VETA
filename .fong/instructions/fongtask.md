# Fong Task Management System - General Guide

**Version:** 4.1 (General Instruction + Pre-Task Analysis)
**Date Created:** 2025-08-18
**Date Updated:** 2025-10-31
**Purpose:** General instruction for task breakdown and management using proven methodologies
**Integration:** Maps to `fongasana-deutschfuns.md` for Asana operations

---

## 📖 Table of Contents

1. [Core Concepts](#-core-concepts)
2. [Pre-Task Analysis (MANDATORY)](#-pre-task-analysis-mandatory)
3. [Task Breakdown Methodology](#-task-breakdown-methodology)
4. [Work Breakdown Structure (WBS)](#-work-breakdown-structure-wbs)
5. [Task Execution Protocol](#-task-execution-protocol---7-step-workflow)
6. [Git Branching Workflow](#-git-branching-workflow-for-microtasks)
7. [Learning with DKM Query RAG](#-learning-with-dkm-query-rag)
8. [Task Management Tools](#-task-management-tools)
9. [Best Practices](#-best-practices)

---

## 🎯 Core Concepts

### What is Task Breakdown?

**Task breakdown** is the process of decomposing a large, complex task into smaller, manageable units called **microtasks**.

**Key Principles (from Software Engineering best practices):**

1. **100% Rule** - The WBS must include 100% of the work defined by the project scope
2. **Hierarchical Decomposition** - Break down work in a tree structure (phases → activities → tasks)
3. **Single Deliverable** - Each task must have one clear, identifiable deliverable
4. **Measurable Completion** - Each task must have clear criteria for "done"
5. **Optimal Granularity** - Tasks should not be too small (< 1 hour) or too large (> several weeks)

**Source:** From DKM Knowledge Base - Software Engineering: A Practitioner's Approach (Pressman & Maxim), BABOK v3, Work Breakdown Structures (Norman, Brotherton, Fried)

---

## 🔍 Pre-Task Analysis (MANDATORY)

**⚠️ CRITICAL: ALWAYS perform this analysis BEFORE breaking down any task.**

**Philosophy:** "Measure twice, cut once" - Understand the problem deeply before planning the solution.

---

### Phase 1: TRACE - Investigate & Gather Information

**Purpose:** Understand the current state, relationships, and dependencies.

**Step 1: Database Analysis**

Use MCP or standalone tools to query and understand data:

```typescript
// MCP Database Query (PRIORITY)
mcp__de-MCP__wp_db_query({
  sql: "SELECT * FROM wp_posts WHERE post_type = 'course' LIMIT 10"
})

// Fallback: Standalone tool
/home/fong/Projects/de/public/.fong/tools/dbqueryx.sh "SELECT ..."
```

**What to check:**
- Current data structure
- Existing records and their states
- Foreign key relationships
- Data integrity issues
- Edge cases and anomalies

**Example:**
```typescript
// Check commission records
mcp__de-MCP__wp_db_query({
  sql: "SELECT user_id, commission_tier, total_commission
        FROM wp_affiliate_commissions
        WHERE created_at >= '2025-01-01'
        ORDER BY created_at DESC LIMIT 20"
})
```

---

**Step 2: Code Analysis**

Use MCP file readers to understand existing code:

```typescript
// PHP File Analysis (PRIORITY)
mcp__de-MCP__php_file_read({
  file_path: "/absolute/path/to/file.php",
  project_path: "/home/fong/Projects/de/public"
})

// JavaScript File Analysis
mcp__de-MCP__js_file_read({
  file_path: "/absolute/path/to/file.js",
  project_path: "/home/fong/Projects/de/public"
})

// Fallback: Standalone tools
/home/fong/Projects/de/public/.fong/tools/fong-php-reader.sh /path/to/file.php
/home/fong/Projects/de/public/.fong/tools/fong-js-reader.sh /path/to/file.js
```

**What to analyze:**
- Function dependencies (callers/callees)
- Class relationships and inheritance
- Hook usage (WordPress actions/filters)
- Data flow and transformations
- Error handling patterns
- Security checks (nonces, capabilities)

**Example:**
```typescript
// Analyze commission calculator
mcp__de-MCP__php_file_read({
  file_path: "/home/fong/Projects/de/public/wp-content/plugins/fong_de_lms/modules/affiliator/src/services/commission-calculator.php",
  project_path: "/home/fong/Projects/de/public"
})
// Returns: Functions, classes, dependencies, WordPress hooks
```

---

**Step 3: File Discovery**

Use `smart-search-fz-rg-bm25` to find related files (fallback: `rg`/ripgrep):

```bash
# Primary hybrid search with ranked context
smart-search-fz-rg-bm25 "function calculate_commission" wp-content/plugins/ --show-content
smart-search-fz-rg-bm25 "affiliate hook" wp-content/plugins/ --top-k 5

# Fallback ripgrep commands
rg "function calculate_commission" -g "*.php" wp-content/plugins/
rg "do_action\('affiliate_" -g "*.php" wp-content/plugins/
rg "new CommissionCalculator" -g "*.php" wp-content/
rg "define\('AFFILIATE_" -g "*.php" wp-content/plugins/
```

> **Setup reminder:** Kiểm tra `.fong/instructions/smartsearch.md` trong project để đảm bảo alias `smart-search-fz-rg-bm25` đã được cấu hình đúng.

**What to discover:**
- All files using the feature
- Hook registration points
- Configuration files
- Test files
- Documentation

---

**Step 4: Relationship Mapping**

**Create a mental (or written) map:**
- Database → Code relationships
- Function call chains
- Event flow (hooks, callbacks)
- User interaction flow
- Data transformation pipeline

**Example Map (Commission Calculation):**
```
User action (purchase)
  ↓
Hook: woocommerce_order_status_completed
  ↓
Function: record_affiliate_commission()
  ↓
Class: CommissionCalculator
  ↓
Database: wp_affiliate_commissions (INSERT)
  ↓
Hook: affiliate_commission_recorded
  ↓
Email notification service
```

---

### Phase 2: RESEARCH - Find Best Practices

**Purpose:** Learn proven solutions before implementing your own.

**Step 1: Query for Task Breakdown Strategies**

**Use DKM QueryRAG to find efficient breakdown methods:**

```typescript
// Research how to break down THIS specific problem
mcp__dkm-knowledgebase__queryRAG({
  question: "commission calculation system architecture breakdown",
  top_k: 5
})

// Learn estimation techniques for this type of task
mcp__dkm-knowledgebase__queryRAG({
  question: "financial calculation feature estimation dependencies",
  top_k: 5
})

// Understand testing strategies
mcp__dkm-knowledgebase__queryRAG({
  question: "unit testing financial calculations money precision",
  top_k: 5
})
```

**What to research:**
- How have others broken down similar problems?
- What are common pitfalls?
- What's the optimal granularity for this type of task?
- What are the critical dependencies?

---

**Step 2: Query for Solution Patterns**

**Use Perplexity AI for latest practices:**

```bash
# Research modern approaches
curl -X POST "https://api.perplexity.ai/chat/completions" \
  -H "Authorization: Bearer $PERPLEXITY_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "sonar",
    "messages": [
      {"role": "system", "content": "You are an expert software architect."},
      {"role": "user", "content": "Best practices for implementing tier-based commission system in PHP 2025"}
    ],
    "temperature": 0.2
  }'
```

**What to find:**
- Modern solution patterns (2024-2025)
- Security best practices
- Performance optimization techniques
- Testing approaches
- Common anti-patterns to avoid

---

**Step 3: Query for Implementation Best Practices**

**Use QueryRAG for foundational knowledge:**

```typescript
// Design patterns
mcp__dkm-knowledgebase__queryRAG({
  question: "strategy pattern factory pattern commission calculation",
  top_k: 5
})

// Clean code principles
mcp__dkm-knowledgebase__queryRAG({
  question: "single responsibility principle financial calculation",
  top_k: 5
})

// Testing patterns
mcp__dkm-knowledgebase__queryRAG({
  question: "test driven development TDD money calculations",
  top_k: 5
})
```

**What to learn:**
- SOLID principles for this domain
- Design patterns applicable to the problem
- Code organization strategies
- Testing methodologies

---

### Phase 3: SYNTHESIZE - Combine Findings

**After TRACE + RESEARCH, answer these questions:**

1. **What is the REAL problem?**
   - Not what was requested, but what needs solving
   - Root cause, not symptoms

2. **What are the constraints?**
   - Technical (database, API, performance)
   - Business (deadlines, budget)
   - Resource (team skills, availability)

3. **What are the dependencies?**
   - Must finish before starting
   - Can run in parallel
   - External dependencies (APIs, services)

4. **What are the risks?**
   - Technical risks (complexity, unknowns)
   - Integration risks (breaking existing features)
   - Data risks (migration, consistency)

5. **How will we verify success?**
   - Unit tests (automated verification)
   - Integration tests (end-to-end flows)
   - Manual checks (edge cases)
   - Acceptance criteria (stakeholder sign-off)

---

### ⚡ Critical Rules for Pre-Task Analysis

**1. ALWAYS Verify Results**

Every task MUST have **verifiable outcomes**:

✅ **Good Examples:**
- "Commission calculator returns correct values" → Unit test with known inputs/outputs
- "Dashboard displays accurate data" → Query DB and compare with UI
- "Email sent on commission recorded" → Check email logs or mock email service

❌ **Bad Examples:**
- "Code looks good" → NOT verifiable
- "Should work" → NOT measurable
- "Tested manually once" → NOT repeatable

**2. Make it TESTABLE**

**Every deliverable needs:**
- **Unit tests** - For pure functions, calculations, business logic
- **Integration tests** - For database queries, API calls, hook interactions
- **Manual checks** - For UI, UX, edge cases

**Example (Commission Calculator):**
```php
// TESTABLE: Pure function with clear input/output
public function calculate_commission(float $order_amount, int $tier): float {
    return match($tier) {
        1 => $order_amount * 0.05,
        2 => $order_amount * 0.07,
        3 => $order_amount * 0.10,
        default => 0.0
    };
}

// Unit test
assert(calculate_commission(100, 1) === 5.0);
assert(calculate_commission(100, 2) === 7.0);
```

**3. Guidelines, Not Rules**

**The methodology is FLEXIBLE:**
- Cách làm chỉ là **gợi ý**, không cứng nhắc
- Làm **thông minh** tùy tình huống
- Skip steps if already understood (but document why)
- Add steps if more investigation needed

**When to skip TRACE:**
- You've worked on this code recently
- It's a new feature (nothing to trace)
- The change is trivial (typo fix, CSS tweak)

**When to do MORE TRACE:**
- Legacy code with no documentation
- Bug fix with unknown root cause
- Performance issue requiring profiling
- Integration with unfamiliar systems

**4. Document Your Findings**

**Save investigation results to `.fong/.memory/`:**

```markdown
# 2025-10-30-investigation-commission-system.md

## Database State
- wp_affiliate_commissions: 1,245 records
- Commission tiers: 5%, 7%, 10%, 15%
- Issue: Tier 4 (15%) has no records

## Code Analysis
- Calculator: wp-content/plugins/.../commission-calculator.php
- Dependencies: WooCommerce order hooks
- Missing: Input validation for negative amounts

## Research Findings
- DKM Query: Strategy pattern recommended for tier logic
- Perplexity: Use Money library for precision (bcmath)

## Next Steps
- Add tier validation
- Implement Money pattern
- Add unit tests for edge cases
```

---

### 🎯 Pre-Task Analysis Checklist

**Before breaking down ANY task, verify:**

- [ ] **TRACE: Database** - Queried and understood data state
- [ ] **TRACE: Code** - Read and analyzed related files (PHP/JS/CSS)
- [ ] **TRACE: Files** - Found all related files with `smart-search-fz-rg-bm25` (fallback: `rg`)
- [ ] **TRACE: Relationships** - Mapped dependencies and flow
- [ ] **RESEARCH: Breakdown** - Queried DKM for task decomposition strategies
- [ ] **RESEARCH: Solution** - Queried Perplexity for latest practices
- [ ] **RESEARCH: Best Practices** - Queried DKM for implementation patterns
- [ ] **SYNTHESIZE: Problem** - Defined real problem, not symptoms
- [ ] **SYNTHESIZE: Constraints** - Identified all constraints and dependencies
- [ ] **SYNTHESIZE: Verification** - Defined how to verify each deliverable
- [ ] **DOCUMENT: Findings** - Saved investigation to `.fong/.memory/`

**Only proceed to Task Breakdown AFTER completing this checklist.**

---

## 🔧 Task Breakdown Methodology

### Step 1: Identify the Deliverable

**Question to ask:**
- What is the final deliverable of this task?
- Who is the customer/stakeholder?
- What does "done" look like?

**Example:**
- Task: "Implement user authentication"
- Deliverable: Working login/logout system with password reset

---

### Step 2: Decompose into Phases

Break the task into **logical phases** (major stages).

**Common Software Project Phases:**
1. **Planning** - Define scope, requirements, approach
2. **Design** - Architecture, data models, interfaces
3. **Implementation** - Coding, testing
4. **Verification** - QA, user acceptance testing
5. **Deployment** - Release, documentation

**Example (User Authentication):**
- Phase 1: Requirements & Design
- Phase 2: Backend Implementation
- Phase 3: Frontend Implementation
- Phase 4: Testing & Integration
- Phase 5: Deployment

---

### Step 3: Break Phases into Activities

Each phase contains **activities** (summary tasks).

**Characteristics of an Activity:**
- Can be done by one person or a well-defined team
- Takes more than a few hours but less than a few weeks
- Has dependencies on other activities

**Example (Phase 2: Backend Implementation):**
- Activity 2.1: Database schema design
- Activity 2.2: Authentication API endpoints
- Activity 2.3: Session management
- Activity 2.4: Password reset workflow

---

### Step 4: Break Activities into Microtasks

Each activity contains **microtasks** (primitive tasks).

**Characteristics of a Microtask:**
- Can be done by one person
- Takes 1-8 hours (not < 1 hour, not > 1 day)
- Has a single, clear deliverable
- Can be tracked and measured

**Example (Activity 2.2: Authentication API endpoints):**
- Task 2.2.1: Design API schema (login, logout, refresh token)
- Task 2.2.2: Implement /login endpoint with JWT generation
- Task 2.2.3: Implement /logout endpoint with session cleanup
- Task 2.2.4: Implement /refresh-token endpoint
- Task 2.2.5: Add unit tests for all endpoints

---

### Step 5: Define Dependencies

Identify which tasks must be completed before others can start.

**Dependency Types:**
- **Finish-to-Start (FS)** - Task B starts when Task A finishes (most common)
- **Start-to-Start (SS)** - Task B starts when Task A starts (parallel work)
- **Finish-to-Finish (FF)** - Task B finishes when Task A finishes

**Example:**
- Task 2.2.1 (Design API) → Must finish before Task 2.2.2 (Implement /login)
- Task 2.2.2, 2.2.3, 2.2.4 → Can run in parallel (SS)
- Task 2.2.5 (Tests) → Must wait for 2.2.2, 2.2.3, 2.2.4 to finish (FS)

---

### Step 6: Estimate Effort & Duration

For each microtask, estimate:
- **Effort** - Total person-hours needed
- **Duration** - Calendar time (considering availability, interruptions)
- **Resources** - Skills/people required

**Estimation Techniques:**
1. **Historical Data** - Look at similar past tasks
2. **Expert Judgment** - Ask experienced team members
3. **Three-Point Estimation** - Best case, worst case, most likely
4. **Planning Poker** - Team-based estimation (Agile)

**Example:**
- Task 2.2.2 (Implement /login endpoint)
  - Effort: 4-6 hours
  - Duration: 1 day (with meetings, interruptions)
  - Resources: Backend developer with JWT experience

---

## 📊 Work Breakdown Structure (WBS)

### What is WBS?

**WBS** is a hierarchical decomposition of the project into phases, activities, and tasks.

**Structure:**
```
Project (Level 0)
├── Phase 1 (Level 1)
│   ├── Activity 1.1 (Level 2)
│   │   ├── Task 1.1.1 (Level 3)
│   │   ├── Task 1.1.2 (Level 3)
│   │   └── Task 1.1.3 (Level 3)
│   └── Activity 1.2 (Level 2)
│       ├── Task 1.2.1 (Level 3)
│       └── Task 1.2.2 (Level 3)
└── Phase 2 (Level 1)
    └── Activity 2.1 (Level 2)
        ├── Task 2.1.1 (Level 3)
        └── Task 2.1.2 (Level 3)
```

### WBS Numbering Scheme

Use hierarchical numbering to show relationships:

```
1.0 Phase 1: Requirements & Design
  1.1 Activity: Gather requirements
    1.1.1 Task: Interview stakeholders
    1.1.2 Task: Document functional requirements
    1.1.3 Task: Create use case diagrams
  1.2 Activity: Design database schema
    1.2.1 Task: Identify entities and relationships
    1.2.2 Task: Create ER diagram
    1.2.3 Task: Write SQL migration scripts

2.0 Phase 2: Backend Implementation
  2.1 Activity: Setup project structure
    2.1.1 Task: Initialize Git repository
    2.1.2 Task: Setup development environment
  2.2 Activity: Implement authentication API
    2.2.1 Task: Design API schema
    2.2.2 Task: Implement /login endpoint
    2.2.3 Task: Implement /logout endpoint
```

### WBS in Task Management Tools

**Generic Hierarchy Mapping:**
- **Section/Epic** = Phase (Level 1)
- **Task/Story** = Activity (Level 2)
- **Subtask** = Microtask (Level 3)

**Example Structure:**
```
Section: "1.0 Requirements & Design"
  ├─ Task: "1.1 Gather requirements"
  │   ├─ Subtask: "1.1.1 Interview stakeholders"
  │   ├─ Subtask: "1.1.2 Document functional requirements"
  │   └─ Subtask: "1.1.3 Create use case diagrams"
  └─ Task: "1.2 Design database schema"
      ├─ Subtask: "1.2.1 Identify entities"
      └─ Subtask: "1.2.2 Create ER diagram"
```

---

## 🎯 Task Execution Protocol - 7-Step Workflow

**Purpose:** Standard workflow for executing each microtask with proper dependency checking, on-the-fly updates, and verification.

**When to Use:** Every time you work on a microtask (wbs-XX-*.md file).

---

### Step 1: Navigate to Task Context Folder

**Action:** Always start by navigating to the task folder containing all WBS files.

```bash
# Navigate to task context folder
cd [path-to-task-folder]

# Example:
cd /home/fong/Projects/de/public/.fong/docs/0-fong-todo/04-time-architecture-migration/

# Verify you're in the right place
pwd
ls -la wbs-*.md
```

**Why:** All task files, logs, and progress tracking are in this folder. Working from the correct context prevents confusion.

---

### Step 2: Read Daily Log & Identify Next Task

**Action:** Read the master file to understand current progress and identify the next pending task.

```bash
# Read the master file's Daily Progress Log
cat doing-wbs-[task-name].md | grep -A 20 "Daily Progress Log"

# Find current focus
cat doing-wbs-[task-name].md | grep "Current Focus"

# List all microtask files to see what's done vs pending
ls -la wbs-*.md done-wbs-*.md
```

**Identify:**
- What has been completed (look for `done-wbs-*.md` files)
- What is the next pending task (first `wbs-*.md` file without `done-` prefix)
- What is currently blocked or in progress

---

### Step 3: Check Dependencies - Verify Prerequisites

**Action:** Before starting any task, verify that all prerequisite tasks are complete.

```bash
# Read the target microtask file
cat wbs-02-batch-1.1.2-core-services.md | grep -A 3 "Dependencies:"

# Example output:
# **Depends On:**
# - Task 1.1.1: JWT Security migration - Status: [⏳/✅]

# Verify dependency status - Check if done-* file exists
ls -la done-wbs-01-*.md
# If file exists → Dependency complete ✅
# If file missing → Dependency NOT complete ❌ → STOP

# Read dependency file to verify it's fully done
cat done-wbs-01-batch-1.1.1-security-jwt.md | grep "Status:"
# Must show: Status: ✅ Done
```

**Critical Rule:** NEVER start a task if its dependencies are not complete. Update the task status to "❌ Blocked" if dependencies are incomplete.

---

### Step 4: Execute Task & Update On-The-Fly

**Action:** Work on the task AND update the task file continuously during execution (NOT after completion).

**Update Pattern:**

```bash
# At START: Change status from Pending to In Progress
# Edit wbs-XX-*.md file:
# Change: **Status:** ⏳ Pending
# To:     **Status:** 🚧 In Progress

# As you complete each step, check it off:
# Change: - [ ] Backup files
# To:     - [x] Backup files ✅ 2025-10-30 14:00

# Add progress notes DURING work:
## Progress Notes
- 14:00 - Started migration
- 14:15 - Backed up 3 files (jwt-handler.php, jwt-validator.php, jwt-config.php)
- 14:30 - Read jwt-handler.php with MCP php_file_read
- 14:45 - Found 2 violations: current_time() line 45, time() line 67
- 15:00 - Replaced with de_time_mysql() and de_time()
- 15:15 - Running tests...
```

**Why On-The-Fly?**
- Creates accurate audit trail
- Easy to resume if interrupted
- Documents decision-making process
- Helps others understand your work

---

### Step 5: Test Forward & Backward - Record Results

**Action:** After implementation, test BOTH new functionality AND existing functionality (backward compatibility).

**Forward Testing** (New functionality works):
```bash
# Test the new feature
# Example: Test de_time() replacement
php -r "require 'wp-load.php'; echo de_time();"

# Record in task file:
## Test Results - Forward
- ✅ de_time() returns correct timestamp
- ✅ de_time_mysql() returns correct format
- ✅ All 2 violations fixed
```

**Backward Testing** (Old functionality still works):
```bash
# Test that existing features didn't break
# Example: Run unit tests
phpunit --filter TestJWTHandler

# Record in task file:
## Test Results - Backward
- ✅ JWT token generation still works
- ✅ JWT validation still works
- ✅ Existing API endpoints return correct responses
```

**Critical:** BOTH forward and backward tests must pass. If backward tests fail, you've introduced a regression.

---

### Step 6: Update Status & Finalize Documentation

**Action:** Mark the task as Done and add a completion summary.

```bash
# Edit the task file:
# Change: **Status:** 🚧 In Progress
# To:     **Status:** ✅ Done

# Add completion summary:
## ✅ Completion Summary
- **Completed:** 2025-10-30 15:30
- **Time Spent:** 1h 30min (Estimated: 2h)
- **Files Modified:** 2 files (jwt-handler.php, jwt-validator.php)
- **Violations Fixed:** 2 violations
- **Tests:** All tests passing (forward + backward)
- **Blockers:** None
- **Notes:** Migration completed successfully. All time() and current_time() replaced with de_time() and de_time_mysql().
```

---

### Step 7: Rename to Done & Update Master

**Action:** Rename the completed task file and update the master file's progress log.

```bash
# Rename microtask file to indicate completion
mv wbs-01-batch-1.1.1-security-jwt.md done-wbs-01-batch-1.1.1-security-jwt.md

# Update master file Daily Progress Log
# Edit doing-wbs-[task-name].md:

### 2025-10-30 (Day 1 - Phase 1 Start)

**Completed:**
- ✅ Batch 1.1.1: JWT Security migration (2 files, 1h 30min)
  - jwt-handler.php - Replaced time() on line 67
  - jwt-validator.php - Replaced current_time() on line 45
  - Tests: All passing (forward + backward)

**Next:**
- 🚀 Batch 1.1.2: Core Services migration (3 files)

**Blockers:** None

# Update progress percentage in master file
# Change: **Overall:** 0% complete
# To:     **Overall:** 3% complete (1/30 batches)
```

---

### Workflow Checklist

After completing each microtask, verify you followed all steps:

- [ ] **Step 1:** Navigated to correct task folder
- [ ] **Step 2:** Read daily log and identified next task
- [ ] **Step 3:** Verified all dependencies are complete
- [ ] **Step 4:** Updated task file on-the-fly during work
- [ ] **Step 5:** Tested forward (new) and backward (existing) functionality
- [ ] **Step 6:** Marked status as Done with completion summary
- [ ] **Step 7:** Renamed to `done-wbs-*.md` and updated master file

---

## 🔀 Git Branching Workflow for Microtasks

**Purpose:** Isolate each microtask in a sandbox branch for safe experimentation, easy rollback, and clean git history.

**Philosophy:** One microtask = One sandbox branch

**Pattern:** `sandbox-wbs-XX-*` (matches task file name)

---

### Why Sandbox Branching?

1. ✅ **Safe Experimentation** - Easy to discard if approach doesn't work
2. ✅ **Clean History** - Squash commits when merging if needed
3. ✅ **Easy Rollback** - Just delete sandbox branch if task fails
4. ✅ **Parallel Work** - Multiple tasks can have separate sandboxes
5. ✅ **Clear Audit Trail** - Branch name matches task file name
6. ✅ **No Contamination** - Working branch stays clean until merge

---

### Workflow Overview

```
Working Branch (e.g., main, develop, feature/xyz)
    ├── Checkpoint commit (PREPARE)
    ├── Create sandbox-wbs-01-*
    │   ├── Work on task
    │   ├── Commit progress (PROGRESS)
    │   └── Complete task (COMPLETE)
    └── Merge sandbox back → Cleanup
```

---

### Step 1: Checkpoint Before Starting

**Action:** Save current state on working branch before creating sandbox.

```bash
# Always checkpoint first
git add .
git commit -m "PREPARE: Checkpoint before Task [X.Y] - [Task Name]"
git push

# Record working branch for later
WORK_BRANCH=$(git branch --show-current)  # e.g., main, develop
echo "Working branch: $WORK_BRANCH"
```

---

### Step 2: Create Sandbox Branch

**Action:** Create task-specific sandbox branch with naming convention.

```bash
# Pattern: sandbox-{wbs-file-name-without-.md}
# Example for wbs-01-batch-1.1.1-security-jwt.md:
TASK_FILE="wbs-01-batch-1.1.1-security-jwt"
git checkout -b sandbox-$TASK_FILE

# Push to remote
git push -u origin sandbox-$TASK_FILE
```

**Naming Convention:**
- **Prefix:** `sandbox-`
- **Base Name:** Match WBS file name (without `.md`)
- **Examples:**
  - `wbs-01-batch-1.1.1-security-jwt.md` → `sandbox-wbs-01-batch-1.1.1-security-jwt`
  - `wbs-02-batch-1.1.2-core-services.md` → `sandbox-wbs-02-batch-1.1.2-core-services`
  - `wbs-06-batch-1.3.1-vietqr-fallback.md` → `sandbox-wbs-06-batch-1.3.1-vietqr-fallback`

---

### Step 3: Work and Commit Frequently (During)

**Action:** Commit every 30-60 minutes to backup progress.

```bash
# Regular progress commits
git add .
git commit -m "PROGRESS: [Brief description of current state]"
git push

# Example commit messages:
# "PROGRESS: Backed up 3 files and analyzed dependencies"
# "PROGRESS: Replaced 2 violations with de_time()"
# "PROGRESS: Forward tests passing, running backward tests"
# "PROGRESS: All tests passing, updating documentation"
```

---

### Step 4: Complete and Merge Back (After)

**Action:** Finalize task, merge to working branch, and cleanup sandbox.

```bash
# 1. Final commit on sandbox
git add .
git commit -m "COMPLETE: Task [X.Y] - [Task Name]

- [List of changes]
- [Test results]
- All acceptance criteria met

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
git push

# 2. Switch back to working branch
git checkout $WORK_BRANCH  # e.g., main
git pull origin $WORK_BRANCH

# 3. Merge sandbox branch
git merge sandbox-wbs-01-batch-1.1.1-security-jwt

# 4. Push merged changes
git push origin $WORK_BRANCH

# 5. Optional: Cleanup sandbox branch
git branch -d sandbox-wbs-01-batch-1.1.1-security-jwt
git push origin --delete sandbox-wbs-01-batch-1.1.1-security-jwt
```

---

### Git Branching Checklist

For EACH microtask:

- [ ] **Before:** Checkpoint commit on working branch (`PREPARE: Checkpoint before Task X.Y`)
- [ ] **Create:** Sandbox branch with pattern `sandbox-wbs-XX-*`
- [ ] **Record:** Save working branch name: `WORK_BRANCH=$(git branch --show-current)`
- [ ] **During:** Commit progress every 30-60 minutes (`PROGRESS: ...`)
- [ ] **Complete:** Final commit with detailed message (`COMPLETE: Task X.Y - ...`)
- [ ] **Merge:** Merge sandbox back to working branch
- [ ] **Push:** Push merged changes to remote
- [ ] **Cleanup:** Delete sandbox branch (optional, keeps history clean)

---

## 📚 Learning with DKM Query RAG

### What is DKM Query RAG?

**DKM (Deutschfuns Knowledge Management)** provides access to **190+ programming books** through RAG (Retrieval-Augmented Generation) to learn best practices from authoritative sources.

**Available Tools:**
1. **queryRAG** (MCP) - Query 151 books from default collection
2. **queryNewRAG** (MCP) - Multi-query with hash-based filtering (190 books)
3. **Standalone Scripts** - Fallback when MCP unavailable

---

### When to Query DKM?

**Query BEFORE-DURING-AFTER your work:**

**BEFORE (Planning):**
- Learn methodology before starting
- Research best practices
- Understand patterns and anti-patterns

**DURING (Implementation):**
- Validate your approach
- Find solutions to problems
- Cross-check decisions

**AFTER (Review):**
- Review code quality
- Compare against standards
- Learn from mistakes

---

### How to Query DKM - Method 1: queryRAG (Simple)

**Tool:** `mcp__dkm-knowledgebase__queryRAG`

**Usage:**
```typescript
// Query default collection (151 books)
mcp__dkm-knowledgebase__queryRAG({
  question: "task breakdown microtask methodology",
  top_k: 5  // Number of chunks to retrieve (3-8 recommended)
})
```

**Query Patterns:**
- Use 2-4 technical keywords
- Be specific (e.g., "WBS hierarchical decomposition" not just "WBS")
- English only

**Examples:**
```typescript
// Learn about WBS
mcp__dkm-knowledgebase__queryRAG({
  question: "work breakdown structure hierarchical levels",
  top_k: 5
})

// Learn about estimation
mcp__dkm-knowledgebase__queryRAG({
  question: "project estimation techniques story points",
  top_k: 5
})

// Learn about dependencies
mcp__dkm-knowledgebase__queryRAG({
  question: "task dependencies critical path scheduling",
  top_k: 5
})
```

---

### How to Query DKM - Method 2: queryNewRAG (Advanced)

**Tool:** `mcp__dkm-knowledgebase__queryNewRAG`

**3-Step Workflow:**

**Step 1: List all available PDFs**
```typescript
mcp__dkm-knowledgebase__listNewRAGSources()
// Returns: 190 books with hash IDs
```

**Step 2: Select 5-9 relevant books**
```typescript
// Review list and identify books relevant to your topic
// Copy FULL 32-character hash IDs
// Example hashes:
// - Harold Kerzner PM: bcece50c97b83329954a863ca01ac13d
// - BABOK v3: 175b727ddf3fb572626b42826e0215d1
// - PMBOK 2021: 2ce3415de8c0370f156a201254b222fe
```

**Step 3: Query with specific hashes**
```typescript
mcp__dkm-knowledgebase__queryNewRAG({
  queries: [
    "WBS hierarchical decomposition phases",
    "task estimation dependencies critical path"
  ],
  source_hashes: "bcece50c97b83329954a863ca01ac13d,175b727ddf3fb572626b42826e0215d1"
})
```

**⚠️ Critical Rules:**
- Maximum 9 sources per query (cognitive load limit)
- Maximum 3 queries per request
- Use FULL 32-char hash (not shortened)
- ALWAYS list sources first (don't skip this step)

---

### Standalone Script (Fallback)

**When MCP unavailable:**

```bash
# Simple query (default collection)
/home/fong/Projects/mini-rag/run.sh "task breakdown methodology"

# Specify collection
/home/fong/Projects/mini-rag/run.sh "WBS hierarchical" /path/to/collection

# NewRAG Multi-Query (advanced)
cd /home/fong/Projects/mini-rag/multi-query
./run-multiquery.sh --list-pdfs  # Step 1: List sources
./run-multiquery.sh --json '{"queries":["WBS","estimation"]}' --source-hashes "hash1,hash2"
```

---

### Recommended Books for Task Management

**Top 5 Core Books:**

1. **Harold Kerzner - Project Management (Wiley 2022)** ⭐⭐⭐
   - Hash: `bcece50c97b83329954a863ca01ac13d`
   - Best for: WBS methodology, scheduling, detailed planning

2. **BABOK v3 (IIBA 2015)**
   - Hash: `175b727ddf3fb572626b42826e0215d1`
   - Best for: WBS, requirements decomposition, stakeholder management

3. **PMBOK Guide 2021**
   - Hash: `2ce3415de8c0370f156a201254b222fe`
   - Best for: PMI standards, project processes

4. **Software Engineering: A Practitioner's Approach (Pressman & Maxim)**
   - Best for: SDLC, task decomposition, scheduling

5. **Work Breakdown Structures (Norman, Brotherton, Fried)**
   - Best for: WBS best practices, 100% Rule, deliverable-oriented decomposition

---

## 🛠️ Task Management Tools

### Folder Structure (Generic)

**Location:** `.fong/docs/0-fong-todo/` (or project-specific equivalent)

**Purpose:** SECONDARY backup (primary = task management tool like Asana/Jira)

**Naming Convention:**
- **Date prefix**: `YYYY-MM-DD-task-name/` (for dated tasks)
- **Numbered prefix**: `01-task-name/` (for ordered sequences)
- **Important tasks**: Use lower numbers (00, 01, 02...)

**Example:**
```
.fong/docs/0-fong-todo/
├── 2025-10-30-implement-user-auth/
├── 2025-10-31-database-migration/
└── project-alpha/
    ├── 01-requirements/
    ├── 02-design/
    └── 03-implementation/
```

---

### Task File Format

**File naming:** `YYYY-MM-DD-{task-name}.md` or `wbs-XX-{task-name}.md`

**Template:**
```markdown
# Task: [Task Title]

**Priority:** High/Medium/Low
**Estimated Time:** X hours/days
**Deadline:** YYYY-MM-DD
**Assigned To:** [Name]
**WBS Code:** 1.2.3 (if applicable)

## Context
Brief description of context

## Requirements
- [ ] Requirement 1
- [ ] Requirement 2
- [ ] Requirement 3

## Acceptance Criteria
- [ ] Criteria 1
- [ ] Criteria 2
- [ ] Criteria 3

## Dependencies
- Depends on: Task X.Y.Z
- Blocks: Task A.B.C

## Notes
Additional notes, blockers, risks

## Progress Log
- **Started:** YYYY-MM-DD HH:MM
- **Last Update:** YYYY-MM-DD HH:MM
- **Completed:** YYYY-MM-DD HH:MM (when done)

## Links/References
- [Issue Tracker](link)
- [Related PR](link)
- [Documentation](link)
```

---

### Task Folder Structure (Per Task)

**For complex tasks, create a dedicated folder:**

```
task-folder/
├── plan.md                  # Initial planning and scope
├── doing.md                 # Current progress and notes
├── manifest.json            # Task metadata (ID, status, links)
├── wbs-00-index.md          # WBS index with all microtasks
├── wbs-01-phase1-task1.md   # Individual microtasks
├── wbs-02-phase1-task2.md
├── done-wbs-01-*.md         # Completed microtasks
└── technical-context.json   # Technical details (optional)
```

---

## ✅ Best Practices

### 1. Always Start with "Why"

**Before breaking down any task, understand:**
- What is the business value?
- Who is the stakeholder?
- What problem are we solving?

---

### 2. Use SMART Criteria

Each microtask should be **SMART**:
- **S**pecific - Clear, well-defined
- **M**easurable - Can track progress
- **A**chievable - Realistic given resources
- **R**elevant - Contributes to project goal
- **T**ime-bound - Has a deadline

---

### 3. Apply the 100% Rule

**The WBS must include 100% of the work defined by the project scope.**

**Verification:**
- Can you reach every deliverable by tracing down the WBS?
- Are there any "hidden" tasks not represented?
- Does the sum of child tasks = parent task scope?

---

### 4. One Deliverable Per Task

**Each task should produce exactly ONE deliverable.**

**Good Examples:**
- ✅ "Write API schema document"
- ✅ "Implement /login endpoint"
- ✅ "Create ER diagram"

**Bad Examples:**
- ❌ "Design and implement authentication" (two deliverables)
- ❌ "Fix bugs and add features" (multiple items)

---

### 5. Optimal Task Granularity

**Task Duration Guidelines:**
- **Too small**: < 1 hour (creates management overhead)
- **Too large**: > 1 week (hard to track progress)
- **Optimal**: 2-8 hours (microtask), 1-5 days (activity)

**Rule of thumb:**
- Microtasks: Can be completed in 1 focused work session
- Activities: Can be completed in 1 sprint (1-2 weeks)
- Phases: Can be completed in 1 milestone (1-2 months)

---

### 6. Define Dependencies Explicitly

**Always identify task dependencies:**
- What must finish before this task starts?
- What can run in parallel?
- What is the critical path?

**Use task management tool dependencies:**
- Mark blockers (Task A blocks Task B)
- Mark dependencies (Task B depends on Task A)
- Visualize with Timeline/Gantt view

---

### 7. Estimate Realistically

**Avoid common estimation mistakes:**
- ❌ Best-case only (ignoring risks)
- ❌ Forgetting interruptions (meetings, emails)
- ❌ Not accounting for learning curve

**Better approach:**
- Use three-point estimation (best, worst, most likely)
- Add buffer for unknowns (10-20%)
- Review past similar tasks for reference
- Consult with team members

---

### 8. Query DKM Frequently

**Follow "80-90% query" philosophy:**
- Query BEFORE work (plan approach)
- Query DURING work (validate decisions)
- Query AFTER work (review quality)
- Use short, focused queries (2-4 keywords)
- Query multiple times from different angles

**Examples:**
```typescript
// Before: Learn methodology
queryRAG("WBS decomposition methodology")

// During: Validate approach
queryRAG("task estimation techniques comparison")

// After: Review quality
queryRAG("code review checklist best practices")
```

---

### 9. DRY Principle (Don't Repeat Yourself)

**Before creating a task:**
- Search existing tasks first
- Check all projects/workspaces
- Avoid duplicate work
- Reference existing work when possible

---

### 10. Update On-The-Fly

**Maintain alignment:**
- Update task status DURING work (not after)
- Add comments as you progress
- Update estimates if scope changes
- Align memory files (`.fong/.memory/`) with current state

---

## 📝 Example: Complete Task Breakdown

### Scenario: Implement Affiliate Dashboard

**Step 1: Identify Deliverable**
- Deliverable: Working affiliate dashboard with commission tracking

**Step 2: Decompose into Phases**
```
1.0 Requirements & Design
2.0 Backend Implementation
3.0 Frontend Implementation
4.0 Testing & Integration
5.0 Deployment
```

**Step 3: Break into Activities**
```
1.0 Requirements & Design
  1.1 Gather requirements
  1.2 Design database schema
  1.3 Design API endpoints
  1.4 Create UI mockups

2.0 Backend Implementation
  2.1 Database migrations
  2.2 Commission calculation service
  2.3 Dashboard API endpoints
  2.4 Report generation
```

**Step 4: Break into Microtasks**
```
2.2 Commission calculation service
  2.2.1 Research commission calculation rules (Query DKM)
  2.2.2 Design calculation algorithm
  2.2.3 Implement base commission calculator class
  2.2.4 Add tier-based commission logic
  2.2.5 Write unit tests for calculator
  2.2.6 Integrate with database queries
```

**Step 5: Define Dependencies**
```
2.2.1 (Research) → Must finish before 2.2.2 (Design)
2.2.2 (Design) → Must finish before 2.2.3 (Implement)
2.2.3 (Base class) → Must finish before 2.2.4 (Tier logic)
2.2.4 (Tier logic) → Must finish before 2.2.5 (Tests)
2.1 (Database) → Must finish before 2.2.6 (Integration)
```

**Step 6: Estimate**
```
2.2.1 Research: 2-3 hours
2.2.2 Design: 3-4 hours
2.2.3 Implement base: 4-6 hours
2.2.4 Tier logic: 4-5 hours
2.2.5 Unit tests: 3-4 hours
2.2.6 Integration: 2-3 hours

Total Activity 2.2: 18-25 hours (3-4 days)
```

**Step 7: Create in Task Management Tool**
```
Section: "2.0 Backend Implementation"
  Task: "2.2 Commission calculation service"
    Subtask: "2.2.1 Research commission rules (DKM query)"
      - Due: Today
      - Assignee: Developer A
      - Estimate: 2-3h
    Subtask: "2.2.2 Design calculation algorithm"
      - Due: Tomorrow
      - Depends on: 2.2.1
      - Estimate: 3-4h
    ... (continue for all subtasks)
```

**Step 8: Query DKM for Research**
```typescript
// Research commission calculation best practices
mcp__dkm-knowledgebase__queryRAG({
  question: "commission calculation tier based affiliate",
  top_k: 5
})

// Learn about calculation patterns
mcp__dkm-knowledgebase__queryRAG({
  question: "financial calculation patterns PHP money",
  top_k: 5
})
```

---

## 🔗 Related Documentation

- **Memory System**: `.fong/instructions/fongmemory.md`
- **Tool Catalog**: `.fong/instructions/fongtools.json`
- **Init Prompt**: `.fong/instructions/init-prompt.json`
- **DKM Knowledge Sources**: `.fong/instructions/instructions-dkm-sources-knowledgebase.md`

---

## 📚 References

**Books Consulted (via DKM Query RAG):**
- Software Engineering: A Practitioner's Approach (Pressman & Maxim, 2020)
- Work Breakdown Structures (Norman, Brotherton, Fried, 2008)
- BABOK v3 - Business Analysis Body of Knowledge (IIBA, 2015)
- Harold Kerzner - Project Management (Wiley, 2022)
- PMBOK Guide 2021 (PMI)

**Tools:**
- DKM Knowledge Base (190 books)
- Task Management Tools (Asana, Jira, Linear, etc.)
- mini-rag (RAG query system)

---

**Last Updated:** 2025-10-31
**Status:** Active - General Instruction Format
**Version:** 4.1
