#!/usr/bin/env python3
"""
ChatGPT Automation Script - Advanced Version
Fast execution with timeout and result extraction
"""

import requests
import json
import time
import sys
from typing import Optional, Dict, Any
from datetime import datetime

class ChatGPTAutomation:
    def __init__(self, base_url: str = "http://localhost:49445"):
        self.base_url = base_url
        self.session_id = None
        self.tab_id = None
        
    def create_session(self) -> bool:
        """Create new AutoChrome session"""
        try:
            response = requests.post(f"{self.base_url}/api/session/create")
            data = response.json()
            self.session_id = data['session']['id']
            print(f"✅ Session created: {self.session_id}")
            return True
        except Exception as e:
            print(f"❌ Failed to create session: {e}")
            return False
    
    def find_chatgpt_tab(self) -> bool:
        """Find and select ChatGPT tab"""
        try:
            response = requests.get(f"{self.base_url}/api/tabs/list")
            tabs = response.json()['tabs']
            
            for tab in tabs:
                if 'chatgpt.com' in tab.get('url', '').lower():
                    self.tab_id = tab['id']
                    # Select the tab
                    requests.post(
                        f"{self.base_url}/api/tabs/select",
                        json={"tabId": self.tab_id}
                    )
                    print(f"✅ ChatGPT tab found and selected")
                    return True
            
            print("❌ ChatGPT tab not found. Please open https://chatgpt.com")
            return False
        except Exception as e:
            print(f"❌ Error finding tab: {e}")
            return False
    
    def execute_script(self, script: str) -> Optional[str]:
        """Execute JavaScript in browser"""
        try:
            response = requests.post(
                f"{self.base_url}/api/execute",
                json={"sessionId": self.session_id, "script": script}
            )
            return response.json().get('result')
        except Exception as e:
            print(f"❌ Script execution error: {e}")
            return None
    
    def input_text(self, text: str) -> bool:
        """Input text into ChatGPT prompt area"""
        script = f"""
        var e = document.querySelector('.ProseMirror');
        if(e) {{
            e.focus();
            e.innerHTML = '<p>{text}</p>';
            e.dispatchEvent(new Event('input', {{bubbles: true}}));
            'Success';
        }} else {{
            'Editor not found';
        }}
        """
        result = self.execute_script(script)
        success = result == 'Success'
        print(f"{'✅' if success else '❌'} Text input: {result}")
        return success
    
    def submit_message(self) -> bool:
        """Submit the message to ChatGPT"""
        # First try to find the send button
        find_script = """
        var buttons = document.querySelectorAll('button');
        for(var i = 0; i < buttons.length; i++) {
            var btn = buttons[i];
            var label = btn.getAttribute('aria-label') || '';
            var text = btn.textContent || '';
            if(label.toLowerCase().includes('send') || text.toLowerCase().includes('send')) {
                return i + '|' + label + '|' + text;
            }
        }
        return 'not_found';
        """
        button_info = self.execute_script(find_script)
        
        if button_info and button_info != 'not_found':
            button_index = button_info.split('|')[0]
            click_script = f"""
            var btn = document.querySelectorAll('button')[{button_index}];
            if(btn && !btn.disabled) {{
                btn.click();
                'Sent';
            }} else {{
                'Button disabled or not found';
            }}
            """
        else:
            # Fallback: try last button (usually the send button)
            click_script = """
            var buttons = document.querySelectorAll('button');
            var lastBtn = buttons[buttons.length - 1];
            if(lastBtn && !lastBtn.disabled) {
                lastBtn.click();
                'Sent via last button';
            } else {
                'No send button found';
            }
            """
        
        result = self.execute_script(click_script)
        success = result and 'Sent' in str(result)
        print(f"{'✅' if success else '❌'} Message submit: {result}")
        return success
    
    def wait_for_response(self, timeout: int = 30) -> Optional[str]:
        """Wait for ChatGPT response with timeout"""
        print("⏳ Waiting for response", end="")
        
        for i in range(timeout):
            time.sleep(1)
            print(".", end="", flush=True)
            
            script = """
            var msgs = document.querySelectorAll('[data-message-author-role="assistant"]');
            if(msgs.length > 0) {
                var lastMsg = msgs[msgs.length - 1];
                var text = lastMsg.innerText || lastMsg.textContent || '';
                text;
            } else {
                '';
            }
            """
            
            response = self.execute_script(script)
            if response and response.strip():
                print("\n✅ Response received!")
                return response
        
        print("\n❌ Timeout waiting for response")
        return None
    
    def take_screenshot(self) -> Optional[str]:
        """Take screenshot of current page"""
        try:
            response = requests.post(
                f"{self.base_url}/api/screenshot/capture",
                json={"sessionId": self.session_id, "options": {"format": "png"}}
            )
            data = response.json()
            if data.get('success'):
                filepath = data['screenshot']['filepath']
                print(f"📸 Screenshot saved: {filepath}")
                return filepath
        except Exception as e:
            print(f"❌ Screenshot error: {e}")
        return None
    
    def ask_chatgpt(self, question: str, wait_timeout: int = 30) -> Dict[str, Any]:
        """Complete flow to ask ChatGPT a question"""
        result = {
            "question": question,
            "response": None,
            "screenshot": None,
            "timestamp": datetime.now().isoformat(),
            "success": False
        }
        
        print(f"\n🤖 ChatGPT Automation Started")
        print(f"📝 Question: {question}")
        print("-" * 50)
        
        # Step 1: Setup
        if not self.create_session():
            return result
        
        if not self.find_chatgpt_tab():
            return result
        
        # Step 2: Input and submit
        if not self.input_text(question):
            return result
        
        time.sleep(0.5)  # Small delay for UI update
        
        if not self.submit_message():
            return result
        
        # Step 3: Wait for response
        response = self.wait_for_response(wait_timeout)
        if response:
            result["response"] = response
            result["success"] = True
            
            # Save to file
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            output_file = f"/tmp/chatgpt_{timestamp}.txt"
            with open(output_file, 'w') as f:
                f.write(f"Question: {question}\n")
                f.write(f"{'=' * 50}\n")
                f.write(f"Response: {response}\n")
                f.write(f"{'=' * 50}\n")
                f.write(f"Timestamp: {result['timestamp']}\n")
            print(f"💾 Response saved to: {output_file}")
            
            # Take screenshot
            result["screenshot"] = self.take_screenshot()
        
        print("-" * 50)
        print(f"{'✅ Success!' if result['success'] else '❌ Failed!'}")
        
        return result

def main():
    # Get question from command line or use default
    question = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else "What is the meaning of life?"
    
    # Run automation
    automation = ChatGPTAutomation()
    result = automation.ask_chatgpt(question)
    
    # Display result
    if result["success"]:
        print(f"\n📄 ChatGPT Response:")
        print("-" * 50)
        # Wrap text for better display
        response_text = result["response"]
        for line in response_text.split('\n'):
            while len(line) > 80:
                print(line[:80])
                line = line[80:]
            print(line)
    
    return 0 if result["success"] else 1

if __name__ == "__main__":
    sys.exit(main())