"""
Smart Healthcare Management System - Enhanced Version
Full-Featured Flask Backend with Role-Based Dashboards

Features:
- Patient Dashboard: Book appointments, view records, bills
- Doctor Dashboard: View patients, add diagnosis, prescriptions
- Admin Dashboard: Manage doctors, departments, reports
"""

import os
from datetime import datetime, timedelta
from functools import wraps
from flask import Flask, render_template, request, redirect, url_for, flash, session, jsonify

# ============================================
# Flask App Configuration
# ============================================

app = Flask(__name__)
app.secret_key = 'smart_healthcare_secret_key_2024'

# ============================================
# Mock Database (Replace with Oracle in production)
# ============================================

# Users Database
USERS = {
    1: {'username': 'admin1', 'password': 'admin123', 'role': 'ADMIN', 'name': 'System Admin', 'email': 'admin@hospital.com'},
    2: {'username': 'dr_sharma', 'password': 'doc123', 'role': 'DOCTOR', 'name': 'Dr. Amit Sharma', 'email': 'sharma@hospital.com', 'doctor_id': 1},
    3: {'username': 'dr_patel', 'password': 'doc123', 'role': 'DOCTOR', 'name': 'Dr. Neha Patel', 'email': 'patel@hospital.com', 'doctor_id': 2},
    4: {'username': 'dr_gupta', 'password': 'doc123', 'role': 'DOCTOR', 'name': 'Dr. Rahul Gupta', 'email': 'gupta@hospital.com', 'doctor_id': 3},
    5: {'username': 'patient_raj', 'password': 'pat123', 'role': 'PATIENT', 'name': 'Raj Kumar', 'email': 'raj@email.com', 'patient_id': 1},
    6: {'username': 'patient_priya', 'password': 'pat123', 'role': 'PATIENT', 'name': 'Priya Singh', 'email': 'priya@email.com', 'patient_id': 2},
    7: {'username': 'patient_amit', 'password': 'pat123', 'role': 'PATIENT', 'name': 'Amit Verma', 'email': 'amit@email.com', 'patient_id': 3},
}

# Departments
DEPARTMENTS = {
    1: {'name': 'Cardiology', 'description': 'Heart and cardiovascular care', 'location': 'Building A, Floor 2'},
    2: {'name': 'Orthopedics', 'description': 'Bone and joint treatment', 'location': 'Building B, Floor 1'},
    3: {'name': 'Neurology', 'description': 'Brain and nervous system', 'location': 'Building A, Floor 3'},
    4: {'name': 'Pediatrics', 'description': 'Child healthcare', 'location': 'Building C, Floor 1'},
    5: {'name': 'General Medicine', 'description': 'Primary healthcare', 'location': 'Building A, Floor 1'},
}

# Doctors
DOCTORS = {
    1: {'user_id': 2, 'name': 'Dr. Amit Sharma', 'specialization': 'Cardiologist', 'dept_id': 1, 'fee': 800, 'phone': '9876543210', 'experience': 15, 'available': True},
    2: {'user_id': 3, 'name': 'Dr. Neha Patel', 'specialization': 'Orthopedic Surgeon', 'dept_id': 2, 'fee': 600, 'phone': '9876543211', 'experience': 10, 'available': True},
    3: {'user_id': 4, 'name': 'Dr. Rahul Gupta', 'specialization': 'Neurologist', 'dept_id': 3, 'fee': 750, 'phone': '9876543212', 'experience': 8, 'available': True},
}

# Patients
PATIENTS = {
    1: {'user_id': 5, 'name': 'Raj Kumar', 'dob': '1990-05-15', 'gender': 'Male', 'phone': '9123456789', 'blood_group': 'A+', 'address': 'Mumbai'},
    2: {'user_id': 6, 'name': 'Priya Singh', 'dob': '1985-08-22', 'gender': 'Female', 'phone': '9123456788', 'blood_group': 'B+', 'address': 'Delhi'},
    3: {'user_id': 7, 'name': 'Amit Verma', 'dob': '1995-12-10', 'gender': 'Male', 'phone': '9123456787', 'blood_group': 'O+', 'address': 'Bangalore'},
}

# Appointments
APPOINTMENTS = {}
appointment_counter = 1

# Medical Records
MEDICAL_RECORDS = {}
record_counter = 1

# Prescriptions
PRESCRIPTIONS = {}
prescription_counter = 1

# Bills
BILLS = {}
bill_counter = 1

# Payments
PAYMENTS = {}
payment_counter = 1

