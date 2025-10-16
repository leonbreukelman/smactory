#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SPEC_DIR="$ROOT_DIR/.specify"
RUNS_DIR="$SPEC_DIR/runs"
JOURNAL_DIR="$SPEC_DIR/journals"
DECISIONS_DIR="$SPEC_DIR/memory/decisions"
CONTEXT_FILE="$SPEC_DIR/memory/context.md"

usage() {
  cat <<'EOF'
Speckit: lightweight spec-driven development runner

Usage:
  ./speckit.sh specify        # scaffold .specify/spec.md from template
  ./speckit.sh ai-plan        # print Copilot prompt and prepare .specify/plan.md
  ./speckit.sh ai-tasks       # print Copilot prompt and prepare .specify/tasks.md
  ./speckit.sh plan           # snapshot .specify/tasks.md into a timestamped run folder
  ./speckit.sh implement      # create a working branch and print Copilot prompts to apply
  ./speckit.sh verify         # run linters and tests
  ./speckit.sh run-all        # plan -> implement (branch only) -> verify
EOF
}

require_file() {
  local path="$1"
  if [[ ! -f "$path" ]]; then
    echo "Missing $path" >&2
    return 1
  fi
}

require_tasks() {
  local tasks="$SPEC_DIR/tasks.md"
  if [[ ! -f "$tasks" ]]; then
    echo "Missing $tasks. Create it from .specify/tasks.template.md or run: ./speckit.sh ai-tasks" >&2
    exit 1
  fi
}

timestamp() {
  date +"%Y%m%d-%H%M%S"
}

# Get Python executable, preferring venv
get_python() {
  if [[ -f ".venv/bin/python" ]]; then
    echo ".venv/bin/python"
  elif [[ -f "venv/bin/python" ]]; then
    echo "venv/bin/python"
  else
    echo "python"
  fi
}

# Initialize daily journal
init_journal() {
  mkdir -p "$JOURNAL_DIR" "$DECISIONS_DIR"
  local today; today="$(date +%Y-%m-%d)"
  local journal="$JOURNAL_DIR/${today}-session.md"

  if [[ ! -f "$journal" ]]; then
    local branch; branch="$(git branch --show-current 2>/dev/null || echo 'N/A')"
    cat > "$journal" <<EOF
# Agent Session Journal - ${today}

## Session Metadata
- **Start Time**: $(date +%Y-%m-%d\ %H:%M:%S)
- **Agent Type**: GitHub Copilot
- **Context**: Branch=${branch}, Run=N/A
- **Goal**: TBD

## Actions Taken

---

## Decisions Made

---

## Session Outcomes
- **Completed Tasks**:
- **Deferred Tasks**:
- **New Issues Found**:
- **Quality Metrics**:
  - Coverage: N/A
  - Linter: N/A
  - Type Check: N/A

## Next Session
**Planned Actions**:
**Context to Preserve**:
EOF
    echo "📔 Created journal: $journal" >&2
  fi
  echo "$journal"
}

# Log action to journal
log_action() {
  local action_type="$1"
  local description="$2"
  local journal; journal="$(init_journal)"
  local timestamp; timestamp="$(date +%Y-%m-%d\ %H:%M:%S)"

  cat >> "$journal" <<EOF

### ${timestamp} - ${action_type}
${description}

---
EOF
}

# Update context
update_context() {
  local branch; branch="$(git branch --show-current 2>/dev/null || echo 'N/A')"
  local timestamp; timestamp="$(date +%Y-%m-%d\ %H:%M:%S)"

  cat > "$CONTEXT_FILE" <<EOF
# Current Development Context
Last Updated: ${timestamp}

## Active Work
- Branch: ${branch}
- Spec Run: ${CURRENT_RUN:-N/A}
- Current Task: See .specify/tasks.md

## Recent Changes
${1:-No recent changes}

## Known Issues
${2:-None}

## Next Steps
${3:-TBD}
EOF
  log_action "Context Update" "Updated context.md with current state"
}

plan() {
  require_tasks
  mkdir -p "$RUNS_DIR"
  local ts; ts="$(timestamp)"
  local run_dir="$RUNS_DIR/$ts"
  mkdir -p "$run_dir"
  cp "$SPEC_DIR/tasks.md" "$run_dir/tasks.md"
  echo "Created plan at $run_dir"
}

specify() {
  mkdir -p "$SPEC_DIR"
  local tmpl="$SPEC_DIR/spec.template.md"
  local out="$SPEC_DIR/spec.md"

  init_journal

  if [[ -f "$out" ]]; then
    echo "Spec already exists at $out"
    log_action "Specify" "Attempted to create spec, but it already exists"
    return 0
  fi
  if ! require_file "$tmpl"; then
    echo "Create a template at $tmpl first (or ask Copilot to scaffold it)." >&2
    exit 1
  fi
  cp "$tmpl" "$out"
  echo "Created spec at $out"

  log_action "Specify" "Created new spec.md from template"
  update_context "Created new specification" "" "Complete spec.md, then run: ./speckit.sh ai-plan"

  echo "Open and complete the spec before running: ./speckit.sh ai-plan"
}

