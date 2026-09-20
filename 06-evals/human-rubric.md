# Human Evaluation Rubric · Juno P0 Triage Copilot

## What graders score

- **Task / product:** Juno P0 Triage Copilot
- **Reviewer audience:** 2 Senior PM + 1 SRE + 1 Support Lead + 1 CSM/ACM (Customer success/Account management)
- **Value proposition:** Synthesise P0 threads, into top 3 risk categories, so that the on-call PM (or designate) can decide within 10 minutes to Rollback / Hotfix / Hold / Escalate.

Note: Escalate here could be needed to a commercial owner / C-level or designate for sensitive issues in a larger/deeper org structure.
## Dimensions

| Dimension             | 1 (fail)                                                                        | 3 (ok)                                                                                    | 5 (excellent)                                                                                                                                                                      |
| --------------------- | ------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| App start performance | Critical - app does not load at all                                             | Acceptable - app loads within 20s                                                         | Excellent - app loads in less than 5s and displays system health                                                                                                                   |
| Accuracy              | Critical - synthesis does not identify an obvious P0 issue or invents something | Acceptable - synthesis shows a representative spread across P0-P3 aligned to the strategy | Strong - synthesis checks and shows that strategy defined levels are matched and references the specific strategy section and surfaces evidence (user quote, incident, escalation) |
| Actionability         | No recommendation; PM has to analyse and decide what to do                      | Concrete actions identified but without owner                                             | Concrete actions, next step with potential commercial impacts/mitigations identified                                                                                               |

**_Full anchors:_**
### 1. App start

- **Score 1:** Critical - app does not load at all
- **Score 2:** Sub-par - app takes 30s or more to load
- **Score 3:** Acceptable - app loads within 20s
- **Score 4:** Strong - app loads within 10s
- **Score 5:** Excellent - app loads in less than 5s and displays system health 

### 2. Prioritisation 

- **Score 1:** Critical - synthesis does not identify any issue
- **Score 2:** Sub-par - synthesis  assigns P0 to all issues identified
- **Score 3:** Acceptable - synthesis shows a spread across P0-P3 aligned to the strategy (if given)
- **Score 4:** Strong - synthesis checks and shows that strategy defined levels are matched and references the specific strategy section 
- **Score 5:** Strong - synthesis checks and shows that strategy defined levels are matched and references the specific strategy section and surfaces a user quote

Note: Consider how sample Bias may affect this (e.g. a representative mix of customer types/sizes needed)

### 3. Actionability 
- **Score 1:** No recommendation; PM has to analyse and decide what to do 
- **Score 2:** Unclear, vague, neither-nor recommendations
- **Score 3:** Concrete actions identified but without owner 
- **Score 4:** Concrete actions, next step with owner suggested 
- **Score 5:** Concrete actions, next step with potential commercial impacts/mitigations identified  

## Calibration

- **Sampling rule:** 50 P0 runs/week, stratified by confidence (high/medium/low). 100% of hand-off cases included.
- **Cadence:** Weekly batch (Friday afternoon)
- **Graders per item:** 2 graders + PM tiebreak per item
- **Calibration cadence:** Re-calibrate quarterly + on rubric drift signal (disagreement >=15%)

If two graders differ by >=2 on any dimension, item is escalated to PM. 
PM resolves with rationale (incl. considerations from CSM/ACM). 
Disagreement rate >=15% on any dimension triggers a re-calibration session.

## Pass bar

>=4.0/5 mean on accuracy + safety; 0 critical safety fails (any "1" on safety)
