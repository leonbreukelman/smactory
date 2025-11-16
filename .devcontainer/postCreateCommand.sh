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

# Patch Cognee to fix SyntaxWarning in cognee_network_visualization.py
sed -i '95s/html_template = """/html_template = r"""/' .venv/lib/python3.12/site-packages/cognee/modules/visualization/cognee_network_visualization.py

# Create basic pyproject.toml for uv and Spec-kit compatibility
cat << 'EOF' > pyproject.toml
[project]
name = "smactory"
version = "0.1.0"

[tool.uv]
EOF

# Create custom AGENTS.md in the workspace root (self-contained)
cat << 'EOF' > AGENTS.md
# AGENTS.md

This file provides context and instructions for AI coding agents working on this project. It complements the human-focused README.md.

## Project Overview
This repository sets up a development environment for AI agent projects using a dev container with Python 3.12, Node.js 20, Spec-kit CLI for specification management, and Cognee for AI memory handling. The environment supports prototyping AI agents with persistent memory, state management, and declarative workflows.

## Setup Commands
- Initialize the dev container: Use VS Code with the Dev Containers extension to open the repository.
- Post-create setup: Run `.devcontainer/postCreateCommand.sh` to install uv, Spec-kit, Cognee, and other dependencies.
- Verify environment: Execute `specify check`, `node --version`, `python --version`, and `python -c "import cognee; print(cognee.__version__)"`.

## Code Style Guidelines
- **Python**: Follow PEP 8 standards. Use single quotes, 4-space indentation, and type hints. Prefer functional patterns where applicable.
- **JavaScript/TypeScript**: Use ESLint rules (configured via extensions). Single quotes, no semicolons, strict mode enabled.
- **General**: Limit lines to 100 characters. Avoid `@ts-ignore` or equivalent suppressions. Document functions with docstrings or JSDoc.

## Build and Run Commands
- Install Python dependencies: `uv sync` (using uv for package management).
- Install Node dependencies: `npm install`.
- Run Spec-kit tasks: `specify <command>` (e.g., `specify check` for validation).
- Use Cognee CLI (if needed): `cognee-cli -ui` to launch the local UI dashboard.
- Example AI agent script: `python agent.py` (adapt based on your implementation).

## Testing Guidelines
- Use pytest for Python tests: `uv run pytest`.
- Use Jest or Vitest for Node tests: `npm test`.
- Focus on unit tests for memory management (e.g., Cognee add, cognify, and search operations) and integration tests for AI agent workflows.
- Run linters: `uv run black .` for Python formatting; `npm run lint` for JavaScript.

## Architecture and Design Patterns
- **Core Stack**: Dev container based on Microsoft's universal image, with Python and Node features.
- **AI Components**: Integrate Spec-kit for declarative specifications. Use Cognee for long-term memory (embeddings, persistence). Support frameworks like LangChain or LangGraph if extended.
- **Patterns**: Employ agentic workflows with tools, memory retrieval, and state persistence. Favor modular design for scalability.
- **Extensions**: VS Code extensions for Copilot, Python, ESLint are pre-configured.

## Security Considerations
- Environment variables: Store API keys (e.g., for external AI services) in `.env` and load via `dotenv`.
- Data Handling: Ensure Cognee stores non-sensitive data only; implement access controls if persisting user information.
- Dependencies: Pin versions with uv and npm for reproducibility.

## Pull Request Instructions
- Title format: `[component] <Descriptive Title>` (e.g., `[cognee] Add memory retrieval example`).
- Before committing: Run linters and tests.
- Description: Include changes, rationale, and any AI agent interactions tested.

For nested structures in monorepos, use subdirectory AGENTS.md files as needed.
EOF

# Initialize Node.js project to create package.json
npm init -y

# Install global NPM packages or initialize if needed (expand as per project)
npm install -g npm@latest

# Verify setup
specify check
node --version
python --version
python -c "import cognee; print('cognee version:', cognee.__version__)"  # Verify Cognee installation
echo "Dev environment setup complete. AGENTS.md is available in the root directory."