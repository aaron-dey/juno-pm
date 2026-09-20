
# Agent Workflow Spec (AWSpec) · Juno

## Goal

Triage P0 escalations into a daily prioritised top-3 risk list, with a strategic-rationale citation per item (Risk mitigation).

**Primary actor:** Agent + Human-in-the-loop

## Trigger

New message in #escalations tagged P0 AND reactions >= 5  within 10 minutes.

*Note: For the project, an operational Slack environment could not be used, so the trigger used was a Langflow Chat input*

## Steps & tools

**Pattern:** ReAct (single-agent reason-act-observe loop)
Reasoning: Info/requests may vary greatly with ambiguity and details - cannot be simply solved with Planner - Executor

| Step | Action                                                                   | Tool / model                                                 | Guardrail                                                                                                                                                                                                                                     |
| ---- | ------------------------------------------------------------------------ | ------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1    | Read the thread + retrieve customer ID and ARR if mentioned.             | slack.reactions(count unique), read-only                     | Agent can READ Slack #escalations + Strategy Knowledge Base + Pipedrive ARR.  <br>Agent can WRITE to #pm-daily and create Jira stubs.  <br>Agent CANNOT edit Salesforce records, edit Jira tickets after creation, or post outside #pm-daily. |
| 2    | RAG retrieval over the RocketShip Strategy One-Pager (M3 KB), top-K = 6. | corpus.retrieve(query, k=6), read-only                       |                                                                                                                                                                                                                                               |
| 3    | Score risk + alignment vs strategic pillars; emit P0-P3 with rationale.  | pipedrive.lookup_arr(customer_id), read-only                 |                                                                                                                                                                                                                                               |
| 4    | Draft summary card (transcript quote + strategic citation).              | jira.create_stub(payload), write, requires confidence >= 80% |                                                                                                                                                                                                                                               |
| 5    | Post to #pm-daily OR route to PM review based on confidence threshold.   | slack.post(channel, payload), write, restricted to #pm-daily |                                                                                                                                                                                                                                               |

**Schemas**

- corpus.retrieve → {chunks:[{text,source,pillar,score}]}.
- pipedrive.lookup_arr → {arr_eur, contract_end, churn_risk}.
- jira.create_stub → {ticket_id, url, status}.

**Memory (in or out of scope)**

- **Episodic:** In-scope: tool results, retrieved chunks, intermediate scores. Lifetime: end of run.
  
- **Semantic:** In-scope: RocketShip strategic taxonomy + Juno system prompt + PM preferences. Lifetime: indefinite, refreshed weekly. 
  Out of scope: do NOT persist customer-specific contracts or PII.
  
- **Working:** In-scope: current thread, customer ID, ARR, retrieved Knowledge Base chunks, current confidence score. Lifetime: Held in working context only.
  
- **External :** 
  In-scope: 
  READ: Slack thread API, RocketShip Strategy Knowledge Base, Pipedrive ARR lookup
  WRITE: Slack channel #pm-daily, Jira ticket (write, stub creation only).

## Human-in-the-loop

PM reviews any P0 with confidence < 70% before posting. 
Hourly review: PM prompted every 55 mins if PO identified within working hours (9:00am and 5:00pm)
Daily summary at 9:55am: PM has a 5-min review window before the agent auto-posts to #pm-daily.

## Success & failure

- **Done when:** - Success: top-3 risk list posted to #pm-daily.
- Failure: > 2 tool errors in a run → log + abort.
- Escalation: confidence < 70% on any P0 → hand to PM.
- Timeout: 90s wall clock → abort with partial output and timestamp.
- **Fails safe when:** Agent can READ Slack #escalations + Strategy Knowledge Base + Pipedrive ARR. 

Agent can WRITE to #pm-daily and create Jira stubs. 
Agent CANNOT edit Salesforce records, edit Jira tickets after creation, or post outside #pm-daily.


![[awspec-illustration.png]]

## Self-review

- [x] Goal is one sentence and names the value frame.
- [x] Trigger is a precise, testable condition.
- [x] Pattern is chosen with a defensible reason.
- [x] At least 3 stop conditions, including escalation.
- [x] Each memory type named (in or out of scope).
- [x] Every tool lists scope (read-only vs write) and a schema.
- [x] Read/write boundaries match the AI PRD (M3).
