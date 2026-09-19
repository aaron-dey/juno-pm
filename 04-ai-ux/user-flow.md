
# AI-Native User Flow · Juno

## Entry point

**Signal type:** Meeting / call ended
Meeting completed (Automation pushes call transcript from preferred tools directly into JUNO PM)

**What they see instantly**
New transcript received and Juno is reading this

## The flow

**1/ Logic**
L.1 Determine if this contains a single issue/request or multiple 
L.2 Determine if this is a (a) operational issue, (b) bug or (c) feature request 
L.3. RAG to determine customer SLA (entitlements, escalations), strategy and product definitions/handbook 
L.4. Summarise requests/issues 

**2/ Messages**
Messages/Breadcrumbs/info to be shown at each step 
M.1. Analysing transcripts 
M.2. Reviewing and classifying 
M.3. Checking context 
M.4. Summarising 3. 

**3/ Router decisions**
R.1. RAG check customer SLA 
R.2. Content check product definition (and roadmap) 
R.3. Content check product strategy (and roadmap)

## AI moments

**Placement:** Full-Page Canvas column
- Individual card(s) with Headline, summary
- Classification: issue, bug, request
- Confidence: highlight to user where particular attention needed on low confidence

Should be possible for user to edit by clicking into fields or tags
Speeds up the analysis - especially if operational critical issues identified

## Fallbacks

**Kill switch**
- Reject the whole analysis as irrelevant (reject)
- Reject individual cards as irrelevant (Regenerate)


**Training signal**
- If user changes description, classification, prioritisation
- If user triggers regeneration of insight card 
- If PRD is edited manually, and AI enhancements applied

**Fail-safe**

Flag missing context - customer SLA (entitlements, escalations), strategy and product definitions/handbook


## Self-review

- [x] Trigger fires on the earliest possible signal, no manual “Start AI” click.
- [x] At least one breadcrumb message turns latency into transparency.
- [x] Maneuver matches the M2 value prop (Automation / Augmentation / Insights / Personalization).
- [x] Every automated decision has a working kill switch.
- [x] Fail-safe path is explicit. No dead end with a bad AI result.
- [x] Hidden logic references M3 PRD specs (Top-K, latency target, knowledge base).
