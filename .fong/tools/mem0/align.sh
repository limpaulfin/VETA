#!/bin/bash

# align.sh - Align project memory with reality (Single Responsibility)
# Usage: ./align.sh <project_path> [project_name] [user_id]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

show_usage() {
    echo "Usage: $0 <project_path> [project_name] [user_id]"
    echo ""
    echo "Examples:"
    echo "  $0 '/home/user/my-project'"
    echo "  $0 '/home/user/my-project' 'custom-name' 'user123'"
    echo ""
    echo "Description:"
    echo "  Analyzes project structure and aligns memory with reality"
    exit 1
}

analyze_project_structure() {
    local project_path="$1"
    local analysis_file="$2"
    
    {
        echo "=== PROJECT ANALYSIS ==="
        echo "Path: $project_path"
        echo "Date: $(get_timestamp)"
        echo ""
        
        echo "=== TECH STACK ==="
        [[ -f package.json ]] && echo "- Node.js/JavaScript (package.json)"
        [[ -f requirements.txt ]] && echo "- Python (requirements.txt)"
        [[ -f Cargo.toml ]] && echo "- Rust (Cargo.toml)"
        [[ -f composer.json ]] && echo "- PHP (composer.json)"
        [[ -f pom.xml ]] && echo "- Java (pom.xml)"
        [[ -f go.mod ]] && echo "- Go (go.mod)"
        
        echo ""
        echo "=== DEPENDENCIES ==="
        if [[ -f package.json ]]; then
            echo "JavaScript:"
            jq -r '.dependencies // {} | keys[]' package.json 2>/dev/null | head -10 | sed 's/^/- /'
        fi
        
        if [[ -f requirements.txt ]]; then
            echo "Python:"
            head -10 requirements.txt | sed 's/^/- /'
        fi
        
        echo ""
        echo "=== STRUCTURE ==="
        tree -L 2 -I 'node_modules|venv|__pycache__|.git' . 2>/dev/null || find . -maxdepth 2 -type d | head -20
        
    } > "$analysis_file"
}

align_project_memory() {
    local project_path="$1"
    local project_name="${2:-$(basename "$project_path")}"
    local user_id="${3:-$(get_default_user_id "$project_name")}"
    
    echo "🔄 Aligning project memory with reality..."
    echo "📂 Project path: $project_path"
    echo "🏷️  Project name: $project_name"
    echo "👤 User ID: $user_id"
    echo ""
    
    # Validate project path
    if [[ ! -d "$project_path" ]]; then
        echo "❌ Project path does not exist: $project_path"
        exit 1
    fi
    
    cd "$project_path"
    
    # Analyze project
    echo "🔍 Analyzing project structure..."
    local analysis_file="/tmp/mem0-project-analysis-$(date +%Y%m%d-%H%M%S).txt"
    analyze_project_structure "$project_path" "$analysis_file"
    
    # Create memory content
    local memory_content="Project Analysis: $project_name
$(cat "$analysis_file")

Analysis completed: $(get_timestamp)
Auto-generated project structure and dependency analysis."
    
    # Add to mem0
    echo ""
    echo "💾 Saving analysis to mem0..."
    "$SCRIPT_DIR/add.sh" "$project_name" "$memory_content" "$user_id"
    
    # Create reference file
    local ref_file="$project_path/.fong-mem0-ref.json"
    cat > "$ref_file" <<EOF
{
  "project_name": "$project_name",
  "user_id": "$user_id", 
  "last_aligned": "$(get_timestamp)",
  "analysis_file": "$analysis_file",
  "commands": {
    "search": "$SCRIPT_DIR/search.sh 'project analysis' '$project_name' '$user_id'",
    "add": "$SCRIPT_DIR/add.sh '$project_name' '<content>' '$user_id'"
  }
}
EOF
    
    echo ""
    echo "✅ Alignment completed!"
    echo "📁 Analysis: $analysis_file"
    echo "🔗 Reference: $ref_file"
}

main() {
    # Initialize
    init
    
    # Check parameters
    if [[ $# -lt 1 ]]; then
        show_usage
    fi
    
    # Validate required parameters
    validate_required "project_path" "$1"
    
    # Execute
    align_project_memory "$@"
}

# Run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi