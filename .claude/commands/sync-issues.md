# /sync-issues - Synchronize GitHub Issues with Codebase

## Command Description
Checks GitHub Issues for accuracy against current codebase and updates them when new functionality affects issue relevance.

## Command Implementation

```bash
echo "=== GITHUB ISSUES SYNCHRONIZATION ==="

# Get all open issues
echo "Fetching all open issues..."
ALL_ISSUES=$(gh issue list --state open --json number,title,body,labels,assignees,updatedAt)

# Get recent significant commits
echo "Analyzing recent commits for functionality changes..."
RECENT_FEATURES=$(git log --oneline --since="30 days ago" --grep="feat\|fix\|refactor" --all)

echo "Recent functionality changes:"
echo "$RECENT_FEATURES"
echo ""

# Analyze issues for potential staleness
echo "=== ISSUE STALENESS ANALYSIS ==="
echo "$ALL_ISSUES" | jq -r '.[] | "\(.number): \(.title) (Updated: \(.updatedAt[:10]))"' | while read issue_line; do
    ISSUE_NUM=$(echo $issue_line | cut -d: -f1)
    ISSUE_TITLE=$(echo $issue_line | cut -d: -f2- | cut -d'(' -f1 | xargs)
    UPDATED_DATE=$(echo $issue_line | grep -o '([^)]*)' | tr -d '()')
    
    # Check if issue is older than recent commits
    ISSUE_AGE_DAYS=$(( ($(date +%s) - $(date -d "$UPDATED_DATE" +%s)) / 86400 ))
    
    if [ "$ISSUE_AGE_DAYS" -gt 30 ]; then
        echo "  🔍 Issue #$ISSUE_NUM: '$ISSUE_TITLE' - $ISSUE_AGE_DAYS days old, checking relevance..."
        
        # Check if issue references files that have changed
        ISSUE_BODY=$(gh issue view $ISSUE_NUM --json body --jq '.body')
        
        # Extract file references from issue
        FILE_REFS=$(echo "$ISSUE_BODY" | grep -o '[a-zA-Z0-9._/-]*\.\(js\|ts\|py\|md\|json\|yml\|yaml\)' | sort -u)
        
        if [ ! -z "$FILE_REFS" ]; then
            echo "    Files referenced in issue:"
            echo "$FILE_REFS" | while read file_ref; do
                if [ -f "$file_ref" ]; then
                    # Check if file was modified recently
                    FILE_MODIFIED=$(git log -1 --format="%ar" -- "$file_ref" 2>/dev/null)
                    echo "      $file_ref - Last modified: $FILE_MODIFIED"
                else
                    echo "      ⚠️  $file_ref - FILE MISSING OR MOVED"
                fi
            done
        fi
    fi
done

# Check for issues that might be affected by new features
echo ""
echo "=== ISSUES POTENTIALLY AFFECTED BY RECENT CHANGES ==="
echo "$RECENT_FEATURES" | while read commit_line; do
    COMMIT_HASH=$(echo $commit_line | cut -d' ' -f1)
    COMMIT_MSG=$(echo $commit_line | cut -d' ' -f2-)
    
    # Get files changed in this commit
    CHANGED_FILES=$(git diff-tree --no-commit-id --name-only -r $COMMIT_HASH)
    
    echo "Commit: $COMMIT_MSG"
    echo "Changed files: $(echo $CHANGED_FILES | tr '\n' ' ')"
    
    # Check if any open issues reference these files
    echo "$CHANGED_FILES" | while read changed_file; do
        if [ ! -z "$changed_file" ]; then
            MATCHING_ISSUES=$(gh issue list --state open --search "$changed_file" --json number,title 2>/dev/null)
            if [ ! -z "$MATCHING_ISSUES" ] && [ "$MATCHING_ISSUES" != "[]" ]; then
                echo "  📋 Issues mentioning $changed_file:"
                echo "$MATCHING_ISSUES" | jq -r '.[] | "    #\(.number): \(.title)"'
            fi
        fi
    done
    echo ""
done

# Generate sync recommendations
echo "=== SYNCHRONIZATION RECOMMENDATIONS ==="
```

## AI Assistant Issue Sync Prompt

