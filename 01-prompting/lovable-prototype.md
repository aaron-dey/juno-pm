# Lovable Prototype · Juno

> Module 1 · Prompting. The clickable Lovable prototype that brings the system prompt to life.

## Prototype link

Lovable preview
https://id-preview--6fa4ff35-a16f-4762-a2f9-1147ab5f2050.lovable.app 

### Changelog
2026-09-01 - 01
1. Initial three-column dashboard — fixed equal-width layout (1280px+) with Raw User Transcripts, Structured Insights, and Draft PRD panes; UI design updated (dark parchment-and-ink aesthetic with brass/rust accents).
2. UX polish — status pill, persistently visible Process Transcript button, sample transcript that clears fully on first user edit, reset-sample control, copy-PRD button, loading skeletons, and clear in-panel error/retry states.
3. Editable system prompt — added a collapsible System instructions panel in the top strip, pre-filled with your Rocketship PM role, guardrails, and output-format rules; edits trigger a “Re-process” state and mark the outputs as custom-instructed.
4. Real AI synthesis — replaced the fake 1.5s delay with a server-side Lovable AI Gateway call to Gemini, returning ranked insights and a markdown PRD from the actual transcript.

2026-09-01 - 02
1. Updated system prompt: New default based on testing
2. Updated column layouts: Widths to enable focus on outputs and flexible to adjust if needed

_____

## What it demonstrates

Agentic app development is very powerful and fast - but clear instructions and guardrails needed to prevent it from simply making stuff up!

_____

## Debrief

- **What worked:** UI and UX implementation was quick and easy 
  
- **What broke / felt like a toy:** Lovable included some placeholder content into the INPUT field, which was great initially, but somehow this continues to be included into the SYNTHESIS even when the field is cleared. It wasn't obvious where the placeholder content came from, and how to ensure that it's fully replaced.
  
- **What I'd change next pass:** Expand on how to make the SYNTHESIS more precise, with a general overview first, and then the actual cards. I make a distinction between an actual user Problem/Pain-point and Opportunity. Additionally, I would create more context of what "Juno PM" is, and include this into how the PRD is shaped.


_____

# Screenshots

## Default view
Page layout shows the steps 1-3 - with a default resizeable layout and empty state information
![[Juno-PM_v1_Screenshot-01-Default.png]]

## Transcript processing 
AI processing triggered with user interview input
![[Juno-PM_v1_Screenshot-02-User-input.png]]

## PRD completed 
Output structure defined through system prompt (incl. mandatory updates for CSM)
![[Juno-PM_v1_Screenshot-03-User-input-and-output.png]]

## System prompt 
Dynamically applied so adjustments can be made in real time
![[Juno-PM_v1_Screenshot-04-System-prompt.png]]