# ============================================
# Helper Functions
# ============================================

def login_required(f):
    """Decorator to require login"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session:
            flash('Please login to access this page', 'error')
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function

def role_required(*roles):
    """Decorator to require specific role(s)"""
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            if 'user_id' not in session:
                flash('Please login to access this page', 'error')
                return redirect(url_for('login'))
            if session.get('role') not in roles:
                flash('You do not have permission to access this page', 'error')
                return redirect(url_for('dashboard'))
            return f(*args, **kwargs)
        return decorated_function
    return decorator

def get_dashboard_url():
    """Get appropriate dashboard based on role"""
    role = session.get('role')
    if role == 'ADMIN':
        return url_for('admin_dashboard')
    elif role == 'DOCTOR':
        return url_for('doctor_dashboard')
    else:
        return url_for('patient_dashboard')

# ============================================
# Routes - Public
# ============================================

@app.route('/')
def index():
    """Home page"""
    if 'user_id' in session:
        return redirect(get_dashboard_url())
    return render_template('index.html')

# ============================================
# Routes - Authentication
# ============================================

@app.route('/login', methods=['GET', 'POST'])
def login():
    """User login - redirects if already logged in"""
    # Fix: Redirect if already logged in
    if 'user_id' in session:
        flash('You are already logged in', 'info')
        return redirect(get_dashboard_url())
    
    if request.method == 'GET':
        return render_template('login.html')
    
    username = request.form.get('username', '').strip()
    password = request.form.get('password', '')
    
    # Find user
    user = None
    user_id = None
    for uid, u in USERS.items():
        if u['username'] == username and u['password'] == password:
            user = u
            user_id = uid
            break
    
    if user:
        session['user_id'] = user_id
        session['username'] = user['username']
        session['role'] = user['role']
        session['name'] = user['name']
        
        # Store role-specific ID
        if user['role'] == 'DOCTOR':
            session['doctor_id'] = user.get('doctor_id')
        elif user['role'] == 'PATIENT':
            session['patient_id'] = user.get('patient_id')
        
        flash(f'Welcome, {user["name"]}!', 'success')
        return redirect(get_dashboard_url())
    
    flash('Invalid username or password', 'error')
    return redirect(url_for('login'))

@app.route('/logout')
def logout():
    """User logout"""
    session.clear()
    flash('You have been logged out successfully', 'success')
    return redirect(url_for('index'))

@app.route('/register', methods=['GET', 'POST'])
def register():
    """Patient registration - redirects if already logged in"""
    global USERS, PATIENTS
    
    if 'user_id' in session:
        return redirect(get_dashboard_url())
    
    if request.method == 'GET':
        return render_template('register.html')
    
    # Get form data
    username = request.form.get('username', '').strip()
    password = request.form.get('password', '')
    email = request.form.get('email', '').strip()
    first_name = request.form.get('first_name', '').strip()
    last_name = request.form.get('last_name', '').strip()
    dob = request.form.get('dob', '')
    gender = request.form.get('gender', '')
    phone = request.form.get('phone', '').strip()
    blood_group = request.form.get('blood_group', '')
    address = request.form.get('address', '').strip()
    city = request.form.get('city', '').strip()
    
    # Check if username exists
    for u in USERS.values():
        if u['username'] == username:
            flash('Username already exists', 'error')
            return redirect(url_for('register'))
        if u['email'] == email:
            flash('Email already registered', 'error')
            return redirect(url_for('register'))
    
    # Create new user and patient
    new_user_id = max(USERS.keys()) + 1
    new_patient_id = max(PATIENTS.keys()) + 1
    
    USERS[new_user_id] = {
        'username': username,
        'password': password,
        'role': 'PATIENT',
        'name': f"{first_name} {last_name}",
        'email': email,
        'patient_id': new_patient_id
    }
    
    PATIENTS[new_patient_id] = {
        'user_id': new_user_id,
        'name': f"{first_name} {last_name}",
        'dob': dob,
        'gender': gender,
        'phone': phone,
        'blood_group': blood_group,
        'address': f"{address}, {city}"
    }
    
    flash('Registration successful! Please login.', 'success')
    return redirect(url_for('login'))

# ============================================
# Routes - Dashboard Redirect
# ============================================

@app.route('/dashboard')
@login_required
def dashboard():
    """Redirect to role-specific dashboard"""
    return redirect(get_dashboard_url())

# ============================================
# Routes - Patient Dashboard
# ============================================

@app.route('/patient/dashboard')
@role_required('PATIENT')
def patient_dashboard():
    """Patient dashboard - overview"""
    patient_id = session.get('patient_id')
    
    # Get patient's appointments
    my_appointments = []
    for apt_id, apt in APPOINTMENTS.items():
        if apt['patient_id'] == patient_id:
            doctor = DOCTORS.get(apt['doctor_id'], {})
            my_appointments.append({
                'id': apt_id,
                'doctor_name': doctor.get('name', 'Unknown'),
                'specialization': doctor.get('specialization', ''),
                'date': apt['date'],
                'time': apt['time'],
                'status': apt['status'],
                'reason': apt.get('reason', '')
            })
    
    # Sort by date
    my_appointments.sort(key=lambda x: x['date'], reverse=True)
    
    # Get upcoming and completed counts
    upcoming = [a for a in my_appointments if a['status'] == 'SCHEDULED']
    completed = [a for a in my_appointments if a['status'] == 'COMPLETED']
    
    # Get pending bills
    pending_amount = sum(
        b['amount'] for b in BILLS.values() 
        if b['patient_id'] == patient_id and b['status'] == 'PENDING'
    )
    
    # Get medical records count
    records_count = sum(1 for r in MEDICAL_RECORDS.values() if r['patient_id'] == patient_id)
    
    return render_template('patient/dashboard.html',
        appointments=my_appointments[:5],
        upcoming_count=len(upcoming),
        completed_count=len(completed),
        pending_amount=pending_amount,
        records_count=records_count
    )

@app.route('/patient/appointments')
@role_required('PATIENT')
def patient_appointments():
    """Patient - view all appointments"""
    patient_id = session.get('patient_id')
    
    appointments = []
    for apt_id, apt in APPOINTMENTS.items():
        if apt['patient_id'] == patient_id:
            doctor = DOCTORS.get(apt['doctor_id'], {})
            appointments.append({
                'id': apt_id,
                'doctor_name': doctor.get('name', 'Unknown'),
                'specialization': doctor.get('specialization', ''),
                'date': apt['date'],
                'time': apt['time'],
                'status': apt['status'],
                'reason': apt.get('reason', '')
            })
    
    appointments.sort(key=lambda x: x['date'], reverse=True)
    
    return render_template('patient/appointments.html', appointments=appointments)

@app.route('/patient/book-appointment', methods=['GET', 'POST'])
@role_required('PATIENT')
def book_appointment():
    """Patient - book new appointment"""
    if request.method == 'GET':
        today = datetime.now().strftime('%Y-%m-%d')
        return render_template('patient/book_appointment.html',
            departments=DEPARTMENTS,
            doctors=DOCTORS,
            today=today
        )
    
    global APPOINTMENTS, appointment_counter
    
    doctor_id = int(request.form.get('doctor_id'))
    apt_date = request.form.get('appointment_date')
    apt_time = request.form.get('appointment_time')
    reason = request.form.get('reason', '')
    
    # Check for conflicts
    for apt in APPOINTMENTS.values():
        if (apt['doctor_id'] == doctor_id and 
            apt['date'] == apt_date and 
            apt['time'] == apt_time and 
            apt['status'] != 'CANCELLED'):
            flash('This time slot is already booked. Please choose another.', 'error')
            return redirect(url_for('book_appointment'))
    
    # Create appointment
    APPOINTMENTS[appointment_counter] = {
        'patient_id': session.get('patient_id'),
        'doctor_id': doctor_id,
        'date': apt_date,
        'time': apt_time,
        'status': 'SCHEDULED',
        'reason': reason,
        'created_at': datetime.now().isoformat()
    }
    
    doctor = DOCTORS.get(doctor_id, {})
    flash(f'Appointment booked successfully with {doctor.get("name")} on {apt_date} at {apt_time}!', 'success')
    appointment_counter += 1
    
    return redirect(url_for('patient_appointments'))

@app.route('/patient/cancel-appointment/<int:apt_id>', methods=['POST'])
@role_required('PATIENT')
def cancel_appointment(apt_id):
    """Patient - cancel appointment"""
    if apt_id in APPOINTMENTS:
        apt = APPOINTMENTS[apt_id]
        if apt['patient_id'] == session.get('patient_id'):
            if apt['status'] == 'SCHEDULED':
                apt['status'] = 'CANCELLED'
                flash('Appointment cancelled successfully', 'success')
            else:
                flash('Only scheduled appointments can be cancelled', 'error')
        else:
            flash('Unauthorized', 'error')
    return redirect(url_for('patient_appointments'))

@app.route('/patient/records')
@role_required('PATIENT')
def patient_records():
    """Patient - view medical records"""
    patient_id = session.get('patient_id')
    
    records = []
    for rec_id, rec in MEDICAL_RECORDS.items():
        if rec['patient_id'] == patient_id:
            doctor = DOCTORS.get(rec['doctor_id'], {})
            # Get prescriptions for this record
            presc = [p for p in PRESCRIPTIONS.values() if p['record_id'] == rec_id]
            records.append({
                'id': rec_id,
                'date': rec['date'],
                'doctor_name': doctor.get('name', 'Unknown'),
                'diagnosis': rec['diagnosis'],
                'symptoms': rec.get('symptoms', ''),
                'notes': rec.get('notes', ''),
                'prescriptions': presc
            })
    
    records.sort(key=lambda x: x['date'], reverse=True)
    return render_template('patient/records.html', records=records)

@app.route('/patient/bills')
@role_required('PATIENT')
def patient_bills():
    """Patient - view bills"""
    patient_id = session.get('patient_id')
    
    bills = []
    for bill_id, bill in BILLS.items():
        if bill['patient_id'] == patient_id:
            bills.append({
                'id': bill_id,
                'date': bill['date'],
                'amount': bill['amount'],
                'status': bill['status'],
                'description': bill.get('description', 'Consultation')
            })
    
    bills.sort(key=lambda x: x['date'], reverse=True)
    return render_template('patient/bills.html', bills=bills)

# ============================================
# Routes - Doctor Dashboard
# ============================================

@app.route('/doctor/dashboard')
@role_required('DOCTOR')
def doctor_dashboard():
    """Doctor dashboard - today's appointments"""
    doctor_id = session.get('doctor_id')
    today = datetime.now().strftime('%Y-%m-%d')
    
    # Get today's appointments
    todays_appointments = []
    all_appointments = []
    
    for apt_id, apt in APPOINTMENTS.items():
        if apt['doctor_id'] == doctor_id:
            patient = PATIENTS.get(apt['patient_id'], {})
            apt_data = {
                'id': apt_id,
                'patient_name': patient.get('name', 'Unknown'),
                'patient_phone': patient.get('phone', ''),
                'patient_gender': patient.get('gender', ''),
                'patient_blood': patient.get('blood_group', ''),
                'date': apt['date'],
                'time': apt['time'],
                'status': apt['status'],
                'reason': apt.get('reason', '')
            }
            all_appointments.append(apt_data)
            if apt['date'] == today and apt['status'] in ['SCHEDULED', 'IN_PROGRESS']:
                todays_appointments.append(apt_data)
    
    # Sort by time
    todays_appointments.sort(key=lambda x: x['time'])
    
    # Stats
    total_patients = len(set(a['patient_name'] for a in all_appointments))
    completed_today = sum(1 for apt in APPOINTMENTS.values() 
                         if apt['doctor_id'] == doctor_id and 
                         apt['date'] == today and 
                         apt['status'] == 'COMPLETED')
    pending_today = len(todays_appointments)
    
    return render_template('doctor/dashboard.html',
        appointments=todays_appointments,
        total_patients=total_patients,
        completed_today=completed_today,
        pending_today=pending_today,
        today=today
    )