ai_plan() {
  local spec="$SPEC_DIR/spec.md"
  local plan="$SPEC_DIR/plan.md"
  local plan_tmpl="$SPEC_DIR/plan.template.md"

  init_journal

  if ! require_file "$spec"; then
    echo "No spec found. Run: ./speckit.sh specify" >&2
    exit 1
  fi
  if [[ ! -f "$plan" ]]; then
    if ! require_file "$plan_tmpl"; then
      echo "Missing plan template at $plan_tmpl" >&2
      exit 1
    fi
    cp "$plan_tmpl" "$plan"
    echo "Initialized plan at $plan"
  fi

  log_action "AI Planning" "Prepared plan.md for AI-assisted planning phase"

  cat <<'EOM'

Next steps (AI-assisted planning with Copilot Chat):
Open .specify/plan.md and paste the following prompt.

[Copilot Prompt: Generate plan.md]
You are the @architect agent. Read .specify/spec.md and .specify/memory/constitution.md.

**JOURNALING REQUIREMENTS**:
1. Document your planning process in today's journal (run: init_journal to get path)
2. For each architectural decision:
   - Create ADR in .specify/memory/decisions/YYYY-MM-DD-brief-title.md
   - Log decision in journal with options considered
   - Reference ADR in plan.md
3. Update .specify/memory/context.md when planning is complete

**PLANNING REQUIREMENTS**:
- Keep scope small and shippable
- List architecture decisions, data models, API contracts
- Include security/performance notes per constitution.md
- Create Test Plan with >=90% coverage target
- Reference all constraints (types, ruff, mypy --strict, TDD)

Do not implement code; produce only the plan.

When done, run: ./speckit.sh ai-tasks
EOM
}

ai_tasks() {
  local plan="$SPEC_DIR/plan.md"
  local tasks="$SPEC_DIR/tasks.md"
  local tasks_tmpl="$SPEC_DIR/tasks.template.md"

  init_journal

  if ! require_file "$plan"; then
    echo "No plan found. Run: ./speckit.sh ai-plan" >&2
    exit 1
  fi
  if [[ ! -f "$tasks" ]]; then
    if ! require_file "$tasks_tmpl"; then
      echo "Missing tasks template at $tasks_tmpl" >&2
      exit 1
    fi
    cp "$tasks_tmpl" "$tasks"
    echo "Initialized tasks at $tasks"
  fi

  log_action "AI Task Breakdown" "Prepared tasks.md for AI-assisted task generation"

  cat <<'EOM'

Next steps (AI-assisted task breakdown with Copilot Chat):
Open .specify/tasks.md and paste the following prompt.

[Copilot Prompt: Generate tasks.md]
You are the task breakdown agent. Read .specify/plan.md and .specify/memory/constitution.md.

**JOURNALING REQUIREMENTS**:
1. Log task generation process in today's journal
2. Note any assumptions or constraints discovered
3. Update .specify/memory/context.md with task count and estimates

**TASK REQUIREMENTS**:
- Generate granular, ordered, TDD-first task list
- Create tests BEFORE implementation files
- Include acceptance criteria per task
- Add observable outcomes (test pass, coverage %, etc.)
- Keep tasks minimal and independently verifiable
- Call out required CI, lint, or typing updates

Replace content of .specify/tasks.md with the task list.

When done, run: ./speckit.sh implement
EOM
}

implement() {
  require_tasks

  local ts; ts="$(timestamp)"
  local branch="spec/$ts"
  local run_dir="$RUNS_DIR/$ts"

  export CURRENT_RUN="$ts"

  mkdir -p "$run_dir"
  cp "$SPEC_DIR/tasks.md" "$run_dir/tasks.md"

  # Create run-specific journal
  local run_journal="$run_dir/journal.md"
  cat > "$run_journal" <<EOF
# Implementation Journal - Run $ts

## Run Metadata
- **Run ID**: $ts
- **Branch**: $branch
- **Tasks File**: .specify/runs/$ts/tasks.md
- **Start Time**: $(date +%Y-%m-%d\ %H:%M:%S)

## Implementation Log

<!-- Copilot: Log each task completion here -->

## Outcomes
<!-- Copilot: Summarize what was accomplished -->
EOF

  if git rev-parse --git-dir >/dev/null 2>&1; then
    git switch -c "$branch"
    echo "Created and switched to branch: $branch"
    log_action "Implementation Start" "Created branch $branch and run directory $run_dir"
  else
    echo "Not a git repo; skipping branch creation." >&2
  fi

  # Initialize or get daily journal
  local daily_journal; daily_journal="$(init_journal)"

  update_context \
    "Started implementation run $ts" \
    "" \
    "Implement tasks from .specify/tasks.md, then run: ./speckit.sh verify"

  cat <<EOM

✅ Implementation environment ready

**Journals**:
- Daily: $daily_journal
- Run: $run_journal

Next steps (AI-assisted implementation with Copilot Chat):
1) Open .specify/tasks.md and relevant source files
2) Open the daily journal: $daily_journal
3) In Copilot Chat, paste the following system prompt:

