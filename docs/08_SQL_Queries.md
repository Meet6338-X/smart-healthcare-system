# 🗄️ SQL Queries

## 🎯 Overview

This document covers **Oracle SQL** including:
- **DDL** (Data Definition Language) - CREATE, ALTER, DROP
- **DML** (Data Manipulation Language) - INSERT, UPDATE, DELETE
- **DQL** (Data Query Language) - SELECT with JOINs, subqueries

---

## 📊 DDL - Data Definition Language

### Create Tables

```sql
-- ============================================
-- 1. USERS Table (Base table for all users)
-- ============================================
CREATE TABLE USERS (
    user_id         NUMBER PRIMARY KEY,
    username        VARCHAR2(50) UNIQUE NOT NULL,
    password_hash   VARCHAR2(255) NOT NULL,
    email           VARCHAR2(100) UNIQUE,
    role            VARCHAR2(20) NOT NULL 
                    CHECK (role IN ('ADMIN', 'DOCTOR', 'PATIENT')),
    status          VARCHAR2(20) DEFAULT 'ACTIVE',
    created_at      DATE DEFAULT SYSDATE
);

-- ============================================
-- 2. DEPARTMENTS Table
-- ============================================
CREATE TABLE DEPARTMENTS (
    dept_id         NUMBER PRIMARY KEY,
    dept_name       VARCHAR2(50) UNIQUE NOT NULL,
    description     VARCHAR2(200),
    location        VARCHAR2(50)
);

-- ============================================
-- 3. DOCTORS Table
-- ============================================
CREATE TABLE DOCTORS (
    doctor_id       NUMBER PRIMARY KEY,
    user_id         NUMBER UNIQUE REFERENCES USERS(user_id),
    dept_id         NUMBER REFERENCES DEPARTMENTS(dept_id),
    first_name      VARCHAR2(50) NOT NULL,
    last_name       VARCHAR2(50) NOT NULL,
    specialization  VARCHAR2(100) NOT NULL,
    license_number  VARCHAR2(50) UNIQUE,
    phone           VARCHAR2(15) NOT NULL,
    experience_years NUMBER,
    consultation_fee NUMBER(10,2) NOT NULL,
    available       CHAR(1) DEFAULT 'Y' CHECK (available IN ('Y', 'N'))
);

-- ============================================
-- 4. PATIENTS Table
-- ============================================
CREATE TABLE PATIENTS (
    patient_id      NUMBER PRIMARY KEY,
    user_id         NUMBER UNIQUE REFERENCES USERS(user_id),
    first_name      VARCHAR2(50) NOT NULL,
    last_name       VARCHAR2(50) NOT NULL,
    date_of_birth   DATE NOT NULL,
    gender          VARCHAR2(10) CHECK (gender IN ('Male', 'Female', 'Other')),
    phone           VARCHAR2(15) NOT NULL,
    address         VARCHAR2(200),
    city            VARCHAR2(50),
    blood_group     VARCHAR2(5),
    emergency_contact VARCHAR2(15),
    registered_date DATE DEFAULT SYSDATE
);

-- ============================================
-- 5. APPOINTMENTS Table
-- ============================================
CREATE TABLE APPOINTMENTS (
    appointment_id  NUMBER PRIMARY KEY,
    patient_id      NUMBER NOT NULL REFERENCES PATIENTS(patient_id),
    doctor_id       NUMBER NOT NULL REFERENCES DOCTORS(doctor_id),
    appointment_date DATE NOT NULL,
    appointment_time VARCHAR2(10) NOT NULL,
    status          VARCHAR2(20) DEFAULT 'SCHEDULED'
                    CHECK (status IN ('SCHEDULED', 'COMPLETED', 'CANCELLED', 'NO_SHOW')),
    reason          VARCHAR2(500),
    created_at      DATE DEFAULT SYSDATE
);

-- ============================================
-- 6. MEDICAL_RECORDS Table
-- ============================================
CREATE TABLE MEDICAL_RECORDS (
    record_id       NUMBER PRIMARY KEY,
    appointment_id  NUMBER UNIQUE REFERENCES APPOINTMENTS(appointment_id),
    patient_id      NUMBER REFERENCES PATIENTS(patient_id),
    doctor_id       NUMBER REFERENCES DOCTORS(doctor_id),
    diagnosis       VARCHAR2(500),
    symptoms        VARCHAR2(500),
    notes           CLOB,
    record_date     DATE DEFAULT SYSDATE
);

-- ============================================
-- 7. PRESCRIPTIONS Table
-- ============================================
CREATE TABLE PRESCRIPTIONS (
    prescription_id NUMBER PRIMARY KEY,
    record_id       NUMBER NOT NULL REFERENCES MEDICAL_RECORDS(record_id),
    medicine_name   VARCHAR2(100) NOT NULL,
    dosage          VARCHAR2(50),
    frequency       VARCHAR2(50),
    duration_days   NUMBER,
    instructions    VARCHAR2(200)
);

-- ============================================
-- 8. BILLS Table
-- ============================================
CREATE TABLE BILLS (
    bill_id         NUMBER PRIMARY KEY,
    appointment_id  NUMBER UNIQUE REFERENCES APPOINTMENTS(appointment_id),
    patient_id      NUMBER REFERENCES PATIENTS(patient_id),
    consultation_fee NUMBER(10,2),
    medicine_fee    NUMBER(10,2) DEFAULT 0,
    lab_fee         NUMBER(10,2) DEFAULT 0,
    total_amount    NUMBER(10,2) NOT NULL,
    discount        NUMBER(5,2) DEFAULT 0,
    final_amount    NUMBER(10,2),
    bill_date       DATE DEFAULT SYSDATE,
    status          VARCHAR2(20) DEFAULT 'PENDING'
                    CHECK (status IN ('PENDING', 'PAID', 'PARTIAL'))
);

-- ============================================
-- 9. PAYMENTS Table
-- ============================================
CREATE TABLE PAYMENTS (
    payment_id      NUMBER PRIMARY KEY,
    bill_id         NUMBER NOT NULL REFERENCES BILLS(bill_id),
    amount_paid     NUMBER(10,2) NOT NULL,
    payment_date    DATE DEFAULT SYSDATE,
    payment_method  VARCHAR2(20) 
                    CHECK (payment_method IN ('CASH', 'CARD', 'UPI', 'INSURANCE')),
    transaction_ref VARCHAR2(50)
);
```

