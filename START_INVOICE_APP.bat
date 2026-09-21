@echo off
setlocal
cd /d "%~dp0"
set "PORT=8000"
set "URL=http://localhost:%PORT%/"

REM Reuse an already-running copy only if it serves this invoice app.
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $r=Invoke-WebRequest -UseBasicParsing -Uri 'http://127.0.0.1:%PORT%/' -TimeoutSec 2; if($r.StatusCode -eq 200 -and $r.Content -match 'Mehta Sanay Invoice'){exit 0}else{exit 1} } catch { exit 1 }" >nul 2>nul
if %errorlevel%==0 goto OPEN

REM If the port is occupied by something else, don't start a competing server.
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $c=New-Object Net.Sockets.TcpClient; $c.Connect('127.0.0.1',%PORT%); $c.Close(); exit 0 } catch { exit 1 }" >nul 2>nul
if %errorlevel%==0 goto PORT_IN_USE

where py >nul 2>nul
if %errorlevel%==0 goto START_PY
where python >nul 2>nul
if %errorlevel%==0 goto START_PYTHON
where npx >nul 2>nul
if %errorlevel%==0 goto START_NPX

echo.
echo Python or Node.js was not found.
echo Install Python from python.org, then run this file again.
pause
exit /b 1

:START_PY
start "Mehta Sanay Invoice Server" /min cmd /c "py -m http.server %PORT%"
goto WAIT

:START_PYTHON
start "Mehta Sanay Invoice Server" /min cmd /c "python -m http.server %PORT%"
goto WAIT

:START_NPX
start "Mehta Sanay Invoice Server" /min cmd /c "npx -y http-server -p %PORT% -c-1"
goto WAIT

:WAIT
set /a ATTEMPTS=0
:CHECK
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $r=Invoke-WebRequest -UseBasicParsing -Uri 'http://127.0.0.1:%PORT%/' -TimeoutSec 2; if($r.StatusCode -eq 200 -and $r.Content -match 'Mehta Sanay Invoice'){exit 0}else{exit 1} } catch { exit 1 }" >nul 2>nul
if %errorlevel%==0 goto OPEN
set /a ATTEMPTS+=1
if %ATTEMPTS% GEQ 30 goto TIMEOUT
timeout /t 1 /nobreak >nul
goto CHECK

:OPEN
start "" "%URL%"
exit /b 0

:PORT_IN_USE
echo.
echo Port %PORT% is already in use by another application.
echo Close that application or change PORT in this batch file, then retry.
pause
exit /b 1

:TIMEOUT
echo.
echo The invoice server did not become ready on port %PORT%.
echo Check the server window for startup errors, then retry.
pause
exit /b 1
