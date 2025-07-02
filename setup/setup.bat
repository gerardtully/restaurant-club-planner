@echo off
REM AI Development Setup Script for Windows
REM This script guides you through installing everything needed

echo.
echo ====================================
echo AI Development Environment Setup
echo ====================================
echo.

REM Check for Node.js
where node >nul 2>1
if %errorlevel% neq 0 (
    echo [!] Node.js not found
    echo Please install Node.js from https://nodejs.org/
    echo Download the LTS version and run the installer
    echo.
    pause
    start https://nodejs.org/
    echo Run this script again after installing Node.js
    goto :end
) else (
    echo [OK] Node.js is installed
)

REM Check for Git
where git >nul 2>1
if %errorlevel% neq 0 (
    echo [!] Git not found
    echo Please install Git from https://git-scm.com/
    echo.
    pause
    start https://git-scm.com/download/win
    echo Run this script again after installing Git
    goto :end
) else (
    echo [OK] Git is installed
)

REM Check for GitHub CLI
where gh >nul 2>1
if %errorlevel% neq 0 (
    echo [!] GitHub CLI not found
    echo Installing GitHub CLI...
    winget install --id GitHub.cli
    if %errorlevel% neq 0 (
        echo.
        echo Could not install automatically.
        echo Please install from https://cli.github.com/
        pause
        start https://cli.github.com/
    )
) else (
    echo [OK] GitHub CLI is installed
)

REM Install Claude Code
echo.
echo Installing Claude Code...
where claude >nul 2>1
if %errorlevel% neq 0 (
    call npm install -g @anthropic-ai/claude-code
    if %errorlevel% neq 0 (
        echo.
        echo Could not install Claude Code via npm.
        echo Please install Claude Desktop from https://claude.ai/download
        echo This includes Claude Code functionality.
        pause
        start https://claude.ai/download
    )
) else (
    echo [OK] Claude Code is installed
)

REM Cursor
echo.
echo Checking for Cursor...
if not exist "%LOCALAPPDATA%\Programs\cursor\Cursor.exe" (
    echo [!] Cursor not found
    echo Please download Cursor from https://cursor.sh/
    echo Install it and then continue
    pause
    start https://cursor.sh/
    echo.
    echo Press any key after installing Cursor...
    pause >nul
) else (
    echo [OK] Cursor is installed
)

REM Install web development tools
echo.
echo Installing web development tools...
where npm >nul 2>1
if %errorlevel% equ 0 (
    echo Installing global npm packages...
    
    REM Create React App
    where create-react-app >nul 2>1
    if %errorlevel% neq 0 (
        call npm install -g create-react-app
        echo [OK] create-react-app installed
    )
    
    REM Vite
    where vite >nul 2>1
    if %errorlevel% neq 0 (
        call npm install -g vite
        echo [OK] Vite installed
    )
    
    REM TypeScript
    where tsc >nul 2>1
    if %errorlevel% neq 0 (
        call npm install -g typescript
        echo [OK] TypeScript installed
    )
    
    REM Prettier
    where prettier >nul 2>1
    if %errorlevel% neq 0 (
        call npm install -g prettier
        echo [OK] Prettier installed
    )
    
    REM ESLint
    where eslint >nul 2>1
    if %errorlevel% neq 0 (
        call npm install -g eslint
        echo [OK] ESLint installed
    )
    
    REM Vercel CLI
    where vercel >nul 2>1
    if %errorlevel% neq 0 (
        call npm install -g vercel
        echo [OK] Vercel CLI installed
    )
    
    REM Netlify CLI
    where netlify >nul 2>1
    if %errorlevel% neq 0 (
        call npm install -g netlify-cli
        echo [OK] Netlify CLI installed
    )
    
    echo [OK] Web development tools installed
) else (
    echo [!] npm not found - skipping web tools
)

REM Configure Git
echo.
echo Configuring Git...
git config --global user.name >nul 2>&1
if %errorlevel% neq 0 (
    echo Let's set up your Git identity
    set /p git_name="Enter your name: "
    set /p git_email="Enter your email: "
    git config --global user.name "%git_name%"
    git config --global user.email "%git_email%"
    echo [OK] Git configured
) else (
    echo [OK] Git already configured
)

REM Success
echo.
echo ====================================
echo Setup Complete!
echo ====================================
echo.
echo Next steps:
echo 1. Open Cursor in this folder
echo 2. Read AI_DEVELOPMENT_GUIDE.md
echo 3. Start building with AI!
echo.
echo Quick tips:
echo - Type 'cursor .' to open Cursor here
echo - Type 'claude --help' for Claude commands
echo - Type 'gh issue list' to see GitHub issues
echo.
echo Happy coding!
echo.

:end
pause