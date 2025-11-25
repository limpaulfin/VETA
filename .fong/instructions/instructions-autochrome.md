# AutoChrome Local Endpoint Guide

**Version**: 2025-10-06 - Sessionless + jQuery
**Updated**: 2025-10-06
**Environment**: Local Machine Chromium
**Purpose**: Sessionless automation with jQuery library injection, form automation, CSS extraction, and screenshots

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
# - Auto-start Chromium nếu chưa chạy (NEW)
# - Auto-create session nếu không cung cấp sessionId (NEW)
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

### 🆕 Sessionless Architecture (2025-10-06)
```bash
# KHÔNG CẦN tạo session - System tự động quản lý!
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' -d '{"script":"document.title"}'
# → Auto-create transient session → Execute → Auto cleanup

# Auto-start Chromium (CDP auto-launch if not running)
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' -d '{"script":"document.title"}'
# → Nếu Chromium chưa chạy, system tự động start và đợi ready, rồi execute script
```

### 📚 jQuery Library Injection (2025-10-06) - RECOMMENDED!
```bash
# jQuery - Query DOM dễ dàng và nhanh gọn
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"$(\"h1\").first().text()"}'
# → jQuery tự động inject vào page, sẵn sàng dùng!

# Supported libraries: jquery, lodash, axios, moment
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery","lodash"],"script":"_.uniq($(\"a\").map((i,el)=>$(el).attr(\"href\")).get())"}'
# → Multiple libraries cùng lúc!
```

### 📦 Available Libraries (Các thư viện có sẵn)

**⚠️ QUAN TRỌNG**: jQuery được inject **MẶC ĐỊNH** cho MỌI request - KHÔNG cần khai báo `"libraries":["jquery"]`!

#### 1. **jQuery 3.7.1** ✅ DEFAULT (Mặc định)
- **CDN**: https://code.jquery.com/jquery-3.7.1.min.js
- **Global**: `window.jQuery`, `window.$`
- **Test**: ✅ PASSED (2025-10-06)
- **Usage**:
```bash
# Không cần khai báo libraries - jQuery SẴN CÓ!
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"script":"$(\"h1\").first().text()"}'
```

#### 2. **Lodash 4.17.21** ✅ TESTED
- **CDN**: https://cdn.jsdelivr.net/npm/lodash@4.17.21/lodash.min.js
- **Global**: `window._`
- **Test**: ✅ PASSED (2025-10-06)
- **Usage**:
```bash
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["lodash"],"script":"_.chunk([\"a\",\"b\",\"c\",\"d\"], 2)"}'
# Result: [["a","b"],["c","d"]]
```

#### 3. **Axios 1.6.2** ✅ TESTED
- **CDN**: https://cdn.jsdelivr.net/npm/axios@1.6.2/dist/axios.min.js
- **Global**: `window.axios`
- **Test**: ✅ PASSED (2025-10-06)
- **Usage**:
```bash
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["axios"],"script":"typeof axios"}'
# Result: "function"
```

#### 4. **Moment.js 2.29.4** ✅ TESTED
- **CDN**: https://cdn.jsdelivr.net/npm/moment@2.29.4/moment.min.js
- **Global**: `window.moment`
- **Test**: ✅ PASSED (2025-10-06)
- **Usage**:
```bash
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["moment"],"script":"moment().format(\"YYYY-MM-DD HH:mm:ss\")"}'
# Result: "2025-10-06 16:25:32"
```

**Test Results Summary** (2025-10-06):
- ✅ jQuery: Injected và hoạt động tốt - MẶC ĐỊNH cho mọi request
- ✅ Lodash: Injected và hoạt động tốt - Array/Object utilities
- ✅ Axios: Injected và hoạt động tốt - HTTP client
- ✅ Moment.js: Injected và hoạt động tốt - Date/time formatting

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

### 1. CDP Keyboard Input APIs (NEW 2025-10-17)

