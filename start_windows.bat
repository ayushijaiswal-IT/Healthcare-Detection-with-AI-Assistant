@echo off
title Healthcare Detection with AI Assistant
cd /d "%~dp0"
echo ============================================================
echo   Healthcare Detection with AI Assistant - one-click start
echo ============================================================
where python >nul 2>nul
if errorlevel 1 (
  echo.
  echo Python was not found. Install Python 3.11, 3.12 or 3.13 from https://www.python.org/downloads/
  echo IMPORTANT: tick "Add python.exe to PATH" during installation, then run this file again.
  pause
  exit /b 1
)
if not exist ".venv\Scripts\python.exe" (
  echo [1/3] Creating a private Python environment...
  python -m venv .venv || (echo Could not create the environment. & pause & exit /b 1)
)
call ".venv\Scripts\activate.bat"
if not exist ".venv\installed.flag" (
  echo [2/3] Installing free libraries - first time only, takes a few minutes...
  python -m pip install --upgrade pip
  pip install -r requirements.txt || (echo Installation failed - check your internet connection. & pause & exit /b 1)
  echo done> ".venv\installed.flag"
)
echo [3/3] Starting the app - your browser will open automatically...
echo       (Leave this window open. Close it or press CTRL+C to stop the app.)
python run.py --open
pause
