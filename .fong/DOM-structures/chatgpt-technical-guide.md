# ChatGPT DOM Technical Guide

**Purpose**: Hướng dẫn kỹ thuật cho việc tự động hóa ChatGPT interface
**Updated**: 2025-09-28
**URL**: https://chatgpt.com/

## Core DOM Elements

### 1. Main Input Area
```javascript
// Textarea chính để nhập prompt
const promptArea = document.getElementById("prompt-textarea");
// ProseMirror editor (contenteditable)
const editor = document.querySelector('.ProseMirror[contenteditable="true"]');
```

### 2. Action Buttons (data-testid)
```javascript
// File upload button
document.querySelector('[data-testid="composer-action-file-upload"]');

// Search button  
document.querySelector('[data-testid="composer-button-search"]');

// Study button
document.querySelector('[data-testid="composer-button-study"]');

// Voice/Speech button
document.querySelector('[data-testid="composer-speech-button"]');

// Model switcher
document.querySelector('[data-testid="model-switcher-dropdown-button"]');
```

### 3. Authentication Elements
```javascript
// Login/Signup buttons
document.querySelector('[data-testid="login-button"]');
document.querySelector('[data-testid="signup-button"]');
document.querySelector('[data-testid="mobile-login-button"]');

// Profile button
document.querySelector('[data-testid="profile-button"]');
```

## Automation Scripts

### Input Text và Submit
```javascript
// Method 1: Direct ProseMirror manipulation
const editor = document.querySelector('.ProseMirror[contenteditable="true"]');
if(editor) {
    // Clear placeholder
    editor.innerHTML = '';
    // Insert text
    const p = document.createElement('p');
    p.textContent = 'Your prompt text here';
    editor.appendChild(p);
    // Trigger input event
    editor.dispatchEvent(new Event('input', {bubbles: true}));
}

// Method 2: Focus và paste
const editor = document.querySelector('.ProseMirror');
if(editor) {
    editor.focus();
    document.execCommand('selectAll');
    document.execCommand('insertText', false, 'Your prompt text here');
}
```

### Submit Message
```javascript
// Tìm nút submit (thường ở footer actions)
const submitBtn = document.querySelector('[data-testid="composer-footer-actions"] button[type="submit"]');
if(submitBtn && !submitBtn.disabled) {
    submitBtn.click();
}
```

### File Upload
```javascript
// Mở file upload dialog
const uploadBtn = document.querySelector('[data-testid="composer-action-file-upload"] button');
if(uploadBtn) {
    uploadBtn.click();
}
```

### Search Mode Toggle
```javascript
const searchBtn = document.querySelector('[data-testid="composer-button-search"] button');
if(searchBtn) {
    searchBtn.click();
}
```

### Study Mode Toggle
```javascript
const studyBtn = document.querySelector('[data-testid="composer-button-study"] button');
if(studyBtn) {
    studyBtn.click();
}
```

## CSS Selectors for Key Elements

### Input Area
- Main container: `.ProseMirror[contenteditable="true"]`
- Placeholder text: `p[data-placeholder]`
- Focus state: `.ProseMirror:focus`

### Action Buttons
- Attach button: `[aria-label="Add photos"]`
- Search button: `[aria-label="Search"]`
- Study button: `[aria-label="Study"]`
- Voice button: `[aria-label="Start voice mode"]`

### Visual Indicators
- Button hover: `.hover\\:bg-token-main-surface-secondary`
- Active state: `.radix-state-open\\:bg-black\\/10`
- Disabled state: `button:disabled`

## Complete Automation Example

```javascript
// Full automation flow cho nhập text và submit
async function sendChatGPTMessage(text) {
    // 1. Focus vào editor
    const editor = document.querySelector('.ProseMirror[contenteditable="true"]');
    if(!editor) {
        console.error('Editor not found');
        return false;
    }
    
    // 2. Clear và nhập text mới
    editor.focus();
    editor.innerHTML = '';
    const p = document.createElement('p');
    p.textContent = text;
    editor.appendChild(p);
    
    // 3. Trigger input event
    editor.dispatchEvent(new Event('input', {bubbles: true}));
    
    // 4. Đợi một chút để UI update
    await new Promise(resolve => setTimeout(resolve, 100));
    
    // 5. Submit message
    const submitBtn = document.querySelector('button[aria-label="Send"]') || 
                      document.querySelector('[data-testid="send-button"]');
    if(submitBtn && !submitBtn.disabled) {
        submitBtn.click();
        return true;
    }
    
    return false;
}

// Sử dụng
sendChatGPTMessage("Hello ChatGPT, how are you?");
```

## Important Notes

1. **ProseMirror Editor**: ChatGPT sử dụng ProseMirror cho text input, không phải textarea thông thường
2. **ContentEditable**: Editor có thuộc tính `contenteditable="true"`
3. **Data-testid**: Sử dụng data-testid attributes để target elements một cách ổn định
4. **Dynamic Loading**: Một số elements có thể được load động, cần check tồn tại trước khi thao tác
5. **Event Dispatching**: Cần dispatch input events sau khi thay đổi nội dung editor

## Testing với AutoChrome

```bash
# 1. Create session
SESSION_ID=$(curl -s -X POST http://localhost:49445/api/session/create | jq -r '.session.id')

# 2. Navigate to ChatGPT
curl -X POST http://localhost:49445/api/execute \
  -H 'Content-Type: application/json' \
  -d "{\"sessionId\":\"$SESSION_ID\",\"script\":\"window.location.href='https://chatgpt.com'\"}"

# 3. Input text
curl -X POST http://localhost:49445/api/execute \
  -H 'Content-Type: application/json' \
  -d "{\"sessionId\":\"$SESSION_ID\",\"script\":\"var e=document.querySelector('.ProseMirror');e?(e.focus(),e.innerHTML='<p>Test prompt</p>',e.dispatchEvent(new Event('input',{bubbles:true})),'Text inserted'):'Editor not found'\"}"

# 4. Submit
curl -X POST http://localhost:49445/api/execute \
  -H 'Content-Type: application/json' \
  -d "{\"sessionId\":\"$SESSION_ID\",\"script\":\"var b=document.querySelector('button[aria-label=\\\"Send\\\"]');b?(b.click(),'Sent'):'Button not found'\"}"
```