#### 🎹 Overview
**Purpose**: Human-like keyboard input via Chrome DevTools Protocol (CDP) at browser level
**Use Cases**: Google Docs automation, form filling, Vietnamese text input, keyboard shortcuts
**Architecture**: Sessionless with auto-cleanup, 50-100ms delays for human simulation

#### Type Text (Char-by-Char)
```bash
# Command: Type text character-by-character with Vietnamese support
curl -X POST http://localhost:49445/api/keyboard/type -H 'Content-Type: application/json' \
  -d '{
    "text": "Trăm năm trong cõi người ta",
    "options": {
      "delayMin": 50,
      "delayMax": 100,
      "humanLike": true
    }
  }'

# Response Format
{
  "success": true,
  "text": "Trăm năm trong cõi người ta",
  "totalChars": 28,
  "successfulChars": 28,
  "totalTime": 2240,
  "averageDelay": 80,
  "humanLike": true,
  "method": "char-by-char",
  "results": [
    {"char": "T", "success": true, "delay": 87},
    {"char": "r", "success": true, "delay": 65}
  ]
}

# Status: ✅ TESTED - Google Docs, 926 chars in 74s, 100% success rate
# Notes: Supports full Vietnamese Unicode (ă, ê, ô, ư, ơ, đ + all tones)
```

#### Paste By Words (Word-by-Word)
```bash
# Command: Paste text word-by-word (faster than char-by-char)
curl -X POST http://localhost:49445/api/keyboard/pasteByWords -H 'Content-Type: application/json' \
  -d '{
    "text": "Chào mừng bạn đến với hệ thống",
    "options": {
      "delayMin": 50,
      "delayMax": 100,
      "humanLike": true
    }
  }'

# Response Format
{
  "success": true,
  "text": "Chào mừng bạn đến với hệ thống",
  "totalWords": 6,
  "successfulWords": 6,
  "totalTime": 450,
  "averageDelay": 75,
  "humanLike": true,
  "method": "paste-by-words"
}

# Status: ⚠️ LIMITED COMPATIBILITY
# ✅ Works: Simple input fields, textareas
# ❌ Doesn't work: Google Docs (only first word pastes)
# Recommendation: Use typeText() for better compatibility
```

#### Press Special Key (With Modifiers)
```bash
# Command: Press special keys (Enter, Tab, etc.) with optional Ctrl/Shift/Alt
curl -X POST http://localhost:49445/api/keyboard/pressKey -H 'Content-Type: application/json' \
  -d '{
    "key": "Enter",
    "options": {
      "ctrl": false,
      "shift": false,
      "alt": false
    }
  }'

# Example: Ctrl+A (Select All)
curl -X POST http://localhost:49445/api/keyboard/pressKey -H 'Content-Type: application/json' \
  -d '{"key": "a", "options": {"ctrl": true}}'

# Example: Press Tab
curl -X POST http://localhost:49445/api/keyboard/pressKey -H 'Content-Type: application/json' \
  -d '{"key": "Tab"}'

# Response Format
{
  "success": true,
  "key": "Ctrl+A",
  "message": "Pressed key: Ctrl+A"
}

# Supported Keys:
# - Special: Enter, Tab, Escape, Space, Backspace, Delete
# - Arrows: ArrowUp, ArrowDown, ArrowLeft, ArrowRight
# - Modifiers: Shift, Control, Alt (standalone)
# - Function: F1, F2, F3, F4, F5
# - Letters: a, A, g, G (for combinations)

# Status: ✅ TESTED - Google Docs keyboard shortcuts work perfectly
# Notes: CDP modifiers bitmask (Ctrl=2, Shift=8, Alt=1)
```

