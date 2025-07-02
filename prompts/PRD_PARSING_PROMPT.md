# Claude Prompt: Parse PRD into Milestone-Based GitHub Issues

## Your Task
Transform the provided PRD (Product Requirements Document) into well-structured GitHub Issues organized by testable milestones. Each milestone should produce functionality that users can test and provide feedback on.

## Ultrathinking Process
Before creating issues, think through:
1. **User Journey Analysis**: What's the simplest path to value? What would make a user say "wow" fastest?
2. **Technical Dependencies**: What must be built first? What can be parallel?
3. **Testing Boundaries**: What can be tested at each stage? How will users interact with it?
4. **Risk Assessment**: What could block progress? What assumptions need validation?
5. **Milestone Definition**: How to group issues for meaningful, testable releases?

## Issue Creation Standards

### For Each Milestone:
- **Duration**: 1-2 weeks maximum
- **Output**: User-testable functionality (not just backend or invisible changes)
- **Issues**: 3-5 per milestone, each completable in 1-2 days
- **Dependencies**: Clear relationships between issues

### 100x Detailed Issue Format:
Each issue must include ALL of these sections:

1. **🎯 Overview** 
   - Parent Issue: # (if applicable)
   - Blocks: # (issues that depend on this)
   - Depends On: # (issues this needs first)
   - Estimated Time: X days
   - Difficulty: Easy/Medium/Hard
   - First-Time Contributors: Yes/No + why

2. **📍 Context for Newcomers**
   - 2-3 sentences explaining the feature
   - Why we're building this
   - How it fits the bigger picture
   - Assume zero prior knowledge

3. **📂 Files to Create/Modify**
   - Exact file paths
   - What each file does
   - Why we need it

4. **✅ Acceptance Criteria**
   - Specific, measurable checkboxes
   - User-facing functionality
   - Technical requirements
   - Quality checks

5. **🏗️ Implementation Guide**
   - Step-by-step instructions
   - Code examples
   - Common patterns to follow
   - Gotchas to avoid

6. **🧪 Testing Instructions**
   - How to verify it works
   - User testing steps
   - Edge cases to check
   - What "done" looks like

7. **🚫 Out of Scope**
   - What NOT to do
   - Future enhancements
   - Scope creep prevention

8. **📊 Success Metrics**
   - How to measure completion
   - Performance targets
   - User experience goals

## Example Ultrathinking Process

<ultrathinking>
The user wants to build a collaborative todo app. Let me think through the milestones:

1. **Value Analysis**: 
   - Fastest path to value: Users need to see todos work locally before any collaboration
   - "Wow" moment: When they can actually check off a todo and it persists
   - Collaboration is exciting but needs foundation first

2. **Technical Dependencies**:
   - Must have: Basic UI → Local functionality → Persistence → Backend → Sync → Sharing
   - Can parallelize: Styling with functionality, tests with features
   - Critical path: Data model must be right from start

3. **Testing Strategy**: 
   - Milestone 1: Can I add/complete/delete todos? (Pure frontend)
   - Milestone 2: Do todos persist when I refresh? (Local storage)
   - Milestone 3: Can I organize my todos? (Categories/priorities)
   - Milestone 4: Can others see my todos? (Sharing/collab)

4. **Risk Assessment**:
   - Biggest risk: Over-engineering early (KISS principle)
   - Data model changes are painful - get it right early
   - Authentication complexity - maybe start with simple sharing links
   - Performance with many todos - plan for it but don't optimize early

5. **Milestone Grouping**:
   - Each milestone = something new users can DO
   - Not just technical progress but user-visible features
   - 4 milestones to full product, each independently valuable
</ultrathinking>

## Parsing Instructions

### 1. Extract Core Requirements
From the PRD, identify:
- **Must-have features** (MVP requirements)
- **Nice-to-have features** (future enhancements)  
- **Implicit requirements** (what users expect but isn't stated)
- **Out of scope** (explicitly not doing)

### 2. Define Milestones
Structure milestones for progressive value delivery:

```
Milestone 1 - MVP (Week 1): Core functionality, locally testable
"I can use this myself right now"

Milestone 2 - Alpha (Week 2): Persistence and basic polish  
"I could show this to a friend"

Milestone 3 - Beta (Week 3): Advanced features and UX
"This feels like a real product"

Milestone 4 - Launch (Week 4): Collaboration and deployment
"I can share this with the world"
```

### 3. Create Issues per Milestone
For each milestone, create 3-5 issues that:
- Build on each other logically
- Can be worked on by different people where possible
- Result in testable features
- Include "integration" issues to tie features together

## Example PRD Input:
"I want to build a todo app where people can create lists, share them with friends, and track completion together. It should work on mobile and desktop, and have a clean, modern design. Users should be able to organize todos by project and set due dates."

## Example Issue Output (100x Detail Level):

### Issue #1: [MVP] Create Basic Todo Interface with Add/Complete/Delete

#### 🎯 Overview
**Milestone**: MVP - Core Todo Functionality (Week 1)
**Parent Issue**: None (this is the foundation)
**Blocks**: #2, #3, #4 (all other features need this base)
**Depends On**: None (starting point)
**Estimated Time**: 1 day
**Difficulty**: Easy
**First-Time Contributors**: Yes! Perfect starting point - no dependencies, clear scope

#### 📍 Context for Newcomers
A todo app helps people track tasks they need to complete. This issue creates the basic interface where users can:
- Type in a new task
- See their list of tasks
- Mark tasks as complete (with satisfying strikethrough!)
- Delete tasks they no longer need

Think of it like a digital sticky note system. We're building just the visual part first - no saving to database yet, so if you refresh the page, todos disappear (we'll fix that in issue #2).

#### 📂 Files to Create/Modify

**Create these new files:**
```
src/
├── index.html          # Main page structure
├── styles/
│   └── main.css       # Visual styling
├── js/
│   └── app.js         # Interactive functionality
└── README.md          # Project documentation
```

**Why this structure:**
- Separating HTML/CSS/JS is a common pattern
- Easy for newcomers to understand
- Sets foundation for future features

#### ✅ Acceptance Criteria
- [ ] Text input field for entering new todos (with placeholder text)
- [ ] "Add" button next to input (or Enter key works)
- [ ] Todos appear in a list below input immediately after adding
- [ ] Each todo has a checkbox on the left
- [ ] Each todo has a delete button (X) on the right
- [ ] Clicking checkbox strikes through the todo text
- [ ] Clicking delete removes todo from list with smooth animation
- [ ] Empty state shows friendly message: "No todos yet! Add one above ☝️"
- [ ] Mobile responsive - works on phone screens
- [ ] Accessible - works with keyboard only

#### 🏗️ Implementation Guide

**Step 1: Create HTML Structure (index.html)**
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Todo App</title>
    <link rel="stylesheet" href="styles/main.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>My Todos</h1>
        </header>
        
        <div class="add-todo-section">
            <input 
                type="text" 
                id="todo-input" 
                class="todo-input"
                placeholder="What needs to be done?"
                aria-label="New todo"
            >
            <button id="add-button" class="add-button">Add</button>
        </div>
        
        <main>
            <ul id="todo-list" class="todo-list"></ul>
            <p id="empty-state" class="empty-state">No todos yet! Add one above ☝️</p>
        </main>
    </div>
    
    <script src="js/app.js"></script>
</body>
</html>
```

**Step 2: Style It Beautifully (styles/main.css)**
```css
* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    background-color: #f5f5f5;
    color: #333;
    line-height: 1.6;
}

.container {
    max-width: 600px;
    margin: 0 auto;
    padding: 20px;
}

header h1 {
    text-align: center;
    color: #2c3e50;
    margin-bottom: 30px;
    font-size: 2.5em;
}

.add-todo-section {
    display: flex;
    gap: 10px;
    margin-bottom: 30px;
}

.todo-input {
    flex: 1;
    padding: 12px 16px;
    font-size: 16px;
    border: 2px solid #ddd;
    border-radius: 8px;
    transition: border-color 0.3s;
}

.todo-input:focus {
    outline: none;
    border-color: #4CAF50;
}

.add-button {
    padding: 12px 24px;
    background-color: #4CAF50;
    color: white;
    border: none;
    border-radius: 8px;
    font-size: 16px;
    cursor: pointer;
    transition: background-color 0.3s;
}

.add-button:hover {
    background-color: #45a049;
}

.todo-list {
    list-style: none;
}

.todo-item {
    display: flex;
    align-items: center;
    padding: 12px;
    background: white;
    margin-bottom: 8px;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    transition: transform 0.2s;
}

.todo-item:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0,0,0,0.15);
}

.todo-checkbox {
    width: 20px;
    height: 20px;
    margin-right: 12px;
    cursor: pointer;
}

.todo-text {
    flex: 1;
    font-size: 16px;
}

.todo-text.completed {
    text-decoration: line-through;
    opacity: 0.6;
}

.delete-button {
    background: none;
    border: none;
    color: #e74c3c;
    font-size: 20px;
    cursor: pointer;
    padding: 4px 8px;
    transition: color 0.3s;
}

.delete-button:hover {
    color: #c0392b;
}

.empty-state {
    text-align: center;
    color: #999;
    font-size: 18px;
    margin-top: 40px;
}

/* Mobile responsive */
@media (max-width: 600px) {
    .container {
        padding: 10px;
    }
    
    header h1 {
        font-size: 2em;
    }
    
    .add-todo-section {
        flex-direction: column;
    }
    
    .add-button {
        width: 100%;
    }
}
```

**Step 3: Add Interactivity (js/app.js)**
```javascript
// State management
let todos = [];
let nextId = 1;

// DOM elements
const todoInput = document.getElementById('todo-input');
const addButton = document.getElementById('add-button');
const todoList = document.getElementById('todo-list');
const emptyState = document.getElementById('empty-state');

// Add todo function
function addTodo() {
    const text = todoInput.value.trim();
    
    if (!text) {
        // Shake the input if empty
        todoInput.classList.add('shake');
        setTimeout(() => todoInput.classList.remove('shake'), 500);
        return;
    }
    
    const todo = {
        id: nextId++,
        text: text,
        completed: false
    };
    
    todos.push(todo);
    todoInput.value = '';
    todoInput.focus();
    
    renderTodos();
}

// Render todos to DOM
function renderTodos() {
    // Clear current list
    todoList.innerHTML = '';
    
    // Show/hide empty state
    emptyState.style.display = todos.length === 0 ? 'block' : 'none';
    
    // Render each todo
    todos.forEach(todo => {
        const li = document.createElement('li');
        li.className = 'todo-item';
        li.innerHTML = `
            <input 
                type="checkbox" 
                class="todo-checkbox" 
                ${todo.completed ? 'checked' : ''}
                onchange="toggleTodo(${todo.id})"
            >
            <span class="todo-text ${todo.completed ? 'completed' : ''}">
                ${escapeHtml(todo.text)}
            </span>
            <button class="delete-button" onclick="deleteTodo(${todo.id})">
                ×
            </button>
        `;
        
        todoList.appendChild(li);
    });
}

// Toggle todo completion
function toggleTodo(id) {
    const todo = todos.find(t => t.id === id);
    if (todo) {
        todo.completed = !todo.completed;
        renderTodos();
    }
}

// Delete todo
function deleteTodo(id) {
    todos = todos.filter(t => t.id !== id);
    renderTodos();
}

// Utility: Escape HTML to prevent XSS
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// Event listeners
addButton.addEventListener('click', addTodo);
todoInput.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') {
        addTodo();
    }
});

// Add shake animation to CSS
const style = document.createElement('style');
style.textContent = `
    @keyframes shake {
        0%, 100% { transform: translateX(0); }
        25% { transform: translateX(-10px); }
        75% { transform: translateX(10px); }
    }
    .shake {
        animation: shake 0.5s;
    }
`;
document.head.appendChild(style);

// Initial render
renderTodos();
```

#### 🧪 Testing Instructions

**Manual Testing Checklist:**
1. **Add Todo**
   - [ ] Type "Buy milk" and click Add - todo appears in list
   - [ ] Type "Walk dog" and press Enter - todo appears in list
   - [ ] Try to add empty todo - input shakes, nothing added
   - [ ] Try to add todo with just spaces - treated as empty

2. **Complete Todo**
   - [ ] Click checkbox next to "Buy milk" - text gets strikethrough
   - [ ] Click checkbox again - strikethrough removed
   - [ ] Visual feedback is smooth

3. **Delete Todo** 
   - [ ] Hover over todo - delete button visible
   - [ ] Click × button - todo disappears smoothly
   - [ ] List reorders correctly

4. **Empty State**
   - [ ] Delete all todos - "No todos yet!" message appears
   - [ ] Add a todo - message disappears

5. **Mobile Testing**
   - [ ] Open on phone/tablet simulator
   - [ ] Input and buttons stack vertically
   - [ ] Everything remains usable

6. **Accessibility**
   - [ ] Tab through interface - logical order
   - [ ] Enter works on focused button
   - [ ] Screen reader announces actions

**What Success Looks Like:**
- User can manage a simple todo list
- Interface feels responsive and polished
- Works on all screen sizes
- No console errors

#### 🚫 Out of Scope
- Data persistence (refresh loses todos - that's issue #2)
- User accounts or authentication
- Categories, projects, or tags
- Due dates or priorities  
- Drag-and-drop reordering
- Search or filtering
- Keyboard shortcuts beyond Enter

Save these for future issues!

#### 📊 Success Metrics
- Page loads in < 1 second
- Adding a todo takes < 100ms
- No layout shift when adding/removing todos
- Works on screens 320px and wider
- Zero console errors
- 100% of acceptance criteria met

---

## Additional Instructions for Claude

When parsing PRDs:
1. **Always start with the simplest valuable thing** - resist over-engineering
2. **Each issue should produce something testable** - no pure refactoring in early milestones
3. **Include code examples** - newcomers need concrete starting points
4. **Explain the "why"** - context helps newcomers understand decisions
5. **Set clear boundaries** - what NOT to do is as important as what to do

Remember: The goal is to help someone who has never seen this codebase before successfully implement a feature and feel proud of their contribution!