# Gemini 2.5 Pro (MCP)

## 📍 Source: Generative AI Reasoning

**Best For**: Complex analysis, multi-step reasoning, planning, structured output.

## 🚀 Usage

**Tool**: `mcp__autochrome-gemini__promptGemini`

### Structured Prompt (Required)
```typescript
mcp__autochrome-gemini__promptGemini({
  role: "Expert Data Scientist",
  context: "Analyzing causal inference methods",
  instructions: "Compare Propensity Score vs RDD",
  output_format: "Table with pros/cons",
  example: "Credit approval domain",
  cautions: "Avoid jargon",
  input: "Which method is best for observational data?"
})
```

## ✅ Best Practices
- **Role**: Define specific expert persona.
- **Context**: Provide background.
- **Output Format**: Be specific (JSON, Table, List).
- **NOT** for factual lookups (Use Perplexity).
