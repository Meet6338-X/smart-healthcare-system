-- ============================================
-- Smart Healthcare Management System
-- DML Script: Insert Sample Data
-- Oracle RDBMS
-- ============================================

-- ============================================
-- Insert Departments
-- ============================================

INSERT INTO DEPARTMENTS (dept_id, dept_name, description, location)
VALUES (dept_seq.NEXTVAL, 'Cardiology', 'Heart and cardiovascular care', 'Building A, Floor 2');

INSERT INTO DEPARTMENTS (dept_id, dept_name, description, location)
VALUES (dept_seq.NEXTVAL, 'Orthopedics', 'Bone and joint treatment', 'Building B, Floor 1');

INSERT INTO DEPARTMENTS (dept_id, dept_name, description, location)
VALUES (dept_seq.NEXTVAL, 'Neurology', 'Brain and nervous system care', 'Building A, Floor 3');

INSERT INTO DEPARTMENTS (dept_id, dept_name, description, location)
VALUES (dept_seq.NEXTVAL, 'Pediatrics', 'Child healthcare', 'Building C, Floor 1');

INSERT INTO DEPARTMENTS (dept_id, dept_name, description, location)
VALUES (dept_seq.NEXTVAL, 'Dermatology', 'Skin care and treatment', 'Building B, Floor 2');

INSERT INTO DEPARTMENTS (dept_id, dept_name, description, location)
VALUES (dept_seq.NEXTVAL, 'General Medicine', 'Primary healthcare', 'Building A, Floor 1');

-- ============================================
-- Insert Users (Admin, Doctors, Patients)
-- ============================================

-- Admin User
INSERT INTO USERS (user_id, username, password_hash, email, role, status)
VALUES (user_seq.NEXTVAL, 'admin1', 'hash_admin123', 'admin@hospital.com', 'ADMIN', 'ACTIVE');

-- Doctor Users
INSERT INTO USERS (user_id, username, password_hash, email, role, status)
VALUES (user_seq.NEXTVAL, 'dr_sharma', 'hash_doc001', 'sharma@hospital.com', 'DOCTOR', 'ACTIVE');

INSERT INTO USERS (user_id, username, password_hash, email, role, status)
VALUES (user_seq.NEXTVAL, 'dr_patel', 'hash_doc002', 'patel@hospital.com', 'DOCTOR', 'ACTIVE');

INSERT INTO USERS (user_id, username, password_hash, email, role, status)
VALUES (user_seq.NEXTVAL, 'dr_gupta', 'hash_doc003', 'gupta@hospital.com', 'DOCTOR', 'ACTIVE');

INSERT INTO USERS (user_id, username, password_hash, email, role, status)
VALUES (user_seq.NEXTVAL, 'dr_reddy', 'hash_doc004', 'reddy@hospital.com', 'DOCTOR', 'ACTIVE');

INSERT INTO USERS (user_id, username, password_hash, email, role, status)
VALUES (user_seq.NEXTVAL, 'dr_khan', 'hash_doc005', 'khan@hospital.com', 'DOCTOR', 'ACTIVE');

-- Patient Users
INSERT INTO USERS (user_id, username, password_hash, email, role, status)
VALUES (user_seq.NEXTVAL, 'patient_raj', 'hash_pat001', 'raj@email.com', 'PATIENT', 'ACTIVE');

INSERT INTO USERS (user_id, username, password_hash, email, role, status)
VALUES (user_seq.NEXTVAL, 'patient_priya', 'hash_pat002', 'priya@email.com', 'PATIENT', 'ACTIVE');

INSERT INTO USERS (user_id, username, password_hash, email, role, status)
VALUES (user_seq.NEXTVAL, 'patient_amit', 'hash_pat003', 'amit@email.com', 'PATIENT', 'ACTIVE');

INSERT INTO USERS (user_id, username, password_hash, email, role, status)
VALUES (user_seq.NEXTVAL, 'patient_sneha', 'hash_pat004', 'sneha@email.com', 'PATIENT', 'ACTIVE');

