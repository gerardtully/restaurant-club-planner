# 🎓 AI Development Workshop Guide

*From PRD to working software in 90 minutes - no terminal needed!*

## Workshop Overview

**Duration**: 90 minutes
**Prerequisites**: PRD already created and placed in `docs/prds/current/PROJECT_PRD.md`
**Outcome**: Working software with automated GitHub workflows

---

## Pre-Workshop Setup (30 min before main session)

### For Non-Technical Participants:
1. **Run workshop setup** (from ai-starter-kit folder):
   - Mac: Double-click `setup/workshop/workshop-setup.sh`
   - Windows: Run `setup/workshop/workshop-setup.bat`
   
2. **Follow the prompts**:
   - Enter project name (e.g., "chess-puzzle")
   - Script will create GitHub repo and issue #1

3. **Edit PRD if desired**:
   - Location: `docs/prds/current/PROJECT_PRD.md`
   - Can use the example or replace with your own

**Result**: Everything is ready! Repo created, automation configured, parent issue waiting.

---

## Workshop Flow

### Introduction (10 min)
- Show example of what we'll build
- Demonstrate the AI workflow
- Explain automation benefits

### Part 1: Quick Check (5 min)
**Verify everyone's setup**

Have participants:
1. Open their GitHub repository in browser
2. Verify issue #1 exists: "Parse PRD into Development Tasks"
3. Open Cursor and navigate to their project folder

**Facilitator**: Help anyone who had setup issues.

### Part 2: Work on PRD Parsing Issue (20 min)
**AI creates all your subtasks**

Participants use:
```
Work on issue #1 "Parse PRD into Development Tasks":
1. Read the PRD from docs/prds/current/PROJECT_PRD.md
2. Read templates/PRD_PARSING_PROMPT.md
3. Parse the PRD into 4-6 subtask issues
4. Create each on GitHub with newcomer-standard-issue template
5. Link them to parent issue #1
```

**Watch**: As AI creates multiple linked issues automatically!

### Part 3: Build First Feature (30 min)
**Real development begins**

Participants pick a subtask and use:
```
Work on issue #[SUBTASK NUMBER]:
1. Create feature branch
2. Implement the requirements
3. Commit and push
4. Create pull request

Guide me step by step.
```

**Watch together**: 
- GitHub Actions running
- Automated checks
- Project board updates

### Part 4: Merge and Celebrate (15 min)
**Complete the cycle**

Participants use:
```
My PR passed all checks. Please:
1. Show me how to merge it
2. Update my local main branch
3. Start on issue #2

Walk me through it.
```

---

## Facilitator Guide

### Room Setup
- Projector showing facilitator's screen
- Participants need laptops with Cursor installed
- WiFi that allows GitHub access
- Backup: Have example PRD ready

### Common Issues & Solutions

**"GitHub authentication failed"**
- Have them use: `Ask AI: "Help me authenticate with GitHub using gh auth login"`

**"Repository already exists"**
- Use different name or ask AI to delete and recreate

**"Workflows not running"**
- Check Actions tab - may need to enable
- First workflow run sometimes needs approval

### Key Teaching Points

1. **AI as coding partner**: You decide WHAT, AI handles HOW
2. **Automation value**: Show time saved with each automated step
3. **Real workflow**: This is how modern teams work
4. **No memorization**: Always ask AI for commands

### Success Metrics
- Everyone has a GitHub repo with automation
- At least 1 PR created and merged
- Participants understand the workflow
- Confidence to continue independently

---

## Participant Handout

### Your AI Prompts Cheat Sheet

**Setup Repository**:
```
Create GitHub repository from current folder with all automation enabled
```

**Create Issues**:
```
Parse my PRD into GitHub issues using newcomer-standard-issue template
```

**Start Development**:
```
Work on issue #[NUMBER] - create branch, implement, and make PR
```

**Fix Problems**:
```
I got error: [PASTE]. How do I fix this?
```

**See Progress**:
```
Show me my issues, PRs, and project board in the browser
```

### Remember
- AI knows the commands - just ask!
- Be specific: include repo name and issue numbers
- Check GitHub website to see visual results
- Every error has a solution - ask AI

---

## Post-Workshop

### Participants leave with:
1. Working GitHub repository
2. Automated workflows running
3. Several issues ready to work on
4. Experience with the full cycle
5. Confidence to continue

### Follow-up resources:
- This guide for reference
- WORKSHOP_SIMPLE.md for step-by-step
- AI_DEVELOPMENT_GUIDE.md for advanced patterns
- Discord/Slack for questions

---

## Alternative Formats

### Lightning Version (30 min)
- Skip automation setup
- Create 2 issues only  
- Build one small feature
- Focus on PR workflow

### Deep Dive (3 hours)
- Include PRD writing session
- Build multiple features
- Add testing workflow
- Deploy to production

### Team Training (Half day)
- Start with team's actual PRD
- Set up real project
- Configure team-specific workflows
- Practice code review process

---

*The goal: Show that ANYONE can build software with AI assistance and proper workflows!*