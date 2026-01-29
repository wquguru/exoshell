# Ralph Loop Ryan Plugin

Ralph autonomous agent for iterative development with multi-PRD parallel support.

Based on [Geoffrey Huntley's Ralph pattern](https://ghuntley.com/ralph/) and [Ryan Carson's implementation](https://x.com/ryancarson/status/2008548371712135632).

## Overview

Ralph is an autonomous loop that runs Claude Code repeatedly until all PRD items are complete. Each iteration is a fresh instance with clean context. Memory persists via git history, `progress.txt`, and `prd.json`.

**Key Features:**
- Multi-PRD parallel development support
- Structured PRD generation with clarifying questions
- Lock mechanism to prevent conflicts
- File tracking for precise commits

## Prerequisites

This plugin requires the `ralph-loop` plugin from the official marketplace:

```bash
# Add the official marketplace
/plugin marketplace add anthropics/claude-plugins-official

# Install the ralph-loop plugin
/plugin install ralph-loop@claude-plugins-official
```

## Installation

```bash
# Add this marketplace
/plugin marketplace add wquguru/ralph-ryan

# Install the plugin
/plugin install ralph-loop-ryan@ralph-ryan
```

## Usage

### 1. Create PRD

```bash
/ralph-ryan prd Add a task priority system with filtering
```

Creates `.claude/ralph-ryan/<prd-slug>/prd.md` with:
- Clarifying questions (lettered options)
- User stories sized for single iterations
- Verifiable acceptance criteria

### 2. Prepare for Execution

```bash
/ralph-ryan prep
```

- Lists available PRDs
- Converts selected `prd.md` → `prd.json`
- Initializes `progress.txt`

### 3. Check Status

```bash
/ralph-ryan status
```

Shows overview of all PRDs:
- Progress (X/Y stories done)
- Lock status
- Conflict warnings
- Next story to execute

### 4. Execute

```bash
/ralph-loop:ralph-loop "Load skill ralph-ryan and execute run mode." --max-iterations 10 --completion-promise COMPLETE
```

Ralph will:
1. Pick highest priority story with `passes: false`
2. Implement → Quality checks → Commit
3. Update `prd.json` and `progress.txt`
4. Repeat until all stories pass

## Directory Structure

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

## Key Concepts

### Fresh Context

Each iteration starts clean. Memory persists via git history, `progress.txt`, and `prd.json`.

### Small Tasks

Each story should complete in one context window.

**Good:** Add a component, update an action, add a migration

**Too big:** Build entire dashboard, add authentication

## Plugin Structure

```
ralph-loop-ryan/
├── .claude-plugin/
│   └── plugin.json      # Plugin metadata
├── commands/
│   └── ralph-ryan.md    # /ralph-ryan command
└── skills/
    └── ralph-ryan/      # Skill files
        ├── SKILL.md     # Entry point with routing
        ├── prd.md       # PRD generation instructions
        ├── prep.md      # Preparation instructions
        ├── run.md       # Execution instructions
        └── status.md    # Status overview instructions
```

## Acknowledgments

This project is forked from [snarktank/ralph](https://github.com/snarktank/ralph) by [Ryan Carson](https://ampcode.com/).
