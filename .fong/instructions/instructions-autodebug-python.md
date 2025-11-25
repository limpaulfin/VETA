---
description: "Auto-debugging system với fongdebug module - tự động log, run, analyze và fix Python code"
version: "2025-09-04T20:00:00Z"
context: "Python development auto-debug workflow"
session_id: "2025-09-04--09-01-pm"
conversation_id: "c2b3f9bd-d58a-41a9-8155-e4826841582e"
---

# 🐛 INSTRUCTIONS: AUTO-DEBUG PYTHON - FONGDEBUG MODULE

## 🎯 MỤC ĐÍCH

Tự động hóa quy trình debug Python code bằng cách:
1. **Luôn log mọi thứ** vào `./src/logs/debug.log`
2. **Chạy code và đọc output** (console + log files)  
3. **AI tự think và fix** cho tới khi code works
4. **Production mode**: Chỉ remove fongdebug khi deploy

## 🏗️ FONGDEBUG MODULE ARCHITECTURE

### **Core Structure**
```python
# Trong mỗi Python file:
from fongdebug import debug_logger, auto_monitor

# Auto-logging decorator
@auto_monitor("function_name")
def any_function():
    debug_logger.info("Function started")
    # ... business logic
    debug_logger.debug("Intermediate state: {data}")
    return result

# Log directory: ./src/logs/debug.log (LUÔN CÓ RELATIVE TỚI SRC)
```

### **File Structure Pattern**
```
project/
├── src/                     # Source code directory
│   ├── logs/               # LOG DIR - LUÔN TRONG SRC
│   │   └── debug.log       # Main debug log
│   ├── fongdebug.py        # Debug module
│   ├── module1.py          # Business code + fongdebug
│   └── module2.py          # Business code + fongdebug
└── main.py                 # Entry point + fongdebug
```

## 🔧 FONGDEBUG MODULE SPECIFICATION

### **1. Auto-Logger (fongdebug.py)**
```python
import logging
import functools
import traceback
import sys
from pathlib import Path
from datetime import datetime

class FongDebugger:
    def __init__(self):
        self.setup_logging()
    
    def setup_logging(self):
        """Setup debug log in ./src/logs/ directory"""
        # Determine src/logs path
        current_file = Path(__file__)
        if current_file.parent.name == 'src':
            log_dir = current_file.parent / 'logs'
        else:
            # If fongdebug not in src, find src directory
            src_dir = current_file.parent / 'src'
            if not src_dir.exists():
                # Create src and logs if not exist
                src_dir.mkdir(exist_ok=True)
            log_dir = src_dir / 'logs'
        
        log_dir.mkdir(exist_ok=True)
        log_file = log_dir / 'debug.log'
        
        # Configure comprehensive logging
        logging.basicConfig(
            level=logging.DEBUG,
            format='%(asctime)s - %(name)s:%(lineno)d - %(levelname)s - %(message)s',
            handlers=[
                logging.FileHandler(log_file, mode='a'),
                logging.StreamHandler(sys.stdout)
            ],
            force=True
        )
        
        self.logger = logging.getLogger('fongdebug')
        self.logger.info(f"🐛 FongDebug initialized - {datetime.now()}")
    
    def auto_monitor(self, func_name=""):
        """Decorator để auto-log function execution"""
        def decorator(func):
            @functools.wraps(func)
            def wrapper(*args, **kwargs):
                name = func_name or func.__name__
                self.logger.info(f"▶️ START: {name}")
                self.logger.debug(f"Args: {args}, Kwargs: {kwargs}")
                
                try:
                    result = func(*args, **kwargs)
                    self.logger.info(f"✅ SUCCESS: {name}")
                    self.logger.debug(f"Result: {type(result)} - {str(result)[:200]}")
                    return result
                except Exception as e:
                    self.logger.error(f"❌ ERROR in {name}: {str(e)}")
                    self.logger.error(f"Traceback:\n{traceback.format_exc()}")
                    raise
            return wrapper
        return decorator
    
    def log_state(self, message, data=None):
        """Log intermediate states"""
        self.logger.debug(f"🔍 STATE: {message}")
        if data is not None:
            self.logger.debug(f"Data: {str(data)[:500]}")

# Global instance
_debugger = FongDebugger()
debug_logger = _debugger.logger
auto_monitor = _debugger.auto_monitor
log_state = _debugger.log_state
```

### **2. Integration Pattern**
```python
# Trong mỗi module .py:
from fongdebug import debug_logger, auto_monitor, log_state

@auto_monitor("load_data")
def load_data(file_path):
    debug_logger.info(f"Loading data from: {file_path}")
    
    try:
        data = pd.read_csv(file_path)
        log_state("Data loaded", f"Shape: {data.shape}")
        return data
    except Exception as e:
        debug_logger.error(f"Failed to load data: {e}")
        raise

@auto_monitor("process_pipeline") 
def main_pipeline():
    debug_logger.info("🚀 Starting main pipeline")
    
    # Step 1
    log_state("Step 1: Data loading")
    data = load_data("input.csv")
    
    # Step 2  
    log_state("Step 2: Processing", f"Records: {len(data)}")
    processed = process_data(data)
    
    debug_logger.info("✅ Pipeline completed successfully")
    return processed
```

