# Assignment 2: DDL & DML Operations

## 1. DDL (Data Definition Language)

### Create Tables with Constraints
The following SQL commands create the necessary tables for the Smart Healthcare System with Primary Keys, Foreign Keys, Unique constraints, and Check constraints.

```sql
-- Create USERS Table
CREATE TABLE USERS (
    user_id         NUMBER PRIMARY KEY,
    username        VARCHAR2(50) UNIQUE NOT NULL,
    password_hash   VARCHAR2(255) NOT NULL,
    email           VARCHAR2(100) UNIQUE,
    role            VARCHAR2(20) CHECK (role IN ('ADMIN', 'DOCTOR', 'PATIENT')),
    status          VARCHAR2(20) DEFAULT 'ACTIVE',
    created_at      DATE DEFAULT SYSDATE
);

-- Create DEPARTMENTS Table
CREATE TABLE DEPARTMENTS (
    dept_id         NUMBER PRIMARY KEY,
    dept_name       VARCHAR2(50) UNIQUE NOT NULL,
    description     VARCHAR2(200),
    location        VARCHAR2(50)
);

-- Create DOCTORS Table
CREATE TABLE DOCTORS (
    doctor_id       NUMBER PRIMARY KEY,
    user_id         NUMBER UNIQUE REFERENCES USERS(user_id) ON DELETE CASCADE,
    dept_id         NUMBER REFERENCES DEPARTMENTS(dept_id),
    first_name      VARCHAR2(50) NOT NULL,
    last_name       VARCHAR2(50) NOT NULL,
    specialization  VARCHAR2(100) NOT NULL,
    license_number  VARCHAR2(50) UNIQUE,
    phone           VARCHAR2(15) NOT NULL,
    consultation_fee NUMBER(10,2) CHECK (consultation_fee > 0),
    available       CHAR(1) DEFAULT 'Y' CHECK (available IN ('Y', 'N'))
);

-- Create PATIENTS Table
CREATE TABLE PATIENTS (
    patient_id      NUMBER PRIMARY KEY,
    user_id         NUMBER UNIQUE REFERENCES USERS(user_id) ON DELETE CASCADE,
    first_name      VARCHAR2(50) NOT NULL,
    last_name       VARCHAR2(50) NOT NULL,
    date_of_birth   DATE NOT NULL,
    gender          VARCHAR2(10) CHECK (gender IN ('Male', 'Female', 'Other')),
    phone           VARCHAR2(15) NOT NULL,
    address         VARCHAR2(200),
    city            VARCHAR2(50),
    blood_group     VARCHAR2(5),
    registered_date DATE DEFAULT SYSDATE
);

-- Create APPOINTMENTS Table
CREATE TABLE APPOINTMENTS (
    appointment_id  NUMBER PRIMARY KEY,
    patient_id      NUMBER NOT NULL REFERENCES PATIENTS(patient_id),
    doctor_id       NUMBER NOT NULL REFERENCES DOCTORS(doctor_id),
    appointment_date DATE NOT NULL,
    appointment_time VARCHAR2(10) NOT NULL,
    status          VARCHAR2(20) CHECK (status IN ('SCHEDULED', 'COMPLETED', 'CANCELLED')),
    reason          VARCHAR2(500),
    created_at      DATE DEFAULT SYSDATE
);
```

## 2. DML (Data Manipulation Language)

### Insert Data (Populate)

```sql
-- Insert Departments
INSERT INTO DEPARTMENTS (dept_id, dept_name, location) 
VALUES (1, 'Cardiology', 'Building A, Floor 2');

INSERT INTO DEPARTMENTS (dept_id, dept_name, location) 
VALUES (2, 'Orthopedics', 'Building B, Floor 1');

-- Insert Users
INSERT INTO USERS (user_id, username, password_hash, role) 
VALUES (1, 'admin1', 'hash123', 'ADMIN');

INSERT INTO USERS (user_id, username, password_hash, role) 
VALUES (2, 'dr_sharma', 'hash_doc1', 'DOCTOR');

INSERT INTO USERS (user_id, username, password_hash, role) 
VALUES (3, 'patient_raj', 'hash_pat1', 'PATIENT');

-- Insert Doctors
INSERT INTO DOCTORS (doctor_id, user_id, dept_id, first_name, last_name, specialization, phone, consultation_fee) 
VALUES (1, 2, 1, 'Amit', 'Sharma', 'Cardiologist', '9876543210', 800.00);

-- Insert Patients
INSERT INTO PATIENTS (patient_id, user_id, first_name, last_name, date_of_birth, gender, phone, city) 
VALUES (1, 3, 'Raj', 'Kumar', TO_DATE('1990-05-15', 'YYYY-MM-DD'), 'Male', '9123456789', 'Mumbai');

-- Insert Appointments
INSERT INTO APPOINTMENTS (appointment_id, patient_id, doctor_id, appointment_date, appointment_time, status, reason) 
VALUES (1, 1, 1, SYSDATE + 2, '10:00 AM', 'SCHEDULED', 'Chest pain');
```

### Update Data (Modify)

```sql
-- Update Doctor's Consultation Fee
UPDATE DOCTORS 
SET consultation_fee = 900.00 
WHERE doctor_id = 1;

-- Update Patient's Address
UPDATE PATIENTS 
SET address = 'New Address, Mumbai', city = 'Navi Mumbai' 
WHERE patient_id = 1;

-- Update Appointment Status
UPDATE APPOINTMENTS 
SET status = 'COMPLETED' 
WHERE appointment_id = 1;
```

### Delete Data

```sql
-- Delete a cancelled appointment
DELETE FROM APPOINTMENTS 
WHERE status = 'CANCELLED' AND appointment_date < SYSDATE - 30;

-- Delete a department (only if no doctors refer to it, or cascade is set)
-- DELETE FROM DEPARTMENTS WHERE dept_id = 3;
```
