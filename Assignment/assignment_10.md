# Assignment 10: MongoDB Queries

## Data Setup
*Assuming the 'patients' collection is populated with diverse data.*

## Quering Techniques

### 1. Basic Find (Select All)
Retrieve all documents in the collection.
```javascript
db.patients.find().pretty()
```

### 2. FindOne (Single Document)
Retrieve the first document that matches the criteria (or first in collection if empty).
```javascript
db.patients.findOne({ "name": "Raj Kumar" })
```

### 3. Exact Match Criteria
Find patients living in 'Delhi'.
```javascript
db.patients.find({ "address": "Delhi" })
```

### 4. Comparison Operators ($gt, $lt)
Find patients older than 30.
```javascript
db.patients.find({ "age": { $gt: 30 } })
```

### 5. Logical Operators ($or, $and)
Find patients who are either 'Female' OR live in 'Mumbai'.
```javascript
db.patients.find({ 
    $or: [
        { "gender": "Female" }, 
        { "address": "Mumbai" }
    ] 
})
```

### 6. Array Query ($in)
Find patients who have 'Diabetes' or 'Asthma' in their medical history.
```javascript
db.patients.find({ 
    "medical_history": { $in: ["Diabetes", "Asthma"] } 
})
```

### 7. Type-Specific Queries ($type)
Find documents where 'age' is stored as a number (Double=1, String=2, Int=16, etc.).
```javascript
// Check if age is stored as an integer (Type 16) or Double (Type 1)
db.patients.find({ "age": { $type: "number" } })
```

### 8. Existence Check ($exists)
Find patients who have an 'email' field in their contact object.
```javascript
db.patients.find({ "contact.email": { $exists: true } })
```

### 9. Regex Search ($regex)
Find patients whose name starts with 'Am'.
```javascript
db.patients.find({ "name": { $regex: "^Am" } })
```

### 10. Projection (Field Selection)
Return only the name and age of patients (exclude _id).
```javascript
db.patients.find(
    {}, 
    { "name": 1, "age": 1, "_id": 0 }
)
```
