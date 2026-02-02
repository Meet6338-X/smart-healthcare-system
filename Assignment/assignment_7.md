# Assignment 7: Database Triggers

## 1. Row-Level Triggers
Row-level triggers fire once for each row affected by the DML statement.

### Audit Trigger (BEFORE UPDATE)
This trigger logs changes made to the `PATIENTS` table into the `PATIENT_AUDIT_LOG` table.

```sql
CREATE OR REPLACE TRIGGER trg_patient_audit
BEFORE UPDATE ON PATIENTS
FOR EACH ROW
BEGIN
    INSERT INTO PATIENT_AUDIT_LOG (
        log_id, 
        patient_id, 
        action, 
        changed_by, 
        change_date, 
        old_phone, 
        new_phone, 
        old_address, 
        new_address
    ) VALUES (
        audit_log_seq.NEXTVAL, 
        :OLD.patient_id, 
        'UPDATE', 
        USER, 
        SYSDATE, 
        :OLD.phone, 
        :NEW.phone, 
        :OLD.address, 
        :NEW.address
    );
END;
/
```
*Effect: When a patient's phone or address is updated, the old values are saved in the audit log.*

### Auto-Generate Email Trigger (BEFORE INSERT)
Ensures every new user has an email address if not provided (sets a default placeholder).

```sql
CREATE OR REPLACE TRIGGER trg_user_email_check
BEFORE INSERT ON USERS
FOR EACH ROW
BEGIN
    IF :NEW.email IS NULL THEN
        :NEW.email := :NEW.username || '@hospital.com';
    END IF;
END;
/
```

## 2. Statement-Level Triggers
Statement-level triggers fire once for the entire DML statement, regardless of how many rows are affected.

### Weekend Restriction Trigger (BEFORE INSERT/UPDATE/DELETE)
Prevents modifications to the `DOCTORS` table on weekends.

```sql
CREATE OR REPLACE TRIGGER trg_secure_doctors
BEFORE INSERT OR UPDATE OR DELETE ON DOCTORS
BEGIN
    IF TO_CHAR(SYSDATE, 'DY') IN ('SAT', 'SUN') THEN
        RAISE_APPLICATION_ERROR(-20005, 'Modifications to Doctor records are not allowed on weekends.');
    END IF;
END;
/
```

### After Statement Trigger
Logs a summary after a bulk update on appointments.

```sql
CREATE OR REPLACE TRIGGER trg_appt_update_log
AFTER UPDATE ON APPOINTMENTS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Appointments table was updated successfully at ' || TO_CHAR(SYSDATE, 'HH24:MI:SS'));
END;
/
```

## 3. Testing the Triggers

```sql
-- Test 1: Update Patient (Triggers trg_patient_audit)
UPDATE PATIENTS 
SET phone = '9999999999' 
WHERE patient_id = 1;

-- Verify Audit Log
SELECT * FROM PATIENT_AUDIT_LOG ORDER BY log_id DESC;

-- Test 2: Insert User without Email (Triggers trg_user_email_check)
INSERT INTO USERS (user_id, username, password_hash, role) 
VALUES (user_seq.NEXTVAL, 'nurse_joy', 'hash123', 'ADMIN'); -- Email is NULL

-- Verify Email Generation
SELECT username, email FROM USERS WHERE username = 'nurse_joy';

-- Test 3: Try to update Doctor on Weekend (Triggers trg_secure_doctors)
-- (This will fail if today is Saturday or Sunday)
-- UPDATE DOCTORS SET consultation_fee = 1000 WHERE doctor_id = 1;
```
