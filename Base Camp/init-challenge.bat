@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

:: --- Configuration ---
set SEASON=%1
set WEEK=%2
set PROJECT_NAME=%3
set KB_CHECKLIST=../../Base Camp/knowledge-base/django-postgres-checklist.md
set PORT_REGISTRY=port_registry.txt

:: Modular Lego Pieces Paths
set BACKEND_SRC=.\templates\django-vue-base\shared-backend
set INFRA_SRC=.\templates\django-vue-base\shared-infra

:: --- Validation ---
if "%PROJECT_NAME%"=="" (
    echo [31m❌ Error: Missing arguments.[0m
    echo Usage: init-challenge.bat [Season] [Week] [Project-Name]
    exit /b 1
)

:: --- 1. SMART PORT CALCULATION ---
if not exist "%PORT_REGISTRY%" type nul > "%PORT_REGISTRY%"

set CURRENT_OFFSET=1
for /f "tokens=1 delims=:" %%a in ('type "%PORT_REGISTRY%"') do set LAST_OFFSET=%%a

if not "%LAST_OFFSET%"=="" (
    set /a CURRENT_OFFSET=%LAST_OFFSET% + 1
)

set /a FE_PORT=5000 + %CURRENT_OFFSET%
set /a BE_PORT=8000 + %CURRENT_OFFSET%

:: --- Template Selection ---
echo [34m🎨 Choose your Frontend Style:[0m
echo 1) Base  2) Dashboard  3) Terminal  4) Minimalist
set /p STYLE_CHOICE="Select [1-4]: "

if "%STYLE_CHOICE%"=="2" (
    set FE_SRC=.\templates\django-vue-base\frontend-dashboard
    set STYLE_NAME=Dashboard
) else if "%STYLE_CHOICE%"=="3" (
    set FE_SRC=.\templates\django-vue-base\frontend-terminal
    set STYLE_NAME=Terminal
) else if "%STYLE_CHOICE%"=="4" (
    set FE_SRC=.\templates\django-vue-base\frontend-minimal
    set STYLE_NAME=Minimalist
) else (
    set FE_SRC=.\templates\django-vue-base\frontend
    set STYLE_NAME=Base
)

set TARGET_DIR=..\!SEASON!\!WEEK!\!PROJECT_NAME!

:: --- Interactive Goal Setting ---
echo [32m📝 What is the primary goal for %WEEK%?[0m
set /p WEEKLY_GOAL="> "

:: --- Execution ---
echo [36m🚀 Initializing: %WEEK% | %PROJECT_NAME% (Ports: FE:%FE_PORT%, BE:%BE_PORT%)...[0m

:: 1. Create Target Directory
if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"

:: 2. Modular Assembly (Using Robocopy instead of rsync)
:: /E (subdirs) /NJH /NJS (quiet) /XD (exclude dirs)
robocopy "%BACKEND_SRC%" "%TARGET_DIR%\backend" /E /NJH /NJS /XD .venv __pycache__ .git
robocopy "%FE_SRC%" "%TARGET_DIR%\frontend" /E /NJH /NJS /XD node_modules .idea .git
robocopy "%INFRA_SRC%" "%TARGET_DIR%" /E /NJH /NJS

:: --- 3. INFRASTRUCTURE ORCHESTRATION (The Magic Part) ---
:: Use PowerShell for text replacement (replaces sed)
set SAFE_NAME=%PROJECT_NAME:-=_%

powershell -Command "(Get-Content '%TARGET_DIR%\docker-compose.yml') -replace 'postgres_data', '%SAFE_NAME%_db_data' | Set-Content '%TARGET_DIR%\docker-compose.yml'"
powershell -Command "(Get-Content '%TARGET_DIR%\docker-compose.yml') -replace '5173:5173', '%FE_PORT%:5173' | Set-Content '%TARGET_DIR%\docker-compose.yml'"
powershell -Command "(Get-Content '%TARGET_DIR%\docker-compose.yml') -replace '8000:8000', '%BE_PORT%:8000' | Set-Content '%TARGET_DIR%\docker-compose.yml'"

:: Update Frontend .env
if exist "%TARGET_DIR%\.env.example" (
    copy "%TARGET_DIR%\.env.example" "%TARGET_DIR%\.env" >nul
    powershell -Command "(Get-Content '%TARGET_DIR%\.env') -replace 'VITE_API_URL=.*', 'VITE_API_URL=http://localhost:%BE_PORT%/' | Set-Content '%TARGET_DIR%\.env'"
)

:: --- 4. SUCCESS LOGGING ---
echo %CURRENT_OFFSET%:%FE_PORT%:%BE_PORT%:%SEASON%/%WEEK%/%PROJECT_NAME% >> %PORT_REGISTRY%

echo --------------------------------------------------------
echo [32m✨ %STYLE_NAME% Project Ready with Unique Ports![0m
echo 📍 FE: http://localhost:%FE_PORT%
echo 📍 BE: http://localhost:%BE_PORT%
echo --------------------------------------------------------

pause