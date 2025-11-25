#!/bin/bash

# Script động để chạy claude với các config tối ưu
# Version a9a2b43d-46d8-41bf-b7be-4c64e10d3406
# bỏ verbose
# Features:
#   - Tự động tắt auto-update
#   - Bật verbose mode
#   - Skip permissions cho development
#   - Tự động detect project root

# Lấy đường dẫn của script hiện tại
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Tìm project root (đi lên từ .fong/)
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "📁 Project root: $PROJECT_ROOT"
echo "⚙️  Cấu hình:"
echo "   - Permission checks: SKIPPED"
echo ""

# Set global configs trước khi chạy
claude config set -g autoUpdates false 2>/dev/null
#claude config set -g verbose true 2>/dev/null

echo "🚀 Đang khởi động (Github) Copilot..."skip
echo "─────────────────────────────────"

# Di chuyển đến project root và chạy claude với flags
#cd "$PROJECT_ROOT" && claude --dangerously-skip-permissions --verbose
cd "$PROJECT_ROOT" && copilot --allow-all-tools --allow-all-paths