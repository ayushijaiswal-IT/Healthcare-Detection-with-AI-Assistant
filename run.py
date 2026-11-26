"""
One-command launcher.

    python run.py              # trains the models if needed, then starts the web app
    python run.py --retrain    # force re-training first
    python run.py --port 9000

Then open http://127.0.0.1:8000
"""
from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
MODELS = ["condition_model.joblib", "diabetes_model.joblib", "heart_model.joblib"]


def models_ok() -> bool:
    if not all((ROOT / "models" / m).exists() for m in MODELS):
        return False
    try:  # also verify they load with the installed library versions
        import joblib

        for m in MODELS:
            joblib.load(ROOT / "models" / m)
        return True
    except Exception as exc:  # noqa: BLE001
        print(f"[run] Saved models could not be loaded ({exc.__class__.__name__}); re-training.")
        return False


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--host", default="127.0.0.1")
    ap.add_argument("--port", type=int, default=8000)
    ap.add_argument("--retrain", action="store_true")
    ap.add_argument("--fast", action="store_true", help="quicker training (fewer tuning iterations)")
    ap.add_argument("--reload", action="store_true")
    ap.add_argument("--open", action="store_true", help="open the web browser automatically when the app is ready")
    args = ap.parse_args()

    if args.retrain or not models_ok():
        print("[run] Training models (first run takes a few minutes)...")
        cmd = [sys.executable, "-m", "ml.train_all"] + (["--fast"] if args.fast else [])
        subprocess.run(cmd, cwd=ROOT, check=True)
    if not any((ROOT / "data" / "samples").glob("*.pdf")):
        subprocess.run([sys.executable, "-m", "scripts.generate_sample_reports"], cwd=ROOT, check=True)

    import uvicorn

    url = f"http://{args.host}:{args.port}"
    if args.open:
        import threading
        import time
        import urllib.request
        import webbrowser

        def _open_when_ready() -> None:
            for _ in range(120):
                try:
                    urllib.request.urlopen(f"{url}/api/health", timeout=1)
                    webbrowser.open(url)
                    return
                except Exception:  # noqa: BLE001 - server not up yet
                    time.sleep(1)

        threading.Thread(target=_open_when_ready, daemon=True).start()
    print(f"[run] Open {url}  (API docs: /docs)   Press CTRL+C to stop.")
    uvicorn.run("app.main:app", host=args.host, port=args.port, reload=args.reload)


if __name__ == "__main__":
    main()
