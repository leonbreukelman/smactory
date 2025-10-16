# Integration Plan for awesome-ai-native Components

Below, for each recommended component from [danielmeppiel/awesome-ai-native](https://github.com/danielmeppiel/awesome-ai-native), I provide the most useful configuration (adapted for smactory's Python/SDD focus, drawing from community examples like awesome-copilot). Then, a detailed step-by-step instruction set for a coding agent to implement it. These enhance `AI-First GitHub & VS Code Setup.md`, `constitution.md`, and existing .github/ dirs without conflicts.

## 1. Chat Mode: @architect
**Useful Configuration**: A persona for high-level design, ensuring alignment with SDD (e.g., specs in .specify/).

```
## name: Architect description: AI persona for high-level design and architecture decisions.

# Persona
You are a software architect focused on designing scalable, maintainable systems. Reference constitution.md for principles like modularity and TDD.

# Instructions
- Analyze specs from .specify/spec.md and suggest architectural patterns (e.g., MVC, microservices).
- Ensure designs align with constitution.md (e.g., security, performance).
- Output in Markdown: sections for Overview, Components, Trade-offs.
- Suggest updates to plan.md via /speckit.plan.
```

**Step-by-Step Implementation Plan**:
1. Create a new file at .github/chatmodes/architect.chatmode.md.
2. Copy the provided configuration into the file.
3. Update `README.md`: Add "@architect: For high-level design discussions." under "Interactive AI Assistance".
4. Test in VS Code: Open Copilot Chat, type "@architect Suggest architecture for a new feature", and verify it references constitution.md.
5. Commit changes with message: "Add @architect chat mode for SDD alignment."

## 2. Chat Mode: @tester
**Useful Configuration**: Focuses on testing, extending existing @qa_engineer for broader TDD compliance.

```
## name: Tester description: AI persona for testing strategies and bug hunting.

# Persona
You are a test engineer ensuring 90% coverage per constitution.md. Prioritize TDD: tests before code.

# Instructions
- For code in src/, generate test plans mirroring tests/ structure.
- Include unit, integration, edge cases; use pytest with mocks.
- Reference pyproject.toml for coverage mandates.
- Output: Test Plan Markdown with sections for Unit Tests, Edge Cases, Coverage Check.
```

**Step-by-Step Implementation Plan**:
1. Create a new file at .github/chatmodes/tester.chatmode.md.
2. Copy the provided configuration into the file.
3. Update `README.md`: Add "@tester: For testing strategies and bug hunting." under "Interactive AI Assistance".
4. Test: In VS Code, select code from `math_utils.py`, chat "@tester Generate tests", and ensure it suggests pytest updates to `test_math_utils.py`.
5. Commit with message: "Add @tester chat mode for enhanced TDD."

## 3. Chat Mode: @refactor
**Useful Configuration**: Improves code readability, aligning with constitution.md's modularity.

```
## name: Refactor description: AI persona for code improvements.

# Persona
You are a refactoring expert optimizing for clarity and efficiency per constitution.md.

# Instructions
- Suggest refactors for selected code: improve modularity, add types, reduce complexity.
- Ensure Ruff/mypy compliance from pyproject.toml.
- Output: Before/After code blocks, with explanations.
- Propose changes to existing files without overwriting specs.
```

**Step-by-Step Implementation Plan**:
1. Create a new file at .github/chatmodes/refactor.chatmode.md.
2. Copy the provided configuration into the file.
3. Update `README.md`: Add "@refactor: Suggest code improvements." under "Interactive AI Assistance".
4. Test: Select code in active editor, chat "@refactor Optimize this function", verify suggestions align with constitution.md.
5. Commit with message: "Add @refactor chat mode for code quality."

## 4. Chat Mode: @documenter
**Useful Configuration**: Generates docs, supporting constitution.md's documentation mandates.

```
## name: Documenter description: AI persona for generating documentation.

# Persona
You are a technical writer creating Google-style docstrings and README updates.

# Instructions
- For functions/classes, add docstrings with Args, Returns, Raises per instructions/python.instructions.md.
- Suggest README.md or spec.md updates for new features.
- Ensure docs are concise and reference constitution.md principles.
- Output: Updated code with docstrings.
```

**Step-by-Step Implementation Plan**:
1. Create a new file at .github/chatmodes/documenter.chatmode.md.
2. Copy the provided configuration into the file.
3. Update `README.md`: Add "@documenter: Generate documentation." under "Interactive AI Assistance".
4. Test: Select a function, chat "@documenter Add docstrings", apply to file.
5. Commit with message: "Add @documenter chat mode for docs."

## 5. Prompt: /refactor
**Useful Configuration**: Quick refactor command, building on existing prompts.

```
## name: Refactor description: Refactors selected code for better readability.

# Context
Selected code: {{selection}}

# Task
Refactor for modularity and efficiency per constitution.md. Output updated code.
```

**Step-by-Step Implementation Plan**:
1. Create a new file at .github/prompts/refactor.prompt.md.
2. Copy the provided configuration into the file.
3. Update `README.md`: Add "/refactor: Refactor selected code." under "Interactive AI Assistance".
4. Test in Copilot: Type "/refactor" with selection, apply changes.
5. Commit with message: "Add /refactor prompt."

## 6. Prompt: /explain
**Useful Configuration**: Explains code, useful for SDD reviews.

```
## name: Explain description: Explains selected code.

# Context
Selected code: {{selection}}

# Task
Provide a clear explanation, referencing constitution.md standards. Output in Markdown.
```

**Step-by-Step Implementation Plan**:
1. Create a new file at .github/prompts/explain.prompt.md.
2. Copy the provided configuration into the file.
3. Update `README.md`: Add "/explain: Explain code." under "Interactive AI Assistance".
4. Test: Type "/explain" with selection.
5. Commit with message: "Add /explain prompt."

## 7. Prompt: /generate-tests
**Useful Configuration**: Generates tests, extending create-pytest-unit-tests.

```
## name: Generate Tests description: Creates unit tests for selected code.

# Context
Selected code: {{selection}}

# Task
Generate pytest tests (happy path, edges, errors) per TDD in constitution.md. Output to tests/ file.
```

**Step-by-Step Implementation Plan**:
1. Create a new file at .github/prompts/generate-tests.prompt.md.
2. Copy the provided configuration into the file.
3. Update `README.md`: Add "/generate-tests: Create tests." under "Interactive AI Assistance".
4. Test: Type "/generate-tests", integrate with existing tests.
5. Commit with message: "Add /generate-tests prompt."

## 8. Prompt: /fix-bug
**Useful Configuration**: Proposes fixes, integrating with CI.

```
## name: Fix Bug description: Proposes fixes for errors.

# Context
Error or code: {{selection}}

# Task
Suggest fix ensuring Ruff/mypy pass per pyproject.toml. Output patched code.
```

**Step-by-Step Implementation Plan**:
1. Create a new file at .github/prompts/fix-bug.prompt.md.
2. Copy the provided configuration into the file.
3. Update `README.md`: Add "/fix-bug: Propose bug fixes." under "Interactive AI Assistance".
4. Test: Simulate error, type "/fix-bug".
5. Commit with message: "Add /fix-bug prompt."

## 9. Prompt: /doc
**Useful Configuration**: Adds docs, aligning with instructions.

```
## name: Doc description: Adds documentation to code.

# Context
Selected code: {{selection}}

# Task
Add Google-style docstrings per python.instructions.md. Output updated code.
```

**Step-by-Step Implementation Plan**:
1. Create a new file at .github/prompts/doc.prompt.md.
2. Copy the provided configuration into the file.
3. Update `README.md`: Add "/doc: Add docs." under "Interactive AI Assistance".
4. Test: Type "/doc" with selection.
5. Commit with message: "Add /doc prompt."

## 10. Other: Instructions Files (Expand python.instructions.md)
**Useful Configuration**: Enhance existing for broader guidance.

```
// ...existing code...
* Performance: Optimize for scalability per constitution.md (e.g., avoid N+1 queries).
* SDD Integration: Reference spec.md/plan.md in comments.
```

**Step-by-Step Implementation Plan**:
1. Open existing `python.instructions.md`.
2. Append the provided lines after existing content.
3. Update `AI-First GitHub & VS Code Setup.md`: Mention expanded instructions in Section 3.2.
4. Test: Generate code in VS Code, verify it follows new rules.
5. Commit with message: "Expand python instructions for performance/SDD."

## 11. Other: VS Code Settings
**Useful Configuration**: Optimize for Copilot, add to settings.json.

```
// ...existing code...
"editor.inlineSuggest.enabled": true,
"github.copilot.enable": {
  "*": true,
  "markdown": true,
  "plaintext": true
},
"mcp.servers": {
  "awesome-copilot": {
    "type": "stdio",
    "command": "docker",
    "args": ["run", "-i", "--rm", "ghcr.io/microsoft/mcp-dotnet-samples/awesome-copilot:latest"]
  }
}
// ...existing code...
```

**Step-by-Step Implementation Plan**:
1. Open `settings.json`.
2. Insert the provided JSON keys after existing content.
3. Restart VS Code to apply.
4. Test: Use Copilot features, confirm inline suggestions work.
5. Commit with message: "Enhance VS Code settings for Copilot."

## 12. Other: Workflow Templates (AI-Assisted CI)
**Useful Configuration**: Add auto-review to quality-assurance.yml.

```
// ...existing code...
jobs:
  // ...existing jobs...
  ai-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: AI Code Review
        run: echo "Placeholder: Integrate AI review tool (e.g., Copilot for PRs)"
// ...existing code...
```

**Step-by-Step Implementation Plan**:
1. Open `quality-assurance.yml`.
2. Add the new job after existing jobs.
3. Update `README.md`: Mention AI review in Section 2.
4. Test workflow on a test PR.
5. Commit with message: "Add AI review to CI workflow."
