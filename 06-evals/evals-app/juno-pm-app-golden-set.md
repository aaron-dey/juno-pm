
# Juno PM App - Golden Dataset — Usage Notes

Companion file: `juno_pm_golden_dataset.json`

## Purpose

This dataset regression-tests **Juno PM's Copilot app schema, UI, and state logic** — not the quality of its AI-generated synthesis. It answers "does the app render, classify, and transition correctly?" rather than "is the AI's judgment good?". This would be something to address in the future based on real transcripts and review.

## How to run it

For each case:

1. Feed `input` (transcript, strategy_doc, and/or existing_card) into Juno.
2. Compare the actual output to `expected_output` **on structure and fields**, not exact wording.

Check things like:

- Is `priority` one of `P0`–`P3` / `REJECT`?
- Does `confidence_band` match the documented numeric range (90–100 green, 60–89 light orange, 30–59 darker orange, 0–29 red)?
- Does a `P0` card show the red icon-only Escalate pill?
- Does editing a card mark the PRD stale until "Rebuild PRD" is pressed?
- Does the citation chain resolve: card → footnote marker → hover/click overlay → References table entry?

## Suggested grouping

Run cases as suites by `category` so a failure points at a specific subsystem:

- `insight_synthesis` — card field extraction and classification
- `prd_generation` — PRD formatting, blockquotes, footnotes, References table
- `mode_switching` — Strategy Mode vs Quality Mode triggering and scoring
- `ui_state` — pills, processing indicators, empty states, staleness
- `citation_traceability` — footnote/overlay/reference-table consistency
- `enhancement` — per-card refinement, selection Expand/Shorten/Custom

## Pass/fail criteria

Grade at the **schema level**, not the string level. Example: TC-003 passes if `priority = P0`, `confidence ≥ 90`, `confidence_band = green`, and the Escalate pill appears — the exact title wording doesn't need to match.

## What this dataset is NOT for

It does not validate whether Juno's actual AI-generated insight is _correct_ or well-written. The `expected_output` values here are synthetic and encode only the **documented format rules** from the changelog — they were not checked against real Lovable AI Gateway / Gemini responses. Evaluating synthesis quality requires real transcripts and real model outputs compared by a human or a separate quality rubric.

## Maintenance

This set reflects the changelog as of **2026-09-15**. Treat it as a living test suite:

- Add a case whenever a real production failure mode is discovered.
- Update or retire cases when Juno's spec changes (e.g. new priority levels, changed confidence-band thresholds, new UI states).