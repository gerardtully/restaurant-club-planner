# /next-issue - Work on Next GitHub Issue

## Command Description
Automatically selects and starts work on the next appropriate GitHub issue based on priority, dependencies, and your current workload.

## Command Implementation

```bash
# Find the next high-priority, ready issue
NEXT_ISSUE=$(gh issue list --label "high-priority,ready" --assignee "" --limit 1 --json number,title --jq '.[0]')

if [ -z "$NEXT_ISSUE" ] || [ "$NEXT_ISSUE" = "null" ]; then
    echo "No high-priority ready issues found. Checking medium priority..."
    NEXT_ISSUE=$(gh issue list --label "ready" --assignee "" --limit 1 --json number,title --jq '.[0]')
fi

if [ -z "$NEXT_ISSUE" ] || [ "$NEXT_ISSUE" = "null" ]; then
    echo "No ready issues available. Here are all open issues:"
    gh issue list --state open
    exit 1
fi

ISSUE_NUMBER=$(echo $NEXT_ISSUE | jq -r '.number')
ISSUE_TITLE=$(echo $NEXT_ISSUE | jq -r '.title')

# Display full issue details
echo "=== SELECTED ISSUE ==="
gh issue view $ISSUE_NUMBER

# Assign issue to yourself
gh issue edit $ISSUE_NUMBER --add-assignee @me

# Create feature branch following naming convention
BRANCH_NAME="feature/issue-${ISSUE_NUMBER}-$(echo "$ISSUE_TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/-$//')"
git checkout -b "$BRANCH_NAME"

echo ""
echo "✅ Ready to work on Issue #${ISSUE_NUMBER}"
echo "📋 Branch created: $BRANCH_NAME"
echo ""
echo "Next steps:"
echo "1. Read CRITICAL_CORE.mdc for development rules"
echo "2. Check issue dependencies and acceptance criteria"
echo "3. Start implementation following the issue guide"
echo "4. Update issue with progress after each subtask"
```

## AI Assistant Prompt
Use this prompt template when working on the selected issue:

```
I'm working on GitHub Issue #[NUMBER]: [TITLE]

Please help me implement this following our development standards:

**Project Context:**
- Read /CLAUDE.md for project-specific rules
- Follow /.cursor/rules/CRITICAL_CORE.mdc principles
- Use patterns from /CONTRIBUTING.md workflow

**Requirements:**
- Single-pass implementation (get it right first try)
- Build validation after each change
- Test coverage for new functionality
- Update documentation with changes
- Follow existing code patterns exactly

**Issue Details:**
[Paste issue description and acceptance criteria]

**Current Codebase:**
[Mention relevant files/directories to examine]

Start by examining the codebase structure and existing patterns, then implement the solution step by step with build validation.
```

## Usage Notes
- Only selects issues that are unassigned and marked as "ready"
- Follows branch naming convention: `feature/issue-{number}-{description}`
- Automatically assigns the issue to you
- Prioritizes high-priority issues first
- Falls back to medium priority if no high-priority issues available