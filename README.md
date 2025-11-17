# Smactory: AI-First Autonomous Management Repository

[![GitHub license](https://img.shields.io/github/license/leonbreukelman/smactory)](https://github.com/leonbreukelman/smactory/blob/main/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/leonbreukelman/smactory)](https://github.com/leonbreukelman/smactory/issues)
[![GitHub stars](https://img.shields.io/github/stars/leonbreukelman/smactory)](https://github.com/leonbreukelman/smactory/stargazers)

## Overview

Smactory is an AI-first repository engineered for autonomous management and prototyping of AI agents. It harnesses official AI tools and integrations to enable self-setup, self-evolution, and operation by AI agents, with human oversight for alignment and refinement. The core focus is on establishing a development environment that supports persistent memory, state management, declarative workflows, and reasoning loops using tools like Spec-kit, Cognee, Goose, and GitHub Copilot CLI. Agents can self-configure secrets, update documentation, and execute tasks via reasoning-react patterns, pushing toward full autonomy.

This repo is bootstrapped autonomously by AI agents, following a single core setup script (see `.devcontainer/postCreateCommand.sh` and `AGENTS.md`). Configurations prioritize reuse of existing, tested code over new generation, with installations referencing official sources for verifiability and security. Secrets (e.g., API keys) are managed post-bootstrap via `setup_secrets.py` for agentic handling.

**Key Stack**:
- **Languages/Runtimes**: Python 3.12, Node.js 22
- **Package Managers**: uv (for Python), NPM (for Node)
- **AI Tools**: Spec-kit CLI (for declarative specifications), Cognee (for AI memory handling with PostgreSQL support), Goose (for reasoning loops), GitHub Copilot, Copilot CLI
- **Persistence**: PostgreSQL (auto-configured with secret-injected credentials)
- **Environment**: Dev Container based on Microsoft's universal image
- **Other**: MCP servers (for managed compute, e.g., Microsoft Cloud Platform integrations), setup_secrets.py for autonomous secret management

The setup ensures reliable, agent-performable tasks to get the repo operational, with documentation self-updated to reflect exact commands, official references, and AI-driven evolutions.

## Quick Start

To get started, clone the repo and use VS Code with Dev Containers for an autonomous setup. Agents can self-execute these steps via reasoning.

1. **Prerequisites**:
   - Git installed
   - Visual Studio Code with the Dev Containers extension (official: [VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers))
   - Docker (for running the container)
   - GitHub Secrets configured (e.g., LLM_API_KEY for Cognee, XAI_API_KEY for Goose—see Security section)

2. **Clone the Repository**:
   ```
   git clone https://github.com/leonbreukelman/smactory.git
   cd smactory
   ```

3. **Open in VS Code**:
   - Launch VS Code: `code .`
   - When prompted, select "Reopen in Container" to build and start the dev environment.

4. **Post-Create Setup**:
   - The container automatically runs `.devcontainer/postCreateCommand.sh`, handling all installations autonomously (e.g., uv, Spec-kit, Cognee with PostgreSQL, Goose, Copilot CLI).
   - This script searches official sources for latest instructions (e.g., via web searches or MCP servers) and updates documentation with exact commands and references.
   - Example installs (as of current setup; always verify latest via official docs):
     - uv: Installed from [Astral's official installer](https://astral.sh/uv) with `curl -LsSf https://astral.sh/uv/install.sh | sh`
     - Spec-kit CLI: From [GitHub's spec-kit repo](https://github.com/github/spec-kit) via `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git`
     - Cognee: From PyPI with `uv pip install "cognee[postgres]"`, including dependencies like Playwright (official: [Playwright docs](https://playwright.dev/python/docs/intro))
     - Goose: From [Block's Goose repo](https://github.com/block/goose) via curl installer (skipping auto-configure)
     - PostgreSQL: Apt-installed with default temp creds; update via `setup_secrets.py`

5. **Post-Bootstrap Configuration**:
   - Run `uv run python setup_secrets.py` to configure/set secrets (e.g., LLM_API_KEY, COGNEE_DB_PASSWORD, XAI_API_KEY). Agents can self-execute this for autonomy.
   - Rebuild container to inject secrets.

6. **Verify Setup**:
   - In the VS Code terminal (after `source .venv/bin/activate`):
     ```
     specify check     # Validates Spec-kit
     node --version    # Should show 22.x
     python --version  # Should show 3.12.x
     python -c "import cognee; print(cognee.__version__)"  # Confirms Cognee
     goose info        # Confirms Goose
     copilot --version # Confirms GitHub Copilot CLI
     PGPASSWORD=$COGNEE_DB_PASSWORD psql -h localhost -U cognee_user -d cognee_db -c "\conninfo"  # Confirms PostgreSQL
     ```
   - Setup complete message: "Dev environment setup complete. AGENTS.md is available in the root directory."

## Usage

- **Prototyping AI Agents**: Use Python scripts to import Cognee for memory operations (e.g., async add/cognify/search). Reuse examples from official Cognee docs ([cognee.ai](https://cognee.ai/docs)). Integrate Goose for reasoning via subprocess.
- **Declarative Workflows**: Run Spec-kit commands like `specify <command>` for specification management. Use slash commands (e.g., /spec-kit.constitution) in Copilot for project guidelines.
- **Extending the Stack**: For new tools, AI agents must first investigate official sources (e.g., browse official docs or MCP servers), use the exact command, and update `AGENTS.md` or this README with references. Always reuse existing code.
- **Running Tasks**:
  - Install dependencies: `uv sync` (Python), `npm install` (Node)
  - Launch Cognee UI (optional): `cognee-cli -ui` (requires LLM_API_KEY)
  - Example agent script: Create `agent.py` and run `uv run python agent.py --task "Your task"`. See AGENTS.md for integration.
  - Secret Management: Run `uv run python setup_secrets.py` for autonomous config.

For AI agent-specific instructions, refer to [AGENTS.md](AGENTS.md). This file provides steering for autonomous operations, including self-updates.

## Architecture

- **Dev Container**: Based on `mcr.microsoft.com/devcontainers/universal:2-linux` (official: [Microsoft Dev Containers](https://github.com/microsoft/vscode-dev-containers)).
- **Patterns**: Agentic workflows with tools, memory retrieval, and state persistence. Modular, async design for scalability; self-configure via setup_secrets.py.
- **Integrations**: GitHub Copilot for code assistance, Copilot CLI for CLI tasks (official: [GitHub Copilot CLI](https://docs.github.com/en/copilot/github-copilot-in-the-cli)). Goose for reasoning (official: [Block Goose](https://github.com/block/goose)).
- **Persistence/Security**: PostgreSQL with secret-injected creds; Cognee handles non-sensitive data. Secrets via GitHub for LLM_API_KEY, etc.

## Contributing

Contributions are welcome via pull requests. Follow these guidelines to maintain AI-first autonomy:

- **PR Format**: `[component] <Descriptive Title>` (e.g., `[cognee] Add memory example`)
- **Before Committing**: Run linters/tests: `uv run black .`, `npm run lint`, `uv run pytest`, `npm test`
- **Description**: Include changes, rationale, and tested AI interactions/memory updates.
- **Issue Templates**: Use GitHub's issue templates for bugs/features.
- **Wiki**: For extended guides, contribute to the [GitHub Wiki](https://github.com/leonbreukelman/smactory/wiki).

All changes should be agent-preparable where possible, reusing code and referencing officials.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with official tools from GitHub, Microsoft, Astral, Block, and others.
- Inspired by AI-first development principles for autonomous repos.
