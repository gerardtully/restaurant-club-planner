/**
 * Restaurant Club Planner - Dinner Scheduler
 * Main application logic for creating and managing dinners
 */

class DinnerScheduler {
    constructor() {
        this.currentEditingId = null;
        this.form = document.getElementById('dinner-form');
        this.messageDiv = document.getElementById('form-message');
        this.dinnersList = document.getElementById('dinners-list');
        this.cancelBtn = document.getElementById('cancel-btn');

        this.initializeForm();
        this.bindEvents();
        this.loadAndDisplayDinners();
    }

    /**
     * Initialize form with default values
     */
    initializeForm() {
        // Set default date to next Monday
        const nextMondayDate = DateUtils.getNextMonday();
        document.getElementById('dinner-date').value = nextMondayDate;
    }

    /**
     * Bind event listeners
     */
    bindEvents() {
        this.form.addEventListener('submit', (e) => this.handleFormSubmit(e));
        this.cancelBtn.addEventListener('click', () => this.cancelEdit());
        
        // Date input change handler for week validation
        document.getElementById('dinner-date').addEventListener('change', (e) => {
            this.validateWeekAvailability(e.target.value);
        });
    }

    /**
     * Handle form submission
     */
    async handleFormSubmit(event) {
        event.preventDefault();
        
        const formData = new FormData(this.form);
        const dinnerData = this.extractFormData(formData);

        // Create or update dinner
        const dinner = new Dinner(dinnerData);
        const validation = dinner.validate();

        if (!validation.isValid) {
            this.showMessage(validation.errors.join(', '), 'error');
            return;
        }

        // Check for week conflicts (only for new dinners or when date changed)
        if (!this.currentEditingId || this.hasDateChanged(dinner)) {
            const weekConflict = this.checkWeekConflict(dinner);
            if (weekConflict) {
                this.showMessage(weekConflict, 'error');
                return;
            }
        }

        // Save dinner
        const success = this.currentEditingId ? 
            DinnerStorage.updateDinner(dinner) : 
            DinnerStorage.addDinner(dinner);

        if (success) {
            const action = this.currentEditingId ? 'updated' : 'created';
            this.showMessage(`Dinner ${action} successfully!`, 'success');
            this.resetForm();
            this.loadAndDisplayDinners();
        } else {
            this.showMessage('Error saving dinner. Please try again.', 'error');
        }
    }

    /**
     * Extract data from form
     */
    extractFormData(formData) {
        const reservedSlotsText = formData.get('reservedSlots');
        const reservedSlots = reservedSlotsText 
            ? reservedSlotsText.split(',').map(name => name.trim()).filter(name => name)
            : [];

        return {
            id: this.currentEditingId,
            date: formData.get('date'),
            time: formData.get('time'),
            restaurant: formData.get('restaurantName') || null,
            address: formData.get('restaurantAddress') || null,
            reservationMade: formData.get('reservationMade') === 'true',
            reservedSlots,
            openSlots: parseInt(formData.get('openSlots')) || 0
        };
    }

    /**
     * Check if there's already a dinner scheduled for the same week
     */
    checkWeekConflict(dinner) {
        const weekStart = dinner.getWeekStart();
        const existingDinner = DinnerStorage.getDinnerForWeek(weekStart);
        
        if (existingDinner && existingDinner.id !== dinner.id) {
            const conflictDate = DateUtils.formatDisplayDate(existingDinner.date);
            return `A dinner is already scheduled for this week on ${conflictDate}. Only one dinner per week is allowed.`;
        }
        
        return null;
    }

    /**
     * Check if date has changed during edit
     */
    hasDateChanged(dinner) {
        if (!this.currentEditingId) return false;
        
        const originalDinner = DinnerStorage.getDinnerById(this.currentEditingId);
        return originalDinner && originalDinner.date !== dinner.date;
    }

    /**
     * Validate week availability when date changes
     */
    validateWeekAvailability(selectedDate) {
        if (!selectedDate) return;

        const tempDinner = new Dinner({ 
            date: selectedDate, 
            time: '19:00',
            id: this.currentEditingId 
        });
        
        const conflict = this.checkWeekConflict(tempDinner);
        if (conflict) {
            this.showMessage(conflict, 'error');
        } else {
            this.hideMessage();
        }
    }

    /**
     * Load dinners and display them
     */
    loadAndDisplayDinners() {
        const upcomingDinners = DinnerStorage.getUpcomingDinners();
        this.displayDinners(upcomingDinners);
    }

    /**
     * Display dinners in the UI
     */
    displayDinners(dinners) {
        if (dinners.length === 0) {
            this.dinnersList.innerHTML = `
                <div class="empty-state">
                    <p>No dinners scheduled yet. Create one above! 👆</p>
                </div>
            `;
            return;
        }

        this.dinnersList.innerHTML = dinners.map(dinner => this.createDinnerCard(dinner)).join('');
        this.bindDinnerCardEvents();
    }

