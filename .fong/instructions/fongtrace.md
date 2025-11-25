# 🔍 Fong Trace System - Laravel QTDND Project

**Mục đích:** Debug và trace execution flow cho Laravel 12.x backend trong dự án QTDND Vietnamese Financial Services

## 🎯 Tracing Strategy cho Laravel

**Target Environment:** Laravel 12.x với DDEV + PostgreSQL 17
**Focus Areas:** Vietnamese compliance, CCCD validation, VND transactions

> **Search Priority:** Dùng `smart-search-fz-rg-bm25` cho phân tích log offline. Các lệnh `rg` bên dưới đóng vai trò fallback chuyên cho regex và streaming pipelines.
>
> **Setup reminder:** Tham khảo `.fong/instructions/smartsearch.md` để cài alias và nắm các tham số `--top-k`, `--show-content`.

## 📋 Laravel Tracing Commands

### **Application Logs**
```bash
# Laravel application logs
ddev exec tail -f storage/logs/laravel.log

# DDEV logs
ddev logs -f

# Database queries
ddev exec php artisan telescope:install  # Nếu có Telescope
```

### **Debug Mode Setup**
```bash
# Enable debug mode trong .env
ddev exec sed -i 's/APP_DEBUG=false/APP_DEBUG=true/' .env

# Clear config cache
ddev exec php artisan config:clear
ddev exec php artisan cache:clear
```

## 🔧 Vietnamese-Specific Tracing

### **CCCD Validation Tracing**
```php
// Trong Model hoặc Controller
Log::info('CCCD Validation Start', [
    'cccd' => $cccd,
    'user_id' => auth()->id(),
    'timestamp' => now()
]);

// Validation result
Log::info('CCCD Validation Result', [
    'cccd' => $cccd,
    'is_valid' => $isValid,
    'error' => $validationError ?? null
]);
```

### **VND Transaction Tracing**
```php
// Transaction start
Log::info('VND Transaction Start', [
    'amount' => $amount,
    'currency' => 'VND',
    'user_id' => $userId,
    'transaction_type' => $type
]);

// Formatted amount
Log::debug('VND Amount Formatting', [
    'raw_amount' => $rawAmount,
    'formatted' => number_format($rawAmount, 0, ',', '.') . ' VND'
]);
```

## ⚡ Modern CLI Tools cho Laravel Tracing

### **smart-search-fz-rg-bm25 + ripgrep cho Log Analysis**
```bash
# Primary hybrid search (offline analysis)
smart-search-fz-rg-bm25 "ERROR" storage/logs/ --show-content
smart-search-fz-rg-bm25 "CCCD validation" storage/logs/ --top-k 5

# 🔄 Fallback ripgrep cho streaming/regex pipelines
rg "ERROR|CRITICAL" storage/logs/laravel.log -A 3 -B 1
rg "CCCD|cccd" storage/logs/laravel.log --json | jq '.'
rg "Vietnamese|Việt|VND" storage/logs/laravel.log -i
```

### **jq cho JSON Log Parsing**
```bash
# Parse structured logs (fallback ripgrep + jq)
ddev exec cat storage/logs/laravel.log | rg "^\{" | jq '.'

# Filter by level
ddev exec cat storage/logs/laravel.log | rg "^\{" | jq 'select(.level=="error")'

# Extract CCCD validation logs
ddev exec cat storage/logs/laravel.log | rg "CCCD" | jq '{timestamp: .datetime, cccd: .context.cccd, valid: .context.is_valid}'
```

## 🐛 Laravel Debug Tracing

### **Request Tracing**
```php
// Trong middleware hoặc controller
Log::info('Request Start', [
    'url' => request()->fullUrl(),
    'method' => request()->method(),
    'ip' => request()->ip(),
    'user_agent' => request()->userAgent(),
    'input' => request()->all()
]);
```

### **Database Query Tracing**
```php
// Enable query logging
use Illuminate\Support\Facades\DB;

DB::enableQueryLog();

// Your database operations here

// Get queries
$queries = DB::getQueryLog();
Log::debug('Database Queries', $queries);
```

### **Eloquent Model Tracing**
```php
// Trong Model
protected static function booted()
{
    static::creating(function ($model) {
        Log::info('Creating Model', [
            'model' => get_class($model),
            'attributes' => $model->getAttributes()
        ]);
    });
    
    static::updating(function ($model) {
        Log::info('Updating Model', [
            'model' => get_class($model),
            'changes' => $model->getDirty(),
            'original' => $model->getOriginal()
        ]);
    });
}
```

