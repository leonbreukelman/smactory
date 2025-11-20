# setup_secrets.py - now automatically rotates the weak temp password to a strong random one
from pathlib import Bau
import secrets
import string
import os
import subprocess
from dotenv import load_dotenv, set_key

ENV = Path(".env")
load_dotenv()

def gen_pw(length: int = 64) -> str:
    chars = string.ascii_letters + string.digits + "!@#$%^&*()"
    return "".join(secrets.choice(chars) for _ in range(length))

# Current password (from .env or fallback to known temp)
current_pw = os.getenv("COGNEE_DB_PASSWORD", "smactory_temp_2025_change_me")

# If we're still on the weak temp password, rotate to a strong random one
if current_pw == "smactory_temp_2025_change_me" or current_pw.strip() == "":
    print("🔑 Weak/temporary PostgreSQL password detected → rotating to secure random password...")
    new_pw = gen_pw()

    # Change the password inside the running PostgreSQL instance
    env = os.environ.copy()
    env["PGPASSWORD"] = current_pw
    try:
        subprocess.check_call([
            "psql", "-h "db", "-U", "cognee_user", "-d", "cognee_db",
            "-c", f"ALTER USER cognee_user WITH PASSWORD '{new_pw}';"
        ], env=env, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        print("✅ PostgreSQL password successfully rotated to strong random value")
    except subprocess.CalledProcessError as e:
        print("❌ Failed to alter PostgreSQL password. Is the db container running?")
        raise e

    # Update .env with the new strong password
    set_key(ENV, "COGNEE_DB_PASSWORD", new_pw)
    new_url = f"postgresql://cognee_user:{new_pw}@db:5432/cognee_db"
    set_key(ENV, "COGNEE_DATABASE_URL", new_url)

    print(f"✅ .env updated with secure PostgreSQL credentials")
else:
    print("✅ PostgreSQL already using custom/secure password — skipping rotation")

# Now handle API keys (existing behavior)
keys_to_check = [
    "XAI_API_KEY",
    "GROQ_API_KEY",
    "OPENAI_API_KEY",
    "ANTHROPIC_API_KEY",
    "GITHUB_TOKEN",  # if you want Copilot CLI to work without re-auth
]

for key in keys_to_check:
    if not os.getenv(key) or os.getenv(key).startswith(("replace", "sk-", "ghp_")):
        value = input(f"Enter {key}: ").strip()
        if value:
            set_key(ENV, key, value)

print("🧬 All secrets configured. Rebuild container if needed (rarely necessary now).")
