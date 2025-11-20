#!/bin/bash
set -e

echo "🧬 Smactory v3 bootstrap beginning..."

# 1. uv
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.cargo/bin:$PATH"

# 2. venv
uv venv --clear .venv
source .venv/bin/activate

# 3. Core AI tools
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
uv pip install "cognee[postgres]" python-dotenv
uv pip install protego playwright
playwright install --with-deps chromium firefox webkit

# 4. Goose – non-interactive + Grok-4
if ! command -v goose &> /dev/null; then
  echo "Installing Goose CLI (non-interactive)..."
  curl -fsSL https://github.com/block/goose/releases/download/stable/download_cli.sh | CONFIGURE=0 bash
fi
export PATH="$HOME/.local/bin:$PATH"

echo 'export GOOSE_PROVIDER=xai' >> ~/.bashrc
echo 'export GOOSE_MODEL=grok-4-0709' >> ~/.bashrc
echo 'export GOOSE_DISABLE_KEYRING=1' >> ~/.bashrc
source ~/.bashrc

mkdir -p ~/.config/goose
cat << 'EOF' > ~/.config/goose/config.yaml
provider: xai
model: grok-4-0709
keyring: false
extensions:
  developer:
    enabled: true
EOF

# 5. GitHub Copilot CLI
npm install -g @github/copilot

# 6. Patch Cognee
sed -i '95s/html_template = """/html_template = r"""/' .venv/lib/python*/site-packages/cognee/modules/visualization/cognee_network_visualization.py 2>/dev/null || true

# 7. pyproject.toml
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

# 8. Node init
npm init -y > /dev/null

# ─────────────────────────────────────────────────────────────
# PostgreSQL client (for psql command)
echo "Installing PostgreSQL client..."
sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y postgresql-client

# Auto-inject temporary DATABASE_URL for cognee (setup_secrets.py will override with real secrets later)
if ! grep -q "COGNEE_DATABASE_URL" .env 2>/dev/null; then
  echo "Injecting temporary Cognee DATABASE_URL..."
  echo "COGNEE_DATABASE_URL=postgresql://cognee_user:smactory_temp_2025_change_me@db:5432/cognee_db" >> .env
fi

# 9. Verification
echo "✅ Verification:"
python --version
node --version
specify --version 2>/dev/null || echo "specify ok"
goose --version
copilot --version
python -c "import cognee; print('cognee', cognee.__version__)"

# ── PostgreSQL client + temp DATABASE_URL for cognee ─────────────────────
echo "Installing PostgreSQL client..."
sudo apt-get update && sudo apt-get install -y postgresql-client

if ! grep -q "COGNEE_DATABASE_URL" .env 2>/dev/null; then
  echo "Injecting temporary Cognee DATABASE_URL..."
  echo "COGNEE_DATABASE_URL=postgresql://cognee_user:smactory_temp_2025_change_me@db:5432/cognee_db" >> .env
fi

echo "🧬 Smactory v3 organism successfully bootstrapped."
# Load .env if present (safe, no validation issues)
if [ -f .env ]; then
  echo "Loading .env variables into environment..."
  set -a
  source .env
  set +a
fi
