#!/bin/bash

# bootstrap.sh: A turnkey setup script for the AI-Native repository.
# This script creates the directory structure, populates template files,
# sets up the Python environment, and provides a mechanism to sync
# with the latest community AI primitives.

set -e # Exit immediately if a command exits with a non-zero status.

# --- Helper Functions ---
print_info() {
    echo -e "\\033[34m[INFO]\\033[0m $1"
}

print_success() {
    echo -e "\\033[32m[SUCCESS]\\033[0m $1"
}

print_warning() {
    echo -e "\\033[33m[WARNING]\\033[0m $1"
}

check_docker() {
    print_info "Checking for Docker..."
    if ! command -v docker &> /dev/null; then
        print_warning "Docker not found. Installing..."
        sudo apt-get update && sudo apt-get install -y docker.io
        print_success "Docker installed."
    else
        print_success "Docker is available."
    fi
}

create_directories() {
    print_info "Creating directory structure..."
    mkdir -p .specify/memory .github/instructions .github/prompts .github/chatmodes .github/workflows .vscode src tests
    print_success "Directory structure created."
}

populate_templates() {
    print_info "Populating template files..."
    # This function will be expanded to write the actual file contents.
    # For now, it just creates empty files as placeholders.
    touch .specify/memory/constitution.md
    touch .github/instructions/python.instructions.md
    touch .github/prompts/create-pytest-unit-tests.prompt.md
    touch .github/chatmodes/qa_engineer.chatmode.md
    touch .github/workflows/quality-assurance.yml
    touch .vscode/extensions.json
    touch .vscode/settings.json
    touch pyproject.toml
    touch README.md
    print_success "Template files created."
}

setup_python_environment() {
    print_info "Setting up Python virtual environment..."
    if [ -d ".venv" ]; then
        print_warning "Virtual environment '.venv' already exists. Skipping creation."
    else
        python3 -m venv .venv
        print_success "Virtual environment created at ./.venv"
    fi

    print_info "Activating virtual environment and installing dependencies..."
    source .venv/bin/activate
    python -m pip install --upgrade pip
    pip install -e .[dev]
    deactivate
    print_success "Dependencies installed. Activate with 'source .venv/bin/activate'."
}

sync_prompts() {
    print_info "Checking for GitHub CLI ('gh')..."
    if ! command -v gh &> /dev/null; then
        print_warning "'gh' command not found. Skipping sync with awesome-copilot."
        print_warning "Please install the GitHub CLI to use this feature: https://cli.github.com/"
        return
    fi

    read -p "Do you want to sync with the latest prompts from github/awesome-copilot? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Cloning awesome-copilot repository to a temporary directory..."
        TMP_DIR=$(mktemp -d)
        gh repo clone github/awesome-copilot "$TMP_DIR" -- --depth 1

        print_info "Awesome-copilot repo cloned to $TMP_DIR"
        print_info "You can now manually copy the latest prompts, instructions, and chat modes from the temporary directory into your project's .github/ directory."
        print_info "Example: cp ${TMP_DIR}/prompts/new-prompt.prompt.md .github/prompts/"

        # Keep the temp dir for the user to browse
        print_warning "The temporary directory will not be deleted automatically. Please review and clean it up yourself: $TMP_DIR"
    fi
}

# --- Execution ---
main() {
    print_info "Starting AI-Native Repository Bootstrap Process..."

    check_docker
    create_directories
    populate_templates # In a real package, this would copy files, not just touch them.
    setup_python_environment
    sync_prompts

    print_success "Bootstrap complete! Your AI-Native repository is ready."
    print_info "Next steps:"
    print_info "1. Fill in the template files with the content provided in the architectural blueprint."
    print_info "2. Activate your virtual environment: source .venv/bin/activate"
    print_info "3. Start developing!"
}

main
