
# STRATEGY

RocketShip, Q3 2026 Strategy One-Pager

NORTH STAR
Become the fastest, most reliable analytics platform for mid-market data teams who currently rely on Excel + Salesforce.

THREE STRATEGIC PILLARS

1. Reliability First
   The platform must work. Every export, every report, every load. We are losing enterprise deals (Pearson Co, Acme) because of P0 reliability bugs - CSV export crashes, 403 permission errors, queue overflows on large reports. ZERO new feature work ships if the legacy reporting API is redlining.

2. Enterprise Compliance
   We win or lose on SAML/SSO, audit logs, and role-based permissions. Acme deal worth $200k ARR is dead if we don't ship Okta SSO by Oct 1. This is not optional.

3. Speed-to-Insight
   Mid-market analysts choose us over Salesforce because we feel fast. Anything that makes the dashboard slower (heavy AI summarization on top of fragile DBs, 30+ second exports) is a step backwards.

WHAT WE ARE NOT DOING THIS QUARTER
- Aesthetic refreshes (dark mode, color palette tweaks, "make it pop" UI work)
- Competitor-mimicking AI features without clear user evidence
- TikTok integration or other social plumbing
- Dashboard summarization that requires DB sharding work

DECISION RULES
- If a request reduces reliability OR slows export speed -> P3 or notRecommended
- If a request unblocks an enterprise deal with stated $ARR -> P0
- If a request comes from "exec opinion" without user evidence -> notRecommended
- If a request fixes a workflow blocker (CSV crash, permission error) -> P0/P1


# PRD - WITHOUT strategy
### Export to CSV crashes on Quarterly Reports

P0

Users experience application crashes without error messages when attempting to export 90-day data to CSV. This breaks downstream data analysis in Excel and forces manual workarounds.

I try to click 'Export to CSV' because I need to pivot this in Excel. It spins for like 5 minutes and then just crashes.

BLOCKED INTERVIEW · SARAH, DATA ANALYST 1×

### Navigation bar color causes eye strain

P1

The new blue navigation bar is excessively bright and creates visual discomfort for users during weekly workflows. Users are asking for a visual adjustment to soften the color.

The first thing I notice is that the new blue navigation bar is really bright, like hurts my eyes bright. Can we change that?

FRUSTRATED INTERVIEW · SARAH, DATA ANALYST 1×


# PRD - WITH strategy

### CSV Export Crash on Quarterly Reports

P0

Exporting report data to CSV causes a 5-minute freeze followed by a crash with no error message. This completely blocks data analysts from pivoting reporting data in Excel.

I try to click 'Export to CSV' because I need to pivot this in Excel. It spins for like 5 minutes and then just crashes.

RELIABILITY FIRST 
100/100

The strategy document explicitly identifies CSV export crashes under 'Reliability First' as critical P0 blockers where zero new feature work ships if reliability is redlining.

BLOCKED INTERVIEW · SARAH 1×

### High-Brightness Blue Navigation Bar

P1

The new bright blue navigation bar causes eye discomfort during regular analyst workflows. The user requested adjusting or toning down the navigation bar styling.

The first thing I notice is that the new blue navigation bar is really bright, like hurts my eyes bright. Can we change that?

SPEED-TO-INSIGHT 
20/100 NOT RECOMMENDED

Aesthetic refreshes and color palette tweaks are explicitly listed under 'WHAT WE ARE NOT DOING THIS QUARTER' in the strategy document.

Aesthetic and color palette modifications are explicitly excluded from Q3 scope in the strategy document.

FRUSTRATED
INTERVIEW · SARAH 1×

### Dark Mode Support

P3

User requested an application-wide dark mode theme to improve visual comfort. This is a purely cosmetic request without direct workflow blocking impact.

Oh, and I'd love a dark mode.

SPEED-TO-INSIGHT
0/100 NOT RECOMMENDED

The strategy document explicitly lists 'dark mode' under 'WHAT WE ARE NOT DOING THIS QUARTER'.

Dark mode is explicitly excluded from Q3 roadmap under the strategy document's non-goals.

HOPEFUL INTERVIEW · SARAH