---

### Create Sequences (Auto-increment)

```sql
-- Sequences for auto-incrementing IDs
CREATE SEQUENCE user_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE dept_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE doctor_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE patient_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE appointment_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE record_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE prescription_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE bill_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE payment_seq START WITH 1 INCREMENT BY 1;
```

---

## 📝 DML - Data Manipulation Language

### INSERT Statements

```sql
-- ============================================
-- Insert Departments
-- ============================================
INSERT INTO DEPARTMENTS (dept_id, dept_name, description, location)
VALUES (dept_seq.NEXTVAL, 'Cardiology', 'Heart and cardiovascular care', 'Building A, Floor 2');

INSERT INTO DEPARTMENTS (dept_id, dept_name, description, location)
VALUES (dept_seq.NEXTVAL, 'Orthopedics', 'Bone and joint treatment', 'Building B, Floor 1');

INSERT INTO DEPARTMENTS (dept_id, dept_name, description, location)
VALUES (dept_seq.NEXTVAL, 'Neurology', 'Brain and nervous system', 'Building A, Floor 3');

INSERT INTO DEPARTMENTS (dept_id, dept_name, description, location)
VALUES (dept_seq.NEXTVAL, 'Pediatrics', 'Child healthcare', 'Building C, Floor 1');

-- ============================================
-- Insert Users
-- ============================================
INSERT INTO USERS (user_id, username, password_hash, email, role)
VALUES (user_seq.NEXTVAL, 'admin1', 'hash_admin123', 'admin@hospital.com', 'ADMIN');

INSERT INTO USERS (user_id, username, password_hash, email, role)
VALUES (user_seq.NEXTVAL, 'dr_sharma', 'hash_doc123', 'sharma@hospital.com', 'DOCTOR');

INSERT INTO USERS (user_id, username, password_hash, email, role)
VALUES (user_seq.NEXTVAL, 'dr_patel', 'hash_doc456', 'patel@hospital.com', 'DOCTOR');

INSERT INTO USERS (user_id, username, password_hash, email, role)
VALUES (user_seq.NEXTVAL, 'patient_raj', 'hash_pat123', 'raj@email.com', 'PATIENT');

INSERT INTO USERS (user_id, username, password_hash, email, role)
VALUES (user_seq.NEXTVAL, 'patient_priya', 'hash_pat456', 'priya@email.com', 'PATIENT');

-- ============================================
-- Insert Doctors
-- ============================================
INSERT INTO DOCTORS (doctor_id, user_id, dept_id, first_name, last_name, specialization, 
                     license_number, phone, experience_years, consultation_fee)
VALUES (doctor_seq.NEXTVAL, 2, 1, 'Amit', 'Sharma', 'Cardiologist', 
        'MCI-12345', '9876543210', 15, 800.00);

INSERT INTO DOCTORS (doctor_id, user_id, dept_id, first_name, last_name, specialization,
                     license_number, phone, experience_years, consultation_fee)
VALUES (doctor_seq.NEXTVAL, 3, 2, 'Neha', 'Patel', 'Orthopedic Surgeon',
        'MCI-67890', '9876543211', 10, 600.00);

-- ============================================
-- Insert Patients
-- ============================================
INSERT INTO PATIENTS (patient_id, user_id, first_name, last_name, date_of_birth, 
                      gender, phone, address, city, blood_group, emergency_contact)
VALUES (patient_seq.NEXTVAL, 4, 'Raj', 'Kumar', TO_DATE('1990-05-15', 'YYYY-MM-DD'),
        'Male', '9123456789', '123 Main Street', 'Mumbai', 'A+', '9123456780');

INSERT INTO PATIENTS (patient_id, user_id, first_name, last_name, date_of_birth,
                      gender, phone, address, city, blood_group)
VALUES (patient_seq.NEXTVAL, 5, 'Priya', 'Singh', TO_DATE('1985-08-22', 'YYYY-MM-DD'),
        'Female', '9123456788', '456 Park Avenue', 'Delhi', 'B+');

-- ============================================
-- Insert Appointments
-- ============================================
INSERT INTO APPOINTMENTS (appointment_id, patient_id, doctor_id, appointment_date,
                          appointment_time, status, reason)
VALUES (appointment_seq.NEXTVAL, 1, 1, TO_DATE('2024-02-15', 'YYYY-MM-DD'),
        '10:00 AM', 'SCHEDULED', 'Chest pain and breathing difficulty');

INSERT INTO APPOINTMENTS (appointment_id, patient_id, doctor_id, appointment_date,
                          appointment_time, status, reason)
VALUES (appointment_seq.NEXTVAL, 2, 2, TO_DATE('2024-02-16', 'YYYY-MM-DD'),
        '11:30 AM', 'COMPLETED', 'Knee pain after fall');
```

