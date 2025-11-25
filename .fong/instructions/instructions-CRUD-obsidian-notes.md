# Instructions: CRUD Obsidian Notes
4b945712-6b1d-440d-83d9-ae444af11618
**Created:** 2025-08-22  
**Updated:** 2025-09-14

## Overview

This document defines comprehensive procedures for Create, Read, Update, Delete operations and intelligent search within the Obsidian knowledge vault system.

## System Configuration

### Prerequisites
- **Operating System**: Linux
- **Base Directory**: `/home/fong/Projects/dropbox-obsidian/`
- **Main Vault**: `/home/fong/Projects/dropbox-obsidian/FongObsidian/`
- **Search Tool**: Use `smart-search-fz-rg-bm25` for primary search (fallback: `rg`/ripgrep)
  - Setup & advanced options: `.fong/instructions/smartsearch.md`
- **Image Analysis**: Use Image Reader tool for screenshots and images in notes

### System Directory Structure

#### File Creation Strategy
Default location for new files:
- **Primary**: `/home/fong/Projects/dropbox-obsidian/FongObsidian/AI/` (for AI-related content)
- **Alternative**: Choose appropriate folder based on content type

## Search Operations

### Step 1: Structure Analysis (MANDATORY)
Always start with directory structure analysis using `tree`:

```bash
# Level 1 overview
tree -L 1 /home/fong/Projects/dropbox-obsidian/FongObsidian/

# Level 2 detailed (when needed)
tree -L 2 /home/fong/Projects/dropbox-obsidian/FongObsidian/01-IMPORTANT-n-URGENT
```

### Step 2: Intelligent Search with smart-search-fz-rg-bm25 (fallback: rg)

Primary hybrid search (fuzzy + BM25):

```bash
smart-search-fz-rg-bm25 "keyword1 keyword2" /home/fong/Projects/dropbox-obsidian/FongObsidian/ --show-content
```

Fallback ripgrep pipeline:

#### Comprehensive Search Strategy

Search toàn bộ Obsidian vault với keyword expansion strategy:

```bash
# Full FongObsidian vault search với multiple keyword patterns
rg --color=auto -i -H -E 'keyword1|keyword2|keyword3|keyword4|keyword5|keyword6|keyword7|keyword8|keyword9|...' \
-g '*.md' -g '*.txt' -g '*.mdc' -g '*.json' \
/home/fong/Projects/dropbox-obsidian/FongObsidian/ | cat
```

**MANDATORY**: Thực hiện tối thiểu 2-3 lần search với các bộ keywords khác nhau để đảm bảo comprehensive coverage.

### Step 3: Advanced Keyword Expansion Strategy

**MANDATORY**: Generate tối thiểu 9 keywords mỗi lần search để đảm bảo comprehensive coverage:

#### Keyword Expansion Categories:
1. **Vietnamese terms** (có dấu)
2. **Vietnamese terms** (không dấu) 
3. **English equivalents**
4. **Technical synonyms**
5. **Related concepts**
6. **Alternative spellings**
7. **Abbreviations/acronyms**
8. **Common misspellings**
9. **Context-related terms**

**Enhanced Example:**
- Base: "Linux Mint"
- Expanded: `linux mint|linux-mint|linuxmint|kubuntu|ubuntu|cinnamon|kde|plasma|apt|debian|LTS|dual boot|ppa|nvidia|driver|troubleshooting|installation|gui|desktop environment`

**Vietnamese Example:**
- Base: "trí tuệ nhân tạo"
- Expanded: `tri tue nhan tao|trí tuệ nhân tạo|artificial intelligence|AI|machine learning|ML|deep learning|neural network|mạng nơ-ron|học máy|thuật toán|algorithm|chatbot|automation`

### Step 4: Time-Based Search (Advanced)

For recent file prioritization:
```bash
find /home/fong/Projects/dropbox-obsidian/FongObsidian/ \
-type d \( -name 'cache' -o -name '__pycache__' -o -name '.history' -o -name '.git' -o -name '.memory' \) -prune \
-o -type f ! -name '*.pdf' ! -name '*.bak' ! -name '*backup*' -printf '%T@ %p\n' \
| sort -rn \
| sed 's/^[0-9.]* //' \
| xargs -d '\n' rg -i -H -E 'keyword1|keyword2' | cat
```

## Image Processing in Notes

When processing Obsidian notes containing images:

### Step 1: Detect Images in Notes
If smart-search does not provide precise regex results, fallback to `rg` to find image references:
```bash
rg -E '!\[\[.*\.(png|jpg|jpeg|gif|webp|svg).*\]\]|!\[.*\]\(.*\.(png|jpg|jpeg|gif|webp|svg).*\)' /path/to/note.md
```

### Step 2: Dual Image Analysis (MANDATORY)
For each image found, use BOTH tools:

