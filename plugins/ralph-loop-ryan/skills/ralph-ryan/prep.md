# Prep Mode (Multi-PRD Support)

Prepare Ralph execution environment by converting PRD and initializing files.

---

## The Job

1. **List available PRDs** in `.claude/ralph-ryan/`
2. **Ask user to select** which PRD to prepare
3. Read selected PRD's `prd.md`
4. Convert to `prd.json`
5. Initialize `progress.txt` (if not exists)

---

## Step 1: List Available PRDs

Scan `.claude/ralph-ryan/` for subdirectories containing `prd.md`:

```bash
ls -d .claude/ralph-ryan/*/
```

Display to user:

```
Available PRDs:

1. prd-06-risk-management/
   └── prd.md exists, prd.json: NO

2. prd-07-model-governance/
   └── prd.md exists, prd.json: YES (3/5 stories done)

Which PRD do you want to prepare? (enter number or name):
```

---

## Step 2: Validate Selection

- Check `prd.md` exists in selected directory
- If `prd.json` already exists, ask if user wants to regenerate

---

## Step 3: Output Format

```json
{
  "project": "[Project Name]",
  "featureName": "[feature-name-kebab-case]",
  "prdSlug": "[prd-slug]",
  "branchName": "ralph/[prd-slug]",
  "description": "[Feature description]",
  "userStories": [
    {
      "id": "US-001",
      "title": "[Story title]",
      "description": "As a [user], I want [feature] so that [benefit]",
      "acceptanceCriteria": [
        "Criterion 1",
        "Typecheck passes"
      ],
      "priority": 1,
      "passes": false,
      "notes": "",
      "filesChanged": []
    }
  ]
}
```

**New fields:**
- `prdSlug`: The PRD directory name
- `filesChanged`: Array to track files modified by each story (initially empty)

---

## Conversion Rules

1. Each user story → one JSON entry
2. IDs: Sequential (US-001, US-002, ...)
3. Priority: Based on dependency order, then document order
4. All stories: `passes: false`, empty `notes`, empty `filesChanged`
5. featureName: kebab-case (e.g., "risk-management")
6. prdSlug: The directory name (e.g., "prd-06-risk-management")
7. branchName: `ralph/` + prdSlug
8. Always include "Typecheck passes" in acceptance criteria

---

## Initialize progress.txt

If `.claude/ralph-ryan/<prd-slug>/progress.txt` doesn't exist, create it:

```markdown
## Codebase Patterns

(Patterns discovered during implementation will be added here)

---

# Progress Log

```

---

## Archiving Previous Runs

**Note:** With multi-PRD support, archiving happens per-PRD when ALL stories complete (handled in run.md), not during prep.

---

## Checklist

Before saving:
- [ ] Listed available PRDs
- [ ] User selected a specific PRD
- [ ] prdSlug matches directory name
- [ ] featureName is kebab-case
- [ ] Each story completable in one iteration
- [ ] Stories ordered by dependency
- [ ] Every story has "Typecheck passes"
- [ ] UI stories have "Verify in browser using dev-browser skill"
- [ ] progress.txt initialized
- [ ] Saved to `.claude/ralph-ryan/<prd-slug>/prd.json`
