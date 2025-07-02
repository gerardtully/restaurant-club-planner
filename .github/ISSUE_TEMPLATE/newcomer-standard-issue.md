---
name: Newcomer Standard Issue
about: Template for creating issues that follow the Newcomer Standard
title: '[Feature Area] Step X: Specific Task Description'
labels: 'enhancement'
assignees: ''

---

# [Feature Area] Step X: Specific Task Description

## 🚨 Mandatory Reading
Before starting ANY work:
1. **MUST READ**: [.cursor/rules/CRITICAL_CORE.mdc](.cursor/rules/CRITICAL_CORE.mdc) - Universal development principles
2. Review the acceptance criteria below

## 🎯 Overview
**Parent Issue**: #[number] (if applicable)
**Blocks**: #[numbers] (issues that depend on this)
**Depends On**: #[numbers] (issues this needs first)
**Estimated Time**: 1-2 days
**Difficulty**: Easy/Medium/Hard

## 📍 Context for Newcomers
[2-3 sentences explaining what this feature area is and why we're doing this task. Assume the reader has never seen this codebase before. Use simple language and avoid jargon.]

## 📂 Files to Create/Modify

### New Files to Create:
- `path/to/new/file1.swift` - [Brief description of what this file does]
- `path/to/new/file2.swift` - [Brief description of what this file does]

### Files to Modify:
- `path/to/existing/file.swift` - [What specific changes needed]
- `path/to/another/file.swift` - [What specific changes needed]

## ✅ Acceptance Criteria
- [ ] Specific measurable outcome 1
- [ ] Specific measurable outcome 2
- [ ] Build passes without warnings
- [ ] Tests added/updated and passing
- [ ] Theme compliance maintained
- [ ] No merge conflicts with other subtasks

## 🏗️ Implementation Guide

### Step 1: [Specific first task]
[Clear instructions with context]

```swift
// Example code showing the pattern to follow
struct ExampleView: View {
    var body: some View {
        // Implementation example
        Text("Hello")
            .foregroundColor(Theme.colors.primary) // Use theme colors
    }
}
```

### Step 2: [Specific second task]
[Clear instructions with examples]

### Step 3: [Specific third task]
[Clear instructions]

## 🧪 Testing Instructions

1. **Manual Testing**:
   - How to test this feature manually
   - Specific user flows to verify
   - Edge cases to check

2. **Automated Tests**:
   ```swift
   // Example test to add
   func testFeatureWorks() {
       // Test implementation
   }
   ```

3. **Validation**:
   - How to know it's working correctly
   - Expected behavior description

## 🚫 Out of Scope
- [Things NOT to do in this issue]
- [Changes to avoid to prevent conflicts]
- [Features being handled in other issues]

## 💡 Tips for Success
- Common pitfalls to avoid
- Helpful code patterns in the codebase
- Similar implementations to reference
- Who to ask for help (@mention)

## 🔗 Resources
- [Link to relevant documentation]
- [Link to similar code in codebase]
- [External resources if needed]

---

**Success looks like**: [One sentence describing what done looks like for this issue]