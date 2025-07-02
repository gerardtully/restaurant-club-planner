---
name: Parent Issue (Requires Subtasks)
about: For features or bugs that will take more than 2 days - MUST be broken into subtasks
title: '[Feature Area] Parent: High-Level Description'
labels: 'parent-issue, needs-subtasks'
assignees: ''

---

<!-- 
⚠️ MANDATORY: This template is for PARENT issues only!
If your task can be completed in 1-2 days, use the "Newcomer Standard Issue" template instead.
Parent issues MUST be broken down into subtasks before work begins.
-->

# [Feature Area] Parent: High-Level Description

## 🚨 Mandatory Reading
Before starting ANY work:
1. **MUST READ**: [.cursor/rules/CRITICAL_CORE.mdc](.cursor/rules/CRITICAL_CORE.mdc) - Universal development principles
2. Review the acceptance criteria below

## 🎯 Overview
**Estimated Total Effort**: X days across Y subtasks
**Priority**: High/Medium/Low
**Complexity**: High/Medium/Low

## 📋 High-Level Description
[2-3 paragraphs explaining the overall feature/fix needed. This provides context but is NOT where implementation happens.]

## 🔨 Subtask Breakdown

<!-- 
MANDATORY: Break this down into 1-2 day subtasks.
Each subtask must modify different files to enable parallel work.
-->

### Planned Subtasks:
- [ ] Step 1: [Specific task] - 1 day - Files: [list files]
- [ ] Step 2: [Specific task] - 2 days - Files: [list files]  
- [ ] Step 3: [Specific task] - 1 day - Files: [list files]
- [ ] Step 4: [Specific task] - 1 day - Files: [list files]

### Dependencies:
- Step 2 depends on Step 1
- Steps 3 & 4 can be done in parallel after Step 2

## 🎯 Success Criteria
[Overall success metrics for the entire feature - each subtask will have its own specific criteria]

## 📊 Why This Breakdown?
[Explain why you've chosen to split it this way - what makes each piece independent?]

## ⚠️ Important Notes
- DO NOT start implementation on this parent issue
- Create subtask issues using the "Newcomer Standard Issue" template
- Each subtask must be self-contained with full context
- Update this issue with subtask issue numbers once created

---

**Next Steps**: Create the subtask issues listed above, then update this description with their issue numbers.