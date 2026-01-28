# 🌐 Distributed Database Concepts

## 🎯 What is a Distributed Database?

A **Distributed Database** is a collection of logically related databases spread across multiple physical locations, connected by a network.

---

## 📊 Distributed vs Centralized

```mermaid
graph TB
    subgraph "Centralized Database"
        C[(Central DB)]
        U1[User 1] --> C
        U2[User 2] --> C
        U3[User 3] --> C
    end
    
    subgraph "Distributed Database"
        D1[(Site 1:<br/>Mumbai)]
        D2[(Site 2:<br/>Delhi)]
        D3[(Site 3:<br/>Bangalore)]
        
        D1 <--> D2
        D2 <--> D3
        D1 <--> D3
        
        U4[Local User] --> D1
        U5[Local User] --> D2
        U6[Local User] --> D3
    end
    
    style C fill:#FF9800,color:#fff
    style D1 fill:#4CAF50,color:#fff
    style D2 fill:#2196F3,color:#fff
    style D3 fill:#9C27B0,color:#fff
```

---

## 📋 Types of Distributed Databases

### 1. Homogeneous

All sites use the **same DBMS** (e.g., all Oracle)

```mermaid
graph LR
    O1[(Oracle<br/>Site 1)] <--> O2[(Oracle<br/>Site 2)] <--> O3[(Oracle<br/>Site 3)]
    
    style O1 fill:#F44336,color:#fff
    style O2 fill:#F44336,color:#fff
    style O3 fill:#F44336,color:#fff
```

### 2. Heterogeneous

Different sites use **different DBMS** (e.g., Oracle, MySQL, PostgreSQL)

```mermaid
graph LR
    O[(Oracle)] <--> M[(MySQL)] <--> P[(PostgreSQL)]
    
    style O fill:#F44336,color:#fff
    style M fill:#4CAF50,color:#fff
    style P fill:#2196F3,color:#fff
```

---

## 🏥 Healthcare System - Distributed Scenario

### Scenario: Multi-Hospital System

```mermaid
graph TB
    subgraph "Mumbai Hospital"
        M_DB[(Mumbai DB)]
        M_PAT[Patients: MUM001-MUM999]
        M_DOC[Doctors: Mumbai Staff]
    end
    
    subgraph "Delhi Hospital"
        D_DB[(Delhi DB)]
        D_PAT[Patients: DEL001-DEL999]
        D_DOC[Doctors: Delhi Staff]
    end
    
    subgraph "Central HQ"
        C_DB[(Central DB)]
        C_RPT[Consolidated Reports]
        C_USR[Admin Users]
    end
    
    M_DB <-->|Sync| C_DB
    D_DB <-->|Sync| C_DB
    
    style M_DB fill:#4CAF50,color:#fff
    style D_DB fill:#2196F3,color:#fff
    style C_DB fill:#FF9800,color:#fff
```

---

## 📊 Data Fragmentation

### 1. Horizontal Fragmentation (Row-based)

Split table by **rows** based on a condition.

```sql
-- Mumbai fragment (patients from Mumbai)
CREATE TABLE PATIENTS_MUMBAI AS
SELECT * FROM PATIENTS WHERE city = 'Mumbai';

-- Delhi fragment (patients from Delhi)
CREATE TABLE PATIENTS_DELHI AS
SELECT * FROM PATIENTS WHERE city = 'Delhi';
```

### 2. Vertical Fragmentation (Column-based)

Split table by **columns**.

```sql
-- Personal info fragment
CREATE TABLE PATIENTS_PERSONAL AS
SELECT patient_id, first_name, last_name, phone, address, city
FROM PATIENTS;

-- Medical info fragment
CREATE TABLE PATIENTS_MEDICAL AS
SELECT patient_id, blood_group, emergency_contact
FROM PATIENTS;
```

### 3. Mixed Fragmentation

Combination of horizontal and vertical.

```mermaid
graph TD
    subgraph "Original PATIENTS Table"
        P[All Columns, All Rows]
    end
    
    subgraph "Vertical Split"
        VP1[Personal Columns]
        VP2[Medical Columns]
    end
    
    subgraph "Horizontal Split"
        HP1[Mumbai Rows]
        HP2[Delhi Rows]
    end
    
    P --> VP1
    P --> VP2
    VP1 --> HP1
    VP1 --> HP2
    
    style P fill:#9C27B0,color:#fff
```

---

## 🔄 Data Replication

### Types of Replication

| Type | Description | Use Case |
|------|-------------|----------|
| **Full Replication** | Complete copy at all sites | High availability |
| **Partial Replication** | Some data at some sites | Balanced approach |
| **No Replication** | Each data item at one site only | Storage efficiency |

### Replication Strategies

