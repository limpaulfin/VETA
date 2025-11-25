#!/bin/bash
# File: .fong/tools/pdf-to-jpg-extractor.sh

PDF_DIR="$1"
DPI="${2:-300}"  # Default 300 DPI for high quality
cd "$PDF_DIR" || exit 1

echo "🔄 Step 3: Converting PDF pages to high-quality JPG (${DPI} DPI, Quality 95%)..."

for pdf_file in *.pdf; do
    if [[ -f "$pdf_file" ]]; then
        base_name="${pdf_file%.pdf}"
        jpg_dir="${base_name}_pages"
        
        echo "  🖼️  Processing: $pdf_file → $jpg_dir/"
        
        # Create directory for JPG pages
        mkdir -p "$jpg_dir"
        
        # Convert using pdftoppm with JPEG output (high quality, smaller size)
        pdftoppm -jpeg -jpegopt quality=95 -r "$DPI" "$pdf_file" "$jpg_dir/page" || {
            echo "  ❌ Failed to convert $pdf_file"
            continue
        }
        
        # Rename pages with proper padding
        cd "$jpg_dir" || continue
        page_count=$(ls page-*.jpg 2>/dev/null | wc -l)
        
        if [[ $page_count -gt 0 ]]; then
            # Rename with zero-padding for proper sorting
            for jpg_file in page-*.jpg; do
                if [[ -f "$jpg_file" ]]; then
                    page_num=$(echo "$jpg_file" | sed 's/page-//;s/\.jpg//')
                    padded_num=$(printf "%03d" "$page_num")
                    new_name="${base_name}_page_${padded_num}.jpg"
                    mv "$jpg_file" "$new_name"
                fi
            done
            
            echo "  ✅ Created $page_count JPG pages in $jpg_dir/"
        fi
        
        cd "$PDF_DIR" || exit 1
    fi
done

echo "✅ Step 3 completed: PDF to high-quality JPG extraction"