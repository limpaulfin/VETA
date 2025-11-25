#!/bin/bash

# delete.sh - Delete memories from mem0 (Single Responsibility)
# Usage: ./delete.sh <memory_id> OR ./delete.sh --project <name> OR ./delete.sh --user <user_id>

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

show_usage() {
    echo "Usage:"
    echo "  $0 <memory_id>                    # Delete single memory by ID"
    echo "  $0 --project <project_name>       # Delete all memories of project"  
    echo "  $0 --user <user_id>              # Delete all memories of user"
    echo "  $0 --project <project> --user <user> # Delete with both filters"
    echo ""
    echo "Examples:"
    echo "  $0 'uuid-memory-id'"
    echo "  $0 --project 'old-project'"
    echo "  $0 --user 'user123'"
    echo ""
    echo "Description:"
    echo "  Deletes memories by ID or using filters"
    exit 1
}

confirm_deletion() {
    local message="$1"
    echo "⚠️  $message"
    read -p "Are you sure? (y/N): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "❌ Deletion cancelled"
        exit 0
    fi
}

delete_single_memory() {
    local memory_id="$1"
    
    echo "🗑️  Deleting single memory..."
    echo "🆔 Memory ID: $memory_id"
    echo ""
    
    confirm_deletion "This will permanently delete the memory."
    
    echo "🚀 Calling API..."
    
    # Make API call
    local endpoint="${MEM0_DELETE_ENDPOINT}${memory_id}/"
    local response=$(api_call "DELETE" "$endpoint")
    
    # Check response
    if echo "$response" | jq -e '.message' > /dev/null 2>&1; then
        echo "✅ $(echo "$response" | jq -r '.message')"
    else
        echo "❌ Unexpected response:"
        pretty_print_response "$response"
        exit 1
    fi
}

delete_filtered_memories() {
    local project_name="${1:-}"
    local user_id="${2:-}"
    
    echo "🗑️  Deleting memories with filters..."
    [[ -n "$project_name" ]] && echo "📂 Project: $project_name"
    [[ -n "$user_id" ]] && echo "👤 User ID: $user_id"
    echo ""
    
    confirm_deletion "This will permanently delete ALL matching memories."
    
    # Create query parameters
    local params=""
    [[ -n "$user_id" ]] && params+="user_id=$user_id&"
    [[ -n "$project_name" ]] && params+="metadata={\"project\":\"$project_name\"}&"
    
    # Remove trailing &
    params="${params%&}"
    
    echo "🚀 Calling API..."
    
    # Make API call
    local endpoint="${MEM0_DELETE_ENDPOINT}?$params"
    local response=$(api_call "DELETE" "$endpoint")
    
    # Check response
    if echo "$response" | jq -e '.message' > /dev/null 2>&1; then
        echo "✅ $(echo "$response" | jq -r '.message')"
    else
        echo "❌ Unexpected response:"
        pretty_print_response "$response"
        exit 1
    fi
}

main() {
    # Initialize
    init
    
    # Check parameters
    if [[ $# -eq 0 ]]; then
        show_usage
    fi
    
    # Handle single memory ID
    if [[ $# -eq 1 ]] && [[ ! "$1" =~ ^-- ]]; then
        validate_required "memory_id" "$1"
        delete_single_memory "$1"
        return
    fi
    
    # Handle filters
    local project_name=""
    local user_id=""
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --project)
                project_name="$2"
                shift 2
                ;;
            --user)
                user_id="$2"
                shift 2
                ;;
            *)
                echo "❌ Unknown option: $1"
                show_usage
                ;;
        esac
    done
    
    # Validate at least one filter
    if [[ -z "$project_name" ]] && [[ -z "$user_id" ]]; then
        echo "❌ Must specify at least --project or --user"
        show_usage
    fi
    
    delete_filtered_memories "$project_name" "$user_id"
}

# Run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi