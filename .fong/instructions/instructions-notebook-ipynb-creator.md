---
description: "General framework cho tạo notebook nghiên cứu với auto-debug, shared seed, và consistent outputs"
version: "2025-09-04T22:00:00Z"
context: "General Research Notebook Framework - Project Agnostic"  
reference: "Map từ instructions-autodebug-notebook.md"
session_id: "2025-09-04--09-01-pm"
conversation_id: "c2b3f9bd-d58a-41a9-8155-e4826841582e"
---

# 📓 INSTRUCTIONS: GENERAL RESEARCH NOTEBOOK CREATOR

## 🎯 MỤC ĐÍCH

Framework tổng quát cho bất kỳ dự án nghiên cứu nào:
1. **Consistency**: Chung nguồn dữ liệu, chung .venv, chung random seed
2. **Auto-Debug**: Tự động fix lỗi cho tới khi works (integration với fonglog)
3. **Reproducible**: 100% tái hiện được kết quả
4. **Summary Report**: File tổng kết cuối cùng giải thích ý nghĩa kết quả
5. **General Structure**: Áp dụng được cho mọi loại project

## 🏗️ GENERAL NOTEBOOK DIRECTORY STRUCTURE

### **Consistent Pattern for Any Research Project**
```
{PROJECT_ROOT}/notebooks/
├── 00_shared_setup/                   # Chung cho mọi project
│   ├── shared_config.py              # Global config & seeds
│   ├── data_validator.py             # Data quality checker  
│   └── result_summarizer.py          # Final report generator
├── 01_data_exploration/               # Khám phá dữ liệu
│   ├── data_exploration.ipynb
│   └── results/                      
│       ├── data_overview.csv         # CONSISTENT: Luôn có file này
│       ├── data_quality.json         # CONSISTENT: Quality metrics
│       └── data_distribution.png     # CONSISTENT: Visualization
├── 02_preprocessing/                  # Xử lý dữ liệu
│   ├── data_preprocessing.ipynb
│   └── results/
│       ├── processed_data.csv        # CONSISTENT: Processed dataset
│       ├── preprocessing_log.json    # CONSISTENT: Processing steps
│       └── before_after_comparison.png
├── 03_baseline_models/               # Baseline (for comparison)
│   ├── baseline_models.ipynb
│   └── results/
│       ├── baseline_predictions.csv  # CONSISTENT: Model outputs
│       ├── baseline_metrics.json     # CONSISTENT: Performance
│       └── baseline_plots.png
├── 04_main_models/                   # Primary models của project
│   ├── model_*.ipynb                 # Model-specific notebooks
│   └── results/
│       ├── model_predictions.csv     # CONSISTENT: Predictions
│       ├── model_metrics.json        # CONSISTENT: Performance
│       ├── model_artifacts/          # Saved models
│       └── model_analysis.png
├── 05_comparison/                    # So sánh models
│   ├── model_comparison.ipynb
│   └── results/
│       ├── comparison_matrix.csv     # CONSISTENT: All results
│       ├── ranking.json              # CONSISTENT: Model ranking
│       └── comparison_charts.png
└── 99_final_summary/                 # Tổng kết cuối cùng
    ├── final_summary.ipynb           # REQUIRED: Summary report
    └── results/
        ├── FINAL_SUMMARY.md          # REQUIRED: Human-readable
        ├── key_findings.json         # REQUIRED: Machine-readable
        └── summary_dashboard.png     # REQUIRED: Visual summary
```

## 🔧 GENERAL SHARED CONFIGURATION SYSTEM

### **00_shared_setup/shared_config.py** - Universal Config
```python
"""
GENERAL shared configuration cho bất kỳ research project nào
CRITICAL: Đảm bảo consistency across all notebooks
"""

import numpy as np
import pandas as pd
import random
import os
import sys
from datetime import datetime
from pathlib import Path

# ========================================
# CONSISTENCY REQUIREMENTS - MANDATORY
# ========================================
GLOBAL_SEED = 42  # FIXED SEED cho 100% reproducibility

# AUTO-DETECT PROJECT ENVIRONMENT
project_root = Path.cwd()
while not (project_root / '.venv').exists() and project_root != project_root.parent:
    project_root = project_root.parent

if not (project_root / '.venv').exists():
    raise RuntimeError("❌ Cannot find .venv directory - ensure project has virtual environment")

print(f"📁 Project root: {project_root}")
print(f"🐍 Using venv: {project_root / '.venv'}")

# ENVIRONMENT PATHS
ENV_CONFIG = {
    'project_root': project_root,
    'venv_path': project_root / '.venv',
    'notebooks_dir': project_root / 'notebooks',
    'data_dir': project_root / 'data',  # Default data location
    'output_dir': project_root / 'outputs',
    'logs_dir': project_root / 'logs'
}

# Ensure all directories exist
for path in ENV_CONFIG.values():
    if isinstance(path, Path):
        path.mkdir(exist_ok=True)

def set_all_seeds(seed=None):
    """Set ALL random seeds for 100% reproducibility"""
    if seed is None:
        seed = GLOBAL_SEED
    
    # Python random
    random.seed(seed)
    os.environ['PYTHONHASHSEED'] = str(seed)
    
    # NumPy
    np.random.seed(seed)
    
    # PyTorch (if available)
    try:
        import torch
        torch.manual_seed(seed)
        torch.cuda.manual_seed(seed)
        torch.cuda.manual_seed_all(seed)
        torch.backends.cudnn.deterministic = True
        torch.backends.cudnn.benchmark = False
        print(f"🔥 PyTorch seeds set: {seed}")
    except ImportError:
        print("⚠️  PyTorch not available - skipping torch seeds")
    
    # TensorFlow (if available)
    try:
        import tensorflow as tf
        tf.random.set_seed(seed)
        print(f"🧠 TensorFlow seed set: {seed}")
    except ImportError:
        print("⚠️  TensorFlow not available - skipping tf seeds")
    
    print(f"🎯 All available seeds set to: {seed}")
    return seed

# ========================================
# GENERAL PROJECT CONFIGURATION
# ========================================
PROJECT_CONFIG = {
    'global_seed': GLOBAL_SEED,
    'timestamp': datetime.now().isoformat(),
    'python_version': sys.version,
    'working_directory': str(Path.cwd()),
    'environment_type': 'jupyter_notebook'
}

# ========================================
# CONSISTENT OUTPUT CONFIGURATION
# ========================================
OUTPUT_CONFIG = {
    'consistent_files': {
        'data_overview': 'data_overview.csv',
        'data_quality': 'data_quality.json', 
        'processed_data': 'processed_data.csv',
        'model_predictions': 'predictions.csv',
        'model_metrics': 'metrics.json',
        'comparison_matrix': 'comparison.csv',
        'final_summary': 'FINAL_SUMMARY.md'
    },
    'required_plots': {
        'data_visualization': 'data_plots.png',
        'model_performance': 'performance.png',
        'comparison_charts': 'comparison.png',
        'summary_dashboard': 'summary.png'
    }
}

# ========================================
# GENERAL VISUALIZATION CONFIG
# ========================================
VIZ_CONFIG = {
    'style': 'default',  # Works across all matplotlib versions
    'figure_size': (12, 8),
    'dpi': 300,
    'font_size': 12,
    'title_size': 14,
    'save_format': 'png',
    'bbox_inches': 'tight',
    'colors': {
        'primary': '#1f77b4',    # Blue
        'secondary': '#ff7f0e',  # Orange  
        'success': '#2ca02c',    # Green
        'warning': '#d62728',    # Red
        'info': '#9467bd',       # Purple
        'neutral': '#8c8c8c'     # Gray
    }
}

# ========================================
# CONSISTENCY UTILITY FUNCTIONS
# ========================================
def get_notebook_output_dir(notebook_name):
    """Get consistent output directory for any notebook"""
    output_dir = ENV_CONFIG['notebooks_dir'] / notebook_name / 'results'
    output_dir.mkdir(parents=True, exist_ok=True)
    return output_dir

def save_consistent_results(data, filename, notebook_name, file_type='csv'):
    """Save results with consistent naming và structure"""
    output_dir = get_notebook_output_dir(notebook_name)
    
    # Enforce consistent filenames
    if filename in OUTPUT_CONFIG['consistent_files']:
        filename = OUTPUT_CONFIG['consistent_files'][filename]
    
    if file_type == 'csv' and hasattr(data, 'to_csv'):
        filepath = output_dir / filename if filename.endswith('.csv') else output_dir / f"{filename}.csv"
        data.to_csv(filepath, index=False)
    elif file_type == 'json':
        filepath = output_dir / filename if filename.endswith('.json') else output_dir / f"{filename}.json"
        import json
        with open(filepath, 'w') as f:
            json.dump(data, f, indent=2, default=str)
    else:
        filepath = output_dir / filename
        
    print(f"💾 Consistent results saved: {filepath}")
    return filepath

def log_notebook_execution(notebook_name):
    """Log notebook execution với full environment info"""
    execution_log = {
        'notebook': notebook_name,
        'timestamp': datetime.now().isoformat(),
        'global_seed': GLOBAL_SEED,
        'project_root': str(ENV_CONFIG['project_root']),
        'venv_path': str(ENV_CONFIG['venv_path']),
        'python_version': PROJECT_CONFIG['python_version'],
        'working_directory': PROJECT_CONFIG['working_directory']
    }
    
    save_consistent_results(execution_log, 'execution_log', notebook_name, 'json')
    print(f"📝 Execution logged: {notebook_name}")
    return execution_log

def validate_environment():
    """Validate environment consistency before running"""
    checks = {
        'venv_exists': ENV_CONFIG['venv_path'].exists(),
        'notebooks_dir_exists': ENV_CONFIG['notebooks_dir'].exists(),
        'data_dir_accessible': ENV_CONFIG['data_dir'].exists() or True,  # May not exist initially
        'seed_set': GLOBAL_SEED is not None
    }
    
    all_passed = all(checks.values())
    
    if all_passed:
        print("✅ Environment validation passed")
    else:
        print("❌ Environment validation failed:")
        for check, status in checks.items():
            if not status:
                print(f"  - {check}: FAILED")
        raise RuntimeError("Environment validation failed")
    
    return checks

# ========================================  
# INITIALIZATION
# ========================================
# Automatically set seeds when module is imported
_ = set_all_seeds(GLOBAL_SEED)
print(f"🔬 Scientific Research Configuration Loaded")
print(f"📊 Project: {PROJECT_CONFIG['project_name']}")
print(f"🎲 Global Seed: {GLOBAL_SEED}")
```

## 📓 NOTEBOOK TEMPLATE GENERATOR

### **Scientific Notebook Template**
```python
"""
Template Generator cho Scientific Research Notebooks
Tạo notebook structure với best practices cho reproducible research
"""

NOTEBOOK_TEMPLATE = {
    'metadata': {
        'kernelspec': {
            'display_name': 'Python 3',
            'language': 'python',
            'name': 'python3'
        },
        'language_info': {
            'name': 'python',
            'version': '3.10+'
        }
    },
    
    'cells': [
        # Cell 1: Header & Documentation
        {
            'cell_type': 'markdown',
            'source': [
                f'# {{notebook_title}}\n',
                f'\n',
                f'**Research Project**: Co-Linh Livestream Forecasting\n',
                f'**Notebook Purpose**: {{purpose}}\n', 
                f'**Author**: Research Team\n',
                f'**Date**: {{date}}\n',
                f'**Reproducibility Seed**: {{seed}}\n',
                f'\n',
                f'## Research Context\n',
                f'{{context}}\n',
                f'\n',
                f'## Expected Outcomes\n',
                f'{{outcomes}}\n',
                f'\n',
                f'## Methodology\n',
                f'{{methodology}}\n'
            ]
        },
        
        # Cell 2: Setup & Imports
        {
            'cell_type': 'code',
            'source': [
                '# ========================================\n',
                '# SETUP & IMPORTS - SCIENTIFIC RESEARCH\n', 
                '# ========================================\n',
                '\n',
                '# Core scientific libraries\n',
                'import numpy as np\n',
                'import pandas as pd\n',
                'import matplotlib.pyplot as plt\n',
                'import seaborn as sns\n',
                'from scipy import stats\n',
                'from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score\n',
                '\n',
                '# Project configuration\n',
                'import sys\n',
                'sys.path.append("../")  # Add notebooks2/ to path\n', 
                'from shared_config import *\n',
                '\n',
                '# Auto-debug integration\n',
                'sys.path.append("../../src/")\n',
                'from fonglog import init_notebook, get_logger\n',
                '\n',
                '# Initialize reproducibility\n',
                'experiment_seed = set_all_seeds(GLOBAL_SEED)\n',
                '\n',
                '# Initialize notebook logging\n',
                'notebook_name = "{{notebook_name}}"\n',
                'logger = init_notebook(notebook_name)\n',
                '\n', 
                '# Configure scientific plotting\n',
                'plt.style.use(VIZ_CONFIG["style"])\n',
                'plt.rcParams.update({\n',
                '    "figure.figsize": VIZ_CONFIG["figure_size"],\n',
                '    "figure.dpi": VIZ_CONFIG["dpi"],\n',
                '    "font.size": VIZ_CONFIG["font_size"],\n',
                '    "axes.titlesize": VIZ_CONFIG["title_size"]\n',
                '})\n',
                '\n',
                'print(f"🔬 Scientific Research Notebook: {notebook_name}")\n',
                'print(f"🎯 Reproducibility Seed: {experiment_seed}")\n',
                'print(f"📊 Ready for research analysis")'
            ]
        },
        
        # Cell 3: Data Loading & Validation
        {
            'cell_type': 'code',
            'source': [
                '# ========================================\n',
                '# DATA LOADING & VALIDATION\n',
                '# ========================================\n',
                '\n',
                'def load_research_data():\n',
                '    """Load data with scientific validation"""\n',
                '    try:\n',
                '        # Load from shared data directory\n',
                '        data_path = Path(DATA_CONFIG["data_dir"])\n',
                '        print(f"📂 Loading data from: {data_path}")\n',
                '        \n',
                '        # TODO: Implement data loading logic\n',
                '        # data = pd.read_csv(data_path / "processed_data.csv")\n',
                '        \n',
                '        # For now, create dummy data for template\n',
                '        np.random.seed(GLOBAL_SEED)\n',
                '        data = pd.DataFrame({\n',
                '            "timestamp": pd.date_range("2024-01-01", periods=1000, freq="1min"),\n',
                '            "sku_id": np.random.choice(["SKU001", "SKU002", "SKU003"], 1000),\n',
                '            "qty": np.random.poisson(5, 1000),\n',
                '            "likes": np.random.poisson(10, 1000),\n',
                '            "comments": np.random.poisson(3, 1000)\n',
                '        })\n',
                '        \n',
                '        return data\n',
                '        \n',
                '    except Exception as e:\n',
                '        logger.logger.error(f"Data loading failed: {e}")\n',
                '        raise\n',
                '\n',
                'def validate_data_quality(data):\n',
                '    """Scientific data quality validation"""\n',
                '    validation_report = {\n',
                '        "total_records": len(data),\n',
                '        "null_values": data.isnull().sum().to_dict(),\n',
                '        "duplicate_records": data.duplicated().sum(),\n',
                '        "data_types": data.dtypes.to_dict(),\n',
                '        "memory_usage_mb": data.memory_usage(deep=True).sum() / 1024**2\n',
                '    }\n',
                '    \n',
                '    # Log validation results\n',
                '    logger.logger.info(f"Data validation completed: {len(data)} records")\n',
                '    if validation_report["duplicate_records"] > 0:\n',
                '        logger.logger.warning(f"Found {validation_report[\\"duplicate_records\\"]} duplicates")\n',
                '    \n',
                '    return validation_report\n',
                '\n',
                '# Load and validate data\n',
                'raw_data = load_research_data()\n',
                'validation_report = validate_data_quality(raw_data)\n',
                '\n',
                '# Log data summary\n',
                'logger.log_dataframe(raw_data, "raw_data", "Initial dataset for analysis")\n',
                '\n',
                'print(f"✅ Data loaded: {len(raw_data)} records")\n',
                'print(f"📊 Memory usage: {validation_report[\\"memory_usage_mb\\"]:.2f} MB")'
            ]
        }
    ]
}

def create_scientific_notebook(notebook_config):
    """Create scientific research notebook from template"""
    import nbformat as nbf
    
    # Create new notebook
    nb = nbf.v4.new_notebook()
    nb.metadata = NOTEBOOK_TEMPLATE['metadata']
    
    # Substitute template variables
    for cell_template in NOTEBOOK_TEMPLATE['cells']:
        if cell_template['cell_type'] == 'markdown':
            source = ''.join(cell_template['source']).format(**notebook_config)
            cell = nbf.v4.new_markdown_cell(source)
        else:
            source = ''.join(cell_template['source']).format(**notebook_config) 
            cell = nbf.v4.new_code_cell(source)
        
        nb.cells.append(cell)
    
    return nb
```

## 🎨 SCIENTIFIC VISUALIZATION TEMPLATES

### **Research-Grade Plotting Functions**
```python
"""
Scientific visualization templates for reproducible research
Following best practices cho academic publications
"""

def create_research_plots():
    """Create standardized research plots"""
    
    def plot_time_series_analysis(data, target_col, title="Time Series Analysis"):
        """Scientific time series visualization"""
        fig, axes = plt.subplots(2, 2, figsize=(15, 10))
        fig.suptitle(title, fontsize=16, fontweight='bold')
        
        # Original time series
        axes[0,0].plot(data.index, data[target_col], 
                      color=VIZ_CONFIG['research_colors']['actual'],
                      linewidth=1, alpha=0.8)
        axes[0,0].set_title('Original Time Series')
        axes[0,0].set_ylabel('Value')
        axes[0,0].grid(True, alpha=0.3)
        
        # Decomposition (if seasonal)
        from statsmodels.tsa.seasonal import seasonal_decompose
        try:
            decomposition = seasonal_decompose(data[target_col], 
                                             model='additive', 
                                             period=60)  # hourly seasonality
            
            axes[0,1].plot(decomposition.trend, color='red', alpha=0.7)
            axes[0,1].set_title('Trend Component')
            axes[0,1].grid(True, alpha=0.3)
            
            axes[1,0].plot(decomposition.seasonal[:200], color='green', alpha=0.7)
            axes[1,0].set_title('Seasonal Component (First 200 points)')
            axes[1,0].grid(True, alpha=0.3)
            
            axes[1,1].plot(decomposition.resid, color='orange', alpha=0.7)
            axes[1,1].set_title('Residual Component')
            axes[1,1].grid(True, alpha=0.3)
            
        except Exception as e:
            logger.logger.warning(f"Decomposition failed: {e}")
            axes[0,1].text(0.5, 0.5, 'Decomposition\nNot Available', 
                          ha='center', va='center', transform=axes[0,1].transAxes)
            axes[1,0].text(0.5, 0.5, 'Seasonal Component\nNot Available', 
                          ha='center', va='center', transform=axes[1,0].transAxes)
            axes[1,1].text(0.5, 0.5, 'Residual Component\nNot Available', 
                          ha='center', va='center', transform=axes[1,1].transAxes)
        
        plt.tight_layout()
        return fig
    
    def plot_model_performance_comparison(results_df, title="Model Performance Comparison"):
        """Scientific model comparison visualization"""
        fig, axes = plt.subplots(1, 3, figsize=(18, 6))
        fig.suptitle(title, fontsize=16, fontweight='bold')
        
        metrics = ['MAE', 'RMSE', 'MAPE']
        colors = list(VIZ_CONFIG['research_colors'].values())
        
        for idx, metric in enumerate(metrics):
            if metric in results_df.columns:
                # Bar plot with error bars if available
                bars = axes[idx].bar(results_df.index, results_df[metric], 
                                   color=colors[:len(results_df)], alpha=0.7)
                axes[idx].set_title(f'{metric} Comparison')
                axes[idx].set_ylabel(metric)
                axes[idx].tick_params(axis='x', rotation=45)
                axes[idx].grid(True, alpha=0.3, axis='y')
                
                # Add value labels on bars
                for bar, value in zip(bars, results_df[metric]):
                    axes[idx].text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.01,
                                 f'{value:.4f}', ha='center', va='bottom')
                
                # Add target line if available
                if metric in EVAL_CONFIG['target_performance']:
                    target = EVAL_CONFIG['target_performance'][metric]
                    if target is not None:
                        axes[idx].axhline(y=target, color='red', linestyle='--', 
                                        alpha=0.8, label=f'Target: {target}')
                        axes[idx].legend()
        
        plt.tight_layout()
        return fig
    
    def plot_prediction_vs_actual(y_true, y_pred, model_name, confidence_interval=None):
        """Scientific prediction vs actual plot"""
        fig, axes = plt.subplots(1, 2, figsize=(15, 6))
        fig.suptitle(f'{model_name}: Prediction Analysis', fontsize=16, fontweight='bold')
        
        # Scatter plot: Predicted vs Actual
        axes[0].scatter(y_true, y_pred, alpha=0.6, 
                       color=VIZ_CONFIG['research_colors']['predicted'])
        
        # Perfect prediction line
        min_val, max_val = min(y_true.min(), y_pred.min()), max(y_true.max(), y_pred.max())
        axes[0].plot([min_val, max_val], [min_val, max_val], 
                    'r--', alpha=0.8, label='Perfect Prediction')
        
        # Add confidence interval if provided
        if confidence_interval is not None:
            axes[0].fill_between([min_val, max_val], 
                               [min_val-confidence_interval, max_val-confidence_interval],
                               [min_val+confidence_interval, max_val+confidence_interval],
                               alpha=0.2, color='gray', label='Confidence Interval')
        
        axes[0].set_xlabel('Actual Values')
        axes[0].set_ylabel('Predicted Values')
        axes[0].set_title('Predicted vs Actual')
        axes[0].grid(True, alpha=0.3)
        axes[0].legend()
        
        # Calculate and display metrics
        mae = mean_absolute_error(y_true, y_pred)
        rmse = np.sqrt(mean_squared_error(y_true, y_pred))
        r2 = r2_score(y_true, y_pred)
        
        metrics_text = f'MAE: {mae:.4f}\\nRMSE: {rmse:.4f}\\nR²: {r2:.4f}'
        axes[0].text(0.05, 0.95, metrics_text, transform=axes[0].transAxes,
                    verticalalignment='top', bbox=dict(boxstyle='round', facecolor='wheat'))
        
        # Residual plot
        residuals = y_true - y_pred
        axes[1].scatter(y_pred, residuals, alpha=0.6, 
                       color=VIZ_CONFIG['research_colors']['actual'])
        axes[1].axhline(y=0, color='r', linestyle='--', alpha=0.8)
        axes[1].set_xlabel('Predicted Values')
        axes[1].set_ylabel('Residuals')
        axes[1].set_title('Residual Plot')
        axes[1].grid(True, alpha=0.3)
        
        plt.tight_layout()
        return fig
    
    def plot_feature_importance(importance_data, title="Feature Importance Analysis"):
        """Scientific feature importance visualization"""
        fig, ax = plt.subplots(1, 1, figsize=(12, 8))
        
        # Sort by importance
        importance_data = importance_data.sort_values('importance', ascending=True)
        
        # Horizontal bar plot
        bars = ax.barh(range(len(importance_data)), importance_data['importance'],
                      color=VIZ_CONFIG['research_colors']['xgboost'], alpha=0.7)
        
        ax.set_yticks(range(len(importance_data)))
        ax.set_yticklabels(importance_data['feature'])
        ax.set_xlabel('Importance Score')
        ax.set_title(title, fontweight='bold')
        ax.grid(True, alpha=0.3, axis='x')
        
        # Add value labels
        for i, (bar, value) in enumerate(zip(bars, importance_data['importance'])):
            ax.text(value + 0.001, bar.get_y() + bar.get_height()/2,
                   f'{value:.3f}', ha='left', va='center')
        
        plt.tight_layout()
        return fig
    
    return {
        'plot_time_series_analysis': plot_time_series_analysis,
        'plot_model_performance_comparison': plot_model_performance_comparison,
        'plot_prediction_vs_actual': plot_prediction_vs_actual,
        'plot_feature_importance': plot_feature_importance
    }

# Load plotting functions globally
research_plots = create_research_plots()
```

