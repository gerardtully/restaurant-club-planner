---
name: Bug Report
about: Report a bug that can be fixed in 1-2 days (larger bugs use Parent Issue template)
title: '[Bug] Specific description of what is broken'
labels: 'bug, needs-triage'
assignees: ''

---

# [Bug] Specific Description of What Is Broken

## 🚨 Mandatory Reading
Before starting ANY work:
1. **MUST READ**: [.cursor/rules/CRITICAL_CORE.mdc](.cursor/rules/CRITICAL_CORE.mdc) - Universal development principles
2. Review the acceptance criteria below

## 🐛 Bug Description
**What's broken**: [Clear description of the problem]
**Expected behavior**: [What should happen instead]
**Actual behavior**: [What actually happens]

## 📱 Reproduction Steps
1. Open the app
2. Navigate to [specific screen]
3. Tap [specific button]
4. Observe [the bug]

## 📍 Context for Newcomers
[1-2 sentences explaining this area of the app for someone unfamiliar with the codebase]

## 🔍 Initial Investigation
**Suspected files**:
- `path/to/suspected/file.swift` - [Why you suspect this file]
- `path/to/another/file.swift` - [Why you suspect this file]

**Error messages/logs**:
```
Paste any relevant error messages or console output here
```

## ✅ Acceptance Criteria
- [ ] Bug no longer reproduces with steps above
- [ ] No regression in related features
- [ ] Tests added to prevent recurrence
- [ ] Build passes without warnings

## 📱 Environment
- iOS Version: [e.g., 18.0]
- Device: [e.g., iPhone 15 Pro]
- App Version: [e.g., 1.0.0]
- Xcode Version: [e.g., 16.0]

## 📸 Screenshots/Videos
[If applicable, add screenshots or videos to help explain the problem]

## 💡 Possible Solution
[If you have ideas about how to fix it, describe them here]

---

**Note**: If this bug requires more than 2 days to fix or affects multiple systems, please use the "Parent Issue" template instead and break it into subtasks.