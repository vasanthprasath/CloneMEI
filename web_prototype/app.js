// ==========================================
// STATE MANAGEMENT & DATA
// ==========================================
const DEFAULT_REQUESTS = [
  {
    id: 'REQ87291',
    requestType: 'Symposium',
    fromDate: '2026-05-26',
    toDate: '2026-05-27',
    timeOut: '08:00 AM',
    timeIn: '06:00 PM',
    createdDate: '24-05-2026 09:30:00 AM',
    reason: 'Attending national level technical symposium at IIT Madras.',
    status: 'approved'
  },
  {
    id: 'REQ99482',
    requestType: 'Holiday',
    fromDate: '2026-06-07',
    toDate: '2026-06-10',
    timeOut: '04:00 PM',
    timeIn: '08:00 AM',
    createdDate: '04-06-2026 11:20:00 AM',
    reason: 'Going home for Diwali celebration with family.',
    status: 'pending'
  },
  {
    id: 'REQ62810',
    requestType: 'Leave',
    fromDate: '2026-05-15',
    toDate: '2026-05-15',
    timeOut: '09:00 AM',
    timeIn: '05:00 PM',
    createdDate: '14-05-2026 02:15:00 PM',
    reason: 'Urgent dental checkup at clinic.',
    status: 'rejected'
  }
];

const savedRequests = localStorage.getItem('mei_hostel_requests');
const initialRequests = savedRequests ? JSON.parse(savedRequests) : DEFAULT_REQUESTS;

const savedName = localStorage.getItem('mei_hostel_student_name');
const initialName = savedName || 'Abishek S';

const appState = {
  currentScreen: 'dashboard',
  studentInfo: {
    name: initialName,
    registerNumber: '21CSR012',
    department: 'Computer Science & Engineering',
    year: 'III Year',
    hostelBlock: 'CV Raman Block (C-Block)',
    roomNumber: '304',
    email: 'abishek.s@meicollege.edu',
    phone: '+91 98765 43210',
    password: 'password123'
  },
  requests: initialRequests,

  foodChoices: {}, // key: YYYY-MM-DD, value: { breakfast: 'veg', lunch: 'veg', dinner: 'veg' }
  selectedFoodDate: null,

  parcels: [
    {
      id: 'PRC001',
      trackingNumber: 'TRACK987654321',
      courierService: 'Amazon Delivery',
      receivedDate: '04/06/2026 04:30 PM',
      status: 'received'
    },
    {
      id: 'PRC002',
      trackingNumber: 'TRACK554433221',
      courierService: 'BlueDart Express',
      receivedDate: '02/06/2026 11:15 AM',
      status: 'delivered'
    }
  ],

  emergencies: []
};

// ==========================================
// DOM ELEMENTS REFERENCE
// ==========================================
const DOM = {
  drawerOverlay: document.getElementById('drawer-overlay'),
  menuBtn: document.getElementById('menu-btn'),
  backBtn: document.getElementById('back-btn'),
  searchBtn: document.getElementById('search-btn'),
  screenTitle: document.getElementById('screen-title'),
  menuItems: document.querySelectorAll('.menu-item'),
  screens: document.querySelectorAll('.app-screen'),
  
  // Dashboard counters (removed from UI)
  dashApprovedCount: document.getElementById('dash-approved-count'),
  dashPendingCount: document.getElementById('dash-pending-count'),
  
  // Request List Screen
  requestListContainer: document.getElementById('request-list-container'),
  fabCreateRequest: document.getElementById('fab-create-request'),
  createRequestModal: document.getElementById('create-request-modal'),
  closeModalBtn: document.getElementById('close-modal-btn'),
  createRequestForm: document.getElementById('create-request-form'),
  
  // Search bar
  searchBarContainer: document.getElementById('search-bar-container'),
  searchInput: document.getElementById('search-input'),
  closeSearchBtn: document.getElementById('close-search-btn'),
  
  // Emergency Screen
  emergencyForm: document.getElementById('emergency-form'),
  emergencyType: document.getElementById('emergency-type'),
  emergencyDesc: document.getElementById('emergency-desc'),
  emergencyContact: document.getElementById('emergency-contact'),
  uploadProofBtn: document.getElementById('upload-proof-btn'),
  proofFileName: document.getElementById('proof-file-name'),
  emergencyHistoryList: document.getElementById('emergency-history-list'),
  
  // Food Screen
  foodCalendarStrip: document.getElementById('food-calendar-strip'),
  mealOptionRows: document.querySelectorAll('.meal-options-row'),
  
  // Parcel Screen
  smsNotificationToggle: document.getElementById('sms-notification-toggle'),
  simulateParcelBtn: document.getElementById('simulate-parcel-btn'),
  parcelHistoryList: document.getElementById('parcel-history-list'),
  
  // Change Password Screen
  changePasswordForm: document.getElementById('change-password-form'),
  passToggleBtns: document.querySelectorAll('.pass-toggle-btn'),
  
  // Toast
  toastNotification: document.getElementById('toast-notification'),
  toastMessage: document.getElementById('toast-message'),
  
  logoutBtns: document.querySelectorAll('.logout-btn')
};

