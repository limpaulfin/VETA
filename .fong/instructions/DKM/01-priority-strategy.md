# Priority Strategy

## 🎯 Priority Order (New Standard)

1. **RagON Service** (API/CURL) 🚀
   - Fastest (<1s), Persistent RAM.
   - Hundreds of books.

2. **RAG Script** (`run.sh`)
   - Fallback if RagON fails.
   - Auto-starts service.

3. **Multiquery Strategy**
   - 3-5 queries for deep understanding.
   - What + How + Why.

4. **Internet Research** (Perplexity/ArXiv)
   - Latest info, academic papers.
   - Use *after* checking internal knowledge.

5. **Project & Personal** (Asana/Notion/Obsidian)
   - Context and notes.

## 📊 Decision Tree

- **Start here** → **RagON (API)**
- **Service down?** → **RAG Script (`run.sh`)**
- **Need deep understanding?** → **Multiquery**
- **Not in books/Need latest?** → **Internet (Perplexity)**
- **Need academic proof?** → **Internet (ArXiv)**
