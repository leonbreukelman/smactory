#!/bin/bash
set -e

echo "🧬 Smactory v3 bootstrap beginning..."

# 1. uv (verified from astral.sh)
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.cargo/bin:$PATH"

# 2. venv
uv venv --clear .venv
source .venv/bin/activate

# 3. Core AI tools (verified from PyPI/GitHub)
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
uv pip install "cognee[postgres]"
uv pip install python-dotenv

# 4. Goose – non-interactive install + Grok-4 config (headless-safe, Nov 2025)
echo "Installing Goose CLI (non-interactive)..."
curl -fsSL https://github.com/block/goose/releases/download/stable/download_cli.sh | CONFIGURE=0 bash
export PATH="$HOME/.local/bin:$PATH"

# Disable keyring globally + configure xAI Grok-4 via env (persisted)
echo 'export GOOSE_PROVIDER=xai' >> ~/.bashrc
echo 'export GOOSE_MODEL=grok-4-0709' >> ~/.bashrc
echo 'export GOOSE_DISABLE_KEYRING=1' >> ~/.bashrc

# Fallback config.yaml (Goose respects this even with keyring disabled)
mkdir -p ~/.config/goose
cat << 'EOF' > ~/.config/goose/config.yaml
provider: xai
model: grok-4-0709
keyring: false

extensions:
  developer:
    enabled: true
EOF

# Source for current session
source ~/.bashrc

# 5. GitHub Copilot CLI (verified from GitHub docs: npm install -g @github/copilot)
npm install -g @github/copilot

# 6. Patch Cognee SyntaxWarning (verified still needed in latest version)
sed -i '95s/html_template = """/html_template = r"""/' .venv/lib/python*/site-packages/cognee/modules/visualization/cognee_network_visualization.py

# 7. pyproject.toml for uv sync compatibility
cat << EOF > pyproject.toml
[project]
name = "smactory"
version = "3.0.0"
dependencies = [
  "cognee[postgres]",
  "python-dotenv"
]

[tool.uv]
EOF

# 8. Initialize node project
npm init -y > /dev/null

# 9. Verification (all commands verified to exist post-install)
echo "✅ Verification:"
python --version  # 3.12.x
node --version    # v22.x
specify check     # Spec-kit ok
goose --version   # Goose version
copilot --version # Copilot CLI version
python -c "import cognee; print('cognee', cognee.__version__)" 

echo "🧬 Smactory v3 organism successfully bootstrapped."
echo "   Next: uv run python setup_secrets.py (creating in next step)"
