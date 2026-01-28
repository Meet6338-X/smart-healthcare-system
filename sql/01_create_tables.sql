-- ============================================
-- Smart Healthcare Management System
-- DDL Script: Create Tables
-- Oracle RDBMS
-- ============================================

-- Drop existing tables (if recreating)
-- Run this section only if you want to start fresh

/*
BEGIN
    FOR t IN (SELECT table_name FROM user_tables) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
    END LOOP;
    FOR s IN (SELECT sequence_name FROM user_sequences) LOOP
        EXECUTE IMMEDIATE 'DROP SEQUENCE ' || s.sequence_name;
    END LOOP;
END;
/
*/

-- ============================================
-- Create Sequences (for auto-increment IDs)
-- ============================================

CREATE SEQUENCE user_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE dept_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE doctor_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE patient_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE appointment_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE record_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE prescription_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE bill_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE payment_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE audit_log_seq START WITH 1 INCREMENT BY 1;

-- ============================================
-- Table 1: USERS
-- Base table for all system users
-- ============================================

CREATE TABLE USERS (
    user_id         NUMBER PRIMARY KEY,
    username        VARCHAR2(50) UNIQUE NOT NULL,
    password_hash   VARCHAR2(255) NOT NULL,
    email           VARCHAR2(100) UNIQUE,
    role            VARCHAR2(20) NOT NULL 
                    CONSTRAINT chk_user_role 
                    CHECK (role IN ('ADMIN', 'DOCTOR', 'PATIENT')),
    status          VARCHAR2(20) DEFAULT 'ACTIVE'
                    CONSTRAINT chk_user_status
                    CHECK (status IN ('ACTIVE', 'INACTIVE', 'SUSPENDED')),
    created_at      DATE DEFAULT SYSDATE
);

COMMENT ON TABLE USERS IS 'Base table for all system users';
COMMENT ON COLUMN USERS.role IS 'User type: ADMIN, DOCTOR, or PATIENT';

-- ============================================
-- Table 2: DEPARTMENTS
-- Hospital departments
-- ============================================

CREATE TABLE DEPARTMENTS (
    dept_id         NUMBER PRIMARY KEY,
    dept_name       VARCHAR2(50) UNIQUE NOT NULL,
    description     VARCHAR2(200),
    location        VARCHAR2(50)
);

COMMENT ON TABLE DEPARTMENTS IS 'Hospital departments like Cardiology, Orthopedics';

-- ============================================
-- Table 3: DOCTORS
-- Doctor profiles (extends USERS)
-- ============================================

CREATE TABLE DOCTORS (
    doctor_id       NUMBER PRIMARY KEY,
    user_id         NUMBER UNIQUE 
                    CONSTRAINT fk_doctor_user 
                    REFERENCES USERS(user_id) ON DELETE CASCADE,
    dept_id         NUMBER 
                    CONSTRAINT fk_doctor_dept 
                    REFERENCES DEPARTMENTS(dept_id),
    first_name      VARCHAR2(50) NOT NULL,
    last_name       VARCHAR2(50) NOT NULL,
    specialization  VARCHAR2(100) NOT NULL,
    license_number  VARCHAR2(50) UNIQUE,
    phone           VARCHAR2(15) NOT NULL,
    experience_years NUMBER CHECK (experience_years >= 0),
    consultation_fee NUMBER(10,2) NOT NULL CHECK (consultation_fee > 0),
    available       CHAR(1) DEFAULT 'Y' 
                    CONSTRAINT chk_doctor_available 
                    CHECK (available IN ('Y', 'N'))
);

COMMENT ON TABLE DOCTORS IS 'Doctor profiles with specialization and fees';

-- ============================================
-- Table 4: PATIENTS
-- Patient records (extends USERS)
-- ============================================

CREATE TABLE PATIENTS (
    patient_id      NUMBER PRIMARY KEY,
    user_id         NUMBER UNIQUE 
                    CONSTRAINT fk_patient_user 
                    REFERENCES USERS(user_id) ON DELETE CASCADE,
    first_name      VARCHAR2(50) NOT NULL,
    last_name       VARCHAR2(50) NOT NULL,
    date_of_birth   DATE NOT NULL,
    gender          VARCHAR2(10) 
                    CONSTRAINT chk_patient_gender 
                    CHECK (gender IN ('Male', 'Female', 'Other')),
    phone           VARCHAR2(15) NOT NULL,
    address         VARCHAR2(200),
    city            VARCHAR2(50),
    blood_group     VARCHAR2(5),
    emergency_contact VARCHAR2(15),
    registered_date DATE DEFAULT SYSDATE
);

COMMENT ON TABLE PATIENTS IS 'Patient demographic and contact information';

-- ============================================
-- Table 5: APPOINTMENTS
-- Appointment scheduling
-- ============================================

CREATE TABLE APPOINTMENTS (
    appointment_id  NUMBER PRIMARY KEY,
    patient_id      NUMBER NOT NULL 
                    CONSTRAINT fk_appt_patient 
                    REFERENCES PATIENTS(patient_id),
    doctor_id       NUMBER NOT NULL 
                    CONSTRAINT fk_appt_doctor 
                    REFERENCES DOCTORS(doctor_id),
    appointment_date DATE NOT NULL,
    appointment_time VARCHAR2(10) NOT NULL,
    status          VARCHAR2(20) DEFAULT 'SCHEDULED'
                    CONSTRAINT chk_appt_status
                    CHECK (status IN ('SCHEDULED', 'COMPLETED', 'CANCELLED', 'NO_SHOW')),
    reason          VARCHAR2(500),
    created_at      DATE DEFAULT SYSDATE
);

