# Smactory: AI-First Autonomous Management Repository

[![GitHub license](https://img.shields.io/github/license/leonbreukelman/smactory)](https://github.com/leonbreukelman/smactory/blob/main/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/leonbreukelman/smactory)](https://github.com/leonbreukelman/smactory/issues)
[![GitHub stars](https://img.shields.io/github/stars/leonbreukelman/smactory)](https://github.com/leonbreukelman/smactory/stargazers)

## Overview

Smactory is an AI-first repository designed for autonomous management and prototyping of AI agents. It leverages official AI tools and integrations to enable self-setup and operation by AI agents, with human oversight for alignment. The core focus is on creating a development environment that supports persistent memory, state management, and declarative workflows using tools like Spec-kit and Cognee.

This repo is prepared autonomously by AI agents, following a single core setup document (see `.devcontainer/postCreateCommand.sh` and `AGENTS.md`). All configurations prioritize reuse of existing tested code over new generation, and installations reference official sources for verifiability.

**Key Stack**:
- **Languages/Runtimes**: Python 3.12, Node.js 20
- **Package Managers**: uv (for Python), NPM (for Node)
- **AI Tools**: Spec-kit CLI (for declarative specifications), Cognee (for AI memory handling with PostgreSQL support), GitHub Copilot, Copilot CLI
- **Environment**: Dev Container based on Microsoft's universal image
- **Other**: MCP servers (for managed compute, e.g., Microsoft Cloud Platform integrations)

The setup ensures reliable, agent-performable tasks to get the repo operational, with documentation updated to reflect exact commands and official references.

## Quick Start

To get started, clone the repo and use VS Code with Dev Containers for an autonomous setup.

1. **Prerequisites**:
   - Git installed
   - Visual Studio Code with the Dev Containers extension (official: [VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers))
   - Docker (for running the container)

2. **Clone the Repository**:
   ```
   git clone https://github.com/leonbreukelman/smactory.git
   cd smactory
   ```

3. **Open in VS Code**:
   - Launch VS Code: `code .`
   - When prompted, select "Reopen in Container" to build and start the dev environment.

4. **Post-Create Setup**:
   - The container automatically runs `.devcontainer/postCreateCommand.sh`, which handles all installations autonomously.
   - This script searches official sources for latest instructions (e.g., via web searches or MCP servers) and updates documentation with exact commands and references.
   - Example installs (as of current setup; always verify latest via official docs):
     - uv: Installed from [Astral's official installer](https://astral.sh/uv) with `curl -LsSf https://astral.sh/uv/install.sh | sh`
     - Spec-kit CLI: From [GitHub's spec-kit repo](https://github.com/github/spec-kit) via `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git`
     - Cognee: From PyPI with `uv pip install "cognee[postgres]"`, including dependencies like Playwright (official: [Playwright docs](https://playwright.dev/python/docs/intro))

5. **Verify Setup**:
   - In the VS Code terminal:
     ```
     source .venv/bin/activate
     python --version  # Should show 3.12.x
     node --version    # Should show 20.x
     specify check     # Validates Spec-kit
     python -c "import cognee; print(cognee.__version__)"  # Confirms Cognee
     ```
   - Setup complete message: "Dev environment setup complete. AGENTS.md is available in the root directory."

## Usage

- **Prototyping AI Agents**: Use Python scripts to import Cognee for memory operations (e.g., add, cognify, search). Reuse examples from official Cognee docs ([cognee.ai](https://cognee.ai/docs)).
- **Declarative Workflows**: Run Spec-kit commands like `specify <command>` for specification management.
- **Extending the Stack**: For new tools, AI agents must first investigate official sources (e.g., browse official docs or MCP servers), use the exact command, and update `AGENTS.md` or this README with references. Always reuse existing code.
- **Running Tasks**:
  - Install dependencies: `uv sync` (Python), `npm install` (Node)
  - Launch Cognee UI (optional): `cognee-cli -ui`
  - Example agent script: Create `agent.py` and run `python agent.py`

For AI agent-specific instructions, refer to [AGENTS.md](AGENTS.md). This file provides steering for autonomous operations.

## Architecture

- **Dev Container**: Based on `mcr.microsoft.com/devcontainers/universal:2-linux` (official: [Microsoft Dev Containers](https://github.com/microsoft/vscode-dev-containers)).
- **Patterns**: Agentic workflows with tools, memory retrieval, and state persistence. Modular design for scalability.
- **Integrations**: GitHub Copilot for code assistance, Copilot CLI for CLI tasks (install via official docs: [GitHub Copilot CLI](https://docs.github.com/en/copilot/github-copilot-in-the-cli)).
- **Security**: Use `.env` for API keys; Cognee handles non-sensitive data.

## Contributing

Contributions are welcome via pull requests. Follow these guidelines to maintain AI-first autonomy:

- **PR Format**: `[component] <Descriptive Title>` (e.g., `[cognee] Add memory example`)
- **Before Committing**: Run linters/tests: `uv run black .`, `npm run lint`, `uv run pytest`, `npm test`
- **Description**: Include changes, rationale, and tested AI interactions.
- **Issue Templates**: Use GitHub's issue templates for bugs/features.
- **Wiki**: For extended guides, contribute to the [GitHub Wiki](https://github.com/leonbreukelman/smactory/wiki).

All changes should be agent-preparable where possible, reusing code and referencing officials.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with official tools from GitHub, Microsoft, Astral, and others.
- Inspired by AI-first development principles for autonomous repos.