---

### UPDATE Statements

```sql
-- Update appointment status
UPDATE APPOINTMENTS
SET status = 'COMPLETED'
WHERE appointment_id = 1;

-- Update doctor consultation fee
UPDATE DOCTORS
SET consultation_fee = 850.00
WHERE doctor_id = 1;

-- Update patient phone number
UPDATE PATIENTS
SET phone = '9123456799', 
    address = '789 New Street'
WHERE patient_id = 1;
```

---

### DELETE Statements

```sql
-- Delete a cancelled appointment
DELETE FROM APPOINTMENTS
WHERE appointment_id = 5 AND status = 'CANCELLED';

-- Delete prescriptions for a deleted medical record
DELETE FROM PRESCRIPTIONS
WHERE record_id = 10;
```

---

## 🔗 JOIN Queries

### INNER JOIN

```sql
-- Appointments with patient and doctor details
SELECT 
    a.appointment_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    d.first_name || ' ' || d.last_name AS doctor_name,
    dp.dept_name,
    a.appointment_date,
    a.appointment_time,
    a.status
FROM APPOINTMENTS a
INNER JOIN PATIENTS p ON a.patient_id = p.patient_id
INNER JOIN DOCTORS d ON a.doctor_id = d.doctor_id
INNER JOIN DEPARTMENTS dp ON d.dept_id = dp.dept_id;
```

### LEFT OUTER JOIN

```sql
-- All patients with their appointments (including those without appointments)
SELECT 
    p.patient_id,
    p.first_name,
    p.last_name,
    COUNT(a.appointment_id) AS total_appointments
FROM PATIENTS p
LEFT OUTER JOIN APPOINTMENTS a ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name;
```

### RIGHT OUTER JOIN

