# Juno PM in Langflow — PO Thread / Human-in-the-Loop Agent

Two prototype flows built in Langflow, exploring how the Juno PM concept (already live as a Lovable web app — see the "Juno PM" project changelog) could work as an **agentic, tool-orchestrated flow** rather than a single LLM call from a web UI. Since a real Slack workspace wasn't available, both flows use Langflow's Chat Input/Output as a stand-in for what would eventually be a Slack trigger and Slack reply.

Both versions solve the same problem: take a "P0 thread" (a customer escalation / incident-style conversation), have an AI Associate PM ("Juno PM") triage it against a knowledge base, produce a ranked risk table, and — if a rank-1 (highest severity) risk is found — pause and hand the decision to a human before anything goes out.

---

## Shared architecture

Both flows follow the same backbone:

```
[context source] ─┐
                   ├─▶ Prompt Template ──▶ Agent (system_prompt) ◀── Chat Input (input_value)
[P0 thread]  ──────┘                            │
                                                 ▼
                                          If-Else router
                                     (does output contain "| 1    |"?)
                                    /                              \
                              false_result                   true_result
                                   │                                │
                             Chat Output                     Human Input
                                                          (Rollback / Hold / Escalate…)
                                                                     │
                                                            branch_rollback
                                                                     │
                                                              Chat Output
```

Key mechanics common to both:

- **Agent** node runs `gpt-4o` (tool-calling enabled, calculator + current-date tools attached, `max_iterations: 15`), but its `system_prompt` input is *overridden* by the Prompt Template's rendered output rather than using the node's own default boilerplate text. This is what actually injects the Juno PM persona, the KB context, and the task instructions at runtime.
- **Prompt Template** carries the actual task spec: identify top 3 risks, cite the message index behind each, score severity 1–5, mark `NEEDS PM REVIEW` under 70% confidence, never invent customer names/ARR/contracts, and output a markdown table.
- **If-Else (Conditional Router)** does a simple substring check (`contains "| 1    |"`) against the agent's markdown table output — a cheap way to detect "rank 1 risk found" without a second model call. If found, route to Human Input; otherwise straight to Chat Output.
- **Human Input** pauses the flow (3-day timeout, no fallback configured) and offers a fixed set of decision buttons. Only the **Rollback** branch is actually wired to an output in either flow — Hold/Escalate (and, in v2, Hotfix) exist as selectable decisions on the node but aren't connected downstream yet. That's a known gap, not a bug — it's enough to prove the human-in-the-loop pause/resume mechanic without building out every downstream action.

---

## v1 — "Basic flow, file-based knowledge base"

**File:** `Juno_PM_Agent-v1-PO-Thread-HIL.json`

