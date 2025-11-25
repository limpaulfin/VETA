#!/bin/bash

# common.sh - Shared functions and utilities for mem0 scripts
# Following SOLID principles: Single Source of Truth for common operations

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load environment variables
load_config() {
    if [[ -f "$SCRIPT_DIR/.env" ]]; then
        # Export all variables from .env, handling variable expansion
        set -a
        source "$SCRIPT_DIR/.env"
        set +a
    else
        echo "❌ Error: .env file not found in $SCRIPT_DIR"
        exit 1
    fi
}

# Validate API key
validate_api_key() {
    if [[ -z "${MEM0_API_KEY:-}" ]]; then
        echo "❌ Error: MEM0_API_KEY not set in .env"
        exit 1
    fi
}

# Common curl wrapper for API calls
api_call() {
    local method="$1"
    local endpoint="$2"
    local data="${3:-}"
    local extra_headers="${4:-}"
    
    local curl_args=(
        -s
        --request "$method"
        --url "$endpoint"
        --header "Authorization: Token $MEM0_API_KEY"
        --header "Content-Type: application/json"
    )
    
    if [[ -n "$data" ]]; then
        curl_args+=(--data "$data")
    fi
    
    if [[ -n "$extra_headers" ]]; then
        curl_args+=("$extra_headers")
    fi
    
    curl "${curl_args[@]}"
}

# Validate JSON
validate_json() {
    local json="$1"
    if ! echo "$json" | jq . >/dev/null 2>&1; then
        echo "❌ Invalid JSON: $json"
        return 1
    fi
    return 0
}

# Format timestamp
get_timestamp() {
    date -u +%Y-%m-%dT%H:%M:%SZ
}

# Generate default user_id from project name
get_default_user_id() {
    local project_name="$1"
    echo "${project_name}-user"
}

# Validate required parameters
validate_required() {
    local param_name="$1"
    local param_value="$2"
    
    if [[ -z "$param_value" ]]; then
        echo "❌ Error: Required parameter '$param_name' is missing"
        return 1
    fi
    return 0
}

# Check if response contains error
check_api_error() {
    local response="$1"
    
    if echo "$response" | jq -e '.detail' > /dev/null 2>&1; then
        local error_msg=$(echo "$response" | jq -r '.detail')
        echo "❌ API Error: $error_msg"
        return 1
    fi
    return 0
}

# Pretty print JSON response
pretty_print_response() {
    local response="$1"
    echo "$response" | jq '.' 2>/dev/null || echo "$response"
}

# Create metadata object
create_metadata() {
    local project_name="$1"
    local extra_metadata="${2:-{}}"
    
    local base_metadata=$(cat <<EOF
{
    "project": "$project_name",
    "timestamp": "$(get_timestamp)",
    "category": "project-memory"
}
EOF
    )
    
    # Merge with extra metadata if provided
    if [[ "$extra_metadata" != "{}" ]]; then
        echo "$base_metadata" | jq ". + $extra_metadata"
    else
        echo "$base_metadata"
    fi
}

# Initialize (load config and validate)
init() {
    load_config
    validate_api_key
}

# Export functions for other scripts to use
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    # Being sourced, export functions
    export -f load_config validate_api_key api_call validate_json get_timestamp
    export -f get_default_user_id validate_required check_api_error pretty_print_response
    export -f create_metadata init
fi