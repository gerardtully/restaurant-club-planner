#!/bin/bash

# 🎯 AI Workshop Setup Script
# Run this from your local ai-starter-kit folder to set up GitHub automation
# No terminal knowledge needed - just run this once!

set -e  # Exit on any error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Helper functions
print_step() {
    echo -e "\n${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Banner
clear
echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════╗"
echo "║        AI Workshop Setup Wizard           ║"
echo "║   Let's get your project ready! 🚀        ║"
echo "╔═══════════════════════════════════════════╝"
echo -e "${NC}"

# Check prerequisites
print_step "Checking prerequisites..."

if ! command -v gh &> /dev/null; then
    print_error "GitHub CLI not found. Please run ./setup.sh first"
    exit 1
fi

if ! gh auth status &> /dev/null; then
    print_warning "Not logged into GitHub. Let's fix that!"
    gh auth login
fi

print_success "Prerequisites checked"

# Get repository name from PRD
print_step "Setting up your repository"

# Get the script's directory and project root
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../.." && pwd )"

# Check if PRD exists
PRD_FILE="$PROJECT_ROOT/docs/prds/current/PROJECT_PRD.md"
if [ ! -f "$PRD_FILE" ]; then
    print_error "PRD not found at $PRD_FILE"
    print_warning "Please ensure you're running this script from the ai-starter-kit directory"
    print_warning "Or create your PRD at: docs/prds/current/PROJECT_PRD.md"
    exit 1
fi

print_success "Found PRD at $PRD_FILE"

# Extract project name from PRD
PROJECT_NAME=$(grep -E "^# (PRD: |Project Name: )" "$PRD_FILE" | head -1 | sed -E 's/# (PRD: |Project Name: )//' | sed 's/\[Your Product Name\]//' | sed 's/\[Your Project Name\]//' | xargs)

if [ -z "$PROJECT_NAME" ] || [[ "$PROJECT_NAME" == *"["* ]]; then
    print_warning "Could not extract project name from PRD"
    # Generate a default name with timestamp
    REPO_NAME="workshop-project-$(date +%Y%m%d-%H%M%S)"
    print_success "Using default project name: $REPO_NAME"
else
    # Convert to valid repo name (lowercase, replace spaces with hyphens)
    REPO_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/[^a-z0-9-]//g')
    print_success "Found project name in PRD: $PROJECT_NAME"
    print_success "Repository name will be: $REPO_NAME"
fi

# Validate repo name
if [[ ! "$REPO_NAME" =~ ^[a-z0-9-]+$ ]]; then
    print_error "Invalid name. Use only lowercase letters, numbers, and hyphens"
    exit 1
fi

# Create repository
print_step "Creating your GitHub repository: $REPO_NAME"

# Check if repo exists
if gh repo view "$REPO_NAME" &> /dev/null; then
    print_warning "Repository $REPO_NAME already exists"
    print_success "Using existing repository"
else
    # Create new private repo
    gh repo create "$REPO_NAME" --private --description "AI Development Workshop Project"
    
    # Update local git remote
    git remote set-url origin "https://github.com/$(gh api user --jq .login)/$REPO_NAME.git"
    
    # Don't rename directory - just update git config
    print_warning "Keeping current directory name"
    
    # Push to new repo
    git push -u origin main
fi

print_success "Repository ready"

# Enable GitHub Actions
print_step "Enabling GitHub Actions..."
gh api -X PUT "repos/{owner}/$REPO_NAME/actions/permissions" \
  -F enabled=true \
  -F allowed_actions="all" || print_warning "Could not enable Actions - do this manually in Settings"

# Set workflow permissions
gh api -X PUT "repos/{owner}/$REPO_NAME/actions/permissions/workflow" \
  -F default_workflow_permissions="write" \
  -F can_approve_pull_request_reviews=true || print_warning "Could not set workflow permissions"

print_success "GitHub Actions enabled"

# Create labels
print_step "Creating issue labels..."

create_label() {
    local name=$1
    local color=$2
    local description=$3
    
    gh label create "$name" --color "$color" --description "$description" --force 2>/dev/null || true
}

create_label "enhancement" "a2eeef" "New feature or request"
create_label "bug" "d73a4a" "Something isn't working"
create_label "needs-triage" "008672" "Needs review"
create_label "parent-issue" "5319e7" "Issue that requires subtasks"
create_label "needs-subtasks" "e99695" "Parent issue needs breakdown"
create_label "stale" "ffffff" "No activity for 30 days"
create_label "in-progress" "0052cc" "Currently being worked on"
create_label "blocked" "b60205" "Blocked by dependencies"

print_success "Labels created"

# Create project board
print_step "Creating project board..."

PROJECT_ID=$(gh api graphql -f query='
  mutation($ownerId: ID!, $title: String!) {
    createProjectV2(input: {ownerId: $ownerId, title: $title}) {
      projectV2 {
        id
        number
      }
    }
  }' -f ownerId="$(gh api user --jq .node_id)" -f title="$REPO_NAME Development" --jq '.data.createProjectV2.projectV2.number' 2>/dev/null || echo "0")

if [ "$PROJECT_ID" != "0" ]; then
    print_success "Project board created (#$PROJECT_ID)"
    
    # Update workflow with project number
    if [ -f ".github/workflows/project-automation.yml" ]; then
        sed -i.bak "s/PROJECT_NUMBER: 1/PROJECT_NUMBER: $PROJECT_ID/" .github/workflows/project-automation.yml
        rm -f .github/workflows/project-automation.yml.bak
        git add .github/workflows/project-automation.yml
        git commit -m "Configure project automation with board #$PROJECT_ID" --quiet
        git push --quiet
    fi
else
    print_warning "Could not create project board - create manually in Projects tab"
fi

# Set up branch protection
print_step "Setting up branch protection..."

# First, ensure main branch exists and has at least one commit
if ! git rev-parse --verify main &>/dev/null; then
    print_warning "Main branch not found, skipping protection rules"
else
    gh api -X PUT "repos/{owner}/$REPO_NAME/branches/main/protection" \
      -f required_status_checks='{"strict":true,"contexts":[]}' \
      -f enforce_admins=false \
      -f required_pull_request_reviews='{"required_approving_review_count":1,"dismiss_stale_reviews":true}' \
      -f restrictions=null \
      -f allow_force_pushes=false \
      -f allow_deletions=false 2>/dev/null || print_warning "Could not set branch protection (this is normal for new repos)"
fi

# Create PRD location
print_step "Setting up PRD location..."
mkdir -p docs/prds/current

# Copy PRD template with workshop example
cat > docs/prds/current/PROJECT_PRD.md << 'EOF'
# Project Name: [Your Project Name]

## Overview
[Brief description of what you're building]

### Example for Workshop:
**Project**: Chess Puzzle Game
**Theme**: Squid Game meets Dairy Queen Blizzard
**Description**: A chess puzzle game where players solve increasingly difficult puzzles. The visual design combines the stark, geometric aesthetics of Squid Game with the swirling, colorful patterns of DQ Blizzards.

## Problem Statement
[What problem does this solve? Who is it for?]

## Goals & Success Metrics
- [ ] Goal 1: [Specific, measurable goal]
- [ ] Goal 2: [Another goal]
- [ ] Success looks like: [Description]

## User Stories
1. As a [user type], I want to [action] so that [benefit]
2. As a [user type], I want to [action] so that [benefit]

## Core Features (MVP)
1. **Feature Name**: [Description]
2. **Feature Name**: [Description]
3. **Feature Name**: [Description]

## Technical Considerations
- Platform: [Web/Mobile/Desktop]
- Tech Stack: [Expected technologies]
- Performance: [Any specific requirements]

## Design & Styling
- Visual Theme: [Description]
- Color Palette: [Main colors]
- UI Components: [Key elements]

## Future Enhancements (Post-MVP)
- [Feature for later]
- [Another future feature]

## Constraints & Assumptions
- [Any limitations]
- [Key assumptions]

## Milestones
1. **Week 1**: [What to complete]
2. **Week 2**: [What to complete]
EOF

# Create AI context file
print_step "Creating AI context file..."
cp templates/CLAUDE_TEMPLATE.md CLAUDE.md

# Update CLAUDE.md with project info
sed -i.bak "s/\[PROJECT_NAME\]/$REPO_NAME/g" CLAUDE.md
rm -f CLAUDE.md.bak

# Commit changes
git add -A
git commit -m "Workshop setup: Configure project structure" --quiet
git push --quiet

print_success "PRD location ready"

# Create parent issue automatically
print_step "Creating parent issue for PRD parsing..."
    
    ISSUE_BODY="# Parse PRD into Development Tasks

## 🎯 Overview
**Estimated Total Effort**: Multiple subtasks across 1-2 weeks
**Priority**: High
**Complexity**: Medium

## 🚨 Mandatory Reading
Before starting ANY work:
1. **MUST READ**: [.cursor/rules/CRITICAL_CORE.mdc](.cursor/rules/CRITICAL_CORE.mdc) - Universal development principles
2. Review the acceptance criteria below

## 📋 High-Level Description
This parent issue tracks the breakdown of our Product Requirements Document (PRD) into actionable development tasks. The PRD is located at \`docs/prds/current/PROJECT_PRD.md\`.

The subtasks created from this issue will form our development roadmap, with each task sized for 1-2 days of work.

**Key Resource**: The \`templates/PRD_PARSING_PROMPT.md\` file contains a detailed template for parsing PRDs into well-structured GitHub issues. This prompt ensures consistent, high-quality issue creation that's newcomer-friendly.

## ✅ Acceptance Criteria
- [ ] PRD has been thoroughly reviewed
- [ ] Subtask issues created following the prompt template
- [ ] Each subtask has clear acceptance criteria
- [ ] Subtasks are properly linked to this parent issue
- [ ] All subtasks follow the 1-2 day sizing guideline
- [ ] Dependencies between tasks are documented

## 📊 Subtasks
To be created based on PRD requirements (will vary by project)

## 🔧 How to Complete This Issue
1. Read the PRD at \`docs/prds/current/PROJECT_PRD.md\`
2. Read the PRD parsing prompt from \`templates/PRD_PARSING_PROMPT.md\`
3. Give the AI assistant this prompt:
   \`\`\`
   I want to work on issue #1 "Parse PRD into Development Tasks".
   
   Please:
   1. Read the PRD from docs/prds/current/PROJECT_PRD.md
   2. Read the PRD parsing prompt from templates/PRD_PARSING_PROMPT.md
   3. Use that prompt to parse the PRD into subtask issues
   4. Create each subtask issue on GitHub using the newcomer-standard-issue template
   5. Link them all as subtasks of issue #1
   
   Repository: [YOUR-USERNAME]/[YOUR-PROJECT-NAME]
   
   Show me the commands for each subtask issue.
   \`\`\`
4. The AI will create properly structured issues following the template
5. Review and link all subtasks to this parent issue

---

**Success looks like**: A complete set of well-defined subtask issues ready for development."

ISSUE_NUMBER=$(gh issue create \
  --title "Parse PRD into Development Tasks" \
  --body "$ISSUE_BODY" \
  --label "parent-issue,needs-subtasks" \
  --repo "$REPO_NAME" \
  | grep -oE '[0-9]+$')

if [ -n "$ISSUE_NUMBER" ]; then
    print_success "Created parent issue #$ISSUE_NUMBER"
else
    print_warning "Could not create parent issue - create it manually"
fi

# Final instructions
echo
echo -e "${GREEN}╔═══════════════════════════════════════════╗"
echo -e "║        ✅ Setup Complete!                 ║"
echo -e "╚═══════════════════════════════════════════╝${NC}"
echo
echo -e "${BLUE}Your repository:${NC} https://github.com/$(gh api user --jq .login)/$REPO_NAME"
echo -e "${BLUE}Parent Issue:${NC} #$ISSUE_NUMBER - Parse PRD into Development Tasks"
echo
echo -e "${YELLOW}📋 Workshop Ready! Next Steps:${NC}"
echo "1. Your PRD is at: docs/prds/current/PROJECT_PRD.md"
echo "2. Parent issue #$ISSUE_NUMBER is ready to work on"
echo "3. Open Cursor and start the workshop!"
echo
echo -e "${GREEN}Everything is set up! Time to build! 🚀${NC}"

# Open repository in browser automatically
print_success "Opening your repository in browser..."
gh repo view --web