// ==========================================
// SCREEN UTILITIES & NAVIGATION FLOW
// ==========================================
function changeScreen(screenId) {
  // Toggle screens
  DOM.screens.forEach(screen => {
    screen.classList.remove('active');
    if (screen.id === `screen-${screenId}`) {
      screen.classList.add('active');
    }
  });

  // Toggle active menu items
  DOM.menuItems.forEach(item => {
    item.classList.remove('active');
    if (item.getAttribute('data-screen') === screenId) {
      item.classList.add('active');
    }
  });

  appState.currentScreen = screenId;

  // Format screen title
  let title = screenId.split('-').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ');
  if (screenId === 'dashboard') title = 'Dashboard';
  if (screenId === 'request-list') title = 'Requests';
  DOM.screenTitle.innerText = title;

  // Handle header action buttons visibility
  if (screenId === 'dashboard') {
    DOM.menuBtn.classList.remove('hidden');
    DOM.backBtn.classList.add('hidden');
    DOM.searchBtn.classList.add('hidden');
  } else {
    DOM.menuBtn.classList.add('hidden');
    DOM.backBtn.classList.remove('hidden');
    
    if (screenId === 'request-list') {
      DOM.searchBtn.classList.remove('hidden');
    } else {
      DOM.searchBtn.classList.add('hidden');
    }
  }

  // Auto close search bar when transitioning screen
  hideSearchBar();

  // Populate view specifics
  if (screenId === 'request-list') {
    renderRequestList(appState.requests);
  } else if (screenId === 'emergency') {
    renderEmergencyHistory();
  } else if (screenId === 'food') {
    initFoodCalendar();
  } else if (screenId === 'parcel') {
    renderParcelHistory();
  }
}

// Side drawer controls
DOM.menuBtn.addEventListener('click', () => {
  DOM.drawerOverlay.classList.add('active');
});

DOM.drawerOverlay.addEventListener('click', (e) => {
  if (e.target === DOM.drawerOverlay) {
    DOM.drawerOverlay.classList.remove('active');
  }
});

DOM.backBtn.addEventListener('click', () => {
  changeScreen('dashboard');
});

// Click sidebar menu items
DOM.menuItems.forEach(item => {
  item.addEventListener('click', () => {
    const screenId = item.getAttribute('data-screen');
    if (screenId) {
      changeScreen(screenId);
      DOM.drawerOverlay.classList.remove('active');
    }
  });
});

// Connect dashboard quick info stats to navigate
document.querySelectorAll('.stat-card[data-screen-link]').forEach(card => {
  card.addEventListener('click', () => {
    const link = card.getAttribute('data-screen-link');
    changeScreen(link);
  });
});

// ==========================================
// SEARCH LOGIC
// ==========================================
DOM.searchBtn.addEventListener('click', () => {
  DOM.searchBarContainer.classList.remove('hidden');
  DOM.searchInput.focus();
});

DOM.closeSearchBtn.addEventListener('click', hideSearchBar);

function hideSearchBar() {
  DOM.searchBarContainer.classList.add('hidden');
  DOM.searchInput.value = '';
  if (appState.currentScreen === 'request-list') {
    renderRequestList(appState.requests);
  }
}

DOM.searchInput.addEventListener('input', (e) => {
  const query = e.target.value.toLowerCase().trim();
  const filtered = appState.requests.filter(req => 
    req.requestType.toLowerCase().includes(query) || 
    req.reason.toLowerCase().includes(query)
  );
  renderRequestList(filtered);
});

// ==========================================
// TOAST NOTIFICATIONS
// ==========================================
function showToast(message) {
  DOM.toastMessage.innerText = message;
  DOM.toastNotification.classList.add('active');
  setTimeout(() => {
    DOM.toastNotification.classList.remove('active');
  }, 3000);
}

