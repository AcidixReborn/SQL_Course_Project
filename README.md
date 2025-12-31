# Designing and Managing Client Databases Using SQL

A relational database system for an architectural firm to manage client details and meetings using MySQL.

## Project Overview

**Objective:** Design and implement a relational database system using MySQL by creating structured tables, establishing relationships, designing an Entity-Relationship (ER) diagram, and performing core SQL operations such as insert, update, delete, and querying data using joins.

**Scenario:** Anna, an architect managing numerous client projects, needs a centralized system to keep track of client information and meeting details. This database solution digitizes and streamlines the project management workflow.

---

## Database Schema

### Database: `clientDB`

### Tables

#### Client Table
| Column         | Type          | Constraints                    |
|----------------|---------------|--------------------------------|
| clientID       | INT           | PRIMARY KEY, AUTO_INCREMENT    |
| clientName     | VARCHAR(100)  | NOT NULL                       |
| clientEmail    | VARCHAR(100)  | UNIQUE, NOT NULL               |
| clientPassword | VARCHAR(255)  | NOT NULL                       |

#### Meeting Table
| Column          | Type          | Constraints                    |
|-----------------|---------------|--------------------------------|
| meetingID       | INT           | PRIMARY KEY, AUTO_INCREMENT    |
| meetingTopic    | VARCHAR(200)  | NOT NULL                       |
| numberOfPeople  | INT           | NOT NULL, CHECK > 0            |
| meetingDate     | DATE          | NOT NULL                       |
| clientID        | INT           | FOREIGN KEY -> Client(clientID)|

### Relationship
- **One-to-Many (1:N)**: One Client can have many Meetings
- **Cascade Rules**: DELETE and UPDATE cascade from Client to Meeting

---

## Project Structure

```
SQL_Course_Project/
├── README.md           # Project documentation (this file)
├── schema.sql          # Database and table definitions
├── data.sql            # Sample data (5 clients, 10 meetings)
├── queries.sql         # CRUD operations and JOIN examples
├── er-diagram.md       # ER diagram documentation
└── *.pdf               # Course project requirements
```

---

## Quick Start

### 1. Create the Database and Tables
```bash
mysql -u root -p < schema.sql
```

### 2. Insert Sample Data
```bash
mysql -u root -p < data.sql
```

### 3. Run Queries
```bash
mysql -u root -p < queries.sql
```

Or execute in MySQL Workbench by opening each file and running.

---

## Big O Notation Analysis

Understanding time complexity is crucial for database performance optimization.

### Operation Time Complexities

| Operation               | Time Complexity | Description                          |
|-------------------------|-----------------|--------------------------------------|
| INSERT                  | O(log n)        | Index maintenance on B-tree          |
| SELECT by PRIMARY KEY   | O(log n)        | B-tree index lookup                  |
| SELECT by indexed column| O(log n)        | Uses secondary index                 |
| SELECT full table       | O(n)            | Full table scan                      |
| UPDATE by PRIMARY KEY   | O(log n)        | Find + update                        |
| DELETE by PRIMARY KEY   | O(log n)        | Find + remove                        |
| DELETE with CASCADE     | O(log n + m)    | m = related records                  |
| JOIN (indexed)          | O(n log m)      | n = outer table, m = inner table     |
| JOIN (unindexed)        | O(n * m)        | Nested loop - avoid!                 |
| GROUP BY                | O(n log n)      | Scan + sort/hash                     |
| ORDER BY                | O(n log n)      | Sorting required                     |

### Index Strategy

| Index                 | Column(s)    | Purpose                    | Complexity |
|-----------------------|--------------|----------------------------|------------|
| PRIMARY (Client)      | clientID     | Primary key lookups        | O(log n)   |
| idx_client_email      | clientEmail  | Login/authentication       | O(log n)   |
| PRIMARY (Meeting)     | meetingID    | Primary key lookups        | O(log n)   |
| idx_meeting_client    | clientID     | JOIN performance           | O(log n)   |
| idx_meeting_date      | meetingDate  | Date range queries         | O(log n)   |

### Performance Best Practices

1. **Always use indexed columns in WHERE clauses** - O(log n) vs O(n)
2. **Use JOINs on indexed foreign keys** - O(n log m) vs O(n * m)
3. **Avoid SELECT *** - transfer only needed columns
4. **Use LIMIT for large result sets** - reduces data transfer
5. **Batch INSERT statements** - reduces transaction overhead

---

## SQL Operations Covered

### CRUD Operations

#### Create (INSERT)
```sql
INSERT INTO Client (clientName, clientEmail, clientPassword)
VALUES ('Anna Smith', 'anna@architectfirm.com', 'password123');
```

