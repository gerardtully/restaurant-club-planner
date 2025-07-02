# /update-docs - Update Project Documentation

## Command Description
Analyzes commit history to identify stale documentation and updates it to reflect current codebase state.

## Command Implementation

```bash
echo "=== DOCUMENTATION UPDATE ANALYSIS ==="

# Get recent commits to identify potential doc-affecting changes
echo "Analyzing recent commits for documentation impact..."
RECENT_COMMITS=$(git log --oneline --since="30 days ago" --grep="feat\|fix\|refactor" --all)

echo "Recent feature/fix commits (last 30 days):"
echo "$RECENT_COMMITS"
echo ""

# Find documentation files
echo "=== CURRENT DOCUMENTATION FILES ==="
DOC_FILES=$(find . -name "*.md" -not -path "./node_modules/*" -not -path "./.git/*" | sort)
echo "$DOC_FILES"
echo ""

# Check last modification dates
echo "=== DOCUMENTATION FRESHNESS ==="
for file in $DOC_FILES; do
    LAST_MODIFIED=$(git log -1 --format="%ar" -- "$file" 2>/dev/null || echo "never committed")
    echo "$file - Last updated: $LAST_MODIFIED"
done
echo ""

# Check for common stale patterns
echo "=== STALENESS INDICATORS ==="

# README.md analysis
if [ -f "README.md" ]; then
    echo "README.md analysis:"
    
    # Check if package.json changed more recently than README
    if [ -f "package.json" ]; then
        README_DATE=$(git log -1 --format="%s" -- README.md 2>/dev/null || echo "0")
        PACKAGE_DATE=$(git log -1 --format="%s" -- package.json 2>/dev/null || echo "0")
        if [ "$README_DATE" != "$PACKAGE_DATE" ]; then
            echo "  ⚠️  package.json updated more recently than README.md"
        fi
    fi
    
    # Check for references to files that may have changed
    echo "  Checking for potentially outdated file references..."
    grep -n "src/\|lib/\|components/\|pages/" README.md 2>/dev/null | head -5
fi

# CONTRIBUTING.md analysis
if [ -f "CONTRIBUTING.md" ]; then
    echo ""
    echo "CONTRIBUTING.md analysis:"
    CONTRIB_DATE=$(git log -1 --format="%at" -- CONTRIBUTING.md 2>/dev/null || echo "0")
    WORKFLOW_DATE=$(git log -1 --format="%at" -- .github/workflows/ 2>/dev/null || echo "0")
    
    if [ "$WORKFLOW_DATE" -gt "$CONTRIB_DATE" ]; then
        echo "  ⚠️  GitHub workflows updated more recently than CONTRIBUTING.md"
    fi
fi

# Check for new features that might need documentation
echo ""
echo "=== NEW FEATURES NEEDING DOCUMENTATION ==="
git log --oneline --since="30 days ago" --grep="feat:" | while read commit; do
    echo "  📝 $commit - May need documentation update"
done

# Generate documentation update plan
echo ""
echo "=== RECOMMENDED UPDATES ==="
```

## AI Assistant Documentation Update Prompt

```
I need to update project documentation to reflect the current state of the codebase.

**Analysis Results:**
[Paste the output from the command above]

**Documentation Update Requirements:**

**1. README.md Updates:**
- [ ] Verify all installation/setup instructions work
- [ ] Update feature list to match current functionality
- [ ] Check all code examples still work
- [ ] Update API documentation if applicable
- [ ] Verify all file paths and references
- [ ] Update screenshots/demos if UI changed

**2. CONTRIBUTING.md Updates:**
- [ ] Verify development workflow matches current process
- [ ] Update build/test commands if changed
- [ ] Check GitHub workflow references
- [ ] Update issue templates if modified
- [ ] Verify branch naming conventions
- [ ] Update testing requirements

**3. Technical Documentation:**
- [ ] Update architecture diagrams if structure changed
- [ ] Document new APIs or endpoints
- [ ] Update configuration examples
- [ ] Check environment variable documentation
- [ ] Update deployment instructions

**4. CLAUDE.md Updates:**
- [ ] Add new project context from recent features
- [ ] Update tech stack if dependencies changed
- [ ] Add new development rules learned
- [ ] Update file structure if reorganized

**Current Codebase Analysis Needed:**
Please examine these areas and update documentation accordingly:

1. **Package Dependencies**: Check package.json/requirements.txt for new dependencies
2. **File Structure**: Verify directory structure matches documentation
3. **Configuration**: Check for new config files or environment variables
4. **Scripts**: Verify all npm scripts/make commands in docs work
5. **APIs**: Document any new endpoints or changed interfaces

**Update Strategy:**
1. Start with README.md as highest priority
2. Test all instructions and examples
3. Update CONTRIBUTING.md for workflow changes
4. Add technical documentation for new features
5. Validate all links and references work

Please provide specific content updates for each file, focusing on accuracy and completeness.
```

