# AutoChrome Local Endpoint Guide

**Version**: 2025-10-01 6fe6d5fca8cf
**Updated**: 2025-10-01
**Environment**: Local Machine Chromium
**Purpose**: Complete endpoint testing, form automation, CSS style extraction, and screenshot capture

## 🚀 Quick Start Scripts

### Start Backend Node.js Server
```bash
# Khởi động backend trên port 49445 (local only, no SSH)
./start_backend.sh

# Backend sẽ:
# - Kill process cũ nếu có
# - Start Node.js server mới
# - Health check tự động
# - Log: backend-node/mindact-node.log
```

### Restart Chromium với CDP
```bash
# Tắt hẳn và khởi động lại Chromium với Chrome DevTools Protocol
./start_chromium_restart.sh

# Script sẽ:
# - Tắt hẳn chromium-browser (CHỈ chromium, KHÔNG phải Chrome)
# - Bật lại với CDP port 9222
# - Mở tab https://google.com.vn
# - Verify CDP connection
```

**Tested**:
- Backend: 3/3 lần thành công (2025-10-01)
- Chromium: 3/3 lần thành công với wmctrl (2025-10-01)
  - Test 1: Start mới khi chưa chạy ✅
  - Test 2: Start khi CDP active nhưng không có cửa sổ ✅
  - Test 3: Restart - Đóng cửa sổ cũ + Start mới ✅

**Lưu ý quan trọng**: Script sử dụng `wmctrl` để đóng cửa sổ "Google - Chromium" (CHỈ cửa sổ có CDP port 9222), KHÔNG động đến Google Chrome browser của user.

## 📚 Table of Contents / Mục lục

