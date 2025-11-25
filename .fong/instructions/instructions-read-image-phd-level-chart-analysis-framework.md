# Framework Phân Tích Biểu Đồ/Đồ Thị Cấp Độ Tiến Sĩ

## CLAUDE CODE IMPLEMENTATION NOTE
**Để đọc và phân tích ảnh/biểu đồ, Claude Code sử dụng tool Read với đầy đủ khả năng vision (không chỉ OCR):**
```
Read(file_path="/path/to/image.png")
```
Tool này cho phép Claude Code:
- Nhận diện visual elements (colors, shapes, patterns)
- Đọc text và số liệu trong ảnh
- Phân tích relationships và trends
- Hiểu context và meaning của biểu đồ

## I. FRAMEWORK TỔNG QUÁT (5 Tầng Phân Tích)

### Tầng 1: Nhận Diện Cơ Bản (Identification)
- **Loại biểu đồ**: ROC, Box plot, Heatmap, Time series, Bar chart, etc.
- **Các thành phần**: Trục, legend, title, units, scale
- **Số lượng biến**: Univariate, bivariate, multivariate
- **Kích thước mẫu**: N = ?
- **Nguồn dữ liệu**: Dataset, thời gian thu thập

### Tầng 2: Đọc Hiểu Kỹ Thuật (Technical Reading)
- **Metrics chính**: 
  - Với ROC: AUC, sensitivity, specificity, cut-off points
  - Với regression: R², RMSE, MAE, residuals
  - Với classification: Precision, recall, F1-score
- **Thống kê mô tả**: Mean, median, SD, CI, p-values
- **Patterns**: Trends, outliers, clusters, distributions
- **Relationships**: Linear/non-linear, correlations, interactions

### Tầng 3: Phân Tích Sâu (Deep Analysis)
- **So sánh models/methods**: Performance gaps, trade-offs
- **Statistical significance**: Hypothesis testing, confidence intervals
- **Assumptions checking**: Normality, homoscedasticity, independence
- **Bias detection**: Selection bias, measurement bias, confounding
- **Generalizability**: External validity, population representativeness

### Tầng 4: Diễn Giải Khoa Học (Scientific Interpretation)
- **Clinical/practical significance**: Effect size, NNT, clinical relevance
- **Theoretical implications**: Supports/contradicts existing theories?
- **Methodological strengths/weaknesses**: Study design limitations
- **Alternative explanations**: Competing hypotheses
- **Context integration**: How fits with literature?

### Tầng 5: Tư Duy Phản Biện (Critical Thinking)
- **What's missing?**: Unreported metrics, hidden assumptions
- **Potential manipulation**: Cherry-picking, p-hacking, overfitting
- **Reproducibility concerns**: Enough detail to replicate?
- **Ethical considerations**: Fairness, bias in algorithms
- **Future directions**: What questions remain unanswered?

## II. CHECKLIST CÂU HỎI CHO TỪNG LOẠI BIỂU ĐỒ

### A. ROC Curves (như ảnh vừa xem)
1. **Basic Questions**:
   - Có bao nhiêu models được so sánh?
   - AUC của từng model là bao nhiêu?
   - Model nào tốt nhất/tệ nhất?

