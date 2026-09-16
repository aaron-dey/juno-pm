# Juno PM Agent — Setup Instructions

## Prerequisites
- Docker installed
- OpenAI API key ready
- Local KB folder: `/Users/aarondey/aos/juno-pm/project/05-agentic-workflows/kb`

## 1. Start Langflow with mounted KB

```bash
docker run \
  -e OPENAI_API_KEY="sk-proj-YOUR-KEY-HERE" \
  -e LANGFLOW_AUTO_LOGIN=true \
  -v /Users/aarondey/aos/juno-pm/project/05-agentic-workflows:/app/kb \
  -p 7860:7860 \
  --name langflow \
  langflowai/langflow
```

Navigate to `http://localhost:7860`

## 2. Build the Flow

Create nodes in this order:

| Node | Type | Config |
|------|------|--------|
| Input | ChatInput | Label: "P0 Thread" |
| System Prompt | Prompt Template | Template: "You are Juno PM, an AI Associate PM. For the attached P0 thread: 1. Identify top 3 risks. 2. Cite message index. 3. Score 1-5 severity. 4. Never invent customer names/ARR. 5. Output markdown table: Rank \| Risk \| Confidence \| Source idx \| Suggested action.\n\nThread:\n{input_value}" |
| KB | Document Loader | Path: `/app/kb`, Type: Markdown |
| Retriever | Retriever | Connect to Document Loader, top-k: 10 |
| LLM | OpenAI | Model: gpt-4o, Temp: 0.2, Max tokens: 800 |
| Agent | Agent | Language Model: OpenAI, Instructions: "You are Juno PM..." |
| Output | Chat Output | - |

## 3. Wire Connections

```
ChatInput → Agent (Input)
Prompt Template → Agent (Instructions)
Retriever → Agent (Context/Tools)
Agent → Chat Output
```

## 4. Test

- Click **Playground**
- Paste a P0 thread with numbered message indices
- Agent returns top 3 risks with confidence scores and source citations

## 5. Optional: Add RAG Context

Update Prompt Template to include `{context}`:

```
You are Juno PM. Project Context:
{context}

P0 Thread:
{input_value}

Identify top 3 risks...
For each risk, cite the message index that supports it.
Score each risk 1-5 for severity. If confidence < 70%, mark NEEDS PM REVIEW.
Never invent customer names, ARR, or contracts.
Output a markdown table: Rank | Risk | Confidence | Source idx | Suggested action.

Thread:
{input_value}
```

The Retriever will automatically pull relevant KB files for context.

---

## Key Points

- Langflow must be restarted with `-v` flag to access KB
- All `.md` files in `/app/kb` are available to Retriever
- Agent uses gpt-4o with low temperature (0.2) for deterministic risk scoring
- Each request automatically includes KB context if Retriever is wired
