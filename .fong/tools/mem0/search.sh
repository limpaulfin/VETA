#!/bin/bash

# search.sh - Search memories in mem0 (Single Responsibility)
# Usage: ./search.sh <query> [project_name] [user_id] [top_k]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

show_usage() {
    echo "Usage: $0 <query> [project_name] [user_id] [top_k]"
    echo ""
    echo "Examples:"
    echo "  $0 'React development'"
    echo "  $0 'database configuration' 'my-project'"
    echo "  $0 'user preferences' 'my-project' 'user123' 20"
    echo ""
    echo "Description:"
    echo "  Searches for memories matching the query"
    echo "  Use --global flag to search across all projects"
    exit 1
}

create_search_filters() {
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

search_memories() {
    local query="$1"
    local project_name="${2:-}"
    local user_id="${3:-}"
    local top_k="${4:-$MEM0_DEFAULT_TOP_K}"
    
    echo "🔍 Searching memories..."
    echo "📝 Query: $query"
    [[ -n "$project_name" ]] && echo "📂 Project: $project_name"
    [[ -n "$user_id" ]] && echo "👤 User ID: $user_id"
    echo "📊 Top results: $top_k"
    echo ""
    
    # Create filters
    local filters=$(create_search_filters "$project_name" "$user_id")
    
    # Create payload
    local payload=$(cat <<EOF
{
  "query": "$query",
  "filters": $filters,
  "version": "$MEM0_DEFAULT_VERSION",
  "top_k": $top_k,
  "threshold": $MEM0_DEFAULT_THRESHOLD,
  "rerank": true
}
EOF
    )
    
    # Validate JSON payload
    if ! validate_json "$payload"; then
        exit 1
    fi
    
    echo "🚀 Calling API..."
    
    # Make API call
    local response=$(api_call "POST" "$MEM0_SEARCH_ENDPOINT" "$payload")
    
    # Check for API errors
    if ! check_api_error "$response"; then
        exit 1
    fi
    
    # Process response
    if echo "$response" | jq -e '.[0].id' > /dev/null 2>&1; then
        local result_count=$(echo "$response" | jq 'length')
        echo "✅ Found $result_count memories:"
        echo ""
        
        # Display formatted results
        echo "$response" | jq -r '.[] | 
            "🆔 ID: \(.id)",
            "💬 Memory: \(.memory)", 
            "👤 User: \(.user_id)",
            "📅 Created: \(.created_at)",
            "🏷️  Categories: \(.categories // [] | join(\", \"))",
            "📊 Metadata: \(.metadata // {})",
            "---"'
            
        # Save results for reference
        local results_file="/tmp/mem0-search-results-$(date +%Y%m%d-%H%M%S).json"
        echo "$response" | jq '.' > "$results_file"
        echo "📁 Results saved to: $results_file"
        
    elif echo "$response" | jq -e '. | length == 0' > /dev/null 2>&1; then
        echo "📭 No memories found matching your query"
    else
        echo "❌ Unexpected response format:"
        pretty_print_response "$response"
        exit 1
    fi
}

main() {
    # Initialize
    init
    
    # Check parameters
    if [[ $# -lt 1 ]]; then
        show_usage
    fi
    
    # Validate required parameters
    validate_required "query" "$1"
    
    # Execute
    search_memories "$@"
}

# Run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi