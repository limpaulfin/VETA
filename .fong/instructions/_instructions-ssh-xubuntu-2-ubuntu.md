@DEPRECIATED

# SSH từ Xubuntu VM → Ubuntu Host

## Cách dùng SSH từ máy ảo vào máy thật

```bash
# Pattern cơ bản - LUÔN cd vào project folder
ssh fong@192.168.122.1 "cd /home/fong/Projects/qtdnd-duythanh && [command]"
```

## Ví dụ

```bash
# Git status
ssh fong@192.168.122.1 "cd /home/fong/Projects/qtdnd-duythanh && git status"

# Laravel artisan
ssh fong@192.168.122.1 "cd /home/fong/Projects/qtdnd-duythanh/backend && php artisan migrate:status"

# DDEV commands
ssh fong@192.168.122.1 "cd /home/fong/Projects/qtdnd-duythanh/backend && ddev describe"

# List files
ssh fong@192.168.122.1 "cd /home/fong/Projects/qtdnd-duythanh && ls -la"
```

## Config
- **Host IP**: 192.168.122.1
- **User**: fong
- **Project**: /home/fong/Projects/qtdnd-duythanh

---
Created: 2025-09-09