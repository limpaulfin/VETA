---
description: "Git operations and branch naming conventions"
argument-hint: "[git command]"
---

# Git Operations Guide | Hướng dẫn Git

⚠️ **MOTTO: ALWAYS DOUBLE CHECK - LUÔN KIỂM TRA KÉP**

Standard git operations with mandatory double-check protocols and branch naming conventions.

## Basic Git Commands | Lệnh Git cơ bản

### Check Status & Information
```bash
git status                    # Check working directory status
git branch --show-current     # Show current branch
git log --oneline -5          # View recent commits
git remote -v                 # Check remotes
```

### Basic Operations
```bash
git add .                     # Add all changes
git commit -m "message"       # Commit with message
git push origin branch-name   # Push to remote branch
git checkout branch-name      # Switch branch
git merge source-branch       # Merge branch
```

## Branch Naming Conventions | Quy tắc đặt tên nhánh

### Feature Branches | Nhánh tính năng
```bash
feature/user-authentication     # New user login system
feature/payment-integration     # Payment gateway integration
feature/sidebar-menu           # Sidebar menu component
feature/dashboard-analytics    # Analytics dashboard
```

### Bug Fix Branches | Nhánh sửa lỗi
```bash
fix/login-validation          # Fix login form validation
fix/payment-timeout           # Fix payment timeout issue
fix/mobile-responsive         # Fix mobile layout issues
fix/database-connection       # Fix database connection error
```

### Hotfix Branches | Nhánh sửa lỗi khẩn cấp
```bash
hotfix/security-patch         # Critical security fix
hotfix/payment-bug            # Critical payment system bug
hotfix/server-crash           # Server crash fix
```

### Development Branches | Nhánh phát triển
```bash
develop/new-architecture      # Major architecture changes
develop/api-v2               # API version 2 development
develop/performance-optimization # Performance improvements
```

## Quick Workflow | Quy trình nhanh

```bash
# 1. Check current status
git status

# 2. Add changes
git add .

# 3. Commit with descriptive message
git commit -m "feat: implement user authentication system"

# 4. Push to current branch
git push origin feature/user-authentication
```

## MERGE WORKFLOW WITH MANDATORY PUSH | QUY TRÌNH MERGE BẮT BUỘC PUSH

⚠️ **BẮT BUỘC: MỖI KHI MERGE PHẢI PUSH VÀ DOUBLE CHECK**

### Standard Merge Sequence | Quy trình merge chuẩn
```bash
# 1. Pre-merge check
git branch --show-current  # Confirm target branch
git status                 # Clean working directory

# 2. Execute merge
git merge source-branch

# 3. MANDATORY: ALWAYS PUSH AFTER MERGE
git push origin target-branch

# 4. MANDATORY: DOUBLE CHECK REMOTE UPDATED
git status              # Should show "up to date"
git log --oneline -3    # Verify commits on remote
```

### Multi-Branch Merge Pipeline | Pipeline merge nhiều nhánh
```bash
# Example: fong → staging → main
# Step 1: Merge to staging
git checkout staging
git merge fong
git push origin staging    # MANDATORY PUSH
git status                 # DOUBLE CHECK

# Step 2: Merge to main  
git checkout main
git merge staging
git push origin main       # MANDATORY PUSH
git status                 # DOUBLE CHECK
```

### MERGE CHECKLIST | DANH SÁCH KIỂM TRA MERGE

#### BEFORE MERGE:
- [ ] Current branch confirmed (target branch)
- [ ] Working directory clean
- [ ] Source branch commits reviewed

#### AFTER MERGE:
- [ ] Merge completed without conflicts
- [ ] Target branch contains expected commits
- [ ] Working directory clean

#### AFTER PUSH (MANDATORY):
- [ ] **ALWAYS push after merge**
- [ ] Push successful (no errors)
- [ ] Remote branch updated
- [ ] Local shows "up to date with origin"

#### DOUBLE CHECK (MANDATORY):
- [ ] **Verify merge commits visible on remote**
- [ ] **Confirm GitHub/remote reflects latest changes**
- [ ] **Cross-reference commit IDs match remote**

## DOUBLE CHECK Branch Switching Protocol | Quy trình chuyển nhánh KIỂM TRA KÉP

⚠️ **ALWAYS DOUBLE CHECK - LUÔN KIỂM TRA KÉP**

### Before Switch | Trước khi chuyển
```bash
# 1. MANDATORY: Check current branch first
git branch --show-current

# 2. Check working directory status
git status

# 3. Inform user: "Currently on branch: [current-branch], switching to: [target-branch]"
```

### Execute Switch | Thực hiện chuyển
```bash
# 4. Execute branch switch
git checkout target-branch
```

### After Switch | Sau khi chuyển
```bash
# 5. MANDATORY: Verify the switch was successful
git branch --show-current

# 6. Confirm with user: "Successfully switched to branch: [new-branch]"

# 7. Optional: Show brief status
git status --short
```

### Complete Example | Ví dụ hoàn chỉnh
```bash
# Step 1: Check current branch (BEFORE)
echo "Checking current branch before switch..."
git branch --show-current

# Step 2: Switch branch
echo "Switching from [current] to [target]..."
git checkout target-branch

# Step 3: Verify switch (AFTER)
echo "Verifying switch was successful..."
git branch --show-current

# Step 4: Final confirmation
echo "✅ Successfully switched to: [new-branch]"
```

## Git Best Practices | Thực hành tốt nhất

- ⚠️ **DOUBLE CHECK Protocol**: Branch switching MUST verify before/after
- 🛡️ **Cross Check**: Always inform user of current → target branch transitions
- 📊 **COMMIT REPORTING**: Mỗi lần commit/push PHẢI báo cáo commit ID và timestamp
- 🔒 **Clean Working Directory**: Always check git status before operations
- 📝 **Descriptive Commits**: Use clear, meaningful commit messages

