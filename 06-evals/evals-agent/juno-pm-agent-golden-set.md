# Juno PM Agent — Golden Dataset (v0)

A regression suite for the `Juno PM - PO Thread - HIL with Embedding` Langflow flow: 32 synthetic P0 threads with known-correct expected outputs, covering the 8 failure modes identified in the plan doc (classification accuracy, evidence/citation compliance, anti-hallucination, reasoning-chain adherence, retrieval relevance, output format, routing logic, and safety/injection resistance).

## What's here

- `kb-fixtures/` — the small, fixed strategy-doc set the agent's knowledge base retrieval is tested against. Four docs: `pricing.md`, `roadmap.md`, `classification-overrides.md`, and `conflicting-addendum.md`. Most cases run against `kb-v1` (the first three docs, chunked and ingested as the `Juno-chunked-small` collection); a few use `kb-empty` (no docs) or `kb-conflicting` (all four, including the addendum) to test specific edge cases.
- `golden-cases.json` — the 32 test cases, one object per case, matching the schema below.

## Case schema

Each case in `golden-cases.json`:

| Field | Meaning |
| --- | --- |
| `id` | Stable id, e.g. `GD-001` |
| `category` | One of the 8 test categories |
| `kb_fixture` | `kb-v1`, `kb-empty`, or `kb-conflicting` — which strategy-doc set to load before running the case |
| `input_thread` | The synthetic P0 thread text to feed as chat input |
| `expected_classification` | The tier (P0–P3) and the rule that justifies it, or `null` where classification isn't the point of the case |
| `expected_risks` | Ranked list of risks the output should surface, each with required citation types and an expected confidence band |
| `expected_router_branch` | `"HIL"` or `"direct"` — which ConditionalRouter branch the case should take |
| `expected_hil_decision_set` | For HIL cases, which of Rollback/Hotfix/Hold/Escalate would be defensible given the thread; `null` for direct-branch cases |
| `must_not_contain` | Forbidden fabrications — names, dollar figures, or claims not present in the input |
| `pass_criteria` | Which checks apply: `automated` (deterministic) vs `judged` (LLM-rubric, 1–5 scale) |
| `notes` | Why the case exists — the real risk or known limitation it guards against |

## Running it

This is data, not a harness. To use it: feed each `input_thread` into the flow (with the matching `kb_fixture` loaded into `Juno-chunked-small`), capture the output, and check it against `expected_*` and `must_not_contain` per the grading rubric in the plan doc (automated checks first, hard-fail checks always, LLM-judged checks on categories 1, 2, and 4 or as budget allows).

A few cases (`GD-026`, `GD-028`, `GD-032`) are intentionally written to probe known-fragile spots in the current design (the router's literal substring match, HIL triggering on rank alone rather than confidence, and cross-document strategy conflicts) rather than to simply pass — their `notes` field says what a "correct" vs. "currently expected" behavior looks like.

## Next steps

1. Load the `kb-fixtures` docs into a test `Juno-chunked-small` collection (or a separate test collection pointed at by a cloned flow) so retrieval cases have known ground truth.
2. Run the 32 cases against the current flow and record results.
3. Get one real, scrubbed P0 thread reviewed against the dataset's expected shape to sanity-check the synthetic ground truth before treating this suite as authoritative.
4. Feed any production bug found later back in as a new case rather than just a fix.
