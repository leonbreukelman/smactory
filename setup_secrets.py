# setup_secrets.py
from pathlib import Path
import secrets
import string

from dotenv import load_dotenv

ENV = Path(".env")

def gen_pw(length: int = 48) -> str:
    """Generate a secure random password."""
    chars = string.ascii_letters + string.digits + "!@#$%^&*()"
    return "".join(secrets.choice(chars) for _ in range(length))

if not ENV.exists():
    print("🔑 No .env found → generating secure defaults")
    password = gen_pw()
    content = f"""# Smactory v3 — auto-generated on first boot
COGNEE_DB_PASSWORD={password}
XAI_API_KEY=replace_with_your_xai_key
OPENAI_API_KEY=sk-..._optional
GOOSE_PROVIDER=xai
GOOSE_MODEL=grok-4-0709
GOOSE_DISABLE_KEYRING=1
COGNEE_DATABASE_URL=postgresql://cognee_user:{password}@db:5432/cognee_db
"""
    ENV.write_text(content)
    print(f"✅ .env created")
    print(f"   Postgres password: {password}")
    print("   ⚠️  Immediately replace XAI_API_KEY (and OpenAI if you use it)!")
else:
    print("✅ .env already exists – skipping generation (keeping existing DB password)")

# Load into current environment (useful when run manually)
load_dotenv(override=True)
print("🧬 Secrets loaded into session")
print("🧬 Secrets loaded. Rebuild container to apply DB password.")
