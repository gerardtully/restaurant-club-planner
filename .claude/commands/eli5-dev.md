# /eli5-dev - Explain Like I'm 5 (Developers New to Workflow)

## Command Description
Explains the current chat context and actions performed for developers who understand programming but are new to this specific workflow and project patterns.

## Command Implementation

```bash
echo "=== ELI5 FOR DEVELOPERS (NEW TO THIS WORKFLOW) ==="
echo ""
echo "👨‍💻 Welcome! You know how to code, but this project has some specific patterns."
echo "    Let me explain what we've been working on and how this workflow differs."
echo ""

# Show current project context
echo "=== PROJECT CONTEXT ==="
echo "Current directory: $(pwd)"
echo "Project type: $([ -f "package.json" ] && echo "Node.js/JavaScript" || [ -f "requirements.txt" ] && echo "Python" || [ -f "Cargo.toml" ] && echo "Rust" || echo "General")"

# Show git status
if git status &>/dev/null; then
    echo "Git status: $(git status --porcelain | wc -l) uncommitted changes"
    echo "Current branch: $(git branch --show-current)"
    echo "Recent commits:"
    git log --oneline -3
else
    echo "Git: Not a git repository"
fi

echo ""
echo "=== THIS PROJECT'S WORKFLOW PATTERNS ==="
```

## AI Assistant Developer ELI5 Prompt

```
Explain our current conversation and work for a developer who understands programming but is new to this specific project's workflow and patterns.

**Context for Developer:**
[Provide current chat context, recent actions, and project state]

**Focus Areas for Developer Explanation:**

**1. Workflow Patterns Specific to This Project:**
- How we use CLAUDE.md for AI context persistence
- The PRD → GitHub Issues → Implementation flow
- CRITICAL_CORE.mdc principles and why they matter
- Branch naming conventions and their enforcement
- Issue template requirements and automation

**2. Development Standards:**
- Single-pass implementation philosophy
- Build validation requirements
- Testing approach and coverage expectations
- Documentation update protocols
- Code review process specifics

**3. GitHub Integration:**
- How we use GitHub CLI for automation
- Issue lifecycle and labeling system
- PR workflow and automated checks
- Assignment limits and branch protection
- Stale issue management

**4. AI-Assisted Development Patterns:**
- How we structure prompts for better results
- Context management across sessions
- Error prevention rules learned from experience
- Prompt engineering templates that work

**5. Project Architecture:**
- File organization principles
- How new features should be integrated
- Testing strategy and validation
- Documentation structure and maintenance

**Developer-Focused Explanation Structure:**
```
🏗️ **Architecture Overview:**
[How this project is structured and why]

⚡ **Workflow Differences:**
[How this differs from typical development workflows]

