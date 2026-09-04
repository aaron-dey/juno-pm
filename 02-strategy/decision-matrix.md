# AI Solution Decision Matrix · Juno

## The decision

Whether RocketShip builds Automated Prioritization in Juno as a Hybrid (RAG + Agentic) Copilot, vs buying a generic LLM API or fine-tuning a model on our corpus.

Why now: roadmap discussions are driven by the loudest voice in Slack rather than customer evidence. Priorities reverse weekly, and the PM cannot defend the call to leadership.

## Options scored

| Option | Cost | Speed | Control | Moat | Risk | Score |
|---|---|---|---|---|---|---|
| Build | 5 | 2 | 5 | 5 | 4 | 4.2 |
| Buy / API | 4 | 5 | 2 | 1 | 2 | 2.8 |
| Fine-tune | 4 | 1 | 4 | 4 | 4 | 3.4 |

## Recommendation

Build

Reasoning for recommendation
- Highest score because Control and Moat are the axes that matter for a - ranking system leadership will trust. 
- A generic Buy / API may be cheaper and faster, but it cannot cite RocketShip sources, so it recreates the loudest-voice problem. 
- Fine-tune is slower than we can wait and still needs the corpus Juno would retrieve live. 

Autonomy 
Copilot: Juno drafts the ranked backlog with citations; the PM approves before publish.

