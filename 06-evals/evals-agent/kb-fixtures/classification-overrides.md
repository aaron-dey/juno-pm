# Strategy: Classification Overrides

*Rocketship internal strategy doc — effective 2026-09-01 (Synthetic)*

These override the tool's default P0–P3 examples when they apply:

- Accessibility issues affecting screen-reader or keyboard-only users are classified **P0**, not P1, per the ADA compliance commitment agreed in the 2026-08-15 legal settlement.
- Login or authentication failures that block any paying customer from accessing the product are always **P0**, even if reported by only one user.
- A report from an Tier-1 account within 60 days of contract renewal is treated as **P1 minimum**, even if it would otherwise be P2/P3 (see Pricing doc).
- General UI/layout complaints ("I don't like the new design") are never classified above **P2** absent a measurable usage-drop signal (e.g., a reported drop in a specific metric, not just sentiment).