@app.route('/doctor/appointments')
@role_required('DOCTOR')
def doctor_appointments():
    """Doctor - view all appointments"""
    doctor_id = session.get('doctor_id')
    
    appointments = []
    for apt_id, apt in APPOINTMENTS.items():
        if apt['doctor_id'] == doctor_id:
            patient = PATIENTS.get(apt['patient_id'], {})
            appointments.append({
                'id': apt_id,
                'patient_name': patient.get('name', 'Unknown'),
                'patient_phone': patient.get('phone', ''),
                'date': apt['date'],
                'time': apt['time'],
                'status': apt['status'],
                'reason': apt.get('reason', '')
            })
    
    appointments.sort(key=lambda x: x['date'], reverse=True)
    return render_template('doctor/appointments.html', appointments=appointments)

@app.route('/doctor/consultation/<int:apt_id>', methods=['GET', 'POST'])
@role_required('DOCTOR')
def doctor_consultation(apt_id):
    """Doctor - consultation form"""
    if apt_id not in APPOINTMENTS:
        flash('Appointment not found', 'error')
        return redirect(url_for('doctor_dashboard'))
    
    apt = APPOINTMENTS[apt_id]
    if apt['doctor_id'] != session.get('doctor_id'):
        flash('Unauthorized', 'error')
        return redirect(url_for('doctor_dashboard'))
    
    patient = PATIENTS.get(apt['patient_id'], {})
    
    if request.method == 'GET':
        # Mark as in progress
        apt['status'] = 'IN_PROGRESS'
        return render_template('doctor/consultation.html',
            appointment=apt,
            apt_id=apt_id,
            patient=patient
        )
    
    # Process consultation form
    global MEDICAL_RECORDS, PRESCRIPTIONS, BILLS, record_counter, prescription_counter, bill_counter
    
    diagnosis = request.form.get('diagnosis', '')
    symptoms = request.form.get('symptoms', '')
    notes = request.form.get('notes', '')
    
    # Create medical record
    MEDICAL_RECORDS[record_counter] = {
        'appointment_id': apt_id,
        'patient_id': apt['patient_id'],
        'doctor_id': session.get('doctor_id'),
        'date': datetime.now().strftime('%Y-%m-%d'),
        'diagnosis': diagnosis,
        'symptoms': symptoms,
        'notes': notes
    }
    current_record_id = record_counter
    record_counter += 1
    
    # Add prescriptions
    medicine_names = request.form.getlist('medicine_name[]')
    dosages = request.form.getlist('dosage[]')
    frequencies = request.form.getlist('frequency[]')
    durations = request.form.getlist('duration[]')
    
    for i in range(len(medicine_names)):
        if medicine_names[i].strip():
            PRESCRIPTIONS[prescription_counter] = {
                'record_id': current_record_id,
                'medicine': medicine_names[i],
                'dosage': dosages[i] if i < len(dosages) else '',
                'frequency': frequencies[i] if i < len(frequencies) else '',
                'duration': durations[i] if i < len(durations) else ''
            }
            prescription_counter += 1
    
    # Create bill
    doctor = DOCTORS.get(session.get('doctor_id'), {})
    BILLS[bill_counter] = {
        'appointment_id': apt_id,
        'patient_id': apt['patient_id'],
        'date': datetime.now().strftime('%Y-%m-%d'),
        'amount': doctor.get('fee', 500),
        'status': 'PENDING',
        'description': f"Consultation with {doctor.get('name', 'Doctor')}"
    }
    bill_counter += 1
    
    # Mark appointment as completed
    apt['status'] = 'COMPLETED'
    
    flash('Consultation completed! Medical record and bill generated.', 'success')
    return redirect(url_for('doctor_dashboard'))

