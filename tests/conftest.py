import os
import sys
from pathlib import Path

# Ensure 'src' is on sys.path for test imports like 'from math_utils import add'
REPO_ROOT = Path(__file__).resolve().parents[1]
SRC = REPO_ROOT / "src"
if SRC.exists():
    sys.path.insert(0, str(SRC))
    os.environ.setdefault("PYTHONPATH", str(SRC))
