# 🤖 CLAUDE.md - AI Assistant Context

This file helps Claude Code understand your project and assist you better.

## Project Overview

**AI Starter Kit**: Battle-tested patterns and workflows for building better software with AI assistance.

This starter kit provides:
1. **Problem Solutions**: Fixes for the 10 most common AI coding issues
2. **Prompt Templates**: Get working code on the first try
3. **PRD Workflow**: Transform ideas into organized GitHub issues
4. **Professional Standards**: GitHub workflows that scale

## Key Principles for Claude

### 1. Developer-Focused
- Assume users are building real projects
- Provide production-ready code
- Follow patterns in `.cursor/rules/CRITICAL_CORE.mdc`
- Reference the AI Development Guide when helping

### 2. Solve Real Problems
- Users often struggle with AI coding issues
- Direct them to relevant sections in AI_DEVELOPMENT_GUIDE.md
- Use the troubleshooting patterns documented there
- Apply the prompt templates for better results

### 3. Maintain Standards
- Follow GitHub workflow in CONTRIBUTING.md
- Use issue templates for structured development
- Encourage PRD-driven development
- Keep code quality high

## Current Structure
```
ai-starter-kit/
├── AI_DEVELOPMENT_GUIDE.md    # Main reference (everything here)
├── CONTRIBUTING.md            # GitHub workflow & standards
├── templates/                 # Ready-to-use templates
│   ├── PRD_TEMPLATE.md       # Simple PRD format
│   ├── CLAUDE_TEMPLATE.md    # For new projects
│   └── README_TEMPLATE.md    # Project documentation
├── examples/                  # Real PRD → Issues examples
└── .cursor/rules/            # AI behavior rules
```

## Common User Tasks

### Getting Started
Direct users to AI_DEVELOPMENT_GUIDE.md - it has:
- 5-minute quick start
- Common problem solutions
- Prompt writing guide
- PRD workflow

### Fixing AI Problems
The guide covers solutions for:
- AI creating too many files
- Code not working despite AI claims
- AI changing too much
- Getting stuck in loops
- And 6 more common issues

### Writing Better Prompts
Reference the prompt examples in the guide:
- Feature additions
- Bug fixes
- Styling
- Refactoring
- Each with bad → good → best examples

### PRD to Issues
Help users follow the workflow:
1. Write simple PRD (template provided)
2. Define milestones (1-2 week chunks)
3. Parse into issues (detailed format)
4. Build incrementally

## Important Context

### For New Users
- Start with the 5-minute quick start in AI_DEVELOPMENT_GUIDE.md
- Apply patterns immediately to their project
- Use templates as starting points

### For Experienced Developers
- Extract patterns for their own projects
- Customize templates for their stack
- Follow CRITICAL_CORE rules
- Adapt workflows to their needs

## Development Standards

Always enforce:
1. **Single-Pass Implementation** - Get it right first time
2. **Build Validation** - Test after every change
3. **Clear Communication** - Explain what you're doing
4. **Efficiency First** - Minimal tool calls

## Key Files Reference

- **Main Guide**: `AI_DEVELOPMENT_GUIDE.md` - Everything consolidated
- **Workflow**: `CONTRIBUTING.md` - GitHub standards
- **Rules**: `.cursor/rules/CRITICAL_CORE.mdc` - Universal principles
- **Templates**: `templates/` directory - Ready to copy
- **Examples**: `examples/` directory - See it in action

---

Remember: This is a production-ready starter kit, not a workshop. Help users apply these patterns to build real software efficiently.