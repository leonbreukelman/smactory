# **[Project Name]**

## **1. Project Overview**

[Provide a concise, high-level summary of the project's purpose, its core functionality, and the problem it solves.]

---

## **2. The AI-Native Development Lifecycle**

This repository follows a structured, AI-assisted development process. Adherence to this workflow is mandatory for all contributions. The process ensures quality, consistency, and architectural integrity.

1. **Specification (.specify/spec.md)**: All new features must begin with a formal specification using the /speckit.specify command. Focus on the *what* and *why*.  
2. **Planning (.specify/plan.md)**: Create a technical plan with /speckit.plan. This plan will be validated against the project's principles in .specify/memory/constitution.md.  
3. **Tasking (.specify/tasks.md)**: Automatically generate an implementation task list with /speckit.tasks.  
4. **Implementation (/speckit.implement)**: Use the /speckit.implement command for large-scale code generation. For interactive tasks (debugging, refactoring), use the custom prompts and chat modes available in the .github/ directory.  
5. **Verification (CI Pipeline)**: All pull requests must pass the full suite of checks in the quality-assurance.yml workflow, which includes linting, type-checking, and unit tests.

---

## **3. Getting Started**

### **Prerequisites**

* Python 3.10+  
* Pip and venv  
* Docker (for some advanced AI features)

### **Installation**

1. Clone the repository:  
   git clone [repository-url]  
2. Navigate to the project directory:  
   cd [project-name]  
3. Run the bootstrap script to set up the environment and AI primitives:  
   ./bootstrap.sh  
4. Activate the virtual environment:  
   source .venv/bin/activate

---

## **4. Key Commands and Workflows**

### **Spec-Driven Development**

* /speckit.constitution: Review or update the project's core principles.  
* /speckit.specify "Create a user authentication endpoint": Start a new feature specification.  
* /speckit.plan: Generate a technical plan from the current spec.md.  
* /speckit.tasks: Break down the plan.md into actionable tasks.  
* /speckit.implement: Execute the tasks.md to generate code.

### **Interactive AI Assistance**

* /create-pytest-unit-tests: Generate unit tests for the currently selected function.  
* /generate-docstrings-for-function: Add comprehensive docstrings to the selected function.  
* @qa_engineer: Switch to a chat mode specialized in identifying edge cases and potential bugs.  
* @architect: Switch to a chat mode for high-level design discussions and trade-off analysis.

---

## **5. How to Contribute**

1. Create a new branch from main.  
2. Follow the AI-Native Development Lifecycle (Section 2) to implement your feature.  
3. Ensure all local checks pass: pytest, ruff check ., mypy ..  
4. Open a pull request against the main branch.  
5. Ensure the CI pipeline passes.  
6. Request a review from the project maintainers.

