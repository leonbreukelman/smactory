"""
Tests for spec kit journaling functionality.

Validates that journals are created, updated, and formatted correctly.
"""
import shutil
import subprocess
import tempfile
from datetime import datetime
from pathlib import Path
from typing import Generator

import pytest


@pytest.fixture
def temp_repo() -> Generator[Path, None, None]:
    """Create a temporary repository for testing.

    Args:
        None

    Yields:
        Path to temporary repository root.
    """
    with tempfile.TemporaryDirectory() as tmpdir:
        repo_path = Path(tmpdir)

        # Initialize git repo
        subprocess.run(["git", "init"], cwd=repo_path, check=True, capture_output=True)
        subprocess.run(
            ["git", "config", "user.email", "test@example.com"],
            cwd=repo_path,
            check=True,
            capture_output=True
        )
        subprocess.run(
            ["git", "config", "user.name", "Test User"],
            cwd=repo_path,
            check=True,
            capture_output=True
        )

        # Copy speckit.sh
        script_source = Path(__file__).parent.parent / "speckit.sh"
        shutil.copy(script_source, repo_path / "speckit.sh")

        # Create .specify structure
        specify_dir = repo_path / ".specify"
        specify_dir.mkdir()
        (specify_dir / "memory").mkdir()
        (specify_dir / "journals").mkdir()

        # Create minimal templates
        (specify_dir / "spec.template.md").write_text("# Spec Template\n")
        (specify_dir / "plan.template.md").write_text("# Plan Template\n")
        (specify_dir / "tasks.template.md").write_text("# Tasks Template\n")

        yield repo_path


def test_journal_created_on_specify(temp_repo: Path) -> None:
    """Test that journal is created when running specify command.

    Args:
        temp_repo: Temporary repository path.
    """
    result = subprocess.run(
        ["bash", "speckit.sh", "specify"],
        cwd=temp_repo,
        capture_output=True,
        text=True
    )

    assert result.returncode == 0

    # Check journal exists
    today = datetime.now().strftime("%Y-%m-%d")
    journal_path = temp_repo / ".specify" / "journals" / f"{today}-session.md"
    assert journal_path.exists()

    # Validate journal content
    content = journal_path.read_text()
    assert "# Agent Session Journal" in content
    assert "## Session Metadata" in content
    assert "Specify" in content  # Should log the specify action


def test_context_updated_on_specify(temp_repo: Path) -> None:
    """Test that context.md is updated during specify.

    Args:
        temp_repo: Temporary repository path.
    """
    subprocess.run(
        ["bash", "speckit.sh", "specify"],
        cwd=temp_repo,
        check=True,
        capture_output=True
    )

    context_path = temp_repo / ".specify" / "memory" / "context.md"
    assert context_path.exists()

    content = context_path.read_text()
    assert "Current Development Context" in content
    assert "Created new specification" in content
    assert "./speckit.sh ai-plan" in content


def test_verify_logs_results(temp_repo: Path) -> None:
    """Test that verify command logs results to journal.

    Args:
        temp_repo: Temporary repository path.
    """
    # Create minimal Python structure
    src_dir = temp_repo / "src"
    src_dir.mkdir()
    (src_dir / "__init__.py").write_text("")
    (src_dir / "example.py").write_text(
        'def hello() -> str:\n'
        '    """Return greeting."""\n'
        '    return "Hello"\n'
    )

    tests_dir = temp_repo / "tests"
    tests_dir.mkdir()
    (tests_dir / "__init__.py").write_text("")
    (tests_dir / "test_example.py").write_text(
        'from src.example import hello\n\n'
        'def test_hello() -> None:\n'
        '    """Test hello function."""\n'
        '    assert hello() == "Hello"\n'
    )

    # Create pyproject.toml
    (temp_repo / "pyproject.toml").write_text(
        '[tool.ruff]\n'
        'line-length = 100\n\n'
        '[tool.mypy]\n'
        'strict = true\n'
    )

    # Initialize journal first
    subprocess.run(
        ["bash", "speckit.sh", "journal"],
        cwd=temp_repo,
        check=True,
        capture_output=True
    )

    # Run verify
    result = subprocess.run(
        ["bash", "speckit.sh", "verify"],
        cwd=temp_repo,
        capture_output=True,
        text=True
    )
    assert result.returncode == 0

    # Check journal updated
    today = datetime.now().strftime("%Y-%m-%d")
    journal_path = temp_repo / ".specify" / "journals" / f"{today}-session.md"
    content = journal_path.read_text()

    assert "## Verification Run" in content
    assert "Ruff:" in content
    assert "Mypy:" in content
    assert "Pytest:" in content


def test_implement_creates_run_journal(temp_repo: Path) -> None:
    """Test that implement creates run-specific journal.

    Args:
        temp_repo: Temporary repository path.
    """
    # Create tasks.md
    tasks_path = temp_repo / ".specify" / "tasks.md"
    tasks_path.write_text("- [ ] Task 1\n- [ ] Task 2\n")

    result = subprocess.run(
        ["bash", "speckit.sh", "implement"],
        cwd=temp_repo,
        capture_output=True,
        text=True
    )

    assert result.returncode == 0

    # Check run journal created
    runs_dir = temp_repo / ".specify" / "runs"
    assert runs_dir.exists()

    # Find the run directory (timestamped)
    run_dirs = list(runs_dir.iterdir())
    assert len(run_dirs) == 1

    run_journal = run_dirs[0] / "journal.md"
    assert run_journal.exists()

    content = run_journal.read_text()
    assert "# Implementation Journal" in content
    assert "## Run Metadata" in content
    assert "spec/" in content  # Branch name


def test_journal_template_format(temp_repo: Path) -> None:
    """Test that journal follows correct template format.

    Args:
        temp_repo: Temporary repository path.
    """
    subprocess.run(
        ["bash", "speckit.sh", "journal"],
        cwd=temp_repo,
        check=True,
        capture_output=True
    )

    today = datetime.now().strftime("%Y-%m-%d")
    journal_path = temp_repo / ".specify" / "journals" / f"{today}-session.md"
    content = journal_path.read_text()

    required_sections = [
        "# Agent Session Journal",
        "## Session Metadata",
        "- **Start Time**:",
        "- **Agent Type**:",
        "- **Context**:",
        "- **Goal**:",
        "## Actions Taken",
        "## Decisions Made",
        "## Session Outcomes",
        "## Next Session"
    ]

    for section in required_sections:
        assert section in content, f"Missing section: {section}"


def test_multiple_actions_logged(temp_repo: Path) -> None:
    """Test that multiple actions are logged to same journal.

    Args:
        temp_repo: Temporary repository path.
    """
    # Run multiple commands
    subprocess.run(
        ["bash", "speckit.sh", "specify"],
        cwd=temp_repo,
        check=True,
        capture_output=True
    )

    subprocess.run(
        ["bash", "speckit.sh", "ai-plan"],
        cwd=temp_repo,
        check=True,
        capture_output=True
    )

    # Check journal has both actions
    today = datetime.now().strftime("%Y-%m-%d")
    journal_path = temp_repo / ".specify" / "journals" / f"{today}-session.md"
    content = journal_path.read_text()

    assert content.count("### ") >= 2  # At least 2 action entries
    assert "Specify" in content
    assert "AI Planning" in content