## Commit/Push Reporting Protocol | Quy trình báo cáo Commit/Push

### Required Information | Thông tin bắt buộc
Mỗi lần thực hiện commit hoặc push, PHẢI trích xuất và báo cáo:

1. **Commit ID** (hash): Ví dụ `63e361e52`
2. **Commit Message**: Nội dung commit message
3. **Branch Name**: Tên nhánh hiện tại
4. **Timestamp**: Thời gian thực hiện (từ output)
5. **Files Changed**: Số lượng files thay đổi
6. **Insertions/Deletions**: Số dòng thêm/xóa

### Example Output Format | Định dạng output mẫu
```
✅ COMMIT SUCCESSFUL:
- Commit ID: 63e361e52
- Branch: feature/khai-bao-trinh-do
- Message: "Implement comprehensive level declaration system..."
- Files: 40 changed
- Changes: +737,364 insertions, -44 deletions
- Time: [extracted from git output]

✅ PUSH SUCCESSFUL:
- Pushed to: origin/feature/khai-bao-trinh-do
- Commit ID: 63e361e52
- Status: Success
```

## CROSSCHECK/DOUBLECHECK PROTOCOL | QUY TRÌNH KIỂM TRA KÉP

⚠️ **BẮT BUỘC: Mỗi thao tác git PHẢI được crosscheck/doublecheck**

### 1. Pre-Operation Check | Kiểm tra trước thao tác
```bash
# ALWAYS check current state first
git branch --show-current
git status
git log --oneline -3
```

### 2. Operation Execution | Thực hiện thao tác
```bash
# Execute the intended operation
git [command]
```

### 3. Post-Operation Verification | Xác minh sau thao tác
```bash
# MANDATORY: Verify the operation result
git branch --show-current
git status
git log --oneline -3
```

### 4. Remote Verification | Kiểm tra remote (for push operations)
```bash
# For push operations, verify remote sync
git status  # Should show "up to date"
```

### 5. Cross-Reference Check | Kiểm tra chéo
```bash
# Cross-reference with expected state
echo "Expected: [describe expected state]"
echo "Actual: [describe actual state from commands above]"
echo "Match: [YES/NO]"
```

### DOUBLECHECK CHECKLIST | DANH SÁCH KIỂM TRA KÉP

#### Before ANY git operation | Trước MỌI thao tác git:
- [ ] Current branch confirmed
- [ ] Working directory status checked  
- [ ] Recent commits reviewed

#### After commit operations | Sau thao tác commit:
- [ ] Commit ID extracted and reported
- [ ] Files changed count verified
- [ ] Commit message matches intention
- [ ] Branch unchanged (unless intended)

#### After merge operations | Sau thao tác merge:
- [ ] Merge completed without conflicts
- [ ] Target branch contains expected commits
- [ ] Working directory clean
- [ ] No unexpected file changes

#### After push operations | Sau thao tác push:
- [ ] Push successful (no errors)
- [ ] Remote branch updated
- [ ] Local branch shows "up to date with origin"
- [ ] Commit visible on remote repository

#### After branch operations | Sau thao tác nhánh:
- [ ] Current branch matches target
- [ ] Working directory appropriate for branch
- [ ] No unexpected uncommitted changes
- [ ] Branch history as expected

### EMERGENCY ROLLBACK | KHÔI PHỤC KHẨN CẤP

Nếu thao tác không như mong đợi:
```bash
# Check what went wrong
git reflog -10

# Rollback if needed (BE VERY CAREFUL)
git reset --hard HEAD^  # Only for local commits
```

**LƯU Ý QUAN TRỌNG:**
- LUÔN backup trước khi thực hiện thao tác nguy hiểm
- KHÔNG ĐƯỢC reset sau khi đã push
- Sử dụng `git revert` thay vì `git reset` cho commits đã push
- Luôn kiểm tra branch hiện tại trước khi thực hiện thao tác
- Commit message phải rõ ràng và mô tả đúng nội dung thay đổi

## Branch Information | Thông tin nhánh

- **Development**: `fong` 
- **Staging**: `staging`
- **Production**: `main`
- **Feature**: `feature/[feature-name]`
- **Bug Fix**: `fix/[bug-description]`
- **Hotfix**: `hotfix/[critical-fix]`

## Commit Message Conventions | Quy ước commit message

### Format
```
<type>: <description>

[optional body]
```

### Types
- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, etc.)
- **refactor**: Code refactoring
- **test**: Adding or updating tests
- **chore**: Build process or auxiliary tool changes

### Examples
```bash
git commit -m "feat: add user authentication system"
git commit -m "fix: resolve payment timeout issue"
git commit -m "docs: update API documentation"
git commit -m "refactor: optimize database queries"
```

---

## Common Git Scenarios | Các tình huống Git thông dụng

### Create and Switch to New Branch
```bash
# Create new feature branch
git checkout -b feature/new-feature

# Or create fix branch
git checkout -b fix/bug-description
```

### Sync with Remote
```bash
# Fetch latest changes
git fetch origin

# Pull latest changes to current branch
git pull origin main

# Rebase current branch on main
git rebase origin/main
```

### Undo Changes
```bash
# Unstage files
git reset HEAD file.txt

# Discard uncommitted changes
git checkout -- file.txt

# Undo last commit (keep changes)
git reset --soft HEAD^

# Undo last commit (discard changes)
git reset --hard HEAD^
```

### View History
```bash
# View commit history
git log --oneline -10

# View changes in specific commit
git show commit-hash

# View differences between branches
git diff main..feature/branch-name
```