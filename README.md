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
	- Changelog: [[lovable-prototype-changelog]]

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

### M6 · Evals & Guardrails
- **Eval stack** — [`06-evals/eval-stack.md`](06-evals/eval-stack.md)
- **Human evaluation rubric** — [`06-evals/human-rubric.md`](06-evals/human-rubric.md)

---

## PM Execution Plan

### Where Juno is today
_____

### What ships next (next 2 sprints)
_____

### What I watch (dashboards)
_____

### Red lines (what blocks shipping — numbers, not feelings)
_____

### Governance
_Compliance · Safety · Reliability · Reputation._

---

## Build Insights

- **Friction point.** _____
- **Key learning.** _____
- **Aha moment.** _____

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
