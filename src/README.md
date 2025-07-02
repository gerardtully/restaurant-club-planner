# 🍽️ Restaurant Club Planner

A mobile-first web app for coordinating weekly restaurant dinners with friends.

## Features

### ✅ Issue #3: Basic Dinner Scheduling Interface (COMPLETE)

- **Create Dinners**: Schedule weekly dinners with date, time, and restaurant details
- **Reserved & Open Slots**: Set specific reserved slots (by name) and open slots for anyone
- **Week Validation**: Only one dinner allowed per calendar week (Monday-Sunday)
- **Edit & Delete**: Modify or remove existing dinners
- **Mobile-First Design**: Touch-friendly interface that works great on phones
- **Local Storage**: Data persists between browser sessions

## How to Use

### 1. Open the App
- Open `src/index.html` in your web browser
- The app will automatically set the date to next Monday at 7:00 PM

### 2. Create a Dinner
- **Date & Time**: Pick your dinner date and time
- **Restaurant Info**: Add restaurant name and address (optional)
- **Reserved Slots**: Enter comma-separated names for people with guaranteed spots
- **Open Slots**: Set how many first-come-first-served spots are available
- **Reservation Status**: Mark if you've already made a restaurant reservation

### 3. Manage Dinners
- **Edit**: Click "Edit" button to modify any dinner details
- **Delete**: Click "Delete" button to remove a dinner (with confirmation)
- **Week Rule**: Can't create multiple dinners in the same calendar week

## Technical Details

### File Structure
```
src/
├── index.html              # Main app page
├── styles/main.css         # Mobile-first styling
├── js/
│   ├── data-models.js      # Dinner data structure & storage
│   └── dinner-scheduler.js # Main app logic
└── README.md              # This file
```

### Data Storage
- Uses browser localStorage for persistence
- Data survives page refreshes and browser restarts
- All data stays on your device (no server required)

### Browser Compatibility
- Modern browsers (Chrome, Firefox, Safari, Edge)
- Mobile browsers (iOS Safari, Chrome Mobile)
- Progressive enhancement for older browsers

## Development Status

- ✅ **Issue #3**: Basic Dinner Scheduling Interface
- ⏳ **Issue #4**: RSVP System (Next)
- ⏳ **Issue #5**: Restaurant Logging (Future)
- ⏳ **Issue #6**: Feedback Collection (Future)

## Testing the App

1. Open `src/index.html` in your browser
2. Try creating a dinner for next Monday
3. Add reserved slots: "John, Jane, Bob"
4. Set 3 open slots
5. Test the edit and delete functions
6. Try creating another dinner in the same week (should show validation error)

Built with vanilla HTML, CSS, and JavaScript - no frameworks required! 🚀 