#### Complete Workflow Example: Vietnamese Poetry to Google Docs
```bash
# Step 1: Select Google Docs tab
curl -X POST http://localhost:49445/api/tabs/select -H 'Content-Type: application/json' \
  -d '{"tabId":"YOUR-TAB-ID"}'

# Step 2: Clear existing content (Ctrl+A + Backspace)
curl -X POST http://localhost:49445/api/keyboard/pressKey -H 'Content-Type: application/json' \
  -d '{"key": "a", "options": {"ctrl": true}}'
curl -X POST http://localhost:49445/api/keyboard/pressKey -H 'Content-Type: application/json' \
  -d '{"key": "Backspace"}'

# Step 3: Type Vietnamese text (926 characters)
curl -X POST http://localhost:49445/api/keyboard/type -H 'Content-Type: application/json' \
  -d '{
    "text": "Trăm năm trong cõi người ta\nChữ tài chữ mệnh khéo là ghét nhau\nTrải qua một cuộc bể dâu\nNhững điều trông thấy mà đau đớn lòng\nLạ gì bỉ sắc tư phong\nTrời xanh quen thói má hồng đánh ghen\nCũng bởi tấm tình sơ kiến\nChốn hoa lá ngọc đầu tiên dây mơ",
    "options": {
      "delayMin": 50,
      "delayMax": 100,
      "humanLike": true
    }
  }'

# Step 4: Capture screenshot to verify
curl -X POST http://localhost:49445/api/screenshot/capture -H 'Content-Type: application/json' \
  -d '{"sessionId":"SESSION_ID"}'

# Result: 926 chars typed in 74.4s with 100% accuracy
```

#### Keyboard Input - Performance Benchmarks
- **Typing Speed**: 50-100ms delay per character/word (adjustable)
- **Vietnamese Support**: 100% accurate with all diacritics (ă, ê, ô, ư, ơ, đ + tones)
- **Tested Volume**: 926 characters in 74.4 seconds (~80ms average)
- **Success Rate**: 100% (926/926 characters successful)
- **Compatibility**: Google Docs ✅, Simple forms ✅, Textareas ✅

#### Keyboard Input - Use Cases
1. **Google Docs Automation** - Type documents with Vietnamese text
2. **Form Filling** - Tab navigation + text input + submit
3. **Search Automation** - Type queries + press Enter
4. **Keyboard Shortcuts** - Ctrl+A, Ctrl+C, Ctrl+V, etc.
5. **Multi-step Workflows** - Complex form interactions

#### Keyboard Input - Technical Details
- **CDP Method**: `Input.dispatchKeyEvent` for char-by-char typing
- **CDP Method**: `Input.insertText` for word-by-word pasting
- **Modifier Encoding**: Bitmask (Ctrl=2, Shift=8, Alt=1, combined with OR)
- **Unicode Support**: Native CDP Input.insertText handles Vietnamese perfectly
- **Anti-Bot Detection**: Random delays (50-100ms) mimic human typing rhythm
- **Sessionless**: Auto-create transient session → Execute → Auto cleanup

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

### 2. JavaScript Execution (Sessionless + jQuery)

#### Execute Script - Sessionless
```bash
# Command Format - KHÔNG CẦN sessionId!
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' -d '{"script":"JAVASCRIPT_CODE"}'

# Example: Get page info (vanilla JS)
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' -d '{"script":"document.title + \" - \" + window.location.href"}'

# Response Format
{
  "success": true,
  "result": "Script execution result here"
}

# Status: ✅ TESTED
# Notes: Sessionless - system tự động tạo transient session và cleanup
```

#### Execute with jQuery (RECOMMENDED)
```bash
# Command Format - jQuery auto-inject
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"JQUERY_CODE"}'

# Example 1: Get page title
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"$(\"title\").text()"}'

# Example 2: Count links
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"$(\"a\").length"}'

# Example 3: Extract headlines
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"$(\"h1, h2, h3\").slice(0,5).map((i,el)=>$(el).text().trim()).get()"}'

# Status: ✅ TESTED với VnExpress.net
# Notes: jQuery tự động inject nếu chưa có, code ngắn gọn và dễ đọc hơn vanilla JS
```

### 3. DOM & Content Extraction

