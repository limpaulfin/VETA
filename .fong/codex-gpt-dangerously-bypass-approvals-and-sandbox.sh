#!/bin/bash

# Script để chạy Codex CLI với quyền bỏ qua sandbox và approval
# Version 2025-10-19
# Cảnh báo: sử dụng trong môi trường đã được sandbox/kiểm soát bên ngoài

# Xác định thư mục chứa script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Suy ra project root (thư mục cha của .fong/)
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "📁 Project root: $PROJECT_ROOT"
echo "⚙️  Cấu hình:"
echo "   - Sandbox: BYPASSED"
echo "   - Approval policy: DISABLED"
echo "   - Extra args: $*"
echo ""
echo "⚠️  WARNING: Codex sẽ chạy với toàn quyền (không sandbox, không approval)."
echo "    Chỉ sử dụng trong môi trường được kiểm soát."
echo ""

echo "🚀 Đang khởi động Codex CLI..."
echo "─────────────────────────────────"

# Di chuyển tới project root và chạy Codex
cd "$PROJECT_ROOT" && codex --dangerously-bypass-approvals-and-sandbox "$@"