    /**
     * Create HTML for a dinner card
     */
    createDinnerCard(dinner) {
        const displayDate = DateUtils.formatDisplayDate(dinner.date);
        const displayTime = DateUtils.formatDisplayTime(dinner.time);
        const reservationStatus = dinner.reservationMade ? 'Yes' : 'No';
        const reservationClass = dinner.reservationMade ? 'reservation-status--yes' : 'reservation-status--no';

        const confirmedReserved = dinner.reservedSlots.filter(name => 
            name && !dinner.declines.includes(name)
        ).length;
        const totalConfirmed = dinner.getConfirmedCount();
        const availableSlots = dinner.getAvailableOpenSlots();

        return `
            <div class="dinner-card" data-dinner-id="${dinner.id}">
                <div class="dinner-card__header">
                    <div>
                        <div class="dinner-card__date">${displayDate}</div>
                        <div class="dinner-card__time">${displayTime}</div>
                    </div>
                    <div class="dinner-card__actions">
                        <button class="btn btn--edit" data-action="edit">Edit</button>
                        <button class="btn btn--danger" data-action="delete">Delete</button>
                    </div>
                </div>
                
                <div class="dinner-card__details">
                    ${dinner.restaurant ? `
                        <div class="dinner-card__restaurant">📍 ${dinner.restaurant}</div>
                    ` : ''}
                    
                    ${dinner.address ? `
                        <div class="dinner-card__address">${dinner.address}</div>
                    ` : ''}
                    
                    <div class="dinner-card__slots">
                        <span class="dinner-card__slot-info">
                            ${totalConfirmed} confirmed of ${dinner.getTotalSeats()} total seats
                        </span>
                        ${availableSlots > 0 ? `
                            <span class="dinner-card__slot-info">
                                ${availableSlots} slots available
                            </span>
                        ` : `
                            <span class="dinner-card__slot-info" style="background: #fee2e2; color: #991b1b;">
                                Fully Booked
                            </span>
                        `}
                    </div>
                    
                    <div class="dinner-card__reservation">
                        <span>Reservation:</span>
                        <span class="reservation-status ${reservationClass}">
                            ${reservationStatus}
                        </span>
                    </div>
                    
                    ${dinner.reservedSlots.length > 0 ? `
                        <div class="dinner-card__reserved">
                            <strong>Reserved for:</strong> ${dinner.reservedSlots.join(', ')}
                        </div>
                    ` : ''}
                </div>
            </div>
        `;
    }

    /**
     * Bind events for dinner card buttons
     */
    bindDinnerCardEvents() {
        const editButtons = document.querySelectorAll('[data-action="edit"]');
        const deleteButtons = document.querySelectorAll('[data-action="delete"]');

        editButtons.forEach(button => {
            button.addEventListener('click', (e) => {
                const dinnerId = e.target.closest('.dinner-card').dataset.dinnerId;
                this.editDinner(dinnerId);
            });
        });

        deleteButtons.forEach(button => {
            button.addEventListener('click', (e) => {
                const dinnerId = e.target.closest('.dinner-card').dataset.dinnerId;
                this.deleteDinner(dinnerId);
            });
        });
    }

    /**
     * Edit dinner - populate form with existing data
     */
    editDinner(dinnerId) {
        const dinner = DinnerStorage.getDinnerById(dinnerId);
        if (!dinner) {
            this.showMessage('Dinner not found', 'error');
            return;
        }

        this.currentEditingId = dinnerId;
        this.populateForm(dinner);
        this.showCancelButton();
        
        // Scroll to form
        document.querySelector('.dinner-form-section').scrollIntoView({ 
            behavior: 'smooth' 
        });
    }

    /**
     * Populate form with dinner data
     */
    populateForm(dinner) {
        document.getElementById('dinner-date').value = dinner.date;
        document.getElementById('dinner-time').value = dinner.time;
        document.getElementById('restaurant-name').value = dinner.restaurant || '';
        document.getElementById('restaurant-address').value = dinner.address || '';
        document.getElementById('reserved-slots').value = dinner.reservedSlots.join(', ');
        document.getElementById('open-slots').value = dinner.openSlots;
        
        // Set reservation radio button
        const reservationValue = dinner.reservationMade.toString();
        document.querySelector(`input[name="reservationMade"][value="${reservationValue}"]`).checked = true;
        
        // Update form button text
        document.querySelector('.btn--primary').textContent = 'Update Dinner';
        this.showMessage('Editing dinner - make changes and click Update', 'success');
    }

    /**
     * Delete dinner with confirmation
     */
    deleteDinner(dinnerId) {
        const dinner = DinnerStorage.getDinnerById(dinnerId);
        if (!dinner) return;

        const displayDate = DateUtils.formatDisplayDate(dinner.date);
        const confirmed = confirm(
            `Are you sure you want to delete the dinner scheduled for ${displayDate}?`
        );

        if (confirmed) {
            const success = DinnerStorage.deleteDinner(dinnerId);
            if (success) {
                this.showMessage('Dinner deleted successfully', 'success');
                this.loadAndDisplayDinners();
            } else {
                this.showMessage('Error deleting dinner', 'error');
            }
        }
    }

    /**
     * Cancel edit mode
     */
    cancelEdit() {
        this.resetForm();
        this.hideMessage();
    }

    /**
     * Reset form to initial state
     */
    resetForm() {
        this.form.reset();
        this.currentEditingId = null;
        this.initializeForm();
        this.hideCancelButton();
        document.querySelector('.btn--primary').textContent = 'Create Dinner';
    }

    /**
     * Show cancel button
     */
    showCancelButton() {
        this.cancelBtn.style.display = 'inline-block';
    }

    /**
     * Hide cancel button
     */
    hideCancelButton() {
        this.cancelBtn.style.display = 'none';
    }

    /**
     * Show message to user
     */
    showMessage(message, type = 'success') {
        this.messageDiv.textContent = message;
        this.messageDiv.className = `form-message form-message--${type}`;
        this.messageDiv.style.display = 'block';
        
        // Auto-hide success messages after 5 seconds
        if (type === 'success') {
            setTimeout(() => this.hideMessage(), 5000);
        }
    }

    /**
     * Hide message
     */
    hideMessage() {
        this.messageDiv.style.display = 'none';
    }
}

// Initialize the application when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    new DinnerScheduler();
}); 