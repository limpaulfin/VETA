#!/bin/bash
# File: .fong/tools/pdf-filename-sanitizer.sh

PDF_DIR="$1"
SKIP_RENAME="${2:-false}"  # Optional parameter to skip rename

if [[ ! -d "$PDF_DIR" ]]; then
    echo "❌ Directory not found: $PDF_DIR"
    exit 1
fi

cd "$PDF_DIR" || exit 1

# Function to generate SHORT, meaningful filenames
generate_short_filename() {
    local original_name="$1"
    local base_name="${original_name%.pdf}"
    
    # Convert to lowercase and extract meaningful words
    local clean_base=$(echo "$base_name" | tr '[:upper:]' '[:lower:]')
    
    # Remove common stop words and metadata patterns
    clean_base=$(echo "$clean_base" | sed -E '
        s/\b(the|and|to|of|for|in|on|at|by|with|from|a|an)\b//g
        s/\b(edition|version|guide|handbook|manual|book|press|publishing|publisher|publication|inc|incorporated|ltd|limited|co|company)\b//g
        s/\b(anna.{0,2}s.{0,2}archive|bookzz\.org|pdf|ebook|download)\b//g
        s/\b[0-9]{4}-[0-9]{2}-[0-9]{2}\b//g
        s/\b[0-9]{8,}\b//g
        s/\b[a-f0-9]{32}\b//g
        s/--+/-/g
        s/;;+/;/g
        s/\s+/ /g
    ')
    
    # Extract 2-3 most meaningful words (avoid very short words)
    local key_words=()
    for word in $clean_base; do
        # Clean each word and check if meaningful
        word=$(echo "$word" | sed 's/[^a-zA-Z0-9]//g')
        if [[ ${#word} -ge 3 && ${#key_words[@]} -lt 3 ]]; then
            key_words+=("$word")
        fi
    done
    
    # If no good words found, use first few chars of original
    if [[ ${#key_words[@]} -eq 0 ]]; then
        local fallback=$(echo "$base_name" | sed 's/[^a-zA-Z0-9]//g' | tr '[:upper:]' '[:lower:]')
        key_words+=("${fallback:0:15}")
    fi
    
    # Join with hyphens (OS-friendly) and limit total length
    local result=$(printf "%s-" "${key_words[@]}")
    result="${result%-}"  # Remove trailing hyphen
    
    # Truncate if too long (keep reasonable length ~30 chars max)
    if [[ ${#result} -gt 30 ]]; then
        result="${result:0:30}"
    fi
    
    # Ensure it ends with .pdf
    echo "${result}.pdf"
}

echo "🔄 Step 1: Checking PDF filenames..."

# Check for problematic filenames
problematic_files=()
for pdf_file in *.pdf; do
    if [[ -f "$pdf_file" ]]; then
        # Check if filename has issues (spaces, special chars, too long)
        if [[ "$pdf_file" =~ [[:space:]\;\&\|\(\)\[\]\{\}\'\"\`\~\!\@\#\$\%\^\*\+\=\<\>\?] ]] || [[ ${#pdf_file} -gt 100 ]]; then
            problematic_files+=("$pdf_file")
        fi
    fi
done

if [[ ${#problematic_files[@]} -gt 0 ]]; then
    echo "⚠️  FOUND PROBLEMATIC FILENAMES:"
    echo ""
    
    for pdf_file in "${problematic_files[@]}"; do
        # Generate SHORT and meaningful filename
        clean_name=$(generate_short_filename "$pdf_file")
        
        echo "📁 CURRENT: '$pdf_file'"
        echo "💡 SUGGEST: '$clean_name'"
        echo "   Issues: $(if [[ "$pdf_file" =~ [[:space:]] ]]; then echo "spaces "; fi)$(if [[ "$pdf_file" =~ [\;\&\|\(\)\[\]\{\}\'\"\`\~\!\@\#\$\%\^\*\+\=\<\>\?] ]]; then echo "special-chars "; fi)$(if [[ ${#pdf_file} -gt 100 ]]; then echo "too-long"; fi)"
        echo "   Length: $(echo -n "$pdf_file" | wc -c) chars → $(echo -n "$clean_name" | wc -c) chars"
        echo ""
    done
    
    if [[ "$SKIP_RENAME" == "false" ]]; then
        echo "❓ Do you want to rename these files to OS-friendly names?"
        echo "   Type 'yes' to proceed with rename, 'no' to continue without renaming:"
        read -r user_response
        
        if [[ "$user_response" == "yes" || "$user_response" == "y" ]]; then
            echo "✅ User confirmed: Proceeding with renaming..."
            
            for pdf_file in "${problematic_files[@]}"; do
                clean_name=$(generate_short_filename "$pdf_file")
                
                echo "  ✅ Renaming: '$pdf_file' → '$clean_name'"
                mv "$pdf_file" "$clean_name"
            done
        else
            echo "ℹ️  User declined: Continuing without renaming files"
            echo "⚠️  Note: Some tools may have issues with special characters in filenames"
        fi
    else
        echo "ℹ️  SKIP_RENAME mode: Continuing without renaming files"
        echo "⚠️  Note: Some tools may have issues with special characters in filenames"
    fi
else
    echo "✅ All PDF filenames are already OS-friendly"
fi

echo "✅ Step 1 completed: Filename check finished"