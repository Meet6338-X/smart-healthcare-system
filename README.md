# 🏥 Smart Healthcare Management System

A comprehensive **Database Management Systems (DBMS)** course project demonstrating database design, SQL, PL/SQL, transactions, indexing, and application integration.

## 📋 Project Overview

This project implements a Smart Healthcare Management System with the following modules:
- **Patient Management** - Registration, profiles, medical history
- **Doctor Management** - Profiles, specializations, schedules
- **Appointment Scheduling** - Book, cancel, view appointments
- **Medical Records** - Diagnosis, prescriptions, notes
- **Billing & Payments** - Invoice generation, payment tracking
- **User Roles** - Admin, Doctor, Patient access control

## 🛠️ Technology Stack

| Component | Technology |
|-----------|------------|
| Database | Oracle RDBMS |
| Language | SQL + PL/SQL |
| Backend | Python Flask |
| Frontend | HTML + CSS |
| DB Driver | cx_Oracle |

## 📁 Project Structure

```
smart-healthcare-system/
├── docs/                           # Documentation (15 files)
│   ├── 01_Project_Overview.md
│   ├── 02_ER_Diagram.md
│   ├── 03_Extended_ER_Diagram.md
│   ├── 04_Relational_Schema.md
│   ├── 05_Normalization.md
│   ├── 06_Functional_Dependencies.md
│   ├── 07_Relational_Algebra.md
│   ├── 08_SQL_Queries.md
│   ├── 09_PLSQL_Objects.md
│   ├── 10_Transactions_and_ACID.md
│   ├── 11_Indexing_and_Query_Optimization.md
│   ├── 12_Distributed_Database_Concepts.md
│   ├── 13_UI_Design.md
│   ├── 14_Backend_Design.md
│   └── 15_Viva_Questions.md
├── sql/                            # SQL Scripts
│   ├── 01_create_tables.sql        # DDL - Table creation
│   ├── 02_insert_data.sql          # DML - Sample data
│   └── 03_plsql_objects.sql        # Procedures, Functions, Triggers
├── templates/                      # HTML Templates
│   ├── base.html
│   ├── index.html
│   ├── login.html
│   ├── register.html
│   ├── book_appointment.html
│   └── dashboard.html
├── static/css/                     # Stylesheets
│   └── style.css
├── app.py                          # Flask Application
├── workhuman.md                    # Step-by-step DB setup guide
└── README.md                       # This file
```

## 🚀 Getting Started

### Prerequisites

1. **Oracle Database** - Oracle XE 18c/21c or Oracle 19c
2. **Python 3.8+**
3. **Oracle Instant Client** (for cx_Oracle)

### Database Setup

Follow the step-by-step guide in `workhuman.md` or run:

```bash
# Connect to Oracle as SYSDBA
sqlplus sys as sysdba

# Create user
CREATE USER healthcare_user IDENTIFIED BY healthcare123;
GRANT CONNECT, RESOURCE, UNLIMITED TABLESPACE TO healthcare_user;

# Connect as healthcare_user and run scripts
@sql/01_create_tables.sql
@sql/02_insert_data.sql
@sql/03_plsql_objects.sql
```

### Running the Application

```bash
# Create virtual environment
python -m venv venv

# Activate (Windows)
venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run Flask app
python app.py
```

Open http://localhost:5000 in your browser.

### Demo Credentials

| Role | Username | Password |
|------|----------|----------|
| Patient | patient_raj | pat123hash |
| Doctor | dr_sharma | doc123hash |
| Admin | admin1 | admin123hash |

## 📚 Documentation

Each documentation file covers specific DBMS concepts:

| File | Topic |
|------|-------|
| 01_Project_Overview | System architecture, modules |
| 02_ER_Diagram | Entities, relationships, cardinality |
| 03_Extended_ER_Diagram | Specialization/Generalization |
| 04_Relational_Schema | Tables, keys, constraints |
| 05_Normalization | 1NF → BCNF with examples |
| 06_Functional_Dependencies | FDs for all tables |
| 07_Relational_Algebra | Query expressions |
| 08_SQL_Queries | DDL, DML, JOINs, subqueries |
| 09_PLSQL_Objects | Procedures, Functions, Triggers |
| 10_Transactions_and_ACID | COMMIT/ROLLBACK, concurrency |
| 11_Indexing | B-Tree, Bitmap, optimization |
| 12_Distributed_Database | CAP theorem, fragmentation |
| 13_UI_Design | Wireframes, design system |
| 14_Backend_Design | Flask architecture |
| 15_Viva_Questions | 25+ Q&A for exam prep |

## 📊 DBMS Concepts Covered

- ✅ ER Modeling & EER
- ✅ Relational Schema Design
- ✅ Normalization (1NF - BCNF)
- ✅ Functional Dependencies
- ✅ Relational Algebra
- ✅ SQL DDL & DML
- ✅ JOINs & Subqueries
- ✅ PL/SQL Programming
- ✅ Triggers & Stored Procedures
- ✅ Transactions & ACID
- ✅ Indexing & Optimization
- ✅ Distributed Database Concepts

## 🎓 Academic Notes

This project is designed for a DBMS course and includes:
- Syllabus-aligned documentation
- Student-friendly explanations
- Exam-ready viva questions
- Well-commented code

## 📝 License

This project is created for educational purposes as part of a DBMS course project.

---

**Created with ❤️ for DBMS Learning**