## 📊 Performance Tracing

### **Response Time Monitoring**
```php
// Trong middleware
public function handle($request, Closure $next)
{
    $startTime = microtime(true);
    
    $response = $next($request);
    
    $executionTime = microtime(true) - $startTime;
    
    Log::info('Request Performance', [
        'url' => $request->fullUrl(),
        'method' => $request->method(),
        'execution_time' => round($executionTime * 1000, 2) . 'ms',
        'memory_usage' => memory_get_peak_usage(true) / 1024 / 1024 . 'MB'
    ]);
    
    return $response;
}
```

### **Database Performance**
```bash
# Slow query log analysis
ddev exec mysql -e "SHOW VARIABLES LIKE 'slow_query_log%'"

# Enable slow query logging
ddev exec mysql -e "SET GLOBAL slow_query_log = 'ON';"
ddev exec mysql -e "SET GLOBAL long_query_time = 1;"  # 1 second threshold
```

## 🔄 Real-time Tracing Commands

### **Live Log Monitoring**
```bash
# Multiple log files simultaneously
ddev exec tail -f storage/logs/laravel.log & 
ddev logs -f &

# With filtering
ddev exec tail -f storage/logs/laravel.log | rg "ERROR|CCCD|Vietnamese"

# JSON logs with jq formatting
ddev exec tail -f storage/logs/laravel.log | rg "^\{" | jq '.'
```

### **DDEV-Specific Tracing**
```bash
# PHP errors
ddev exec tail -f /var/log/php_errors.log

# Nginx access logs
ddev logs web

# Database logs
ddev logs db

# All container logs
ddev logs --all -f
```

## 🎯 Vietnamese Financial Compliance Tracing

### **CCCD Pattern Validation**
```php
Log::debug('CCCD Pattern Check', [
    'input' => $cccd,
    'pattern' => '/^[0-9]{12}$/',
    'matches' => preg_match('/^[0-9]{12}$/', $cccd),
    'length' => strlen($cccd)
]);
```

### **VND Amount Validation**
```php
Log::debug('VND Amount Validation', [
    'raw_input' => $input,
    'parsed_amount' => $amount,
    'min_amount' => 1000000, // 1M VND
    'max_amount' => 1000000000, // 1B VND
    'is_valid_range' => $amount >= 1000000 && $amount <= 1000000000
]);
```

### **Vietnamese Text Encoding**
```php
Log::debug('Vietnamese Encoding Check', [
    'input' => $vietnameseText,
    'encoding' => mb_detect_encoding($vietnameseText),
    'is_utf8' => mb_check_encoding($vietnameseText, 'UTF-8'),
    'char_count' => mb_strlen($vietnameseText, 'UTF-8')
]);
```

## 📈 Trace Analysis Commands

### **Log Statistics**
```bash
# Error count by day
rg "ERROR" storage/logs/laravel.log | cut -d' ' -f1 | sort | uniq -c

# CCCD validation success rate
rg "CCCD.*valid.*true" storage/logs/laravel.log | wc -l
rg "CCCD.*valid.*false" storage/logs/laravel.log | wc -l

# Response time analysis
rg "execution_time.*ms" storage/logs/laravel.log | sed 's/.*execution_time":\([^,]*\).*/\1/' | sort -n | tail -10
```

### **Memory để Trace Patterns**
```bash
# Save common trace patterns
echo "# Common QTDND Trace Patterns

## CCCD Validation Error
rg 'CCCD.*error' storage/logs/laravel.log -A 2 -B 1

## VND Transaction Issues  
rg 'VND.*transaction.*failed' storage/logs/laravel.log --json | jq '.'

## Vietnamese Character Encoding Issues
rg 'encoding.*error|UTF-8.*error' storage/logs/laravel.log
" > .fong/.memory/$(date +%Y%m%d)-trace-patterns.md
```

## 🚀 Integration với DDEV

### **Custom DDEV Commands để Tracing**
```bash
# .ddev/commands/web/trace-errors
#!/bin/bash
tail -f /var/www/html/storage/logs/laravel.log | rg "ERROR|CRITICAL" --color=always

# .ddev/commands/web/trace-cccd
#!/bin/bash  
tail -f /var/www/html/storage/logs/laravel.log | rg "CCCD" --color=always -A 2 -B 1
```

**Lưu ý:** Trace system này tối ưu cho Laravel 12.x với Vietnamese compliance requirements và sử dụng modern CLI tools để phân tích hiệu quả.
