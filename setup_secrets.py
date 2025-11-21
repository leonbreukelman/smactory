from pathlib import Path
import os
import subprocess
import secrets
import string
from dotenv import load_dotenv, set_key

ENV_PATH = Path(".env")
load_dotenv(ENV_PATH, override=True)

SUPERUSER_PW = "smactory_temp_2025_change_me"  # known only inside container, safe

def gen_pw(length=64):
    chars = string.ascii_letters + string.digits + "!@#$%^&*()"
    return "".join(secrets.choice(chars) for _ in range(length))

# Rotate cognee_user password to strong random
print("🔑 Rotating cognee_user password to strong random value...")
new_pw = gen_pw()

env = os.environ.copy()
env["PGPASSWORD"] = SUPERUSER_PW

subprocess.check_call([
    "psql", "-h", "db", "-U", "postgres", "-d", "cognee_db",
    "-c", f"ALTER USER cognee_user WITH PASSWORD '{new_pw}';"
], env=env)

# Update .env with new strong password
new_url = f"postgresql://cognee_user:{new_pw}@db:5432/cognee_db"
set_key(ENV_PATH, "COGNEE_DATABASE_URL", new_url)

print("✅ cognee_user password rotated and .env updated")

# Rest of your API key prompts...
keys = ["XAI_API_KEY", "GROQ_API_KEY", "OPENAI_API_KEY", "ANTHROPIC_API_KEY", "GITHUB_TOKEN"]
for key in keys:
    if not os.getenv(key) or os.getenv(key).startswith("replace"):
        value = input(f"Enter {key}: ").strip()
        if value:
            set_key(ENV_PATH, key, value)

print("🧬 All secrets configured – rebuild only if you want, not required")