## 🤖 AI AUTO-DEBUG WORKFLOW

### **BƯỚC 1: EXECUTE & MONITOR**
```bash
# AI chạy Python script
python main.py

# AI simultaneously monitors:
# - Console output (STDOUT/STDERR)  
# - Log file: tail -f src/logs/debug.log
```

### **BƯỚC 2: ERROR DETECTION & ANALYSIS**
```python
# AI detects errors from:
# 1. Exit code != 0
# 2. Exception trong console
# 3. ERROR/CRITICAL entries trong debug.log
# 4. Stack traces

# AI analysis workflow:
def ai_analyze_error():
    """AI tự động phân tích lỗi"""
    
    # Read console output
    console_output = capture_stdout_stderr()
    
    # Read debug.log
    with open('src/logs/debug.log', 'r') as f:
        log_content = f.read()
    
    # Extract error patterns
    errors = extract_errors(console_output, log_content)
    
    # AI thinking process:
    for error in errors:
        print(f"🔍 ANALYZING ERROR: {error}")
        root_cause = ai_determine_root_cause(error)
        fix_strategy = ai_generate_fix_strategy(root_cause)
        ai_apply_fix(fix_strategy)
    
    # Re-run and verify
    return ai_verify_fix()
```

### **BƯỚC 3: AUTO-FIX LOOP**
```python
def autodebug_loop(max_iterations=5):
    """AI auto-debug until success"""
    
    for iteration in range(max_iterations):
        debug_logger.info(f"🔄 Auto-debug iteration {iteration + 1}")
        
        # Execute code
        exit_code, stdout, stderr = run_python_script()
        
        # Check success
        if exit_code == 0 and no_errors_in_logs():
            debug_logger.info("✅ AUTO-DEBUG SUCCESS - Code works!")
            return True
        
        # Analyze errors
        errors = ai_analyze_errors(stdout, stderr, 'src/logs/debug.log')
        
        # Generate fixes  
        fixes = ai_generate_fixes(errors)
        
        # Apply fixes
        ai_apply_fixes(fixes)
        
        debug_logger.info(f"🛠️ Applied {len(fixes)} fixes")
    
    debug_logger.error("❌ AUTO-DEBUG FAILED after max iterations")
    return False
```

## 📋 AI EXECUTION INSTRUCTIONS

### **🎯 WHEN TO USE AUTO-DEBUG**
```bash
# MANDATORY usage khi:
# 1. Developing new Python modules
# 2. Debugging existing code issues  
# 3. Integration testing
# 4. Performance troubleshooting
# 5. Code refactoring validation
```

### **🔥 AI AUTO-DEBUG PROTOCOL**

#### **Phase 1: Setup**
```bash
# 1. Ensure fongdebug module exists
# 2. Verify log directory: src/logs/
# 3. Check all .py files have fongdebug imports
```

#### **Phase 2: Execute & Monitor**
```bash
# Run với comprehensive monitoring:
python main.py 2>&1 | tee execution.log &
tail -f src/logs/debug.log &

# AI reads BOTH streams simultaneously
```

#### **Phase 3: Error Analysis**
```python
# AI systematic error analysis:
def ai_comprehensive_analysis():
    # 1. Parse exception stack traces
    # 2. Identify missing imports/dependencies  
    # 3. Check data type mismatches
    # 4. Validate file paths and permissions
    # 5. Analyze logic flow issues
    # 6. Check configuration problems
```

#### **Phase 4: Fix Generation**
```python
# AI generates targeted fixes:
def ai_generate_targeted_fixes(errors):
    fixes = []
    for error in errors:
        if "ModuleNotFoundError" in error:
            fixes.append(generate_import_fix(error))
        elif "FileNotFoundError" in error:
            fixes.append(generate_path_fix(error))
        elif "TypeError" in error:
            fixes.append(generate_type_fix(error))
        # ... more error patterns
    return fixes
```

#### **Phase 5: Fix Application** 
```python
# AI applies fixes systematically:
def ai_apply_fixes_systematically(fixes):
    for fix in fixes:
        debug_logger.info(f"🛠️ Applying fix: {fix.description}")
        
        # Apply code changes
        apply_code_change(fix)
        
        # Test fix immediately
        if test_fix_works(fix):
            debug_logger.info(f"✅ Fix successful: {fix.description}")
        else:
            debug_logger.error(f"❌ Fix failed: {fix.description}")
            rollback_change(fix)
```

## 🚀 USAGE EXAMPLES

