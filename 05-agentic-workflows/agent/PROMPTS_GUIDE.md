# Juno PM Agent — Prompt Templates & Tuning

This guide covers system prompts, few-shot examples, and tuning strategies for the Langflow agent.

---

## Core System Prompt (Recommended)

Use this in the **Prompt Template** node:

```
You are Juno PM, an AI Associate PM specializing in risk identification in software products and organizations.

**Project Context:**
{context}

**P0 Thread:**
{input_value}

**Analysis Instructions:**
1. Extract the top 3 risks from the thread, ranked by severity
2. For each risk, cite the source message index(es)
3. Score severity on a 1-5 scale (5=critical, 1=minor)
4. Assign confidence (% likelihood this is a real risk, not false positive)
5. Suggest a concrete action for mitigation

**Critical Rules:**
- Never invent facts (customer names, ARR, timeline estimates)
- Only cite what's explicitly in the thread
- If insufficient data, flag as "confidence < 70%"
- Focus on business impact, execution blockers, and customer/team health
- Ignore routine operational updates

**Output Format:**
Return a markdown table:

| Rank | Risk | Severity (1-5) | Confidence | Source Idx | Suggested Action |
|------|------|--------|------------|-----------|-----------------|
| 1 | [risk title] | [#] | [%] | [idx] | [action] |
| 2 | ... | ... | ... | ... | ... |
| 3 | ... | ... | ... | ... | ... |

**Additional Notes:**
[If applicable, add context on follow-up items, escalations, or dependencies]
```

---

## Risk Category Framework

Adapt the system prompt to emphasize specific risk categories:

### 1. Execution Risks
- Timeline slippage
- Resource constraints
- Technical debt
- Dependency blockers

**Prompt addition:**
```
Focus on: execution blockers, timeline risks, resource conflicts.
Examples: "2-week fix vs. 1-week launch deadline", "team context-switching"
```

### 2. Customer Risks
- Churn signals
- SLA violations
- Feature commitments at risk
- Escalations to C-level

**Prompt addition:**
```
Focus on: customer satisfaction, retention, revenue impact.
Examples: "ARR $500k customer threatening churn", "support tickets spiking"
```

### 3. Product Risks
- Quality/reliability issues
- Scope creep
- Feature parity gaps
- Competitive threats

**Prompt addition:**
```
Focus on: product quality, competitive positioning, user experience.
Examples: "15% mobile failure rate", "competitor launched similar feature"
```

### 4. Team/Org Risks
- Burnout
- Knowledge silos
- Hiring/retention issues
- Misalignment

**Prompt addition:**
```
Focus on: team health, capacity, morale, alignment.
Examples: "team burned out from context-switching", "PM left unexpectedly"
```

---

## Few-Shot Examples (Add to Prompt)

Insert concrete examples to ground the model:

```
**Examples:**

Example 1 (High Severity):
Thread:
[0] @eng: Database migration failed in prod, 5% of users can't load profiles
[1] Customer support getting flooded (50+ tickets/hour)
[2] CEO asked for status update in 30 min

Expected Output:
| Rank | Risk | Severity | Confidence | Source | Action |
|------|------|----------|-----------|--------|--------|
| 1 | Prod outage affecting 5% of users | 5 | 98% | [0],[1] | Immediate: rollback or hotfix; comms to customers |
| 2 | C-level escalation requiring urgent comms | 5 | 95% | [2] | Brief CEO with ETA; set expectations |
| 3 | Support team overwhelmed | 4 | 90% | [1] | Allocate resources to support; auto-responses |

Example 2 (Medium Severity):
Thread:
[0] Design review showed nav is confusing for new users
[1] Usability testing scores are 2 points below competitor
[2] Feature is launching next week

Expected Output:
| Rank | Risk | Severity | Confidence | Source | Action |
|------|------|----------|-----------|--------|--------|
| 1 | UX confusion impacting user adoption | 3 | 85% | [0],[1] | Conduct quick usability fix; test before launch |
| 2 | Launch timeline at risk if changes needed | 3 | 75% | [2] | Scope: what's must-fix vs. post-launch |
| 3 | Competitive disadvantage if not fixed | 2 | 60% | [1] | Monitor competitor adoption; assess impact |

Example 3 (Low Severity / Not a Risk):
Thread:
[0] Q4 roadmap planning meeting scheduled
[1] Team had great sprint retrospective
[2] New team member onboarded successfully

Expected Output:
| Rank | Risk | Severity | Confidence | Source | Action |
|------|------|----------|-----------|--------|--------|
| — | No material risks detected | — | — | — | Continue current trajectory |

Additional Notes: Positive team signals. Monitor Q4 planning for resource conflicts.
```

---

## Temperature & Model Tuning

### Temperature Settings
- **0.1-0.2:** Deterministic, consistent risk scoring (recommended)
- **0.3-0.5:** Slightly more creative, still focused
- **0.6+:** Higher variance, may miss systematic risks

For Juno PM, use **0.2** to ensure consistent, repeatable risk identification.

