#!/usr/bin/env bash
# One-click start for macOS / Linux:  bash start_mac_linux.sh
set -e
cd "$(dirname "$0")"
echo "============================================================"
echo "  Healthcare Detection with AI Assistant - one-click start"
echo "============================================================"
PY=$(command -v python3 || command -v python || true)
if [ -z "$PY" ]; then
  echo "Python 3 was not found. Install Python 3.11-3.13 from https://www.python.org/downloads/ and run this again."
  exit 1
fi
if [ ! -x ".venv/bin/python" ]; then
  echo "[1/3] Creating a private Python environment..."
  "$PY" -m venv .venv
fi
source .venv/bin/activate
if [ ! -f ".venv/installed.flag" ]; then
  echo "[2/3] Installing free libraries - first time only, takes a few minutes..."
  python -m pip install --upgrade pip
  pip install -r requirements.txt
  touch .venv/installed.flag
fi
echo "[3/3] Starting the app - your browser will open automatically..."
echo "      (Press CTRL+C to stop the app.)"
python run.py --open
