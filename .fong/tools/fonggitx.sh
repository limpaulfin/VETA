#!/bin/bash

# fonggitx.sh - Git operations via SSH with auto-detect codebase
# Usage: ./fonggitx.sh "git_command"
# Example: ./fonggitx.sh "status" or ./fonggitx.sh "add ."

# Auto-detect PROJECT_PATH from script location
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# Navigate up from .fong/tools/ to project root
PROJECT_PATH="$( cd "${SCRIPT_DIR}/../.." && pwd )"

# SSH Configuration
SSH_USER="fong"
SSH_HOST="192.168.122.1"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}🔔 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

print_info() {
    echo -e "${MAGENTA}📍 Project: ${PROJECT_PATH}${NC}"
}

# Function to execute git command via SSH
execute_git_command() {
    local git_cmd="$1"
    
    # Add 'git' prefix if not present
    if [[ ! "$git_cmd" =~ ^git ]]; then
        git_cmd="git $git_cmd"
    fi
    
    # Handle special git commands for non-interactive execution
    if echo "$git_cmd" | grep -q "git merge" && ! echo "$git_cmd" | grep -q "\--no-edit"; then
        git_cmd=$(echo "$git_cmd" | sed 's/git merge /git merge --no-edit /')
        print_warning "Auto-modified: $git_cmd"
    elif echo "$git_cmd" | grep -q "git rebase" && ! echo "$git_cmd" | grep -q "\--no-edit"; then
        git_cmd=$(echo "$git_cmd" | sed 's/git rebase /git rebase --no-edit /')
        print_warning "Auto-modified: $git_cmd"
    elif echo "$git_cmd" | grep -q "git pull" && echo "$git_cmd" | grep -q "rebase"; then
        if ! echo "$git_cmd" | grep -q "\--no-edit"; then
            git_cmd=$(echo "$git_cmd" | sed 's/git pull /git pull --no-edit /')
            print_warning "Auto-modified: $git_cmd"
        fi
    fi
    
    # Set environment for non-interactive git operations
    local env_vars="export GIT_EDITOR=true && export GIT_MERGE_AUTOEDIT=no"
    local full_command="cd ${PROJECT_PATH} && ${env_vars} && ${git_cmd}"
    
    print_info
    print_status "Executing: $git_cmd"
    
    # Execute command via SSH
    ssh "${SSH_USER}@${SSH_HOST}" "${full_command}"
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        print_success "Command completed successfully"
    else
        print_error "Command failed with exit code: $exit_code"
    fi
    
    return $exit_code
}

# Main function
main() {
    if [ $# -eq 0 ]; then
        echo "Usage: $0 'git_command'"
        echo ""
        echo "Examples:"
        echo "  $0 'status'"
        echo "  $0 'branch --show-current'"
        echo "  $0 'add .'"
        echo "  $0 'commit -m \"Your message\"'"
        echo "  $0 'push origin main'"
        echo ""
        echo "Auto-detected project: ${PROJECT_PATH}"
        exit 1
    fi
    
    local git_command="$1"
    
    # Check SSH connectivity first
    if ! ssh -o ConnectTimeout=2 "${SSH_USER}@${SSH_HOST}" "echo 'SSH connection OK'" &>/dev/null; then
        print_error "Cannot connect to SSH host ${SSH_HOST}"
        print_warning "Please check if you're in KVM guest environment"
        exit 1
    fi
    
    # Execute git command
    execute_git_command "$git_command"
}

# Run main function with all arguments
main "$@"