## Documentation Validation Script

```bash
echo ""
echo "=== DOCUMENTATION VALIDATION ==="

# Test README instructions
if [ -f "README.md" ]; then
    echo "Testing README.md instructions..."
    
    # Extract and test install commands
    if grep -q "npm install" README.md; then
        echo "  Found npm install instruction"
        # Could add actual validation here
    fi
    
    if grep -q "pip install" README.md; then
        echo "  Found pip install instruction"
    fi
    
    # Check for broken links (basic check)
    echo "  Checking for broken internal links..."
    grep -o "\[.*\](.*\.md)" README.md 2>/dev/null | while read link; do
        file=$(echo $link | sed 's/.*](\(.*\))/\1/')
        if [ ! -f "$file" ]; then
            echo "    ⚠️  Broken link: $file"
        fi
    done
fi

# Validate code examples
echo ""
echo "Checking code examples in documentation..."
for doc_file in $DOC_FILES; do
    # Count code blocks
    CODE_BLOCKS=$(grep -c "```" "$doc_file" 2>/dev/null || echo "0")
    if [ "$CODE_BLOCKS" -gt 0 ]; then
        echo "  $doc_file has $CODE_BLOCKS code blocks"
    fi
done
```

## Post-Update Validation

```bash
echo ""
echo "=== POST-UPDATE CHECKLIST ==="
echo ""
echo "After updating documentation:"
echo "□ All setup instructions tested"
echo "□ Code examples work correctly"
echo "□ Internal links point to existing files"
echo "□ External links are accessible"
echo "□ Screenshots/images are current"
echo "□ Version numbers are correct"
echo "□ Feature list matches actual functionality"
echo "□ Contribution guidelines are accurate"
echo "□ Build/test instructions work"
echo "□ Documentation follows markdown standards"
echo ""
echo "Commit documentation updates:"
echo "git add *.md"
echo "git commit -m \"docs: Update documentation to reflect current codebase state\""
echo ""
```

## Smart Update Triggers

```bash
# Check for specific patterns that indicate docs need updates
echo "=== SMART UPDATE TRIGGERS ==="

# New dependencies
if [ -f "package.json" ]; then
    NEW_DEPS=$(git diff HEAD~10..HEAD package.json | grep "+" | grep -v "^+++" | wc -l)
    if [ "$NEW_DEPS" -gt 0 ]; then
        echo "📦 New dependencies detected - update installation docs"
    fi
fi

# New scripts
if [ -f "package.json" ]; then
    SCRIPT_CHANGES=$(git diff HEAD~10..HEAD package.json | grep -E "scripts|build|test" | wc -l)
    if [ "$SCRIPT_CHANGES" -gt 0 ]; then
        echo "⚙️  Script changes detected - update development docs"
    fi
fi

# New configuration files
NEW_CONFIG=$(git log --name-only --since="30 days ago" | grep -E "\.(json|yaml|yml|toml|ini|env)$" | sort -u)
if [ ! -z "$NEW_CONFIG" ]; then
    echo "🔧 New config files detected:"
    echo "$NEW_CONFIG"
    echo "   Update configuration documentation"
fi

# API changes (look for new routes/endpoints)
API_CHANGES=$(git log --since="30 days ago" -p | grep -E "app\.(get|post|put|delete)|@app\.route|def.*route" | wc -l)
if [ "$API_CHANGES" -gt 0 ]; then
    echo "🌐 Potential API changes detected - update API documentation"
fi
```

## Usage Notes
- Run monthly or after major feature releases
- Focus on user-facing documentation first
- Test all instructions before committing updates
- Use commit history to identify what changed
- Prioritize README.md and CONTRIBUTING.md
- Validate all code examples and links work