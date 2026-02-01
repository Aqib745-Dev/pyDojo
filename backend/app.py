from fastapi import FastAPI
from pydantic import BaseModel
import subprocess, tempfile, os, sys, re

app = FastAPI(title="PyDojo Sandbox (DEV)")

DENY_IMPORTS = [
    "os", "sys", "subprocess", "socket", "pathlib", "shutil", "ctypes",
    "resource", "signal", "multiprocessing", "threading"
]
MAX_OUTPUT_CHARS = 8000
TIMEOUT_SECONDS = 2.0

class RunReq(BaseModel):
    code: str
    stdin: str | None = None

class RunRes(BaseModel):
    stdout: str
    stderr: str
    passed: bool

def _looks_unsafe(code: str) -> str | None:
    for mod in DENY_IMPORTS:
        if re.search(rf"(^|\n)\s*(import\s+{mod}|from\s+{mod}\s+import)", code):
            return f"Import '{mod}' is not allowed in this sandbox."
    if "open(" in code or "__import__(" in code:
        return "File access and dynamic imports are not allowed in this sandbox."
    if "eval(" in code or "exec(" in code:
        return "Dynamic execution is not allowed in this sandbox."
    return None

@app.post("/run", response_model=RunRes)
def run_code(req: RunReq):
    unsafe_reason = _looks_unsafe(req.code)
    if unsafe_reason:
        return RunRes(stdout="", stderr=unsafe_reason, passed=False)

    with tempfile.TemporaryDirectory() as td:
        path = os.path.join(td, "main.py")
        with open(path, "w", encoding="utf-8") as f:
            f.write(req.code)

        try:
            proc = subprocess.run(
                [sys.executable, path],
                input=(req.stdin or "").encode("utf-8"),
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                timeout=TIMEOUT_SECONDS,
                cwd=td,
                env={"PYTHONIOENCODING": "utf-8"},
            )
            out = proc.stdout.decode("utf-8", errors="replace")
            err = proc.stderr.decode("utf-8", errors="replace")
        except subprocess.TimeoutExpired:
            return RunRes(stdout="", stderr="Timed out. Try a smaller solution.", passed=False)

    out = out[:MAX_OUTPUT_CHARS]
    err = err[:MAX_OUTPUT_CHARS]
    passed = (proc.returncode == 0 and err.strip() == "")
    return RunRes(stdout=out, stderr=err, passed=passed)
