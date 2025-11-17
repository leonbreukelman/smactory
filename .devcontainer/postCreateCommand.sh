#!/bin/bash

# Install uv for Python package management (required for Spec-kit)
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.cargo/bin:$PATH"

# Create a virtual environment using uv
uv venv --clear .venv

# Activate the venv (this can be automated or run manually in the terminal)
source .venv/bin/activate

# Install Spec-kit CLI
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git

# Install Cognee as a Python library (primarily used programmatically, with optional CLI features)
# This will be available for import in Python scripts
# Dependencies
uv pip install protego>=0.1.0
uv pip install playwright
playwright install --with-deps
# Cognee with PostgreSQL support
uv pip install "cognee[postgres]"

# NEW: Install GitHub CLI and openssl if not present; consolidate apt updates (AI-first automation, reduce sudo calls)
sudo apt-get update
sudo apt-get install -y gh openssl

# Configure sudo to not require password for codespace user (fixes prompt issues)
echo "codespace ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/codespace > /dev/null
sudo chmod 0440 /etc/sudoers.d/codespace

# NEW: Install and configure PostgreSQL for Cognee memory persistence
if ! command -v psql &> /dev/null; then
  sudo apt-get install -y postgresql postgresql-contrib
  sudo service postgresql start
  
  # Use default temp password for initial setup (updated post-bootstrap via setup_secrets.py)
  TEMP_DB_PASSWORD="cognee_pass"
  
  sudo -u postgres psql -c "CREATE USER cognee_user WITH PASSWORD '$TEMP_DB_PASSWORD';"
  sudo -u postgres psql -c "CREATE DATABASE cognee_db OWNER cognee_user;"
  sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE cognee_db TO cognee_user;"
  echo "PostgreSQL setup complete. Credentials: user=cognee_user, db=cognee_db (default password: cognee_pass - update via setup_secrets.py)."
fi

# Export DB URL for Cognee (password from env/secrets; persistent, with default fallback)
cat << 'EOF' >> ~/.bashrc
export COGNEE_DB_PASSWORD=${COGNEE_DB_PASSWORD:-"cognee_pass"}
export COGNEE_DB_URL="postgresql://cognee_user:${COGNEE_DB_PASSWORD}@localhost:5432/cognee_db"
EOF
source ~/.bashrc

# Patch Cognee to fix SyntaxWarning in cognee_network_visualization.py
sed -i '95s/html_template = """/html_template = r"""/' .venv/lib/python3.12/site-packages/cognee/modules/visualization/cognee_network_visualization.py

# Create basic pyproject.toml for uv and Spec-kit compatibility
cat << 'EOF' > pyproject.toml
[project]
name = "smactory"
version = "0.1.0"
requires-python = ">=3.12"
[tool.uv]
EOF

# Create custom AGENTS.md in the workspace root (self-contained)
cat << 'EOF' > AGENTS.md
# AGENTS.md

This file provides context and instructions for AI coding agents working on this project. It complements the human-focused README.md.

## Project Overview
This repository sets up an AI-first development environment for agentic workflows using a dev container with Python 3.12, Node.js 22, Spec-kit CLI for declarative specifications, Cognee for persistent AI memory (with PostgreSQL backend and LLM integration), Goose for reasoning loops, and GitHub Copilot CLI for AI-assisted ops. The stack supports prototyping autonomous agents with memory retrieval, state management, declarative task orchestration, scalable reasoning, and self-reflective patterns. Environment variables/secrets (e.g., LLM_API_KEY, XAI_API_KEY) are injected via GitHub for secure, hands-off autonomy.

## Setup Commands
- Initialize the dev container: Use VS Code with the Dev Containers extension to open the repository.
- Post-create setup: Run `.devcontainer/postCreateCommand.sh` to install uv, Spec-kit, Cognee (with PostgreSQL), Goose, GitHub Copilot CLI, and other dependencies. PostgreSQL auto-starts with `COGNEE_DB_URL` from secrets; LLM_API_KEY required for Cognee.
- Verify environment: Execute `specify check`, `node --version` (expect 22.x), `python --version`, `python -c "import cognee; print(cognee.__version__)"`, `goose info`, `copilot --version`, and `PGPASSWORD=$COGNEE_DB_PASSWORD psql -h localhost -U cognee_user -d cognee_db -c "\conninfo"` (for DB check). Echo $LLM_API_KEY to confirm.

## Code Style Guidelines
- **Python**: Follow PEP 8 standards. Use single quotes, 4-space indentation, and type hints. Prefer async/functional patterns for agentic loops (e.g., await Cognee ops).
- **JavaScript/TypeScript**: Use ESLint rules (configured via extensions). Single quotes, no semicolons, strict mode enabled.
- **General**: Limit lines to 100 characters. Avoid `@ts-ignore` or equivalent suppressions. Document functions with docstrings or JSDoc. Prioritize AI-readable code for self-reflection (e.g., explicit async handling).

