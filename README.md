# **Smactory**

## **1. Project Overview**

Smactory is an AI-Native Python project template for structured development, solving inconsistent AI-assisted coding workflows by integrating Spec-Driven Development and AI primitives.

---

## **2. The AI-Native Development Lifecycle**

This repository follows a structured, AI-assisted development process with comprehensive journaling. Adherence to this workflow is mandatory for all contributions. The process ensures quality, consistency, and architectural integrity.

1. **Specification (.specify/spec.md)**: All new features begin with a formal specification. Run `./speckit.sh specify` to scaffold from the template, then complete it (the what and why).
2. **Planning (.specify/plan.md)**: Run `./speckit.sh ai-plan` to initialize plan.md and print a Copilot prompt to generate the plan, validated against `.specify/memory/constitution.md`.
3. **Tasking (.specify/tasks.md)**: Run `./speckit.sh ai-tasks` to initialize tasks.md and print a Copilot prompt to generate a granular, TDD-first task list from the plan.
4. **Implementation**: Run `./speckit.sh implement` to create a working branch and follow the guided Copilot prompt to apply the tasks incrementally.
5. **Verification**: Run `./spe-ckit.sh verify` to run all quality checks (linting, type-checking, tests).

### **Handling Changes and Iteration**

The SDD process is not strictly linear. If you discover a flaw in the plan or tasks during implementation:
1.  **Pause**: Stop the current implementation work.
2.  **Document**: Note the issue and your proposed change in the daily journal (`.specify/journals/`).
3.  **Update**: Modify `.specify/spec.md` or `.specify/plan.md` as needed.
4.  **Regenerate**: If the plan changed significantly, you may need to re-run `./speckit.sh ai-tasks` to get a new task list.
5.  **Resume**: Continue implementation using the updated tasks.

### **📔 Journaling System**

Every development session is automatically journaled for transparency and continuity:

- **Daily Journal**: `.specify/journals/YYYY-MM-DD-session.md` - Logs all actions, decisions, and observations
- **Run Journal**: `.specify/runs/<timestamp>/journal.md` - Implementation-specific progress tracking
- **Decision Records**: `.specify/memory/decisions/YYYY-MM-DD-title.md` - Architectural decisions (ADRs)
- **Context**: `.specify/memory/context.md` - Current development state

**Review Development History**:
```bash
# Today's journal
cat .specify/journals/$(date +%Y-%m-%d)-session.md

# Current context
cat .specify/memory/context.md

# List decisions
ls .specify/memory/decisions/
```

---

## **3. Getting Started**

### **Prerequisites**

* Python 3.10+
* Pip and venv
* Docker (for some advanced AI features)

### **Installation**

1. Clone the repository:
   git clone https://github.com/leonbreukelman/smactory
2. Navigate to the project directory:
   cd smactory
3. (Optional) Run the bootstrap script to set up the environment:
   ./bootstrap.sh
4. Activate the virtual environment (WSL):
   source .venv/bin/activate

---

## **4. Key Commands and Workflows**

### **Spec-Driven Development**

* ./speckit.sh specify      – scaffold `.specify/spec.md` from template.
* ./speckit.sh ai-plan      – initialize `.specify/plan.md` and print Copilot prompt to draft the plan.
* ./speckit.sh ai-tasks     – initialize `.specify/tasks.md` and print Copilot prompt to draft the tasks.
* ./speckit.sh plan         – snapshot finalized `tasks.md` into `.specify/runs/<timestamp>/`.
* ./speckit.sh implement    – create a branch and guide you to apply tasks with Copilot.
* ./speckit.sh verify       – run Ruff, mypy (--strict), and pytest with coverage.

### **Interactive AI Assistance**

* /create-pytest-unit-tests: Generate unit tests for the currently selected function.
* /generate-docstrings-for-function: Add comprehensive docstrings to the selected function.
* @journaler: Maintain session journals and decision records.
* @architect: Create technical plans and make architectural decisions.
* @qa_engineer: Switch to a chat mode specialized in identifying edge cases and potential bugs.
* @tester: For testing strategies and bug hunting.
* @refactor: Suggest code improvements.
* @documenter: Generate documentation.
* /refactor: Refactor selected code.
* /explain: Explain code.
* /generate-tests: Create tests.
* /fix-bug: Propose bug fixes.
* /doc: Add docs.

---

## **5. How to Contribute**

1. Create a new branch from main.
2. Follow the AI-Native Development Lifecycle (Section 2) to implement your feature.
3. Ensure all local checks pass: pytest, ruff check ., mypy . (with 90% coverage).
4. Open a pull request against the main branch.
5. Ensure the CI pipeline passes.
6. Request a review from the project maintainers.

