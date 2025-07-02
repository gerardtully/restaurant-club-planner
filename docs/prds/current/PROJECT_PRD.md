# 🧾 Product Requirements Document (PRD)

## Project: Restaurant Club Planner

---

## 1. 🎯 Problem Overview

### Elevator Pitch

A mobile-first web app that helps a core group of friends coordinate weekly restaurant dinners. It enables flexible scheduling, RSVP tracking, and automatic restaurant logging — all while maintaining a lightweight, no-login experience.

### Problem Statement

Group coordination for recurring weekly events becomes chaotic without a dedicated tool. Group chats lose information, attendees forget details, and hosts must constantly repeat logistics. There’s no single place to track who’s coming, where the group has been, or what restaurants are worth revisiting.

### Core User Story

> "As a member of a weekly restaurant club, I want to quickly see where and when the next dinner is happening, RSVP if I'm attending, and check what restaurants we've already visited so we don’t repeat."

---

## 2. 🧩 Feature Breakdown

### 2.1 Dinner Scheduling

- Admin can create a new dinner with:
  - Date & time (defaults to next Monday @ 7PM)
  - Reserved slots (pre-filled names)
  - Open slots (number of available RSVP spots)
  - Restaurant name & address (optional)
  - Reservation made (Yes/No)
- Only one dinner allowed per calendar week (week starts on Monday)
- Admin can edit any dinner’s fields post-creation
- Admin can delete or duplicate dinners

### 2.2 RSVP System

- Users RSVP by entering a name (no login)
- RSVP options:
  - Join an open slot (until seats filled)
  - Reserved users can confirm or decline
  - Declining frees up that slot to the open pool
- When seat limit is reached:
  - Show "Dinner is fully booked" message
  - No waitlist supported in MVP
- RSVP list visually separates confirmed, declined, and open spots

### 2.3 Restaurant Logging

- A new restaurant entry is auto-created once a dinner occurs
- Restaurant entry includes:
  - Name
  - Address
  - Cuisine
  - Price point category (\$, \$\$, \$\$\$)
  - Aggregated feedback (below)

### 2.4 Feedback Collection

- After the dinner's start time, all attendees see a feedback form with:
  1. Would you come here again?
  2. Would you come here alone?
  3. Would you tell someone about this place?
- Each answer is Yes/No
- Answers are attributed to each attendee (non-anonymous)
- Users can submit answers **only once**
- Restaurant detail view shows % of Yes for each question

### 2.5 History View

- A browsable dinner history includes:
  - Date & time
  - Restaurant info (name/address)
  - Reservation status (Yes/No)
  - Attendees (confirmed names)
  - Feedback answers per person

### 2.6 Restaurant Directory & Search

- Filterable/searchable restaurant log:
  - Filter by: cuisine, price point
  - Search by: restaurant name
- Clicking a restaurant shows full info + feedback percentages

### 2.7 Mobile UX / Responsiveness

- Mobile-first layout with:
  - Touch-friendly RSVP buttons
  - Vertical dinner/event feed
  - Easy filtering in restaurant view
- Desktop view remains usable but unoptimized

---

## 3. 👥 User Stories

### Admin User

- Create, duplicate, or delete weekly dinners
- Set date/time, slot count, reserved names
- Fill in restaurant info and mark reservation made
- View all RSVP names and manually edit slots if needed

### Regular Attendee

- View next 4 weeks of dinners
- RSVP to an open slot by entering name
- Confirm or decline if in a reserved slot
- Submit post-dinner feedback with Yes/No answers
- Browse past dinners and view restaurant feedback

### Guest Attendee

- Access web app via shared link
- RSVP without account by typing name
- See details for upcoming dinner
- Give feedback after attending

---

## 4. 🧱 Components & Logic

### Dinner Model

```ts
Dinner {
  id: string,
  date: datetime,
  restaurant: string | null,
  address: string | null,
  time: string (defaults 7pm),
  reservationMade: boolean,
  reservedSlots: string[],
  openSlots: number,
  attendees: string[],
  declines: string[],
}
```

### Restaurant Model

```ts
Restaurant {
  id: string,
  name: string,
  address: string,
  cuisine: string,
  priceCategory: "$" | "$$" | "$$$",
  dinnersVisited: number,
  feedback: {
    wouldReturn: { name: string, answer: boolean }[],
    wouldComeAlone: { name: string, answer: boolean }[],
    wouldRecommend: { name: string, answer: boolean }[],
  }
}
```

---

## 5. 📆 Milestones

### Milestone 1: Dinner Creation & RSVP (Core Flow)

- Admin creates dinners with reserved + open slots
- Public RSVP form with name entry
- Visual RSVP list with statuses
- Seat cap enforcement with "Fully Booked" UI

**Acceptance Criteria:**

- Can’t create >1 dinner per week
- RSVPs update in real time
- Admin can change seats and slots post-creation

---

### Milestone 2: Restaurant Log & Feedback

- Auto-log restaurant after dinner
- Feedback form triggers after dinner start time
- Each user can submit once
- Restaurant page shows feedback % breakdown

**Acceptance Criteria:**

- Only attendees can submit feedback
- % correct based on Yes/No tallies
- No anonymous answers

---

### Milestone 3: Directory & Filters

- Add price & cuisine tags
- Enable search + filtering
- Show list of all restaurants with links to detail view

**Acceptance Criteria:**

- Filters work on cuisine & price tier
- Search finds substring matches on name

---

### Milestone 4: History View & UX Polish

- Show full dinner history
- Include all metadata and RSVP names
- Responsive layout finalized

**Acceptance Criteria:**

- Works on mobile and desktop
- Feedback is visible per person on past dinners

---

## 6. 🤖 AI/LLM Integration (None Planned in MVP)

- No dynamic generation, AI chat, or LLM use at runtime
- No notifications or background workers

---

## 7. 📌 Exclusions (MVP Won't Include)

- Waitlists
- Login/authentication
- Push/email notifications
- Ratings or written comments
- Restaurant suggestions
- Chat or discussion threads

---

## 8. ✅ Final Notes for Dev

- Default to Monday 7PM for new events
- All RSVP logic must support late opt-in/out with seat validation
- Feedback logic is unlocked post-dinner start time
- Use minimal external dependencies unless absolutely needed
- Use a flat file store or Supabase if persistent state is needed