2. **Advanced Questions**:
   - Optimal cut-off point ở đâu (Youden's index)?
   - Trade-off giữa sensitivity và specificity như thế nào?
   - Có overlap của CI không? (nếu có CI bands)
   - Cost-benefit analysis cho different thresholds?

3. **PhD-Level Questions**:
   - Class imbalance có ảnh hưởng AUC không?
   - Precision-Recall curve sẽ khác thế nào?
   - Calibration của models như thế nào?
   - DeLong test cho AUC comparison?
   - Net reclassification improvement (NRI)?

### B. Survival Curves (Kaplan-Meier)
1. **Basic**: Median survival, survival rates at timepoints
2. **Advanced**: Log-rank test, hazard ratios, censoring patterns
3. **PhD-Level**: Competing risks, time-varying covariates, informative censoring

### C. Forest Plots (Meta-analysis)
1. **Basic**: Overall effect size, individual study effects
2. **Advanced**: Heterogeneity (I²), fixed vs random effects
3. **PhD-Level**: Publication bias, sensitivity analysis, meta-regression

### D. Heatmaps/Correlation Matrices
1. **Basic**: Strongest/weakest correlations
2. **Advanced**: Clustering patterns, multicollinearity
3. **PhD-Level**: Partial correlations, network analysis, causal inference

## III. FRAMEWORK VIẾT BÁO CÁO PHÂN TÍCH

### 1. Executive Summary (1 paragraph)
- Main finding in 1 sentence
- Key metrics
- Clinical/practical implication

### 2. Technical Analysis (3-4 paragraphs)
- **Para 1**: What the figure shows (descriptive)
- **Para 2**: Key quantitative findings
- **Para 3**: Comparative analysis
- **Para 4**: Limitations and caveats

### 3. Implications (2 paragraphs)
- **Para 1**: Scientific/theoretical implications
- **Para 2**: Practical/clinical applications

### 4. Critical Assessment (1-2 paragraphs)
- Strengths and weaknesses
- Suggestions for improvement
- Remaining questions

## IV. RED FLAGS KHI ĐỌC BIỂU ĐỒ

### Visual Manipulation
- Y-axis không bắt đầu từ 0
- Scales không đồng nhất
- Cherry-picked time windows
- Misleading color schemes

### Statistical Issues
- No confidence intervals
- Multiple testing without correction
- Post-hoc subgroup analysis
- Data dredging signs

### Reporting Problems
- Missing sample sizes
- No effect sizes, only p-values
- Selective outcome reporting
- Composite endpoints không rõ ràng

## V. TOOLS & TECHNIQUES

### Quantitative Extraction
- Sử dụng WebPlotDigitizer cho data extraction
- Cross-check với reported values
- Calculate unreported metrics

### Validation Checks
- Internal consistency (numbers add up?)
- External validity (generalizable?)
- Face validity (makes sense?)

### Documentation
- Screenshot với annotations
- Structured notes theo framework
- Version control cho analyses

## VI. EXAMPLE ANALYSIS (Áp dụng cho ROC curve vừa xem)

### Level 1 - Basic
"Đây là ROC curve so sánh 11 models cho binary classification, với Voting Classifier cho AUC cao nhất (0.79)"

### Level 2 - Technical
"ROC analysis reveals ensemble methods (Voting, GB, RF) achieving AUC ~0.79, significantly outperforming simple models like QDA (0.58) and MLP (0.51). The 0.28 AUC gap suggests substantial performance differences in discriminative ability."

### Level 3 - Deep Analysis  
"The clustering of top performers (AUC 0.76-0.79) suggests possible performance ceiling, potentially due to feature limitations or irreducible noise. The poor MLP performance (0.51) indicates either insufficient training data, poor hyperparameter tuning, or inappropriate architecture for this problem."

### Level 4 - Scientific Interpretation
"The success of ensemble methods over neural networks contradicts deep learning superiority claims, supporting the 'no free lunch theorem'. For medical applications, the 0.79 AUC may be insufficient for clinical deployment without additional validation and calibration studies."

### Level 5 - Critical Thinking
"Missing: confidence intervals, validation cohort results, calibration plots, decision curve analysis. Questions: Why MLP underperforms? Is class imbalance affecting results? Would AUROC be more appropriate? Cost-sensitive evaluation needed for medical context."

---

## PRACTICAL CHECKLIST KHI ĐỌC BIỂU ĐỒ

☐ Identify: Loại biểu đồ, các thành phần
☐ Measure: Đọc chính xác các giá trị
☐ Compare: So sánh giữa các nhóm/models
☐ Patterns: Tìm trends, outliers
☐ Statistics: Check significance, CI
☐ Context: Đặt trong bối cảnh nghiên cứu
☐ Critique: Tìm weaknesses, biases
☐ Implications: Clinical/practical meaning
☐ Questions: What's next? What's missing?
☐ Document: Ghi chép có hệ thống