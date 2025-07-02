#!/bin/bash

# Script to configure branch protection rules for the main branch
# Run this script with: gh auth login && ./.github/scripts/setup-branch-protection.sh

set -e

REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)
BRANCH="main"

echo "🔐 Setting up branch protection for $REPO branch: $BRANCH"

# Configure branch protection rules
gh api \
  --method PUT \
  -H "Accept: application/vnd.github+json" \
  /repos/$REPO/branches/$BRANCH/protection \
  --input - <<EOF
{
  "required_status_checks": {
    "strict": true,
    "contexts": [
      "python-tests",
      "Build",
      "validate-commits",
      "check-assignment",
      "check-readme"
    ]
  },
  "enforce_admins": false,
  "required_pull_request_reviews": {
    "dismissal_restrictions": {},
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": false,
    "required_approving_review_count": 1,
    "require_last_push_approval": false
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "block_creations": false,
  "required_conversation_resolution": true,
  "lock_branch": false,
  "allow_fork_syncing": true
}
EOF

echo "✅ Branch protection rules configured successfully!"

# Show current protection status
echo ""
echo "📊 Current protection status:"
gh api \
  -H "Accept: application/vnd.github+json" \
  /repos/$REPO/branches/$BRANCH/protection \
  | jq '{
    required_status_checks: .required_status_checks.contexts,
    require_reviews: .required_pull_request_reviews.required_approving_review_count,
    dismiss_stale_reviews: .required_pull_request_reviews.dismiss_stale_reviews,
    enforce_admins: .enforce_admins,
    require_conversation_resolution: .required_conversation_resolution
  }'