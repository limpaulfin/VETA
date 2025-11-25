# Instructions: MCP Safe Calculation Math Engine

**For AI:** Hướng dẫn chi tiết cách sử dụng `mcp__safe-calculation__calculate` tool

**Date:** 2025-10-15
**Version:** 1.0.0

---

## ⚠️ CRITICAL: TUYỆT ĐỐI KHÔNG SUY LUẬN TÍNH TOÁN

**LUÔN LUÔN GIẢ ĐỊNH: AI SẼ SAI KHI LÀM TOÁN**

- ❌ **KHÔNG BAO GIỜ** tính toán trong reasoning
- ❌ **KHÔNG BAO GIỜ** tự suy luận kết quả
- ✅ **LUÔN LUÔN** dùng MCP tool này cho MỌI phép toán
- ✅ **NẾU MCP KHÔNG AVAILABLE**: Gọi CLI trực tiếp tại `/home/fong/Projects/MCPs/mcp-safe-calculation-math-engine-core/python-cli-core/calc.sh`

**Examples that MUST use this tool:**
- Simple math: `2 + 2`, `10 * 5` → use `eval` operation
- Functions: `sqrt(16)`, `sin(0)` → use `eval` operation
- Conversions: `12 inch to cm` → use `units_convert` operation
- Counting items: count array elements → use `count` operation with `type: "items"`
- Statistics: mean, median, standard deviation → use `stats_describe` operation
- ANY calculation or counting, no matter how trivial

---

## 🎯 Tool Overview

**Tool Name:** `mcp__safe-calculation__calculate`

**Parameters:**
- `operation` (string, required): Operation name (26 total)
- `params` (object, required): Operation-specific parameters **ALL VALUES MUST BE STRINGS**

**Output Format:**
```json
{
  "status": "success|error",
  "operation": "operation_name",
  "data": {
    // Operation-specific results
  }
}
```

---

## 📋 Complete Operations List (27 Operations)

### 1️⃣ Utility Tools (2 operations)

#### `uuid` - UUID Generator
```javascript
// Full UUID
{"operation": "uuid", "params": {"mode": "full", "count": "3"}}

// Tail only (8 chars)
{"operation": "uuid", "params": {"mode": "tail", "count": "5"}}
```

**Parameters:**
- `mode`: "full" | "tail" (default: "full")
- `count`: number of UUIDs (default: "1")

#### `random` - Random Number Generator
```javascript
// Random integers in decimal
{"operation": "random", "params": {"from": "100", "to": "999", "count": "10", "format": "dec"}}

// Hex format
{"operation": "random", "params": {"from": "0", "to": "255", "count": "5", "format": "hex"}}
```

**Parameters:**
- `from`: start range (default: "0")
- `to`: end range (default: "9999")
- `count`: number of values (default: "1")
- `format`: "dec" | "hex" | "bin" | "oct" (default: "dec")

---

### 2️⃣ Expression Evaluator (1 operation)

#### `eval` - Math Expression Evaluation
```javascript
// Basic arithmetic
{"operation": "eval", "params": {"expression": "2 + 3 * 4"}}
// Output: 14

// Functions
{"operation": "eval", "params": {"expression": "sqrt(16) + sin(0)"}}
// Output: 4

// High precision
{"operation": "eval", "params": {"expression": "22/7", "precision": "50"}}
```

**Parameters:**
- `expression`: math expression (required)
- `precision`: decimal places 1-100 (default: "15")

**Supported:**
- Operators: `+`, `-`, `*`, `/`, `%`, `**` (power)
- Functions: `sqrt`, `sin`, `cos`, `tan`, `log`, `exp`, `abs`
- Constants: `pi`, `e`

---

### 3️⃣ BASE-N Converter (1 operation)

#### `base_convert` - Number Base Conversion
```javascript
// Hex to Binary
{"operation": "base_convert", "params": {"value": "FFEE", "from_base": "hex", "to_base": "bin"}}

// Decimal to Hex
{"operation": "base_convert", "params": {"value": "1234", "from_base": "dec", "to_base": "hex"}}

// With bitwise operation
{"operation": "base_convert", "params": {"value": "0xFF", "from_base": "hex", "to_base": "dec", "op": "AND", "operand": "0x0F"}}
```

**Parameters:**
- `value`: input value
- `from_base`: "dec" | "hex" | "oct" | "bin"
- `to_base`: "dec" | "hex" | "oct" | "bin"
- `op`: (optional) "AND" | "OR" | "XOR" | "NOT" | "SHL" | "SHR"
- `operand`: (required if op is provided)

---

### 4️⃣ Counter (1 operation)

#### `count` - Array Counter with Indexed Mapping
**Purpose:** Accurate counting for AI - solves the problem of LLMs miscounting items

