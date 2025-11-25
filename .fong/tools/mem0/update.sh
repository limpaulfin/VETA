#!/bin/bash

# update.sh - Update specific memory in mem0 (Single Responsibility)
# Usage: ./update.sh <memory_id> <new_content> [metadata_json]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

show_usage() {
    echo "Usage: $0 <memory_id> <new_content> [metadata_json]"
    echo ""
    echo "Examples:"
    echo "  $0 'uuid-id' 'Updated memory content'"
    echo "  $0 'uuid-id' 'New content' '{\"project\": \"updated-project\"}'"
    echo ""
    echo "Description:"
    echo "  Updates an existing memory by ID"
    exit 1
}

update_memory() {
    local memory_id="$1"
    local new_content="$2"
    local metadata="${3:-{}}"
    
    echo "🔄 Updating memory..."
    echo "🆔 Memory ID: $memory_id"
    echo "💬 New content: $new_content"
    echo "📊 Metadata: $metadata"
    echo ""
    
    # Validate metadata JSON
    if ! validate_json "$metadata"; then
        exit 1
    fi
    
    # Create payload
    local payload=$(cat <<EOF
{
  "text": "$new_content",
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
    local endpoint="${MEM0_UPDATE_ENDPOINT}${memory_id}/"
    local response=$(api_call "PUT" "$endpoint" "$payload")
    
    # Check for API errors
    if ! check_api_error "$response"; then
        exit 1
    fi
    
    # Process successful response
    if echo "$response" | jq -e '.id' > /dev/null 2>&1; then
        echo "✅ Memory updated successfully!"
        echo ""
        echo "$response" | jq -r '
            "🆔 ID: \(.id)",
            "💬 Content: \(.text // .memory)",
            "👤 User: \(.user_id // \"N/A\")",
            "📅 Created: \(.created_at)",
            "🔄 Updated: \(.updated_at)",
            "📊 Metadata: \(.metadata)"'
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
    validate_required "memory_id" "$1"
    validate_required "new_content" "$2"
    
    # Execute
    update_memory "$@"
}

# Run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi