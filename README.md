# Smactory 🚀

**A Fully AI-Autonomous Repository for Prototyping & Managing Production-Grade AI Agents**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Dev Container](https://img.shields.io/badge/Dev%20Container-Ready-brightgreen)](https://code.visualstudio.com/docs/devcontainers/containers)
[![Python 3.12](https://img.shields.io/badge/Python-3.12-3776AB?logo=python&logoColor=white)](https://python.org)
[![Node.js 22](https://img.shields.io/badge/Node.js-22-339933?logo=node.js&logoColor=white)](https://nodejs.org)

Smactory is built to be **operated entirely by AI agents**.

Humans only provide high-level direction and final alignment review.

The repo installs its own tools, configures secrets, starts databases, writes and updates its own documentation, stores knowledge in Cognee, reasons with Goose, acts with Copilot CLI, and evolves itself — all from **official, verifiable sources only**.

This is what happens when you combine Dev Containers + uv + Spec-kit + Cognee + Goose + Copilot CLI correctly: the repository becomes **alive**.

## Quick Start (≈ 8–10 min total)

```bash
git clone https://github.com/leonbreukelman/smactory.git
cd smactory
code .        # Open in VS Code
```

→ When prompted → **"Reopen in Container"**

The Dev Container will automatically:

1. Install Python 3.12, uv, Node.js 22, PostgreSQL, Playwright, etc.
2. Install Spec-kit, Goose, Cognee, Copilot CLI from their official sources
3. Start PostgreSQL with persistent volume
4. Create venv and install all Python dependencies

### Critical Next Steps (do these exactly in this order)

#### 1. Initialize Spec-Kit

```bash
specify init --here --ai copilot
```

This creates `.specify/` with templates and memory directory. Copilot Chat will now recognize all `/speckit.*` slash commands.

#### 2. Create the Project Constitution (one-time, defines agent law forever)

**Best & most reliable method (avoids any copy-paste formatting issues):**

1. Create a new file in the repository root called **`constitution_prompt.md`**
2. Paste **exactly** this content into it:

```markdown
Create the definitive constitution for Smactory — the world's first fully AI-autonomous agent factory.

This repository must be capable of complete self-maintenance and self-evolution by AI agents with only high-level human alignment review.

Core imperatives that are absolute law (these MUST be enforced at all times by every agent):

1. **Autonomy & Self-Maintenance** — Agents must install, configure, document, test, improve, and evolve the repository without human intervention whenever possible.

2. **Source-of-Truth Only** — Every command, installation, or configuration change MUST be taken directly from the official documentation of the tool and cited with the exact URL. Hallucinated commands are forbidden.

3. **Documentation Excellence** — After ANY change (even tiny), immediately update README.md, AGENTS.md, and any relevant files with the precise commands used, their exact output, the date, and the official source URL. Documentation is never allowed to be stale.

4. **Security First** — Secrets are sacred. Never log, print, commit, or expose secrets. Use only .env + setup_secrets.py. If a secret is accidentally exposed, immediately revoke it and notify the human.

5. **Reliability & Quality** — All code changes must pass `uv run black . && uv run ruff check .`, have tests, and be verified working before PR merge. Zero tolerance for broken builds.

6. **Memory Persistence** — All important knowledge, learnings, decisions, commands, and sources must be stored in Cognee graph + vector memory AND in .specify/memory/ for future sessions.

7. **Reasoning Superiority** — Use Goose for any complex or long-horizon reasoning. Never use weak models for important decisions.

8. **Tool Mastery Order** — Prefer official CLIs in this strict precedence: Copilot CLI → Goose → uv → specify → cognee → python subprocess only as last resort.

9. **Self-Evolution** — At least once per day or after major work, scan the entire repository for improvements, create feature branches, open PRs with proper titles/descriptions, and request human review only for final merge.

10. **Truthfulness & Alignment** — Never hallucinate commands, facts, or sources. If uncertain, research official docs first. Always act in the best interest of creating powerful, safe, production-grade autonomous agents. Human alignment decisions are supreme.

Make this constitution extremely strict, comprehensive, written in clear, enforceable language that the agent will treat as supreme law.

Use markdown formatting, sections, numbered lists, bold for emphasis, and make it visually clean. This file will be saved as .specify/memory/constitution.md and it is the highest law of this repository — higher than any other file.
```

3. Save the file (commit after constitution is generated)

4. Open **Copilot Chat** → type exactly:

```
/speckit.constitution @constitution_prompt.md
```

→ The agent will read the file raw (perfect formatting) and create `.specify/memory/constitution.md`

5. Review → commit the generated constitution immediately.

This constitution is now the **supreme law** of the repository. Every future `/speckit` command automatically respects it.

#### 3. Inject Secrets (Groq, OpenAI, Anthropic, XAI, GitHub token, etc.)

```bash
uv run python setup_secrets.py
```

Follow prompts or let an agent do it.  
Rebuild container once afterward (Ctrl+Shift+P → "Dev Containers: Rebuild Container") so secrets are injected.

#### 4. Verify Everything is Alive

```bash
specify check              # Spec-kit ready
goose info                 # Goose ready  
python -c "import cognee; print('Cognee', cognee.__version__)"
copilot --version          # Copilot CLI ready

# PostgreSQL (uses the temp bootstrap password)
PGPASSWORD=smactory_temp_2025_change_me psql -h db -U cognee_user -d cognee_db -c "\conninfo"
# You should see: You are connected to database "cognee_db" as user "cognee_user" via socket in "/var/run/postgresql" ...
```

You now have a fully autonomous, self-documenting, self-improving AI agent factory.

## Running Your First Autonomous Agent

Just let Copilot do everything:

```
copilot run "Using the project constitution, introduce yourself in AGENTS.md, summarize your capabilities, and propose three concrete improvements to the repository right now"
```

Or run the example:

```bash
uv run python -m examples.simple_agent --task "You are now the principal agent of Smactory. Introduce yourself in AGENTS.md and propose three immediate improvements."
```

The real power is the loop: **Constitution → Specification → Plan → Tasks → Implement → Document → Repeat**

## Recommended Ongoing Workflow (AI-First)

1. Open Copilot Chat → describe desired outcome in natural language
2. Agent uses `/speckit.specify` → `/speckit.plan` → `/speckit.tasks` → `/speckit.implement`
3. Agent updates documentation with exact sourced commands
4. Agent opens PR
5. Human only reviews & merges (alignment check)

## Core Stack (Installed & Verified Autonomously)

| Component         | Purpose                                    | Official Source                                      |
|-------------------|--------------------------------------------|------------------------------------------------------|
| Spec-kit CLI      | Constitution + spec-driven development     | https://github.com/github/spec-kit                   |
| Goose (Block)     | Best-in-class reasoning engine             | https://block.github.io/goose                        |
| Cognee            | Persistent graph + vector memory           | https://cognee.ai                                            |
| GitHub Copilot CLI| Terminal actions & agentic commands        | https://docs.github.com/en/copilot/github-copilot-in-the-cli |
| uv (Astral)       | 50–100× faster Python packaging            | https://astral.sh/uv                                         |
| PostgreSQL        | Persistent storage for Cognee              | postgresql.org                                               |

Every tool is installed from its official source. The constitution enforces this. No exceptions.

## Contributing = Letting Agents Contribute

The only valid way to contribute:

1. Let an agent propose & implement the change following the constitution
2. Agent opens PR with title format `[agent-autonomy]`, `[memory]`, `[tooling]`, etc.
3. PR description must contain: “Verified with agent · Constitution v1 applied”
4. Human merges

## License

MIT © Leon Breukelman

---

**Smactory is the endgame.**

A repository that no longer needs humans to write code — only to dream.

Star if you're ready for agents to take over (safely).  
Fork if you're going to let them run wild.
