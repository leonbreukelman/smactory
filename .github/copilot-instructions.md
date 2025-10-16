# Instructions for Python Code (repo-scoped)

The following guidance mirrors `.github/instructions/python.instructions.md` to ensure Copilot applies repository-specific behavior consistently.

When generating or modifying Python code in this repository, adhere to:

- Adhere to pyproject.toml: All code must be compliant with the ruff linter and formatter rules defined in the root pyproject.toml file.
- Strict Typing: Use full type hints for all function arguments, return values, and variables. The code must be mypy --strict compliant.
- Docstrings: Generate Google-style docstrings for all public modules, classes, and functions. Include Args:, Returns:, and Raises: sections.
- TDD Compliance: When asked to create a new function or feature, first suggest the corresponding pytest unit tests.
- Security: Be vigilant about security vulnerabilities. Sanitize all inputs, especially those that will be used in database queries (to prevent SQL injection) or rendered in HTML (to prevent XSS).
- Error Handling: Do not swallow exceptions. Use specific exception types and provide clear error messages.
- Performance: Optimize for scalability per constitution.md (e.g., avoid N+1 queries).
- SDD Integration: Reference spec.md/plan.md in comments.

## 📔 Agent Behavior & Journaling (CRITICAL)

### Before Starting Any Work

**ALWAYS** perform these steps:

1. **Read Current Context**:
   ```bash
   # Check what's happening now
   cat .specify/memory/context.md
   
   # Read today's journal
   cat .specify/journals/$(date +%Y-%m-%d)-session.md
   
   # If in a spec run, read run journal
   cat .specify/runs/<RUN_ID>/journal.md
   ```

2. **Understand Task Context**:
   - Read `.specify/tasks.md` to see current task
   - Check related decision records in `.specify/memory/decisions/`
   - Review recent journal entries for this feature

### During Work - Journaling Requirements

For **every significant action**, document in today's journal (`.specify/journals/YYYY-MM-DD-session.md`):

```markdown
### HH:MM - <Action Type>
**Prompt**: <what user asked>
**Response**: <what was done>
**Files**: <list with brief descriptions>
**Tests**: <command and results>
**Observations**: <notes>
```

**Action Types**: Implementation, Refactoring, Bug Fix, Test Addition, Decision Point, Documentation

### Architectural Decisions

When making **any architectural choice**, create a decision record:

1. **Create file**: `.specify/memory/decisions/YYYY-MM-DD-brief-title.md`
2. **Use this format**:

```markdown
# ADR-XXX: <Title>

**Date**: YYYY-MM-DD  
**Status**: Accepted  
**Deciders**: GitHub Copilot + Developer

## Context
<What problem are we solving?>

## Options Considered

### Option 1: <Name>
**Pros**: 
- <Advantage 1>

**Cons**:
- <Disadvantage 1>

**Effort**: Low | Medium | High

### Option 2: <Name>
**Pros**: ...
**Cons**: ...
**Effort**: ...

## Decision
We chose **<Option X>** because:
<Primary rationale>

## Consequences

### Positive
- <Benefit 1>
- <Benefit 2>

### Negative
- <Trade-off 1>

### Mitigations
- <How to address trade-off 1>

## Implementation Notes
<Technical details, patterns to follow>

## References
- Link to spec.md section
- Link to plan.md section
```

3. **Log in journal**:
```markdown
### HH:MM - Decision: <Title>
**Question**: <What needed deciding?>
**Options**: <List briefly>
**Decision**: <Chosen option>
**Rationale**: <Why>
**Recorded In**: `.specify/memory/decisions/YYYY-MM-DD-title.md`
```

### After Significant Changes

**Update context file** (`.specify/memory/context.md`):

```markdown
# Current Development Context
Last Updated: YYYY-MM-DD HH:MM:SS

## Active Work
- Branch: <branch-name>
- Spec Run: <run-id>
- Current Task: <task-id> from .specify/tasks.md

## Recent Changes
- `<file>` - <what changed> - <why>
- `<file>` - <what changed> - <why>

## Known Issues
- <issue> - <status>

## Next Steps
- <what to do next>
```

### End of Task

When completing a task from [`.specify/tasks.md`](.specify/tasks.md ):

1. **Mark task complete** in tasks.md (change `[ ]` to `[x]`)
2. **Log completion** in journal:
```markdown
### HH:MM - Task Completed: T<N>
**Task**: <Task description>
**Files Changed**: <count> files
**Tests**: All passing ✅
**Coverage**: <X>% (delta: +<Y>%)
**Duration**: <estimated time>
```
3. **Update run journal** (`.specify/runs/<RUN_ID>/journal.md`) with outcomes
4. **Update context.md** with next task

### Quality Gates

Before claiming work is complete:

- [ ] All tests pass: `pytest`
- [ ] Linter passes: `ruff check .`
- [ ] Type checker passes: `mypy src`
- [ ] Coverage >= 90% for new code
- [ ] Journal updated with all actions
- [ ] Context.md reflects current state
- [ ] Decision records created (if applicable)
- [ ] Task marked complete in tasks.md

### Example Journal Entry (Complete)

```markdown
### 14:32 - Implementation: T2
**Prompt Given**:
```
Implement SSE endpoint from task T2
```

**Agent Response**:
Created FastAPI endpoint with SSE streaming for real-time machine status.

**Files Modified**:
- `src/api/routes/machines.py` - Added sse_stream_endpoint()
- `tests/api/test_sse.py` - Added 3 test cases

**Tests Run**:
```bash
$ pytest tests/api/test_sse.py -v
PASSED (3/3)
```

**Observations**:
SSE streaming works well. Concern about N+1 queries → created ADR-007.

**Decision Made**:
Created ADR-007 for eager loading strategy to prevent N+1 queries.
See: .specify/memory/decisions/2025-10-16-eager-loading-machines.md

---
```

### Troubleshooting

**If journal is missing**:
```bash
./speckit.sh journal  # Creates today's journal
```

**If you forget to journal**:
- Acknowledge the gap
- Backfill what you remember
- Continue proper journaling going forward

**If context is unclear**:
- Ask user to clarify
- Document assumption in journal
- Proceed with reasonable default

### Session Handoff

At end of session, **summarize in journal**:

```markdown
## Session Outcomes
- **Completed Tasks**: T1, T2, T3
- **Deferred Tasks**: T4 (reason)
- **New Issues Found**: 
  - <issue 1>
  - <issue 2>
- **Quality Metrics**:
  - Coverage: <X>%
  - Linter: ✅ | ❌
  - Type Check: ✅ | ❌
  - Performance: <notes>

## Next Session
**Planned Actions**: <what to do next>
**Context to Preserve**: <important context for next session>
**Blockers**: <anything blocking progress>
```

This ensures continuity when development resumes.