# ============================================
# Routes - Admin Dashboard
# ============================================

@app.route('/admin/dashboard')
@role_required('ADMIN')
def admin_dashboard():
    """Admin dashboard - overview"""
    total_doctors = len(DOCTORS)
    total_patients = len(PATIENTS)
    total_appointments = len(APPOINTMENTS)
    
    # Revenue
    total_revenue = sum(b['amount'] for b in BILLS.values() if b['status'] == 'PAID')
    pending_revenue = sum(b['amount'] for b in BILLS.values() if b['status'] == 'PENDING')
    
    # Recent appointments
    recent_appointments = []
    for apt_id, apt in list(APPOINTMENTS.items())[-5:]:
        patient = PATIENTS.get(apt['patient_id'], {})
        doctor = DOCTORS.get(apt['doctor_id'], {})
        recent_appointments.append({
            'id': apt_id,
            'patient': patient.get('name', 'Unknown'),
            'doctor': doctor.get('name', 'Unknown'),
            'date': apt['date'],
            'status': apt['status']
        })
    
    return render_template('admin/dashboard.html',
        total_doctors=total_doctors,
        total_patients=total_patients,
        total_appointments=total_appointments,
        total_revenue=total_revenue,
        pending_revenue=pending_revenue,
        recent_appointments=recent_appointments,
        departments=DEPARTMENTS
    )