// ==========================================
// SCREEN 3 & 4: REQUESTS & MODAL DIALOGS
// ==========================================
function renderRequestList(data) {
  DOM.requestListContainer.innerHTML = '';
  
  if (data.length === 0) {
    DOM.requestListContainer.innerHTML = `
      <div class="empty-state">
        <span class="material-icons-round empty-icon">assignment_late</span>
        <h4>No requests found</h4>
        <p>Tap + to create a new permission request</p>
      </div>
    `;
    return;
  }

  data.forEach(req => {
    // Parse date locally (avoids UTC midnight → previous day issue)
    const parseLocalDate = (str) => {
      if (!str) return new Date();
      if (str.includes('-') && str.length === 10 && str[2] === '-') {
        const [d,m,y] = str.split('-');
        return new Date(+y, +m - 1, +d);
      }
      const [y,m,d] = str.split('-');
      return new Date(+y, +m - 1, +d);
    };

    const fromDateObj = parseLocalDate(req.fromDate);
    const toDateObj   = parseLocalDate(req.toDate);

    // DD-MM-YYYY format
    const pad     = (n) => n.toString().padStart(2, '0');
    const fmtDate = (d) => `${pad(d.getDate())}-${pad(d.getMonth()+1)}-${d.getFullYear()}`;
    const fromStr = fmtDate(fromDateObj);
    const toStr   = fmtDate(toDateObj);

    const statusLabel = req.status.charAt(0).toUpperCase() + req.status.slice(1);

    const card = document.createElement('div');
    card.className = 'request-card';
    card.innerHTML = `
      <div class="rc-status-curve"></div>

      <div class="rc-row">
        <span class="rc-from-to-label">From :</span>
        <span class="material-icons-round rc-field-icon">calendar_today</span>
        <span class="rc-field-bold">${fromStr}</span>
        <span class="rc-divider-pipe">|</span>
        <span class="material-icons-round rc-field-icon">schedule</span>
        <span class="rc-field-bold">${req.timeOut}</span>
      </div>

      <div class="rc-row">
        <span class="rc-from-to-label">To :</span>
        <span class="material-icons-round rc-field-icon">calendar_today</span>
        <span class="rc-field-bold">${toStr}</span>
        <span class="rc-divider-pipe">|</span>
        <span class="material-icons-round rc-field-icon">schedule</span>
        <span class="rc-field-bold">${req.timeIn}</span>
      </div>

      <div class="rc-row">
        <span class="material-icons-round rc-field-icon">schedule</span>
        <span class="rc-field-gray">${req.createdDate}</span>
      </div>

      <div class="rc-row">
        <span class="material-icons-round rc-field-icon">person</span>
        <span class="rc-field-normal">${req.requestType}</span>
      </div>

      <div class="rc-row">
        <span class="material-icons-round rc-field-icon">sms</span>
        <span class="rc-field-ash">${req.reason}</span>
      </div>

      <div class="rc-row">
        <span class="material-icons-round rc-field-icon">sms</span>
        <span class="rc-field-status">${statusLabel}</span>
      </div>
    `;
    DOM.requestListContainer.appendChild(card);
  });
}

// Modal open/close
DOM.fabCreateRequest.addEventListener('click', () => {
  DOM.createRequestModal.classList.add('active');
});

DOM.closeModalBtn.addEventListener('click', () => {
  DOM.createRequestModal.classList.remove('active');
});

DOM.createRequestModal.addEventListener('click', (e) => {
  if (e.target === DOM.createRequestModal) {
    DOM.createRequestModal.classList.remove('active');
  }
});

