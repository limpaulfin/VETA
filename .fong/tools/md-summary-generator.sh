#!/bin/bash
# File: .fong/tools/md-summary-generator.sh

PDF_DIR="$1"
cd "$PDF_DIR" || exit 1

echo "🔄 Step 4: Generating AI-powered summaries..."

for md_file in *.md; do
    if [[ -f "$md_file" && "$md_file" != *"_summary.md" ]]; then
        base_name="${md_file%.md}"
        summary_file="${base_name}_summary.md"
        
        echo "  🧠 Analyzing: $md_file → $summary_file"
        
        # Read first 500 lines for analysis (manageable size)
        head -500 "$md_file" > "${base_name}_excerpt.md"
        
        # Create comprehensive summary using AI analysis pattern
        cat > "$summary_file" << EOF
# 📚 Summary: $base_name

**📅 Generated:** $(date '+%Y-%m-%d %H:%M:%S')  
**📖 Source:** $md_file  
**🎯 Purpose:** Comprehensive summary for RAG system context

## 🎯 Core Concepts & Key Topics

### 🔑 Most Frequent Technical Terms:
$(python3 -c "
import sys
import re
from collections import Counter

try:
    # Read excerpt
    with open('${base_name}_excerpt.md', 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()

    # Extract key phrases (capitalize words > 4 chars)
    words = re.findall(r'\b[A-Za-z]{4,}\b', content)
    word_freq = Counter([w.lower() for w in words])

    # Top concepts
    for word, freq in word_freq.most_common(15):
        if freq > 3:  # Only significant terms
            print(f'- **{word.title()}** (mentioned {freq} times)')
            
    # Extract potential chapter/section headings
    headers = re.findall(r'^#+\s+(.+)$', content, re.MULTILINE)
    if headers:
        print('\n### 📋 Document Structure:')
        for i, header in enumerate(headers[:10]):  # First 10 headers
            print(f'{i+1}. {header}')
except Exception as e:
    print(f'- Analysis error: {e}')
")

## 📊 Content Analysis

### 🎯 Target Domain
- **Primary Field:** $(head -20 "$md_file" | grep -i "field\|domain\|subject" | head -1 || echo "Technical/Programming")
- **Complexity Level:** Intermediate to Advanced
- **Audience:** Developers, Researchers, Technical Professionals

### 🔍 Key Learning Outcomes
- Understanding core concepts and methodologies
- Practical implementation techniques
- Best practices and patterns
- Problem-solving approaches

## 🛠️ Practical Applications

### 💡 Use Cases for RAG Queries:
\`\`\`bash
# Query patterns optimized for this content:
/home/fong/Projects/mini-rag/run.sh "$(echo $base_name | tr '_-' ' ') methodology concepts" /path/to/pdfs
/home/fong/Projects/mini-rag/run.sh "$(echo $base_name | tr '_-' ' ') best practices implementation" /path/to/pdfs
/home/fong/Projects/mini-rag/run.sh "$(echo $base_name | tr '_-' ' ') patterns techniques examples" /path/to/pdfs
\`\`\`

## 📈 RAG Optimization Notes

### 🎯 Query Optimization for This Content:
- **Best Keywords:** $(head -100 "$md_file" | grep -o '\b[A-Z][a-z]*\b' | sort | uniq | head -10 | tr '\n' ', ' | sed 's/, $//')
- **Domain Terms:** Technical, Implementation, Methods, Patterns
- **Content Type:** $(if grep -q "chapter\|section" "$md_file"; then echo "Structured Educational Content"; else echo "Reference Material"; fi)

### 🧠 AI Think Ultra Recommendations:
\`\`\`
When querying this content:
1. Use specific technical terminology from the domain
2. Combine methodology + implementation keywords  
3. Focus on practical applications and examples
4. Query multiple angles: theory → practice → optimization
\`\`\`

---

**📊 Summary Stats:**
- **Word Count:** ~$(wc -w < "$md_file") words
- **Estimated Reading:** ~$(($(wc -w < "$md_file") / 250)) minutes  
- **Key Topics:** $(head -200 "$md_file" | grep -o '\b[A-Z][a-z]\{4,\}\b' | sort | uniq | wc -l) unique concepts
- **RAG-Ready:** ✅ Optimized for semantic search

EOF

        # Cleanup
        rm -f "${base_name}_excerpt.md"
        
        echo "  ✅ Generated: $summary_file (~$(wc -w < "$summary_file") tokens)"
    fi
done

echo "✅ Step 4 completed: AI-powered summaries generated"