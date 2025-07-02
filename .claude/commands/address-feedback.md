# /address-feedback - Handle PR Review Feedback

## Command Description
Systematically addresses PR review feedback with proper tracking and validation.

## Command Implementation

```bash
# Get PR number from user or current branch
if [ -z "$1" ]; then
    PR_NUMBER=$(gh pr view --json number --jq '.number' 2>/dev/null)
    if [ -z "$PR_NUMBER" ]; then
        echo "Please provide PR number: /address-feedback <PR_NUMBER>"
        exit 1
    fi
else
    PR_NUMBER=$1
fi

echo "=== ADDRESSING FEEDBACK FOR PR #${PR_NUMBER} ==="

# Show PR details
gh pr view $PR_NUMBER

# Get all review comments
echo ""
echo "=== REVIEW COMMENTS ==="
gh pr view $PR_NUMBER --json reviews --jq '.reviews[] | select(.state == "CHANGES_REQUESTED" or .state == "COMMENTED") | {author: .author.login, body: .body, state: .state}'

# Show review thread comments (line-specific)
echo ""
echo "=== LINE-SPECIFIC COMMENTS ==="
gh api "repos/:owner/:repo/pulls/$PR_NUMBER/reviews" --jq '.[] | select(.state == "CHANGES_REQUESTED" or .state == "COMMENTED") | .id' | while read review_id; do
    echo "Review by $(gh api "repos/:owner/:repo/pulls/reviews/$review_id" --jq '.user.login'):"
    gh api "repos/:owner/:repo/pulls/$PR_NUMBER/comments" --jq ".[] | select(.pull_request_review_id == $review_id) | {path: .path, line: .line, body: .body}"
    echo ""
done

# Checkout PR branch if not already
CURRENT_BRANCH=$(git branch --show-current)
PR_BRANCH=$(gh pr view $PR_NUMBER --json headRefName --jq '.headRefName')

if [ "$CURRENT_BRANCH" != "$PR_BRANCH" ]; then
    echo "Checking out PR branch: $PR_BRANCH"
    gh pr checkout $PR_NUMBER
fi

echo ""
echo "=== FEEDBACK RESOLUTION WORKFLOW ==="
echo "1. Review all feedback above"
echo "2. Make necessary code changes"
echo "3. Test changes thoroughly"
echo "4. Commit with descriptive messages"
echo "5. Push and notify reviewers"
echo ""
```

## AI Assistant Feedback Resolution Prompt

```
I need help addressing PR review feedback systematically.

**PR Context:**
- PR #[PR_NUMBER]: [PR_TITLE]
- Current branch: [BRANCH_NAME]
- Reviewer feedback attached below

**Review Feedback:**
[Paste all review comments and line-specific feedback]

**Resolution Requirements:**
1. **Address each comment individually** - don't batch responses
2. **Follow CRITICAL_CORE principles** - single-pass quality fixes
3. **Maintain code quality** - don't just make minimal changes
4. **Test thoroughly** - validate each fix works
5. **Document changes** - explain what was changed and why

**For each piece of feedback, please:**
1. **Analyze the concern** - understand the reviewer's point
2. **Propose specific solution** - show exactly what to change
3. **Explain the fix** - why this approach addresses the concern
4. **Identify test requirements** - how to validate the fix
5. **Check for side effects** - ensure no regressions

**Code Quality Standards:**
- Preserve existing patterns and architecture
- Follow project coding standards exactly
- Ensure changes are minimal but complete
- Maintain or improve test coverage
- Update documentation if behavior changes

Start with the highest priority feedback first. For each fix, show the before/after code and explain the reasoning.
```

## Feedback Resolution Checklist

```bash
echo "=== RESOLUTION CHECKLIST ==="
echo ""
echo "For each piece of feedback:"
echo "□ Understood the reviewer's concern"
echo "□ Implemented appropriate fix"
echo "□ Tested the fix thoroughly"
echo "□ No regressions introduced"
echo "□ Code follows project standards"
echo "□ Updated tests if needed"
echo "□ Updated documentation if needed"
echo ""
echo "Before pushing:"
echo "□ All feedback addressed"
echo "□ Build passes without warnings"
echo "□ All tests pass"
echo "□ No lint violations"
echo "□ Changes are properly committed"
echo ""
```

## Post-Resolution Actions

```bash
echo "=== AFTER ADDRESSING FEEDBACK ==="
echo ""
echo "1. Commit your changes:"
echo "   git add ."
echo "   git commit -m \"Address PR feedback: [specific changes made]\""
echo ""
echo "2. Push changes:"
echo "   git push"
echo ""
echo "3. Notify reviewers:"
echo "   gh pr comment $PR_NUMBER --body \"@reviewer I've addressed your feedback. Key changes:"
echo "   - [Change 1]: [Brief explanation]"
echo "   - [Change 2]: [Brief explanation]"
echo "   Please review when you have a chance. Thanks!\""
echo ""
echo "4. Optional - Request re-review:"
echo "   gh pr edit $PR_NUMBER --add-reviewer @reviewer-username"
echo ""
echo "5. Mark feedback as resolved:"
echo "   # Use GitHub web interface to mark individual conversations as resolved"
echo ""
```

## Feedback Response Templates

### For Code Quality Issues
```
Thanks for the feedback! I've addressed this by:
- [Specific change made]
- [Why this approach was chosen]
- [How it improves the code]

The change is in commit [COMMIT_SHA]. Please let me know if this resolves your concern.
```

### For Architecture Concerns  
```
Good catch on the architecture point. I've refactored this to:
- [How the architecture was improved]
- [Why this follows project patterns better]
- [Any trade-offs considered]

This better aligns with our CRITICAL_CORE principles. Ready for another look.
```

### For Testing Requests
```
You're right about the test coverage. I've added:
- [New tests added]
- [Edge cases covered]
- [How they validate the functionality]

Test coverage for this feature is now [X]%. All tests passing.
```

## Usage Notes
- Always address feedback completely, don't make partial fixes
- Test each change individually before moving to the next
- Communicate clearly about what was changed and why
- Be receptive to feedback and ask questions if unclear
- Thank reviewers for their time and expertise