[Implementation Agent Prompt]
You are implementing tasks from .specify/tasks.md for run $ts.

**JOURNALING REQUIREMENTS** (CRITICAL):
Before, during, and after each task:

1. **Read Context First**:
   - Read .specify/memory/context.md for current state
   - Read $daily_journal for today's work
   - Read $run_journal for this implementation run

2. **Log Every Action**:
   - Document in $daily_journal:
     * Timestamp, task ID, files modified
     * Test commands run and results
     * Any decisions or observations
   - Document in $run_journal:
     * Task completion status
     * Code changes summary
     * Test results

3. **Create Decision Records**:
   - For architectural choices, create:
     .specify/memory/decisions/YYYY-MM-DD-brief-title.md
   - Log in journal: "Decision recorded in ADR-XXX"

4. **Update Context**:
   - After significant changes, update .specify/memory/context.md
   - Include: current task, recent changes, known issues, next steps

**IMPLEMENTATION RULES**:
- Make minimal, incremental diffs
- Run tests locally and keep them green
- Update or add unit tests as you change behavior
- Maintain docstrings and typing per constitution.md
- Follow TDD: test first, then implementation

**REPORTING**:
When editing files, show unified diff with context.
After each task, confirm:
✅ Tests pass
✅ Coverage maintained/improved
✅ Journal updated
✅ Context current

4) After applying changes, run: ./speckit.sh verify

EOM
}

verify() {
  pushd "$ROOT_DIR" >/dev/null

  local journal; journal="$(init_journal)"
  local timestamp; timestamp="$(date +%Y-%m-%d\ %H:%M:%S)"

  echo "" >> "$journal"
  echo "## Verification Run - $timestamp" >> "$journal"
  echo "" >> "$journal"

  local verify_output; verify_output=$(mktemp)
  local exit_code=0

  echo "Running Ruff..."
  if ruff check . | tee -a "$verify_output"; then
    echo "✅ Ruff: Pass" >> "$journal"
  else
    echo "❌ Ruff: Failed" >> "$journal"
    exit_code=1
  fi

  local python_exe; python_exe="$(get_python)"

  echo "Running mypy..."
  if PYTHONPATH="src:${PYTHONPATH-}" "$python_exe" -m mypy src | tee -a "$verify_output"; then
    echo "✅ Mypy: Pass" >> "$journal"
  else
    echo "❌ Mypy: Failed" >> "$journal"
    exit_code=1
  fi

  echo "Running pytest..."
  if PYTHONPATH="src:${PYTHONPATH-}" "$python_exe" -m pytest -q --maxfail=1 --disable-warnings \
    --cov=src --cov-report=term-missing | tee -a "$verify_output"; then
    echo "✅ Pytest: Pass" >> "$journal"

    # Extract coverage percentage
    local coverage; coverage=$(grep -oP '\d+%' "$verify_output" | tail -1 || echo "N/A")
    echo "📊 Coverage: $coverage" >> "$journal"
  else
    echo "❌ Pytest: Failed" >> "$journal"
    exit_code=1
  fi

  rm -f "$verify_output"

  if [[ $exit_code -eq 0 ]]; then
    echo "" >> "$journal"
    echo "**Result**: All checks passed ✅" >> "$journal"
    update_context \
      "Verification passed successfully" \
      "" \
      "Review changes, update tasks.md, continue implementation"
  else
    echo "" >> "$journal"
    echo "**Result**: Some checks failed ❌" >> "$journal"
    echo "See output above for details" >> "$journal"
    update_context \
      "Verification failed - see journal for details" \
      "Linting, typing, or test failures" \
      "Fix errors, then re-run: ./speckit.sh verify"
  fi

  popd >/dev/null
  return $exit_code
}

case "${1:-}" in
  specify) specify ;;
  ai-plan) ai_plan ;;
  ai-tasks) ai_tasks ;;
  plan) plan ;;
  implement) implement ;;
  verify) verify ;;
  journal) init_journal ;;  # New: manual journal access
  run-all) plan; implement; verify ;;
  -h|--help|"") usage ;;
  *) echo "Unknown command: $1" >&2; usage; exit 2 ;;
esac
