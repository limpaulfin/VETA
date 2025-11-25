# 🛡️ Kali Security & Hacking Books RAG - Query Instructions

**📅 Date Created:** 2025-10-05
**👨‍💻 Author:** Fong & AI Assistant
**🎯 Purpose:** Query Kali Linux, penetration testing, networking, và OSINT books collection

## 📚 RAG COLLECTION PATH

```bash
# Kali Security Books Collection
RAG_BOOKS="/home/fong/Projects/RAG-Kali-hacking-books"

# Mini-RAG Command
RAG_CMD="/home/fong/Projects/mini-rag/run.sh"
```

## 📖 AVAILABLE BOOKS (11 PDFs)

### 1. **Kali Linux Penetration Testing Bible** (`kali-pentesting-bible.pdf`)
   - **Author:** Glen D. Singh
   - **Topics:** Complete pentesting lifecycle, reconnaissance, exploitation, privilege escalation, reporting
   - **18 Chapters:** Terminal mastery → Bash scripting → Network scanning → Web vulnerabilities → Post-exploitation → Python automation
   - **Best for:** End-to-end penetration testing methodology

### 2. **Learning Kali Linux Security Testing** (`learning-kali-security.pdf`)
   - **Topics:** Kali Linux security testing fundamentals
   - **Best for:** Kali Linux beginners, security testing basics

### 3. **Mastering Kali Linux Advanced Pentesting** (`mastering-kali-advanced.pdf`)
   - **Topics:** Advanced penetration testing techniques
   - **Best for:** Advanced Kali users, complex attack scenarios

### 4. **Ultimate Kali Linux Book 3rd Edition** (`ultimate-kali-book.pdf`)
   - **Topics:** Comprehensive Kali Linux reference
   - **Best for:** Complete Kali Linux guide, tool mastery

### 5. **Linux Basics for Hackers** (`linux-basics-hackers.pdf`)
   - **Author:** OccupyTheWeb (Null-Byte founder, US military/intelligence trainer)
   - **Topics:** Linux fundamentals for hacking, terminal, networking, scripting, anonymity
   - **17 Chapters:** File system → Network manipulation → Permissions → Services → Wireless → Python scripting
   - **Best for:** Linux beginners entering hacking field, Kali Linux foundation

### 6. **Linux Hacking: Art of Exploitation** (`linux-hacking-exploitation.pdf`)
   - **Author:** Jon Erickson
   - **Topics:** C programming, assembly, buffer overflow, shellcode, exploitation techniques
   - **Best for:** Low-level exploitation, binary hacking, exploit development

### 7. **Linux Programming Interface** (`linux-programming.pdf`)
   - **Topics:** Linux system programming, kernel interface
   - **Best for:** Linux internals, system-level programming

