# Lovable Prototype app · Juno

## Prototype link
https://disboard.lovable.app

# Changelog 

**Context** 
Juno PM started from a shared template, evolving with each class, to become a functional, strategy-aware AI synthesis tool with editable, citation-traceable outputs which could be further enhanced with AI support with user edits/overrides possible to ensure insights and PRD drafting could be useful.

Key build steps were: 
- starting from the template to make core loop visible and functional;
- adding AI synthesis and iterate on System Prompt with examples directly in the prototype; 
- then made the AI's reasoning inspectable, correctable (confidence, evidence quotes, footnotes, per-card refinement); 
- and finally enabled in context AI enhancement (re-process insights, edit PRD with AI support: expand/contrac/custom)

Each release below is grouped into four consistent categories:
- **System** — app infrastructure, configuration, state management, data plumbing (incl. system prompt)
- **UXD** — interface, layout, and interaction design (incl. user enabled kill-switch and fail safe)
- **AI Synthesis** — the core generation pipeline: how transcripts become insights and a PRD draft
- **AI Enhancement** — user-directed AI features layered on top of a generated result (refine, rewrite, expand/shorten)

---

## 2026-09-19 — Product analytics

**System**

- Added product analytics (Amplitude)
	- **Process Transcript** — track "Process transcript", with the transcript ID, if strategy was loaded, whether the prompt was edited, and transcript length
	- **Insight Priority Changed** — track priority changes, with the card ID and the from/to priorities
	- **Insight Reprocessed** — track individual insight card re-processing 

## 2026-09-15 — System instructions & output rendering

**System**

- Default system prompt updated to the v1 structured version: markdown headers, 5-step reasoning chain, classification, evidence rules, full PRD output format, References section with insights-overview table, footnotes, and system info

**UXD**

- System instructions overlay simplified: Context field removed; single full-height editor with the same view/edit (pencil/eye) Markdown experience
- Markdown tables in the PRD column render as styled, human-readable tables

---

## 2026-09-11 — Polish & mobile

**UXD**

- Insights
	- P0 cards get a red icon-only Escalate arrow pill
- Status info
	- Top pills renamed: "Awaiting input" → Ready, "Process transcript" → Process
	- Status pill format: "1 insight (1 src)" / "N insights (M src)"
- Mobile layout: columns stack vertically with page scroll; top bar (logo, status, Process) sticky; desktop layout untouched

---

## 2026-09-10 — "v3 release": Editable insight cards, AI regeneration and enhancement

**System**

- Transcript ID pill auto-generated (`JNO-YYYYMMDD`) after the Transcripts pill, passed into the prompt as the citation source label
- Stable card IDs (INS-001…) shown as small faded text above titles
- Manual "Rebuild PRD" button to incorporate card edits; card edits mark the PRD stale until rebuilt

**UXD**

- Insights
	- Insight cards fully editable: inline title/description editing; clickable priority (P0–P3 or REJECT); editable sentiment; strategic-pillar tag editable on click
	- Rejected cards move to a collapsed, restorable "Rejected" list (kill switch)
	- Confidence shown as nn% with colour bands: 90–100 green, 60–89 light orange, 30–59 darker orange, 0–29 red
	- Rationale text toned down to muted gray to improve readability  
- PRD
	- Citation overlays: superscript references open a small info overlay on hover/click to avoid user scrolling/losing context in PRD; full reference list kept at document end
	- PRD column directly editable (pencil toggle, save/cancel, "edited" marker)
- Status info
	- Processing progress panel: step-by-step "Juno is working" indicator above the skeleton cards to give user better understanding of what the system is doing; "No insights" pill hidden during processing
	- Pill renames: "Strategy loaded" → Strategy, "Transcripts loaded" → Transcripts

**AI Synthesis**

- Prompts tightened so PRD quotes are real blockquotes tied to evidence
- Prompts require numbered footnotes + a References section, feeding the citation overlay above

**AI Enhancement**

- Per-card AI refinement (sparkles button): re-checks title/description/priority/confidence against the evidence quote
- PRD editing/enhancement: highlight text → Expand / Shorten / Custom (AI rewrites only the selection; floating Enhance button added since preview swallows right-click)

Note: related audi [[trust-gaps]] 

---

## 2026-09-04 — "v2 release": Strategy context application and AI synthesis

**UXD**

- Strategy column added: paste text or upload `.txt`/`.md` files, with word count and a formatted Markdown preview/edit toggle to improve readability 
- Transcripts now start empty with a clear status pill; structured insights display new strategic metadata and warnings
- Flexible layout: columns are draggable and resizable (12% minimum width); top control strip streamlined

**AI Synthesis**

- Strategy input integrated into the AI synthesis process
- Dual-Mode AI Synthesis updated:  dynamic switching between Strategy Mode (aligned with uploaded strategy docs) and Quality Mode (scoring based on request-quality signals and anti-pattern detection)
- Draft PRD gains superscript footnote references and a clean definitions/reference block

---

## 2026-09-01 — 02

**System**

- Updated default system prompt based on testing/tuning in the prototype with transcripts

**UXD**

- Updated column widths to favour output focus, still flexible to adjust

---

## 2026-09-01 — 01

**UXD**

- Initial three-column dashboard based on template: fixed equal-width layout (1280px+) with Raw User Transcripts, Structured Insights, and Draft PRD panes; applied personal UI design (dark parchment-and-ink aesthetic with brass/rust accents)
- UX polish: status pill, persistently visible Process Transcript button, sample transcript that clears fully on first user edit, reset-sample control, copy-PRD button, loading skeletons, clear in-panel error/retry states

**System**

- Editable system prompt to enable realtime tuning: collapsible System instructions panel in the top strip, pre-filled with the Rocketship PM role, guardrails, and output-format rules; edits trigger a "Re-process" state and mark outputs as custom-instructed

**AI Synthesis**

- Real AI synthesis: replaced the fake 1.5s delay with a server-side Lovable AI Gateway call to Gemini, returning ranked insights and a markdown PRD from the actual transcript

**************************
