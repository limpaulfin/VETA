# Git Operations via SSH - Xubuntu KVM

**Version**: e8817093-9e56-4839-944d-1b2acb52f788  
**Updated**: 2025-09-23

## 🎯 Mục Đích
Hướng dẫn thao tác Git qua SSH khi đang work trên Xubuntu KVM environment với auto-detect codebase.

## 🛠️ Cách Dùng Tool fonggitx.sh (RECOMMENDED)

### Tool Path (từ project root)
```bash
.fong/tools/fonggitx.sh
```

### Cú Pháp
```bash
.fong/tools/fonggitx.sh "command"
# Hoặc với prefix git
.fong/tools/fonggitx.sh "git command"
```

### Tính Năng Chính
- ✨ **Auto-detect codebase** từ vị trí script
- 🚀 SSH tới host KVM (192.168.122.1) 
- 🎨 Colored output với status messages
- 🔧 Non-interactive mode cho merge/rebase
- 📍 Hiển thị project path tự động

## 📋 Các Lệnh Git Thông Dụng (Dùng fonggitx.sh)

### Kiểm tra trạng thái
```bash
.fong/tools/fonggitx.sh "status"
```

### Xem branch hiện tại
```bash
.fong/tools/fonggitx.sh "branch --show-current"
```

### Add changes
```bash
.fong/tools/fonggitx.sh "add ."
```
**Note:** Always use `git add .` to stage all changes at once. Never add files individually.

### Commit
```bash
.fong/tools/fonggitx.sh "commit -m 'commit message'"
```

### Push
```bash
.fong/tools/fonggitx.sh "push origin main"
```

### Pull
```bash
.fong/tools/fonggitx.sh "pull origin main"
```

### Xem log
```bash
.fong/tools/fonggitx.sh "log --oneline -5"
```

### Xem diff
```bash
.fong/tools/fonggitx.sh "diff"
```

## 🔄 Standard Workflow

### Commit + Push workflow
```bash
# 1. Check status
.fong/tools/fonggitx.sh "status"

# 2. Add ALL changes (ALWAYS use git add .)
.fong/tools/fonggitx.sh "add ."

# 3. Commit with descriptive message
.fong/tools/fonggitx.sh "commit -m 'your message'"

# 4. Push to remote
.fong/tools/fonggitx.sh "push origin main"
```

## 🔧 Technical Details

### SSH Configuration
- **SSH_USER**: fong
- **SSH_HOST**: 192.168.122.1 (KVM host IP)
- **PROJECT_PATH**: Auto-detected from script location

### Auto-Detection Logic
```bash
# Script tự detect project root bằng cách:
# 1. Lấy vị trí của script
# 2. Navigate up từ .fong/tools/ đến project root
PROJECT_PATH="$( cd "${SCRIPT_DIR}/../.." && pwd )"
```

### Non-Interactive Features
- Auto-add `--no-edit` cho merge commands
- Auto-add `--no-edit` cho rebase commands  
- Set `GIT_EDITOR=true` và `GIT_MERGE_AUTOEDIT=no`

## 🔐 Git Authentication Setup

### Problem: HTTPS vs SSH
- **HTTPS URLs** (`https://github.com/...`) yêu cầu username/password mỗi lần push
- **SSH URLs** (`git@github.com:...`) dùng SSH keys, không cần password

### Solution: Chuyển sang SSH Authentication

#### 1. Kiểm tra remote hiện tại
```bash
.fong/tools/fonggitx.sh "remote -v"
```

#### 2. Nếu đang dùng HTTPS, đổi sang SSH
```bash
# Format: git@github.com:USERNAME/REPOSITORY.git
.fong/tools/fonggitx.sh "remote set-url origin git@github.com:USERNAME/REPOSITORY.git"

# Example cho project này:
.fong/tools/fonggitx.sh "remote set-url origin git@github.com:limpaulfin/ai_litreview_pipeline.git"
```

#### 3. Verify SSH key đã setup
```bash
# Check SSH keys trên host machine
ssh fong@192.168.122.1 "ls -la ~/.ssh/id_*.pub"
```

#### 4. Push với SSH
```bash
.fong/tools/fonggitx.sh "push -u origin main"
```

### Troubleshooting
- **Error: "could not read Username"** → Remote đang dùng HTTPS, cần đổi sang SSH
- **Error: "Permission denied"** → SSH key chưa setup hoặc chưa add vào GitHub
- **Success example**: Project `de/public` dùng `git@github.com:TheMOBfamily/tiengduc2.git`

## ⚠️ Critical Notes
1. **Auto-detect project root** - Không cần manual cd hay config path
2. **Prefix "git" optional** - Tool tự thêm nếu thiếu
3. **Each project has its own fonggitx.sh** - Copy tool vào `.fong/tools/` directory
4. **ALWAYS use `git add .`** - Stage all changes at once, never add files individually
5. **SSH connectivity check** - Tool kiểm tra kết nối trước khi execute
6. **Use SSH for authentication** - Tránh lỗi username/password với HTTPS