INSERT INTO USERS (user_id, username, password_hash, email, role, status)
VALUES (user_seq.NEXTVAL, 'patient_vikram', 'hash_pat005', 'vikram@email.com', 'PATIENT', 'ACTIVE');

-- ============================================
-- Insert Doctors
-- ============================================

INSERT INTO DOCTORS (doctor_id, user_id, dept_id, first_name, last_name, 
    specialization, license_number, phone, experience_years, consultation_fee, available)
VALUES (doctor_seq.NEXTVAL, 2, 1, 'Amit', 'Sharma', 'Cardiologist', 
    'MCI-12345', '9876543210', 15, 800.00, 'Y');

INSERT INTO DOCTORS (doctor_id, user_id, dept_id, first_name, last_name,
    specialization, license_number, phone, experience_years, consultation_fee, available)
VALUES (doctor_seq.NEXTVAL, 3, 2, 'Neha', 'Patel', 'Orthopedic Surgeon',
    'MCI-67890', '9876543211', 10, 600.00, 'Y');

INSERT INTO DOCTORS (doctor_id, user_id, dept_id, first_name, last_name,
    specialization, license_number, phone, experience_years, consultation_fee, available)
VALUES (doctor_seq.NEXTVAL, 4, 3, 'Rahul', 'Gupta', 'Neurologist',
    'MCI-11111', '9876543212', 8, 750.00, 'Y');

INSERT INTO DOCTORS (doctor_id, user_id, dept_id, first_name, last_name,
    specialization, license_number, phone, experience_years, consultation_fee, available)
VALUES (doctor_seq.NEXTVAL, 5, 4, 'Sunita', 'Reddy', 'Pediatrician',
    'MCI-22222', '9876543213', 12, 500.00, 'Y');

INSERT INTO DOCTORS (doctor_id, user_id, dept_id, first_name, last_name,
    specialization, license_number, phone, experience_years, consultation_fee, available)
VALUES (doctor_seq.NEXTVAL, 6, 6, 'Imran', 'Khan', 'General Physician',
    'MCI-33333', '9876543214', 5, 400.00, 'Y');

-- ============================================
-- Insert Patients
-- ============================================

INSERT INTO PATIENTS (patient_id, user_id, first_name, last_name, date_of_birth,
    gender, phone, address, city, blood_group, emergency_contact, registered_date)
VALUES (patient_seq.NEXTVAL, 7, 'Raj', 'Kumar', TO_DATE('1990-05-15', 'YYYY-MM-DD'),
    'Male', '9123456789', '123 Main Street, Andheri', 'Mumbai', 'A+', '9123456780', SYSDATE);

INSERT INTO PATIENTS (patient_id, user_id, first_name, last_name, date_of_birth,
    gender, phone, address, city, blood_group, emergency_contact, registered_date)
VALUES (patient_seq.NEXTVAL, 8, 'Priya', 'Singh', TO_DATE('1985-08-22', 'YYYY-MM-DD'),
    'Female', '9123456788', '456 Park Avenue, Connaught Place', 'Delhi', 'B+', '9123456781', SYSDATE);

INSERT INTO PATIENTS (patient_id, user_id, first_name, last_name, date_of_birth,
    gender, phone, address, city, blood_group, emergency_contact, registered_date)
VALUES (patient_seq.NEXTVAL, 9, 'Amit', 'Verma', TO_DATE('1995-12-10', 'YYYY-MM-DD'),
    'Male', '9123456787', '789 Lake View, Koramangala', 'Bangalore', 'O+', '9123456782', SYSDATE);

INSERT INTO PATIENTS (patient_id, user_id, first_name, last_name, date_of_birth,
    gender, phone, address, city, blood_group, emergency_contact, registered_date)
VALUES (patient_seq.NEXTVAL, 10, 'Sneha', 'Joshi', TO_DATE('1988-03-25', 'YYYY-MM-DD'),
    'Female', '9123456786', '101 Tech Park, Baner', 'Pune', 'AB-', '9123456783', SYSDATE);

