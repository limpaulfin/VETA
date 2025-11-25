#!/bin/bash

# add.sh - Add memory to mem0 (Single Responsibility)
# Usage: ./add.sh <project_name> <message_content> [user_id]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

show_usage() {
    echo "Usage: $0 <project_name> <message_content> [user_id]"
    echo ""
    echo "Examples:"
    echo "  $0 'my-project' 'User prefers React for frontend'"
    echo "  $0 'my-project' 'Database uses PostgreSQL' 'custom-user'"
    echo ""
    echo "Description:"
    echo "  Adds a new memory to the specified project"
    exit 1
}

add_memory() {
    local project_name="$1"
    local message_content="$2"
    local user_id="${3:-$(get_default_user_id "$project_name")}"
    
    echo "📝 Adding memory to project: $project_name"
    echo "👤 User ID: $user_id" 
    echo "💬 Content: $message_content"
    echo ""
    
    # Create metadata
    local metadata=$(create_metadata "$project_name")
    
    # Create payload
    local payload=$(cat <<EOF
{
  "messages": [
    {
      "role": "user", 
      "content": "$message_content"
    }
  ],
  "user_id": "$user_id",
  "version": "$MEM0_DEFAULT_VERSION",
  "metadata": $metadata
}
EOF
    )
    
    # Validate JSON payload
    if ! validate_json "$payload"; then
        exit 1
    fi
    
    echo "🚀 Calling API..."
    
    # Make API call
    local response=$(api_call "POST" "$MEM0_ADD_ENDPOINT" "$payload")
    
    # Check for API errors
    if ! check_api_error "$response"; then
        exit 1
    fi
    
    # Process successful response
    if echo "$response" | jq -e '.[0].id' > /dev/null 2>&1; then
        local memory_id=$(echo "$response" | jq -r '.[0].id')
        local memory_content=$(echo "$response" | jq -r '.[0].data.memory')
        
        echo "✅ Memory added successfully!"
        echo "🆔 Memory ID: $memory_id"
        echo "💾 Stored: $memory_content"
        echo ""
        echo "📄 Full Response:"
        pretty_print_response "$response"
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
    if [[ $# -lt 2 ]]; then
        show_usage
    fi
    
    # Validate required parameters
    validate_required "project_name" "$1"
    validate_required "message_content" "$2"
    
    # Execute
    add_memory "$@"
}

# Run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi