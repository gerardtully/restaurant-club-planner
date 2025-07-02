# /review-pr - Staff Developer PR Review

## Command Description
Comprehensive PR review focusing on code quality, architecture compliance, and adherence to CRITICAL_CORE rules.

## Command Implementation

```bash
# Get PR number from user or use current branch
if [ -z "$1" ]; then
    # Try to get PR for current branch
    PR_NUMBER=$(gh pr view --json number --jq '.number' 2>/dev/null)
    if [ -z "$PR_NUMBER" ]; then
        echo "Please provide PR number: /review-pr <PR_NUMBER>"
        exit 1
    fi
else
    PR_NUMBER=$1
fi

# Fetch PR details
PR_DATA=$(gh pr view $PR_NUMBER --json title,body,author,headRefName,baseRefName,files)
PR_TITLE=$(echo $PR_DATA | jq -r '.title')
PR_AUTHOR=$(echo $PR_DATA | jq -r '.author.login')
HEAD_BRANCH=$(echo $PR_DATA | jq -r '.headRefName')
BASE_BRANCH=$(echo $PR_DATA | jq -r '.baseRefName')

echo "=== REVIEWING PR #${PR_NUMBER} ==="
echo "Title: $PR_TITLE"
echo "Author: $PR_AUTHOR"
echo "Branch: $HEAD_BRANCH → $BASE_BRANCH"
echo ""

# Show PR details
gh pr view $PR_NUMBER

# Get changed files
echo ""
echo "=== CHANGED FILES ==="
gh pr diff $PR_NUMBER --name-only

# Check if PR follows branch naming convention
if [[ ! $HEAD_BRANCH =~ ^(feature|fix|docs|refactor|design)/issue-[0-9]+-.*$ ]]; then
    echo "⚠️  WARNING: Branch name doesn't follow convention (type/issue-number-description)"
fi

# Check for issue reference
if ! gh pr view $PR_NUMBER --json body | jq -r '.body' | grep -q -E "(Fixes|Closes|Resolves) #[0-9]+"; then
    echo "⚠️  WARNING: PR doesn't reference an issue (missing 'Fixes #123')"
fi

# Run build validation
echo ""
echo "=== BUILD VALIDATION ==="
echo "Checking out PR branch for testing..."
gh pr checkout $PR_NUMBER

# Run common validation commands
echo "Running build validation..."
if command -v npm &> /dev/null && [ -f "package.json" ]; then
    npm run build 2>/dev/null || echo "❌ Build failed"
    npm run lint 2>/dev/null || echo "❌ Lint failed"
    npm test 2>/dev/null || echo "❌ Tests failed"
elif command -v python &> /dev/null && [ -f "requirements.txt" ]; then
    python -m flake8 . 2>/dev/null || echo "❌ Lint failed"
    python -m pytest 2>/dev/null || echo "❌ Tests failed"
fi

echo ""
echo "=== REVIEW CHECKLIST ==="
echo "Manual review points to verify:"
echo ""
```

## AI Assistant Review Prompt
Use this comprehensive prompt for AI-assisted code review:

```
I need a comprehensive staff-level code review for this PR following our development standards.

**PR Details:**
- Number: #[PR_NUMBER]
- Title: [PR_TITLE]
- Author: [PR_AUTHOR]
- Files changed: [LIST_FILES]

**Review Criteria - Check ALL of these:**

**1. CRITICAL_CORE Compliance:**
- [ ] Single-pass implementation quality
- [ ] No unnecessary file creation
- [ ] Preserves existing code patterns
- [ ] Follows established architecture

**2. Code Quality:**
- [ ] Clean, readable code
- [ ] Proper error handling
- [ ] No code duplication
- [ ] Follows language best practices
- [ ] Security considerations addressed

**3. Architecture & Design:**
- [ ] Follows project architecture patterns
- [ ] Maintains clean separation of concerns
- [ ] No architectural violations
- [ ] Scalable implementation

**4. Testing & Validation:**
- [ ] Adequate test coverage
- [ ] Tests are meaningful and not trivial
- [ ] Build passes without warnings
- [ ] No regressions introduced

**5. Documentation & Standards:**
- [ ] Code is self-documenting
- [ ] Complex logic has comments
- [ ] Documentation updated if needed
- [ ] Follows team coding standards

**6. GitHub Workflow:**
- [ ] Branch naming follows convention
- [ ] References issue properly
- [ ] PR description is clear
- [ ] Acceptance criteria met

Please examine each changed file and provide:
1. **Detailed feedback** on code quality and architecture
2. **Specific improvement suggestions** with examples
3. **Security or performance concerns**
4. **Overall assessment** (Approve/Request Changes/Comment)
5. **Priority level** for any requested changes

Be thorough but constructive. Focus on teaching moments for the author.
```

## Post-Review Actions

```bash
echo ""
echo "=== POST-REVIEW ACTIONS ==="
echo "Choose your review action:"
echo "1. Approve PR: gh pr review $PR_NUMBER --approve --body 'LGTM! Code meets all standards.'"
echo "2. Request changes: gh pr review $PR_NUMBER --request-changes --body '[Your feedback]'"
echo "3. Comment only: gh pr review $PR_NUMBER --comment --body '[Your feedback]'"
echo ""
echo "Additional actions:"
echo "- Add labels: gh pr edit $PR_NUMBER --add-label 'needs-changes'"
echo "- Request specific reviewer: gh pr edit $PR_NUMBER --add-reviewer @username"
echo "- Merge when ready: gh pr merge $PR_NUMBER --squash"
```

## Review Quality Checklist
- [ ] Examined all changed files
- [ ] Verified build passes
- [ ] Checked test coverage
- [ ] Validated against CRITICAL_CORE rules
- [ ] Assessed architectural impact
- [ ] Provided constructive feedback
- [ ] Checked for security issues
- [ ] Verified documentation updates