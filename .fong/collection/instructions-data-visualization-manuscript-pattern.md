# Instructions: Data Visualization for Academic Manuscript Pattern

## Overview
Hướng dẫn chi tiết để tạo data visualizations cho manuscript học thuật sử dụng Python và embed vào Markdown files.

## Pattern này áp dụng cho:
- Academic manuscripts với nhiều tables/charts/diagrams
- Research papers cần professional visualizations
- Tiểu luận và báo cáo khoa học với data analysis
- Bất kỳ document nào có complex data cần trực quan hóa

## Workflow Pattern

### Bước 1: Chuẩn bị và phân tích
1. **Đọc toàn bộ manuscript files** để identify:
   - Các bảng dữ liệu cần visualize
   - Frameworks và flowcharts cần convert
   - Charts, graphs, diagrams cần tạo
   - Spider/radar diagrams
   - Timeline và Gantt charts
   
2. **Tạo folder structure**:
   ```bash
   manuscript/
   ├── python-visualizations/     # Python scripts
   ├── images/                   # Output images
   └── [manuscript-files].md     # Original content
   ```

### Bước 2: Python Scripts Organization

#### File Structure Pattern:
```
01_[category]_charts.py          # Ví dụ: performance, market analysis
02_[category]_analysis.py        # Ví dụ: gap analysis, benchmarking  
03_[category]_timeline.py        # Ví dụ: implementation, roadmaps
generate_all_charts.py           # Master script
```

#### Python Template Pattern:
```python
#!/usr/bin/env python3
"""
[Category] Generator
Mô tả ngắn gọn về charts được tạo
"""

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns

# Cấu hình font tiếng Việt
plt.rcParams['font.family'] = ['DejaVu Sans']

def create_[chart_name]():
    """Tạo chart cụ thể với mô tả rõ ràng"""
    # Data preparation
    # Chart creation
    # Styling and labels
    # Save to images folder
    plt.savefig('/path/to/images/chart_name.png', dpi=300, bbox_inches='tight')
    plt.close()
    print("✓ Tạo [chart_name] thành công")

if __name__ == "__main__":
    # Run all chart functions
    create_[chart_name]()
```

### Bước 3: Chart Categories Templates

#### 1. Performance Charts (01_*.py)
- **Bar charts**: Revenue, profit, market share
- **Line charts**: Trends over time
- **Pie charts**: Market composition
- **Combo charts**: Multiple metrics

#### 2. Analysis Charts (02_*.py)  
- **Spider/Radar diagrams**: Gap analysis, capability assessment
- **Heatmaps**: Readiness assessment, maturity levels
- **Scatter plots**: Benchmarking, correlation analysis
- **Matrix charts**: Risk assessment, prioritization

#### 3. Timeline Charts (03_*.py)
- **Gantt charts**: Implementation timeline
- **Waterfall charts**: ROI analysis, cost-benefit
- **Resource pyramids**: Organizational structure, budget allocation
- **Flow diagrams**: Process workflows

### Bước 4: Master Script Pattern

```python
#!/usr/bin/env python3
"""
Master Script - Generate All Charts
Template for running all visualization scripts
"""

import subprocess
import sys
from pathlib import Path

def install_requirements():
    """Cài đặt thư viện cần thiết"""
    requirements = ['matplotlib', 'seaborn', 'pandas', 'numpy']
    for package in requirements:
        try:
            subprocess.check_call([sys.executable, "-m", "pip", "install", package])
        except:
            print(f"⚠ Không thể cài đặt {package}")

def run_script(script_name):
    """Chạy Python script và handle errors"""
    # Implementation similar to provided example

def check_images_created():
    """Verify all expected images were generated"""
    # Implementation to check image files exist

if __name__ == "__main__":
    # Main execution flow
```

### Bước 5: Embedding Pattern

#### Image Reference Format:
```markdown
**[Title]: [Description]**

![Alt Text](images/image_name.png)

*Nguồn: [Source information]*
```