```javascript
// Count array items with indexed mapping
{"operation": "count", "params": {"data": "[\"item1\", \"item2\", \"item3\"]", "type": "items"}}
// Output: {"count": 3, "items": [...], "indexed_items": {"1": "item1", "2": "item2", "3": "item3"}}

// Count array of objects
{"operation": "count", "params": {"data": "[{\"file\": \"a.php\", \"status\": \"ACTIVE\"}, {\"file\": \"b.php\"}]", "type": "items"}}
// Output: count=2 with indexed mapping

// Count other types
{"operation": "count", "params": {"data": "hello world", "type": "chars"}}   // count=11 characters
{"operation": "count", "params": {"data": "hello world", "type": "words"}}   // count=2 words
{"operation": "count", "params": {"data": "line1\nline2", "type": "lines"}}  // count=2 lines
```

**Parameters:**
- `data`: Data to count
  - **For arrays**: Must be JSON string, e.g. `"[\"item1\", \"item2\"]"` (NOT direct array)
  - **For text**: Plain string, e.g. `"hello world"`
  - **Important**: ALL params values must be strings (MCP requirement)
- `type`: "items" | "chars" | "words" | "lines" | "keys" | "auto" (default: "auto")

**Output Format for type="items":**
```json
{
  "count": <number>,
  "items": [original array],
  "indexed_items": {
    "1": <first_item>,
    "2": <second_item>,
    ...
  }
}
```

**Use Cases:**
- Count downgrade positions: 13 items → indexed_items shows exact order
- Count files by status: 5 files → know exactly which is #1, #2, etc.
- Prevent AI counting errors: Always accurate count with clear ordering

---

### 5️⃣ Scientific Constants (2 operations)

#### `const_get` - Get CODATA 2022 Constant
```javascript
// By code
{"operation": "const_get", "params": {"code": "01"}}
// Output: c = 299792458 m/s

// By name
{"operation": "const_get", "params": {"name": "h"}}
// Output: Planck constant = 6.62607015e-34 J⋅s
```

**Parameters:**
- `code`: constant code (01-40)
- `name`: constant symbol (e.g., "h", "c", "G")

#### `const_list` - List All Constants
```javascript
{"operation": "const_list", "params": {}}
```

---

### 6️⃣ Complex Numbers (3 operations)

#### `complex_eval` - Complex Number Evaluation
```javascript
{"operation": "complex_eval", "params": {"expression": "(3+4i) * (1-2i)"}}
// Output: 11-2i
```

#### `complex_to_polar` - Rectangular to Polar
```javascript
{"operation": "complex_to_polar", "params": {"re": "3", "im": "4", "angle_mode": "rad"}}
// Output: r=5, theta=0.927 rad
```

#### `complex_from_polar` - Polar to Rectangular
```javascript
{"operation": "complex_from_polar", "params": {"r": "5", "theta": "0.927", "angle_mode": "rad"}}
// Output: re=3, im=4
```

**Parameters:**
- `angle_mode`: "rad" | "deg"

---

### 7️⃣ Unit Conversion (3 operations)

#### `units_convert` - General Unit Conversion
```javascript
{"operation": "units_convert", "params": {"value": "12", "from_unit": "inch", "to_unit": "cm"}}
// Output: 30.48 cm

{"operation": "units_convert", "params": {"value": "100", "from_unit": "kg", "to_unit": "lb"}}
// Output: 220.46 lb
```

#### `units_quick` - Quick Conversion (Preset Codes)
```javascript
{"operation": "units_quick", "params": {"code": "01", "value": "12"}}
// Output: 30.48 cm (inch → cm)
```

**Preset Codes:**
```
01: inch ↔ cm        08: yard ↔ m
02: ft ↔ m           09: mile ↔ km
03: lb ↔ kg          10: oz ↔ g
04: gal ↔ L          11: atm ↔ Pa
05: °F ↔ °C          12: hp ↔ W
06: acre ↔ m²        13: cal ↔ J
07: sqft ↔ m²        14: psi ↔ Pa
```

#### `units_list` - List Preset Conversions
```javascript
{"operation": "units_list", "params": {}}
```

---

### 8️⃣ Statistics (4 operations)

#### `stats_describe` - Descriptive Statistics
```javascript
{"operation": "stats_describe", "params": {"data": "[1,2,3,4,5]"}}
// Output: mean=3, median=3, stdev=1.414, min=1, max=5
```

#### `stats_regress` - Regression Analysis
```javascript
// Linear regression
{"operation": "stats_regress", "params": {"x": "[1,2,3,4,5]", "y": "[2,4,6,8,10]", "model": "lin"}}
// Output: slope=2.0, intercept=0.0, r²=1.0
```

**Models:** "lin", "log", "exp", "power"

