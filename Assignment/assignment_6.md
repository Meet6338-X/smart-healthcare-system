# Assignment 6: Stored Procedures & Functions

## 1. Stored Procedures
Procedures are named PL/SQL blocks that perform specific actions.

### Procedure to Book an Appointment
This procedure checks if a doctor is available before booking.

```sql
CREATE OR REPLACE PROCEDURE book_appointment (
    p_patient_id IN NUMBER,
    p_doctor_id IN NUMBER,
    p_date IN DATE,
    p_time IN VARCHAR2,
    p_reason IN VARCHAR2
) IS
    v_available CHAR(1);
    v_appt_count NUMBER;
BEGIN
    -- Check if doctor is active/available
    SELECT available INTO v_available 
    FROM DOCTORS WHERE doctor_id = p_doctor_id;
    
    IF v_available = 'N' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Doctor is not available for consultation.');
    END IF;

    -- Check for double booking (simple check)
    SELECT COUNT(*) INTO v_appt_count 
    FROM APPOINTMENTS 
    WHERE doctor_id = p_doctor_id 
    AND appointment_date = p_date 
    AND appointment_time = p_time
    AND status != 'CANCELLED';
    
    IF v_appt_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Slot is already booked.');
    END IF;

    -- Insert new appointment
    INSERT INTO APPOINTMENTS (appointment_id, patient_id, doctor_id, appointment_date, appointment_time, status, reason)
    VALUES (appointment_seq.NEXTVAL, p_patient_id, p_doctor_id, p_date, p_time, 'SCHEDULED', p_reason);
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Appointment booked successfully!');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Invalid Doctor ID.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
```

### Procedure to Generate Bill
Auto-calculates the bill based on doctor fees.

```sql
CREATE OR REPLACE PROCEDURE generate_bill (
    p_appointment_id IN NUMBER
) IS
    v_doc_fee NUMBER;
    v_patient_id NUMBER;
    v_exists NUMBER;
BEGIN
    -- Check if bill already exists
    SELECT COUNT(*) INTO v_exists FROM BILLS WHERE appointment_id = p_appointment_id;
    
    IF v_exists > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Bill already exists for this appointment.');
        RETURN;
    END IF;

    -- Get Doctor Fee and Patient ID
    SELECT d.consultation_fee, a.patient_id
    INTO v_doc_fee, v_patient_id
    FROM APPOINTMENTS a
    JOIN DOCTORS d ON a.doctor_id = d.doctor_id
    WHERE a.appointment_id = p_appointment_id;
    
    -- Insert Bill
    INSERT INTO BILLS (bill_id, appointment_id, patient_id, consultation_fee, total_amount, status, bill_date)
    VALUES (bill_seq.NEXTVAL, p_appointment_id, v_patient_id, v_doc_fee, v_doc_fee, 'PENDING', SYSDATE);
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Bill generated with Amount: ' || v_doc_fee);
END;
/
```

## 2. Stored Functions
Functions are named PL/SQL blocks that must return a value.

### Function to Calculate Doctor's Total Revenue
Computes the total earnings of a doctor from paid bills.

```sql
CREATE OR REPLACE FUNCTION get_doctor_revenue (
    p_doctor_id IN NUMBER
) RETURN NUMBER IS
    v_total_revenue NUMBER := 0;
BEGIN
    SELECT NVL(SUM(b.final_amount), 0)
    INTO v_total_revenue
    FROM BILLS b
    JOIN APPOINTMENTS a ON b.appointment_id = a.appointment_id
    WHERE a.doctor_id = p_doctor_id
    AND b.status = 'PAID';
    
    RETURN v_total_revenue;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END;
/
```

### Function to Get Patient Age
Calculates precise age from DOB.

```sql
CREATE OR REPLACE FUNCTION get_patient_age (
    p_patient_id IN NUMBER
) RETURN NUMBER IS
    v_dob DATE;
    v_age NUMBER;
BEGIN
    SELECT date_of_birth INTO v_dob 
    FROM PATIENTS 
    WHERE patient_id = p_patient_id;
    
    v_age := FLOOR(MONTHS_BETWEEN(SYSDATE, v_dob) / 12);
    
    RETURN v_age;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN -1; -- Indicator for invalid patient
END;
/
```

### Execution Example
```sql
DECLARE
    v_rev NUMBER;
    v_age NUMBER;
BEGIN
    -- Call Procedure
    book_appointment(1, 1, SYSDATE+5, '04:00 PM', 'Follow-up checkup');
    
    -- Call Function
    v_rev := get_doctor_revenue(1);
    DBMS_OUTPUT.PUT_LINE('Total Revenue for Doctor 1: ' || v_rev);
    
    v_age := get_patient_age(1);
    DBMS_OUTPUT.PUT_LINE('Age of Patient 1: ' || v_age);
END;
/
```
