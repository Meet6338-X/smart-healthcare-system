-- ============================================
-- Smart Healthcare Management System
-- Additional Dummy Data Script
-- Oracle RDBMS
-- ============================================

-- ============================================
-- Insert Additional Patient Users (6-10)
-- ============================================

INSERT INTO USERS (user_id, username, password_hash, email, role, status)
VALUES (user_seq.NEXTVAL, 'patient_arti', 'hash_pat006', 'arti@email.com', 'PATIENT', 'ACTIVE');

INSERT INTO USERS (user_id, username, password_hash, email, role, status)
VALUES (user_seq.NEXTVAL, 'patient_rahul', 'hash_pat007', 'rahul@email.com', 'PATIENT', 'ACTIVE');

INSERT INTO USERS (user_id, username, password_hash, email, role, status)
VALUES (user_seq.NEXTVAL, 'patient_meera', 'hash_pat008', 'meera@email.com', 'PATIENT', 'ACTIVE');

INSERT INTO USERS (user_id, username, password_hash, email, role, status)
VALUES (user_seq.NEXTVAL, 'patient_karan', 'hash_pat009', 'karan@email.com', 'PATIENT', 'ACTIVE');

INSERT INTO USERS (user_id, username, password_hash, email, role, status)
VALUES (user_seq.NEXTVAL, 'patient_anita', 'hash_pat010', 'anita@email.com', 'PATIENT', 'ACTIVE');

-- ============================================
-- Insert Additional Patients (6-10)
-- ============================================

INSERT INTO PATIENTS (patient_id, user_id, first_name, last_name, date_of_birth,
    gender, phone, address, city, blood_group, emergency_contact, registered_date)
VALUES (patient_seq.NEXTVAL, 12, 'Arti', 'Sharma', TO_DATE('1992-07-18', 'YYYY-MM-DD'),
    'Female', '9988776655', '301 Green Valley, Salt Lake', 'Kolkata', 'A-', '9988776600', SYSDATE);

INSERT INTO PATIENTS (patient_id, user_id, first_name, last_name, date_of_birth,
    gender, phone, address, city, blood_group, emergency_contact, registered_date)
VALUES (patient_seq.NEXTVAL, 13, 'Rahul', 'Mehta', TO_DATE('1983-09-05', 'YYYY-MM-DD'),
    'Male', '9988776654', '402 Sunset Boulevard, T Nagar', 'Chennai', 'B+', '9988776601', SYSDATE);

INSERT INTO PATIENTS (patient_id, user_id, first_name, last_name, date_of_birth,
    gender, phone, address, city, blood_group, emergency_contact, registered_date)
VALUES (patient_seq.NEXTVAL, 14, 'Meera', 'Iyer', TO_DATE('1998-01-30', 'YYYY-MM-DD'),
    'Female', '9988776653', '503 Olive Gardens, Adyar', 'Chennai', 'AB+', '9988776602', SYSDATE);

INSERT INTO PATIENTS (patient_id, user_id, first_name, last_name, date_of_birth,
    gender, phone, address, city, blood_group, emergency_contact, registered_date)
VALUES (patient_seq.NEXTVAL, 15, 'Karan', 'Singh', TO_DATE('1975-11-12', 'YYYY-MM-DD'),
    'Male', '9988776652', '604 Royal Enclave, Bodakdev', 'Ahmedabad', 'O+', '9988776603', SYSDATE);

INSERT INTO PATIENTS (patient_id, user_id, first_name, last_name, date_of_birth,
    gender, phone, address, city, blood_group, emergency_contact, registered_date)
VALUES (patient_seq.NEXTVAL, 16, 'Anita', 'Desai', TO_DATE('1988-04-22', 'YYYY-MM-DD'),
    'Female', '9988776651', '705 Hill View, Kharadi', 'Pune', 'A+', '9988776604', SYSDATE);

-- ============================================
-- Insert Additional Appointments (7-15)
-- ============================================

-- Scheduled appointments
INSERT INTO APPOINTMENTS (appointment_id, patient_id, doctor_id, appointment_date,
    appointment_time, status, reason, created_at)
VALUES (appointment_seq.NEXTVAL, 6, 1, SYSDATE + 1, '09:30 AM', 'SCHEDULED',
    'Heart palpitations and mild chest discomfort', SYSDATE);

INSERT INTO APPOINTMENTS (appointment_id, patient_id, doctor_id, appointment_date,
    appointment_time, status, reason, created_at)
VALUES (appointment_seq.NEXTVAL, 7, 2, SYSDATE + 2, '02:30 PM', 'SCHEDULED',
    'Shoulder pain after gym workout', SYSDATE);

INSERT INTO APPOINTMENTS (appointment_id, patient_id, doctor_id, appointment_date,
    appointment_time, status, reason, created_at)
VALUES (appointment_seq.NEXTVAL, 8, 3, SYSDATE + 3, '11:00 AM', 'SCHEDULED',
    'Migraine headaches for past 2 weeks', SYSDATE);

INSERT INTO APPOINTMENTS (appointment_id, patient_id, doctor_id, appointment_date,
    appointment_time, status, reason, created_at)
