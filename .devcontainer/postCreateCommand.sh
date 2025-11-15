#!/bin/bash

# Install uv for Python package management (required for Spec-kit)
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.cargo/bin:$PATH"

# Install Spec-kit CLI
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git

# Fetch and place AGENTS.md in the workspace root
curl -o AGENTS.md https://raw.githubusercontent.com/openai/agents.md/main/AGENTS.md

# Install global NPM packages or initialize if needed (expand as per project)
npm install -g npm@latest

# Verify setup
specify check --ignore-agent-tools  # Skip AI tool checks if not all are installed
node --version
python --version
echo "Dev environment setup complete. AGENTS.md is available in the root directory."