#### Common Embedding Locations:
1. **Tables** → Replace với bar/pie charts
2. **Framework descriptions** → Add radar/spider diagrams  
3. **Timeline sections** → Insert Gantt charts
4. **Financial analysis** → Include waterfall charts
5. **Comparison sections** → Add benchmark charts

### Bước 6: Quality Assurance Checklist

#### Technical Quality:
- [ ] All images generated successfully (300 DPI minimum)
- [ ] Consistent styling across all charts
- [ ] Vietnamese text rendering correctly
- [ ] Appropriate chart types for data
- [ ] Color scheme professional và accessible

#### Content Quality:
- [ ] All data accurately represented
- [ ] Chart titles descriptive và informative
- [ ] Legends clear và complete
- [ ] Axis labels appropriate
- [ ] Sources properly attributed

#### Integration Quality:
- [ ] Images properly embedded in markdown
- [ ] Alt text descriptive
- [ ] Consistent file naming convention
- [ ] Images enhance rather than duplicate text
- [ ] Proper image sizing và alignment

## Naming Conventions

### File Naming:
- **Python scripts**: `01_category_description.py`
- **Images**: `category_specific_name.png`
- **Master script**: `generate_all_charts.py`

### Image Naming Examples:
- `vinamilk_performance_2020_2024.png`
- `vietnam_dairy_market_share.png`
- `iso_9001_benefits.png`
- `gap_analysis_spider_diagram.png`
- `implementation_gantt_chart.png`
- `roi_waterfall_chart.png`

## Error Handling Patterns

### Common Issues và Solutions:
1. **Font rendering**: Use DejaVu Sans for Vietnamese
2. **Package installation**: Handle gracefully với try/catch
3. **Image save paths**: Use absolute paths
4. **Memory management**: Close matplotlib figures
5. **Data formatting**: Validate before plotting

### Debug Pattern:
```python
try:
    create_chart()
    print("✓ Chart created successfully")
except Exception as e:
    print(f"❌ Error creating chart: {e}")
    # Log error details
    return False
```

## Customization Guidelines

### Color Schemes:
- **Professional**: Blues, grays, dark colors
- **Academic**: Consistent color palette
- **Accessibility**: High contrast, colorblind-friendly

### Chart Styling:
- **Fonts**: Sans-serif, readable sizes (10-14pt)
- **Grid**: Subtle, non-distracting
- **Labels**: Clear, concise
- **Legend**: Positioned appropriately

## Advanced Patterns

### Interactive Elements:
- Hover effects for web version
- Clickable elements
- Animation for presentations

### Multi-language Support:
- Language detection
- Font switching
- Label translation

### Export Options:
- Multiple format support (PNG, SVG, PDF)
- Resolution options
- Print optimization

## Reusability Tips

### Template Reuse:
1. **Copy entire folder structure**
2. **Update data sources**  
3. **Modify chart titles/labels**
4. **Adjust color schemes**
5. **Run master script**

### Configuration Files:
- Create config.json for common settings
- Externalize data sources
- Parameterize chart dimensions

## Success Metrics

### Completion Indicators:
- All Python scripts run without errors
- All expected images generated
- Images properly embedded in manuscript
- Visual quality meets academic standards
- Manuscript flow improved với visualizations

### Performance Metrics:
- Script execution time < 5 minutes
- Image file sizes optimized (< 1MB each)
- No duplicate or unnecessary images
- Clear improvement in document readability

## Extensions và Future Improvements

### Possible Enhancements:
- Automated data source integration
- Template library expansion
- Version control for chart updates  
- Batch processing for multiple manuscripts
- Cloud deployment options

## Conclusion

Pattern này provides a systematic approach để create professional data visualizations for academic manuscripts, ensuring consistency, quality, và reusability across different projects.

**Key Benefits:**
- ✅ Consistent professional appearance
- ✅ Automated generation process  
- ✅ Easy maintenance và updates
- ✅ Scalable for large documents
- ✅ Reusable template structure

---

*Created: 2025-09-14*  
*Project: Vinamilk Quality Management Research*  
*Usage: Academic manuscript data visualization*