- Two separate **Read File** components load raw files directly off disk (via Langflow's Docling-backed file loader) — one feeding `context` (the knowledge base document) and one feeding `input_value` (the P0 thread transcript) into the Prompt Template.
- Chat Input is wired straight into the Agent's own `input_value`, so the live chat message is a second channel into the agent alongside the file-derived system prompt.
- No retrieval step: the *entire* contents of both files are dropped into the prompt every run. Fine for proving the flow with small files; doesn't scale with a larger knowledge base and burns context/tokens as the KB grows.

**What this version demonstrates:** getting the core orchestration right — file ingestion, prompt assembly from multiple sources, agent invocation, conditional branching on the agent's own output, and a working human-in-the-loop pause. It's the "does the shape of the flow work at all" version.

---

## v2 — "With embedding knowledge base"

**File:** `Juno_PM_Agent-v2-PO-Thread-HIL-with-Embedding.json`
	
Replaces the brute-force file-stuffing with a real retrieval pipeline, using Langflow's unified **Knowledge** component in both its modes:

- **Ingest path:** Read File → Split Text (`CharacterTextSplitter`, chunk size 500, overlap 50) → Knowledge (mode = *Ingest*, knowledge base `Juno-chunked-small`, column config marks `text` as the vectorized/identifier column, metadata included).
- **Retrieve path:** the Chat Input message is used as the `search_query` straight into a second Knowledge node (mode = *Retrieve*, `top_k: 5`, same `Juno-chunked-small` KB) → Parser (flattens the retrieved rows to plain text via a `{content}` pattern) → Prompt Template.
- The Agent's system prompt was also rewritten to be much closer to the "real" Rocketship PM persona already running in the Juno PM web app: explicit role framing (PM at Rocketship triaging Slack/email/Jira/CSAT feedback), a 5-step reasoning chain (parse → assess signal strength → evaluate impact → flag dependencies → recommend action), a P0–P3 classification rubric with worked examples, an evidence rule (every priority needs a strategy clause *and* a cited source), and a stricter output spec (summary line, confidence, table with a "strategic alignment" column, explicit "confirm action" step).
- Human Input decisions were expanded from `Rollback/Hold/Escalate` to `Rollback/Hotfix/Hold/Escalate`.

**One thing worth flagging as a rough edge:** the Prompt Template in v2 kept the single `{input_value}` placeholder labelled "P0 Thread" from v1, but it's now wired to the *retrieved KB chunks* (via the Parser), not the live thread — the actual live P0 thread only reaches the Agent through the separate Chat Input → Agent `input_value` edge. Functionally it still works (the agent sees both the retrieved context and the live thread, just via two different inputs instead of the cleaner `{context}` / `{input_value}` split v1 used), but it's a naming leftover from reusing the v1 template rather than a deliberate design choice — worth tidying up if this flow gets carried forward.

**What this version demonstrates:** chunking strategy (size/overlap trade-offs), a vector-search-backed retrieval step instead of full-document stuffing, using the same knowledge base in two modes (ingest vs. retrieve) from one component type, and iterating a system prompt from a generic placeholder into a fully specified, evidence-driven persona that mirrors the production Juno PM prompt.

---

## v1 → v2 at a glance

| | v1 | v2 |
|---|---|---|
| Knowledge source | Raw file content, read whole | Chunked, embedded, retrieved by similarity search |
| Context inputs to prompt | 2 separate Read Files → `context` + `input_value` | Retrieved chunks (via Parser) → single `input_value`; live thread goes straight to the Agent |
| Chunking | None | `CharacterTextSplitter`, 500 chars, 50 overlap |
| Retrieval | None (full-text stuffing) | Knowledge component, `top_k = 5` |
| System prompt | Generic Juno PM task instructions | Full Rocketship PM persona: 5-step reasoning chain, P0–P3 rubric w/ examples, evidence requirement, stricter output spec |
| Human decisions | Rollback / Hold / Escalate | Rollback / Hotfix / Hold / Escalate |
| Wired human-in-loop outcomes | Rollback only | Rollback only |
| Model | gpt-4o | gpt-4o |

---

## Learnings this pair of flows demonstrates

- **Agent orchestration basics in Langflow:** wiring multiple sources into a single prompt, overriding an Agent node's system prompt at runtime from an upstream component rather than hardcoding it.
- **Conditional routing on unstructured LLM output:** using a cheap substring match against a markdown table as a routing signal, instead of a second classification call.
- **Human-in-the-loop as a first-class flow primitive:** pausing execution with a timeout and a fixed decision set, and resuming on a specific branch — the core mechanic needed before this could safely sit in front of a real Slack channel.
- **RAG fundamentals:** the concrete difference between "stuff the whole file into the prompt" (v1) and "chunk → embed → retrieve top-k" (v2), including the practical parameters involved (chunk size/overlap, top-k, which column gets vectorized).
- **Prompt iteration:** moving from a generic task prompt to a fully specified persona with an explicit reasoning chain and evidence rules — and doing it in a way that stays consistent with the persona/rules already validated in the production Juno PM web app.

## Known gaps / natural next steps

- Only the Rollback decision branch is wired to an output in either flow — Hold/Escalate/Hotfix are dead ends today.
- Chat Input/Output is a stand-in for Slack; swapping in a real Slack trigger/webhook is the obvious next step once a workspace is available.
- The v2 Prompt Template's `{input_value}` placeholder is mislabeled ("P0 Thread") but actually carries retrieved KB content — worth renaming/cleaning up if this flow is extended.
- No evaluation harness yet (no test set of threads with known "correct" risk rankings to check the router's substring-match trigger or the agent's severity scoring against).
