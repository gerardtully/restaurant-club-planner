# 🎯 AI Development Workflow Extraction Guide

*A pragmatic guide for experienced developers to extract and apply AI-assisted development patterns to existing projects.*

## Executive Summary

This starter kit contains battle-tested patterns from production AI-assisted development. Extract what you need:

- **PRD → Issue Workflow**: Transform ideas into structured GitHub issues in minutes
- **AI Context Management**: CLAUDE.md pattern for consistent AI behavior across sessions
- **Error Prevention Rules**: Documented solutions to the 10 most common AI coding failures
- **Prompt Engineering Templates**: Copy-paste formulas that work

**Time to value**: 15 minutes to extract patterns, 1 hour to integrate into existing project.

---

## 🔥 Core Patterns Worth Stealing

### 1. The CLAUDE.md Pattern
**What**: Project context file that persists across AI sessions  
**Value**: 70% reduction in context repetition, consistent AI behavior  
**Extract**: Copy `/templates/CLAUDE_TEMPLATE.md` to your project root

### 2. PRD → GitHub Issues Workflow
**What**: Structured process from idea to executable tasks  
**Value**: 2-hour planning sessions become 20 minutes  
**Extract**: 
- PRD template: `/templates/PRD_TEMPLATE.md`
- Parsing prompt: `/templates/PRD_PARSING_PROMPT.md`
- Issue templates: `.github/ISSUE_TEMPLATE/` (8 templates)
- Example transformation: `/examples/todo_app_parsed_issues.md`

### 3. Critical AI Behavior Rules
**What**: Universal rules that prevent common failures  
**Value**: First-pass success rate increases from ~40% to ~80%  
**Extract**: Create `.ai/rules/` in your project with:
```
- Single-pass implementation required
- No file creation without explicit request
- Test after every change
- Preserve existing code style
```

### 4. Constraint-Based Prompting
**What**: Prompt structure that reduces AI hallucination  
**Value**: Working code on first attempt  
**Formula**: Context + Request + Constraints + Example

---

## 📋 Integration Playbook

### Phase 1: Assess Current State (5 min)
```bash
# Quick audit of your project
find . -name "*.md" -path "*/.*" -prune -o -print | grep -E "(README|CONTRIBUTING|docs)"
ls -la .github/workflows/
git log --oneline -10  # Recent commit style
```

### Phase 2: Create AI Context (10 min)
1. Copy `CLAUDE.md` to your project root:
   ```bash
   curl -O https://raw.githubusercontent.com/seanacres/ai-starter-kit/main/templates/CLAUDE_TEMPLATE.md
   mv CLAUDE_TEMPLATE.md CLAUDE.md
   ```

2. Customize for your project:
   - Replace boilerplate with your project description
   - Add your tech stack specifics
   - Document any unusual patterns or constraints
   - Include your coding standards

### Phase 3: Implement PRD Workflow (15 min)
1. Create docs structure:
   ```bash
   mkdir -p docs/prds/{current,future,completed}
   ```

2. Add to your `CONTRIBUTING.md`:
   ```markdown
   ## Development Process
   1. PRD in `/docs/prds/current/`
   2. Parse to GitHub issues using AI
   3. Implement in 1-2 week milestones
   4. Archive to `/docs/prds/completed/`
   ```

3. Train your team on the PRD parsing prompt

### Phase 4: Add AI Rules (10 min)
Create `.cursorrules` or `.github/ai-rules.md`:
```markdown
# AI Assistant Rules
1. Read existing code before suggesting changes
2. One feature per conversation
3. No unsolicited refactoring
4. Test commands must be provided
5. Match existing code style exactly
```

---

## 🛠 Stack Customization Guide

### For React/Next.js Projects
```markdown
# In CLAUDE.md, add:
Tech Stack:
- Next.js 14 with App Router
- TypeScript strict mode
- Tailwind CSS with custom design system
- Prisma with PostgreSQL

AI Rules:
- Use server components by default
- Client components only with 'use client'
- Follow app directory conventions
```

### For Python/Django Projects
```markdown
# In CLAUDE.md, add:
Tech Stack:
- Django 4.2 with DRF
- Python 3.11 with type hints
- Black formatter settings
- pytest for testing

AI Rules:
- Follow PEP 8 strictly
- Use Django's built-in features
- Type hints required
```

### For Enterprise/Legacy Projects
```markdown
# In CLAUDE.md, add:
Constraints:
- No new dependencies without approval
- Maintain backward compatibility
- Follow existing patterns, even if outdated
- Changes must be minimal and isolated
```

