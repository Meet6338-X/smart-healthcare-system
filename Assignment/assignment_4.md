# Assignment 4: Joins & Subqueries

## 1. Join Queries

### Equi Join
```sql
-- List Patient Name and Doctor Name for each appointment
SELECT p.first_name AS patient_name, d.first_name AS doctor_name, a.appointment_date
FROM APPOINTMENTS a
JOIN PATIENTS p ON a.patient_id = p.patient_id
JOIN DOCTORS d ON a.doctor_id = d.doctor_id;

-- List Doctors and their Department Names
SELECT d.first_name, d.last_name, dept.dept_name
FROM DOCTORS d
JOIN DEPARTMENTS dept ON d.dept_id = dept.dept_id;
```

### Non-Equi Join
```sql
-- Find doctors whose consultation fee is within a specific budget range table
-- (Assuming a hypothetical SALARY_GRADES table exists for demo)
-- SELECT d.last_name, d.consultation_fee, g.grade
-- FROM DOCTORS d, FEE_GRADES g
-- WHERE d.consultation_fee BETWEEN g.min_fee AND g.max_fee;

-- Without extra table: Show pairings of doctors where one charges more than the other
SELECT d1.last_name AS doc_higher, d2.last_name AS doc_lower
FROM DOCTORS d1
JOIN DOCTORS d2 ON d1.consultation_fee > d2.consultation_fee;
```

### Self Join
```sql
-- If doctors had a mentor/supervisor in the same table
-- (Assuming supervisor_id exists in DOCTORS table)
-- SELECT worker.last_name, manager.last_name
-- FROM DOCTORS worker
-- JOIN DOCTORS manager ON worker.supervisor_id = manager.doctor_id;

-- Find doctors in the same department
SELECT d1.first_name AS doctor_1, d2.first_name AS doctor_2, d1.dept_id
FROM DOCTORS d1
JOIN DOCTORS d2 ON d1.dept_id = d2.dept_id
WHERE d1.doctor_id < d2.doctor_id;
```

### Outer Join (Left, Right, Full)
```sql
-- Left Outer Join: List all Departments and their doctors (including empty departments)
SELECT dept.dept_name, d.last_name
FROM DEPARTMENTS dept
LEFT JOIN DOCTORS d ON dept.dept_id = d.dept_id;

-- Right Outer Join: List all Patients and their appointments (if any)
SELECT p.last_name, a.appointment_date
FROM APPOINTMENTS a
RIGHT JOIN PATIENTS p ON a.patient_id = p.patient_id;

-- Full Outer Join: List all appointments and bills, showing missing matches
SELECT a.appointment_id, b.bill_id
FROM APPOINTMENTS a
FULL JOIN BILLS b ON a.appointment_id = b.appointment_id;
```

## 2. Subqueries

### Single Row Subqueries (=, >, <)
```sql
-- Find doctors who charge more than the average consultation fee
SELECT first_name, last_name, consultation_fee
FROM DOCTORS
WHERE consultation_fee > (SELECT AVG(consultation_fee) FROM DOCTORS);

-- Find the patient who booked the last appointment
SELECT first_name, last_name
FROM PATIENTS
WHERE patient_id = (SELECT patient_id FROM APPOINTMENTS 
                    WHERE appointment_id = (SELECT MAX(appointment_id) FROM APPOINTMENTS));
```

### Multiple Row Subqueries (IN, ANY, ALL)
```sql
-- List doctors who are in departments located in 'Building A'
SELECT first_name, last_name
FROM DOCTORS
WHERE dept_id IN (SELECT dept_id FROM DEPARTMENTS WHERE location LIKE 'Building A%');

-- List doctors whose fee is higher than ALL doctors in 'Orthopedics' (id=2)
SELECT first_name, last_name, consultation_fee
FROM DOCTORS
WHERE consultation_fee > ALL (SELECT consultation_fee FROM DOCTORS WHERE dept_id = 2);

-- List patients who have ANY appointment status as 'CANCELLED'
SELECT first_name, last_name
FROM PATIENTS
WHERE patient_id = ANY (SELECT patient_id FROM APPOINTMENTS WHERE status = 'CANCELLED');
```

### Correlated Subqueries (EXISTS)
```sql
-- List departments that have at least one doctor
SELECT dept_name
FROM DEPARTMENTS d
WHERE EXISTS (SELECT 1 FROM DOCTORS doc WHERE doc.dept_id = d.dept_id);

-- List patients who have never booked an appointment
SELECT first_name, last_name
FROM PATIENTS p
WHERE NOT EXISTS (SELECT 1 FROM APPOINTMENTS a WHERE a.patient_id = p.patient_id);
```

## 3. DML with Subqueries

```sql
-- Increase fee by 10% for doctors in 'Cardiology' department
UPDATE DOCTORS
SET consultation_fee = consultation_fee * 1.10
WHERE dept_id = (SELECT dept_id FROM DEPARTMENTS WHERE dept_name = 'Cardiology');

-- Delete appointments for patients who are inactive (using subquery)
-- DELETE FROM APPOINTMENTS
-- WHERE patient_id IN (SELECT user_id FROM USERS WHERE status = 'INACTIVE');
-- (Note: Patient ID and User ID mapping requires join, simplified logic shown)
```

## 4. Query Processing Strategies

Query processing involves translating high-level queries (SQL) into low-level operations.
1.  **Parsing and Translation**: Syntax check and converting to relational algebra.
2.  **Optimization**: Choosing the most efficient execution plan (using indexes, statistics).
3.  **Evaluation**: Executing the plan and retrieving data.

**Key strategies include**:
*   **Selection**: Using indices (B-tree, Hash) vs Full Table Scan.
*   **Sorting**: External merge sort is common for large datasets.
*   **Join Methods**: Nested Loop Join, Merge Join, Hash Join.