```sql
-- All doctors with their appointment counts
SELECT 
    d.doctor_id,
    d.first_name || ' ' || d.last_name AS doctor_name,
    COUNT(a.appointment_id) AS appointments_handled
FROM APPOINTMENTS a
RIGHT OUTER JOIN DOCTORS d ON a.doctor_id = d.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name;
```

### FULL OUTER JOIN

```sql
-- All patients and appointments (both matched and unmatched)
SELECT 
    p.first_name AS patient_name,
    a.appointment_date,
    a.status
FROM PATIENTS p
FULL OUTER JOIN APPOINTMENTS a ON p.patient_id = a.patient_id;
```

---

## 🔍 Nested Queries (Subqueries)

### Subquery in WHERE

```sql
-- Patients who have appointments with senior doctors (experience > 10 years)
SELECT first_name, last_name, phone
FROM PATIENTS
WHERE patient_id IN (
    SELECT patient_id FROM APPOINTMENTS
    WHERE doctor_id IN (
        SELECT doctor_id FROM DOCTORS WHERE experience_years > 10
    )
);
```

### Subquery in FROM (Inline View)

```sql
-- Doctors with above-average consultation fees
SELECT doctor_id, first_name, last_name, consultation_fee
FROM DOCTORS
WHERE consultation_fee > (
    SELECT AVG(consultation_fee) FROM DOCTORS
);
```

### Correlated Subquery

```sql
-- Patients with more than 2 appointments
SELECT p.patient_id, p.first_name, p.last_name
FROM PATIENTS p
WHERE (
    SELECT COUNT(*) FROM APPOINTMENTS a 
    WHERE a.patient_id = p.patient_id
) > 2;
```

### EXISTS Subquery

```sql
-- Doctors who have at least one completed appointment
SELECT d.doctor_id, d.first_name, d.last_name
FROM DOCTORS d
WHERE EXISTS (
    SELECT 1 FROM APPOINTMENTS a
    WHERE a.doctor_id = d.doctor_id AND a.status = 'COMPLETED'
);
```

---

## 📊 GROUP BY and HAVING

### Basic GROUP BY

```sql
-- Count appointments per status
SELECT status, COUNT(*) AS count
FROM APPOINTMENTS
GROUP BY status;
```

### GROUP BY with HAVING

```sql
-- Doctors with more than 5 completed appointments
SELECT 
    d.doctor_id,
    d.first_name || ' ' || d.last_name AS doctor_name,
    COUNT(a.appointment_id) AS completed_count
FROM DOCTORS d
JOIN APPOINTMENTS a ON d.doctor_id = a.doctor_id
WHERE a.status = 'COMPLETED'
GROUP BY d.doctor_id, d.first_name, d.last_name
HAVING COUNT(a.appointment_id) > 5;
```

### Multiple Aggregations

```sql
-- Department statistics
SELECT 
    dp.dept_name,
    COUNT(DISTINCT d.doctor_id) AS doctor_count,
    AVG(d.consultation_fee) AS avg_fee,
    MAX(d.experience_years) AS max_experience
FROM DEPARTMENTS dp
LEFT JOIN DOCTORS d ON dp.dept_id = d.dept_id
GROUP BY dp.dept_name;
```

---

## 📈 Advanced Queries

### WITH Clause (Common Table Expression)

```sql
-- Monthly appointment report
WITH MonthlyAppointments AS (
    SELECT 
        TO_CHAR(appointment_date, 'YYYY-MM') AS month,
        COUNT(*) AS total,
        SUM(CASE WHEN status = 'COMPLETED' THEN 1 ELSE 0 END) AS completed,
        SUM(CASE WHEN status = 'CANCELLED' THEN 1 ELSE 0 END) AS cancelled
    FROM APPOINTMENTS
    GROUP BY TO_CHAR(appointment_date, 'YYYY-MM')
)
SELECT * FROM MonthlyAppointments ORDER BY month DESC;
```

### CASE Statement

```sql
-- Categorize doctors by experience
SELECT 
    first_name,
    last_name,
    experience_years,
    CASE 
        WHEN experience_years >= 15 THEN 'Senior'
        WHEN experience_years >= 5 THEN 'Experienced'
        ELSE 'Junior'
    END AS experience_level
FROM DOCTORS;
```

---

> **📝 DBMS Concept:** SQL is a declarative language - you specify WHAT you want, not HOW to get it. The database optimizer determines the most efficient execution plan.