### Core API Documentation
- [📋 Endpoints Testing & Documentation](#-endpoints-testing--documentation)
  - [1. Session Management](#1-session-management)
  - [2. Tab Management](#2-tab-management)
  - [3. JavaScript Execution](#3-javascript-execution)
  - [4. DOM & Content Extraction](#4-dom--content-extraction)
  - [9. DOM Extraction with File Output](#9-dom-extraction-with-file-output)
  - [10. Text Extraction with File Output](#10-text-extraction-with-file-output)
  - [11. List Extraction Files](#11-list-extraction-files)
  - [12. Screenshot Capture Operations](#12-screenshot-capture-operations)

### Agent Workflow & Best Practices
- [🎯 AGENT WORKFLOW: DOM First → Learn → Execute](#-agent-workflow-dom-first--learn--execute-strategy)
- [🎯 Common Usage Patterns](#-common-usage-patterns)
- [🔒 JavaScript Security & Best Practices](#-javascript-security--best-practices)
  - [ULTRA-SHORT VANILLA JS (PRIORITY METHOD)](#ultra-short-vanilla-js-priority-method)
  - [Proven Form Element Patterns](#proven-form-element-patterns)
  - [CSS Style Extraction Patterns](#css-style-extraction-patterns)
  - [JSON Escape-Safe Patterns](#json-escape-safe-patterns)
  - [KISS (Keep It Super Simple) Rules](#kiss-keep-it-super-simple-rules)
  - [Multiple Calls Strategy](#multiple-calls-strategy)

### Interactive Operations (TESTED)
- [🎯 Interactive Operations](#-interactive-operations-tested)
  - [5. Click Operations](#5-click-operations-minified-javascript---1-line)
  - [6. Form Filling Operations](#6-form-filling-operations-minified-javascript---1-line)
  - [7. Scroll Operations](#7-scroll-operations)
  - [8. Checkbox/Radio/Select Operations](#8-checkboxradioselect-operations)

### Technical Reference
- [⚡ Performance Notes](#-performance-notes)
- [🐛 Troubleshooting](#-troubleshooting)
- [📈 Future Testing](#-future-testing)

### Quick Reference - Copy & Paste Scripts
- [Form Elements](#proven-form-element-patterns): Email, Password, Text, Radio, Checkbox, Textarea, Dropdown
- [CSS Extraction](#css-style-extraction-patterns): Single element, Multi-element batch, Comprehensive analysis
- [Console Logs](#console-logs-extraction-patterns): DevTools extraction, Error/warning detection, Message analysis
- [Visual Effects](#kiss-keep-it-super-simple-rules): Color highlighting, Transform scaling, Focus/blur validation

## 📋 Endpoints Testing & Documentation

### 1. Session Management

#### Create Session
```bash
# Command
curl -X POST http://localhost:49445/api/session/create -H 'Content-Type: application/json'

# Response Format
{
  "success": true,
  "session": {
    "id": "session-uuid-here",
    "created": "2025-09-15T13:58:02.812Z",
    "lastActive": "2025-09-15T13:58:02.812Z"
  }
}

# Status: ✅ TESTED
# Notes: Tạo session thành công, trả về UUID để sử dụng cho các request tiếp theo
```

### 2. Tab Management

#### List Tabs
```bash
# Command
curl -s http://localhost:49445/api/tabs/list | jq

# Response Format
{
  "success": true,
  "tabs": [
    {
      "id": "TAB_ID_HEX",
      "title": "Tab Title",
      "url": "https://example.com",
      "description": "No description",
      "isDevTools": false,
      "isActive": true/false
    }
  ]
}

# Status: ✅ TESTED
# Notes: Hiển thị tất cả tab với thông tin chi tiết, bao gồm DevTools tabs
```

#### Current Tab
```bash
# Command
curl -X GET http://localhost:49445/api/tabs/current

# Response Format
{
  "success": true,
  "currentTab": {
    "id": "TAB_ID",
    "title": "Current Tab Title",
    "url": "https://current-tab-url.com"
  }
}

# Status: ✅ TESTED
# Notes: Trả về thông tin tab hiện đang được chọn/active
```

#### Select Tab
```bash
# Command
curl -X POST http://localhost:49445/api/tabs/select -H 'Content-Type: application/json' -d '{"tabId":"TAB_ID_HERE","reason":"Optional reason"}'

# Example
curl -X POST http://localhost:49445/api/tabs/select -H 'Content-Type: application/json' -d '{"tabId":"2B7254B7A937CF28E8366F2BEC0988FF","reason":"Testing select tab endpoint"}'

# Response Format
{
  "success": true,
  "selectedTab": {
    "id": "2B7254B7A937CF28E8366F2BEC0988FF",
    "title": "Tab Title",
    "url": "https://tab-url.com",
    "reason": "Testing select tab endpoint"
  }
}

# Status: ✅ TESTED
# Notes: Chuyển đổi tab thành công, trả về thông tin tab đã chọn
```

### 3. JavaScript Execution

#### Execute Script
```bash
# Command Format
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' -d '{"sessionId":"SESSION_ID","script":"JAVASCRIPT_CODE"}'

# Example: Get page info
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' -d '{"sessionId":"eae7b9f0-c778-4610-9d39-f653215f2fbc","script":"document.title + \" - Current URL: \" + window.location.href"}'

# Response Format
{
  "success": true,
  "result": "Script execution result here"
}

# Status: ✅ TESTED  
# Notes: Thực thi JavaScript thành công, trả về kết quả execution
```

### 4. DOM & Content Extraction

#### Get DOM HTML
```bash
# Command: Extract complete DOM as JSON
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' -d '{"sessionId":"SESSION_ID","script":"JSON.stringify({url: window.location.href, title: document.title, html: document.documentElement.outerHTML})"}'

# Example: Truncated DOM for testing
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' -d '{"sessionId":"eae7b9f0-c778-4610-9d39-f653215f2fbc","script":"JSON.stringify({url: window.location.href, title: document.title, html: document.documentElement.outerHTML.substring(0,500) + \"...[TRUNCATED]\"})"}'

# Status: ✅ TESTED
# Notes: Trả về complete DOM HTML trong JSON format
```

#### Get Page Text
```bash
# Command: Extract readable text content
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' -d '{"sessionId":"SESSION_ID","script":"document.body.innerText || document.body.textContent"}'

# Example: Truncated text
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' -d '{"sessionId":"eae7b9f0-c778-4610-9d39-f653215f2fbc","script":"document.body.innerText.substring(0,200) + \"...[TRUNCATED]\""}'

# Status: ✅ TESTED
# Notes: Trích xuất text content thành công, có thể dùng để phân tích nội dung page
```

## 🎯 AGENT WORKFLOW: DOM First → Learn → Execute Strategy

### Core Philosophy: Always Extract First!
**IMPORTANT**: Following AutoChrome agent approach - NEVER take action without understanding page structure first.

#### Workflow Steps:
1. **🔍 EXTRACT DOM FIRST**: Always get full page structure before taking action
2. **📚 LEARN & ANALYZE**: Understand the page context and available elements  
3. **🎯 PLAN ACTIONS**: Choose safest and most reliable approach
4. **⚡ EXECUTE SAFELY**: Take informed actions based on understanding

## 🚀 NEW: Dedicated DOM & Text Extraction Endpoints

### 9. DOM Extraction with File Output
```bash
# Extract complete DOM and save to downloads/
curl -X POST http://localhost:49445/api/dom/extract -H 'Content-Type: application/json' -d '{"sessionId":"SESSION_ID"}'

# Response includes file path and metadata
{
  "success": true,
  "filepath": "/home/fong/Projects/MindAct/backend-node/downloads/DOM-uuid.html",
  "filename": "DOM-310d69e5-3ce0-40fb-9547-7b7e16127c0f.html",
  "uuid": "310d69e5-3ce0-40fb-9547-7b7e16127c0f",
  "url": "https://scholar.google.com/...",
  "title": "Page Title",
  "fileSize": 292,
  "timestamp": "2025-09-15 14:10:13"
}

# Status: ✅ TESTED & WORKING
# Notes: Tạo file DOM với UUID unique, metadata header, lưu vào downloads/
```

### 10. Text Extraction with File Output  
```bash
# Extract page text and save to downloads/
curl -X POST http://localhost:49445/api/text/extract -H 'Content-Type: application/json' -d '{"sessionId":"SESSION_ID"}'

# Response format
{
  "success": true,
  "filepath": "/home/fong/Projects/MindAct/backend-node/downloads/plain-text-uuid.txt",
  "filename": "plain-text-615fe165-8558-45fa-9670-d1ad8fbda7e5.txt",
  "uuid": "615fe165-8558-45fa-9670-d1ad8fbda7e5",
  "url": "https://current-page-url.com",
  "title": "Page Title", 
  "fileSize": 6,
  "timestamp": "2025-09-15 14:10:20"
}

# Status: ✅ TESTED & WORKING
# Notes: Tạo file text với UUID unique, metadata header, lưu vào downloads/
```

### 11. List Extraction Files
```bash  
# List all extraction files (DOM + text)
curl -X GET http://localhost:49445/api/extractions/list | jq

# Filter by type: dom, text, or all
curl -X GET http://localhost:49445/api/extractions/list?type=dom | jq
curl -X GET http://localhost:49445/api/extractions/list?type=text | jq

# Response includes file details sorted by newest first
{
  "success": true,
  "files": [
    {
      "filename": "DOM-310d69e5-3ce0-40fb-9547-7b7e16127c0f.html",
      "filepath": "/full/path/to/file",
      "size": 299083,
      "sizeKB": 292,
      "created": "2025-09-15T14:10:13.571Z",
      "modified": "2025-09-15T14:10:13.571Z"
    }
  ],
  "count": 14,
  "type": "all"
}

# Status: ✅ TESTED & WORKING
# Notes: Shows all files in downloads/, sorted by newest first
```

### 12. Screenshot Capture Operations

#### Basic Screenshot Capture
```bash
# Command: Capture current viewport screenshot
curl -X POST http://localhost:49445/api/screenshot/capture -H 'Content-Type: application/json' -d '{"sessionId":"SESSION_ID","options":{"format":"png","quality":90}}'

# Response Format
{
  "success": true,
  "screenshot": {
    "id": "73762d55-eb1c-400a-af73-68ba78c01f3b",
    "filename": "screenshot-2025-09-17T13-02-25-998Z-73762d55-eb1c-400a-af73-68ba78c01f3b.png",
    "filepath": "/home/fong/Projects/MindAct/backend-node/downloads/screenshots/screenshot-file.png",
    "format": "png", 
    "size": 46212,
    "timestamp": "2025-09-17T13:02:25.999Z",
    "options": {"format": "png"},
    "url": "unknown"
  }
}

# Status: ✅ TESTED
# Notes: Captures current viewport (46KB), saves to downloads/screenshots/
```

#### Region Screenshot Capture
```bash
# Command: Capture specific region with coordinates
curl -X POST http://localhost:49445/api/screenshot/capture-region -H 'Content-Type: application/json' -d '{"sessionId":"SESSION_ID","clip":{"x":0,"y":0,"width":400,"height":300,"scale":1},"options":{"format":"png"}}'

# Response Format
{
  "success": true,
  "screenshot": {
    "id": "cea52a3e-8257-45bc-a825-ea2bb40ae00d",
    "filename": "screenshot-2025-09-17T13-02-46-850Z-cea52a3e-8257-45bc-a825-ea2bb40ae00d.png",
    "filepath": "/home/fong/Projects/MindAct/backend-node/downloads/screenshots/screenshot-file.png",
    "format": "png",
    "size": 1349,
    "timestamp": "2025-09-17T13:02:46.850Z",
    "options": {
      "format": "png",
      "clip": {"x": 0, "y": 0, "width": 400, "height": 300, "scale": 1}
    },
    "url": "unknown"
  }
}

# Status: ✅ TESTED  
# Notes: Smaller file (1.3KB for 400x300px), requires clip.scale parameter
```

#### Full Page Screenshot Capture
```bash
# Command: Capture entire page beyond viewport
curl -X POST http://localhost:49445/api/screenshot/capture-full-page -H 'Content-Type: application/json' -d '{"sessionId":"SESSION_ID","options":{"format":"png"}}'

# Response Format  
{
  "success": true,
  "screenshot": {
    "id": "7bdd74a6-1999-4c79-99ad-421c7e420dea",
    "filename": "screenshot-2025-09-17T13-03-03-247Z-7bdd74a6-1999-4c79-99ad-421c7e420dea.png",
    "filepath": "/home/fong/Projects/MindAct/backend-node/downloads/screenshots/screenshot-file.png",
    "format": "png",
    "size": 28833,
    "timestamp": "2025-09-17T13:03:03.247Z",
    "options": {
      "format": "png",
      "captureBeyondViewport": true
    },
    "url": "unknown"
  }
}

# Status: ✅ TESTED
# Notes: Captures entire page (28KB), includes captureBeyondViewport:true
```

#### List All Screenshots
```bash
# Command: Get all captured screenshots
curl -X GET http://localhost:49445/api/screenshots/list | jq '.count'

# Response Format
{
  "success": true,
  "screenshots": [
    {
      "id": "screenshot-uuid",
      "filename": "screenshot-timestamp-uuid.png", 
      "filepath": "/full/path/to/screenshot",
      "format": "png",
      "size": 46212,
      "timestamp": "2025-09-17T13:02:25.999Z",
      "options": {"format": "png"},
      "url": "unknown"
    }
  ],
  "count": 5
}

# Status: ✅ TESTED
# Notes: Returns all screenshots with metadata, count shows total number
```

#### Get Screenshot Metadata
```bash
# Command: Get specific screenshot info by ID
curl -X GET http://localhost:49445/api/screenshot/SCREENSHOT_ID | jq '.screenshot | {id: .id, filename: .filename, size: .size, format: .format}'

# Response Format
{
  "id": "73762d55-eb1c-400a-af73-68ba78c01f3b",
  "filename": "screenshot-2025-09-17T13-02-25-998Z-73762d55-eb1c-400a-af73-68ba78c01f3b.png",
  "size": 46212,
  "format": "png"
}

# Status: ✅ TESTED
# Notes: Returns complete metadata for specific screenshot
```

#### Download Raw Screenshot Image
```bash 
# Command: Get raw image file (headers check)
curl -X GET http://localhost:49445/api/screenshot/SCREENSHOT_ID/image -I

# Response Headers
HTTP/1.1 200 OK
Content-Type: image/png
Content-Length: 46212
ETag: W/"b484-XO2o1rTcxhFzyQ3IfTLTm371O90"

# Status: ✅ TESTED  
# Notes: Returns actual PNG file, can be saved directly or viewed in browser
```

#### Delete Screenshot
```bash
# Command: Delete specific screenshot by ID
curl -X DELETE http://localhost:49445/api/screenshot/SCREENSHOT_ID

# Response Format
{
  "success": true,
  "message": "Screenshot deleted successfully"
}

# Status: ✅ TESTED
# Notes: Removes both file and metadata, irreversible operation
```

#### Cleanup Old Screenshots
```bash
# Command: Remove screenshots older than specified hours
curl -X POST http://localhost:49445/api/screenshots/cleanup -H 'Content-Type: application/json' -d '{"hoursOld":24}'

# Response Format
{
  "success": true,
  "results": {
    "deleted": 0,
    "failed": 0, 
    "remaining": 4
  }
}

# Status: ✅ TESTED
# Notes: Batch cleanup operation, returns deletion statistics
```

### 📁 Screenshot File Storage Location

**Primary Directory**: `/home/fong/Projects/MindAct/backend-node/downloads/screenshots/`

**File Naming Convention**: `screenshot-YYYY-MM-DDTHH-MM-SS-sssZ-uuid.format`
- Example: `screenshot-2025-09-17T13-02-25-998Z-73762d55-eb1c-400a-af73-68ba78c01f3b.png`

**File Formats Supported**: 
- PNG (default, lossless)
- JPEG (with quality parameter)

**File Size Examples**:
- Viewport screenshot: ~46KB  
- Region screenshot (400x300): ~1.3KB
- Full page screenshot: ~28KB

**Management**:
- Auto-cleanup available via `/api/screenshots/cleanup`
- Manual deletion via `/api/screenshot/:id` DELETE
- Metadata stored in-memory with UUID indexing
- Files persist across backend restarts

**💡 RECOMMENDED WORKFLOW - Copy to Project Tmp Directories**:

After capturing screenshots, copy them to project tmp directories for easier access:

```bash
# Copy screenshot to project .fong/.tmp directory (recommended)
cp /home/fong/Projects/MindAct/backend-node/downloads/screenshots/screenshot-*.png \
   /home/fong/Projects/MindAct/.fong/.tmp/

# Alternative: Copy to backend tmp directory  
cp /home/fong/Projects/MindAct/backend-node/downloads/screenshots/screenshot-*.png \
   /home/fong/Projects/MindAct/backend-node/tmp/

# Copy specific screenshot by ID
SCREENSHOT_ID="73762d55-eb1c-400a-af73-68ba78c01f3b"
cp /home/fong/Projects/MindAct/backend-node/downloads/screenshots/*${SCREENSHOT_ID}*.png \
   /home/fong/Projects/MindAct/.fong/.tmp/
```

**Available Tmp Directories**:
- `/home/fong/Projects/MindAct/.fong/.tmp/` - Project temp files (hidden directory)
- `/home/fong/Projects/MindAct/backend-node/tmp/` - Backend temp directory

**Benefits of Copying to Tmp**:
- Easier file navigation and access
- Temporary workspace for image processing
- Organized separation from permanent storage
- Quick cleanup with single directory deletion

## 🎯 Common Usage Patterns

### Pattern 1: AGENT WORKFLOW - Complete Page Analysis
```bash
# Step 1: Create session
SESSION_RESPONSE=$(curl -X POST http://localhost:49445/api/session/create -H 'Content-Type: application/json')
SESSION_ID=$(echo $SESSION_RESPONSE | jq -r '.session.id')

# Step 2: List available tabs
curl -s http://localhost:49445/api/tabs/list | jq

# Step 3: Select target tab  
curl -X POST http://localhost:49445/api/tabs/select -H 'Content-Type: application/json' -d '{"tabId":"TAB_ID"}'

# Step 4: 🔍 EXTRACT DOM FIRST (ALWAYS FIRST!)
curl -X POST http://localhost:49445/api/dom/extract -H 'Content-Type: application/json' -d '{"sessionId":"$SESSION_ID"}'

# Step 5: 📚 EXTRACT TEXT CONTENT (Learn page context)
curl -X POST http://localhost:49445/api/text/extract -H 'Content-Type: application/json' -d '{"sessionId":"$SESSION_ID"}'

# Step 6: 🎯 ANALYZE extracted files before taking action (LOCAL)
# Read DOM file to understand structure:
cat /home/fong/Projects/MindAct/backend-node/downloads/DOM-*.html | grep -i "form\|input\|button" | head -10
grep -o 'input[^>]*' /home/fong/Projects/MindAct/backend-node/downloads/DOM-*.html | head -5

# Read text file to understand page content:
cat /home/fong/Projects/MindAct/backend-node/downloads/plain-text-*.txt | head -20

# Step 7: ⚡ NOW execute actions based on understanding
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' -d '{"sessionId":"$SESSION_ID","script":"INFORMED_ACTION_SCRIPT"}'
```

### Pattern 2: Search Form Interaction (AGENT APPROACH)
```bash
# ❌ WRONG: Don't do this first!  
# curl -X POST .../api/execute... # Blind action

# ✅ CORRECT: Always extract first!
# Step 1: Extract DOM to understand form structure
curl -X POST http://localhost:49445/api/dom/extract -H 'Content-Type: application/json' -d '{"sessionId":"$SESSION_ID"}'

# Step 2: Extract text to understand page context  
curl -X POST http://localhost:49445/api/text/extract -H 'Content-Type: application/json' -d '{"sessionId":"$SESSION_ID"}'

# Step 3: Analyze extracted files - find actual input names/IDs (LOCAL)
grep -i "input.*name.*q\|input.*id.*search" /home/fong/Projects/MindAct/backend-node/downloads/DOM-*.html
grep -o 'input[^>]*' /home/fong/Projects/MindAct/backend-node/downloads/DOM-*.html | head -5

# Step 4: Now execute INFORMED actions based on analysis
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' -d '{"sessionId":"$SESSION_ID","script":"document.querySelector(\"input[name=q]\") ? \"Found\" : \"Not found\""}'

# Step 5: Fill and submit (only after confirming element exists)
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' -d '{"sessionId":"$SESSION_ID","script":"document.querySelector(\"input[name=q]\").value = \"search term\"; document.querySelector(\"form\").submit(); \"Search submitted\""}'
```

## 🎯 Interactive Operations (TESTED)

### 5. Click Operations (MINIFIED JavaScript - 1 Line)
```bash
# Basic Click with Visual Feedback (Minified for Safety)
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' -d '{"sessionId":"SESSION_ID","script":"var b=document.querySelector(\"SELECTOR\");b?(b.style.backgroundColor=\"yellow\",b.style.border=\"3px solid red\",b.scrollIntoView(),setTimeout(function(){b.click()},1000),\"Element highlighted and will be clicked in 1s\"):\"Element not found\""}'

# Find Clickable Elements (Minified)
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' -d '{"sessionId":"SESSION_ID","script":"var e=[];document.querySelectorAll(\"a,button,input[type=submit]\").forEach(function(l,i){i<5&&e.push(l.tagName+\" - \"+(l.textContent||l.value||l.name||\"no-text\").substring(0,30))});e.join(\" | \")"}'

# Status: ✅ TESTED on Google Scholar
# Notes: Visual feedback hoạt động tốt, cần thêm delay cho user nhìn thấy
```

### 6. Form Filling Operations (MINIFIED JavaScript - 1 Line)
```bash
# Fill Text Input with Visual Feedback (Minified)  
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' -d '{"sessionId":"SESSION_ID","script":"var i=document.querySelector(\"input[name=q]\");i?(i.style.backgroundColor=\"lightblue\",i.style.border=\"2px solid blue\",i.value=\"Your text here\",i.focus(),i.blur(),\"Input found, filled, and highlighted\"):\"Input not found\""}'

# Fill Multiple Form Fields (Minified)
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' -d '{"sessionId":"SESSION_ID","script":"var e=document.querySelector(\"input[type=email]\"),p=document.querySelector(\"input[type=password]\");e&&p?(e.value=\"test@example.com\",p.value=\"password123\",\"Form fields filled\"):\"Form fields not found\""}'

# Status: ✅ TESTED on Google Scholar search input
# Notes: focus()/blur() events trigger validation, visual feedback rõ ràng
```

### 7. Scroll Operations
```bash
# Scroll to Specific Position
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' -d '{"sessionId":"SESSION_ID","script":"window.scrollTo(0, 500); \"Scrolled to 500px from top\""}'

# Scroll with Animation and Return
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' -d '{"sessionId":"SESSION_ID","script":"window.scrollTo(0, 500); setTimeout(function() { window.scrollTo(0, 0); }, 1000); \"Scrolled down 500px, will return to top in 1s\""}'

# Scroll to Element
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' -d '{"sessionId":"SESSION_ID","script":"var el = document.querySelector(\"SELECTOR\"); if(el) { el.scrollIntoView({behavior: \"smooth\", block: \"center\"}); \"Scrolled to element\"; } else { \"Element not found\"; }"}'

# Status: ✅ TESTED
# Notes: Smooth scrolling hoạt động tốt, có thể thấy chuyển động
```

### 8. Checkbox/Radio/Select Operations
```bash
# Toggle Checkbox/Radio
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' -d '{"sessionId":"SESSION_ID","script":"var cb = document.querySelector(\"input[type=checkbox]\"); if(cb) { cb.checked = !cb.checked; cb.style.transform = \"scale(1.5)\"; \"Checkbox toggled and highlighted\"; } else { \"Checkbox not found\"; }"}'

# Count Form Elements
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' -d '{"sessionId":"SESSION_ID","script":"var inputs = document.querySelectorAll(\"input[type=checkbox], input[type=radio]\"); inputs.length + \" checkboxes/radios found\""}'

# Select Dropdown Option
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' -d '{"sessionId":"SESSION_ID","script":"var select = document.querySelector(\"select\"); if(select) { select.selectedIndex = 1; select.style.backgroundColor = \"lightgreen\"; \"Dropdown option selected\"; } else { \"Dropdown not found\"; }"}'

# Status: ✅ TESTED  
# Notes: Transform scale effect visible, Google Scholar có 2 checkbox/radio elements
```

## ⚡ Performance Notes

- **Local Latency**: Minimal overhead for local requests
- **JSON Escaping**: Complex scripts need proper quote escaping  
- **Large DOM**: Full DOM extraction có thể > 1MB, nên truncate khi test
- **Session Reuse**: Tạo session một lần, dùng lại cho nhiều requests

## 🔒 JavaScript Security & Best Practices

### ULTRA-SHORT VANILLA JS (PRIORITY METHOD)
- **Max 5-10 words per script** - Ultra-compressed for safety
- **Use IDs only** - `getElementById()` fastest và most reliable  
- **No complex selectors** - Simple, bulletproof targeting
- **Single-line ternary** - `condition?(action,"Success"):"Failed"`
- **Multiple endpoint calls OK** - System designed for frequent calls

### Proven Form Element Patterns:
```javascript
// ✅ EMAIL FIELD (tested GitHub)
var e=document.getElementById("email");e?(e.style.backgroundColor="yellow",e.value="test@gmail.com",e.focus(),e.blur(),"Found"):"Not found"

// ✅ PASSWORD FIELD (tested GitHub)  
var p=document.getElementById("password");p?(p.style.backgroundColor="lightblue",p.value="SecurePass123","Found"):"Not found"

// ✅ TEXT INPUT (tested GitHub)
var u=document.getElementById("login");u?(u.style.backgroundColor="lightgreen",u.value="testuser123","Found"):"Not found"

// ✅ RADIO BUTTON (tested W3Schools)
var r=document.getElementById("javascript");r?(r.style.transform="scale(3)",r.checked=true,r.click(),"Selected"):"Not found"

// ✅ CHECKBOX (tested W3Schools)
var c=document.getElementById("vehicle1");c?(c.style.transform="scale(2)",c.checked=true,"Checked"):"Not found"

// ✅ TEXTAREA (tested W3Schools)
var t=document.querySelector("textarea");t?(t.style.backgroundColor="yellow",t.value="Test message","Found"):"Not found"

// ✅ DROPDOWN (tested GitHub complex)
var btn=document.getElementById("select-panel-button-id");btn?(btn.style.backgroundColor="orange",btn.click(),"Opened"):"Not found"

// ✅ SUBMIT BUTTON (safe highlight only)
var s=document.querySelector("button[type=submit]");s?(s.style.backgroundColor="red",s.style.border="5px solid darkred","Found"):"Not found"
```

### CSS Style Extraction Patterns:
```javascript
// ✅ CSS STYLE EXTRACTION - Single Element (tested Stripe.com)
var e=document.querySelector("SELECTOR");if(e){var s=window.getComputedStyle(e);JSON.stringify({color:s.color,fontSize:s.fontSize,fontWeight:s.fontWeight,fontFamily:s.fontFamily.split(",")[0],bg:s.backgroundColor,padding:s.padding});}else{"Not found"}

// ✅ MULTI-ELEMENT CSS BATCH READ (tested Stripe.com)
var selectors=["h1","button","a"];var results=[];for(var i=0;i<selectors.length;i++){var e=document.querySelector(selectors[i]);if(e){var s=window.getComputedStyle(e);results.push({sel:selectors[i],color:s.color,fontSize:s.fontSize,fontWeight:s.fontWeight});}}JSON.stringify(results)

// ✅ COMPREHENSIVE CSS PROPERTIES (tested Stripe.com) 
var e=document.querySelector("SELECTOR");if(e){var cs=window.getComputedStyle(e);JSON.stringify({color:cs.color,bgColor:cs.backgroundColor,fontSize:cs.fontSize,fontWeight:cs.fontWeight,fontFamily:cs.fontFamily,padding:cs.padding,margin:cs.margin,border:cs.border,borderRadius:cs.borderRadius,letterSpacing:cs.letterSpacing,lineHeight:cs.lineHeight,display:cs.display,position:cs.position,cursor:cs.cursor});}else{"Element not found"}
```

### Console Logs Extraction Patterns:
```javascript
// ✅ CONSOLE LOGS EXTRACTION - From DevTools Tab (tested tiengduc2fong.com)
var msgs=document.querySelectorAll(".console-message");var logs=[];for(var i=0;i<msgs.length;i++){logs.push("LOG "+(i+1)+": "+msgs[i].textContent.trim());}logs.join("\n")

// ✅ CONSOLE MESSAGE COUNT BY LEVEL
var errors=document.querySelectorAll(".console-error-level");var warnings=document.querySelectorAll(".console-warning-level");var info=document.querySelectorAll(".console-info-level");JSON.stringify({errors:errors.length,warnings:warnings.length,info:info.length,totalMessages:document.querySelectorAll(".console-message").length})

// ✅ SHORT CONSOLE LOG SUMMARY
var msgs=document.querySelectorAll(".console-message");var logs=[];for(var i=0;i<msgs.length;i++){logs.push((i+1)+": "+msgs[i].textContent.trim().substring(0,100));}logs.length+" console messages found: "+logs.join(" | ")
```

### JSON Escape-Safe Patterns:
```javascript
// ❌ BAD: Special chars cause JSON errors
"Special chars: ' \" \n \t ! @ # $ % ^ & * ( )"

// ✅ GOOD: Simple alphanumeric only
"Simple text without special characters"

// ❌ BAD: Multi-line newlines
"Line 1\nLine 2\nLine 3"  

// ✅ GOOD: Single line spaces
"Line 1 Line 2 Line 3"
```

### KISS (Keep It Super Simple) Rules:
```javascript
// ✅ ULTRA-SHORT: 1 action, 1 check
var x=document.getElementById("id");x?(x.value="test","OK"):"NO"

// ✅ COLOR HIGHLIGHTING (visual feedback)  
var y=document.getElementById("id");y?(y.style.backgroundColor="lime","OK"):"NO"

// ✅ SCALE EFFECTS (for small elements)
var z=document.getElementById("id");z?(z.style.transform="scale(2)","OK"):"NO"

// ✅ FOCUS/BLUR (trigger validation)
var w=document.getElementById("id");w?(w.focus(),w.blur(),"OK"):"NO"
```

### Multiple Calls Strategy:
```bash
# ✅ PATTERN: Call endpoints multiple times - system handles it
curl -X POST .../api/execute... # Call 1
curl -X POST .../api/execute... # Call 2  
curl -X POST .../api/execute... # Call 3
# No rate limiting - safe to call repeatedly
```

### Endpoint Reusability (TESTED):
- **DOM extraction**: Call multiple times on same page = same UUID files
- **Text extraction**: Multiple calls create separate files with timestamps  
- **JavaScript execution**: Can execute same script repeatedly
- **Session persistence**: Reuse same sessionId across multiple calls
- **No caching issues**: Fresh execution every time

### CSS Analysis Best Practices (Stripe.com Tested):
- **window.getComputedStyle()**: Primary method for reading actual CSS values
- **Essential properties**: color, fontSize, fontWeight, fontFamily, backgroundColor, padding
- **Family splitting**: Use `.split(",")[0]` to get primary font only
- **Batch processing**: Loop through multiple selectors efficiently
- **Visual feedback**: Always highlight element being analyzed
- **Design system extraction**: Perfect for automated design token generation

## 🐛 Troubleshooting

### Common Issues
```bash
# Connection refused
# Check if backend is running on localhost:49445
curl http://localhost:49445/health
```

### JSON Escaping Issues
```bash
# BAD: Quotes not escaped
"script": "document.title + " - " + window.location"

# GOOD: Properly escaped
"script": "document.title + \" - \" + window.location.href"
```

## 📈 Future Testing
- [x] **Form automation** - 8 element types tested (email, password, text, radio, checkbox, textarea, dropdown, submit)
- [x] **CSS style extraction** - Complete CSS analysis workflow established
- [x] **Console logs extraction** - DevTools automation for debugging and monitoring
- [x] **Visual feedback** - Color highlighting and transform effects working
- [x] **Multi-site testing** - GitHub, W3Schools, Stripe.com, tiengduc2fong.com validated
- [ ] File upload endpoints
- [ ] WebSocket connections  
- [ ] Error handling edge cases
- [ ] Performance benchmarks
- [ ] Session timeout behavior

## 📂 DOM Structure Knowledge Base

### Local Project DOM Storage
**Primary Location**: `/home/fong/Projects/boiler-plate-cursor-project-with-init-prompt/.fong/DOM-structures/`

#### CRUD Operations for DOM Structures

##### Create/Extract DOM
```bash
# Step 1: Create session
SESSION_ID=$(curl -s -X POST http://localhost:49445/api/session/create -H 'Content-Type: application/json' | jq -r '.session.id')

# Step 2: Select target tab
TAB_ID=$(curl -s http://localhost:49445/api/tabs/list | jq -r '.tabs[] | select(.url | contains("domain")) | .id' | head -1)
curl -X POST http://localhost:49445/api/tabs/select -H 'Content-Type: application/json' -d "{\"tabId\":\"$TAB_ID\"}"

# Step 3: Extract DOM
DOM_PATH=$(curl -s -X POST http://localhost:49445/api/dom/extract -H 'Content-Type: application/json' -d "{\"sessionId\":\"$SESSION_ID\"}" | jq -r '.filepath')

# Step 4: Save to project DOM structures
DOMAIN=$(echo "$DOM_PATH" | grep -oP 'DOM-\K[^.]+' || echo "unknown")
cp "$DOM_PATH" ".fong/DOM-structures/$(date +%Y%m%d)-${DOMAIN}-dom-structure.html"
```

##### Read DOM Structures
```bash
# List all saved DOM structures
ls -la .fong/DOM-structures/*.html

# Search specific elements in saved DOMs
grep -h "input\|form\|button" .fong/DOM-structures/*.html | head -20

# Analyze specific domain structure
cat .fong/DOM-structures/chatgpt.com-dom-structure.html | grep -o 'class="[^"]*"' | sort | uniq -c | sort -nr | head -10
```

##### Update DOM Structure
```bash
# Re-extract and update existing DOM
DOMAIN="chatgpt.com"
NEW_DOM=$(curl -s -X POST http://localhost:49445/api/dom/extract -H 'Content-Type: application/json' -d "{\"sessionId\":\"$SESSION_ID\"}" | jq -r '.filepath')
mv ".fong/DOM-structures/${DOMAIN}-dom-structure.html" ".fong/DOM-structures/${DOMAIN}-dom-structure.$(date +%Y%m%d%H%M%S).bak"
cp "$NEW_DOM" ".fong/DOM-structures/${DOMAIN}-dom-structure.html"
```

##### Delete Old DOM Structures
```bash
# Remove old backups (keep latest 3)
ls -t .fong/DOM-structures/*.bak | tail -n +4 | xargs rm -f

# Clean up specific domain
rm -f .fong/DOM-structures/*chatgpt*.bak
```

### Available DOM Structures
Located in `.fong/DOM-structures/`:

1. **`chatgpt.com-dom-structure.html`** - ChatGPT interface DOM mapping
2. **Add new domains as needed following naming convention: `domain.com-dom-structure.html`**

### DOM Analysis Commands

#### Quick Element Discovery
```bash
# Find all input fields in saved DOM
grep -o '<input[^>]*>' .fong/DOM-structures/*.html | cut -d: -f2 | sort | uniq

# Extract all button texts
grep -o '<button[^>]*>[^<]*</button>' .fong/DOM-structures/*.html | sed 's/<[^>]*>//g'

# List all form IDs
grep -o 'form[^>]*id="[^"]*"' .fong/DOM-structures/*.html | grep -o 'id="[^"]*"'
```

#### CSS Class Analysis
```bash
# Top 10 most used CSS classes
cat .fong/DOM-structures/*.html | grep -o 'class="[^"]*"' | cut -d'"' -f2 | tr ' ' '\n' | sort | uniq -c | sort -nr | head -10

# Find specific framework patterns (React, Vue, etc)
grep -l "react\|vue\|angular" .fong/DOM-structures/*.html
```

## 🎓 Knowledge Base Summary

### Completed Research & Documentation:
1. **`comprehensive-form-automation-tests.md`** - 100% success rate across 8 form element types
2. **`github.com-signup-dom-structure.md`** - Complete GitHub signup form analysis  
3. **`w3schools.com-forms-dom-structure.md`** - Educational forms structure and patterns
4. **`form-automation-best-practices.md`** - ULTRA-SHORT VANILLA JS methodology
5. **`css-style-extraction-stripe.com.md`** - CSS analysis of beautiful UI design
6. **`console-logs-extraction-tiengduc2fong.com.md`** - DevTools console logs extraction methodology

### Local DOM Structures Repository
- **Location**: `.fong/DOM-structures/`
- **Format**: `domain.com-dom-structure.html`
- **Backup**: Automatic versioning with timestamps
- **Analysis**: Built-in grep/search patterns for element discovery

### Proven Success Metrics:
- **Form Elements**: 8/8 types successfully automated (100% success)
- **Websites Tested**: 4 different domains with different architectures  
- **CSS Extraction**: 11 test iterations → Perfect working patterns
- **Console Logs**: DevTools extraction from live websites (100% success)
- **Script Reliability**: ULTRA-SHORT patterns with 0 failures
- **Knowledge Preservation**: Complete documentation for future reuse
- **DOM Repository**: Local storage with CRUD operations
```