#### A) External Image Reader Tool
```bash
/home/fong/Projects/MCPs/fong_image_reader-core/run.sh /path/to/image.png
```

#### B) Claude Code Built-in Image Processing
- Use Claude Code's native Read tool for images
- Direct file path reading: `/path/to/image.png`
- Provides multimodal analysis capabilities

### Step 3: Comprehensive Image Documentation
- Combine analysis from both tools
- Include detailed image content in note context
- Maintain image analysis for searchability and reference

## CRUD Operations

### Create Operations

#### File Naming Convention
- **Primary Format** (AI folder): `YYYY-MM-DD-HH-MM-descriptive-name.md` (with timestamp prefix)
- **Alternative Format**: `kebab-case-for-file-names.md` (for non-time-sensitive content)
- **Location Priority**: Prefer creation in `/home/fong/Projects/dropbox-obsidian/FongObsidian/AI/` for AI-related content

#### Standard Note Template
```markdown
---
title: "Descriptive title based on content"
created: YYYY-MM-DD
updated: YYYY-MM-DD
aliases: 
  - Alternative name 1
  - Alias 2
category: "Topic classification"
status: "draft"
---

### Main Content
[Content here]

### Related Images
[If applicable, include image analysis from Image Reader]

tags: vietnamese-tags, english-tags, technical-terms, obsidian-notes

---
*This note was automatically generated by AI assistant (Asi).*
```

#### SSoT & DRY Compliance
- **MANDATORY**: Before creating/updating, use `smart-search-fz-rg-bm25` to scan for existing related content (fallback: `rg`)
- **Cross-reference**: Use Obsidian linking syntax `[[Other Note Name]]` for bi-directional links
- **Tag strategy**: Include both Vietnamese and English keywords for comprehensive search

### Read Operations

#### Comprehensive Search Protocol
1. **Full vault search**: Search toàn bộ `/home/fong/Projects/dropbox-obsidian/FongObsidian/` với expanded keywords
2. **Multi-round search**: Thực hiện 2-3 rounds với different keyword combinations
3. **Keyword expansion**: Generate tối thiểu 9 keywords per search (Vietnamese/English/synonyms/alternatives)
4. **Image processing**: When notes contain images, analyze them with Image Reader

### Update Operations

- **Consistency**: Maintain SSoT principles and update cross-references
- **Link maintenance**: Update internal links when content changes
- **Tag optimization**: Refresh tags to match current content

### Delete Operations

- **Link checking**: Verify no broken links remain after deletion
- **Archive consideration**: Move to archive folders rather than permanent deletion when appropriate

## Advanced Search Techniques

### Modern CLI Tools Integration
- **Primary**: `smart-search-fz-rg-bm25` (fallback: `rg`/ripgrep)
- **File discovery**: `fd` - replaces `find` 
- **Directory listing**: `tree` - preferred over `ls`
- **JSON processing**: `jq` - for structured data

### Context-Aware Search
Use regex patterns for complex matching:
```bash
rg --color=auto -E "function [a-zA-Z_]+\(.*\)" # Function definitions
rg --color=auto -E "\[\[.*obsidian.*\]\]" # Obsidian internal links
```

### Git History Search (when applicable)
```bash
git log -G "search_term" -p # Find changes containing search term
```

## Best Practices

### Performance Optimization
- **Pipe termination**: Always end search commands with `| cat` to prevent pager interruption
- **Parallel processing**: When using the ripgrep fallback, leverage `rg` multi-threading capabilities
- **Efficient exclusions**: Use `--exclude-dir` to skip irrelevant directories

### Maintenance Workflows
- **AI folder priority**: Maintain `/home/fong/Projects/dropbox-obsidian/FongObsidian/AI/` as primary location for AI-related content
- **Timestamp naming**: Use YYYY-MM-DD-HH-MM prefix for new files in AI folder
- **Regular cleanup**: Archive outdated notes and maintain folder organization
- **Image cataloging**: Document all images using dual processing (External + Built-in tools) for comprehensive analysis

## Tool Integration

### Dual Image Processing Integration
- **External Tool**: `/home/fong/Projects/MCPs/fong_image_reader-core/run.sh`
- **Built-in Tool**: Claude Code Read tool with multimodal capabilities
- **Supported Formats**: PNG, JPG, JPEG, WebP, GIF, SVG, PDF pages
- **Use Cases**: Screenshots, documentation images, UI analysis, charts, diagrams
- **Processing Strategy**: Always use both tools for comprehensive analysis

### Memory System Integration
- **Context preservation**: Link Obsidian knowledge with project memory systems
- **Cross-reference**: Maintain connections between Obsidian notes and development documentation

---

*Instructions created for AI assistant integration with Obsidian knowledge management workflows*