COMMENT ON TABLE APPOINTMENTS IS 'Patient-Doctor appointment records';

-- ============================================
-- Table 6: MEDICAL_RECORDS
-- Patient medical history per appointment
-- ============================================

CREATE TABLE MEDICAL_RECORDS (
    record_id       NUMBER PRIMARY KEY,
    appointment_id  NUMBER UNIQUE 
                    CONSTRAINT fk_record_appt 
                    REFERENCES APPOINTMENTS(appointment_id),
    patient_id      NUMBER 
                    CONSTRAINT fk_record_patient 
                    REFERENCES PATIENTS(patient_id),
    doctor_id       NUMBER 
                    CONSTRAINT fk_record_doctor 
                    REFERENCES DOCTORS(doctor_id),
    diagnosis       VARCHAR2(500),
    symptoms        VARCHAR2(500),
    notes           CLOB,
    record_date     DATE DEFAULT SYSDATE
);

COMMENT ON TABLE MEDICAL_RECORDS IS 'Medical diagnosis and notes for each visit';

-- ============================================
-- Table 7: PRESCRIPTIONS
-- Medications prescribed
-- ============================================

CREATE TABLE PRESCRIPTIONS (
    prescription_id NUMBER PRIMARY KEY,
    record_id       NUMBER NOT NULL 
                    CONSTRAINT fk_presc_record 
                    REFERENCES MEDICAL_RECORDS(record_id),
    medicine_name   VARCHAR2(100) NOT NULL,
    dosage          VARCHAR2(50),
    frequency       VARCHAR2(50),
    duration_days   NUMBER CHECK (duration_days > 0),
    instructions    VARCHAR2(200)
);

COMMENT ON TABLE PRESCRIPTIONS IS 'Prescribed medications per medical record';

-- ============================================
-- Table 8: BILLS
-- Patient billing
-- ============================================

CREATE TABLE BILLS (
    bill_id         NUMBER PRIMARY KEY,
    appointment_id  NUMBER UNIQUE 
                    CONSTRAINT fk_bill_appt 
                    REFERENCES APPOINTMENTS(appointment_id),
    patient_id      NUMBER 
                    CONSTRAINT fk_bill_patient 
                    REFERENCES PATIENTS(patient_id),
    consultation_fee NUMBER(10,2),
    medicine_fee    NUMBER(10,2) DEFAULT 0,
    lab_fee         NUMBER(10,2) DEFAULT 0,
    total_amount    NUMBER(10,2) NOT NULL,
    discount        NUMBER(5,2) DEFAULT 0,
    final_amount    NUMBER(10,2),
    bill_date       DATE DEFAULT SYSDATE,
    status          VARCHAR2(20) DEFAULT 'PENDING'
                    CONSTRAINT chk_bill_status
                    CHECK (status IN ('PENDING', 'PAID', 'PARTIAL'))
);

COMMENT ON TABLE BILLS IS 'Patient invoices per appointment';

-- ============================================
-- Table 9: PAYMENTS
-- Payment transactions
-- ============================================

CREATE TABLE PAYMENTS (
    payment_id      NUMBER PRIMARY KEY,
    bill_id         NUMBER NOT NULL 
                    CONSTRAINT fk_payment_bill 
                    REFERENCES BILLS(bill_id),
    amount_paid     NUMBER(10,2) NOT NULL CHECK (amount_paid > 0),
    payment_date    DATE DEFAULT SYSDATE,
    payment_method  VARCHAR2(20) 
                    CONSTRAINT chk_payment_method
                    CHECK (payment_method IN ('CASH', 'CARD', 'UPI', 'INSURANCE')),
    transaction_ref VARCHAR2(50)
);

COMMENT ON TABLE PAYMENTS IS 'Payment transactions for bills';

-- ============================================
-- Table 10: PATIENT_AUDIT_LOG
-- Audit trail for patient updates
-- ============================================

CREATE TABLE PATIENT_AUDIT_LOG (
    log_id          NUMBER PRIMARY KEY,
    patient_id      NUMBER,
    action          VARCHAR2(10),
    changed_by      VARCHAR2(50),
    change_date     DATE DEFAULT SYSDATE,
    old_phone       VARCHAR2(15),
    new_phone       VARCHAR2(15),
    old_address     VARCHAR2(200),
    new_address     VARCHAR2(200)
);

COMMENT ON TABLE PATIENT_AUDIT_LOG IS 'Audit log for tracking patient data changes';

-- ============================================
-- Create Indexes for Performance
-- ============================================

CREATE INDEX idx_appointment_date ON APPOINTMENTS(appointment_date);
CREATE INDEX idx_appointment_status ON APPOINTMENTS(status);
CREATE INDEX idx_appointment_slot ON APPOINTMENTS(doctor_id, appointment_date, appointment_time);
CREATE INDEX idx_patient_phone ON PATIENTS(phone);
CREATE INDEX idx_patient_name ON PATIENTS(last_name, first_name);
CREATE INDEX idx_doctor_specialization ON DOCTORS(specialization);
CREATE INDEX idx_bill_status ON BILLS(status);

-- ============================================
-- Verification Queries
-- ============================================

-- List all tables
SELECT table_name FROM user_tables ORDER BY table_name;

-- List all sequences
SELECT sequence_name FROM user_sequences ORDER BY sequence_name;

-- List all indexes
SELECT index_name, table_name FROM user_indexes 
WHERE index_name LIKE 'IDX_%' ORDER BY table_name;

COMMIT;

-- ============================================
-- End of DDL Script
-- ============================================
