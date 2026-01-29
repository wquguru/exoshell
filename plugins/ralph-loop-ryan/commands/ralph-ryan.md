---
description: Create a new PRD for Ralph autonomous development
argument-hint: <feature description>
allowed-tools: [Read, Write, Glob, Grep, Bash, AskUserQuestion]
---

# Ralph PRD Command

Create a new Product Requirements Document for Ralph autonomous execution.

## Arguments

The user invoked this command with: $ARGUMENTS

## Instructions

Load the ralph-ryan skill and execute PRD mode with the provided feature description.

1. Read the skill file at `skills/ralph-ryan/SKILL.md` to understand routing
2. Based on the "prd" intent, read `skills/ralph-ryan/prd.md`
3. Follow the PRD generation instructions with the user's feature description

## Usage

```
/ralph-ryan prd Add a task priority system with filtering
```
