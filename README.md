# Juno PM

> Deliver outstanding outcomes by turning raw information into actionable insights, and taking nuanced product decisions, aligned to your team and customer needs.

Aaron Dey · #ai-product-management-aug25-26-weekdays · Aug-Sep 2026

This repo is my final project for the **AI Product Management Certification**. 
Each module's artefact lives in its own folder; this README is the dashboard and the pitch.

***Final Project Deliverables***

---

## Module artefacts

### M1 · Prompting
- **System prompt** — [`01-prompting/system-prompt.md`](01-prompting/system-prompt.md)
- **Lovable prototype** app —  https://disboard.lovable.app 
	- [Changelog: `01-prompting/lovable-prototype-changelog.md`](https://github.com/aaron-dey/juno-pm/blob/main/01-prompting/lovable-prototype-changelog.md)  

### M2 · Strategy
- **Decision matrix** — [`02-strategy/decision-matrix.md`](02-strategy/decision-matrix.md)
- **AI Strategy one-pager** — [`02-strategy/strategy-one-pager.md`](02-strategy/strategy-one-pager.md)

### M3 · RAG / AI PRD
- **AI PRD** — [`03-rag-prd/prd.md`](03-rag-prd/prd.md)

### M4 · AI-Native UX
- **AI user flow** — [`04-ai-ux/user-flow.md`](04-ai-ux/user-flow.md)
- **Trust-gap mitigations** — [`04-ai-ux/trust-gaps.md`](04-ai-ux/trust-gaps.md)

### M5 · Agentic Workflows
- **Agent Workflow Spec (AWSpec)** — [`05-agentic-workflows/awspec.md`](05-agentic-workflows/awspec.md)
- **Agent Control Panel** — [`05-agentic-workflows/agent-control-panel.md`](05-agentic-workflows/agent-control-panel.md)
- **Agents —**  [`05-agentic-workflows/agent`](https://github.com/aaron-dey/juno-pm/tree/main/05-agentic-workflows/agent)
### M6 · Evals & Guardrails
- **Eval stack** — [`06-evals/eval-stack.md`](06-evals/eval-stack.md)
- **Human evaluation rubric** — [`06-evals/human-rubric.md`](06-evals/human-rubric.md)
- **Evals** —  [APP: `06-evals/evals-app`](https://github.com/aaron-dey/juno-pm/tree/main/06-evals/evals-app) | [AGENT: `06-evals/evals-agent`](https://github.com/aaron-dey/juno-pm/tree/main/06-evals/evals-agent)

---

## PM Execution Plan

### Where Juno is today
- Strategy, PRD, Prototype, Agent, Prompts,  Evals created (draft, synthetic)
- App prototype published with product analytics enabled
- Agent preview chat created (hooks to Slack pending)
- Evals for prototype and agent drafted, golden sets created with focus on UXD functionality for app prototype and synthesis quality
- Human rubric drafted and calibration pending

### What ships next (next 2 sprints)
- Sprint 1: 
-- Review/refine the Eval golden set with (recruited) reviewers
-- Add additional PII scrubbing (focus on transcript processing to include anonymised IDs)
-- Add fallback exists if the Lovable AI Gateway/Gemini goes down (degraded-mode banner)
-- Implement final blocking governance requirements 
-- Wire up live production environments 

- Sprint 2: 
-- Open closed beta with 6 PMs (2 RocketShip, 4 customers) for Transcript processing functionality 
-- Weekly rubric review
-- instrument abandon-rate.

### What I watch (dashboards)
- Daily: priority re-classification rate, regeneration rate, edit rate.
- Weekly: rejection hit-rate; cost per run.
- Per release: golden-set accuracy

### Red lines (what blocks shipping)
-  Critical-safety fail: 0
- Cost: >$0.50 per run.
- P99 latency: >10s on triage flow.

### Governance
- Compliance: 
-- PII minimised at input (GDPR DSR support process/tooling needed within 30-days)
-- EU AI Act compliance risk review (documented)
-- Review and document provider compliance (Lovable, Gemini, Langflow, OpenAI) and EU data-residency

- Safety
-- No autonomy upgrade for Agent without re-review.
-- Human in the Loop action cannot be bypassed silently 

- Reliability
- P99 latency reviewed weekly (post-mortem and action plan within 5 business days if repeated breach for 2 consecutive weeks)
-- Product analytics metrics (reclassification rate, regenerate rate, abandon rate) reviewed weekly (Amplitude)

- Reputation
-- Customer-facing communication about deprioritisation stays 100% human
-- Missed-P0 incident postmortem and action plan (within 5 business days)

---

## Build Insights

- **Friction point.** Iterating/tuning parameters for the vector database ingest and retrieval, system and individual prompts (chunking, Top-K, history) was early friction triggering iterations that balanced accuracy, latency and cost
- **Key learning.** Building user trust requires this to be designed into the (system) prompt and UXD right from the start, to be iterated/improved based on product analytics and qualitative reviews
- **Aha moment.** Closing the control gap by enabling granular human steering and HIL chat prompts was a step change to improve quality of outputs and user trust that only approved actions moved forward

---

## Async showcase

3-minute walkthrough: PENDING

---

## Repo structure

```
├── README.md                                ← dashboard + pitch
│
│
├── 01-prompting/
│   ├── system-prompt.md                     ← M1: Juno's system prompt
│   ├── lovable-prototype.md                 ← M1: prototype link + debrief
│   ├── lovable-prototype-changelog.md       ← M1: prototype changelog
│
│
├── 02-strategy/
│   ├── decision-matrix.md                   ← M2: build / buy / fine-tune call
│   ├── strategy-one-pager.md                ← M2: AI strategy one-pager
│
│
├── 03-rag-prd/
│   ├── prd.md                               ← M3: AI PRD with retrieval reqs
│
│
├── 04-ai-ux/
│   ├── user-flow.md                         ← M4: AI-native user flow
│   └── trust-gaps.md                        ← M4: trust-gap mitigations audit
│
│
├── 05-agentic-workflows/
│   ├── awspec.md                            ← M5: Agent Workflow Spec
│   ├── agent-control-panel.md               ← M5: Agent Control Panel
│   └── agent/
│       ├── Juno-PM-Agent-creation-notes.md  ← M5: Juno agents (Langflow)
│       ├── kb/                              ← M5: Juno agents kb
│       │   ├── agent-context.md
│       │   ├── agent-system-prompt.md
│       │   └── strategy-one-pager.md
│       ├── screenshots/                     ← M5: Agents flow (images/PDFs)
│       └── setup_info/                      ← M5: Setup (guide from scratch)
│           ├── Juno_PM_Agent_Setup_Instructions.md
│           ├── LANGFLOW_SETUP.md
│           ├── PROMPTS_GUIDE.md
│           └── QUICK_START.md
│
│
└── 06-evals/
    ├── eval-stack.md                        ← M6: layered eval stack
    ├── human-rubric.md                      ← M6: human evaluation rubric
    ├── evals-agent/                         ← M6: Agent evals  
    │   ├── juno-pm-agent-golden-set.md      
    │   ├── golden-set-agent.json            ← M6: Companion dataset (cases) 
    │   └── kb-fixtures/
    │       ├── classification-overrides.md
    │       ├── conflicting-addendum.md
    │       ├── pricing.md
    │       └── roadmap.md
    └── evals-app/                          ← M6: App evals (functionality)
        ├── juno-pm-app-golden-set.md       
        └── golden-set-app.json             ← M6: Companion dataset 
```

---

_Certification submission — AI Product Management Certification._
