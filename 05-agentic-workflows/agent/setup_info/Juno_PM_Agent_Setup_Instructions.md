# Juno PM Agent — Setup Instructions

Two prototype Langflow flows for the Juno PM agentic-workflow concept: **v1** (basic, file-based KB) and **v2** (embedding-backed KB with retrieval). Both use Langflow's Chat Input/Output as a stand-in for a future Slack trigger/reply. See `Juno-PM-Agent-creation-notes.md` for the full design writeup.

## Prerequisites
- Docker installed
- OpenAI API key ready
- Project folder mounted into the container: `/Users/aarondey/aos/juno-pm/project/05-agentic-workflows/agent`
  - KB source files: `agent/kb/`
  - Flow exports: `agent/Juno_PM_Agent-v1-PO-Thread-HIL.json`, `agent/Juno_PM_Agent-v2-PO-Thread-HIL-with-Embedding.json`

## 1. Start Langflow

```bash
docker run \
  -e OPENAI_API_KEY="sk-proj-YOUR-KEY-HERE" \
  -e LANGFLOW_AUTO_LOGIN=true \
  -v /Users/aarondey/aos/juno-pm/project/05-agentic-workflows/agent:/app/kb \
  -p 7860:7860 \
  --name langflow \
  langflowai/langflow
```

Navigate to `http://localhost:7860`.

Restart the container (stop + re-run with `-v`) any time KB files change — v1 rereads files from disk on each run, so this is enough for v1. v2 additionally needs the ingestion step below whenever KB content changes.

## 2. Import a flow

In the Langflow UI: **File → Import from file**, then pick either:
- `Juno_PM_Agent-v1-PO-Thread-HIL.json` (simple setup)
- `Juno_PM_Agent-v2-PO-Thread-HIL-with-Embedding.json` (embeddings)

Both share the same backbone: `[context source] + [P0 thread] → Prompt Template → Agent (system_prompt override) → If-Else router ("| 1 |" in output?) → Chat Output`, with a `Human Input` step (3-day timeout) inserted on the router's true branch when a rank-1 risk is found. Only the **Rollback** decision is wired to an output in either version — Hold/Escalate (and, in v2, Hotfix) are selectable but not yet connected downstream. That's a known gap, not a bug.

---

## v1 — Basic flow (file-based KB)

**File:** `Juno_PM_Agent-v1-PO-Thread-HIL.json`

No ingestion step needed — this version reads KB files straight off disk on every run.

| Node | Type | Config |
|---|---|---|
| Read File (context) | Read File (Docling-backed) | Loads the KB doc(s) from `agent/kb/` → feeds `context` |
| Read File (thread) | Read File | Loads the P0 thread transcript → feeds `input_value` |
| Chat Input | ChatInput | Live chat message, wired straight into the Agent's own `input_value` (a second, parallel input channel) |
| Prompt Template | Prompt Template | Task spec: identify top 3 risks, cite message index, score severity 1–5, mark `NEEDS PM REVIEW` under 70% confidence, never invent customer names/ARR/contracts, output a markdown table |
| Agent | Agent (gpt-4o, tool-calling, calculator + current-date tools, `max_iterations: 15`) | `system_prompt` overridden by the Prompt Template's rendered output |
| If-Else Router | Conditional Router | Substring check on the agent's markdown output for `"| 1    |"` (rank-1 risk found) |
| Human Input | Human Input | Decisions: Rollback / Hold / Escalate — only Rollback is wired downstream |
| Chat Output | Chat Output | Final output (false branch straight from Agent, true branch via Human Input → Rollback) |

**Trade-off:** entire file contents are stuffed into the prompt every run — fine for small KB files, doesn't scale and burns tokens as the KB grows. Use this version to sanity-check the flow shape (ingestion, prompt assembly, conditional routing, human-in-the-loop pause/resume) before moving to v2.

**Test:** click **Playground**, paste a P0 thread with numbered message indices, confirm the agent returns a ranked risk table with citations and confidence scores, and that a rank-1 risk correctly triggers the Human Input pause.

---

## v2 — Embedding-backed flow (needs an ingestion step)

**File:** `Juno_PM_Agent-v2-PO-Thread-HIL-with-Embedding.json`

This version replaces file-stuffing with real retrieval via Langflow's unified **Knowledge** component, used in two modes. **The KB must be ingested once before retrieval will return anything** — do this before your first test run, and again any time KB source files change.

