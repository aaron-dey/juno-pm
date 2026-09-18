# Juno PM Agent — Quick Start (5 mins)

## What You've Got

✅ KB folder created: `/Users/aarondey/aos/juno-pm/project/05-agentic-workflows/agent/kb`  
✅ Startup script: `/Users/aarondey/aos/juno-pm/project/05-agentic-workflows/agent/langflow-start.sh`  
✅ Langflow template: `Juno Agent - starter template.json` (import into Langflow UI)  
✅ Full setup guide: `LANGFLOW_SETUP.md`  
✅ Prompt tuning guide: `PROMPTS_GUIDE.md`  

---

## Step 1: Set Your API Key

```bash
export OPENAI_API_KEY="sk-proj-YOUR-KEY-HERE"
```

---

## Step 2: Start Langflow

```bash
cd /Users/aarondey/aos/juno-pm/project/05-agentic-workflows/agent
./langflow-start.sh
```

Or manually:
```bash
docker run \
  -e OPENAI_API_KEY="sk-proj-YOUR-KEY-HERE" \
  -e LANGFLOW_AUTO_LOGIN=true \
  -v /Users/aarondey/aos/juno-pm/project/05-agentic-workflows/agent:/app/kb \
  -p 7860:7860 \
  --name langflow \
  langflowai/langflow
```

---

## Step 3: Import Template & Run

1. Open http://localhost:7860
2. Click **File** → **Import from file**
3. Select: `Juno Agent - starter template.json`
4. Click **Playground** at bottom
5. Paste a P0 thread → Agent returns risk table

---

## Test P0 Thread

```
[0] Database migration failed in prod, 5% of users locked out
[1] Customer support flooded with 60+ tickets/hour
[2] CEO wants status in 30 min
[3] Engineering can't pinpoint root cause, trying rollback
[4] Launch event is tomorrow
```

Expected: Severity 5 risks, 95%+ confidence, clear actions.

---

## KB Files

Currently in KB:
- `strategy-one-pager.md` (product strategy context)

**To add more KB:**
1. Save `.md` files to `/Users/aarondey/aos/juno-pm/project/05-agentic-workflows/agent/kb/`
2. Restart Langflow (stop & restart Docker)
3. Agent now has more context

---

## Troubleshooting

**Docker error?**  
Check Docker is running: `docker ps`

**Port 7860 in use?**  
Use different port: `-p 7861:7860` → visit `http://localhost:7861`

**No KB context?**  
- Verify KB path in Docker: should show at `/app/kb`
- Files must be `.md` format
- Restart Docker after adding files

**Agent returns garbage?**  
- Check LLM is gpt-4o, temp 0.2
- Try simpler test thread first
- Verify API key is valid

---

## Next: Fine-Tuning

Read `PROMPTS_GUIDE.md` for:
- System prompt customization
- Risk category frameworks
- Temperature & model tuning
- Few-shot examples
- Advanced prompt variants

---

## Files Inventory

```
/Users/aarondey/aos/juno-pm/project/05-agentic-workflows/agent/
├── langflow-start.sh                 (startup script)
├── kb/
│   └── strategy-one-pager.md        (KB file)
├── Juno Agent - starter template.json (pre-built flow)
├── LANGFLOW_SETUP.md                 (full setup guide)
├── PROMPTS_GUIDE.md                  (prompt tuning)
└── Juno_PM_Agent_Setup_Instructions.md (original instructions)
```