INSERT INTO PATIENTS (patient_id, user_id, first_name, last_name, date_of_birth,
    gender, phone, address, city, blood_group, emergency_contact, registered_date)
VALUES (patient_seq.NEXTVAL, 11, 'Vikram', 'Malhotra', TO_DATE('1978-11-08', 'YYYY-MM-DD'),
    'Male', '9123456785', '202 Business Bay, Sector 5', 'Hyderabad', 'O-', '9123456784', SYSDATE);

-- ============================================
-- Insert Appointments
-- ============================================

-- Scheduled appointments
INSERT INTO APPOINTMENTS (appointment_id, patient_id, doctor_id, appointment_date,
    appointment_time, status, reason, created_at)
VALUES (appointment_seq.NEXTVAL, 1, 1, SYSDATE + 2, '10:00 AM', 'SCHEDULED',
    'Chest pain and shortness of breath', SYSDATE);

INSERT INTO APPOINTMENTS (appointment_id, patient_id, doctor_id, appointment_date,
    appointment_time, status, reason, created_at)
VALUES (appointment_seq.NEXTVAL, 3, 2, SYSDATE + 3, '11:30 AM', 'SCHEDULED',
    'Back pain for 3 weeks', SYSDATE);

INSERT INTO APPOINTMENTS (appointment_id, patient_id, doctor_id, appointment_date,
    appointment_time, status, reason, created_at)
VALUES (appointment_seq.NEXTVAL, 4, 3, SYSDATE + 1, '09:00 AM', 'SCHEDULED',
    'Frequent headaches and dizziness', SYSDATE);

-- Completed appointments
INSERT INTO APPOINTMENTS (appointment_id, patient_id, doctor_id, appointment_date,
    appointment_time, status, reason, created_at)
VALUES (appointment_seq.NEXTVAL, 2, 2, SYSDATE - 7, '02:00 PM', 'COMPLETED',
    'Knee pain after fall', SYSDATE - 10);

INSERT INTO APPOINTMENTS (appointment_id, patient_id, doctor_id, appointment_date,
    appointment_time, status, reason, created_at)
VALUES (appointment_seq.NEXTVAL, 5, 5, SYSDATE - 3, '10:30 AM', 'COMPLETED',
    'Fever and cold', SYSDATE - 5);

-- Cancelled appointment
INSERT INTO APPOINTMENTS (appointment_id, patient_id, doctor_id, appointment_date,
    appointment_time, status, reason, created_at)
VALUES (appointment_seq.NEXTVAL, 1, 4, SYSDATE - 1, '03:00 PM', 'CANCELLED',
    'Child vaccination', SYSDATE - 2);

-- ============================================
-- Insert Medical Records (for completed appointments)
-- ============================================

INSERT INTO MEDICAL_RECORDS (record_id, appointment_id, patient_id, doctor_id,
    diagnosis, symptoms, notes, record_date)
VALUES (record_seq.NEXTVAL, 4, 2, 2, 'Mild knee sprain - Grade 1',
    'Pain in right knee, mild swelling, tenderness',
    'Patient fell while playing football. X-ray shows no fracture. Rest and physiotherapy recommended.',
    SYSDATE - 7);

INSERT INTO MEDICAL_RECORDS (record_id, appointment_id, patient_id, doctor_id,
    diagnosis, symptoms, notes, record_date)
VALUES (record_seq.NEXTVAL, 5, 5, 5, 'Viral fever with upper respiratory infection',
    'Fever 101°F, running nose, sore throat, body ache',
    'Common viral infection. Prescribed antipyretics and rest. Follow up if symptoms persist beyond 3 days.',
    SYSDATE - 3);

-- ============================================
-- Insert Prescriptions
-- ============================================

-- Prescriptions for record 1 (knee sprain)
INSERT INTO PRESCRIPTIONS (prescription_id, record_id, medicine_name, dosage,
    frequency, duration_days, instructions)
VALUES (prescription_seq.NEXTVAL, 1, 'Ibuprofen', '400mg', 'Twice daily', 7, 'Take after food');

INSERT INTO PRESCRIPTIONS (prescription_id, record_id, medicine_name, dosage,
    frequency, duration_days, instructions)