DOM.createRequestForm.addEventListener('submit', (e) => {
  e.preventDefault();

  const type   = document.getElementById('req-type').value;
  const reason = document.getElementById('req-reason').value.trim();

  const fromDate = picker.fromDateVal  || '';
  const toDate   = picker.toDateVal    || '';
  const timeOut  = picker.fromTimeStr  || '';
  const timeIn   = picker.toTimeStr    || '';

  if (!fromDate || !toDate || !timeOut || !timeIn) {
    showToast('Please select dates and times using the calendar button.');
    return;
  }

  const padZero = (v) => v.toString().padStart(2, '0');
  const now = new Date();
  const createdDateFormatted = `${padZero(now.getDate())}-${padZero(now.getMonth()+1)}-${now.getFullYear()} ${padZero(now.getHours()%12||12)}:${padZero(now.getMinutes())}:${padZero(now.getSeconds())} ${now.getHours()>=12?'PM':'AM'}`;

  const newRequest = {
    id: 'REQ' + Math.floor(10000 + Math.random() * 90000),
    requestType: type,
    fromDate,
    toDate,
    timeOut,
    timeIn,
    createdDate: createdDateFormatted,
    reason,
    status: 'approved'
  };

  appState.requests.unshift(newRequest);
  localStorage.setItem('mei_hostel_requests', JSON.stringify(appState.requests));

  // Reset display spans
  ['from-date-display','from-time-display','to-date-display','to-time-display'].forEach(id => {
    const el = document.getElementById(id);
    if (el) { el.textContent = id.includes('from-date')?'From':id.includes('from-time')?'Time Out':id.includes('to-date')?'To':'Time In'; el.className='modal-dt-display modal-dt-placeholder'; }
  });
  picker.fromDateVal = picker.toDateVal = picker.fromTimeStr = picker.toTimeStr = null;

  DOM.createRequestForm.reset();
  DOM.createRequestModal.classList.remove('active');
  updateDashboardCounts();
  showToast('Request submitted successfully!');
  changeScreen('request-list');
});

// Update dashboard counters
function updateDashboardCounts() {
  const approved = appState.requests.filter(r => r.status === 'approved').length;
  const pending = appState.requests.filter(r => r.status === 'pending').length;
  
  if (DOM.dashApprovedCount) DOM.dashApprovedCount.innerText = approved;
  if (DOM.dashPendingCount) DOM.dashPendingCount.innerText = pending;
}

// ==========================================
// SCREEN 7: EMERGENCY REQUEST
// ==========================================
let simulatedFileName = null;

DOM.uploadProofBtn.addEventListener('click', () => {
  simulatedFileName = `medical_proof_${Date.now().toString().slice(-4)}.pdf`;
  DOM.proofFileName.innerText = `Uploaded: ${simulatedFileName}`;
  DOM.proofFileName.classList.remove('hidden');
  showToast('Proof document attached!');
});

DOM.emergencyForm.addEventListener('submit', (e) => {
  e.preventDefault();
  
  const type = DOM.emergencyType.value;
  const desc = DOM.emergencyDesc.value;
  const contact = DOM.emergencyContact.value;

  const now = new Date();
  const dateStr = now.toLocaleDateString('en-US', { month: 'short', day: '2-digit', year: 'numeric' }) + ' - ' + now.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' });

  const emergencyItem = {
    id: 'EMG' + Date.now().toString().slice(-6),
    type: type,
    description: desc,
    contact: contact,
    proof: simulatedFileName,
    date: dateStr,
    status: 'Submitted'
  };

  appState.emergencies.unshift(emergencyItem);
  DOM.emergencyForm.reset();
  DOM.proofFileName.classList.add('hidden');
  simulatedFileName = null;
  
  renderEmergencyHistory();
  showToast('Emergency Alert Dispatched!');
});

function renderEmergencyHistory() {
  DOM.emergencyHistoryList.innerHTML = '';
  
  if (appState.emergencies.length === 0) {
    DOM.emergencyHistoryList.innerHTML = `
      <p style="text-align:center; color:var(--text-secondary); font-size:12px; margin-top:10px;">
        No emergency requests submitted.
      </p>
    `;
    return;
  }

  appState.emergencies.forEach(item => {
    const div = document.createElement('div');
    div.className = 'emergency-history-item';
    div.innerHTML = `
      <div class="emergency-history-header">
        <span class="emergency-history-type">${item.type}</span>
        <span class="status-badge rejected">${item.status.toUpperCase()}</span>
      </div>
      <p class="emergency-history-desc">${item.description}</p>
      <div class="emergency-history-footer">
        <span>Contact: ${item.contact}</span>
        <span>${item.date}</span>
      </div>
    `;
    DOM.emergencyHistoryList.appendChild(div);
  });
}