#### Get DOM HTML (Vanilla JS)
```bash
# Command: Extract complete DOM as JSON
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"script":"JSON.stringify({url: window.location.href, title: document.title, html: document.documentElement.outerHTML})"}'

# Example: Truncated DOM for testing
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"script":"JSON.stringify({url: window.location.href, title: document.title, html: document.documentElement.outerHTML.substring(0,500) + \"...[TRUNCATED]\"})"}'

# Status: ✅ TESTED
# Notes: Sessionless - không cần sessionId
```

#### Get DOM HTML (jQuery - RECOMMENDED)
```bash
# Extract DOM với jQuery - ngắn gọn hơn
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"JSON.stringify({url: location.href, title: $(\"title\").text(), html: $(\"html\").html()})"}'

# Extract specific elements only
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"$(\"article, .content, main\").html()"}'

# Status: ✅ RECOMMENDED
# Notes: jQuery làm code dễ đọc và linh hoạt hơn
```

#### Get Page Text
```bash
# Vanilla JS
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"script":"document.body.innerText.substring(0,200)"}'

# jQuery (RECOMMENDED)
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"$(\"body\").text().substring(0,200)"}'

# Status: ✅ TESTED
# Notes: jQuery đơn giản hơn và consistent
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

### 4. DOM Extraction with File Output (Sessionless)
```bash
# Extract complete DOM and save to downloads/ - KHÔNG CẦN sessionId
curl -X POST http://localhost:49445/api/dom/extract -H 'Content-Type: application/json' -d '{}'

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

# Status: ✅ SESSIONLESS - Auto-managed
# Notes: System tự tạo transient session, extract DOM, save file, cleanup
```

### 5. Text Extraction with File Output (Sessionless)
```bash
# Extract page text and save to downloads/ - KHÔNG CẦN sessionId
curl -X POST http://localhost:49445/api/text/extract -H 'Content-Type: application/json' -d '{}'

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

# Status: ✅ SESSIONLESS - Auto-managed
# Notes: Text extraction cũng sessionless như DOM extraction
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

### Pattern 1: SESSIONLESS WORKFLOW - Complete Page Analysis (RECOMMENDED)
```bash
# Step 1: List available tabs
curl -s http://localhost:49445/api/tabs/list | jq

# Step 2: Select target tab
curl -X POST http://localhost:49445/api/tabs/select -H 'Content-Type: application/json' -d '{"tabId":"TAB_ID"}'

# Step 3: 🔍 EXTRACT DOM FIRST (ALWAYS FIRST!) - No sessionId needed
curl -X POST http://localhost:49445/api/dom/extract -H 'Content-Type: application/json' -d '{}'

# Step 4: 📚 EXTRACT TEXT CONTENT (Learn page context) - No sessionId needed
curl -X POST http://localhost:49445/api/text/extract -H 'Content-Type: application/json' -d '{}'

# Step 5: 🎯 ANALYZE extracted files before taking action (LOCAL)
# Read DOM file to understand structure:
cat /home/fong/Projects/MindAct/backend-node/downloads/DOM-*.html | grep -i "form\|input\|button" | head -10

# Read text file to understand page content:
cat /home/fong/Projects/MindAct/backend-node/downloads/plain-text-*.txt | head -20

# Step 6: ⚡ Execute with jQuery (RECOMMENDED) - No sessionId needed
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"$(\"input[name=q]\").val(\"search term\").closest(\"form\").submit()"}'
```

### Pattern 2: jQuery Search Form - Sessionless (RECOMMENDED)
```bash
# ✅ CORRECT: Always extract first!

# Step 1: Extract DOM to understand form structure - No sessionId
curl -X POST http://localhost:49445/api/dom/extract -H 'Content-Type: application/json' -d '{}'

# Step 2: Analyze extracted files - find actual input names/IDs (LOCAL)
grep -i "input.*name.*q\|input.*id.*search" /home/fong/Projects/MindAct/backend-node/downloads/DOM-*.html

# Step 3: Execute with jQuery (RECOMMENDED) - One liner!
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"$(\"input[name=q]\").val(\"search term\").closest(\"form\").submit()"}'

# Alternative: Step by step with jQuery
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"$(\"input[name=q]\").val(\"AI research\").css(\"background\",\"yellow\")"}'

curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"$(\"button[type=submit]\").click()"}'
```