## 🔍 AUTOMATED TESTING & VALIDATION

### **Notebook Quality Validator**
```python
"""
Automated testing system for scientific notebooks
Ensures reproducibility and research quality standards
"""

class NotebookScientificValidator:
    """Validate notebook adherence to scientific standards"""
    
    def __init__(self, notebook_path):
        self.notebook_path = notebook_path
        self.notebook_name = Path(notebook_path).stem
        self.validation_results = {}
        
    def validate_reproducibility(self):
        """Check reproducibility requirements"""
        checks = {
            'seed_usage': self._check_seed_usage(),
            'shared_config': self._check_shared_config_import(),
            'deterministic_operations': self._check_deterministic_ops(),
            'version_documentation': self._check_version_docs()
        }
        
        self.validation_results['reproducibility'] = checks
        return all(checks.values())
    
    def validate_scientific_standards(self):
        """Check scientific visualization and analysis standards"""
        checks = {
            'proper_plotting': self._check_scientific_plots(),
            'statistical_tests': self._check_statistical_analysis(),
            'error_bars_confidence': self._check_uncertainty_quantification(),
            'methodology_documentation': self._check_methodology_docs()
        }
        
        self.validation_results['scientific_standards'] = checks
        return all(checks.values())
    
    def validate_outputs(self):
        """Validate notebook outputs quality"""
        output_dir = Path(self.notebook_path).parent / 'results'
        
        if not output_dir.exists():
            return False
            
        checks = {
            'results_directory': output_dir.exists(),
            'csv_outputs': len(list(output_dir.glob('*.csv'))) > 0,
            'plot_outputs': len(list(output_dir.glob('*.png'))) > 0,
            'config_logging': (output_dir / 'experiment_config.json').exists()
        }
        
        self.validation_results['outputs'] = checks
        return all(checks.values())
    
    def _check_seed_usage(self):
        """Check if global seed is properly used"""
        with open(self.notebook_path, 'r') as f:
            content = f.read()
        return 'GLOBAL_SEED' in content and 'set_all_seeds' in content
    
    def _check_shared_config_import(self):
        """Check if shared config is imported"""
        with open(self.notebook_path, 'r') as f:
            content = f.read()
        return 'from shared_config import' in content
    
    def _check_deterministic_ops(self):
        """Check for potential non-deterministic operations"""
        with open(self.notebook_path, 'r') as f:
            content = f.read()
        
        # Check for proper torch settings
        torch_settings = [
            'torch.backends.cudnn.deterministic = True',
            'torch.backends.cudnn.benchmark = False'
        ]
        
        return any(setting in content for setting in torch_settings)
    
    def _check_version_docs(self):
        """Check if versions are documented"""  
        with open(self.notebook_path, 'r') as f:
            content = f.read()
        return 'version' in content.lower() or 'requirements' in content.lower()
    
    def _check_scientific_plots(self):
        """Check if scientific plotting standards are used"""
        with open(self.notebook_path, 'r') as f:
            content = f.read()
        
        scientific_elements = [
            'plt.grid',
            'fontsize',
            'plt.tight_layout',
            'research_colors',
            'suptitle'
        ]
        
        return sum(element in content for element in scientific_elements) >= 3
    
    def _check_statistical_analysis(self):
        """Check for proper statistical analysis"""
        with open(self.notebook_path, 'r') as f:
            content = f.read()
        
        stats_elements = [
            'mean_absolute_error',
            'r2_score',
            'confidence_interval',
            'statistical_significance'
        ]
        
        return sum(element in content for element in stats_elements) >= 2
    
    def _check_uncertainty_quantification(self):
        """Check if uncertainty is properly quantified"""
        with open(self.notebook_path, 'r') as f:
            content = f.read()
        
        uncertainty_elements = [
            'confidence',
            'error_bar',
            'std',
            'variance',
            'bootstrap'
        ]
        
        return any(element in content for element in uncertainty_elements)
    
    def _check_methodology_docs(self):
        """Check if methodology is properly documented"""
        with open(self.notebook_path, 'r') as f:
            content = f.read()
        
        method_keywords = [
            '## Methodology',
            '## Method',
            '## Approach',
            'algorithm',
            'procedure'
        ]
        
        return any(keyword in content for keyword in method_keywords)
    
    def generate_validation_report(self):
        """Generate comprehensive validation report"""
        report = {
            'notebook': self.notebook_name,
            'timestamp': datetime.now().isoformat(),
            'reproducibility_score': sum(self.validation_results.get('reproducibility', {}).values()),
            'scientific_score': sum(self.validation_results.get('scientific_standards', {}).values()),
            'output_score': sum(self.validation_results.get('outputs', {}).values()),
            'total_checks': len(self.validation_results.get('reproducibility', {})) + 
                          len(self.validation_results.get('scientific_standards', {})) + 
                          len(self.validation_results.get('outputs', {})),
            'passed_checks': sum(sum(checks.values()) for checks in self.validation_results.values()),
            'detailed_results': self.validation_results
        }
        
        report['overall_score'] = (report['passed_checks'] / report['total_checks'] * 100) if report['total_checks'] > 0 else 0
        
        return report
```

