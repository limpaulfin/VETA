#!/bin/bash

# ChatGPT Quick One-Liner Commands
# Copy and paste these commands for ultra-fast automation

echo "📚 ChatGPT Quick Automation Commands"
echo "===================================="
echo ""
echo "1️⃣ ASK CHATGPT (One-liner):"
echo 'Q="What is 2+2?" && S=$(curl -s -X POST http://localhost:49445/api/session/create | jq -r ".session.id") && T=$(curl -s http://localhost:49445/api/tabs/list | jq -r ".tabs[] | select(.url | contains(\"chatgpt\")) | .id" | head -1) && curl -s -X POST http://localhost:49445/api/tabs/select -d "{\"tabId\":\"$T\"}" -H "Content-Type: application/json" && curl -s -X POST http://localhost:49445/api/execute -d "{\"sessionId\":\"$S\",\"script\":\"document.querySelector(\".ProseMirror\").innerHTML='"'"'<p>$Q</p>'"'"';document.querySelector(\".ProseMirror\").dispatchEvent(new Event(\"input\",{bubbles:true}));setTimeout(()=>{document.querySelector('"'"'button[aria-label=\"Send prompt\"]'"'"').click()},500);\"ok\"\"}" -H "Content-Type: application/json" && sleep 3 && curl -s -X POST http://localhost:49445/api/execute -d "{\"sessionId\":\"$S\",\"script\":\"document.querySelector('"'"'[data-message-author-role=\"assistant\"]'"'"')?.innerText||'"'"'Waiting...'"'"'\"}" -H "Content-Type: application/json" | jq -r ".result"'
echo ""
echo "2️⃣ QUICK INPUT TEXT:"
echo 'curl -X POST http://localhost:49445/api/execute -H "Content-Type: application/json" -d "{\"sessionId\":\"$(curl -s -X POST http://localhost:49445/api/session/create | jq -r .session.id)\",\"script\":\"document.querySelector('"'"'.ProseMirror'"'"').innerHTML='"'"'<p>Hello ChatGPT!</p>'"'"';'"'"'Done'"'"'\"}" | jq -r .result'
echo ""
echo "3️⃣ CLICK SEARCH BUTTON:"
echo 'S=$(curl -s -X POST http://localhost:49445/api/session/create | jq -r .session.id) && curl -X POST http://localhost:49445/api/execute -d "{\"sessionId\":\"$S\",\"script\":\"document.querySelectorAll('"'"'button'"'"')[7].click();'"'"'Search clicked'"'"'\"}" -H "Content-Type: application/json"'
echo ""
echo "4️⃣ GET LAST RESPONSE:"
echo 'curl -X POST http://localhost:49445/api/execute -H "Content-Type: application/json" -d "{\"sessionId\":\"SESSION_ID\",\"script\":\"Array.from(document.querySelectorAll('"'"'[data-message-author-role=\"assistant\"]'"'"')).pop()?.innerText||'"'"'No response yet'"'"'\"}" | jq -r .result'
echo ""
echo "5️⃣ FULL CONVERSATION EXTRACT:"
echo 'curl -X POST http://localhost:49445/api/execute -H "Content-Type: application/json" -d "{\"sessionId\":\"SESSION_ID\",\"script\":\"Array.from(document.querySelectorAll('"'"'[data-message-author-role]'"'"')).map(m=>m.getAttribute('"'"'data-message-author-role'"'"')+'"'"': '"'"'+m.innerText.substring(0,100)).join('"'"'\\n---\\n'"'"')\"}" | jq -r .result'
echo ""
echo "===================================="
echo "💡 Replace SESSION_ID with actual session ID"
echo "💡 Replace question text as needed"