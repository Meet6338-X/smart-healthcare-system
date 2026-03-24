# 📐 UML Class Diagram

## 🎯 Smart Healthcare Management System - Class Diagram

This diagram represents the static structure of the system showing classes, their attributes, methods, and relationships.

```mermaid
classDiagram
    class Users {
        <<abstract>>
        -user_id: int
        -username: varchar
        -password_hash: varchar
        -email: varchar
        -role: varchar
        -created_at: date
        +login()
        +logout()
        +update_profile()
    }

    class Admins {
        -admin_id: int
        -admin_level: varchar
        -permissions: varchar
        -assigned_date: date
        +manage_users()
        +manage_system_config()
    }

    class Doctors {
        -doctor_id: int
        -specialization: varchar
        -license_number: varchar
        -experience_years: int
        -consultation_fee: decimal
        +view_schedule()
        +update_availability()
        +add_medical_record()
    }

    class Patients {
        -patient_id: int
        -date_of_birth: date
        -gender: varchar
        -blood_group: varchar
        -emergency_contact: varchar
        +book_appointment()
        +view_medical_records()
        +make_payment()
    }

    class Departments {
        -dept_id: int
        -dept_name: varchar
        -description: varchar
        -location: varchar
        +get_doctors()
        +get_dept_info()
    }

    class Appointments {
        -appointment_id: int
        -appointment_date: date
        -appointment_time: time
        -status: varchar
        -reason: varchar
        +schedule()
        +cancel()
        +reschedule()
        +complete()
    }

    class MedicalRecords {
        -record_id: int
        -diagnosis: varchar
        -notes: clob
        -record_date: date
        +add_diagnosis()
        +add_notes()
        +finalize_record()
    }

    class Prescriptions {
        -prescription_id: int
        -medicine_name: varchar
        -dosage: varchar
        -duration_days: int
        -instructions: varchar
        +validate_prescription()
        +print_prescription()
    }

    class Bills {
        -bill_id: int
        -total_amount: decimal
        -bill_date: date
        -status: varchar
        +calculate_total()
        +generate_bill()
        +update_status()
    }

    class Payments {
        -payment_id: int
        -amount_paid: decimal
        -payment_date: date
        -payment_method: varchar
        +process_payment()
        +generate_receipt()
        +refund_payment()
    }

    %% Relationships
    Users <|-- Admins : Inheritance
    Users <|-- Doctors : Inheritance
    Users <|-- Patients : Inheritance

    Departments "1" --* "0..*" Doctors : has >
    Patients "1" --* "0..*" Appointments : books >
    Doctors "1" --* "0..*" Appointments : attends >

    Appointments "1" --* "1" MedicalRecords : generates >
    MedicalRecords "1" --* "0..*" Prescriptions : contains >
    Appointments "1" --* "1" Bills : generates >
    Bills "1" --* "0..*" Payments : receives >

    %% Dependency relationships
    Admins ..> Users : manages
    Doctors ..> Patients : treats
    Patients ..> Doctors : consults
```

## 🔄 Sequence Diagram: Appointment Booking Flow

```mermaid
sequenceDiagram
    participant Patient as Patient/User
    participant Frontend as Frontend (HTML/JS)
    participant Backend as Backend (Flask)
    participant Database as Database (Oracle)
    participant PLSQL as PL/SQL Procedures

    Patient->>Frontend: Fill appointment form
    Frontend->>Backend: POST /book-appointment
    Backend->>Backend: Validate input
    Backend->>Database: Get departments & doctors
    Database-->>Backend: Return departments/doctors
    Backend-->>Frontend: Render booking form with data
    Patient->>Frontend: Select doctor, date, time
    Frontend->>Backend: POST booking data
    Backend->>Backend: Validate booking data
    Backend->>PLSQL: Call sp_safe_book_appointment
    PLSQL->>Database: SELECT FOR UPDATE time slot
    Database-->>PLSQL: Slot availability result
    alt Slot available
        PLSQL->>Database: INSERT appointment
        Database-->>PLSQL: Success
        PLSQL-->>Backend: SUCCESS message
        Backend-->>Frontend: Redirect to dashboard
        Frontend-->>Patient: Show success message
    else Slot booked
        PLSQL-->>Backend: ERROR: Slot booked
        Backend-->>Frontend: Show error
        Frontend-->>Patient: Show error message
    end
```

## 📊 Sequence Diagram: Payment Processing

