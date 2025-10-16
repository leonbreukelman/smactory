# AI-Native Gap Remediation Plan

This plan closes the gaps identified against the awesome-ai-native developer experience. It includes concrete diffs and a step-by-step instruction set for the coding agent. All steps assume WSL/Ubuntu bash; no PowerShell/Windows-specific support is required.

## Selected SDD pipeline

- Choice: Lightweight local SpecKit (bash) runner via `speckit.sh`.
- Rationale: Fits this small Python repo, keeps loop simple (plan → implement with Copilot Chat → verify), no infra/secrets, and aligns with your WSL-only requirement.

## Diffs to apply

1) Ensure pytest imports work by putting `src` on PYTHONPATH during tests

- Create `tests/conftest.py`:

```
from pathlib import Path
import os
import sys

# Ensure 'src' is on sys.path for test imports like 'from math_utils import add'
REPO_ROOT = Path(__file__).resolve().parents[1]
SRC = REPO_ROOT / "src"
if SRC.exists():
    sys.path.insert(0, str(SRC))
    os.environ.setdefault("PYTHONPATH", str(SRC))
```

- Update CI to set PYTHONPATH for mypy and pytest in `.github/workflows/quality-assurance.yml`:

```
# ...existing steps...
      - name: Run mypy
        env:
          PYTHONPATH: src
        run: mypy src tests
# ...existing steps...
      - name: Run tests with pytest
        env:
          PYTHONPATH: src
        run: |
          pytest -q --maxfail=1 --disable-warnings --cov=src --cov-report=term-missing
# ...existing steps...
```

2) Copy Copilot instructions into recognized location

- Create `.github/copilot-instructions.md` as a verbatim copy of `.github/instructions/python.instructions.md` content to ensure repo-scoped instructions are picked up by Copilot.

3) Implement a minimal SpecKit pipeline (bash-only)

- Replace `speckit.sh` with this bash-only runner that supports plan/implement/verify and a combined run-all. It does not attempt Windows/PowerShell support.

```
#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SPEC_DIR="$ROOT_DIR/.specify"
RUNS_DIR="$SPEC_DIR/runs"

usage() {
  cat <<'EOF'
Speckit: lightweight spec-driven development runner

Usage:
  ./speckit.sh plan           # snapshot .specify/tasks.md into a timestamped run folder
  ./speckit.sh implement      # create a working branch and print Copilot prompts to apply
  ./speckit.sh verify         # run linters and tests
  ./speckit.sh run-all        # plan -> implement (branch only) -> verify
EOF
}

require_tasks() {
  local tasks="$SPEC_DIR/tasks.md"
  if [[ ! -f "$tasks" ]]; then
    echo "Missing $tasks. Create it from .specify/tasks.template.md" >&2
    exit 1
  fi
}

timestamp() {
  date +"%Y%m%d-%H%M%S"
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

implement() {
  require_tasks
  local ts; ts="$(timestamp)"
  local branch="spec/$ts"
  if git rev-parse --git-dir >/dev/null 2>&1; then
    git switch -c "$branch"
    echo "Created and switched to branch: $branch"
  else
    echo "Not a git repo; skipping branch creation." >&2
  fi

  cat <<'EOM'

Next steps (manual, assisted by Copilot Chat):
1) Open .specify/tasks.md and the relevant source files.
2) In Copilot Chat, paste the following system prompt to drive changes:

[Prompt]
You are implementing the tasks defined in .specify/tasks.md for this repository.
- Make minimal, incremental diffs.
- Run tests locally and keep them green.
- Update or add unit tests as you change behavior.
- Maintain docstrings and typing.
When editing files, show a unified diff with context.

3) After applying changes, run: ./speckit.sh verify

EOM
}

verify() {
  pushd "$ROOT_DIR" >/dev/null
  echo "Running Ruff..."
  ruff check .
  echo "Running mypy..."
  PYTHONPATH="src:${PYTHONPATH-}" mypy src
  echo "Running pytest..."
  PYTHONPATH="src:${PYTHONPATH-}" pytest -q --maxfail=1 --disable-warnings --cov=src --cov-report=term-missing
  popd >/dev/null
}

case "${1:-}" in
  plan) plan ;;
  implement) implement ;;
  verify) verify ;;
  run-all) plan; implement; verify ;;
  -h|--help|"") usage ;;
  *) echo "Unknown command: $1" >&2; usage; exit 2 ;;
esac
```

- Add `.specify/tasks.template.md` as a starter file developers can copy to `.specify/tasks.md`:

```
# Tasks

- Task: Short description of the change
  Rationale: Why this change is needed
  Acceptance criteria:
    - [ ] Observable outcome 1
    - [ ] Observable outcome 2

Notes:
- Keep tasks small; prefer multiple short tasks to one large one.
```

## Step-by-step instruction set for the coding agent

1) Fix test imports
- Create `tests/conftest.py` with the snippet above.
- Verify locally:
  - Ensure dev deps are installed in your WSL venv.
  - Run: `PYTHONPATH=src pytest -q` and confirm tests pass.

2) Update CI for PYTHONPATH
- Edit `.github/workflows/quality-assurance.yml` to add `env: PYTHONPATH: src` on the mypy and pytest steps as shown.
- Open a branch and confirm CI passes.

3) Copy Copilot instructions
- Create `.github/copilot-instructions.md` by copying the full content of `.github/instructions/python.instructions.md` verbatim. Do not delete the original.

4) Implement SpecKit pipeline
- Replace `speckit.sh` with the script above and make it executable: `chmod +x ./speckit.sh` (in WSL).
- Add `.specify/tasks.template.md` and create `.specify/tasks.md` from it with your real tasks.
- Dry run:
  - `./speckit.sh plan`
  - `./speckit.sh implement` (will create a git branch when inside a git repo)
  - Make a small code change guided by Copilot Chat.
  - `./speckit.sh verify`

5) PR and review
- Commit and push your branch.
- Open a PR and ensure the CI jobs pass.

Notes:
- This plan intentionally avoids PowerShell/Windows support; use WSL/Ubuntu bash.
- If later you want auto-apply of prompts, extend `speckit.sh` to generate and apply patch files, still gated by `verify`.
