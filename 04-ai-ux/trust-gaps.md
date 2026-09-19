
# Trust-Gap Mitigations · Juno


## Trust gaps 

| Gap                       | Where it shows up                                          | User cost                               | Mitigation                                                                                                                                                                                                |
| ------------------------- | ---------------------------------------------------------- | --------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **The Black-box Gap**     | Can the user see why the AI decided?                       | Noticeable but recoverable (4/5 closed) | Citations shown In-line with hover/overlay citation and summary at end System prompts visible (and editable) directly by user                                                                             |
| **The Hallucination Gap** | Could this confidently be wrong?                           | Noticeable but recoverable (3/5 closed) | Clear indicator if sources were not loaded or failed to load Confidence scores shown clearly (highlight at too-low threshold) Regeneration/re-processing trigger at a granular level (not all or nothing) |
| **The Control Gap**       | Can the user steer or stop?                                | Noticeable but recoverable (2/5 closed) | Classification overrides at granular insight level Direct edit of output and AI enhancement support (incl. custom instructions) to regenerate                                                             |
| **The Intelligence Tax**  | Is the latency / privacy / cognitive load worth the value? | Noticeable but recoverable (3/5 closed) | Processing updates to show steps and progress directly within UI                                                                                                                                          |

## Highest-priority fix

**The Control Gap** (2/5). Classification overrides at granular insight level, direct edit of output and AI regeneration/enhancement support (incl. custom instructions).


## Verdict

**Iterate** 
Focus on the highest impact change, ensuring the synthesis is of a high quality, which in turn is used to generate and update the PRD.



**Note: See improvements: [[lovable-prototype-changelog]]