#!/bin/bash

# mem0.sh - Main orchestrator for mem0 operations (Single Responsibility)
# Usage: ./mem0.sh <command> [options]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for better UX
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

show_help() {
    echo -e "${CYAN}🧠 Mem0 API Manager - SOLID Architecture${NC}"
    echo ""
    echo -e "${YELLOW}USAGE:${NC}"
    echo "  $0 <command> [options]"
    echo ""
    echo -e "${YELLOW}COMMANDS:${NC}"
    echo -e "  ${GREEN}add${NC}        <project> <content> [user_id]     Add memory to project"
    echo -e "  ${GREEN}search${NC}     <query> [project] [user] [top_k] Search memories"
    echo -e "  ${GREEN}get${NC}        [project] [user] [page] [size]    Get all memories"
    echo -e "  ${GREEN}update${NC}     <memory_id> <content> [metadata]  Update memory"
    echo -e "  ${GREEN}delete${NC}     <memory_id>                       Delete single memory"
    echo -e "  ${GREEN}delete${NC}     --project <name>                  Delete project memories"
    echo -e "  ${GREEN}delete${NC}     --user <user_id>                  Delete user memories"
    echo -e "  ${GREEN}align${NC}      <project_path> [name] [user]      Align project with reality"
    echo -e "  ${GREEN}stats${NC}                                        Show memory statistics"
    echo -e "  ${GREEN}projects${NC}                                     List all projects"
    echo -e "  ${GREEN}help${NC}                                         Show this help"
    echo ""
    echo -e "${YELLOW}EXAMPLES:${NC}"
    echo "  $0 add 'my-project' 'User prefers React'"
    echo "  $0 search 'React development' 'my-project'"
    echo "  $0 get 'my-project'"
    echo "  $0 update 'uuid-id' 'Updated content'"
    echo "  $0 delete --project 'old-project'"
    echo "  $0 align '/path/to/project'"
    echo ""
    echo -e "${YELLOW}ARCHITECTURE:${NC}"
    echo "  Each command runs as independent script following SOLID principles"
    echo "  Shared functions in common.sh following DRY principle"
}

show_stats() {
    echo -e "${CYAN}📊 Memory Statistics${NC}"
    echo ""
    "$SCRIPT_DIR/get.sh" "" "" 1 1000
}

list_projects() {
    echo -e "${CYAN}📂 All Projects${NC}"
    echo ""
    # Use get.sh to retrieve and display project summary
    "$SCRIPT_DIR/get.sh" | grep -A 20 "📊 SUMMARY BY PROJECT:" | head -20
}

validate_command() {
    local command="$1"
    local valid_commands=("add" "search" "get" "update" "delete" "align" "stats" "projects" "help")
    
    for valid_cmd in "${valid_commands[@]}"; do
        if [[ "$command" == "$valid_cmd" ]]; then
            return 0
        fi
    done
    
    echo -e "${RED}❌ Unknown command: $command${NC}"
    return 1
}

route_command() {
    local command="$1"
    shift
    
    case "$command" in
        "add")
            "$SCRIPT_DIR/add.sh" "$@"
            ;;
        "search")
            "$SCRIPT_DIR/search.sh" "$@"
            ;;
        "get")
            "$SCRIPT_DIR/get.sh" "$@"
            ;;
        "update")
            "$SCRIPT_DIR/update.sh" "$@"
            ;;
        "delete")
            "$SCRIPT_DIR/delete.sh" "$@"
            ;;
        "align")
            "$SCRIPT_DIR/align.sh" "$@"
            ;;
        "stats")
            show_stats
            ;;
        "projects")
            list_projects
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            echo -e "${RED}❌ Command routing error${NC}"
            exit 1
            ;;
    esac
}

main() {
    # Check if no arguments
    if [[ $# -eq 0 ]]; then
        show_help
        exit 1
    fi
    
    local command="$1"
    
    # Validate command
    if ! validate_command "$command"; then
        echo ""
        show_help
        exit 1
    fi
    
    # Route to appropriate script
    route_command "$@"
}

# Run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi