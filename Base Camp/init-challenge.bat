@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: --- Configuration ---
set SEASON=%~1
set WEEK=%~2
set PROJECT_NAME=%~3
set TEMPLATE_DIR=.\templates\django-vue-base
set KB_CHECKLIST=..\..\Base Camp\knowledge-base\django-postgres-checklist.md

:: --- Validation ---
if "%PROJECT_NAME%"=="" (
    echo ❌ Error: Missing arguments.
    echo Usage: init-challenge.bat [Season] [Week] [Project-Name]
    echo Example: init-challenge.bat S1-Mastery Week-05 task-tracker
    exit /b 1
)

set TARGET_DIR=..\!SEASON!\!WEEK!-!PROJECT_NAME!

:: --- Interactive Goal Setting ---
echo 📝 What is the primary goal for %WEEK%?
set /p WEEKLY_GOAL="> "

:: --- Execution ---
echo 🚀 Initializing: %WEEK% ^| %PROJECT_NAME%...

:: 1. Create Season/Week directory
if exist "!TARGET_DIR!" (
    echo ⚠️  Warning: !TARGET_DIR! already exists. Skipping creation.
) else (
    mkdir "!TARGET_DIR!"
    echo 📁 Created folder: !TARGET_DIR!
)

:: 2. Copy Boilerplate (The Windows version of rsync)
echo 📦 Injecting Clean Slate Boilerplate...
:: /E copies subdirectories, /XD and /XF exclude specific folders and files
robocopy "%TEMPLATE_DIR%" "!TARGET_DIR!" /E /XF .git node_modules .venv __pycache__ db.sqlite3 *.pyc /XD .git node_modules .venv __pycache__ .idea /NFL /NDL /NJH /NJS

:: 2.5 Customize Frontend Brand Name (Title Case Logic)
echo 🎨 Personalizing frontend brand...

:: Use PowerShell to convert kebab-case to Title Case (task-tracker -> Task Tracker)
for /f "usebackq tokens=*" %%i in (`powershell -Command "(Get-Culture).TextInfo.ToTitleCase('%PROJECT_NAME%'.Replace('-', ' '))"`) do set FORMATTED_NAME=%%i

:: Paths to files
set APP_VUE_PATH=!TARGET_DIR!\frontend\src\App.vue
set INDEX_HTML_PATH=!TARGET_DIR!\frontend\index.html

:: Update App.vue brand using PowerShell Find/Replace
if exist "!APP_VUE_PATH!" (
    powershell -Command "(Get-Content '!APP_VUE_PATH!') -replace 'Vue 3 \+ Vite \+ Django', '!FORMATTED_NAME!' | Set-Content '!APP_VUE_PATH!'"
    echo ✅ App.vue brand set to: !FORMATTED_NAME!
)

:: Update index.html title
if exist "!INDEX_HTML_PATH!" (
    powershell -Command "(Get-Content '!INDEX_HTML_PATH!') -replace '<title>Vue 3 \+ Vite</title>', '<title>!FORMATTED_NAME!</title>' | Set-Content '!INDEX_HTML_PATH!'"
    echo ✅ index.html title set to: !FORMATTED_NAME!
)

:: 3. Setup Environment Files
if exist "!TARGET_DIR!\.env.example" (
    copy "!TARGET_DIR!\.env.example" "!TARGET_DIR!\.env" >nul
    echo ✅ Created .env from .env.example
)

:: 4. Generate the Weekly README
echo 📝 Customizing Weekly README...
(
echo # %WEEK%: !FORMATTED_NAME!
echo ^> **Season:** %SEASON%
echo ^> **Status:** 🟡 In Progress
echo ^> **Template:** Clean Slate (Auth-Only^)
echo.
echo ## 🎯 Weekly Challenge Goal
echo %WEEKLY_GOAL%
echo.
echo ## 🛠️ Stack
echo - **Frontend:** Vue 3 (Vite + Pinia^)
echo - **Backend:** Django REST Framework (Custom User Auth^)
echo - **Database:** PostgreSQL
echo - **Orchestration:** Docker Compose
echo.
echo ## 📅 Refactor Schedule
echo - **Monday-Wednesday:** Feature implementation.
echo - **Thursday:** Use the [Optimization Checklist](%KB_CHECKLIST%^) to refactor and optimize.
echo - **Friday:** Final testing and Launch.
echo.
echo ## 🚦 Getting Started
echo 1. \`cd %SEASON%/%WEEK%-%PROJECT_NAME%\`
echo 2. \`docker-compose up --build\`
) > "!TARGET_DIR!\README.md"

:: 5. Success Message
echo --------------------------------------------------------
echo ✨ Setup Complete!
echo 📍 Location: !TARGET_DIR!
echo 💻 Next Steps:
echo    1. cd "!TARGET_DIR!"
echo    2. docker-compose up
echo --------------------------------------------------------