## 🎯 Interactive Operations - jQuery (RECOMMENDED)

### 5. Click Operations - jQuery (Ngắn gọn và rõ ràng)
```bash
# Basic Click with Visual Feedback - jQuery
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"$(\"button.submit\").css({\"background\":\"yellow\",\"border\":\"3px solid red\"}).get(0).scrollIntoView(); setTimeout(()=>$(\"button.submit\").click(), 1000); \"Will click in 1s\""}'

# Simple Click - No delay
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"$(\"a.login-button\").click()"}'

# Find ALL Clickable Elements
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"$(\"a, button, input[type=submit]\").slice(0,5).map((i,el)=>$(el).prop(\"tagName\")+\" - \"+$(el).text().substring(0,30)).get().join(\" | \")"}'

# Status: ✅ RECOMMENDED - Code ngắn và dễ đọc hơn vanilla JS
# Notes: jQuery chaining làm code rõ ràng, dễ maintain
```

### 6. Form Filling Operations - jQuery (RECOMMENDED)
```bash
# Fill Text Input with Visual Feedback - jQuery
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"$(\"input[name=q]\").css({\"background\":\"lightblue\",\"border\":\"2px solid blue\"}).val(\"Your text here\").focus().blur()"}'

# Fill Multiple Form Fields - jQuery chainable!
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"$(\"input[type=email]\").val(\"test@example.com\"); $(\"input[type=password]\").val(\"pass123\"); \"Form filled\""}'

# Complete Form Fill + Submit - All in one!
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"$(\"#email\").val(\"user@test.com\"); $(\"#password\").val(\"SecureP@ss\"); $(\"input[name=agree]\").prop(\"checked\",true); $(\"form\").submit()"}'

# Status: ✅ RECOMMENDED - jQuery makes form automation simple
# Notes: .focus().blur() triggers validation, chaining makes code clean
```

### 7. Scroll Operations - jQuery (RECOMMENDED)
```bash
# Scroll to Specific Position - jQuery animate
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"$(\"html, body\").animate({scrollTop: 500}, 300); \"Scrolling to 500px\""}'

# Scroll to Top
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"$(\"html, body\").animate({scrollTop: 0}, 300)"}'

# Scroll to Element - jQuery smooth scroll
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"$(\"h2.section-title\").get(0).scrollIntoView({behavior:\"smooth\",block:\"center\"})"}'

# Scroll to Bottom
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"$(\"html, body\").animate({scrollTop: $(document).height()}, 500)"}'

# Status: ✅ RECOMMENDED - Smooth scrolling với jQuery animate
# Notes: jQuery animate() provides smooth, controllable scrolling
```

### 8. Checkbox/Radio/Select - jQuery (RECOMMENDED)
```bash
# Toggle Checkbox - jQuery
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"$(\"input[type=checkbox]\").first().prop(\"checked\", function(i,val){return !val}).css(\"transform\",\"scale(1.5)\")"}'

# Check Multiple Checkboxes - jQuery
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"$(\"input[name='\''terms'\''], input[name='\''privacy'\'']\").prop(\"checked\",true)"}'

# Select Radio Button - jQuery
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"$(\"input[type=radio][value='\''yes'\'']\").prop(\"checked\",true).css(\"transform\",\"scale(2)\")"}'

# Select Dropdown Option - jQuery (by value)
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"$(\"select#country\").val(\"vietnam\").css(\"background\",\"lightgreen\")"}'

# Select Dropdown Option - jQuery (by index)
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"$(\"select\").prop(\"selectedIndex\",2)"}'

# Count Form Elements - jQuery
curl -X POST http://localhost:49445/api/execute -H 'Content-Type: application/json' \
  -d '{"libraries":["jquery"],"script":"$(\"input[type=checkbox], input[type=radio]\").length + \" elements found\""}'

# Status: ✅ RECOMMENDED - jQuery .prop() and .val() make it simple
# Notes: .prop("checked") for checkbox/radio, .val() for select
```

