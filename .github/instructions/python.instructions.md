# **Instructions for Python Code**

When generating or modifying Python code in this repository, you MUST adhere to the following guidelines, which are derived from our project's constitution.md.

* **Adhere to pyproject.toml**: All code must be compliant with the ruff linter and formatter rules defined in the root pyproject.toml file.
* **Strict Typing**: Use full type hints for all function arguments, return values, and variables. The code must be mypy --strict compliant.
* **Docstrings**: Generate Google-style docstrings for all public modules, classes, and functions. Include Args:, Returns:, and Raises: sections.
* **TDD Compliance**: When asked to create a new function or feature, first suggest the corresponding pytest unit tests.
* **Security**: Be vigilant about security vulnerabilities. Sanitize all inputs, especially those that will be used in database queries (to prevent SQL injection) or rendered in HTML (to prevent XSS).
* Error Handling: Do not swallow exceptions. Use specific exception types and provide clear error messages.
* Performance: Optimize for scalability per constitution.md (e.g., avoid N+1 queries).
* SDD Integration: Reference spec.md/plan.md in comments.