VALUES (appointment_seq.NEXTVAL, 9, 5, SYSDATE + 1, '04:00 PM', 'SCHEDULED',
    'Annual health checkup', SYSDATE);

INSERT INTO APPOINTMENTS (appointment_id, patient_id, doctor_id, appointment_date,
    appointment_time, status, reason, created_at)
VALUES (appointment_seq.NEXTVAL, 10, 4, SYSDATE + 4, '10:30 AM', 'SCHEDULED',
    'Skin rash and itching', SYSDATE);

-- Completed appointments
INSERT INTO APPOINTMENTS (appointment_id, patient_id, doctor_id, appointment_date,
    appointment_time, status, reason, created_at)
VALUES (appointment_seq.NEXTVAL, 6, 5, SYSDATE - 5, '03:00 PM', 'COMPLETED',
    'Seasonal flu and fever', SYSDATE - 7);

INSERT INTO APPOINTMENTS (appointment_id, patient_id, doctor_id, appointment_date,
    appointment_time, status, reason, created_at)
VALUES (appointment_seq.NEXTVAL, 7, 1, SYSDATE - 10, '11:30 AM', 'COMPLETED',
    'Routine cardiac checkup', SYSDATE - 12);

INSERT INTO APPOINTMENTS (appointment_id, patient_id, doctor_id, appointment_date,
    appointment_time, status, reason, created_at)
VALUES (appointment_seq.NEXTVAL, 8, 4, SYSDATE - 3, '02:00 PM', 'COMPLETED',
    'Chickenpox treatment', SYSDATE - 5);

INSERT INTO APPOINTMENTS (appointment_id, patient_id, doctor_id, appointment_date,
    appointment_time, status, reason, created_at)
VALUES (appointment_seq.NEXTVAL, 9, 2, SYSDATE - 8, '09:00 AM', 'COMPLETED',
    'Lower back pain', SYSDATE - 10);

-- Cancelled appointments
INSERT INTO APPOINTMENTS (appointment_id, patient_id, doctor_id, appointment_date,
    appointment_time, status, reason, created_at)
VALUES (appointment_seq.NEXTVAL, 10, 3, SYSDATE - 2, '03:30 PM', 'CANCELLED',
    'Numbness in hands', SYSDATE - 3);

-- ============================================
-- Insert Additional Medical Records (3-6)
-- ============================================

INSERT INTO MEDICAL_RECORDS (record_id, appointment_id, patient_id, doctor_id,
    diagnosis, symptoms, notes, record_date)
VALUES (record_seq.NEXTVAL, 6, 6, 5, 'Seasonal Influenza (Type A)',
    'Fever 102°F, chills, body ache, sore throat, cough',
    'Viral infection confirmed. Advised rest, hydration, and symptomatic treatment. Medical leave for 3 days.',
    SYSDATE - 5);

INSERT INTO MEDICAL_RECORDS (record_id, appointment_id, patient_id, doctor_id,
    diagnosis, symptoms, notes, record_date)
VALUES (record_seq.NEXTVAL, 7, 7, 1, 'Mild Hypertension - Stage 1',
    'Elevated blood pressure (145/95), occasional headaches',
    'ECG normal. Lifestyle modifications advised: low salt diet, regular exercise. Follow up in 1 month.',
    SYSDATE - 10);

INSERT INTO MEDICAL_RECORDS (record_id, appointment_id, patient_id, doctor_id,
    diagnosis, symptoms, notes, record_date)
VALUES (record_seq.NEXTVAL, 8, 8, 4, 'Varicella (Chickenpox)',
    'Itchy rash with blisters, mild fever, fatigue',
    'Contagious viral infection. Prescribed antihistamines and calamine lotion. Isolated for 5 days.',
    SYSDATE - 3);

INSERT INTO MEDICAL_RECORDS (record_id, appointment_id, patient_id, doctor_id,
    diagnosis, symptoms, notes, record_date)
VALUES (record_seq.NEXTVAL, 9, 9, 2, 'Lumbar Strain - Chronic',
    'Persistent lower back pain for 3 months, stiffness in morning',
    'X-ray shows no椎间盘突出. Physical therapy recommended. Ergonomic changes at work advised.',
    SYSDATE - 8);

-- ============================================
-- Insert Additional Prescriptions (7-18)
-- ============================================

-- Prescriptions for record 3 (Flu)
INSERT INTO PRESCRIPTIONS (prescription_id, record_id, medicine_name, dosage,
    frequency, duration_days, instructions)
VALUES (prescription_seq.NEXTVAL, 3, 'Oseltamivir', '75mg', 'Twice daily', 5, 
    'Take with food');

INSERT INTO PRESCRIPTIONS (prescription_id, record_id, medicine_name, dosage,
    frequency, duration_days, instructions)
VALUES (prescription_seq.NEXTVAL, 3, 'Paracetamol', '650mg', 'Every 6 hours if fever', 5, 
    'Take after food');

INSERT INTO PRESCRIPTIONS (prescription_id, record_id, medicine_name, dosage,
    frequency, duration_days, instructions)
