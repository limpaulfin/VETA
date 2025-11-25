#!/usr/bin/env python3
"""
ChatGPT Full Feature Automation Script
Complete automation for all ChatGPT UI elements and features
"""

import requests
import json
import time
from typing import Optional, Dict, Any, List
from datetime import datetime

class ChatGPTFullAutomation:
    def __init__(self, base_url: str = "http://localhost:49445"):
        self.base_url = base_url
        self.session_id = None
        
    def create_session(self) -> str:
        """Create AutoChrome session"""
        response = requests.post(f"{self.base_url}/api/session/create")
        self.session_id = response.json()['session']['id']
        return self.session_id
    
    def execute(self, script: str) -> Any:
        """Execute JavaScript in browser"""
        if not self.session_id:
            self.create_session()
        
        response = requests.post(
            f"{self.base_url}/api/execute",
            json={"sessionId": self.session_id, "script": script}
        )
        return response.json().get('result')
    
    def select_chatgpt_tab(self) -> bool:
        """Find and select ChatGPT tab"""
        response = requests.get(f"{self.base_url}/api/tabs/list")
        tabs = response.json()['tabs']
        
        for tab in tabs:
            if 'chatgpt.com' in tab.get('url', '').lower():
                requests.post(
                    f"{self.base_url}/api/tabs/select",
                    json={"tabId": tab['id']}
                )
                return True
        return False
    
    # ============= BUTTON OPERATIONS =============
    
    def click_search_button(self) -> str:
        """Click Search button to enable search mode"""
        script = """
        var searchBtn = document.querySelector('[data-testid="composer-button-search"] button') || 
                        document.querySelectorAll('button')[7];
        if(searchBtn) {
            searchBtn.style.backgroundColor = 'yellow';
            searchBtn.click();
            'Search mode activated';
        } else {
            'Search button not found';
        }
        """
        return self.execute(script)
    
    def click_study_button(self) -> str:
        """Click Study button to enable study mode"""
        script = """
        var studyBtn = document.querySelector('[data-testid="composer-button-study"]') || 
                       document.querySelectorAll('button')[8];
        if(studyBtn) {
            studyBtn.style.backgroundColor = 'lightblue';
            studyBtn.click();
            'Study mode activated';
        } else {
            'Study button not found';
        }
        """
        return self.execute(script)
    
    def click_voice_button(self) -> str:
        """Click Voice button to start voice mode"""
        script = """
        var voiceBtn = document.querySelector('[data-testid="composer-speech-button"]');
        if(voiceBtn) {
            voiceBtn.style.backgroundColor = 'purple';
            voiceBtn.click();
            'Voice mode: ' + voiceBtn.getAttribute('aria-label');
        } else {
            'Voice button not found';
        }
        """
        return self.execute(script)
    
    def click_attach_button(self) -> str:
        """Click Attach/Upload button"""
        script = """
        var attachBtn = document.querySelector('[aria-label="Add photos"]') || 
                        document.querySelector('[data-testid="composer-action-file-upload"] button');
        if(attachBtn) {
            attachBtn.style.backgroundColor = 'lightgreen';
            attachBtn.click();
            'Attach dialog opened';
        } else {
            'Attach button not found';
        }
        """
        return self.execute(script)
    
    # ============= MODEL OPERATIONS =============
    
    def get_current_model(self) -> str:
        """Get currently selected model"""
        script = """
        var modelBtn = document.querySelector('[data-testid="model-switcher-dropdown-button"]') || 
                       document.querySelector('button[aria-haspopup="menu"]');
        modelBtn ? modelBtn.textContent.trim() : 'Unknown model';
        """
        return self.execute(script)
    
    def switch_model(self, model_name: str = None) -> str:
        """Switch to different model"""
        # First click dropdown
        script1 = """
        var modelBtn = document.querySelector('[data-testid="model-switcher-dropdown-button"]') || 
                       document.querySelector('button[aria-haspopup="menu"]');
        if(modelBtn) {
            modelBtn.click();
            'Dropdown opened';
        } else {
            'Model button not found';
        }
        """
        self.execute(script1)
        time.sleep(0.5)
        
        # Then select model
        if model_name:
            script2 = f"""
            var items = document.querySelectorAll('[role="menuitem"], [role="option"]');
            var found = false;
            for(var i = 0; i < items.length; i++) {{
                if(items[i].textContent.includes('{model_name}')) {{
                    items[i].click();
                    found = true;
                    break;
                }}
            }}
            found ? 'Switched to ' + '{model_name}' : 'Model not found';
            """
        else:
            # Just get available models
            script2 = """
            var items = document.querySelectorAll('[role="menuitem"], [role="option"]');
            var models = [];
            for(var i = 0; i < items.length; i++) {
                models.push(items[i].textContent.trim());
            }
            models.join(', ');
            """
        return self.execute(script2)
    
    # ============= TEXT OPERATIONS =============
    
    def input_message(self, text: str) -> str:
        """Input text into prompt area"""
        script = f"""
        var editor = document.querySelector('.ProseMirror');
        if(editor) {{
            editor.focus();
            editor.innerHTML = '<p>{text}</p>';
            editor.dispatchEvent(new Event('input', {{bubbles: true}}));
            'Text inputted';
        }} else {{
            'Editor not found';
        }}
        """
        return self.execute(script)
    
    def send_message(self) -> str:
        """Send the message"""
        script = """
        var sendBtn = document.querySelector('button[aria-label*="Send"]') || 
                      document.querySelector('button[type="submit"]:not(:disabled)');
        if(!sendBtn) {
            var buttons = document.querySelectorAll('button');
            sendBtn = buttons[buttons.length - 1];
        }
        if(sendBtn && !sendBtn.disabled) {
            sendBtn.click();
            'Message sent';
        } else {
            'Send button not available';
        }
        """
        return self.execute(script)
    
    def send_with_enter(self) -> str:
        """Send message using Enter key"""
        script = """
        var editor = document.querySelector('.ProseMirror');
        if(editor) {
            var event = new KeyboardEvent('keydown', {
                key: 'Enter',
                code: 'Enter',
                keyCode: 13,
                bubbles: true
            });
            editor.dispatchEvent(event);
            'Enter key pressed';
        } else {
            'Editor not found';
        }
        """
        return self.execute(script)
    
    # ============= CONVERSATION OPERATIONS =============
    
    def get_last_response(self) -> str:
        """Get last ChatGPT response"""
        script = """
        var messages = document.querySelectorAll('[data-message-author-role="assistant"]');
        if(messages.length > 0) {
            var lastMsg = messages[messages.length - 1];
            lastMsg.innerText || lastMsg.textContent || '';
        } else {
            'No response yet';
        }
        """
        return self.execute(script)
    
    def get_full_conversation(self) -> List[Dict[str, str]]:
        """Get entire conversation"""
        script = """
        var messages = document.querySelectorAll('[data-message-author-role]');
        var conversation = [];
        for(var i = 0; i < messages.length; i++) {
            var msg = messages[i];
            conversation.push({
                role: msg.getAttribute('data-message-author-role'),
                content: (msg.innerText || msg.textContent || '').substring(0, 500)
            });
        }
        JSON.stringify(conversation);
        """
        result = self.execute(script)
        try:
            return json.loads(result) if result else []
        except:
            return []
    
    def copy_last_response(self) -> str:
        """Copy last response to clipboard"""
        script = """
        var messages = document.querySelectorAll('[data-message-author-role="assistant"]');
        if(messages.length > 0) {
            var lastMsg = messages[messages.length - 1];
            var copyBtn = lastMsg.parentElement.querySelector('button[aria-label*="Copy"]');
            if(copyBtn) {
                copyBtn.click();
                'Response copied to clipboard';
            } else {
                'Copy button not found';
            }
        } else {
            'No response to copy';
        }
        """
        return self.execute(script)
    
    # ============= UI STATE OPERATIONS =============
    
    def check_ui_state(self) -> Dict[str, Any]:
        """Check various UI states"""
        script = """
        var state = {
            isLoggedIn: !document.querySelector('[data-testid="login-button"]'),
            hasMessages: document.querySelectorAll('[data-message-author-role]').length > 0,
            editorEnabled: !document.querySelector('.ProseMirror')?.hasAttribute('disabled'),
            searchMode: document.querySelector('[data-testid="composer-button-search"][aria-pressed="true"]') !== null,
            studyMode: document.querySelector('[data-testid="composer-button-study"][aria-pressed="true"]') !== null,
            currentModel: document.querySelector('[data-testid="model-switcher-dropdown-button"]')?.textContent || 'unknown',
            messageCount: document.querySelectorAll('[data-message-author-role]').length
        };
        JSON.stringify(state);
        """
        result = self.execute(script)
        try:
            return json.loads(result) if result else {}
        except:
            return {}
    
    def clear_conversation(self) -> str:
        """Start new conversation"""
        script = """
        // Look for New Chat button
        var newChatBtn = document.querySelector('a[href="/"]') || 
                         document.querySelector('button[aria-label*="New chat"]');
        if(newChatBtn) {
            newChatBtn.click();
            'New conversation started';
        } else {
            'New chat button not found';
        }
        """
        return self.execute(script)
    
    # ============= PROFILE OPERATIONS =============
    
    def open_profile_menu(self) -> str:
        """Open profile dropdown menu"""
        script = """
        var profileBtn = document.querySelector('[data-testid="profile-button"]') || 
                         document.querySelector('button[aria-label*="profile"]');
        if(profileBtn) {
            profileBtn.click();
            'Profile menu opened';
        } else {
            'Profile button not found';
        }
        """
        return self.execute(script)
    
    def get_profile_menu_items(self) -> List[str]:
        """Get profile menu items after opening"""
        self.open_profile_menu()
        time.sleep(0.5)
        
        script = """
        var items = document.querySelectorAll('[role="menuitem"]');
        var menuItems = [];
        for(var i = 0; i < items.length; i++) {
            menuItems.push(items[i].textContent.trim());
        }
        JSON.stringify(menuItems);
        """
        result = self.execute(script)
        try:
            return json.loads(result) if result else []
        except:
            return []
    
    # ============= UTILITY OPERATIONS =============
    
    def take_screenshot(self, filename: str = None) -> str:
        """Take screenshot of current state"""
        response = requests.post(
            f"{self.base_url}/api/screenshot/capture",
            json={"sessionId": self.session_id, "options": {"format": "png"}}
        )
        if response.json().get('success'):
            return response.json()['screenshot']['filepath']
        return None
    
    def highlight_element(self, selector: str, color: str = 'yellow') -> str:
        """Highlight element for debugging"""
        script = f"""
        var el = document.querySelector('{selector}');
        if(el) {{
            el.style.backgroundColor = '{color}';
            el.style.border = '3px solid red';
            el.style.transform = 'scale(1.1)';
            el.scrollIntoView({{behavior: 'smooth', block: 'center'}});
            'Element highlighted';
        }} else {{
            'Element not found: {selector}';
        }}
        """
        return self.execute(script)
    
    def wait_for_element(self, selector: str, timeout: int = 10) -> bool:
        """Wait for element to appear"""
        for i in range(timeout):
            script = f"""
            document.querySelector('{selector}') ? 'found' : 'not_found';
            """
            if self.execute(script) == 'found':
                return True
            time.sleep(1)
        return False
    
    # ============= COMPLETE WORKFLOWS =============
    
    def complete_conversation_flow(self, question: str, use_search: bool = False, use_study: bool = False) -> Dict[str, Any]:
        """Complete conversation workflow with all features"""
        result = {
            "timestamp": datetime.now().isoformat(),
            "question": question,
            "search_mode": use_search,
            "study_mode": use_study,
            "response": None,
            "model": None,
            "state": None,
            "screenshot": None
        }
        
        print(f"\n🤖 Starting Complete ChatGPT Automation")
        print(f"📝 Question: {question}")
        print(f"🔍 Search Mode: {use_search}")
        print(f"📚 Study Mode: {use_study}")
        print("-" * 50)
        
        # Setup
        self.create_session()
        self.select_chatgpt_tab()
        
        # Get initial state
        result["state"] = self.check_ui_state()
        result["model"] = result["state"].get("currentModel", "unknown")
        print(f"📊 Current Model: {result['model']}")
        
        # Enable modes if requested
        if use_search:
            print("🔍 Enabling search mode...")
            self.click_search_button()
            time.sleep(0.5)
        
        if use_study:
            print("📚 Enabling study mode...")
            self.click_study_button()
            time.sleep(0.5)
        
        # Send message
        print("💬 Sending message...")
        self.input_message(question)
        time.sleep(0.5)
        self.send_message()
        
        # Wait for response
        print("⏳ Waiting for response...")
        for i in range(30):
            time.sleep(1)
            response = self.get_last_response()
            if response and response != "No response yet":
                result["response"] = response
                print("✅ Response received!")
                break
            print(".", end="", flush=True)
        
        print()
        
        # Take screenshot
        result["screenshot"] = self.take_screenshot()
        if result["screenshot"]:
            print(f"📸 Screenshot saved: {result['screenshot']}")
        
        # Final state
        result["final_state"] = self.check_ui_state()
        
        return result

