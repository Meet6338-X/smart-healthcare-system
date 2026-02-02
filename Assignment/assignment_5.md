# Assignment 5: PL/SQL Cursors

## 1. Implicit Cursors (SQL%FOUND, SQL%ROWCOUNT)
Implicit cursors are automatically created by Oracle for DML statements (`INSERT`, `UPDATE`, `DELETE`) and single-row `SELECT INTO`.

```sql
DECLARE
    v_rows_updated NUMBER;
BEGIN
    -- Update Consultation Fee for a specific doctor
    UPDATE DOCTORS 
    SET consultation_fee = consultation_fee + 50 
    WHERE dept_id = 1;
    
    -- Check how many rows were affected
    IF SQL%FOUND THEN
        v_rows_updated := SQL%ROWCOUNT;
        DBMS_OUTPUT.PUT_LINE('Total doctors updated: ' || v_rows_updated);
    ELSE
        DBMS_OUTPUT.PUT_LINE('No doctors found for the given department.');
    END IF;
END;
/
```

## 2. Explicit Cursors
Explicit cursors are defined by the programmer for queries that return multiple rows.

```sql
DECLARE
    -- Declare the cursor
    CURSOR c_patients IS 
        SELECT first_name, last_name, phone FROM PATIENTS;
        
    v_fname PATIENTS.first_name%TYPE;
    v_lname PATIENTS.last_name%TYPE;
    v_phone PATIENTS.phone%TYPE;
BEGIN
    -- Open the cursor
    OPEN c_patients;
    
    LOOP
        -- Fetch data into variables
        FETCH c_patients INTO v_fname, v_lname, v_phone;
        
        -- Exit when no more rows
        EXIT WHEN c_patients%NOTFOUND;
        
        -- Process the data
        DBMS_OUTPUT.PUT_LINE('Patient: ' || v_fname || ' ' || v_lname || ' - Contact: ' || v_phone);
    END LOOP;
    
    -- Close the cursor
    CLOSE c_patients;
END;
/
```

## 3. Cursor FOR Loop
A Cursor FOR Loop simplifies processing by automatically opening, fetching, and closing the cursor.

```sql
DECLARE
    CURSOR c_appointments IS 
        SELECT appointment_id, status, appointment_date 
        FROM APPOINTMENTS 
        WHERE status = 'SCHEDULED';
BEGIN
    -- Loop automatically handles OPEN, FETCH, CLOSE
    FOR r_appt IN c_appointments LOOP
        DBMS_OUTPUT.PUT_LINE('Appointment ID: ' || r_appt.appointment_id || 
                             ' Date: ' || r_appt.appointment_date || 
                             ' is currently scheduled.');
    END LOOP;
END;
/
```

## 4. Parameterized Cursors
Cursors can accept parameters to make them dynamic and reusable.

```sql
DECLARE
    -- Declare cursor with parameter
    CURSOR c_doctors_by_dept(p_dept_id NUMBER) IS 
        SELECT first_name, last_name, specialization 
        FROM DOCTORS 
        WHERE dept_id = p_dept_id;
        
    v_dept_id DEPARTMENTS.dept_id%TYPE := 1; -- Example: Cardiology
BEGIN
    DBMS_OUTPUT.PUT_LINE('Doctors in Department ' || v_dept_id || ':');
    
    -- Open cursor with argument
    FOR r_doc IN c_doctors_by_dept(v_dept_id) LOOP
        DBMS_OUTPUT.PUT_LINE('- ' || r_doc.first_name || ' ' || r_doc.last_name || 
                             ' (' || r_doc.specialization || ')');
    END LOOP;
    
    -- We can reuse the same cursor for a different department
    v_dept_id := 2; -- Orthopedics
    DBMS_OUTPUT.PUT_LINE('Doctors in Department ' || v_dept_id || ':');
    
    FOR r_doc IN c_doctors_by_dept(v_dept_id) LOOP
        DBMS_OUTPUT.PUT_LINE('- ' || r_doc.first_name || ' ' || r_doc.last_name || 
                             ' (' || r_doc.specialization || ')');
    END LOOP;
END;
/
```