## Build and Run Commands
- Install Python dependencies: `uv sync` (using uv for package management).
- Install Node dependencies: `npm install`.
- Run Spec-kit tasks: `specify <command>` (e.g., `specify check` for validation).
- Run Cognee CLI (if needed): `cognee-cli -ui` to launch the local UI dashboard (requires `COGNEE_DB_URL` and LLM_API_KEY).
- Run Goose: `goose` for interactive sessions; integrate via subprocess in scripts for automation.
- Example AI agent script: `uv run python agent.py --task "Your declarative task here"` (uses Spec-kit specs, Cognee memory, and Goose reasoning). Set LLM_API_KEY for cognify.
- GitHub Copilot CLI: `copilot explain "command"` for AI-assisted ops.

## Testing Guidelines
- Use pytest for Python tests: `uv run pytest`.
- Use Jest or Vitest for Node tests: `npm test`.
- Focus on unit tests for memory management (e.g., Cognee add/cognify/search with PostgreSQL queries) and integration tests for agent workflows (e.g., async reasoning loops with Goose).
- Run linters: `uv run black .` for Python formatting; `npm run lint` for JavaScript.
- AI-specific: Test agent self-reflection by simulating failures and verifying memory recall (e.g., via test_cognee.py).

## Architecture and Design Patterns
- **Core Stack**: Dev container based on Microsoft's universal image, with Python/Node features, PostgreSQL for persistence.
- **AI Components**: Spec-kit for declarative task specs (e.g., YAML-driven workflows). Cognee for long-term memory (embeddings, graphs via PostgreSQL and LLM). Goose for dynamic reasoning loops (integrated async in agents). GitHub Copilot CLI for command-line augmentation.
- **Patterns**: Agentic workflows with tools, memory retrieval, and state persistence. Use reasoning-react loops (e.g., in agent.py: reason → act → remember). Favor modular, async design for scalability to multi-agent panels. Self-configure via env/secrets (e.g., LLM_API_KEY for Cognify).
- **Extensions**: VS Code extensions for Copilot, Python, ESLint pre-configured. Goose extensions (e.g., developer mode) enabled by default.

## Security Considerations
- Environment variables: Store API keys (e.g., LLM_API_KEY for Cognee, XAI_API_KEY for Goose) via GitHub Secrets; auto-injected on rebuild. Use row-level security if scaling to user data.
- Data Handling: Cognee/PostgreSQL stores non-sensitive agent state only; implement row-level security if scaling to user data.
- Dependencies: Pin versions with uv and npm for reproducibility. Avoid plain-text secrets in configs (e.g., Goose uses env vars; PostgreSQL passwords via secrets).

## Pull Request Instructions
- Title format: `[component] <Descriptive Title>` (e.g., `[goose] Integrate reasoning loop in agent.py`).
- Before committing: Run linters, tests, and agent simulations (e.g., via agent.py with sample specs).
- Description: Include changes, rationale, AI agent interactions tested, and any memory/state updates.

For nested structures in monorepos, use subdirectory AGENTS.md files as needed. Evolve toward full autonomy: Agents should self-update this file via reasoning loops.
EOF

# Create setup_secrets.py for post-bootstrap secret configuration
cat << 'EOF' > setup_secrets.py
import os
import subprocess
import secrets  # For random key gen if needed

def setup_secret(key_name, description, generate_if_missing=False):
    """AI-first secret setup: Check env, prompt/set via GH CLI."""
    if os.getenv(key_name):
        print(f"{key_name} already set in env—skipping.")
        return
    print(f"{description} (e.g., {key_name}) not found.")
    value = input(f"Enter {key_name} (or leave blank to {'generate' if generate_if_missing else 'skip'}): ").strip()
    if not value and generate_if_missing:
        value = secrets.token_hex(32)  # Secure random (e.g., for DB pass)
        print(f"Generated: {value}")
    if value:
        subprocess.run(["gh", "secret", "set", key_name, "--app", "codespaces", "--body", value])
        print(f"{key_name} set—rebuild Codespace to inject.")
    else:
        print(f"Skipped {key_name}—set manually in UI.")

if __name__ == "__main__":
    setup_secret("LLM_API_KEY", "OpenAI API key for Cognee embeddings/cognify")
    setup_secret("COGNEE_DB_PASSWORD", "PostgreSQL password for Cognee DB", generate_if_missing=True)
    setup_secret("XAI_API_KEY", "xAI key for Goose reasoning")
    print("Setup complete. Rebuild for changes to take effect.")
EOF

# Initialize Node.js project to create package.json
npm init -y

# Install global NPM packages or initialize if needed (expand as per project)
npm install -g npm@latest

# Install GitHub Copilot CLI (official: https://docs.github.com/copilot/how-tos/set-up/install-copilot-cli)
npm install -g @github/copilot

# Verify setup
specify check
node --version
python --version
python -c "import cognee; print('cognee version:', cognee.__version__)"  # Verify Cognee installation
copilot --version  # Verify GitHub Copilot CLI installation
PGPASSWORD=${COGNEE_DB_PASSWORD:-"cognee_pass"} psql -h localhost -U cognee_user -d cognee_db -c "\conninfo" || echo "PostgreSQL check failed"
echo "Dev environment setup complete. AGENTS.md is available in the root directory."
echo "Run 'uv run python setup_secrets.py' to configure secrets like LLM_API_KEY and update DB password."
