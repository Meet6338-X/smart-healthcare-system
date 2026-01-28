-- ============================================
-- Smart Healthcare Management System
-- PL/SQL Objects: Procedures, Functions, Triggers
-- Oracle RDBMS
-- ============================================

-- ============================================
-- PROCEDURE 1: Register New Patient
-- Purpose: Creates user account and patient record
-- ============================================

CREATE OR REPLACE PROCEDURE sp_register_patient (
    p_username      IN VARCHAR2,
    p_password      IN VARCHAR2,
    p_email         IN VARCHAR2,
    p_first_name    IN VARCHAR2,
    p_last_name     IN VARCHAR2,
    p_dob           IN DATE,
    p_gender        IN VARCHAR2,
    p_phone         IN VARCHAR2,
    p_address       IN VARCHAR2,
    p_city          IN VARCHAR2,
    p_blood_group   IN VARCHAR2,
    p_result        OUT VARCHAR2
)
AS
    v_user_id       NUMBER;
    v_patient_id    NUMBER;
BEGIN
    -- Step 1: Create user account
    INSERT INTO USERS (user_id, username, password_hash, email, role, status)
    VALUES (user_seq.NEXTVAL, p_username, p_password, p_email, 'PATIENT', 'ACTIVE')
    RETURNING user_id INTO v_user_id;
    
    -- Step 2: Create patient record
    INSERT INTO PATIENTS (
        patient_id, user_id, first_name, last_name, date_of_birth,
        gender, phone, address, city, blood_group
    )
    VALUES (
        patient_seq.NEXTVAL, v_user_id, p_first_name, p_last_name, p_dob,
        p_gender, p_phone, p_address, p_city, p_blood_group
    )
    RETURNING patient_id INTO v_patient_id;
    
    -- Commit transaction
    COMMIT;
    
    p_result := 'SUCCESS: Patient registered with ID ' || v_patient_id;
    
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        p_result := 'ERROR: Username or email already exists';
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END sp_register_patient;
/

-- ============================================
-- PROCEDURE 2: Book Appointment
-- Purpose: Books appointment with validations
-- ============================================

CREATE OR REPLACE PROCEDURE sp_book_appointment (
    p_patient_id    IN NUMBER,
    p_doctor_id     IN NUMBER,
    p_apt_date      IN DATE,
    p_apt_time      IN VARCHAR2,
    p_reason        IN VARCHAR2,
    p_result        OUT VARCHAR2
)
AS
    v_doctor_available  CHAR(1);
    v_existing_count    NUMBER;
    v_appointment_id    NUMBER;
BEGIN
    -- Validation 1: Check if doctor is available (general availability)
    SELECT available INTO v_doctor_available
    FROM DOCTORS WHERE doctor_id = p_doctor_id;
    
    IF v_doctor_available = 'N' THEN
        p_result := 'ERROR: Doctor is not available for appointments';
        RETURN;
    END IF;
    
    -- Validation 2: Check for time slot conflict
    SELECT COUNT(*) INTO v_existing_count
    FROM APPOINTMENTS
    WHERE doctor_id = p_doctor_id
      AND appointment_date = p_apt_date
      AND appointment_time = p_apt_time
      AND status NOT IN ('CANCELLED');
    
    IF v_existing_count > 0 THEN
        p_result := 'ERROR: This time slot is already booked';
        RETURN;
    END IF;
    
    -- Validation 3: Cannot book in past
    IF p_apt_date < TRUNC(SYSDATE) THEN
        p_result := 'ERROR: Cannot book appointment in the past';
        RETURN;
    END IF;
    
    -- Create appointment
    INSERT INTO APPOINTMENTS (
        appointment_id, patient_id, doctor_id, 
        appointment_date, appointment_time, status, reason
    )
    VALUES (
        appointment_seq.NEXTVAL, p_patient_id, p_doctor_id,
        p_apt_date, p_apt_time, 'SCHEDULED', p_reason
    )
    RETURNING appointment_id INTO v_appointment_id;
    
    COMMIT;
    p_result := 'SUCCESS: Appointment booked with ID ' || v_appointment_id;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_result := 'ERROR: Doctor not found';
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END sp_book_appointment;
/

-- ============================================
-- PROCEDURE 3: Cancel Appointment
-- Purpose: Cancels an existing appointment
-- ============================================

CREATE OR REPLACE PROCEDURE sp_cancel_appointment (
    p_appointment_id    IN NUMBER,
    p_patient_id        IN NUMBER,
    p_result            OUT VARCHAR2
)
AS
    v_current_status    VARCHAR2(20);
    v_apt_patient_id    NUMBER;
BEGIN
    -- Get current appointment details
    SELECT status, patient_id INTO v_current_status, v_apt_patient_id
    FROM APPOINTMENTS
    WHERE appointment_id = p_appointment_id;
    
    -- Validation: Check ownership
    IF v_apt_patient_id != p_patient_id THEN
        p_result := 'ERROR: You can only cancel your own appointments';
        RETURN;
    END IF;
    
    -- Validation: Can only cancel scheduled appointments
    IF v_current_status != 'SCHEDULED' THEN
        p_result := 'ERROR: Only SCHEDULED appointments can be cancelled';
        RETURN;
    END IF;
    
    -- Cancel the appointment
    UPDATE APPOINTMENTS
    SET status = 'CANCELLED'
    WHERE appointment_id = p_appointment_id;
    
    COMMIT;
    p_result := 'SUCCESS: Appointment cancelled';
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_result := 'ERROR: Appointment not found';
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END sp_cancel_appointment;
/

-- ============================================
-- FUNCTION 1: Calculate Patient Age
-- Purpose: Returns patient's age in years
-- ============================================

