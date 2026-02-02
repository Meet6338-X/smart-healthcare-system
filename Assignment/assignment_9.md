# Assignment 9: MongoDB Basics

## 1. Create Database
In MongoDB, a database is created automatically when you first switch to it and insert data.

```javascript
// Switch to the database (creates it if it doesn't exist)
use smart_healthcare
```

## 2. Insert Documents
Inserting data into collections (equivalent to tables).

### Insert Single Document
```javascript
db.patients.insertOne({
    "patient_id": 1,
    "name": "Raj Kumar",
    "age": 30,
    "gender": "Male",
    "contact": {
        "phone": "9123456789",
        "email": "raj@email.com"
    },
    "address": "Mumbai",
    "medical_history": ["Hypertension"]
})
```

### Insert Multiple Documents
```javascript
db.patients.insertMany([
    {
        "patient_id": 2,
        "name": "Priya Singh",
        "age": 28,
        "gender": "Female",
        "contact": { "phone": "9988776655" },
        "address": "Delhi"
    },
    {
        "patient_id": 3,
        "name": "Amit Verma",
        "age": 45,
        "gender": "Male",
        "contact": { "phone": "9876543210" },
        "address": "Bangalore",
        "medical_history": ["Diabetes", "Asthma"]
    }
])
```

## 3. Update Documents
Modifying existing data using `updateOne` or `updateMany`.

### Update Generic Field
```javascript
// Update phone number for patient_id 1
db.patients.updateOne(
    { "patient_id": 1 },
    { $set: { "contact.phone": "9000000000" } }
)
```

### Add Element to Array
```javascript
// Add a new condition to medical_history for patient_id 3
db.patients.updateOne(
    { "patient_id": 3 },
    { $push: { "medical_history": "High Cholesterol" } }
)
```

## 4. Remove Documents
Deleting data using `deleteOne` or `deleteMany`.

### Remove Single Document
```javascript
// Delete patient with patient_id 2
db.patients.deleteOne({ "patient_id": 2 })
```

### Remove Multiple Documents
```javascript
// Delete all patients from 'Mumbai'
db.patients.deleteMany({ "address": "Mumbai" })
```
