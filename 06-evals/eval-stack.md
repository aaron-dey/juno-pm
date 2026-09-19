# Eval Stack · Juno

## What "good" means

>=80% not reclassified; regenerate rate <=15%; abandon rate <=20% on non-trivial intents

- Active: insights reclassification (P0-P3,Reject); insights "regenerate" and PRD "edit before send" buttons
- Passive: insights rejection, time-to-first-action, abandon rate (insights not actions/PRD not copied)

## The stack

| Layer        | Evaluator                                                                                                                                   | What it catches                                                                                                                                                                                                                                   | Threshold / gate                                               |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------- |
| Code-based   | Automated checks · cadence: Every PR (CI gate) + nightly cron · owner: CI fails the PR. Eng owns format/citation. PM owns the accuracy bar. | - LLM-judge scores accuracy of top-3 (rubric-aligned) <br>- Format check: valid markdown table with required columns <br>- Citation check: each risk cites a message index that exists - Refusal check: contracts/legal language triggers refusal | >=90% golden-set accuracy; 100% format/citation/refusal pass   |
| LLM-as-judge | Automated assessment on the golden set                                                                                                      | Silent wrong outputs at the long tail                                                                                                                                                                                                             | >=90% golden-set accuracy; 100% format/citation/refusal pass   |
| Human        | 06-evals/human-rubric.md · 2 graders + PM tiebreak per disagreement protocol · cadence: Weekly batch (Friday afternoon)                     | - 50 P0 triage runs / week - Stratified across confidence buckets ( high: >80% / mid: 60-80% / low: <60%) - 100% of hand-off cases included                                                                                                       | >=4.0/5 mean across accuracy + safety; 0 critical safety fails |

## Golden set

- 100 anonymised P0 threads with PM-curated expected top-3 risks
- Versioned in 06-evals/golden-set/
- Refresh quarterly and after every major incident

## Release gate

**Hard gates (auto-block):**

- 0% PII leakage (auto-block)
- 0 critical safety fails on the human-eval layer
- Citation check fail => block

**Soft gates (PM sign-off):**

- P99 latency >5s requires PM justification
- Off-brand tone flags >2% require PM review (not auto-block)

**User-feedback layer (online):** cadence Per request (real-time) + weekly aggregate review; owner PM reviews weekly; on-call PM triages "escalates" >=2 threads.

![[eval-stack-illustration.png]]