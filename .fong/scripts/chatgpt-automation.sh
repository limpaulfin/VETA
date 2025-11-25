#!/bin/bash

# ChatGPT Automation Script - Fast & Reliable
# Usage: ./chatgpt-automation.sh "Your question here"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
AUTOCHROME_URL="http://localhost:49445"
QUESTION="${1:-What is the capital of France?}"

echo -e "${YELLOW}🚀 Starting ChatGPT Automation...${NC}"
echo -e "Question: ${GREEN}$QUESTION${NC}"
echo "----------------------------------------"

# Step 1: Create session
echo -e "${YELLOW}[1/6] Creating session...${NC}"
SESSION_ID=$(curl -s -X POST $AUTOCHROME_URL/api/session/create -H 'Content-Type: application/json' | jq -r '.session.id')
if [ -z "$SESSION_ID" ]; then
    echo -e "${RED}❌ Failed to create session${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Session created: $SESSION_ID${NC}"

# Step 2: Find and select ChatGPT tab
echo -e "${YELLOW}[2/6] Finding ChatGPT tab...${NC}"
TAB_ID=$(curl -s $AUTOCHROME_URL/api/tabs/list | jq -r '.tabs[] | select(.url | contains("chatgpt.com")) | .id' | head -1)
if [ -z "$TAB_ID" ]; then
    echo -e "${RED}❌ ChatGPT tab not found. Please open https://chatgpt.com${NC}"
    exit 1
fi
curl -s -X POST $AUTOCHROME_URL/api/tabs/select -H 'Content-Type: application/json' -d "{\"tabId\":\"$TAB_ID\"}" > /dev/null
echo -e "${GREEN}✓ ChatGPT tab selected${NC}"

# Step 3: Clear and input question
echo -e "${YELLOW}[3/6] Inputting question...${NC}"
cat > /tmp/chatgpt_input.json << EOF
{
  "sessionId": "$SESSION_ID",
  "script": "var e = document.querySelector('.ProseMirror'); if(e) { e.focus(); e.innerHTML = '<p>${QUESTION}</p>'; e.dispatchEvent(new Event('input', {bubbles: true})); 'Input success'; } else { 'Editor not found'; }"
}
EOF
INPUT_RESULT=$(curl -s -X POST $AUTOCHROME_URL/api/execute -H 'Content-Type: application/json' -d @/tmp/chatgpt_input.json | jq -r '.result')
echo -e "${GREEN}✓ Question inputted${NC}"

# Step 4: Submit the question
echo -e "${YELLOW}[4/6] Submitting question...${NC}"
cat > /tmp/chatgpt_submit.json << EOF
{
  "sessionId": "$SESSION_ID",
  "script": "var btn = document.querySelector('button[aria-label=\"Send prompt\"]') || document.querySelector('button[type=\"submit\"]:not(:disabled)'); if(btn) { btn.click(); 'Sent'; } else { var allBtns = document.querySelectorAll('button'); for(var i = allBtns.length - 1; i >= 0; i--) { if(allBtns[i].textContent.includes('Send') || allBtns[i].getAttribute('aria-label')?.includes('Send')) { allBtns[i].click(); return 'Sent via search'; } } 'Send button not found'; }"
}
EOF
SUBMIT_RESULT=$(curl -s -X POST $AUTOCHROME_URL/api/execute -H 'Content-Type: application/json' -d @/tmp/chatgpt_submit.json | jq -r '.result')
echo -e "${GREEN}✓ Question submitted${NC}"

# Step 5: Wait for response with timeout
echo -e "${YELLOW}[5/6] Waiting for ChatGPT response...${NC}"
MAX_ATTEMPTS=30  # 30 seconds timeout
ATTEMPT=0
RESPONSE=""

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    sleep 1
    
    # Check for assistant response
    cat > /tmp/chatgpt_check.json << EOF
{
  "sessionId": "$SESSION_ID",
  "script": "var msgs = document.querySelectorAll('[data-message-author-role=\"assistant\"]'); if(msgs.length > 0) { var lastMsg = msgs[msgs.length - 1]; var text = lastMsg.innerText || lastMsg.textContent || ''; text.substring(0, 2000); } else { ''; }"
}
EOF
    
    RESPONSE=$(curl -s -X POST $AUTOCHROME_URL/api/execute -H 'Content-Type: application/json' -d @/tmp/chatgpt_check.json | jq -r '.result')
    
    if [ ! -z "$RESPONSE" ] && [ "$RESPONSE" != "null" ] && [ "$RESPONSE" != "" ]; then
        echo -e "${GREEN}✓ Response received!${NC}"
        break
    fi
    
    echo -n "."
    ATTEMPT=$((ATTEMPT + 1))
done

echo ""

# Step 6: Display results
echo -e "${YELLOW}[6/6] Results:${NC}"
echo "----------------------------------------"
if [ ! -z "$RESPONSE" ] && [ "$RESPONSE" != "null" ]; then
    echo -e "${GREEN}ChatGPT Response:${NC}"
    echo "$RESPONSE" | fold -w 80 -s
    
    # Save to file
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    OUTPUT_FILE="/tmp/chatgpt_response_$TIMESTAMP.txt"
    echo "Question: $QUESTION" > $OUTPUT_FILE
    echo "----------------------------------------" >> $OUTPUT_FILE
    echo "Response: $RESPONSE" >> $OUTPUT_FILE
    echo -e "\n${GREEN}✓ Response saved to: $OUTPUT_FILE${NC}"
else
    echo -e "${RED}❌ No response received within timeout${NC}"
    exit 1
fi

# Optional: Take screenshot
echo -e "\n${YELLOW}Taking screenshot...${NC}"
SCREENSHOT=$(curl -s -X POST $AUTOCHROME_URL/api/screenshot/capture -H 'Content-Type: application/json' -d "{\"sessionId\":\"$SESSION_ID\",\"options\":{\"format\":\"png\"}}" | jq -r '.screenshot.filename')
if [ ! -z "$SCREENSHOT" ]; then
    echo -e "${GREEN}✓ Screenshot saved: $SCREENSHOT${NC}"
fi

echo "----------------------------------------"
echo -e "${GREEN}✅ Automation completed successfully!${NC}"