@echo off
REM AI Workshop Setup Script for Windows
REM Run this from your ai-starter-kit folder

echo.
echo ====================================
echo    AI Workshop Setup Wizard
echo    Let's get your project ready!
echo ====================================
echo.

REM Check for GitHub CLI
where gh >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] GitHub CLI not found. Please run setup.bat first
    pause
    exit /b 1
)

REM Check GitHub auth
gh auth status >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Not logged into GitHub. Let's fix that!
    gh auth login
)

echo [OK] Prerequisites checked
echo.

REM Get repository name from PRD
set PRD_FILE=docs\prds\current\PROJECT_PRD.md

if not exist "%PRD_FILE%" (
    echo [!] PRD not found at %PRD_FILE%. Please create your PRD first.
    pause
    exit /b 1
)

REM Extract project name from PRD
for /f "tokens=*" %%i in ('findstr /B "# PRD: # Project Name:" "%PRD_FILE%" 2^>nul') do (
    set LINE=%%i
    goto :found
)
:found

if defined LINE (
    REM Remove the # PRD: or # Project Name: prefix
    set PROJECT_NAME=%LINE:~2%
    set PROJECT_NAME=%PROJECT_NAME:PRD: =%
    set PROJECT_NAME=%PROJECT_NAME:Project Name: =%
    
    REM Check if it's still a placeholder
    echo %PROJECT_NAME% | findstr /C:"[Your" >nul
    if %errorlevel% equ 0 (
        echo [!] PRD still has placeholder name
        set /p REPO_NAME="Enter your project name (lowercase, no spaces): "
    ) else (
        echo [OK] Found project name in PRD: %PROJECT_NAME%
        
        REM Convert to valid repo name - this is limited in batch
        REM For simplicity, ask user to confirm/provide valid name
        echo Repository name needs to be lowercase with no spaces
        set /p REPO_NAME="Enter repository name (or press Enter to use suggested): "
        if "%REPO_NAME%"=="" (
            echo Please enter a valid repository name:
            set /p REPO_NAME="Repository name (lowercase, no spaces): "
        )
    )
) else (
    echo [!] Could not extract project name from PRD
    set /p REPO_NAME="Enter your project name (lowercase, no spaces): "
)

REM Create repository
echo.
echo Creating GitHub repository: %REPO_NAME%

gh repo view %REPO_NAME% >nul 2>&1
if %errorlevel% equ 0 (
    echo [!] Repository already exists
    set /p USE_EXISTING="Use existing repository? (y/n): "
    if /i not "%USE_EXISTING%"=="y" exit /b 1
) else (
    gh repo create %REPO_NAME% --private --description "AI Development Workshop Project"
    
    REM Update local git remote
    for /f "tokens=*" %%i in ('gh api user --jq .login') do set GITHUB_USER=%%i
    git remote set-url origin "https://github.com/%GITHUB_USER%/%REPO_NAME%.git"
    
    REM Rename the local directory
    cd ..
    ren "%CD%" "%REPO_NAME%"
    cd "%REPO_NAME%"
    
    REM Push to new repo
    git push -u origin main
)

echo [OK] Repository ready

REM Enable GitHub Actions
echo Enabling GitHub Actions...
gh api -X PUT "repos/{owner}/%REPO_NAME%/actions/permissions" -f enabled=true -f allowed_actions=all >nul 2>&1
gh api -X PUT "repos/{owner}/%REPO_NAME%/actions/permissions/workflow" -f default_workflow_permissions=write -f can_approve_pull_request_reviews=true >nul 2>&1

echo [OK] GitHub Actions enabled

REM Create labels
echo Creating issue labels...

call :create_label "enhancement" "a2eeef" "New feature or request"
call :create_label "bug" "d73a4a" "Something isn't working"
call :create_label "needs-triage" "008672" "Needs review"
call :create_label "parent-issue" "5319e7" "Issue that requires subtasks"
call :create_label "needs-subtasks" "e99695" "Parent issue needs breakdown"
call :create_label "stale" "ffffff" "No activity for 30 days"
call :create_label "in-progress" "0052cc" "Currently being worked on"
call :create_label "blocked" "b60205" "Blocked by dependencies"

echo [OK] Labels created

REM Create parent issue
echo Creating parent issue for PRD parsing...

echo # Parse PRD into Development Tasks > issue_body.txt
echo. >> issue_body.txt
echo ## 🎯 Overview >> issue_body.txt
echo **Estimated Total Effort**: 4-6 subtasks across 1-2 weeks >> issue_body.txt
echo **Priority**: High >> issue_body.txt
echo **Complexity**: Medium >> issue_body.txt
echo. >> issue_body.txt
echo ## 🚨 Mandatory Reading >> issue_body.txt
echo Before starting ANY work: >> issue_body.txt
echo 1. **MUST READ**: [.cursor/rules/CRITICAL_CORE.mdc](.cursor/rules/CRITICAL_CORE.mdc) - Universal development principles >> issue_body.txt
echo 2. Review the acceptance criteria below >> issue_body.txt
echo. >> issue_body.txt
echo ## 📋 High-Level Description >> issue_body.txt
echo This parent issue tracks the breakdown of our Product Requirements Document (PRD) into actionable development tasks. The PRD is located at `docs/prds/current/PROJECT_PRD.md`. >> issue_body.txt
echo. >> issue_body.txt
echo The subtasks created from this issue will form our development roadmap, with each task sized for 1-2 days of work. >> issue_body.txt
echo. >> issue_body.txt
echo ## ✅ Acceptance Criteria >> issue_body.txt
echo - [ ] PRD has been thoroughly reviewed >> issue_body.txt
echo - [ ] 4-6 subtask issues created using newcomer-standard-issue template >> issue_body.txt
echo - [ ] Each subtask has clear acceptance criteria >> issue_body.txt
echo - [ ] Subtasks are properly linked to this parent issue >> issue_body.txt
echo - [ ] All subtasks follow the 1-2 day sizing guideline >> issue_body.txt
echo - [ ] Dependencies between tasks are documented >> issue_body.txt

gh issue create --title "Parse PRD into Development Tasks" --body-file issue_body.txt --label "parent-issue,needs-subtasks" --repo %REPO_NAME%
del issue_body.txt

echo [OK] Created parent issue #1

REM Success message
echo.
echo ====================================
echo      Setup Complete!
echo ====================================
echo.
echo Your repository: https://github.com/{owner}/%REPO_NAME%
echo Parent Issue: #1 - Parse PRD into Development Tasks
echo.
echo Workshop Ready! Next Steps:
echo 1. Your PRD is at: docs/prds/current/PROJECT_PRD.md
echo 2. Parent issue #1 is ready to work on
echo 3. Open Cursor and start the workshop!
echo.
echo Everything is set up! Time to build!
echo.

set /p OPEN_BROWSER="Open repository in browser? (y/n): "
if /i "%OPEN_BROWSER%"=="y" (
    gh repo view --web
)

pause
goto :eof

:create_label
gh label create "%~1" --color "%~2" --description "%~3" --force >nul 2>&1
goto :eof