🔧 **Tools & Automation:**
[What's automated and what requires manual work]

📋 **Recent Work Summary:**
[What we accomplished in this session, with technical details]

🎯 **Next Steps:**
[What a developer should focus on next]
```

**Include Technical Details:**
- Specific commands used
- Configuration files involved
- Automation scripts and their purposes
- Integration points and dependencies
- Performance considerations
- Debugging approaches

Keep it technical but focus on the unique aspects of this workflow that differ from standard development practices.
```

## Workflow Pattern Explanations

```bash
echo "=== KEY WORKFLOW PATTERNS ==="
echo ""
echo "🤖 AI-FIRST DEVELOPMENT:"
echo "   • CLAUDE.md provides persistent context across AI sessions"
echo "   • Prompts are engineered for single-pass success"
echo "   • CRITICAL_CORE.mdc contains universal dev principles"
echo "   • Error prevention rules based on common AI coding failures"
echo ""
echo "📋 PRD → ISSUES WORKFLOW:"
echo "   • Ideas start as simple PRDs (Product Requirements Documents)"
echo "   • PRDs get parsed into detailed GitHub Issues using AI"
echo "   • Issues follow strict templates for newcomer-friendly onboarding"
echo "   • Implementation happens in 1-2 day chunks max"
echo ""
echo "🔧 GITHUB AUTOMATION:"
echo "   $(ls .github/workflows/*.yml 2>/dev/null | wc -l) automated workflows handle:"
echo "   • Issue validation and formatting"
echo "   • Branch naming enforcement"
echo "   • Assignment limits (max 3 active per person)"
echo "   • Stale issue management"
echo "   • Project board automation"
echo ""
echo "✅ QUALITY GATES:"
echo "   • Single-pass implementation (get it right first time)"
echo "   • Build validation after every change"
echo "   • Documentation updates are mandatory"
echo "   • No commits without issue references"
```

## Technical Context

```bash
echo ""
echo "=== TECHNICAL IMPLEMENTATION DETAILS ==="

# Show project structure
echo ""
echo "📁 PROJECT STRUCTURE:"
if [ -f "CLAUDE.md" ]; then
    echo "   ✅ CLAUDE.md - AI context persistence"
fi
if [ -f "CONTRIBUTING.md" ]; then
    echo "   ✅ CONTRIBUTING.md - Workflow documentation"
fi
if [ -f ".cursor/rules/CRITICAL_CORE.mdc" ]; then
    echo "   ✅ CRITICAL_CORE.mdc - Universal development rules"
fi
if [ -d ".github/workflows" ]; then
    echo "   ✅ .github/workflows/ - Automated quality gates"
fi
if [ -d "templates" ]; then
    echo "   ✅ templates/ - Ready-to-use templates"
fi

# Show automation status
echo ""
echo "🤖 AUTOMATION STATUS:"
if [ -f ".github/workflows/validate-issues.yml" ]; then
    echo "   ✅ Issue validation enforced"
fi
if [ -f ".github/workflows/branch-naming.yml" ]; then
    echo "   ✅ Branch naming conventions enforced"
fi
if [ -f ".github/workflows/assignment-check.yml" ]; then
    echo "   ✅ Assignment limits enforced"
fi

# Show development commands
echo ""
echo "⚙️ DEVELOPMENT COMMANDS:"
if [ -f "package.json" ]; then
    echo "   Available npm scripts:"
    grep -A 10 '"scripts"' package.json | grep -o '"[^"]*":' | tr -d '":' | sed 's/^/   • npm run /'
fi
if [ -f "Makefile" ]; then
    echo "   Available make targets:"
    grep "^[a-zA-Z]" Makefile | cut -d: -f1 | sed 's/^/   • make /'
fi
```

## Recent Session Summary

```bash
echo ""
echo "=== CURRENT SESSION TECHNICAL SUMMARY ==="
echo ""
echo "🔨 RECENT ACTIONS PERFORMED:"
# This would be populated by the AI based on actual session context
echo "   [AI will fill this based on conversation history]"
echo ""
echo "📊 CURRENT STATE:"
echo "   • Working directory: $(pwd)"
echo "   • Git status: $(git status --porcelain | wc -l) modified files"
echo "   • Open issues: $(gh issue list --state open | wc -l 2>/dev/null || echo "unknown")"
echo "   • Recent commits: $(git log --oneline --since="7 days ago" | wc -l)"
echo ""
echo "🎯 NEXT LOGICAL STEPS:"
echo "   [AI will suggest next actions based on current state]"
```

## Development Environment Setup

```bash
echo ""
echo "=== DEVELOPMENT ENVIRONMENT SETUP ==="
echo ""
echo "🛠️ REQUIRED TOOLS:"
echo "   • Git (for version control)"
echo "   • GitHub CLI (gh command) - for issue/PR automation"
echo "   • Node.js/npm (if JavaScript project) or Python/pip (if Python project)"
echo "   • Code editor with AI assistance (Cursor recommended)"
echo ""
echo "📋 SETUP CHECKLIST FOR NEW DEVELOPERS:"
echo "   □ Clone repository"
echo "   □ Install dependencies"
echo "   □ Read CLAUDE.md for project context"
echo "   □ Read CONTRIBUTING.md for workflow"
echo "   □ Review .cursor/rules/CRITICAL_CORE.mdc"
echo "   □ Run initial build/test to verify setup"
echo "   □ Check GitHub CLI authentication: gh auth status"
echo "   □ Review open issues to understand current priorities"
echo ""
echo "🚀 FIRST CONTRIBUTION WORKFLOW:"
echo "   1. Pick a 'good-first-issue' labeled issue"
echo "   2. Create branch: git checkout -b feature/issue-X-description"
echo "   3. Implement following CRITICAL_CORE principles"
echo "   4. Test thoroughly and validate build passes"
echo "   5. Update documentation"
echo "   6. Create PR with 'Fixes #X' in description"
echo "   7. Address review feedback promptly"
```

## Advanced Patterns

```bash
echo ""
echo "=== ADVANCED WORKFLOW PATTERNS ==="
echo ""
echo "🧠 AI CONTEXT MANAGEMENT:"
echo "   • Each project has a CLAUDE.md with persistent context"
echo "   • Context includes tech stack, patterns, and constraints"
echo "   • AI assistants read this first for consistent behavior"
echo "   • Reduces context repetition by ~70%"
echo ""
echo "📈 SCALING PATTERNS:"
echo "   • Issues are designed for parallel development"
echo "   • File boundaries prevent merge conflicts"
echo "   • Milestones break large features into 1-2 week chunks"
echo "   • Automated validation catches issues early"
echo ""
echo "🔍 DEBUGGING APPROACH:"
echo "   • Build validation runs after every change"
echo "   • Test failures must be fixed before proceeding"
echo "   • No partial implementations or 'TODO' commits"
echo "   • Error logs are examined, not guessed at"
echo ""
echo "📚 KNOWLEDGE TRANSFER:"
echo "   • All decisions documented in commit messages"
echo "   • Issues include full context for newcomers"
echo "   • Patterns are extracted and templated"
echo "   • Onboarding is streamlined through automation"
```

## Usage Notes
- Use this for developers joining the project
- Focuses on unique workflow aspects
- Assumes programming knowledge
- Explains automation and tooling
- Provides actionable next steps
- Highlights differences from standard workflows