#### Read (SELECT)
```sql
SELECT * FROM Client WHERE clientID = 1;
```

#### Update (UPDATE)
```sql
UPDATE Client SET clientEmail = 'anna.new@email.com' WHERE clientID = 1;
```

#### Delete (DELETE)
```sql
DELETE FROM Meeting WHERE meetingID = 5;
```

### JOIN Operations

#### INNER JOIN
```sql
SELECT c.clientName, m.meetingTopic, m.meetingDate
FROM Client c
INNER JOIN Meeting m ON c.clientID = m.clientID;
```

#### LEFT JOIN
```sql
SELECT c.clientName, m.meetingTopic
FROM Client c
LEFT JOIN Meeting m ON c.clientID = m.clientID;
```

---

## ER Diagram

See [er-diagram.md](er-diagram.md) for detailed ER diagram documentation.

### Quick Reference
```
┌─────────────────┐       1:N       ┌─────────────────────┐
│     CLIENT      │───────────────>│       MEETING       │
├─────────────────┤                 ├─────────────────────┤
│ PK clientID     │                 │ PK meetingID        │
│    clientName   │                 │    meetingTopic     │
│ U  clientEmail  │                 │    numberOfPeople   │
│    clientPassword│                │    meetingDate      │
└─────────────────┘                 │ FK clientID         │
                                    └─────────────────────┘
```

---

## Security Considerations

### Password Storage

**WARNING:** This demo uses plain text passwords for simplicity. In production:

```sql
-- NEVER store plain text passwords!
-- Use these hashing algorithms:
--   - bcrypt (recommended)
--   - Argon2 (modern, memory-hard)
--   - PBKDF2 (widely supported)
```

**Example implementations:**
```python
# Python with bcrypt
import bcrypt
hashed = bcrypt.hashpw(password.encode(), bcrypt.gensalt())
```

```javascript
// Node.js with bcrypt
const bcrypt = require('bcrypt');
const hash = await bcrypt.hash(password, 10);
```

```php
// PHP
$hash = password_hash($password, PASSWORD_DEFAULT);
```

### SQL Injection Prevention

Always use parameterized queries in application code:

```python
# Python - SAFE
cursor.execute("SELECT * FROM Client WHERE clientID = %s", (user_id,))

# Python - UNSAFE (don't do this!)
cursor.execute(f"SELECT * FROM Client WHERE clientID = {user_id}")
```

---

## Sample Data

### Clients (5 records)
| ID | Name           | Email                      |
|----|----------------|----------------------------|
| 1  | Anna Smith     | anna@architectfirm.com     |
| 2  | John Doe       | john@architectfirm.com     |
| 3  | Sarah Johnson  | sarah@clientcorp.com       |
| 4  | Michael Chen   | michael@buildingco.com     |
| 5  | Emily Davis    | emily@designstudio.com     |

### Meetings (10 records)
| ID | Topic                  | People | Date       | Client |
|----|------------------------|--------|------------|--------|
| 1  | Project Kickoff        | 5      | 2025-05-05 | Anna   |
| 2  | Design Review          | 3      | 2025-05-10 | Anna   |
| 3  | Final Presentation     | 8      | 2025-05-15 | John   |
| 4  | Budget Planning        | 4      | 2025-05-18 | Sarah  |
| 5  | Site Inspection        | 6      | 2025-05-20 | Anna   |
| 6  | Contract Negotiation   | 3      | 2025-05-22 | Michael|
| 7  | Blueprint Review       | 5      | 2025-05-25 | Emily  |
| 8  | Progress Update        | 4      | 2025-05-28 | John   |
| 9  | Material Selection     | 7      | 2025-06-01 | Sarah  |
| 10 | Completion Walkthrough | 10     | 2025-06-05 | Michael|

---

## Project Tasks Completed

- [x] **Task 1:** Create database `clientDB`
- [x] **Task 2:** Define Client table (ID, name, email, password)
- [x] **Task 3:** Create Meeting table (topic, people, date, FK)
- [x] **Task 4:** Design ER Diagram with relationships
- [x] **Task 5:** Perform CRUD operations (INSERT, UPDATE, DELETE, SELECT)
- [x] **Task 6:** Establish relationships using SQL JOINs

---

## Technologies Used

- **MySQL** - Relational Database Management System
- **SQL** - Structured Query Language
- **MySQL Workbench** - Database design and management tool

---

## References

- MySQL Documentation: https://dev.mysql.com/doc/
- SQL Tutorial: https://www.w3schools.com/sql/
- Big O Notation: https://en.wikipedia.org/wiki/Big_O_notation

---

## License

This project is created for educational purposes as part of the Full Stack Development Program with Generative AI.
