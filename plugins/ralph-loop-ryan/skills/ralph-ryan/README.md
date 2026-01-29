# Ralph Loop Ryan

Autonomous AI agent that implements features iteratively through PRD-driven development with **multi-PRD parallel support**.

Based on [Geoffrey Huntley's Ralph pattern](https://ghuntley.com/ralph/) and [Ryan Carson's implementation](https://x.com/ryancarson/status/2008548371712135632).

## Overview

Ralph is an autonomous loop that runs Claude Code repeatedly until all PRD items are complete. Each iteration is a fresh instance with clean context. Memory persists via git history, `progress.txt`, and `prd.json`.

**New in v2:** Support for multiple PRDs running in parallel on the same branch.

## Installation

Before using this skill, you need to install the ralph-loop plugin:

**Step 1: Add the official marketplace**
```bash
/plugin marketplace add anthropics/claude-plugins-official
```

**Step 2: Install the ralph-loop plugin**
```bash
/plugin install ralph-loop@claude-plugins-official
```

Make sure to upgrade Claude Code to the latest version before installation.

## Workflow

```bash
# Check status of all PRDs
/ralph-ryan status

# Create a new PRD (will ask for slug name)
/ralph-ryan prd [describe your feature]

# Prepare a PRD for execution (will list available PRDs)
/ralph-ryan prep

# Execute stories (will list available PRDs)
/ralph-loop:ralph-loop "Load skill ralph-ryan and execute run mode." --max-iterations 10 --completion-promise COMPLETE
```

## Directory Structure (Multi-PRD)

```
.claude/ralph-ryan/
├── prd-06-risk-management/          # PRD subdirectory
│   ├── prd.md                       # Human-readable PRD
│   ├── prd.json                     # Machine-readable stories
│   ├── progress.txt                 # Learnings for future iterations
│   └── lock.json                    # Execution lock (prevents conflicts)
├── prd-07-model-governance/
│   └── ...
└── ...

.claude/ralph-ryan-archived/
└── 2026-01-29-prd-05-market-data/   # Archived after completion
```

## Commands

### 1. Check Status

```bash
/ralph-ryan status
```

Shows overview of all PRDs:
- Progress (X/Y stories done)
- Lock status
- Conflict warnings
- Next story to execute

### 2. Generate PRD

```bash
/ralph-ryan prd Add a task priority system with filtering
```

Creates `.claude/ralph-ryan/<prd-slug>/prd.md` with:
- Clarifying questions (lettered options)
- User stories sized for single iterations
- Verifiable acceptance criteria

### 3. Prepare for Execution

```bash
/ralph-ryan prep
```

- Lists available PRDs
- Converts selected `prd.md` → `prd.json`
- Initializes `progress.txt`

### 4. Execute

```bash
/ralph-loop:ralph-loop "Load skill ralph-ryan and execute run mode." --max-iterations 10 --completion-promise COMPLETE
```

Ralph will:
1. List available PRDs and select one
2. Acquire lock for the selected PRD
3. Read prd.json and progress.txt
4. Pick highest priority story where `passes: false`
5. Implement that single story
6. Track files changed
7. Run quality checks
8. Commit only related files
9. Update prd.json to mark story complete
10. Append learnings to progress.txt
11. Release lock
12. Repeat until all stories pass

## Multi-PRD Parallel Development

You can run multiple PRDs simultaneously:

```bash
# Terminal 1: Execute PRD-06
/ralph-loop:ralph-loop "Load skill ralph-ryan and execute run mode for prd-06-risk-management." --max-iterations 10 --completion-promise COMPLETE

# Terminal 2: Execute PRD-07
/ralph-loop:ralph-loop "Load skill ralph-ryan and execute run mode for prd-07-model-governance." --max-iterations 10 --completion-promise COMPLETE
```

### Lock Mechanism

Prevents concurrent execution conflicts:

```json
// lock.json
{
  "lockedBy": "session-abc123",
  "lockedAt": "2026-01-29T10:30:00Z",
  "storyId": "US-003"
}
```

- Locks expire after 30 minutes
- Stale locks can be overridden
- Locks are released after each story

### File Tracking

Each story records modified files:

```json
{
  "id": "US-003",
  "passes": true,
  "filesChanged": [
    "app/risk/greeks/page.tsx",
    "components/charts/greeks-heatmap.tsx"
  ]
}
```

Benefits:
- Precise commits (only related files)
- Conflict detection across PRDs

### Conflict Detection

When multiple PRDs modify the same file, you'll see a warning:

```
⚠️ Potential conflict detected!

File: components/charts/heatmap.tsx
- Modified by: prd-06-risk-management (US-002)
- Also tracked by: prd-07-model-governance (US-003)
```

## Key Concepts

### Each Iteration = Fresh Context

Each iteration spawns a **new instance** with clean context. Memory persists only via:
- Git history (commits from previous iterations)
- `progress.txt` (learnings and patterns)
- `prd.json` (which stories are done)

### Small Tasks

Each story must complete in **one context window**. If too big, the LLM runs out of context and produces poor code.

**Right-sized:**
- Add a database column and migration
- Add a UI component to existing page
- Update a server action

**Too big (split these):**
- "Build entire dashboard"
- "Add authentication"

### Stop Condition

When all stories have `passes: true`, Ralph outputs `<promise>COMPLETE</promise>` and the loop exits.

## Debugging

```bash
# See status of all PRDs
/ralph-ryan status

# See which stories are done in a specific PRD
cat .claude/ralph-ryan/prd-06-risk-management/prd.json | jq '.userStories[] | {id, title, passes}'

# See learnings from previous iterations
cat .claude/ralph-ryan/prd-06-risk-management/progress.txt

# Check git history
git log --oneline -10

# Check for locks
ls -la .claude/ralph-ryan/*/lock.json
```

## Files

| File | Purpose |
|------|---------|
| `SKILL.md` | Entry point with routing logic |
| `prd.md` | PRD generation instructions |
| `prep.md` | Preparation/conversion instructions |
| `run.md` | Execution instructions |
| `status.md` | Status overview instructions |