```mermaid
sequenceDiagram
    participant Patient as Patient/User
    participant Frontend as Frontend (HTML/JS)
    participant Backend as Backend (Flask)
    participant Database as Database (Oracle)
    participant PLSQL as PL/SQL Procedures

    Patient->>Frontend: View bill
    Frontend->>Backend: GET bill details
    Backend->>Database: SELECT bill, appointment
    Database-->>Backend: Bill & appointment data
    Backend-->>Frontend: Display bill
    Patient->>Frontend: Enter payment details
    Frontend->>Backend: POST payment
    Backend->>Backend: Validate payment
    Backend->>PLSQL: Process payment procedure
    PLSQL->>Database: INSERT payment
    Database-->>PLSQL: Payment recorded
    PLSQL->>Database: UPDATE bill status
    Database-->>PLSQL: Bill updated
    PLSQL-->>Backend: Payment success
    Backend-->>Frontend: Payment confirmation
    Frontend-->>Patient: Show receipt
```

## 🏥 Component Diagram

```mermaid
graph TD
    %% Frontend Components
    subgraph Frontend[Frontend Layer]
        Index[Index/Home Page]
        Register[Registration Form]
        Login[Login Form]
        BookAppointment[Appointment Booking]
        Dashboard[User Dashboard]
        Style[CSS Styles]
        JS[JavaScript Validation]
    end

    %% Backend Components
    subgraph Backend[Backend Layer]
        FlaskApp[Flask Application]
        Routes[Route Handlers]
        DBManager[Database Manager]
        SessionMgr[Session Manager]
        Auth[Authentication Service]
        Validation[Input Validation]
    end

    %% Database Components
    subgraph Database[Database Layer]
        Tables[Database Tables]
        Procedures[PL/SQL Procedures]
        Triggers[Triggers]
        Indexes[Database Indexes]
        Sequences[Sequences]
    end

    %% Connections
    Index -->|HTTP| FlaskApp
    Register -->|HTTP| FlaskApp
    Login -->|HTTP| FlaskApp
    BookAppointment -->|HTTP| FlaskApp
    Dashboard -->|HTTP| FlaskApp

    FlaskApp --> Routes
    Routes --> DBManager
    Routes --> Auth
    Routes --> Validation
    DBManager --> Tables
    DBManager --> Procedures
    DBManager --> Triggers
    Auth --> Tables
    Validation --> Tables

    Style --> Index
    Style --> Register
    Style --> Login
    Style --> BookAppointment
    Style --> Dashboard
    JS --> Register
    JS --> Login
    JS --> BookAppointment
```

## 📋 Class Description Summary

| Class              | Responsibility        | Key Attributes                 | Key Methods                                   |
| ------------------ | --------------------- | ------------------------------ | --------------------------------------------- |
| **Users**          | Base user entity      | user_id, username, email, role | login(), logout(), update_profile()           |
| **Admins**         | System administrators | admin_level, permissions       | manage_users(), manage_system_config()        |
| **Doctors**        | Medical practitioners | specialization, license_number | view_schedule(), add_medical_record()         |
| **Patients**       | Healthcare recipients | date_of_blood, blood_group     | book_appointment(), make_payment()            |
| **Departments**    | Medical departments   | dept_name, location            | get_doctors(), get_dept_info()                |
| **Appointments**   | Scheduled visits      | date, time, status, reason     | schedule(), cancel(), complete()              |
| **MedicalRecords** | Visit documentation   | diagnosis, notes               | add_diagnosis(), finalize_record()            |
| **Prescriptions**  | Medication orders     | medicine_name, dosage          | validate_prescription(), print_prescription() |
| **Bills**          | Financial charges     | total_amount, status           | calculate_total(), generate_bill()            |
| **Payments**       | Payment transactions  | amount, method                 | process_payment(), generate_receipt()         |

## 🔗 Relationships Explained

1. **Inheritance**: Admins, Doctors, and Patients inherit from Users (using single table with discriminator)
2. **Composition**: Departments compose Doctors (1:many relationship)
3. **Association**: Patients and Doctors associate through Appointments
4. **Dependency**: Appointments generate MedicalRecords and Bills
5. **Aggregation**: Bills receive multiple Payments

> **📝 DBMS Concept:** UML class diagrams provide a static view of the system, showing the classes, their attributes, operations, and the relationships among objects. This helps in understanding the system structure and serves as a blueprint for implementation.