@app.route('/admin/doctors')
@role_required('ADMIN')
def admin_doctors():
    """Admin - manage doctors"""
    doctors_list = []
    for doc_id, doc in DOCTORS.items():
        dept = DEPARTMENTS.get(doc['dept_id'], {})
        doctors_list.append({
            'id': doc_id,
            'name': doc['name'],
            'specialization': doc['specialization'],
            'department': dept.get('name', 'Unknown'),
            'fee': doc['fee'],
            'phone': doc['phone'],
            'available': doc['available']
        })
    
    return render_template('admin/doctors.html', 
        doctors=doctors_list,
        departments=DEPARTMENTS
    )

@app.route('/admin/add-doctor', methods=['POST'])
@role_required('ADMIN')
def admin_add_doctor():
    """Admin - add new doctor"""
    global USERS, DOCTORS
    
    name = request.form.get('name', '').strip()
    email = request.form.get('email', '').strip()
    phone = request.form.get('phone', '').strip()
    specialization = request.form.get('specialization', '').strip()
    dept_id = int(request.form.get('dept_id', 1))
    fee = float(request.form.get('fee', 500))
    
    # Create username from name
    username = 'dr_' + name.lower().replace(' ', '_').replace('dr.', '').strip('_')
    
    # Check if exists
    for u in USERS.values():
        if u['email'] == email:
            flash('Email already exists', 'error')
            return redirect(url_for('admin_doctors'))
    
    # Create user and doctor
    new_user_id = max(USERS.keys()) + 1
    new_doctor_id = max(DOCTORS.keys()) + 1
    
    USERS[new_user_id] = {
        'username': username,
        'password': 'doc123',  # Default password
        'role': 'DOCTOR',
        'name': name,
        'email': email,
        'doctor_id': new_doctor_id
    }
    
    DOCTORS[new_doctor_id] = {
        'user_id': new_user_id,
        'name': name,
        'specialization': specialization,
        'dept_id': dept_id,
        'fee': fee,
        'phone': phone,
        'experience': 0,
        'available': True
    }
    
    flash(f'Doctor {name} added successfully! Username: {username}, Password: doc123', 'success')
    return redirect(url_for('admin_doctors'))