#### `prob_dist` - Probability Distributions
```javascript
// Normal distribution PDF
{"operation": "prob_dist", "params": {"dist": "normal", "func": "pdf", "x": "0", "mu": "0", "sigma": "1"}}
// Output: 0.3989
```

**Distributions:** normal, t, chi2, F, binomial, poisson
**Functions:** pdf, cdf, ppf

#### `stat_test` - Statistical Tests
```javascript
// t-test
{"operation": "stat_test", "params": {"test": "t_test", "data1": "[1,2,3,4,5]", "data2": "[2,3,4,5,6]"}}
// Output: statistic=-1.0, p_value=0.347
```

**Tests:** t_test, chi2, ks_test

---

### 9️⃣ Equation Solvers (2 operations)

#### `solve_linear` - Linear System Solver
```javascript
// Solve: 2x + y = 5, x + 3y = 8
{"operation": "solve_linear", "params": {"A": "[[2,1],[1,3]]", "b": "[5,8]"}}
// Output: x=1, y=3
```

#### `solve_poly` - Polynomial Solver
```javascript
// Solve: x² - 5x + 6 = 0
{"operation": "solve_poly", "params": {"coeffs": "[1,-5,6]"}}
// Output: roots=[2, 3]
```

---

### 🔟 Calculus (3 operations)

#### `differentiate` - Derivative
```javascript
{"operation": "differentiate", "params": {"expr": "x^2", "var": "x", "at": "2"}}
// Output: 4
```

#### `integrate` - Definite Integral
```javascript
{"operation": "integrate", "params": {"expr": "x^2", "var": "x", "from": "0", "to": "1"}}
// Output: 0.333...
```

#### `limit` - Limit Calculation
```javascript
// Classic limit
{"operation": "limit", "params": {"expr": "sin(x)/x", "var": "x", "to": "0", "direction": "+-"}}
// Output: 1

// Limit at infinity
{"operation": "limit", "params": {"expr": "1/x", "var": "x", "to": "inf"}}
// Output: 0
```

**Parameters:**
- `direction`: "+" | "-" | "+-" (default: "+-")

---

### 1️⃣1️⃣ Combinatorics & Number Theory (2 operations)

#### `combinatorics` - Combinatorial Functions
```javascript
// nCr (combinations)
{"operation": "combinatorics", "params": {"func": "nCr", "n": "10", "r": "3"}}
// Output: 120

// nPr (permutations)
{"operation": "combinatorics", "params": {"func": "nPr", "n": "10", "r": "3"}}
// Output: 720

// Factorial
{"operation": "combinatorics", "params": {"func": "factorial", "n": "5"}}
// Output: 120
```

**Functions:** nCr, nPr, factorial

#### `number_theory` - Number Theory Operations
```javascript
// GCD
{"operation": "number_theory", "params": {"func": "gcd", "a": "48", "b": "18"}}
// Output: 6

// LCM
{"operation": "number_theory", "params": {"func": "lcm", "a": "12", "b": "18"}}
// Output: 36

// Prime check
{"operation": "number_theory", "params": {"func": "isprime", "a": "17"}}
// Output: true

// Modular exponentiation
{"operation": "number_theory", "params": {"func": "powmod", "a": "2", "b": "10", "m": "1000"}}
// Output: 24
```

**Functions:** gcd, lcm, isprime, powmod

---

### 1️⃣2️⃣ Linear Algebra (2 operations)

#### `matrix_op` - Matrix Operations
```javascript
// Determinant
{"operation": "matrix_op", "params": {"op": "det", "A": "[[1,2],[3,4]]"}}
// Output: -2.0

// Inverse
{"operation": "matrix_op", "params": {"op": "inv", "A": "[[1,2],[3,4]]"}}
// Output: [[-2.0,1.0],[1.5,-0.5]]

// Matrix addition
{"operation": "matrix_op", "params": {"op": "add", "A": "[[1,2],[3,4]]", "B": "[[5,6],[7,8]]"}}
// Output: [[6,8],[10,12]]
```

**Operations:** add, sub, mul, det, inv, rank, trace, transpose

#### `vector_op` - Vector Operations
```javascript
// Dot product
{"operation": "vector_op", "params": {"op": "dot", "u": "[1,2,3]", "v": "[4,5,6]"}}
// Output: 32.0

// Cross product
{"operation": "vector_op", "params": {"op": "cross", "u": "[1,0,0]", "v": "[0,1,0]"}}
// Output: [0,0,1]

// Norm (magnitude)
{"operation": "vector_op", "params": {"op": "norm", "u": "[3,4]"}}
// Output: 5.0

// Angle between vectors
{"operation": "vector_op", "params": {"op": "angle", "u": "[1,0]", "v": "[0,1]"}}
// Output: 1.571 rad (90°)
```

**Operations:** dot, cross, norm, angle

---

### 1️⃣3️⃣ Batch Processing (1 operation)

