# Assignment 11: Map Reduce in MongoDB

## Overview
Map-Reduce is a data processing paradigm for condensing large volumes of data into useful aggregated results. 
*Note: In modern MongoDB (v5.0+), the Aggregation Pipeline is preferred over Map-Reduce for performance, but Map-Reduce is still supported.*

## Example: Count Patients per City

### 1. Define the Map Function
The map function identifies the grouping key and emits a value for processing.
Here, we group by `address` (City) and emit `1` for each patient.

```javascript
var mapFunction = function() {
    emit(this.address, 1);
};
```

### 2. Define the Reduce Function
The reduce function processes the values emitted for a specific key.
Here, we sum up the count for each city.

```javascript
var reduceFunction = function(keyCity, valuesCount) {
    return Array.sum(valuesCount);
};
```

### 3. Execute Map-Reduce
Run the map-reduce command on the `patients` collection and store the result in a new collection `city_stats`.

```javascript
db.patients.mapReduce(
    mapFunction,
    reduceFunction,
    { out: "city_stats" }
)
```

### 4. View Results
Query the output collection to see the aggregated data.

```javascript
db.city_stats.find()
```
*Expected Output:*
```json
{ "_id" : "Mumbai", "value" : 10 }
{ "_id" : "Delhi", "value" : 8 }
{ "_id" : "Bangalore", "value" : 12 }
```

## Example 2: Average Age per Gender

### 1. Map Function
Emit age for each gender.

```javascript
var mapFunction2 = function() {
    emit(this.gender, this.age);
};
```

### 2. Reduce Function
Calculate sum and count (Note: MapReduce handles arrays of values, but for average, a Finalize step is often cleaner, or we simpler sum loops). Simple average in reduce is complex because reduce can be called iteratively (re-reducing reduced values). 

**Correct Approach for Average:**
Emit object `{ count: 1, age: this.age }`.

```javascript
var mapFunctionAvg = function() {
    emit(this.gender, { count: 1, total_age: this.age });
};
```

```javascript
var reduceFunctionAvg = function(key, values) {
    var reduced = { count: 0, total_age: 0 };
    
    values.forEach(function(val) {
        reduced.count += val.count;
        reduced.total_age += val.total_age;
    });
    
    return reduced;
};
```

### 3. Finalize Function
Calculate average from total and count.

```javascript
var finalizeFunctionAvg = function(key, reducedVal) {
    reducedVal.avg_age = reducedVal.total_age / reducedVal.count;
    return reducedVal;
};
```

### 4. Execute
```javascript
db.patients.mapReduce(
    mapFunctionAvg,
    reduceFunctionAvg,
    { 
        out: "gender_age_stats",
        finalize: finalizeFunctionAvg
    }
)
```
