# Assignment 8: Database Views

## 1. Simple Views (Updatable)
A simple view is based on a single table and does not contain functions or grouping. It is generally updatable.

### Create Simple View
View to show only 'Cardiology' doctors.

```sql
CREATE OR REPLACE VIEW view_cardio_doctors AS
SELECT doctor_id, first_name, last_name, consultation_fee, dept_id
FROM DOCTORS
WHERE dept_id = 1; -- Assuming 1 is Cardiology
```

### Update Base Table via View
We can update the consultation fee of a doctor through this view.

```sql
-- Update fee for a doctor in the view
UPDATE view_cardio_doctors
SET consultation_fee = 850
WHERE doctor_id = 1;

-- Verify change in base table
SELECT doctor_id, consultation_fee FROM DOCTORS WHERE doctor_id = 1;
```

## 2. Complex Views (Read-Only by Default)
A complex view involves multiple tables (joins), aggregate functions, or distinct clauses. These are generally not updatable directly.

### Create Complex View (Multiple Tables)
View to show Appointment details with Patient and Doctor names.

```sql
CREATE OR REPLACE VIEW view_appointment_details AS
SELECT a.appointment_id, 
       p.first_name || ' ' || p.last_name AS patient_name,
       d.first_name || ' ' || d.last_name AS doctor_name,
       a.appointment_date, 
       a.status
FROM APPOINTMENTS a
JOIN PATIENTS p ON a.patient_id = p.patient_id
JOIN DOCTORS d ON a.doctor_id = d.doctor_id;
```

## 3. Restrictions on Updatable Views
You cannot perform DML operations on a view if it contains:
1.  Group functions (SUM, ACG, etc.)
2.  `GROUP BY` or `DISTINCT` clauses
3.  Joins (in most cases, unless Key-Preserved Table rule is met)
4.  Columns defined by expressions (e.g., `salary * 12`)

### Demonstration of Restriction
Attempting to update the complex view above will likely fail if it maps to multiple tables ambiguously or involves expressions.

```sql
-- This might fail or be restricted depending on the exact join structure and key preservation
-- UPDATE view_appointment_details 
-- SET patient_name = 'New Name' 
-- WHERE appointment_id = 1;
-- Error: ORA-01779: cannot modify a column which maps to a non key-preserved table
```

## 4. INSTEAD OF Triggers (Making Complex Views Updatable)
To allow updates on complex views, we use `INSTEAD OF` triggers.

```sql
CREATE OR REPLACE TRIGGER trg_update_appt_view
INSTEAD OF UPDATE ON view_appointment_details
FOR EACH ROW
BEGIN
    -- Update the base APPOINTMENTS table
    UPDATE APPOINTMENTS
    SET status = :NEW.status,
        appointment_date = :NEW.appointment_date
    WHERE appointment_id = :OLD.appointment_id;
    
    -- Note: Updating Patient/Doctor names here would require separate UPDATEs to those tables
    -- and is generally avoided to prevent modifying master data unintentionally.
END;
/
```

### Testing the INSTEAD OF Trigger
```sql
-- Now this update will work (it updates the underlying APPOINTMENTS table)
UPDATE view_appointment_details
SET status = 'COMPLETED'
WHERE appointment_id = 1;
```
