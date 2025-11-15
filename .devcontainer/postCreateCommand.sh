#!/bin/bash
set -euo pipefail

# Install uv for Python package management (required for Spec-kit)
curl -LsSf https://astral.sh/uv/install.sh | sh
# Ensure uv is on PATH for this session
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# Update npm first to avoid issues with global installs
npm install -g npm@latest

# Install GitHub Copilot CLI (Node package)
npm install -g @githubnext/github-copilot-cli

# Install Spec-kit CLI (Python)
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git

# Fetch and place AGENTS.md in the workspace root
curl -o AGENTS.md https://raw.githubusercontent.com/openai/agents.md/main/AGENTS.md

# Verify setup
specify check --ignore-agent-tools  # Skip AI tool checks if not all are installed
node --version
python --version
uv --version
echo "Dev environment setup complete. AGENTS.md is available in the root directory."