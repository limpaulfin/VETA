#!/bin/bash

# get.sh - Get all memories from mem0 (Single Responsibility)
# Usage: ./get.sh [project_name] [user_id] [page] [page_size]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

show_usage() {
    echo "Usage: $0 [project_name] [user_id] [page] [page_size]"
    echo ""
    echo "Examples:"
    echo "  $0                              # Get all project memories"
    echo "  $0 'my-project'                 # Get memories for specific project"
    echo "  $0 'my-project' 'user123'       # Get memories for project and user"
    echo "  $0 '' '' 2 100                  # Get page 2 with 100 items"
    echo ""
    echo "Description:"
    echo "  Retrieves all memories with optional filtering"
    exit 1
}

create_get_filters() {
    local project_name="${1:-}"
    local user_id="${2:-}"
    
    if [[ -n "$project_name" ]] && [[ -n "$user_id" ]]; then
        echo '{"AND": [{"metadata": {"project": "'$project_name'"}}, {"user_id": "'$user_id'"}]}'
    elif [[ -n "$project_name" ]]; then
        echo '{"metadata": {"project": "'$project_name'"}}'
    elif [[ -n "$user_id" ]]; then
        echo '{"user_id": "'$user_id'"}'
    else
        echo '{"metadata": {"category": "project-memory"}}'
    fi
}

get_memories() {
    local project_name="${1:-}"
    local user_id="${2:-}"
    local page="${3:-1}"
    local page_size="${4:-$MEM0_DEFAULT_PAGE_SIZE}"
    
    echo "📋 Getting all memories..."
    [[ -n "$project_name" ]] && echo "📂 Project: $project_name"
    [[ -n "$user_id" ]] && echo "👤 User ID: $user_id"
    echo "📄 Page: $page, Size: $page_size"
    echo ""
    
    # Create filters
    local filters=$(create_get_filters "$project_name" "$user_id")
    
    # Create payload
    local payload=$(cat <<EOF
{
  "filters": $filters,
  "page": $page,
  "page_size": $page_size
}
EOF
    )
    
    # Validate JSON payload
    if ! validate_json "$payload"; then
        exit 1
    fi
    
    echo "🚀 Calling API..."
    
    # Make API call
    local response=$(api_call "POST" "$MEM0_GET_ENDPOINT" "$payload")
    
    # Check for API errors
    if ! check_api_error "$response"; then
        exit 1
    fi
    
    # Process response
    if echo "$response" | jq -e '.[0].id' > /dev/null 2>&1; then
        local result_count=$(echo "$response" | jq 'length')
        echo "✅ Found $result_count memories on page $page:"
        echo ""
        
        # Summary by project
        echo "📊 SUMMARY BY PROJECT:"
        echo "$response" | jq -r 'group_by(.metadata.project // "unknown") | .[] | 
            "🏷️  \(.[0].metadata.project // "Unknown"): \(length) memories"'
        echo ""
        
        # Summary by user
        echo "👥 SUMMARY BY USER:"
        echo "$response" | jq -r 'group_by(.owner // .user_id // "unknown") | .[] | 
            "👤 \(.[0].owner // .[0].user_id // "Unknown"): \(length) memories"'
        echo ""
        
        # Detailed list
        echo "📋 DETAILED LIST:"
        echo "$response" | jq -r '.[] | 
            "🆔 ID: \(.id)",
            "💬 Memory: \(.memory)",
            "📂 Project: \(.metadata.project // \"N/A\")",
            "👤 User: \(.owner // .user_id // \"N/A\")",
            "📅 Created: \(.created_at)",
            "🔄 Updated: \(.updated_at)",
            "---"'
            
    elif echo "$response" | jq -e '. | length == 0' > /dev/null 2>&1; then
        echo "📭 No memories found"
    else
        echo "❌ Unexpected response format:"
        pretty_print_response "$response"
        exit 1
    fi
}

main() {
    # Initialize
    init
    
    # Execute (all parameters are optional)
    get_memories "$@"
}

# Run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi