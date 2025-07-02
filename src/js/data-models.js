/**
 * Data Models for Restaurant Club Planner
 * Defines the structure and validation for Dinner objects
 */

/**
 * Dinner Model
 * Represents a scheduled dinner event
 */
class Dinner {
    constructor({
        id = null,
        date,
        time = '19:00',
        restaurant = null,
        address = null,
        reservationMade = false,
        reservedSlots = [],
        totalSeats = 6,
        attendees = [],
        declines = [],
        createdAt = new Date().toISOString()
    }) {
        this.id = id || this.generateId();
        this.date = date;
        this.time = time;
        this.restaurant = restaurant;
        this.address = address;
        this.reservationMade = reservationMade;
        this.reservedSlots = Array.isArray(reservedSlots) ? reservedSlots : [];
        this.totalSeats = parseInt(totalSeats) || 6;
        this.attendees = Array.isArray(attendees) ? attendees : [];
        this.declines = Array.isArray(declines) ? declines : [];
        this.createdAt = createdAt;
    }

    /**
     * Generate a unique ID for the dinner
     */
    generateId() {
        return 'dinner_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
    }

    /**
     * Get the full datetime for this dinner
     */
    getDateTime() {
        return new Date(`${this.date}T${this.time}`);
    }

    /**
     * Check if this dinner has occurred (past the start time)
     */
    hasOccurred() {
        return this.getDateTime() < new Date();
    }

    /**
     * Get the week start date (Monday) for this dinner
     */
    getWeekStart() {
        const dinnerDate = new Date(this.date);
        const dayOfWeek = dinnerDate.getDay();
        const mondayOffset = dayOfWeek === 0 ? -6 : 1 - dayOfWeek; // Handle Sunday as day 0
        const monday = new Date(dinnerDate);
        monday.setDate(dinnerDate.getDate() + mondayOffset);
        return monday.toISOString().split('T')[0]; // Return YYYY-MM-DD format
    }

    /**
     * Get number of open slots (total seats minus reserved slots)
     */
    getOpenSlots() {
        return Math.max(0, this.totalSeats - this.reservedSlots.length);
    }

    /**
     * Get number of confirmed attendees
     */
    getConfirmedCount() {
        return this.attendees.length + this.reservedSlots.filter(name => 
            name && !this.declines.includes(name)
        ).length;
    }

    /**
     * Get available open slots (excluding reserved slots that declined)
     */
    getAvailableOpenSlots() {
        const declinedReservedSlots = this.reservedSlots.filter(name => 
            this.declines.includes(name)
        ).length;
        return this.getOpenSlots() + declinedReservedSlots - this.attendees.length;
    }

    /**
     * Check if dinner is fully booked
     */
    isFullyBooked() {
        return this.getAvailableOpenSlots() <= 0;
    }

    /**
     * Validate dinner data
     */
    validate() {
        const errors = [];

        if (!this.date) {
            errors.push('Date is required');
        }

        if (!this.time) {
            errors.push('Time is required');
        }

        if (this.totalSeats < 1) {
            errors.push('Total seats must be at least 1');
        }

        if (this.reservedSlots.length > this.totalSeats) {
            errors.push('Reserved slots cannot exceed total seats');
        }

        // Check if date is valid
        if (this.date && isNaN(Date.parse(this.date))) {
            errors.push('Invalid date format');
        }

        return {
            isValid: errors.length === 0,
            errors
        };
    }

    /**
     * Convert to plain object for storage
     */
    toJSON() {
        return {
            id: this.id,
            date: this.date,
            time: this.time,
            restaurant: this.restaurant,
            address: this.address,
            reservationMade: this.reservationMade,
            reservedSlots: this.reservedSlots,
            totalSeats: this.totalSeats,
            attendees: this.attendees,
            declines: this.declines,
            createdAt: this.createdAt
        };
    }

    /**
     * Create Dinner instance from stored data
     */
    static fromJSON(data) {
        return new Dinner(data);
    }
}

/**
 * Data Storage Helper Functions
 * Handles localStorage operations for dinner data
 */
class DinnerStorage {
    static STORAGE_KEY = 'restaurant_club_dinners';

    /**
     * Get all dinners from localStorage
     */
    static getAllDinners() {
        try {
            const data = localStorage.getItem(this.STORAGE_KEY);
            if (!data) return [];
            
            const parsed = JSON.parse(data);
            return parsed.map(dinnerData => Dinner.fromJSON(dinnerData));
        } catch (error) {
            console.error('Error loading dinners from storage:', error);
            return [];
        }
    }

    /**
     * Save all dinners to localStorage
     */
    static saveDinners(dinners) {
        try {
            const data = dinners.map(dinner => dinner.toJSON());
            localStorage.setItem(this.STORAGE_KEY, JSON.stringify(data));
            return true;
        } catch (error) {
            console.error('Error saving dinners to storage:', error);
            return false;
        }
    }

    /**
     * Add a new dinner
     */
    static addDinner(dinner) {
        const dinners = this.getAllDinners();
        dinners.push(dinner);
        return this.saveDinners(dinners);
    }

    /**
     * Update an existing dinner
     */
    static updateDinner(updatedDinner) {
        const dinners = this.getAllDinners();
        const index = dinners.findIndex(dinner => dinner.id === updatedDinner.id);
        
        if (index !== -1) {
            dinners[index] = updatedDinner;
            return this.saveDinners(dinners);
        }
        
        return false;
    }

    /**
     * Delete a dinner
     */
    static deleteDinner(dinnerId) {
        const dinners = this.getAllDinners();
        const filteredDinners = dinners.filter(dinner => dinner.id !== dinnerId);
        return this.saveDinners(filteredDinners);
    }

    /**
     * Get dinner by ID
     */
    static getDinnerById(id) {
        const dinners = this.getAllDinners();
        return dinners.find(dinner => dinner.id === id) || null;
    }

    /**
     * Check if a dinner exists for the given week
     */
    static getDinnerForWeek(weekStartDate) {
        const dinners = this.getAllDinners();
        return dinners.find(dinner => dinner.getWeekStart() === weekStartDate) || null;
    }

    /**
     * Get upcoming dinners (future dates only)
     */
    static getUpcomingDinners() {
        const dinners = this.getAllDinners();
        const now = new Date();
        
        return dinners
            .filter(dinner => dinner.getDateTime() >= now)
            .sort((a, b) => a.getDateTime() - b.getDateTime());
    }
}

/**
 * Restaurant Club Members
 * Predefined list of club members for reserved slots
 */
class ClubMembers {
    static MEMBERS = [
        'Gerard',
        'Nicholas', 
        'Levi',
        'Steven',
        'Bernardo'
    ];

    /**
     * Get all club members
     */
    static getAllMembers() {
        return [...this.MEMBERS];
    }

    /**
     * Add a new member (for future expansion)
     */
    static addMember(name) {
        if (name && !this.MEMBERS.includes(name)) {
            this.MEMBERS.push(name);
            return true;
        }
        return false;
    }
}

/**
 * Utility Functions
 */
class DateUtils {
    /**
     * Get next Monday's date in YYYY-MM-DD format
     */
    static getNextMonday() {
        const today = new Date();
        const daysUntilMonday = (8 - today.getDay()) % 7 || 7;
        const nextMonday = new Date(today);
        nextMonday.setDate(today.getDate() + daysUntilMonday);
        return nextMonday.toISOString().split('T')[0];
    }

    /**
     * Format date for display (fixes timezone issues)
     */
    static formatDisplayDate(dateString) {
        // Parse date in local timezone to avoid UTC conversion issues
        const [year, month, day] = dateString.split('-');
        const date = new Date(parseInt(year), parseInt(month) - 1, parseInt(day));
        const options = { 
            weekday: 'long', 
            year: 'numeric', 
            month: 'long', 
            day: 'numeric' 
        };
        return date.toLocaleDateString('en-US', options);
    }

    /**
     * Format time for display (convert 24hr to 12hr)
     */
    static formatDisplayTime(timeString) {
        const [hours, minutes] = timeString.split(':');
        const hour = parseInt(hours);
        const ampm = hour >= 12 ? 'PM' : 'AM';
        const displayHour = hour === 0 ? 12 : hour > 12 ? hour - 12 : hour;
        return `${displayHour}:${minutes} ${ampm}`;
    }
}

// Make classes available globally
window.Dinner = Dinner;
window.DinnerStorage = DinnerStorage;
window.DateUtils = DateUtils;
window.ClubMembers = ClubMembers; 