## ⚡ Performance Notes

- **Sessionless**: Auto session cleanup = no memory leak
- **Local Latency**: Minimal overhead for local requests
- **jQuery Injection**: +200-500ms first time, cached thereafter
- **JSON Escaping**: Complex scripts need proper quote escaping
- **Large DOM**: Full DOM extraction có thể > 1MB, nên truncate khi test
- **Concurrent Requests**: System handles multiple requests safely

## 🔒 JavaScript Security & Best Practices

### 📚 **PRIORITY: jQuery (RECOMMENDED METHOD)**
- **Shorter code** - `$("#id")` thay vì `document.getElementById()`
- **Chainable** - `$("#id").val("text").focus()`
- **Consistent API** - `.text()`, `.html()`, `.val()` cho mọi element
- **Auto-inject** - Chỉ cần `"libraries":["jquery"]`
- **Proven reliability** - jQuery 3.7.1, battle-tested

### ULTRA-SHORT VANILLA JS (Alternative Method)
- **Use only if** - Page already has jQuery conflicts
- **Max 5-10 words per script** - Ultra-compressed for safety
- **Use IDs only** - `getElementById()` fastest
- **Single-line ternary** - `condition?(action,"Success"):"Failed"`

### Form Element Patterns - jQuery (RECOMMENDED)
```javascript
// 📚 EMAIL FIELD - jQuery ngắn gọn hơn
$("#email").css("background","yellow").val("test@gmail.com").focus().blur()

// 📚 PASSWORD FIELD
$("#password").css("background","lightblue").val("SecurePass123")

// 📚 TEXT INPUT
$("#login, input[name='username']").css("background","lightgreen").val("testuser123")

// 📚 RADIO BUTTON
$("#javascript").prop("checked",true).css("transform","scale(3)")

// 📚 CHECKBOX
$("#vehicle1, input[name='agree']").prop("checked",true).css("transform","scale(2)")

// 📚 TEXTAREA
$("textarea").css("background","yellow").val("Test message")

// 📚 DROPDOWN/SELECT
$("select#country").val("vietnam").css("background","lightgreen")

// 📚 SUBMIT BUTTON (highlight only)
$("button[type=submit]").css({"background":"red","border":"5px solid darkred"})

// 📚 FILL ENTIRE FORM (chainable!)
$("#email").val("test@example.com");
$("#password").val("pass123");
$("input[name='agree']").prop("checked",true);
$("form").submit();
```

### Form Element Patterns - Vanilla JS (Fallback)
```javascript
// ⚠️ CHỈ DÙNG nếu không thể inject jQuery

// EMAIL FIELD (tested GitHub)
var e=document.getElementById("email");e?(e.style.backgroundColor="yellow",e.value="test@gmail.com",e.focus(),e.blur(),"Found"):"Not found"

// PASSWORD FIELD (tested GitHub)
var p=document.getElementById("password");p?(p.style.backgroundColor="lightblue",p.value="SecurePass123","Found"):"Not found"

// TEXT INPUT (tested GitHub)
var u=document.getElementById("login");u?(u.style.backgroundColor="lightgreen",u.value="testuser123","Found"):"Not found"

// CHECKBOX (tested W3Schools)
var c=document.getElementById("vehicle1");c?(c.style.transform="scale(2)",c.checked=true,"Checked"):"Not found"
```