### 8. **TCP/IP Guide** (`tcp-ip-guide.pdf`)
   - **Author:** Charles M. Kozierok (MIT EECS Master's)
   - **Topics:** TCP/IP protocol suite, OSI model, IP addressing, routing, DNS, HTTP
   - **300+ Illustrations:** Protocol stack, 3-way handshake, network troubleshooting
   - **Best for:** Network protocol fundamentals, TCP/IP architecture

### 9. **TCP/IP Illustrated Vol 1: Protocols** (`tcp-ip-protocols.pdf`)
   - **Topics:** TCP/IP protocols illustrated, detailed protocol analysis
   - **Best for:** Deep protocol understanding, packet-level analysis

### 10. **Open Source Intelligence Techniques** (`osint-techniques.pdf`)
   - **Author:** Michael Bazzell
   - **Edition:** Sixth Edition (2018)
   - **14 Chapters:** Computer setup → Search engines → Social media → People search → Geolocation
   - **Tools:** Buscador VM, Firefox/Chrome extensions, IntelTechniques, TweetDeck
   - **Best for:** Social media intelligence, people tracking, digital investigation

### 11. **If It's Smart, It's Vulnerable** (`smart-vulnerable.pdf`)
   - **Topics:** IoT security vulnerabilities, smart device hacking
   - **Best for:** IoT security testing, smart device exploitation

## 🎯 QUERY SYNTAX

```bash
# Standard query format
$RAG_CMD "[ENGLISH_QUERY]" $RAG_BOOKS

# Example
/home/fong/Projects/mini-rag/run.sh "nmap scanning techniques" /home/fong/Projects/RAG-Kali-hacking-books
```

## 📝 QUERY PATTERNS BY DOMAIN

### 1. Network Reconnaissance & Scanning
```bash
# Simple, focused queries
"nmap port scanning"
"network reconnaissance techniques"
"DNS enumeration methods"
"service discovery scanning"
"stealth scan techniques"
```

### 2. Exploitation & Vulnerabilities
```bash
"buffer overflow exploitation"
"SQL injection techniques"
"XSS cross site scripting"
"privilege escalation methods"
"exploit development basics"
```

### 3. Linux Security & Hacking
```bash
"Linux privilege escalation"
"SUID exploitation techniques"
"kernel exploit methods"
"bash scripting pentesting"
"Linux permission exploitation"
```

### 4. Kali Tools & Techniques
```bash
"metasploit framework usage"
"burp suite web testing"
"aircrack wireless hacking"
"hashcat password cracking"
"wireshark packet analysis"
```

### 5. OSINT & Information Gathering
```bash
"OSINT social media intelligence"
"email address verification"
"username tracking techniques"
"Google dorks advanced search"
"metadata analysis methods"
```

### 6. TCP/IP & Networking
```bash
"TCP handshake process"
"IP addressing subnetting"
"network protocol analysis"
"packet capture inspection"
"routing protocols basics"
```

### 7. Web Application Security
```bash
"web application vulnerabilities"
"OWASP top ten security"
"authentication bypass techniques"
"session hijacking methods"
"CSRF attack prevention"
```

### 8. Wireless Security
```bash
"WiFi cracking techniques"
"wireless network attacks"
"WPA WPA2 exploitation"
"Bluetooth security testing"
"wireless reconnaissance methods"
```

### 9. Post-Exploitation
```bash
"lateral movement techniques"
"hash dumping methods"
"pivoting network access"
"persistence establishment techniques"
"data exfiltration methods"
```

### 10. Cryptography & Passwords
```bash
"hash cracking techniques"
"password attack methods"
"encryption basics security"
"hashcat usage examples"
"rainbow table attacks"
```

## ✅ QUERY BEST PRACTICES

### DO's:
1. **Use simple, focused English** - "nmap scanning" not "how to use nmap for scanning networks"
2. **Technical terminology** - "SUID exploitation" not "special permissions attack"
3. **Combine 2-4 keywords** - "privilege escalation Linux kernel"
4. **Specific tool names** - "metasploit payload generation"
5. **Precise techniques** - "SQL injection blind techniques"

### DON'Ts:
1. **Avoid Vietnamese** - English only
2. **No complex boolean** - NOT "(SQL OR XSS) AND (NOT basic)"
3. **No long sentences** - Keep queries short
4. **No generic terms** - "hacking" alone too broad
5. **No question format** - "nmap stealth scan" not "how to do stealth scan with nmap?"

## 🚀 COMMON USE CASES

### Learning Pentesting Basics:
```bash
$RAG_CMD "penetration testing methodology phases" $RAG_BOOKS
$RAG_CMD "reconnaissance information gathering techniques" $RAG_BOOKS
$RAG_CMD "vulnerability assessment scanning" $RAG_BOOKS
```

### Network Security Testing:
```bash
$RAG_CMD "network scanning nmap techniques" $RAG_BOOKS
$RAG_CMD "port scanning stealth methods" $RAG_BOOKS
$RAG_CMD "network service enumeration" $RAG_BOOKS
```

### Web Application Testing:
```bash
$RAG_CMD "SQL injection exploitation techniques" $RAG_BOOKS
$RAG_CMD "XSS vulnerability detection" $RAG_BOOKS
$RAG_CMD "web application attack vectors" $RAG_BOOKS
```

### OSINT Investigation:
```bash
$RAG_CMD "social media intelligence gathering" $RAG_BOOKS
$RAG_CMD "email tracking verification methods" $RAG_BOOKS
$RAG_CMD "reverse image search techniques" $RAG_BOOKS
```

### Linux Exploitation:
```bash
$RAG_CMD "SUID privilege escalation" $RAG_BOOKS
$RAG_CMD "Linux kernel exploitation" $RAG_BOOKS
$RAG_CMD "bash scripting automation pentesting" $RAG_BOOKS
```

## 📊 PERFORMANCE NOTES

- **First run**: ~2-5 minutes (builds index from 11 PDFs)
- **Cached runs**: ~5-10 seconds
- **Index location**: `/home/fong/Projects/RAG-Kali-hacking-books/.mini_rag_index/`
- **Results saved**: `/home/fong/Projects/mini-rag/results/`

## 🔄 FORCE REBUILD (Only When Needed)

```bash
# Only use --force-rebuild if:
# - Added/removed PDFs
# - Results seem outdated
# - System warns about file changes

$RAG_CMD "query here" $RAG_BOOKS --force-rebuild
```

## 🎯 EXAMPLE QUERIES

```bash
# Network scanning
/home/fong/Projects/mini-rag/run.sh "nmap stealth scan SYN ACK" /home/fong/Projects/RAG-Kali-hacking-books

# Privilege escalation
/home/fong/Projects/mini-rag/run.sh "SUID exploitation Linux privilege" /home/fong/Projects/RAG-Kali-hacking-books

# OSINT techniques
/home/fong/Projects/mini-rag/run.sh "Google dorks advanced search operators" /home/fong/Projects/RAG-Kali-hacking-books

# Web vulnerabilities
/home/fong/Projects/mini-rag/run.sh "SQL injection blind boolean time based" /home/fong/Projects/RAG-Kali-hacking-books

# Wireless hacking
/home/fong/Projects/mini-rag/run.sh "WiFi WPA2 cracking aircrack" /home/fong/Projects/RAG-Kali-hacking-books

# TCP/IP networking
/home/fong/Projects/mini-rag/run.sh "TCP handshake three way connection" /home/fong/Projects/RAG-Kali-hacking-books

# Exploitation techniques
/home/fong/Projects/mini-rag/run.sh "buffer overflow shellcode exploitation" /home/fong/Projects/RAG-Kali-hacking-books

# Post-exploitation
/home/fong/Projects/mini-rag/run.sh "lateral movement pivoting techniques" /home/fong/Projects/RAG-Kali-hacking-books
```

## 🧠 AI WORKFLOW

### Query Construction Process:
1. **Think Ultra** - Identify security domain (network/web/OSINT/exploitation)
2. **Extract Keywords** - Technical terms, tool names, attack types
3. **Construct Query** - Combine 2-4 precise English keywords
4. **Execute RAG** - Run query against Kali books collection
5. **Process Results** - Apply retrieved knowledge as reference

### Domain Mapping:
- User asks về **scanning** → "nmap reconnaissance scanning techniques"
- User asks về **tấn công web** → "SQL injection XSS web vulnerabilities"
- User asks về **OSINT** → "social media intelligence gathering OSINT"
- User asks về **Linux exploit** → "privilege escalation SUID kernel exploit"

## 📚 SUMMARIES AVAILABLE

Em đã tạo AI summaries cho 4 books (có thể đọc để hiểu nội dung):
- `tcp-ip-guide_summary.md`
- `kali-pentesting-bible_summary.md`
- `linux-basics-hackers_summary.md`
- `osint-techniques_summary.md`

## 🔧 TROUBLESHOOTING

```bash
# Check if index exists
ls -la /home/fong/Projects/RAG-Kali-hacking-books/.mini_rag_index/

# Test with simple query
/home/fong/Projects/mini-rag/run.sh "penetration testing" /home/fong/Projects/RAG-Kali-hacking-books

# Rebuild if needed
/home/fong/Projects/mini-rag/run.sh "test query" /home/fong/Projects/RAG-Kali-hacking-books --force-rebuild
```

---

**🎯 Key Principle**: Simple, precise English queries với technical terms = Best results!