### 2a. Ingest the KB (run once, and after any KB edits)

```
Read File → Split Text (CharacterTextSplitter, chunk size 500, overlap 50) → Knowledge (mode = Ingest, KB name: "Juno-chunked-small", vectorized/identifier column: text, metadata included)
```

Run this ingest path in the Langflow UI (e.g. via its own Run button on the Knowledge node, or by running the whole flow once) so the `Juno-chunked-small` knowledge base is populated before you test retrieval. Skipping this step means the Retrieve path below returns nothing.

### 2b. Retrieve + generate

| Node | Type | Config |
|---|---|---|
| Chat Input | ChatInput | Message used directly as the `search_query` into the Retrieve node, *and* wired straight to the Agent's `input_value` (the live P0 thread) |
| Knowledge (Retrieve) | Knowledge, mode = Retrieve | Same KB `Juno-chunked-small`, `top_k: 5` |
| Parser | Parser | Flattens retrieved rows to plain text via a `{content}` pattern |
| Prompt Template | Prompt Template | Receives the parsed KB chunks as `{input_value}` — note: still labelled "P0 Thread" from v1, but it's now the retrieved KB context, not the live thread (see rough-edge note below) |
| Agent | Agent (gpt-4o, tool-calling, calculator + current-date tools, `max_iterations: 15`) | `system_prompt` overridden by the Prompt Template output. Rewritten to the full Rocketship PM persona: role framing (PM triaging Slack/email/Jira/CSAT), a 5-step reasoning chain (parse → assess signal strength → evaluate impact → flag dependencies → recommend action), a P0–P3 classification rubric with worked examples, an evidence rule (every priority needs a strategy clause *and* a cited source), and a stricter output spec (summary line, confidence, table with a "strategic alignment" column, explicit "confirm action" step) |
| If-Else Router | Conditional Router | Same substring check on `"| 1    |"` |
| Human Input | Human Input | Decisions expanded to Rollback / Hotfix / Hold / Escalate — only Rollback is wired downstream |
| Chat Output | Chat Output | Final output |

**Known rough edge:** the Prompt Template's single `{input_value}` placeholder kept its v1 label ("P0 Thread") but is now wired to the *retrieved KB chunks* via the Parser — the live P0 thread reaches the Agent only through the separate Chat Input → Agent `input_value` edge. It still works functionally (the agent sees both), but the naming is a leftover from reusing the v1 template. Worth renaming/cleaning up if this flow is carried forward.

**Test:** run the ingestion step first, then click **Playground**, paste a P0 thread, and confirm the agent's table now cites retrieved KB context (not the whole file) plus a strategic-alignment column, and that a rank-1 risk triggers Human Input with all four decision options visible.

---

## v1 → v2 at a glance

| | v1 | v2 |
|---|---|---|
| Knowledge source | Raw file content, read whole | Chunked, embedded, retrieved by similarity search |
| Setup step | None beyond mounting the KB folder | **One-time (and post-edit) ingestion run required** |
| Chunking | None | CharacterTextSplitter, 500 chars, 50 overlap |
| Retrieval | None (full-text stuffing) | Knowledge component, top_k = 5 |
| System prompt | Generic Juno PM task instructions | Full Rocketship PM persona: 5-step reasoning chain, P0–P3 rubric, evidence requirement |
| Human decisions | Rollback / Hold / Escalate | Rollback / Hotfix / Hold / Escalate |
| Wired human-in-loop outcomes | Rollback only | Rollback only |
| Model | gpt-4o, temp 0.2 | gpt-4o, temp 0.2 |

---

## Key Points

- Langflow must be restarted with the `-v` flag to access the KB folder.
- v1 needs no separate ingestion — it rereads files from disk each run.
- v2 needs the KB **ingested into `Juno-chunked-small` before first use**, and re-ingested after any KB file changes — retrieval otherwise returns empty results.
- Both flows use gpt-4o at low temperature (0.2) for deterministic risk scoring.
- Only the Rollback decision branch is wired to an output in either flow; Hold/Escalate/Hotfix are dead ends today.
- Chat Input/Output stands in for a future Slack trigger/webhook.
- No evaluation harness yet — no test set of threads with known "correct" rankings to check the router's substring trigger or the agent's severity scoring against.