```mermaid
graph LR
    subgraph "Synchronous"
        S_M[Master] -->|Immediate| S_S1[Slave 1]
        S_M -->|Immediate| S_S2[Slave 2]
    end
    
    subgraph "Asynchronous"
        A_M[Master] -->|Delayed| A_S1[Slave 1]
        A_M -->|Delayed| A_S2[Slave 2]
    end
    
    style S_M fill:#4CAF50,color:#fff
    style A_M fill:#FF9800,color:#fff
```

---

## 📊 Distributed Query Processing

### Query Example

```sql
-- Query spanning multiple sites
SELECT p.first_name, a.appointment_date, d.first_name AS doctor_name
FROM PATIENTS@MUMBAI_DB p
JOIN APPOINTMENTS@CENTRAL_DB a ON p.patient_id = a.patient_id
JOIN DOCTORS@DELHI_DB d ON a.doctor_id = d.doctor_id
WHERE a.appointment_date >= SYSDATE;
```

### Query Processing Steps

```mermaid
flowchart TD
    A[Query Submitted] --> B[Query Parser]
    B --> C[Query Optimizer]
    C --> D{Data Location?}
    D -->|Site 1| E1[Execute at Site 1]
    D -->|Site 2| E2[Execute at Site 2]
    D -->|Site 3| E3[Execute at Site 3]
    E1 --> F[Combine Results]
    E2 --> F
    E3 --> F
    F --> G[Return to User]
```

---

## 🔐 Distributed Transaction Management

### Two-Phase Commit (2PC)

```mermaid
sequenceDiagram
    participant C as Coordinator
    participant S1 as Site 1
    participant S2 as Site 2
    
    Note over C,S2: Phase 1: Prepare
    C->>S1: PREPARE
    C->>S2: PREPARE
    S1->>C: READY
    S2->>C: READY
    
    Note over C,S2: Phase 2: Commit
    C->>S1: COMMIT
    C->>S2: COMMIT
    S1->>C: ACK
    S2->>C: ACK
```

### Phase 1: Prepare
- Coordinator asks all sites if they can commit
- Sites respond with READY or ABORT

### Phase 2: Commit/Abort
- If all sites READY → Send COMMIT
- If any site ABORT → Send ROLLBACK

---

## 📋 CAP Theorem

```mermaid
graph TD
    subgraph "CAP Theorem: Pick Any Two"
        C["Consistency<br/>All nodes see same data"]
        A["Availability<br/>System always responds"]
        P["Partition Tolerance<br/>Works despite network failures"]
    end
    
    C --- A
    A --- P
    P --- C
    
    style C fill:#F44336,color:#fff
    style A fill:#4CAF50,color:#fff
    style P fill:#2196F3,color:#fff
```

| Combination | Example Systems |
|-------------|-----------------|
| **CA** | Traditional RDBMS (single node) |
| **CP** | HBase, MongoDB (configurable) |
| **AP** | Cassandra, CouchDB |

---

## 📊 Advantages & Disadvantages

### ✅ Advantages

| Advantage | Description |
|-----------|-------------|
| **Local Autonomy** | Each site manages its own data |
| **Improved Performance** | Parallel processing, local queries |
| **Reliability** | No single point of failure |
| **Scalability** | Easy to add new sites |

### ❌ Disadvantages

| Disadvantage | Description |
|--------------|-------------|
| **Complexity** | Harder to design and maintain |
| **Network Dependency** | Network failure affects access |
| **Security** | More attack surface |
| **Cost** | Higher infrastructure cost |

---

## 🔗 Oracle Distributed Features

### Database Links

```sql
-- Create link to remote database
CREATE DATABASE LINK mumbai_link
CONNECT TO healthcare_user IDENTIFIED BY password
USING 'mumbai_db_tns';

-- Use database link
SELECT * FROM PATIENTS@mumbai_link;
```

### Synonyms for Transparency

```sql
-- Create synonym to hide location
CREATE SYNONYM all_patients FOR PATIENTS@mumbai_link;

-- Users query without knowing location
SELECT * FROM all_patients WHERE city = 'Mumbai';
```

---

## 🎓 Viva Quick Points

| Concept | Explanation |
|---------|-------------|
| **Distributed DB** | Data spread across multiple locations |
| **Fragmentation** | Breaking table into smaller parts |
| **Replication** | Storing copies at multiple sites |
| **2PC** | Protocol for distributed transactions |
| **CAP Theorem** | Can't have all: Consistency, Availability, Partition Tolerance |
| **Database Link** | Oracle feature to access remote DB |

---

> **📝 DBMS Concept:** Distributed databases provide scalability and reliability but introduce complexity in transaction management, concurrency control, and query optimization.
