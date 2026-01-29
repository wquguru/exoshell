# Status Mode

Display overview of all PRDs and their execution status.

---

## The Job

1. Scan `.claude/ralph-ryan/` for all PRD subdirectories
2. For each PRD, gather status information
3. Display formatted overview
4. Optionally show conflict analysis

---

## Output Format

```
╔══════════════════════════════════════════════════════════════════╗
║                    Ralph PRD Status Overview                      ║
╚══════════════════════════════════════════════════════════════════╝

📁 Active PRDs (.claude/ralph-ryan/)
────────────────────────────────────────────────────────────────────

1. prd-06-risk-management/
   ├── Status:    🟡 IN PROGRESS (3/5 stories)
   ├── Branch:    ralph/prd-06-risk-management
   ├── Lock:      🔓 Unlocked
   ├── Progress:  ████████░░░░░░░░ 60%
   └── Next:      US-004 - VaR calculation page

2. prd-07-model-governance/
   ├── Status:    🟢 READY (0/4 stories)
   ├── Branch:    ralph/prd-07-model-governance
   ├── Lock:      🔓 Unlocked
   ├── Progress:  ░░░░░░░░░░░░░░░░ 0%
   └── Next:      US-001 - Model list page

3. prd-08-settings/
   ├── Status:    ⚪ NOT PREPARED (prd.md only)
   ├── Branch:    -
   ├── Lock:      -
   └── Action:    Run `/ralph-ryan prep` to prepare

────────────────────────────────────────────────────────────────────

📦 Archived PRDs (.claude/ralph-ryan-archived/)
────────────────────────────────────────────────────────────────────

• 2026-01-29-prd-05-market-data/ (5/5 stories)
• 2026-01-28-prd-04-dashboard/ (8/8 stories)

────────────────────────────────────────────────────────────────────

⚠️ Conflict Analysis
────────────────────────────────────────────────────────────────────

No file conflicts detected between active PRDs.

(or)

Potential conflicts:
• components/charts/heatmap.tsx
  - prd-06-risk-management: US-003 (modified)
  - prd-07-model-governance: US-002 (planned)

────────────────────────────────────────────────────────────────────

💡 Quick Commands:
   /ralph-ryan prd [description]  - Create new PRD
   /ralph-ryan prep               - Prepare PRD for execution
   /ralph-ryan run                - Execute next story
```

---

## Status Indicators

| Icon | Status | Meaning |
|------|--------|---------|
| 🟢 | READY | prd.json exists, 0 stories done, ready to start |
| 🟡 | IN PROGRESS | Some stories completed |
| ✅ | COMPLETE | All stories done (should be archived) |
| ⚪ | NOT PREPARED | Only prd.md exists, needs prep |
| 🔒 | LOCKED | Another agent is working on this PRD |
| 🔓 | UNLOCKED | Available for execution |

---

## Lock Status Details

If a PRD is locked, show:

```
├── Lock:      🔒 Locked
│   ├── By:    session-abc123
│   ├── At:    2026-01-29 10:30:00 (15 min ago)
│   └── Story: US-003
```

If lock is stale (> 30 min):

```
├── Lock:      ⚠️ Stale lock (45 min old)
│   └── Can be overridden
```

---

## Conflict Detection Logic

For each active PRD, collect:
1. Files already modified (`filesChanged` in completed stories)

Cross-reference across all PRDs to find overlaps.

**Note:** Only detects conflicts based on **already modified files**. Does not predict future modifications.

---

## Implementation

```bash
# List PRD directories
for dir in .claude/ralph-ryan/*/; do
  if [ -f "$dir/prd.json" ]; then
    # Parse JSON for status
    jq '{
      slug: .prdSlug,
      total: (.userStories | length),
      done: ([.userStories[] | select(.passes == true)] | length),
      next: ([.userStories[] | select(.passes == false)][0].id // "none")
    }' "$dir/prd.json"
  elif [ -f "$dir/prd.md" ]; then
    echo "NOT PREPARED: $dir"
  fi
done
```

---

## Checklist

- [ ] Scanned all PRD directories
- [ ] Displayed status for each PRD
- [ ] Showed lock status
- [ ] Ran conflict analysis
- [ ] Listed archived PRDs
- [ ] Provided quick command reference