### Model Selection
- **gpt-4o:** Recommended for reasoning, consistency
- **gpt-4-turbo:** Faster, slightly lower quality
- **gpt-3.5-turbo:** Cheaper, may miss nuanced risks

### Max Tokens
- **800:** Default (good for top 3 risks + action items)
- **1200:** If you want more detail per risk or longer action plans
- **400:** If you want just risk titles (fast + cheap)

---

## Advanced Prompt Variants

### Variant A: Risk Probability Scoring
```
For each risk, also estimate:
- **Prior probability:** How common is this type of risk in similar projects?
- **Posterior probability:** Given evidence in thread, likelihood this risk manifests?

Output: Add a "Risk Probability" column with (prior) → (posterior).
```

### Variant B: Stakeholder Impact
```
For each risk, specify:
- Who is affected? (Engineering, Product, Sales, Customers, etc.)
- Financial impact? (if quantifiable: ARR at risk, cost of fix, etc.)
- Timeline impact? (delay by X days if not addressed)

Output: Add columns "Stakeholders", "Financial Impact", "Timeline Impact".
```

### Variant C: Historical Context
```
Reference KB context to classify risks:
- New/emerging (not seen in past P0s)
- Recurring (pattern from previous issues)
- Escalating (severity increasing over time)

Output: Add column "Risk Type (New/Recurring/Escalating)".
```

### Variant D: Action Priority Matrix
```
Structure suggested actions by urgency vs. importance:
- P0 (Do today): Immediate action required
- P1 (Do this week): Important, time-sensitive
- P2 (Backlog): Important but not urgent
- P3 (Monitor): Watch for escalation

Output: Prefix each action with priority level.
```

---

## Retriever Tuning

### KB Relevance
The Retriever pulls context from KB markdown files. To improve:

1. **Add more domain knowledge:** Add docs on:
   - Past P0 examples (anonymized)
   - Organizational priorities & constraints
   - Customer account details
   - Competitive landscape

2. **Structure KB files:** Use clear headers & sections:
   ```markdown
   # Strategy
   ## Product Roadmap
   ## Customer Health
   ## Team Capacity
   ```

3. **Update KB frequently:** Stale KB = stale context
   - Refresh strategy quarterly
   - Update customer health monthly
   - Log past P0 outcomes to learn patterns

### Retriever Parameters
- **top-k:** How many chunks to retrieve
  - 5: Fast, narrow focus (use if KB is small)
  - 10: Balanced (recommended)
  - 20+: Thorough, risk of noise (use if KB is large)
  
- **Search type:** How to find relevant chunks
  - Similarity (vector search): Better semantic matching
  - Keyword (BM25): Better exact term matching
  - Hybrid: Best of both

---

## Prompt Testing Checklist

Before deploying, test with these scenarios:

- [ ] **Genuine P0:** Known high-severity issue → Correctly ranked at Severity 5
- [ ] **False positive:** Routine update (e.g., "meeting scheduled") → Marked as no risk
- [ ] **Subtle risk:** Implication vs. explicit statement → Correctly inferred
- [ ] **Missing context:** Unknown customer/term in thread → Flagged as "insufficient data"
- [ ] **Multiple risks:** Complex thread with 5+ issues → Correctly prioritized top 3
- [ ] **Conflicting signals:** "Everything's fine" vs. explicit problem → Risk identified
- [ ] **Jargon-heavy:** Internal acronyms/terminology → Correctly interpreted via KB

---

## Examples for KB Integration

Sample P0 thread + expected output for Juno's KB:

### Example: Mobile Encoder Failure (from your notes)
**Thread:**
```
[0] @eng: Mobile encoder hit memory limit on iPhone 12
[1] Tests passing on Android, but iOS 15 users seeing crashes
[2] Customer X (Acme Inc, $800k ARR) reported in support ticket
[3] Engineering estimates 2 days to fix with low-confidence (could be 5+)
[4] Marketing promised "premium quality" for launch next Monday
[5] Team already context-switching on 3 other P1s
```

**Expected Risk Output:**
```
| Rank | Risk | Severity | Confidence | Source | Action |
|------|------|----------|-----------|--------|--------|
| 1 | iOS encoder crashes blocking $800k customer | 5 | 98% | [0],[1],[2] | P0: Immediate hotfix scoping; customer success outreach |
| 2 | Launch timeline at risk (2-5 day estimate vs Mon deadline) | 4 | 90% | [3],[4] | Reset launch to realistic date; communicate to stakeholders |
| 3 | Team capacity / context-switching limiting fix velocity | 3 | 85% | [5] | Offload P1s; dedicated iOS fix task force |
```

---

## Deployment Checklist

Before going live with agent:

- [ ] API key configured & tested
- [ ] KB folder mounted correctly in Docker
- [ ] System prompt pasted into Prompt Template node
- [ ] LLM model: gpt-4o, Temp: 0.2, Max: 800
- [ ] Retriever wired to Agent
- [ ] Agent output structure matches expected markdown table
- [ ] Tested on 5+ real P0 threads
- [ ] Confidence scores < 70% are flagged for manual review
- [ ] No hallucinations (invented facts) on test set