---

## 👥 Team Rollout Strategy

### Week 1: Pioneer Adoption
1. One senior dev extracts patterns
2. Apply to one active project
3. Document specific wins/customizations

### Week 2: Early Adopters
1. Share customized templates in team meeting
2. 2-3 devs try on their projects
3. Collect feedback, refine rules

### Week 3: Team-Wide
1. Standardize CLAUDE.md across projects
2. Add to onboarding checklist
3. Create team-specific prompt library

### Success Metrics
- Time from PRD to first PR
- Reduction in AI-generated bugs
- Developer satisfaction scores
- Code review iterations

---

## 🚀 Advanced Workflows

### Multi-Stage PRD Processing
```bash
# For complex projects, break PRD parsing into stages:
1. Technical Discovery PRD → Research issues
2. Implementation PRD → Development issues  
3. Deployment PRD → DevOps/release issues
```

### AI Context Layering
```
project/
├── CLAUDE.md          # Project-wide context
├── frontend/
│   └── CLAUDE.md     # Frontend-specific rules
└── backend/
    └── CLAUDE.md     # Backend-specific rules
```

### Automated PR Descriptions
```markdown
# In PRD parsing prompt, add:
Also generate a PR description template with:
- Summary of changes
- Testing checklist
- Breaking changes
- Deployment notes
```

### GitHub Automation (Included)
The starter kit includes battle-tested GitHub workflows:
- **Issue Validation**: Automatic formatting and requirement checks
- **Assignment Tracking**: Prevents duplicate work, manages assignments
- **Branch Naming**: Enforces `feature/`, `fix/`, `docs/` conventions
- **PR Automation**: Templates and project board updates
- **Stale Management**: Keeps issues/PRs fresh

See `.github/workflows/` for all automations.

---

## 📊 Measuring Success

### Before/After Metrics
Track these before and after implementation:
- **PRD → Deployment time**: Typically 40% reduction
- **First-pass AI success**: From ~40% to ~80%
- **Context switching overhead**: 70% reduction
- **Bug introduction rate**: 50% lower with rules

### Quick Wins Checklist
- [ ] CLAUDE.md reduces repeated context: Save 5-10 min/session
- [ ] PRD workflow clarifies requirements: Save 2 hours/feature
- [ ] AI rules prevent common mistakes: Save 30 min/day debugging
- [ ] Team alignment improves: Fewer revision cycles

---

## 🔧 Troubleshooting Integration

### Common Integration Issues

**"AI ignores our coding standards"**
- Add explicit examples to CLAUDE.md
- Include your linter config
- Reference specific style guide sections

**"PRD workflow too heavy for small features"**
- Create micro-PRD template (5 lines)
- Use for 2+ day features only
- Inline small tasks in issues

**"Team resistance to new workflow"**
- Start with volunteers only
- Show time savings data
- Let success stories spread naturally

---

## 📚 Quick Reference

### Essential Files to Copy
```bash
templates/CLAUDE_TEMPLATE.md → CLAUDE.md
templates/PRD_TEMPLATE.md → docs/prds/current/
templates/PRD_PARSING_PROMPT.md → team-docs/
```

### Prompt Patterns That Work
```
Feature: "In [file], add [feature] that [behavior]. Current structure: [code]. Constraints: [limits]"
Debug: "Error: [paste]. Context: [what you tried]. Find root cause, don't guess."
Refactor: "Improve [file] for [goal]. Preserve: [list]. Change only: [scope]"
```

### Decision Tree
```
New project? → Full starter kit
Existing project < 6 months? → Full integration  
Legacy project? → CLAUDE.md + Rules only
Quick experiment? → Just prompt templates
```

---

## 🎯 Next Steps

1. **Extract**: Copy templates you need (15 min)
2. **Customize**: Adapt to your stack (30 min)
3. **Test**: Try on one real feature (1 hour)
4. **Iterate**: Refine based on results
5. **Scale**: Roll out to team

### Running Team Workshops
Use `setup/workshop/workshop-setup.sh` and `WORKSHOP_GUIDE.md` to run hands-on training:
- Session 1: Non-technical prototype building
- Session 2: GitHub automation setup
- Includes all prompts and step-by-step instructions

Remember: Take what works, leave what doesn't. These patterns are meant to be adapted, not followed blindly.

---

*For beginners or setup help, see [NON_TECHNICAL_START_HERE.md](setup/NON_TECHNICAL_START_HERE.md)*