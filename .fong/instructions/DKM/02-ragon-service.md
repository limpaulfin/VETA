# RagON Service (Priority #1)

## 🚀 Usage Flow

### 1. API/CURL (Primary)
**Goal**: Query persistent service (<1s).

```bash
# Default Query (Implicit Path)
# Uses default DKM-PDFs path loaded at startup
curl -s -X POST http://localhost:2011/query \
  -H "Content-Type: application/json" \
  -d '{
    "question": "SOLID principles",
    "top_k": 4
  }' | jq

# Custom Path Query
curl -s -X POST http://localhost:2011/query \
  -H "Content-Type: application/json" \
  -d '{
    "pdf_directory": "/home/fong/Projects/mini-rag/DKM-PDFs",
    "question": "SOLID principles",
    "top_k": 4
  }' | jq

# Check Cache Stats
curl http://localhost:2011/cache/stats
```

### 2. `run.sh` (Secondary/Fallback)
**Goal**: Auto-start service if down.

```bash
cd /home/fong/Projects/mini-rag
./run.sh "SOLID principles" /home/fong/Projects/mini-rag/DKM-PDFs
```

### 3. Start Script (Manual)
**Goal**: Force start service.

```bash
/home/fong/Projects/mini-rag/RagON/Start-RAG-persistent-service.sh
```

## ✅ Best Practices
- **ALWAYS** try API first.
- **Default Path**: Service auto-loads DKM-PDFs.
- Use **Absolute Paths** for custom directories.
