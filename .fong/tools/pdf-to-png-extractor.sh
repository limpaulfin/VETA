#!/bin/bash
# File: .fong/tools/pdf-to-png-extractor.sh

PDF_DIR="$1"
DPI="${2:-300}"  # Default 300 DPI for high quality
cd "$PDF_DIR" || exit 1

echo "🔄 Step 3: Converting PDF pages to high-quality PNG (${DPI} DPI)..."

for pdf_file in *.pdf; do
    if [[ -f "$pdf_file" ]]; then
        base_name="${pdf_file%.pdf}"
        png_dir="${base_name}_pages"
        
        echo "  🖼️  Processing: $pdf_file → $png_dir/"
        
        # Create directory for PNG pages
        mkdir -p "$png_dir"
        
        # Convert using pdftoppm (high quality)
        pdftoppm -png -r "$DPI" "$pdf_file" "$png_dir/page" || {
            echo "  ❌ Failed to convert $pdf_file"
            continue
        }
        
        # Rename pages with proper padding
        cd "$png_dir" || continue
        page_count=$(ls page-*.png 2>/dev/null | wc -l)
        
        if [[ $page_count -gt 0 ]]; then
            # Rename with zero-padding for proper sorting
            for png_file in page-*.png; do
                if [[ -f "$png_file" ]]; then
                    page_num=$(echo "$png_file" | sed 's/page-//;s/\.png//')
                    padded_num=$(printf "%03d" "$page_num")
                    new_name="${base_name}_page_${padded_num}.png"
                    mv "$png_file" "$new_name"
                fi
            done
            
            echo "  ✅ Created $page_count PNG pages in $png_dir/"
        fi
        
        cd "$PDF_DIR" || exit 1
    fi
done

echo "✅ Step 3 completed: PDF to high-quality PNG extraction"