// ==========================================
// SCREEN 8: FOOD CHOICE CALENDAR STRIP
// ==========================================
function initFoodCalendar() {
  DOM.foodCalendarStrip.innerHTML = '';
  const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  
  // Create next 5 days
  for (let i = 0; i < 5; i++) {
    const d = new Date();
    d.setDate(d.getDate() + i);
    const dayName = weekdays[d.getDay()];
    const dateNum = d.getDate();
    const key = d.toISOString().split('T')[0];

    // Seed state if not set
    if (!appState.foodChoices[key]) {
      appState.foodChoices[key] = { breakfast: 'veg', lunch: 'veg', dinner: 'veg' };
    }

    if (i === 0 && !appState.selectedFoodDate) {
      appState.selectedFoodDate = key;
    }

    const btn = document.createElement('div');
    btn.className = `food-date-btn ${appState.selectedFoodDate === key ? 'active' : ''}`;
    btn.setAttribute('data-date-key', key);
    btn.innerHTML = `
      <span>${dayName.toUpperCase()}</span>
      <h4>${dateNum}</h4>
    `;
    
    btn.addEventListener('click', () => {
      document.querySelectorAll('.food-date-btn').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      appState.selectedFoodDate = key;
      loadFoodPreferences(key);
    });

    DOM.foodCalendarStrip.appendChild(btn);
  }

  loadFoodPreferences(appState.selectedFoodDate);
}

function loadFoodPreferences(dateKey) {
  const choices = appState.foodChoices[dateKey];
  
  DOM.mealOptionRows.forEach(row => {
    const meal = row.getAttribute('data-meal');
    const selectedType = choices[meal];
    
    const buttons = row.querySelectorAll('.meal-opt-btn');
    buttons.forEach(btn => {
      btn.classList.remove('active');
      if (btn.getAttribute('data-type') === selectedType) {
        btn.classList.add('active');
      }
    });
  });
}

DOM.mealOptionRows.forEach(row => {
  const meal = row.getAttribute('data-meal');
  const buttons = row.querySelectorAll('.meal-opt-btn');
  
  buttons.forEach(btn => {
    btn.addEventListener('click', () => {
      const type = btn.getAttribute('data-type');
      const dateKey = appState.selectedFoodDate;
      
      // Update state
      appState.foodChoices[dateKey][meal] = type;
      
      // Reload view row
      row.querySelectorAll('.meal-opt-btn').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      showToast(`${meal.charAt(0).toUpperCase() + meal.slice(1)} selection updated!`);
    });
  });
});

// ==========================================
// SCREEN 9: PARCEL TRACKING
// ==========================================
DOM.simulateParcelBtn.addEventListener('click', () => {
  const trackId = 'TRACK' + Math.floor(100000000 + Math.random() * 900000000);
  const couriers = ['FedEx Express', 'Amazon Prime', 'DTDC Courier', 'Delhivery Express', 'SpeedPost India'];
  const courier = couriers[Math.floor(Math.random() * couriers.length)];
  
  const now = new Date();
  const dateStr = now.toLocaleDateString('en-US', { month: 'short', day: '2-digit', year: 'numeric' }) + ' ' + now.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' });

  const newParcel = {
    id: 'PRC' + Date.now().toString().slice(-4),
    trackingNumber: trackId,
    courierService: courier,
    receivedDate: dateStr,
    status: 'received'
  };

  appState.parcels.unshift(newParcel);
  renderParcelHistory();
  showToast('New parcel logged in guard portal!');
});

function renderParcelHistory() {
  DOM.parcelHistoryList.innerHTML = '';
  
  if (appState.parcels.length === 0) {
    DOM.parcelHistoryList.innerHTML = `
      <p style="text-align:center; color:var(--text-secondary); font-size:12px; margin-top:10px;">No parcels recorded.</p>
    `;
    return;
  }

  appState.parcels.forEach(p => {
    const div = document.createElement('div');
    div.className = 'parcel-history-item';
    
    let statusClass = 'pickup';
    let statusText = 'AWAITING PICKUP';
    if (p.status === 'delivered') {
      statusClass = 'delivered';
      statusText = 'DELIVERED';
    }

    div.innerHTML = `
      <div class="parcel-history-header">
        <span class="courier-title">${p.courierService}</span>
        <span class="parcel-status-chip ${statusClass}">${statusText}</span>
      </div>
      <div class="parcel-track-id">Track ID: ${p.trackingNumber}</div>
      <div class="request-card-divider"></div>
      <div class="emergency-history-footer">
        <span>Recipient: ${appState.studentInfo.name}</span>
        <span>${p.receivedDate}</span>
      </div>
    `;
    
    // Tap to simulate guard checkout
    if (p.status === 'received') {
      div.style.cursor = 'pointer';
      div.addEventListener('click', () => {
        p.status = 'delivered';
        renderParcelHistory();
        showToast('Parcel delivery confirmed!');
      });
    }

    DOM.parcelHistoryList.appendChild(div);
  });
}

