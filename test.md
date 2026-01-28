# 🧪 Database Testing Guide

This guide provides steps to directly view and query the Oracle database for the Smart Healthcare Management System.

---

## 📋 Prerequisites

- Oracle Database installed (XE/19c)
- SQL*Plus or SQL Developer
- Database created as per `workhuman.md`

---

## 🔌 Connect to Database

### Option 1: SQL*Plus (Command Line)

```bash
# Connect as healthcare_user
sqlplus healthcare_user/healthcare123@localhost:1521/XEPDB1

# Or if using Oracle XE without pluggable database
sqlplus healthcare_user/healthcare123@localhost:1521/XE
```

### Option 2: SQL Developer (GUI)

1. Open Oracle SQL Developer
2. Create new connection:
   - **Connection Name:** Healthcare
   - **Username:** healthcare_user
   - **Password:** healthcare123
   - **Hostname:** localhost
   - **Port:** 1521
   - **Service Name:** XEPDB1 (or XE)
3. Click **Connect**

---

## 📊 View All Tables

```sql
-- List all tables in the schema
SELECT table_name FROM user_tables ORDER BY table_name;
```

**Expected Tables:**
- USERS
- PATIENTS
- DOCTORS
- DEPARTMENTS
- APPOINTMENTS
- MEDICAL_RECORDS
- PRESCRIPTIONS
- BILLS
- PAYMENTS
- ROOMS

---

## 👥 View Users

```sql
-- View all users
SELECT user_id, username, role, email, created_at 
FROM users 
ORDER BY user_id;

-- View only patients
SELECT u.username, p.first_name, p.last_name, p.phone, p.blood_group
FROM users u
JOIN patients p ON u.user_id = p.user_id
WHERE u.role = 'PATIENT';

-- View only doctors
SELECT u.username, d.first_name, d.last_name, d.specialization, d.consultation_fee
FROM users u
JOIN doctors d ON u.user_id = d.user_id
WHERE u.role = 'DOCTOR';
```

---

## 📅 View Appointments

```sql
-- View all appointments with patient and doctor names
SELECT 
    a.appointment_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    d.first_name || ' ' || d.last_name AS doctor_name,
    a.appointment_date,
    a.appointment_time,
    a.status,
    a.reason
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
ORDER BY a.appointment_date DESC, a.appointment_time;

-- View today's appointments
SELECT 
    a.appointment_id,
    p.first_name || ' ' || p.last_name AS patient,
    d.first_name || ' ' || d.last_name AS doctor,
    a.appointment_time,
    a.status
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
WHERE TRUNC(a.appointment_date) = TRUNC(SYSDATE)
ORDER BY a.appointment_time;

-- View appointments by status
SELECT status, COUNT(*) AS count
FROM appointments
GROUP BY status;
```

---

## 📋 View Medical Records

```sql
-- View medical records with prescriptions
SELECT 
    mr.record_id,
    p.first_name || ' ' || p.last_name AS patient,
    d.first_name || ' ' || d.last_name AS doctor,
    mr.diagnosis,
    mr.record_date,
    (SELECT COUNT(*) FROM prescriptions pr WHERE pr.record_id = mr.record_id) AS prescription_count
FROM medical_records mr
JOIN patients p ON mr.patient_id = p.patient_id
JOIN doctors d ON mr.doctor_id = d.doctor_id
ORDER BY mr.record_date DESC;

-- View prescriptions for a specific record
SELECT 
    pr.medicine_name,
    pr.dosage,
    pr.frequency,
    pr.duration
FROM prescriptions pr
WHERE pr.record_id = 1;  -- Change record_id as needed
```

---

## 💰 View Bills & Payments

```sql
-- View all bills
SELECT 
    b.bill_id,
    p.first_name || ' ' || p.last_name AS patient,
    b.total_amount,
    b.bill_status,
    b.bill_date
FROM bills b
JOIN patients p ON b.patient_id = p.patient_id
ORDER BY b.bill_date DESC;

-- View pending bills
SELECT 
    p.first_name || ' ' || p.last_name AS patient,
    b.total_amount,
    b.bill_date
FROM bills b
JOIN patients p ON b.patient_id = p.patient_id
WHERE b.bill_status = 'PENDING';

-- View total revenue
SELECT 
    SUM(CASE WHEN bill_status = 'PAID' THEN total_amount ELSE 0 END) AS paid_revenue,
    SUM(CASE WHEN bill_status = 'PENDING' THEN total_amount ELSE 0 END) AS pending_revenue
FROM bills;
```

---

## 🏥 View Departments & Doctors

```sql
-- View departments with doctor count
SELECT 
    dept.name AS department,
    dept.location,
    COUNT(d.doctor_id) AS doctor_count
FROM departments dept
LEFT JOIN doctors d ON dept.dept_id = d.dept_id
GROUP BY dept.dept_id, dept.name, dept.location
ORDER BY dept.name;

-- View doctors with their departments
SELECT 
    d.first_name || ' ' || d.last_name AS doctor_name,
    d.specialization,
    dept.name AS department,
    d.consultation_fee
FROM doctors d
JOIN departments dept ON d.dept_id = dept.dept_id
ORDER BY dept.name, d.first_name;
```

---

## 🔧 Useful Queries

### Count Records in All Tables

```sql
SELECT 'USERS' AS table_name, COUNT(*) AS row_count FROM users
UNION ALL
SELECT 'PATIENTS', COUNT(*) FROM patients
UNION ALL
SELECT 'DOCTORS', COUNT(*) FROM doctors
UNION ALL
SELECT 'DEPARTMENTS', COUNT(*) FROM departments
UNION ALL
SELECT 'APPOINTMENTS', COUNT(*) FROM appointments
UNION ALL
SELECT 'MEDICAL_RECORDS', COUNT(*) FROM medical_records
UNION ALL
SELECT 'PRESCRIPTIONS', COUNT(*) FROM prescriptions
UNION ALL
SELECT 'BILLS', COUNT(*) FROM bills
ORDER BY table_name;
```

### Check Table Structure

```sql
-- Describe a specific table
DESC appointments;

-- View all columns of a table
SELECT column_name, data_type, nullable
FROM user_tab_columns
WHERE table_name = 'APPOINTMENTS'
ORDER BY column_id;
```

### Check Indexes

```sql
SELECT index_name, table_name, uniqueness
FROM user_indexes
WHERE table_name IN ('USERS', 'PATIENTS', 'DOCTORS', 'APPOINTMENTS')
ORDER BY table_name, index_name;
```

### Check Stored Procedures

```sql
SELECT object_name, object_type, status
FROM user_objects
WHERE object_type IN ('PROCEDURE', 'FUNCTION', 'TRIGGER')
ORDER BY object_type, object_name;
```

---

## 🧹 Clear Test Data

```sql
-- WARNING: This deletes all data! Use carefully.
-- Run in this order to respect foreign keys

DELETE FROM payments;
DELETE FROM prescriptions;
DELETE FROM medical_records;
DELETE FROM bills;
DELETE FROM appointments;
DELETE FROM patients;
DELETE FROM doctors;
DELETE FROM users WHERE role != 'ADMIN';
DELETE FROM departments;

COMMIT;
```

---

## 🔄 Reload Sample Data

After clearing, run the sample data script:

```sql
@sql/02_insert_data.sql
```

---

## 📝 Notes

1. Replace `healthcare123` with your actual password
2. Use `XEPDB1` for Oracle 18c+ or `XE` for older versions
3. All queries assume the schema from `sql/01_create_tables.sql`
4. For the Flask mock data version, data is stored in memory (app.py)
