# Juno PM Agent — Langflow Setup (Complete)

## Prerequisites
- Docker installed
- OpenAI API key ready
- KB path: `/Users/aarondey/aos/juno-pm/project/05-agentic-workflows/agent/kb`

---

## 1. Start Langflow with mounted KB

Run this command in your terminal (replace `YOUR-KEY-HERE` with your actual OpenAI API key):

```bash
docker run \
  -e OPENAI_API_KEY="sk-proj-YOUR-KEY-HERE" \
  -e LANGFLOW_AUTO_LOGIN=true \
  -v /Users/aarondey/aos/juno-pm/project/05-agentic-workflows/agent:/app/kb \
  -p 7860:7860 \
  --name langflow \
  langflowai/langflow
```

Navigate to `http://localhost:7860`

---

## 2. Import the Starter Template

The starter template is available as a JSON export in your project folder:  
`/Users/aarondey/aos/juno-pm/project/05-agentic-workflows/Juno Agent - starter template.json`

In Langflow UI:
1. Click **File** → **Import from file**
2. Select the starter template JSON
3. This imports pre-configured nodes (see details below)

---

## 3. Template Nodes Overview

Your starter template includes these pre-configured nodes:

| Node | Type | Purpose |
|------|------|---------|
| **P0 Input** | ChatInput | User pastes P0 thread with numbered message indices |
| **System Prompt** | Prompt Template | Juno PM instructions for risk analysis |
| **KB Retriever** | Retriever | Pulls context from KB markdown files |
| **LLM** | OpenAI (gpt-4o) | Low-temp (0.2) for deterministic scoring |
| **Agent** | Agent | Orchestrates input → retrieval → LLM → output |
| **Output** | Chat Output | Returns risks with confidence & citations |

---

## 4. Key Configuration Details

### System Prompt Template
```
You are Juno PM, an AI Associate PM specializing in risk identification.

**Project Context:**
{context}

**P0 Thread Analysis:**
{input_value}

**Your task:**
1. Identify the top 3 risks from the thread
2. Cite the source message index for each risk
3. Score severity on a 1-5 scale
4. Never invent customer names, ARR figures, or project details
5. Return a markdown table:

| Rank | Risk | Confidence | Source Idx | Suggested Action |
|------|------|-----------|-----------|-----------------|
| 1 | [risk] | [%] | [idx] | [action] |
| 2 | ... | ... | ... | ... |
| 3 | ... | ... | ... | ... |
```

### LLM Configuration
- **Model:** gpt-4o
- **Temperature:** 0.2 (deterministic, consistent scoring)
- **Max tokens:** 800
- **Top-p:** 0.95

### Retriever Configuration
- **Document Loader Path:** `/app/kb`
- **File Type:** Markdown (*.md)
- **Top-k:** 10 (retrieves top 10 relevant chunks)
- **Search Type:** Similarity (vector or keyword)

---

## 5. Wire Connections (if manually building)

```
ChatInput → Agent (receives input)
Prompt Template → Agent (instructions)
Retriever → Agent (context/tools)
LLM → Agent (reasoning engine)
Agent → Chat Output (sends result)
```

---

## 6. KB Content

Your KB folder currently contains:
- `strategy-one-pager.md` — Juno's product strategy and goals

**To add more KB files:**
- Place any `.md` files in `/Users/aarondey/aos/juno-pm/project/05-agentic-workflows/agent/kb/`
- Restart Langflow (Docker container) to pick up new files
- Retriever will automatically index and surface relevant chunks

---

## 7. Test the Agent

1. Click **Playground** in Langflow UI
2. Paste a sample P0 thread (example below)
3. Agent returns markdown table with top 3 risks

### Sample P0 Thread Input:
```
[0] @pm: We have a critical issue with the video encoder.
[1] Support reports 15% of streams are failing on mobile.
[2] Customer X (ARR $500k) is threatening to churn.
[3] Engineering says they need 2 weeks to fix, but customer escalated to C-suite.
[4] Marketing promised this feature for next week's launch event.
[5] Team is burned out from context-switching.
```

### Expected Output:
| Rank | Risk | Confidence | Source Idx | Suggested Action |
|------|------|-----------|-----------|-----------------|
| 1 | Customer churn risk due to encoder failures | 95% | [1],[2],[3] | Prioritize mobile encoder fix; customer success outreach |
| 2 | Launch timeline conflict | 85% | [4],[5] | Reset launch expectations with Marketing; align on realistic date |
| 3 | Team burnout impacting execution | 80% | [5] | Refactor backlog to reduce context-switching; protect focus time |

---

## 8. Debugging Tips

**Agent not retrieving KB context?**
- Verify KB files are in `/app/kb` (inside container)
- Restart Docker container: `docker restart langflow`
- Check Retriever is wired to Agent

**LLM not returning structured output?**
- Check gpt-4o is selected in LLM node
- Verify temperature is 0.2 (not too high for consistency)
- Ensure prompt template includes the table format instruction

**Docker port conflicts?**
- If port 7860 is in use, change to another (e.g., `-p 7861:7860`)
- Update browser URL accordingly

---

## 9. Next Steps

1. **Populate KB:** Add more strategy docs, past P0 examples, customer context
2. **Fine-tune System Prompt:** Adjust risk categories based on your priorities
3. **Export & Deploy:** Once tested, export the flow and deploy as a standalone API or webhook
4. **Metrics:** Track which risks the agent catches vs. misses to refine scoring

---

## Quick Reference

| Component | Value |
|-----------|-------|
| Langflow UI | http://localhost:7860 |
| Docker image | langflowai/langflow |
| LLM model | gpt-4o |
| Temperature | 0.2 |
| KB location (host) | /Users/aarondey/aos/juno-pm/project/05-agentic-workflows/agent/kb |
| KB location (container) | /app/kb |
| Starter template | Juno Agent - starter template.json |