// ==========================================
// SCREEN 10: CHANGE PASSWORD
// ==========================================
DOM.passToggleBtns.forEach(btn => {
  btn.addEventListener('click', () => {
    const input = btn.previousElementSibling;
    const icon = btn.querySelector('.material-icons-round');
    
    if (input.type === 'password') {
      input.type = 'text';
      icon.innerText = 'visibility';
    } else {
      input.type = 'password';
      icon.innerText = 'visibility_off';
    }
  });
});

DOM.changePasswordForm.addEventListener('submit', (e) => {
  e.preventDefault();
  
  const current = document.getElementById('current-password').value;
  const newPass = document.getElementById('new-password').value;
  const confirmPass = document.getElementById('confirm-password').value;

  if (current !== appState.studentInfo.password) {
    showToast('Incorrect current password!');
    return;
  }

  if (newPass.length < 6) {
    showToast('New password too short!');
    return;
  }

  if (newPass !== confirmPass) {
    showToast('Confirm password does not match!');
    return;
  }

  appState.studentInfo.password = newPass;
  DOM.changePasswordForm.reset();
  showToast('Password updated successfully!');
  changeScreen('dashboard');
});

// ==========================================
// LOGOUT BUTTON HANDLER
// ==========================================
DOM.logoutBtns.forEach(btn => {
  btn.addEventListener('click', () => {
    showToast('Logging out...');
    setTimeout(() => {
      location.reload();
    }, 1000);
  });
});

// String prototype pad helper for older browser mockups
String.prototype.padLeft = function (length, character) {
  return this.padStart(length, character);
};

