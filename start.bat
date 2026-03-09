@echo off
REM Smart Healthcare System - Startup Script
REM ========================================
REM This script starts both backend (Flask) and frontend (served by Flask)

echo.
echo ========================================
echo   Smart Healthcare System
echo   Starting Backend & Frontend...
echo ========================================
echo.

echo [1/2] Installing dependencies...
pip install -r requirements.txt

echo.
echo [2/2] Starting Flask server (Backend + Frontend)...
echo.
echo The application will be available at:
echo   - Backend API: http://localhost:5000
echo   - Frontend:    http://localhost:5000
echo.
echo Press Ctrl+C to stop the server
echo.

python app.py

pause