@app.route('/admin/toggle-doctor/<int:doc_id>')
@role_required('ADMIN')
def admin_toggle_doctor(doc_id):
    """Admin - toggle doctor availability"""
    if doc_id in DOCTORS:
        DOCTORS[doc_id]['available'] = not DOCTORS[doc_id]['available']
        status = 'available' if DOCTORS[doc_id]['available'] else 'unavailable'
        flash(f'Doctor marked as {status}', 'success')
    return redirect(url_for('admin_doctors'))

@app.route('/admin/departments')
@role_required('ADMIN')
def admin_departments():
    """Admin - manage departments"""
    dept_list = []
    for dept_id, dept in DEPARTMENTS.items():
        doctor_count = sum(1 for d in DOCTORS.values() if d['dept_id'] == dept_id)
        dept_list.append({
            'id': dept_id,
            'name': dept['name'],
            'description': dept['description'],
            'location': dept['location'],
            'doctor_count': doctor_count
        })
    return render_template('admin/departments.html', departments=dept_list)

@app.route('/admin/add-department', methods=['POST'])
@role_required('ADMIN')
def admin_add_department():
    """Admin - add new department"""
    global DEPARTMENTS
    
    name = request.form.get('name', '').strip()
    description = request.form.get('description', '').strip()
    location = request.form.get('location', '').strip()
    
    new_dept_id = max(DEPARTMENTS.keys()) + 1
    DEPARTMENTS[new_dept_id] = {
        'name': name,
        'description': description,
        'location': location
    }
    
    flash(f'Department {name} added successfully!', 'success')
    return redirect(url_for('admin_departments'))

# ============================================
# API Routes
# ============================================

@app.route('/api/doctors-by-department/<int:dept_id>')
def api_doctors_by_dept(dept_id):
    """Get doctors by department"""
    doctors = [
        {'id': doc_id, 'name': doc['name'], 'specialization': doc['specialization'], 'fee': doc['fee']}
        for doc_id, doc in DOCTORS.items()
        if doc['dept_id'] == dept_id and doc['available']
    ]
    return jsonify(doctors)

# ============================================
# Error Handlers
# ============================================

@app.errorhandler(404)
def not_found(e):
    return render_template('error.html', error='Page not found'), 404

@app.errorhandler(500)
def server_error(e):
    return render_template('error.html', error='Server error'), 500

# ============================================
# Main
# ============================================

if __name__ == '__main__':
    print("=" * 60)
    print("  Smart Healthcare Management System - Enhanced Version")
    print("=" * 60)
    print("  Server: http://localhost:5000")
    print("-" * 60)
    print("  Demo Credentials:")
    print("    Patient: patient_raj / pat123")
    print("    Doctor:  dr_sharma / doc123")
    print("    Admin:   admin1 / admin123")
    print("=" * 60)
    
    app.run(debug=True, host='0.0.0.0', port=5000)
