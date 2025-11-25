#!/bin/bash

# Git operations via SSH for Xubuntu KVM
# Auto-detect project root from script location

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Project root is 2 levels up from .fong/tools/
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# SSH settings
SSH_USER="fong"
SSH_HOST="192.168.122.1"

# Get full command from arguments (including "git")
FULL_COMMAND="$@"

# If no arguments, show help
if [ -z "$FULL_COMMAND" ]; then
    echo "Usage: $0 <full git command>"
    echo "Example: $0 git status"
    echo "Example: $0 git add ."
    echo "Example: $0 git commit -m 'message'"
    echo "Example: $0 git push origin main"
    echo ""
    echo "Project root: $PROJECT_ROOT"
    exit 1
fi

# Execute command via SSH
echo "Executing: $FULL_COMMAND"
echo "In directory: $PROJECT_ROOT"
echo "----------------------------------------"

ssh "$SSH_USER@$SSH_HOST" "cd $PROJECT_ROOT && $FULL_COMMAND"