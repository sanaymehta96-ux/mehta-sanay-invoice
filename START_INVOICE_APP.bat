@echo off
cd /d "%~dp0"
where py >nul 2>nul
if %errorlevel%==0 goto PY
where python >nul 2>nul
if %errorlevel%==0 goto PYTHON
where npx >nul 2>nul
if %errorlevel%==0 goto NPX
echo.
echo Python or Node.js was not found.
echo Install Python from python.org, then run this file again.
pause
exit /b 1

:PY
start "Mehta Sanay Invoice" http://localhost:8000
py -m http.server 8000
exit /b

:PYTHON
start "Mehta Sanay Invoice" http://localhost:8000
python -m http.server 8000
exit /b

:NPX
start "Mehta Sanay Invoice" http://localhost:8000
npx http-server -p 8000
exit /b