### CSS Style Extraction - jQuery (RECOMMENDED)
```javascript
// 📚 CSS SINGLE ELEMENT - jQuery ngắn gọn hơn nhiều
JSON.stringify({
  color: $("h1").css("color"),
  fontSize: $("h1").css("font-size"),
  fontWeight: $("h1").css("font-weight"),
  bg: $("h1").css("background-color")
})

// 📚 MULTI-ELEMENT BATCH READ
["h1","button","a"].map(sel => ({
  sel: sel,
  color: $(sel).css("color"),
  fontSize: $(sel).css("font-size")
}))

// 📚 COMPREHENSIVE CSS PROPERTIES
var props = ["color","background-color","font-size","font-weight","padding","margin","border","border-radius"];
Object.fromEntries(props.map(p => [p, $("h1").css(p)]))

// 📚 ALL COMPUTED STYLES (ultimate extraction)
var el = $("h1")[0];
var cs = window.getComputedStyle(el);
JSON.stringify({color:cs.color,bg:cs.backgroundColor,fontSize:cs.fontSize,fontWeight:cs.fontWeight})
```

### CSS Extraction - Vanilla JS (Fallback)
```javascript
// ⚠️ CHỈ DÙNG nếu không thể inject jQuery

// CSS SINGLE ELEMENT (tested Stripe.com)
var e=document.querySelector("h1");if(e){var s=window.getComputedStyle(e);JSON.stringify({color:s.color,fontSize:s.fontSize,fontWeight:s.fontWeight,bg:s.backgroundColor});}else{"Not found"}

// MULTI-ELEMENT BATCH READ
var selectors=["h1","button","a"];var results=[];for(var i=0;i<selectors.length;i++){var e=document.querySelector(selectors[i]);if(e){var s=window.getComputedStyle(e);results.push({sel:selectors[i],color:s.color,fontSize:s.fontSize});}}JSON.stringify(results)
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

### KISS (Keep It Super Simple) Rules - jQuery First:
```javascript
// 📚 JQUERY - Shorter, cleaner, PREFERRED
$("#id").val("test")  // Set value
$("#id").css("background","lime")  // Highlight
$("#id").css("transform","scale(2)")  // Scale effect
$("#id").focus().blur()  // Trigger validation

// 📚 JQUERY CHAINING - Multiple actions in one line
$("#email").css("background","yellow").val("test@example.com").focus().blur()

// 📚 JQUERY MULTI-SELECT - Apply to multiple elements
$("input[type=checkbox]").prop("checked",true).css("transform","scale(1.5)")

// 📚 JQUERY CONDITIONAL - Exists check
$("button.submit").length > 0 ? $("button.submit").click() : "Not found"
```

### KISS - Vanilla JS Fallback (Only if jQuery conflicts):
```javascript
// ⚠️ CHỈ DÙNG khi không thể inject jQuery

// ULTRA-SHORT: 1 action, 1 check
var x=document.getElementById("id");x?(x.value="test","OK"):"NO"

// COLOR HIGHLIGHTING
var y=document.getElementById("id");y?(y.style.backgroundColor="lime","OK"):"NO"
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

##### Create/Extract DOM (Sessionless)
```bash
# Step 1: Select target tab
TAB_ID=$(curl -s http://localhost:49445/api/tabs/list | jq -r '.tabs[] | select(.url | contains("domain")) | .id' | head -1)
curl -X POST http://localhost:49445/api/tabs/select -H 'Content-Type: application/json' -d "{\"tabId\":\"$TAB_ID\"}"

# Step 2: Extract DOM - No sessionId needed!
DOM_PATH=$(curl -s -X POST http://localhost:49445/api/dom/extract -H 'Content-Type: application/json' -d '{}' | jq -r '.filepath')

# Step 3: Save to project DOM structures
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

##### Update DOM Structure (Sessionless)
```bash
# Re-extract and update existing DOM - No sessionId needed!
DOMAIN="chatgpt.com"
NEW_DOM=$(curl -s -X POST http://localhost:49445/api/dom/extract -H 'Content-Type: application/json' -d '{}' | jq -r '.filepath')
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