```
I need to synchronize GitHub Issues with the current codebase state and recent changes.

**Analysis Results:**
[Paste the output from the command above]

**Issue Synchronization Tasks:**

**1. Stale Issue Detection:**
For each issue older than 30 days, check:
- [ ] Are referenced files still accurate?
- [ ] Has the feature already been implemented?
- [ ] Are acceptance criteria still valid?
- [ ] Do file paths still exist?
- [ ] Is the technical approach still appropriate?

**2. Impact Analysis:**
For each recent commit that might affect issues:
- [ ] Which open issues are related to changed files?
- [ ] Do issue descriptions need updating?
- [ ] Are any issues now blocked or unblocked?
- [ ] Should issue priority change?
- [ ] Are acceptance criteria still achievable?

**3. Issue Content Updates:**
For each affected issue, update:
- [ ] File paths that have moved/renamed
- [ ] Code examples that are now outdated
- [ ] Implementation approaches that changed
- [ ] Dependencies that are now resolved
- [ ] Acceptance criteria that need revision

**4. Issue Status Updates:**
Check if issues should be:
- [ ] Closed (already implemented)
- [ ] Blocked (dependencies changed)
- [ ] Unblocked (dependencies resolved)
- [ ] Re-prioritized (context changed)
- [ ] Split (scope too large after changes)

**Current Codebase Context:**
Please examine the current state and provide specific updates for each affected issue:

1. **File Structure Analysis**: Compare issue file references with actual structure
2. **Feature Gap Analysis**: Identify functionality described in issues that now exists
3. **Dependency Analysis**: Check if blocked issues can now proceed
4. **Priority Reassessment**: Suggest priority changes based on current needs

**Update Actions:**
For each issue that needs changes, provide:
1. Specific text updates needed
2. Label changes (add/remove)
3. Status changes (close/block/unblock)
4. Priority adjustments
5. Assignment recommendations

Focus on accuracy and ensuring issues reflect current project state.
```

## Issue Update Automation

```bash
echo ""
echo "=== AUTOMATED ISSUE UPDATES ==="

# Function to update issue with standardized comment
update_issue_comment() {
    local issue_num=$1
    local update_reason=$2
    local changes_made=$3
    
    gh issue comment $issue_num --body "## 🔄 Issue Synchronization Update

**Reason for Update:** $update_reason

**Changes Made:**
$changes_made

**Context:** This issue was automatically reviewed and updated to reflect current codebase state.

*Last sync: $(date)*"
}

# Function to close completed issues
close_implemented_issue() {
    local issue_num=$1
    local implementation_details=$2
    
    gh issue close $issue_num --comment "## ✅ Issue Resolved

This issue appears to have been implemented based on recent codebase changes.

**Implementation Evidence:**
$implementation_details

**Action:** Closing as completed. If this was closed in error, please reopen and provide additional context.

*Auto-closed during issue sync: $(date)*"
}

# Function to update stale issues
update_stale_issue() {
    local issue_num=$1
    local staleness_reason=$2
    
    gh issue edit $issue_num --add-label "needs-update"
    gh issue comment $issue_num --body "## ⚠️ Issue Requires Update

**Staleness Detected:** $staleness_reason

**Required Actions:**
- [ ] Verify file paths are still accurate
- [ ] Update code examples if needed
- [ ] Confirm acceptance criteria are still valid
- [ ] Check if dependencies have changed

**Maintainer:** Please review and update this issue or close if no longer relevant.

*Flagged during automated sync: $(date)*"
}

echo "Issue update functions loaded. Use the AI analysis above to determine which issues need updates."
```

## Sync Validation

```bash
echo ""
echo "=== SYNC VALIDATION CHECKLIST ==="
echo ""
echo "After running issue synchronization:"
echo "□ All stale issues reviewed"
echo "□ File references validated"
echo "□ Implemented features closed"
echo "□ Blocked issues identified"
echo "□ Priority adjustments made"
echo "□ Labels updated appropriately"
echo "□ Assignments reviewed"
echo "□ Comments added for transparency"
echo ""

# Generate summary report
echo "=== SYNC SUMMARY REPORT ==="
echo "Issues processed: $(gh issue list --state all | wc -l)"
echo "Open issues: $(gh issue list --state open | wc -l)"
echo "Recently updated: $(gh issue list --state open --search 'updated:>$(date -d "7 days ago" +%Y-%m-%d)' | wc -l)"
echo "Needs attention: $(gh issue list --state open --label 'needs-update' | wc -l)"
echo ""
echo "Recent sync activity:"
git log --oneline --grep="sync\|update.*issue" --since="7 days ago"
```

## Batch Update Scripts

```bash
echo ""
echo "=== BATCH UPDATE HELPERS ==="

# Update multiple issues with file path corrections
batch_update_file_paths() {
    echo "Batch updating file paths in issues..."
    # This would be customized based on actual file moves
    # Example: if src/ was renamed to lib/
    # gh issue list --search "src/" --json number | jq -r '.[].number' | while read issue_num; do
    #     # Update issue with corrected paths
    # done
}

# Add labels to issues missing them
batch_add_labels() {
    echo "Adding missing labels to issues..."
    gh issue list --state open --json number,labels | jq -r '.[] | select(.labels | length == 0) | .number' | while read issue_num; do
        echo "Issue #$issue_num has no labels - needs manual review"
    done
}

# Flag issues for manual review
batch_flag_for_review() {
    echo "Flagging issues that need manual review..."
    gh issue list --state open --search "updated:<$(date -d "60 days ago" +%Y-%m-%d)" --json number | jq -r '.[].number' | while read issue_num; do
        gh issue edit $issue_num --add-label "needs-review"
    done
}

echo "Batch update functions available. Run based on sync analysis results."
```

## Usage Notes
- Run weekly after significant feature releases
- Focus on issues older than 30 days first
- Validate file references before updating
- Close implemented features promptly
- Add clear comments explaining changes
- Use labels to track sync status