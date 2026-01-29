#!/bin/bash

# Ralph Ryan Loop Setup Script
# Creates state file for in-session Ralph loop (PRD-specific)

set -euo pipefail

# Parse arguments
PRD_SLUG=""
MAX_ITERATIONS=0
COMPLETION_PROMISE="COMPLETE"

print_help() {
  cat << 'HELP_EOF'
Ralph Ryan Loop - Multi-PRD autonomous development loop

USAGE:
  setup-ralph-ryan-loop.sh <prd-slug> [OPTIONS]

ARGUMENTS:
  prd-slug    The PRD directory name to execute (required)

OPTIONS:
  --max-iterations <n>    Maximum iterations before auto-stop (default: unlimited)
  -h, --help              Show this help message

DESCRIPTION:
  Starts a Ralph Loop for a specific PRD. The stop hook prevents
  exit and feeds the prompt back until completion or iteration limit.

  Completion is detected when Claude outputs: <promise>COMPLETE</promise>

EXAMPLES:
  setup-ralph-ryan-loop.sh prd-06-risk-management
  setup-ralph-ryan-loop.sh prd-06-risk-management --max-iterations 20

STOPPING:
  - Output <promise>COMPLETE</promise> when all stories pass
  - Reach --max-iterations limit
  - Run /ralph-ryan cancel <prd-slug>
HELP_EOF
}

# Parse options
while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      print_help
      exit 0
      ;;
    --max-iterations)
      if [[ -z "${2:-}" ]] || ! [[ "$2" =~ ^[0-9]+$ ]]; then
        echo "❌ Error: --max-iterations requires a positive integer" >&2
        exit 1
      fi
      MAX_ITERATIONS="$2"
      shift 2
      ;;
    *)
      if [[ -z "$PRD_SLUG" ]]; then
        PRD_SLUG="$1"
      else
        echo "❌ Error: Unexpected argument: $1" >&2
        exit 1
      fi
      shift
      ;;
  esac
done

# Validate PRD slug
if [[ -z "$PRD_SLUG" ]]; then
  echo "❌ Error: PRD slug is required" >&2
  echo "" >&2
  echo "   Usage: setup-ralph-ryan-loop.sh <prd-slug> [--max-iterations N]" >&2
  echo "" >&2
  echo "   Available PRDs:" >&2
  if [[ -d ".claude/ralph-ryan" ]]; then
    for dir in .claude/ralph-ryan/*/; do
      if [[ -f "${dir}prd.json" ]]; then
        echo "     - $(basename "$dir")" >&2
      fi
    done
  else
    echo "     (none found)" >&2
  fi
  exit 1
fi

PRD_DIR=".claude/ralph-ryan/$PRD_SLUG"

# Check PRD directory exists
if [[ ! -d "$PRD_DIR" ]]; then
  echo "❌ Error: PRD directory not found: $PRD_DIR" >&2
  echo "" >&2
  echo "   Available PRDs:" >&2
  for dir in .claude/ralph-ryan/*/; do
    if [[ -f "${dir}prd.json" ]]; then
      echo "     - $(basename "$dir")" >&2
    fi
  done
  exit 1
fi

# Check prd.json exists
if [[ ! -f "$PRD_DIR/prd.json" ]]; then
  echo "❌ Error: prd.json not found in $PRD_DIR" >&2
  echo "" >&2
  echo "   Run '/ralph-ryan prep' first to prepare this PRD." >&2
  exit 1
fi

# Check if another loop is already active for this PRD
if [[ -f "$PRD_DIR/ralph-loop.local.md" ]]; then
  echo "⚠️  Warning: A loop is already active for $PRD_SLUG" >&2
  echo "   Overwriting previous loop state..." >&2
fi

# Build the prompt
PROMPT="Load skill ralph-ryan and execute run mode for $PRD_SLUG.

IMPORTANT: You are in a Ralph loop. Follow these rules:
1. Read $PRD_DIR/prd.json to find the next story (passes: false)
2. Implement ONE story only
3. Run quality checks, commit changes
4. Update prd.json (set passes: true, add filesChanged)
5. Update progress.txt with learnings
6. If ALL stories pass, archive and output <promise>COMPLETE</promise>
7. Otherwise, end normally (loop will continue)"

# Create state file
STATE_FILE="$PRD_DIR/ralph-loop.local.md"

cat > "$STATE_FILE" <<EOF
---
active: true
iteration: 1
max_iterations: $MAX_ITERATIONS
completion_promise: "COMPLETE"
prd_slug: "$PRD_SLUG"
started_at: "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
---

$PROMPT
EOF

# Output setup message
cat <<EOF
🔄 Ralph Ryan loop activated for PRD: $PRD_SLUG

Iteration: 1
Max iterations: $(if [[ $MAX_ITERATIONS -gt 0 ]]; then echo $MAX_ITERATIONS; else echo "unlimited"; fi)
Completion: Output <promise>COMPLETE</promise> when all stories pass

State file: $STATE_FILE

⚠️  The loop will run until:
    - All stories complete (outputs COMPLETE)
    - Max iterations reached
    - You run /ralph-ryan cancel $PRD_SLUG

EOF

# Output the prompt
echo "$PROMPT"

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "CRITICAL - Ralph Loop Rules"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "To complete this loop, output: <promise>COMPLETE</promise>"
echo ""
echo "ONLY output this when ALL stories in prd.json have passes: true"
echo "Do NOT lie to exit the loop early!"
echo "═══════════════════════════════════════════════════════════"