## 🚀 GENERAL NOTEBOOK CREATION WORKFLOW

### **Universal AI Notebook Creator - Any Project**
```python
"""
AI system tự động tạo GENERAL notebook cho bất kỳ project nào
CRITICAL: Đảm bảo consistency, auto-debug, shared environment
"""

def ai_create_general_notebook(notebook_config):
    """
    AI tạo general notebook với full auto-debug, consistent environment
    
    Args:
        notebook_config: Dict chứa config cho notebook
        - name: Tên notebook  
        - purpose: Mục đích (general - không specific)
        - analysis_type: loại phân tích (data_prep, modeling, comparison, etc)
        - folder: thư mục chứa notebook
    """
    
    # Validate config
    required_keys = ['name', 'purpose', 'model_type', 'folder']
    if not all(key in notebook_config for key in required_keys):
        raise ValueError(f"Missing required keys: {required_keys}")
    
    # Create notebook structure
    base_dir = Path(PROJECT_CONFIG['base_dir']) / notebook_config['folder']
    base_dir.mkdir(parents=True, exist_ok=True)
    
    notebook_path = base_dir / f"{notebook_config['name']}.ipynb"
    results_dir = base_dir / 'results'
    results_dir.mkdir(exist_ok=True)
    
    # Generate notebook content
    template_config = {
        'notebook_title': notebook_config['name'].replace('_', ' ').title(),
        'purpose': notebook_config['purpose'],
        'context': f"Analysis for {notebook_config['model_type']} model in livestream forecasting research",
        'outcomes': f"Expected to achieve R² > 0.80 and MAPE < 15% per research requirements",
        'methodology': f"Following {notebook_config['model_type']} methodology with reproducible seed {GLOBAL_SEED}",
        'notebook_name': notebook_config['name'],
        'date': datetime.now().strftime('%Y-%m-%d'),
        'seed': GLOBAL_SEED
    }
    
    # Create notebook using template
    nb = create_scientific_notebook(template_config)
    
    # Add model-specific cells
    if notebook_config['model_type'] == 'xgboost':
        nb = add_xgboost_cells(nb)
    elif notebook_config['model_type'] == 'lstm':
        nb = add_lstm_cells(nb)
    elif notebook_config['model_type'] == 'baseline':
        nb = add_baseline_cells(nb)
    
    # Add auto-debug integration
    nb = add_autodebug_cells(nb)
    
    # Save notebook
    with open(notebook_path, 'w') as f:
        nbf.write(nb, f)
    
    # Create README for folder
    create_notebook_readme(base_dir, notebook_config)
    
    # Log creation
    print(f"✅ Scientific notebook created: {notebook_path}")
    print(f"📁 Results directory: {results_dir}")
    
    return notebook_path

def create_all_research_notebooks():
    """Create complete set of research notebooks"""
    
    notebooks_config = [
        {
            'name': 'data_preparation',
            'purpose': 'Load, clean, and prepare Prod3W dataset for analysis',
            'model_type': 'preprocessing',
            'folder': '01_data_preparation'
        },
        {
            'name': 'baseline_comparison',
            'purpose': 'Implement and evaluate baseline forecasting models (ARIMA, ETS, Moving Average)',
            'model_type': 'baseline', 
            'folder': '02_baseline_models'
        },
        {
            'name': 'xgboost_training',
            'purpose': 'Train and optimize XGBoost model for livestream demand forecasting',
            'model_type': 'xgboost',
            'folder': '03_xgboost_model'
        },
        {
            'name': 'lstm_training',
            'purpose': 'Develop LSTM neural network for sequence-based demand prediction',
            'model_type': 'lstm',
            'folder': '04_lstm_model'
        },
        {
            'name': 'comprehensive_comparison',
            'purpose': 'Compare all models and generate final research results',
            'model_type': 'evaluation',
            'folder': '06_model_comparison'
        }
    ]
    
    created_notebooks = []
    for config in notebooks_config:
        try:
            notebook_path = ai_create_scientific_notebook(config)
            created_notebooks.append(notebook_path)
        except Exception as e:
            print(f"❌ Failed to create {config['name']}: {e}")
    
    print(f"✅ Created {len(created_notebooks)} research notebooks")
    return created_notebooks
```