VALUES (prescription_seq.NEXTVAL, 3, 'Cetirizine', '10mg', 'Once daily', 5, 
    'Take at bedtime');

-- Prescriptions for record 4 (Hypertension)
INSERT INTO PRESCRIPTIONS (prescription_id, record_id, medicine_name, dosage,
    frequency, duration_days, instructions)
VALUES (prescription_seq.NEXTVAL, 4, 'Amlodipine', '5mg', 'Once daily', 30, 
    'Take in morning with water');

INSERT INTO PRESCRIPTIONS (prescription_id, record_id, medicine_name, dosage,
    frequency, duration_days, instructions)
VALUES (prescription_seq.NEXTVAL, 4, 'Aspirin', '75mg', 'Once daily', 30, 
    'Take after breakfast');

-- Prescriptions for record 5 (Chickenpox)
INSERT INTO PRESCRIPTIONS (prescription_id, record_id, medicine_name, dosage,
    frequency, duration_days, instructions)
VALUES (prescription_seq.NEXTVAL, 5, 'Calamine Lotion', 'Apply externally', '3 times daily', 7, 
    'Apply on affected areas');

INSERT INTO PRESCRIPTIONS (prescription_id, record_id, medicine_name, dosage,
    frequency, duration_days, instructions)
VALUES (prescription_seq.NEXTVAL, 5, 'Chlorpheniramine', '4mg', 'Twice daily', 5, 
    'Take to reduce itching');

-- Prescriptions for record 6 (Back pain)
INSERT INTO PRESCRIPTIONS (prescription_id, record_id, medicine_name, dosage,
    frequency, duration_days, instructions)
VALUES (prescription_seq.NEXTVAL, 6, 'Diclofenac', '50mg', 'Twice daily after food', 7, 
    'Take after food');

INSERT INTO PRESCRIPTIONS (prescription_id, record_id, medicine_name, dosage,
    frequency, duration_days, instructions)
VALUES (prescription_seq.NEXTVAL, 6, 'Thiocolchicoside', '4mg', 'Once at night', 7, 
    'Take before sleep');

-- ============================================
-- Insert Additional Bills (3-6)
-- ============================================

INSERT INTO BILLS (bill_id, appointment_id, patient_id, consultation_fee,
    medicine_fee, lab_fee, total_amount, discount, final_amount, bill_date, status)
VALUES (bill_seq.NEXTVAL, 6, 6, 400.00, 320.00, 0.00, 720.00, 0.00, 720.00, SYSDATE - 5, 'PAID');

INSERT INTO BILLS (bill_id, appointment_id, patient_id, consultation_fee,
    medicine_fee, lab_fee, total_amount, discount, final_amount, bill_date, status)
VALUES (bill_seq.NEXTVAL, 7, 7, 800.00, 150.00, 500.00, 1450.00, 100.00, 1350.00, SYSDATE - 10, 'PAID');

INSERT INTO BILLS (bill_id, appointment_id, patient_id, consultation_fee,
    medicine_fee, lab_fee, total_amount, discount, final_amount, bill_date, status)
VALUES (bill_seq.NEXTVAL, 8, 8, 500.00, 280.00, 0.00, 780.00, 50.00, 730.00, SYSDATE - 3, 'PENDING');

INSERT INTO BILLS (bill_id, appointment_id, patient_id, consultation_fee,
    medicine_fee, lab_fee, total_amount, discount, final_amount, bill_date, status)
VALUES (bill_seq.NEXTVAL, 9, 9, 600.00, 200.00, 0.00, 800.00, 0.00, 800.00, SYSDATE - 8, 'PAID');

-- ============================================
-- Insert Additional Payments (3-6)
-- ============================================

INSERT INTO PAYMENTS (payment_id, bill_id, amount_paid, payment_date, payment_method, transaction_ref)
VALUES (payment_seq.NEXTVAL, 3, 720.00, SYSDATE - 5, 'UPI', 'TXN-UPI-002');

INSERT INTO PAYMENTS (payment_id, bill_id, amount_paid, payment_date, payment_method, transaction_ref)
VALUES (payment_seq.NEXTVAL, 4, 1350.00, SYSDATE - 10, 'CARD', 'TXN-CARD-002');

INSERT INTO PAYMENTS (payment_id, bill_id, amount_paid, payment_date, payment_method, transaction_ref)
VALUES (payment_seq.NEXTVAL, 5, 730.00, SYSDATE - 3, 'CASH', 'TXN-CASH-001');

INSERT INTO PAYMENTS (payment_id, bill_id, amount_paid, payment_date, payment_method, transaction_ref)
VALUES (payment_seq.NEXTVAL, 6, 800.00, SYSDATE - 8, 'UPI', 'TXN-UPI-003');

-- ============================================
-- Commit all changes
-- ============================================

COMMIT;

-- ============================================
-- Verification Queries
-- ============================================

SELECT 'PATIENTS' AS table_name, COUNT(*) AS record_count FROM PATIENTS
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
-- End of Additional Dummy Data Script
-- ============================================