### **Example 1: Data Processing Pipeline**
```python
# main.py
from fongdebug import debug_logger, auto_monitor

@auto_monitor("data_pipeline")
def main():
    debug_logger.info("🚀 Starting data pipeline")
    
    # AI auto-logs mọi step
    data = load_csv_data()
    cleaned = clean_data(data)  
    results = analyze_data(cleaned)
    
    debug_logger.info("✅ Pipeline completed")
    return results

# AI execution:
# 1. python main.py
# 2. Monitor src/logs/debug.log  
# 3. If errors → analyze → fix → retry
# 4. Loop until success
```

### **Example 2: Machine Learning Training**
```python
from fongdebug import debug_logger, auto_monitor, log_state

@auto_monitor("ml_training")
def train_model():
    debug_logger.info("🤖 Starting ML training")
    
    # Load data
    log_state("Loading training data")
    X, y = load_training_data()
    
    # Train model
    log_state("Training model", f"Data shape: {X.shape}")
    model = RandomForestClassifier()
    model.fit(X, y)
    
    # Evaluate
    score = model.score(X_test, y_test)
    log_state("Model evaluation", f"Accuracy: {score}")
    
    debug_logger.info(f"✅ Training completed - Accuracy: {score}")
    return model

# AI autodebug sẽ:
# - Detect import errors → fix imports
# - Detect data issues → fix data loading
# - Detect model errors → fix parameters  
# - Loop until training succeeds
```

## 🎛️ PRODUCTION VS DEVELOPMENT

### **Development Mode (DEFAULT)**
```python
# LUÔN CÓ fongdebug trong development
from fongdebug import debug_logger, auto_monitor
```

### **Production Mode** 
```python  
# CHỈ KHI DEPLOY production mới remove:
# Option 1: Comment out fongdebug
# from fongdebug import debug_logger, auto_monitor

# Option 2: Use environment variable
import os
if os.getenv('PRODUCTION') != 'true':
    from fongdebug import debug_logger, auto_monitor
else:
    # Production logging
    import logging
    debug_logger = logging.getLogger(__name__)
```

## ⚠️ CRITICAL SUCCESS FACTORS

### **1. MANDATORY LOGGING**
- MỌI function trong development PHẢI có `@auto_monitor`
- MỌI intermediate state PHẢI log với `log_state()` 
- MỌI error PHẢI captured với full traceback

### **2. AI AUTO-FIX REQUIREMENTS**
- AI PHẢI đọc CẢ console output VÀ debug.log  
- AI PHẢI analyze errors systematically (stack trace, types, logic)
- AI PHẢI apply fixes incrementally và test each fix
- AI PHẢI loop until success (max 5 iterations)

### **3. LOG FILE MANAGEMENT**
```python
# Log rotation để avoid huge files:
def rotate_debug_log():
    log_file = Path('src/logs/debug.log')
    if log_file.stat().st_size > 10 * 1024 * 1024:  # 10MB
        backup = f"debug_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"
        log_file.rename(Path('src/logs') / backup)
```

## 📊 SUCCESS METRICS

### **✅ AUTO-DEBUG THÀNH CÔNG KHI:**
- Code chạy hoàn chỉnh không lỗi (exit code = 0)
- Không có ERROR/CRITICAL trong debug.log
- Console output clean (no exceptions)
- Business logic outputs đúng expected results
- Performance acceptable (không infinite loops)

### **📈 KPI TRACKING**
```python
# Track auto-debug effectiveness:
# - Success rate (% fixes thành công)
# - Average iterations per fix
# - Common error patterns  
# - Fix accuracy rate
```

## 🔗 INTEGRATION VỚI FONG TOOLS

### **Memory Integration**
```bash
# Auto-save debug session vào memory:
echo "## Auto-Debug Session $(date)" >> .fong/.memory/debug_sessions.md
echo "- Errors found: [list]" >> .fong/.memory/debug_sessions.md  
echo "- Fixes applied: [list]" >> .fong/.memory/debug_sessions.md
echo "- Success: [yes/no]" >> .fong/.memory/debug_sessions.md
```

### **Tool Integration**
```bash
# Use modern tools cho analysis:
smart-search-fz-rg-bm25 "ERROR" src/logs/ --show-content   # Primary log search
rg "ERROR|CRITICAL" src/logs/debug.log                      # Fallback regex search
fd "*.py" src/ --exec grep -l "fongdebug" # Check fongdebug usage
bat src/logs/debug.log                    # Pretty view logs
```

## 🎯 TRIẾT LÝ

> **"Debug early, debug often, debug automatically"**
> 
> Thay vì manually debug mỗi lần có lỗi, AI sẽ tự động:
> - Log comprehensive data
> - Detect và analyze errors  
> - Generate và apply fixes
> - Verify fixes work
> - Loop until success
> 
> Mục tiêu: **Zero manual debugging** trong development workflow.

---

**📝 LƯU Ý QUAN TRỌNG:**
1. **fongdebug LUÔN ACTIVE** trong development
2. **./src/logs/debug.log** là single source of truth
3. **AI phải loop fix** cho đến khi code works hoàn toàn  
4. **Only remove fongdebug** khi chuyển production
5. **Log files** phải comprehensive và readable cho AI analysis