## 🎯 INTEGRATION VỚI AUTO-DEBUG

### **Auto-Debug Integration for Research**
```python
"""
Tích hợp auto-debug system cho scientific notebooks
"""

def add_autodebug_cells(nb):
    """Add auto-debug capabilities to notebook"""
    
    # Auto-debug setup cell
    autodebug_setup = nbf.v4.new_code_cell('''
# ========================================
# AUTO-DEBUG INTEGRATION
# ========================================

# Import autodebug system
try:
    from fonglog import get_logger
    logger = get_logger()
    
    # Enable automatic debugging
    def debug_cell(func):
        """Decorator for automatic cell debugging"""
        def wrapper(*args, **kwargs):
            try:
                result = func(*args, **kwargs)
                logger.logger.info(f"✅ Function {func.__name__} completed successfully")
                return result
            except Exception as e:
                logger.logger.error(f"❌ Function {func.__name__} failed: {e}")
                # Auto-fix suggestions
                if "FileNotFoundError" in str(e):
                    print("💡 Auto-fix suggestion: Check file path or create dummy data")
                elif "KeyError" in str(e):
                    print("💡 Auto-fix suggestion: Validate DataFrame columns")
                elif "ModuleNotFoundError" in str(e):
                    print("💡 Auto-fix suggestion: Install missing package")
                raise
        return wrapper
    
    print("🔧 Auto-debug system ready")
    
except ImportError:
    print("⚠️ Auto-debug not available - running in fallback mode")
    def debug_cell(func):
        return func
''')
    
    # Insert after setup cell (cell index 2)
    nb.cells.insert(3, autodebug_setup)
    
    # Add validation cell at end
    validation_cell = nbf.v4.new_code_cell('''
# ========================================
# FINAL VALIDATION & QUALITY CHECK
# ========================================

def validate_notebook_results():
    """Validate notebook execution and results quality"""
    
    validation_report = {
        'timestamp': datetime.now().isoformat(),
        'notebook': notebook_name,
        'seed_used': experiment_seed,
        'results_generated': False,
        'plots_created': False,
        'data_saved': False,
        'quality_score': 0
    }
    
    # Check results directory
    results_dir = Path(f"{notebook_name}-output")
    if results_dir.exists():
        validation_report['results_generated'] = True
        
        # Check for CSV files
        csv_files = list(results_dir.glob("data/*.csv"))
        validation_report['data_saved'] = len(csv_files) > 0
        
        # Check for plot files
        plot_files = list(results_dir.glob("charts/*.png"))
        validation_report['plots_created'] = len(plot_files) > 0
        
        # Calculate quality score
        checks = [
            validation_report['results_generated'],
            validation_report['data_saved'], 
            validation_report['plots_created']
        ]
        validation_report['quality_score'] = sum(checks) / len(checks) * 100
    
    # Log final results
    logger.logger.info(f"📊 Notebook validation completed")
    logger.logger.info(f"Quality score: {validation_report['quality_score']:.1f}%")
    
    if validation_report['quality_score'] >= 80:
        print("✅ NOTEBOOK EXECUTION SUCCESSFUL - High quality results generated")
    else:
        print("⚠️ NOTEBOOK EXECUTION INCOMPLETE - Check outputs and re-run failed cells")
    
    # Save validation report
    validation_path = results_dir / "validation_report.json"
    with open(validation_path, 'w') as f:
        json.dump(validation_report, f, indent=2)
    
    return validation_report

# Run validation
try:
    final_validation = validate_notebook_results()
    logger.logger.info("✅ Notebook validation completed successfully")
except Exception as e:
    logger.logger.error(f"❌ Validation failed: {e}")
    print(f"💥 Validation error: {e}")
''')
    
    nb.cells.append(validation_cell)
    
    return nb
```