VALUES (prescription_seq.NEXTVAL, 1, 'Muscle Relaxant (Thiocolchicoside)', '4mg', 
    'Once at night', 5, 'Take before bed');

INSERT INTO PRESCRIPTIONS (prescription_id, record_id, medicine_name, dosage,
    frequency, duration_days, instructions)
VALUES (prescription_seq.NEXTVAL, 1, 'Ice Pack Application', 'Apply for 15 mins', 
    '3-4 times daily', 7, 'Wrap in cloth before applying');

-- Prescriptions for record 2 (viral fever)
INSERT INTO PRESCRIPTIONS (prescription_id, record_id, medicine_name, dosage,
    frequency, duration_days, instructions)
VALUES (prescription_seq.NEXTVAL, 2, 'Paracetamol', '500mg', 'Every 6 hours if fever', 5, 
    'Take after food, maximum 4 tablets per day');

INSERT INTO PRESCRIPTIONS (prescription_id, record_id, medicine_name, dosage,
    frequency, duration_days, instructions)
VALUES (prescription_seq.NEXTVAL, 2, 'Cetirizine', '10mg', 'Once daily', 5, 
    'Take at night for cold symptoms');

INSERT INTO PRESCRIPTIONS (prescription_id, record_id, medicine_name, dosage,
    frequency, duration_days, instructions)
VALUES (prescription_seq.NEXTVAL, 2, 'Steam Inhalation', '10-15 minutes', 'Twice daily', 5, 
    'Add eucalyptus oil if available');

-- ============================================
-- Insert Bills (for completed appointments)
-- ============================================

INSERT INTO BILLS (bill_id, appointment_id, patient_id, consultation_fee,
    medicine_fee, lab_fee, total_amount, discount, final_amount, bill_date, status)
VALUES (bill_seq.NEXTVAL, 4, 2, 600.00, 250.00, 0.00, 850.00, 0.00, 850.00, SYSDATE - 7, 'PAID');

INSERT INTO BILLS (bill_id, appointment_id, patient_id, consultation_fee,
    medicine_fee, lab_fee, total_amount, discount, final_amount, bill_date, status)
VALUES (bill_seq.NEXTVAL, 5, 5, 400.00, 150.00, 0.00, 550.00, 50.00, 500.00, SYSDATE - 3, 'PAID');

-- ============================================
-- Insert Payments
-- ============================================

INSERT INTO PAYMENTS (payment_id, bill_id, amount_paid, payment_date, payment_method, transaction_ref)
VALUES (payment_seq.NEXTVAL, 1, 850.00, SYSDATE - 7, 'CARD', 'TXN-CARD-001');

INSERT INTO PAYMENTS (payment_id, bill_id, amount_paid, payment_date, payment_method, transaction_ref)
VALUES (payment_seq.NEXTVAL, 2, 500.00, SYSDATE - 3, 'UPI', 'TXN-UPI-001');

-- ============================================
-- Commit all changes
-- ============================================

COMMIT;

-- ============================================
-- Verification Queries
-- ============================================

SELECT 'DEPARTMENTS' AS table_name, COUNT(*) AS record_count FROM DEPARTMENTS
UNION ALL
SELECT 'USERS', COUNT(*) FROM USERS
UNION ALL
SELECT 'DOCTORS', COUNT(*) FROM DOCTORS
UNION ALL
SELECT 'PATIENTS', COUNT(*) FROM PATIENTS
UNION ALL
SELECT 'APPOINTMENTS', COUNT(*) FROM APPOINTMENTS
UNION ALL
SELECT 'MEDICAL_RECORDS', COUNT(*) FROM MEDICAL_RECORDS
UNION ALL
SELECT 'PRESCRIPTIONS', COUNT(*) FROM PRESCRIPTIONS
UNION ALL
SELECT 'BILLS', COUNT(*) FROM BILLS
UNION ALL
SELECT 'PAYMENTS', COUNT(*) FROM PAYMENTS;

-- ============================================
-- End of DML Script
-- ============================================