def main():
    import sys
    
    # Initialize automation
    bot = ChatGPTFullAutomation()
    
    # Parse command line arguments
    if len(sys.argv) < 2:
        print("Usage: python3 chatgpt-full-automation.py <command> [options]")
        print("\nCommands:")
        print("  ask <question>     - Ask a question")
        print("  search <question>  - Ask with search mode")
        print("  study <question>   - Ask with study mode")
        print("  state             - Check UI state")
        print("  models            - List available models")
        print("  conversation      - Get full conversation")
        print("  screenshot        - Take screenshot")
        print("  clear            - Start new conversation")
        return
    
    command = sys.argv[1]
    
    if command == "ask" and len(sys.argv) > 2:
        question = " ".join(sys.argv[2:])
        result = bot.complete_conversation_flow(question)
        if result["response"]:
            print("\n📄 Response:")
            print("-" * 50)
            print(result["response"][:500])
    
    elif command == "search" and len(sys.argv) > 2:
        question = " ".join(sys.argv[2:])
        result = bot.complete_conversation_flow(question, use_search=True)
        if result["response"]:
            print("\n📄 Response (Search Mode):")
            print("-" * 50)
            print(result["response"][:500])
    
    elif command == "study" and len(sys.argv) > 2:
        question = " ".join(sys.argv[2:])
        result = bot.complete_conversation_flow(question, use_study=True)
        if result["response"]:
            print("\n📄 Response (Study Mode):")
            print("-" * 50)
            print(result["response"][:500])
    
    elif command == "state":
        bot.create_session()
        bot.select_chatgpt_tab()
        state = bot.check_ui_state()
        print("\n📊 ChatGPT UI State:")
        print("-" * 50)
        for key, value in state.items():
            print(f"{key}: {value}")
    
    elif command == "models":
        bot.create_session()
        bot.select_chatgpt_tab()
        print(f"Current model: {bot.get_current_model()}")
        print("\nAvailable models:")
        models = bot.switch_model()  # Just get list
        print(models)
    
    elif command == "conversation":
        bot.create_session()
        bot.select_chatgpt_tab()
        conv = bot.get_full_conversation()
        print("\n💬 Full Conversation:")
        print("-" * 50)
        for msg in conv:
            print(f"[{msg.get('role', 'unknown')}]: {msg.get('content', '')[:200]}...")
    
    elif command == "screenshot":
        bot.create_session()
        bot.select_chatgpt_tab()
        path = bot.take_screenshot()
        print(f"Screenshot saved: {path}")
    
    elif command == "clear":
        bot.create_session()
        bot.select_chatgpt_tab()
        result = bot.clear_conversation()
        print(result)
    
    else:
        print("Invalid command or missing arguments")
        print("Run without arguments to see usage")

if __name__ == "__main__":
    main()