// ============================================
// CUSTOM DARK DATE + CLOCK PICKER
// ============================================
const picker = {
  slot: 'from',           // 'from' or 'to'
  selYear: 0, selMonth: 0, selDay: 0,
  selHour: 8, selMin: 0, selAmPm: 'AM',
  mode: 'hours',          // 'hours' | 'minutes'

  // Elements
  datePicker:  document.getElementById('custom-date-picker'),
  timePicker:  document.getElementById('custom-time-picker'),
  yearLabel:   document.getElementById('cpicker-year-label'),
  selLabel:    document.getElementById('cpicker-selected-label'),
  monthLabel:  document.getElementById('cpicker-month-label'),
  daysGrid:    document.getElementById('cpicker-days-grid'),
  clockFace:   document.getElementById('cpicker-clock-face'),
  clockHand:   document.getElementById('cpicker-clock-hand'),
  hrDisplay:   document.getElementById('cpicker-hr-display'),
  minDisplay:  document.getElementById('cpicker-min-display'),
  amBtn:       document.getElementById('cpicker-am-btn'),
  pmBtn:       document.getElementById('cpicker-pm-btn'),

  MONTHS: ['January','February','March','April','May','June',
           'July','August','September','October','November','December'],
  DAYS:   ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'],
  MONTHS_SHORT: ['Jan','Feb','Mar','Apr','May','Jun',
                 'Jul','Aug','Sep','Oct','Nov','Dec'],

  openDate(slot) {
    this.slot = slot;
    const now = new Date();
    this.selYear = now.getFullYear();
    this.selMonth = now.getMonth();
    this.selDay = now.getDate();
    this.renderCalendar();
    this.datePicker.classList.add('active');
  },

  renderCalendar() {
    const y = this.selYear, m = this.selMonth, d = this.selDay;
    this.yearLabel.textContent = y;
    const dayName = this.DAYS[new Date(y, m, d).getDay()];
    this.selLabel.textContent = `${dayName}, ${d} ${this.MONTHS_SHORT[m]}`;
    this.monthLabel.textContent = `${this.MONTHS[m]} ${y}`;

    const firstDay = new Date(y, m, 1).getDay();
    const daysInMonth = new Date(y, m + 1, 0).getDate();
    const today = new Date();

    this.daysGrid.innerHTML = '';

    // Empty cells before first day
    for (let i = 0; i < firstDay; i++) {
      const prev = new Date(y, m, 0).getDate() - firstDay + i + 1;
      const el = document.createElement('div');
      el.className = 'cpicker-day empty';
      el.textContent = prev;
      this.daysGrid.appendChild(el);
    }

    for (let day = 1; day <= daysInMonth; day++) {
      const el = document.createElement('div');
      el.className = 'cpicker-day';
      el.textContent = day;

      if (day === d) el.classList.add('selected');
      else if (day === today.getDate() && m === today.getMonth() && y === today.getFullYear()) {
        el.classList.add('today');
      }

      el.addEventListener('click', () => {
        this.selDay = day;
        this.renderCalendar();
      });
      this.daysGrid.appendChild(el);
    }
  },

  confirmDate() {
    const mm = String(this.selMonth + 1).padStart(2, '0');
    const dd = String(this.selDay).padStart(2, '0');
    const isoDate = `${this.selYear}-${mm}-${dd}`;
    const dispDate = `${dd}-${mm}-${this.selYear}`;

    // Store in picker state
    if (this.slot === 'from') this.fromDateVal = isoDate;
    else                       this.toDateVal   = isoDate;

    // Update display span in the modal
    const dateDisplay = document.getElementById(this.slot === 'from' ? 'from-date-display' : 'to-date-display');
    if (dateDisplay) {
      dateDisplay.textContent = dispDate;
      dateDisplay.classList.remove('modal-dt-placeholder');
    }

    this.datePicker.classList.remove('active');
    this.openTime();
  },

  openTime() {
    this.mode = 'hours';
    this.hrDisplay.classList.add('active-part');
    this.minDisplay.classList.remove('active-part');
    this.updateTimeDisplay();
    this.renderClock();
    this.timePicker.classList.add('active');
  },

  updateTimeDisplay() {
    this.hrDisplay.textContent = String(this.selHour).padStart(2, '0');
    this.minDisplay.textContent = String(this.selMin).padStart(2, '0');
    this.amBtn.classList.toggle('active-ampm', this.selAmPm === 'AM');
    this.pmBtn.classList.toggle('active-ampm', this.selAmPm === 'PM');
  },

  renderClock() {
    // Remove old numbers
    this.clockFace.querySelectorAll('.cpicker-clock-num').forEach(n => n.remove());

    const R = 88; // radius from center
    const cx = 120, cy = 120; // center of 240px circle

    const count = this.mode === 'hours' ? 12 : 12;
    const nums = this.mode === 'hours'
      ? [12,1,2,3,4,5,6,7,8,9,10,11]
      : [0,5,10,15,20,25,30,35,40,45,50,55];

    nums.forEach((num, i) => {
      const angle = (i * 30 - 90) * Math.PI / 180;
      const x = cx + R * Math.cos(angle);
      const y = cy + R * Math.sin(angle);

      const el = document.createElement('div');
      el.className = 'cpicker-clock-num';
      el.textContent = this.mode === 'hours' ? num : String(num).padStart(2, '0');
      el.style.left = x + 'px';
      el.style.top = y + 'px';

      const isSelected = this.mode === 'hours'
        ? num === this.selHour
        : num === this.selMin;
      if (isSelected) el.classList.add('selected-num');

      el.addEventListener('click', () => {
        if (this.mode === 'hours') {
          this.selHour = num;
          this.mode = 'minutes';
          this.hrDisplay.classList.remove('active-part');
          this.minDisplay.classList.add('active-part');
        } else {
          this.selMin = num;
        }
        this.updateTimeDisplay();
        this.renderClock();
        this.rotateHand();
      });
      this.clockFace.appendChild(el);
    });

    this.rotateHand();
  },

  rotateHand() {
    let deg;
    if (this.mode === 'hours') {
      const h = this.selHour % 12;
      deg = h * 30 - 90;
    } else {
      deg = this.selMin * 6 - 90;
    }
    this.clockHand.style.transform = `rotate(${deg + 90}deg)`;
  },

  confirmTime() {
    const h = String(this.selHour).padStart(2, '0');
    const m = String(this.selMin).padStart(2, '0');
    const timeStr = `${h}:${m} ${this.selAmPm}`;

    // Store in picker state
    if (this.slot === 'from') this.fromTimeStr = timeStr;
    else                       this.toTimeStr   = timeStr;

    // Update display span
    const disp = document.getElementById(this.slot === 'from' ? 'from-time-display' : 'to-time-display');
    if (disp) {
      disp.textContent = timeStr;
      disp.classList.remove('modal-dt-placeholder');
    }

    this.timePicker.classList.remove('active');
  }
};

// Wire up buttons
document.getElementById('cpicker-prev').addEventListener('click', () => {
  picker.selMonth--;
  if (picker.selMonth < 0) { picker.selMonth = 11; picker.selYear--; }
  picker.renderCalendar();
});
document.getElementById('cpicker-next').addEventListener('click', () => {
  picker.selMonth++;
  if (picker.selMonth > 11) { picker.selMonth = 0; picker.selYear++; }
  picker.renderCalendar();
});
document.getElementById('cpicker-date-cancel').addEventListener('click', () => {
  picker.datePicker.classList.remove('active');
});
document.getElementById('cpicker-date-ok').addEventListener('click', () => picker.confirmDate());

