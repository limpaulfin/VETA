# ArXiv Research

## 📍 Source: Academic Papers

**Best For**: Deep tech, algorithms, security research, AI theory.

## 🚀 Usage

**Tool**: `/home/fong/Projects/arxiv-searcher/arxiv-searcher.sh`
**Downloads**: `/home/fong/Projects/arxiv-searcher/downloads/`

### Workflow
1. **Check Downloads First**:
   ```bash
   tree /home/fong/Projects/arxiv-searcher/downloads/
   ```

2. **Search**:
   ```bash
   /home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "web security AND AI" -n 20
   ```

3. **Download** (Only if needed):
   ```bash
   /home/fong/Projects/arxiv-searcher/arxiv-searcher.sh "web security" -d --download-limit 5
   ```

## ✅ Best Practices
- **ALWAYS** check `downloads/` first.
- Use `Relevance` sort for topics.
- Use `SubmittedDate` sort for latest news.
- Max 100 results per query.
