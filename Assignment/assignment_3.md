# Assignment 3: SELECT Queries & Functions

## 1. Filter Queries (WHERE Clause)

### Conditional & Logical Operators
```sql
-- List doctors with consultation fee greater than 500 AND experience more than 5 years
SELECT first_name, last_name, consultation_fee, experience_years
FROM DOCTORS
WHERE consultation_fee > 500 AND experience_years > 5;

-- List patients who are either Male OR live in Mumbai
SELECT first_name, last_name, gender, city
FROM PATIENTS
WHERE gender = 'Male' OR city = 'Mumbai';
```

### LIKE / NOT LIKE
```sql
-- Find doctors whose specialization starts with 'Cardio'
SELECT first_name, last_name, specialization
FROM DOCTORS
WHERE specialization LIKE 'Cardio%';

-- Find patients whose name does NOT contain 'man'
SELECT first_name, last_name
FROM PATIENTS
WHERE last_name NOT LIKE '%man%';
```

### IN / NOT IN
```sql
-- List patients from specific cities
SELECT first_name, last_name, city
FROM PATIENTS
WHERE city IN ('Mumbai', 'Delhi', 'Pune');

-- List doctors NOT in specific departments (IDs 1 and 2)
SELECT first_name, last_name, dept_id
FROM DOCTORS
WHERE dept_id NOT IN (1, 2);
```

### BETWEEN ... AND
```sql
-- List appointments scheduled in the next 7 days
SELECT appointment_id, appointment_date, status
FROM APPOINTMENTS
WHERE appointment_date BETWEEN SYSDATE AND SYSDATE + 7;

-- List bills with total amount between 500 and 1000
SELECT bill_id, total_amount, status
FROM BILLS
WHERE total_amount BETWEEN 500 AND 1000;
```

### IS NULL / IS NOT NULL
```sql
-- List patients who do NOT have an emergency contact number
SELECT first_name, last_name
FROM PATIENTS
WHERE emergency_contact IS NULL;

-- List doctors who have a license number (should be all, but for demo)
SELECT first_name, last_name, license_number
FROM DOCTORS
WHERE license_number IS NOT NULL;
```

## 2. Sorting and Grouping

### ORDER BY
```sql
-- List doctors sorted by consultation fee (High to Low)
SELECT first_name, last_name, consultation_fee
FROM DOCTORS
ORDER BY consultation_fee DESC;

-- List patients sorted by City then Name
SELECT city, first_name, last_name
FROM PATIENTS
ORDER BY city ASC, first_name ASC;
```

### GROUP BY & Aggregate Functions
```sql
-- Count number of doctors per department
SELECT dept_id, COUNT(*) AS doctor_count
FROM DOCTORS
GROUP BY dept_id;

-- Calculate average consultation fee per specialization
SELECT specialization, AVG(consultation_fee) AS avg_fee
FROM DOCTORS
GROUP BY specialization;

-- Calculate total revenue from paid bills
SELECT SUM(final_amount) AS total_revenue
FROM BILLS
WHERE status = 'PAID';
```

### HAVING Clause
```sql
-- List cities with more than 5 patients
SELECT city, COUNT(*)
FROM PATIENTS
GROUP BY city
HAVING COUNT(*) > 5;

-- List departments where average doctor experience is less than 5 years
SELECT dept_id, AVG(experience_years)
FROM DOCTORS
GROUP BY dept_id
HAVING AVG(experience_years) < 5;
```

## 3. Set Operators

### UNION / UNION ALL
```sql
-- List names of all doctors and patients in a single list
SELECT first_name, last_name, 'Doctor' AS type FROM DOCTORS
UNION
SELECT first_name, last_name, 'Patient' AS type FROM PATIENTS;
```

### INTERSECT
```sql
-- Find cities where both Doctors and Patients reside (Assuming Doctors have city column in extended design, using simplified example)
-- Ideally: SELECT city FROM DOCTORS INTERSECT SELECT city FROM PATIENTS;
-- Given schema: List user_ids that are both in DOCTORS and PATIENTS (Should be none technically, but syntax valid)
SELECT user_id FROM DOCTORS
INTERSECT
SELECT user_id FROM PATIENTS;
```

### MINUS
```sql
-- List Departments that have NO doctors assigned
SELECT dept_id FROM DEPARTMENTS
MINUS
SELECT dept_id FROM DOCTORS;
```

## 4. Single Row Functions

### String Functions
```sql
-- Convert names to uppercase and concatenate
SELECT UPPER(first_name) || ' ' || UPPER(last_name) AS full_name
FROM PATIENTS;

-- Extract first 3 characters of specialization
SELECT SUBSTR(specialization, 1, 3) AS spec_code
FROM DOCTORS;
```

### Date Functions
```sql
-- Calculate patient age
SELECT first_name, ROUND((SYSDATE - date_of_birth)/365.25, 0) AS age
FROM PATIENTS;

-- Extract month from appointment date
SELECT appointment_id, TO_CHAR(appointment_date, 'Month') AS appt_month
FROM APPOINTMENTS;
```

### Numerical Functions
```sql
-- Round consultation fee to nearest integer
SELECT consultation_fee, ROUND(consultation_fee) AS rounded_fee
FROM DOCTORS;

-- Calculate potential discount (10%)
SELECT total_amount, total_amount * 0.10 AS discount_value
FROM BILLS;
```