## 📋 USAGE INSTRUCTIONS

### **Complete Research Workflow**

```bash
# 1. Setup research environment
cd /home/fong/Projects/co-linh-livestream-forecasting/notebooks2/

# 2. Create all research notebooks
python -c "
from shared_config import *
from notebook_creator import create_all_research_notebooks
created = create_all_research_notebooks()
print(f'Created {len(created)} research notebooks')
"

# 3. Run notebooks với auto-debug
cd 01_data_preparation/
jupyter notebook data_preparation.ipynb

# 4. Execute all notebooks in sequence
for folder in 01_data_preparation 02_baseline_models 03_xgboost_model 04_lstm_model 06_model_comparison; do
    echo "🚀 Running $folder notebook..."
    cd $folder/
    jupyter nbconvert --execute --to notebook --inplace *.ipynb
    cd ../
done
```

### **Individual Notebook Usage**
```python
# In notebook cell - standard research pattern
%%fongcell analysis "Perform data analysis"

# Use debug decorator for functions
@debug_cell
def analyze_engagement_patterns(data):
    """Analyze viewer engagement patterns"""
    # Set seed for reproducibility
    np.random.seed(GLOBAL_SEED)
    
    # Analysis code...
    results = data.groupby('sku_id').agg({
        'likes': ['mean', 'std'],
        'comments': ['mean', 'std'],
        'qty': ['sum', 'mean']
    })
    
    # Log results with scientific validation
    logger.log_dataframe(results, 'engagement_analysis', 'Viewer engagement patterns by SKU')
    
    # Create scientific visualization
    fig = research_plots['plot_time_series_analysis'](data, 'qty', 'Demand Analysis')
    logger.log_plot(fig, 'demand_time_series', 'Time series analysis of demand patterns')
    
    return results

# Execute analysis
engagement_results = analyze_engagement_patterns(raw_data)
```

## 🎯 SUCCESS CRITERIA

### **✅ SCIENTIFIC NOTEBOOK STANDARDS**
- **Reproducibility**: 100% reproducible với shared seed
- **Documentation**: Complete methodology và context documentation
- **Visualization**: Research-grade plots với proper statistical representation
- **Validation**: All outputs validated cho quality và completeness
- **Auto-Debug**: Integration với fonglog system cho automatic error handling
- **Standards Compliance**: Adherence to scientific research best practices

### **📊 QUALITY METRICS**
- Reproducibility Score: 100% (all seeds properly set)
- Scientific Standards Score: >90% (proper plots, stats, documentation)
- Output Quality Score: >80% (valid CSV files, meaningful plots)
- Auto-Debug Success Rate: >90% (automatic error recovery)

---

**🔬 CORE PRINCIPLE**: 
Mỗi notebook phải hoạt động như một independent scientific experiment, hoàn toàn reproducible với shared seed, tạo ra research-quality outputs, và tự động debug khi có lỗi xảy ra.