#!/bin/bash

# ChatGPT Complete Feature Testing Script
# Tests all UI elements and features

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

AUTOCHROME_URL="http://localhost:49445"

echo -e "${CYAN}================================${NC}"
echo -e "${CYAN}  ChatGPT Complete Feature Test ${NC}"
echo -e "${CYAN}================================${NC}"
echo ""

# Create session
echo -e "${YELLOW}Creating session...${NC}"
SESSION_ID=$(curl -s -X POST $AUTOCHROME_URL/api/session/create -H 'Content-Type: application/json' | jq -r '.session.id')
echo -e "${GREEN}✓ Session: $SESSION_ID${NC}"
echo ""

# Helper function to execute script
execute_script() {
    local script="$1"
    local description="$2"
    
    cat > /tmp/test_script.json << EOF
{
  "sessionId": "$SESSION_ID",
  "script": "$script"
}
EOF
    
    echo -e "${BLUE}Testing: $description${NC}"
    result=$(curl -s -X POST $AUTOCHROME_URL/api/execute -H 'Content-Type: application/json' -d @/tmp/test_script.json | jq -r '.result')
    
    if [[ "$result" == *"not found"* ]] || [[ "$result" == "null" ]] || [[ -z "$result" ]]; then
        echo -e "${RED}  ✗ Failed: $result${NC}"
    else
        echo -e "${GREEN}  ✓ Success: $result${NC}"
    fi
    echo ""
    sleep 0.5
}

# Test 1: Input Area
execute_script "var e=document.querySelector('.ProseMirror');e?(e.style.border='3px solid blue','Editor found'):'Editor not found'" "Text Input Area"

# Test 2: Search Button
execute_script "var b=document.querySelectorAll('button')[7];b?(b.style.backgroundColor='yellow',b.getAttribute('aria-label')||b.textContent):'Not found'" "Search Button"

# Test 3: Study Button  
execute_script "var b=document.querySelectorAll('button')[8];b?(b.style.backgroundColor='lightblue',b.getAttribute('aria-label')||b.textContent):'Not found'" "Study Button"

# Test 4: Voice Button
execute_script "var b=document.querySelector('[data-testid=\"composer-speech-button\"]');b?(b.style.backgroundColor='purple',b.getAttribute('aria-label')):'Not found'" "Voice Button"

# Test 5: Attach Button
execute_script "var b=document.querySelector('[aria-label=\"Add photos\"]');b?(b.style.backgroundColor='lightgreen','Upload: '+b.getAttribute('aria-label')):'Not found'" "Attach/Upload Button"

# Test 6: File Input
execute_script "var i=document.querySelector('input[type=\"file\"]');i?'File input accepts: '+i.accept:'Not found'" "File Input Element"

# Test 7: Model Switcher
execute_script "var b=document.querySelectorAll('button')[0];b&&b.textContent.includes('GPT')?'Model: '+b.textContent:'Not found'" "Model Switcher"

# Test 8: Send Button
execute_script "var btns=document.querySelectorAll('button');var last=btns[btns.length-1];last?'Last button: '+(last.getAttribute('aria-label')||'unnamed'):'Not found'" "Send Button"

# Test 9: Messages
execute_script "var m=document.querySelectorAll('[data-message-author-role]');'Messages found: '+m.length" "Message Elements"

# Test 10: Interactive Elements Count
execute_script "var counts={button:document.querySelectorAll('button').length,input:document.querySelectorAll('input').length,link:document.querySelectorAll('a').length};'Buttons:'+counts.button+', Inputs:'+counts.input+', Links:'+counts.link" "Interactive Elements"

# Test sending a message
echo -e "${PURPLE}=== Testing Message Send ===${NC}"
execute_script "var e=document.querySelector('.ProseMirror');if(e){e.innerHTML='<p>Test: What is 1+1?</p>';e.dispatchEvent(new Event('input',{bubbles:true}));'Message typed'}else{'Editor not found'}" "Type Message"

sleep 1

execute_script "var btns=document.querySelectorAll('button');var send=btns[btns.length-1];if(send&&!send.disabled){send.click();'Sent'}else{'Send button issue'}" "Send Message"

echo -e "${YELLOW}Waiting for response...${NC}"
sleep 3

execute_script "var msgs=document.querySelectorAll('[data-message-author-role=\"assistant\"]');if(msgs.length>0){var last=msgs[msgs.length-1];'Response: '+(last.innerText||'').substring(0,100)}else{'No response yet'}" "Check Response"

# Final summary
echo ""
echo -e "${CYAN}================================${NC}"
echo -e "${CYAN}        Test Complete!          ${NC}"
echo -e "${CYAN}================================${NC}"

# Take screenshot
echo -e "${YELLOW}Taking final screenshot...${NC}"
SCREENSHOT=$(curl -s -X POST $AUTOCHROME_URL/api/screenshot/capture \
    -H 'Content-Type: application/json' \
    -d "{\"sessionId\":\"$SESSION_ID\",\"options\":{\"format\":\"png\"}}" \
    | jq -r '.screenshot.filename')

if [ ! -z "$SCREENSHOT" ]; then
    echo -e "${GREEN}✓ Screenshot: $SCREENSHOT${NC}"
fi

echo ""
echo -e "${GREEN}All tests completed!${NC}"