document.getElementById('cpicker-am-btn').addEventListener('click', () => {
  picker.selAmPm = 'AM'; picker.updateTimeDisplay();
});
document.getElementById('cpicker-pm-btn').addEventListener('click', () => {
  picker.selAmPm = 'PM'; picker.updateTimeDisplay();
});
document.getElementById('cpicker-hr-display').addEventListener('click', () => {
  picker.mode = 'hours';
  picker.hrDisplay.classList.add('active-part');
  picker.minDisplay.classList.remove('active-part');
  picker.renderClock();
});
document.getElementById('cpicker-min-display').addEventListener('click', () => {
  picker.mode = 'minutes';
  picker.minDisplay.classList.add('active-part');
  picker.hrDisplay.classList.remove('active-part');
  picker.renderClock();
});
document.getElementById('cpicker-time-cancel').addEventListener('click', () => {
  picker.timePicker.classList.remove('active');
});
document.getElementById('cpicker-time-ok').addEventListener('click', () => picker.confirmTime());

// Sync and update student name
const profileNameInput = document.getElementById('profile-name-input');
const profileNameDisplay = document.querySelector('.profile-name');
const profileAvatarDisplay = document.querySelector('.profile-avatar');
const dashStudentNameDisplay = document.querySelector('.student-name');

if (profileNameInput) {
  profileNameInput.addEventListener('input', (e) => {
    const newName = e.target.value;
    
    // Update name in profile card header dynamically
    if (profileNameDisplay) {
      profileNameDisplay.textContent = newName || 'Student Name';
    }
    
    // Update avatar initials dynamically
    if (profileAvatarDisplay) {
      const trimmed = newName.trim();
      if (!trimmed) {
        profileAvatarDisplay.textContent = '';
      } else {
        const parts = trimmed.split(' ').filter(p => p.length > 0);
        let initials = '';
        if (parts.length > 0) {
          initials += parts[0][0].toUpperCase();
          if (parts.length > 1) {
            initials += parts[parts.length - 1][0].toUpperCase();
          } else if (parts[0].length > 1) {
            initials += parts[0][1].toUpperCase();
          }
        }
        profileAvatarDisplay.textContent = initials;
      }
    }
  });
}

// Save profile changes to dashboard and localStorage on button click
const saveProfileBtn = document.getElementById('save-profile-btn');
if (saveProfileBtn && profileNameInput) {
  saveProfileBtn.addEventListener('click', () => {
    const finalName = profileNameInput.value.trim() || 'Student Name';
    
    // Save name to state and localStorage
    appState.studentInfo.name = finalName;
    localStorage.setItem('mei_hostel_student_name', finalName);
    
    // Update name on dashboard welcome card
    if (dashStudentNameDisplay) {
      dashStudentNameDisplay.textContent = finalName;
    }
    
    showToast('Profile updated successfully!');
  });
}

// Function to initialize UI with user's saved name
function initializeUserProfileName() {
  const name = appState.studentInfo.name;
  
  if (profileNameInput) {
    profileNameInput.value = name;
  }
  if (profileNameDisplay) {
    profileNameDisplay.textContent = name || 'Student Name';
  }
  if (dashStudentNameDisplay) {
    dashStudentNameDisplay.textContent = name || 'Student Name';
  }
  
  if (profileAvatarDisplay) {
    const trimmed = name.trim();
    if (!trimmed) {
      profileAvatarDisplay.textContent = '';
    } else {
      const parts = trimmed.split(' ').filter(p => p.length > 0);
      let initials = '';
      if (parts.length > 0) {
        initials += parts[0][0].toUpperCase();
        if (parts.length > 1) {
          initials += parts[parts.length - 1][0].toUpperCase();
        } else if (parts[0].length > 1) {
          initials += parts[0][1].toUpperCase();
        }
      }
      profileAvatarDisplay.textContent = initials;
    }
  }
}

// PUBLIC: called by the + buttons in the modal
function openDateThenTime(slot) {
  picker.openDate(slot);
}

// ==========================================
// INITIALIZATION
// ==========================================
initializeUserProfileName();
updateDashboardCounts();
changeScreen('dashboard');
