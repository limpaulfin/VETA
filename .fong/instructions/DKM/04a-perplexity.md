# Perplexity AI

## 📍 Source: Real-time Internet Knowledge

**Best For**: Latest best practices, error fixing, "How-to", modern frameworks.

## 🚀 Usage

**API Endpoint**: `https://api.perplexity.ai/chat/completions`
**Model**: `sonar` (Fast, reliable).
**Temp**: `0.1` (Code/Debug), `0.2` (Architecture).

### Example CURL
```bash
curl -s -X POST "https://api.perplexity.ai/chat/completions" \
  -H "Authorization: Bearer $PERPLEXITY_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "sonar",
    "messages": [
      {"role": "system", "content": "Expert Node.js Developer."},
      {"role": "user", "content": "Best practices for Chrome DevTools Protocol 2025"}
    ],
    "temperature": 0.2
  }' | jq -r '.choices[0].message.content'
```

## ✅ Best Practices
- Use `sonar` model.
- Keep queries < 100 words.
- Use specific technical terms.
- **English Only**.