#### `batch` - Execute Multiple Operations

**Purpose:** Execute multiple calculations in a single request with labeled results

```javascript
// Basic batch
{"operation": "batch", "params": {"operations": [
  {"name": "calc1", "operation": "eval", "params": {"expression": "2+2"}},
  {"name": "calc2", "operation": "uuid", "params": {"mode": "tail"}}
]}}

// Multiple calculations
{"operation": "batch", "params": {"operations": [
  {"name": "total", "operation": "eval", "params": {"expression": "100+200+300"}},
  {"name": "average", "operation": "eval", "params": {"expression": "(100+200+300)/3"}},
  {"name": "report_id", "operation": "uuid", "params": {"mode": "tail"}}
]}}

// Multi-unit conversions
{"operation": "batch", "params": {"operations": [
  {"name": "km_to_mile", "operation": "units_convert", "params": {"value": "100", "from_unit": "km", "to_unit": "mile"}},
  {"name": "kg_to_lb", "operation": "units_convert", "params": {"value": "50", "from_unit": "kg", "to_unit": "lb"}},
  {"name": "celsius_to_f", "operation": "units_quick", "params": {"code": "05", "value": "25"}}
]}}
```

**Parameters:**
- `operations`: Array of operation objects
  - Each object requires: `name` (label), `operation` (type), `params` (operation-specific)
  - Order is preserved in results
  - Labels can be Vietnamese: `"name": "phép tính 1"`

**Output Format:**
```json
{
  "status": "success|error",
  "operation": "batch",
  "data": {
    "total": <number>,
    "successful": <number>,
    "failed": <number>,
    "results": [
      {
        "order": <number>,
        "name": "operation_label",
        "status": "success|error",
        "operation": "operation_type",
        "result": {...}
      }
    ]
  }
}
```

**Key Features:**
- **Partial success**: Batch succeeds if ≥1 operation succeeds
- **Order preservation**: Results return in same order as input
- **Error isolation**: Individual failures don't stop other operations
- **Labeled results**: Easy to identify results by name

**Common Use Cases:**
- Multiple related calculations (total, average, percentage)
- Data conversion pipelines (format conversion → validation → stats)
- Multi-unit conversions (distance, weight, temperature)
- Report generation (calculations + UUID + timestamp)

**Documentation:**
- Quick reference: `mcp-safe-calculation-math-engine-core/python-cli-core/BATCH_QUICK_REFERENCE.md`
- Full guide: `mcp-safe-calculation-math-engine-core/python-cli-core/BATCH_FEATURE.md`
- Implementation: `mcp-safe-calculation-math-engine-core/python-cli-core/BATCH_IMPLEMENTATION_SUMMARY.md`

---

## 🔄 Fallback: Direct CLI Call

**If MCP not available**, call Python CLI directly:

```bash
/home/fong/Projects/MCPs/mcp-safe-calculation-math-engine-core/python-cli-core/calc.sh '{"operation": "eval", "params": {"expression": "2 + 2"}}'
```

### CLI Help Command

**If tool call fails or you need to verify usage**, check the CLI help:

```bash
/home/fong/Projects/MCPs/mcp-safe-calculation-math-engine-core/python-cli-core/calc.sh --help
```

**Help Output Summary:**
- Lists all 27 operations with descriptions (including batch)
- Shows exact JSON parameter format for each operation
- Provides example usage for every operation
- Notes: All parameter values must be strings
- Returns JSON with fields: status, operation, data

**Common CLI Help Usage:**
```bash
# Show full help with all 27 operations
/home/fong/Projects/MCPs/mcp-safe-calculation-math-engine-core/python-cli-core/calc.sh --help

# Example operations from help:
# 01. uuid: Generate UUID values
# 02. random: Random integers in dec/hex/bin/oct
# 03. eval: Evaluate math expressions
# 04. base_convert: Convert between number bases
# 05. count: Count items/chars/words/lines
# 27. batch: Execute multiple operations in one request
# ... (21 more operations)
```

**When to use `--help`:**
- Tool call returns error or unexpected result
- Need to verify exact parameter names/format
- Checking available operations
- Confirming parameter constraints
- Troubleshooting failed calculations

---

## 📚 Additional Resources

- **Python CLI README**: `/home/fong/Projects/MCPs/mcp-safe-calculation-math-engine-core/python-cli-core/README.md`
- **HOW-TO-USE-MCP**: `/home/fong/Projects/MCPs/mcp-safe-calculation-math-engine-core/HOW-TO-USE-MCP.md`
- **MCP README**: `/home/fong/Projects/MCPs/mcp-safe-calculation-math-engine-core/mcp/README.md`

---

**Last Updated:** 2025-11-14
**Version:** 1.3.0 (Added batch operation - execute multiple calculations in single request)
