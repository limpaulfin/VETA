#!/bin/bash

# Script để chạy Cursor Agent CLI trong project hiện tại
# Version 2025-10-20
# Cảnh báo: đảm bảo cursor-agent đã được cài trong PATH

# Xác định thư mục chứa script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Suy ra project root (thư mục cha của .fong/)
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "📁 Project root: $PROJECT_ROOT"
echo "⚙️  Cấu hình:"
echo "   - Command: cursor-agent"
echo "   - Extra args: $*"
echo ""

echo "🚀 Đang khởi động Cursor Agent CLI..."
echo "─────────────────────────────────"

# Di chuyển tới project root và chạy cursor-agent
cd "$PROJECT_ROOT" && cursor-agent "$@"