CREATE OR REPLACE FUNCTION fn_calculate_age (
    p_patient_id IN NUMBER
) RETURN NUMBER
AS
    v_dob   DATE;
    v_age   NUMBER;
BEGIN
    SELECT date_of_birth INTO v_dob
    FROM PATIENTS
    WHERE patient_id = p_patient_id;
    
    -- Calculate age in years
    v_age := FLOOR(MONTHS_BETWEEN(SYSDATE, v_dob) / 12);
    
    RETURN v_age;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN -1; -- Patient not found
    WHEN OTHERS THEN
        RETURN -2; -- Error occurred
END fn_calculate_age;
/

-- ============================================
-- FUNCTION 2: Get Pending Bill Amount
-- Purpose: Returns total unpaid amount for patient
-- ============================================

CREATE OR REPLACE FUNCTION fn_get_pending_amount (
    p_patient_id IN NUMBER
) RETURN NUMBER
AS
    v_total_pending NUMBER := 0;
BEGIN
    SELECT NVL(SUM(final_amount), 0) INTO v_total_pending
    FROM BILLS
    WHERE patient_id = p_patient_id
      AND status IN ('PENDING', 'PARTIAL');
    
    RETURN v_total_pending;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END fn_get_pending_amount;
/

-- ============================================
-- FUNCTION 3: Get Doctor Appointment Count
-- Purpose: Returns count of appointments for doctor
-- ============================================

CREATE OR REPLACE FUNCTION fn_get_doctor_appointment_count (
    p_doctor_id IN NUMBER,
    p_status    IN VARCHAR2 DEFAULT NULL
) RETURN NUMBER
AS
    v_count NUMBER := 0;
BEGIN
    IF p_status IS NULL THEN
        SELECT COUNT(*) INTO v_count
        FROM APPOINTMENTS
        WHERE doctor_id = p_doctor_id;
    ELSE
        SELECT COUNT(*) INTO v_count
        FROM APPOINTMENTS
        WHERE doctor_id = p_doctor_id
          AND status = p_status;
    END IF;
    
    RETURN v_count;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END fn_get_doctor_appointment_count;
/

-- ============================================
-- TRIGGER 1: Auto-Generate Bill
-- Purpose: Creates bill when appointment completed
-- ============================================

CREATE OR REPLACE TRIGGER trg_auto_generate_bill
AFTER UPDATE OF status ON APPOINTMENTS
FOR EACH ROW
WHEN (NEW.status = 'COMPLETED' AND OLD.status != 'COMPLETED')
DECLARE
    v_consultation_fee  NUMBER(10,2);
    v_bill_exists       NUMBER;
BEGIN
    -- Check if bill already exists
    SELECT COUNT(*) INTO v_bill_exists
    FROM BILLS WHERE appointment_id = :NEW.appointment_id;
    
    IF v_bill_exists = 0 THEN
        -- Get doctor's consultation fee
        SELECT consultation_fee INTO v_consultation_fee
        FROM DOCTORS WHERE doctor_id = :NEW.doctor_id;
        
        -- Create bill
        INSERT INTO BILLS (
            bill_id, appointment_id, patient_id,
            consultation_fee, total_amount, final_amount, status
        )
        VALUES (
            bill_seq.NEXTVAL, :NEW.appointment_id, :NEW.patient_id,
            v_consultation_fee, v_consultation_fee, v_consultation_fee, 'PENDING'
        );
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Log error (in production, use proper error logging table)
        NULL;
END;
/

-- ============================================
-- TRIGGER 2: Patient Audit Trail
-- Purpose: Logs changes to patient records
-- ============================================

CREATE OR REPLACE TRIGGER trg_patient_audit
AFTER UPDATE ON PATIENTS
FOR EACH ROW
BEGIN
    -- Log only if phone or address changed
    IF :OLD.phone != :NEW.phone OR NVL(:OLD.address, 'X') != NVL(:NEW.address, 'X') THEN
        INSERT INTO PATIENT_AUDIT_LOG (
            log_id, patient_id, action, changed_by,
            old_phone, new_phone, old_address, new_address
        )
        VALUES (
            audit_log_seq.NEXTVAL, :OLD.patient_id, 'UPDATE', USER,
            :OLD.phone, :NEW.phone, :OLD.address, :NEW.address
        );
    END IF;
END;
/

-- ============================================
-- TRIGGER 3: Validate Appointment Date
-- Purpose: Prevents booking in the past
-- ============================================

CREATE OR REPLACE TRIGGER trg_validate_appointment_date
BEFORE INSERT ON APPOINTMENTS
FOR EACH ROW
BEGIN
    IF :NEW.appointment_date < TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Cannot book appointment in the past');
    END IF;
END;
/

-- ============================================
-- Test the PL/SQL Objects
-- ============================================

-- Test Function: Calculate Age
SELECT 
    patient_id,
    first_name,
    last_name,
    fn_calculate_age(patient_id) AS age
FROM PATIENTS;

-- Test Function: Get Pending Amount
SELECT 
    patient_id,
    first_name,
    fn_get_pending_amount(patient_id) AS pending_amount
FROM PATIENTS;

-- Test Procedure: Book Appointment
DECLARE
    v_result VARCHAR2(200);
BEGIN
    sp_book_appointment(
        p_patient_id => 1,
        p_doctor_id  => 1,
        p_apt_date   => SYSDATE + 14,
        p_apt_time   => '04:00 PM',
        p_reason     => 'Follow-up consultation',
        p_result     => v_result
    );
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/

-- ============================================
-- Verify PL/SQL Objects Created
-- ============================================

SELECT object_name, object_type, status
FROM user_objects
WHERE object_type IN ('PROCEDURE', 'FUNCTION', 'TRIGGER')
ORDER BY object_type, object_name;

-- ============================================
-- End of PL/SQL Script
-- ============================================
