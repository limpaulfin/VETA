#!/bin/bash

# Script wrapper để chạy claude-dev-dangerous.sh cho project này (portable version)
# Created: 2025-09-22
# Auto-detects codebase location from script path

# Lấy đường dẫn thực của script (resolve symlinks)
SCRIPT_PATH=$(readlink -f "$0")
# Lấy thư mục chứa script
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
# Đi lên 2 cấp để ra codebase root (.fong/claude-xubuntu -> codebase)
CODEBASE_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)

echo "🚀 Starting Claude Dev for project: $CODEBASE_ROOT"

# Chạy claude-dev với codebase path tự động detect
/home/fong/Projects/ssh-claude-code/claude-dev.sh "$CODEBASE_ROOT"