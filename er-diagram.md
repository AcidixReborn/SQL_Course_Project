# Entity-Relationship (ER) Diagram Documentation

## Overview

This document provides detailed specifications for creating the ER diagram for the `clientDB` database. The diagram can be created using MySQL Workbench, draw.io, Lucidchart, or any ER modeling tool.

---

## Entities

### Entity 1: Client

| Attribute       | Data Type     | Constraints            | Description                     |
|-----------------|---------------|------------------------|---------------------------------|
| **clientID**    | INT           | PRIMARY KEY, AUTO_INCREMENT | Unique identifier for client |
| clientName      | VARCHAR(100)  | NOT NULL               | Full name of the client         |
| clientEmail     | VARCHAR(100)  | UNIQUE, NOT NULL       | Email address (must be unique)  |
| clientPassword  | VARCHAR(255)  | NOT NULL               | Password (hash in production)   |

**Visual Representation:**
- Draw as a **rectangle**
- Label: "Client"
- Underline `clientID` to indicate PRIMARY KEY
- Mark `clientEmail` with (U) to indicate UNIQUE constraint

---

### Entity 2: Meeting

| Attribute         | Data Type     | Constraints                  | Description                      |
|-------------------|---------------|------------------------------|----------------------------------|
| **meetingID**     | INT           | PRIMARY KEY, AUTO_INCREMENT  | Unique identifier for meeting    |
| meetingTopic      | VARCHAR(200)  | NOT NULL                     | Subject/title of the meeting     |
| numberOfPeople    | INT           | NOT NULL, CHECK > 0          | Expected number of attendees     |
| meetingDate       | DATE          | NOT NULL                     | Scheduled date of meeting        |
| *clientID*        | INT           | FOREIGN KEY, NOT NULL        | Reference to Client table        |

**Visual Representation:**
- Draw as a **rectangle**
- Label: "Meeting"
- Underline `meetingID` to indicate PRIMARY KEY
- Mark `clientID` with (FK) to indicate FOREIGN KEY

---

## Relationship

### Client - Meeting Relationship

| Property          | Value                                          |
|-------------------|------------------------------------------------|
| **Relationship Name** | "schedules" or "has"                       |
| **Type**          | One-to-Many (1:N)                              |
| **Cardinality**   | One Client can have Many Meetings              |
| **Participation** | Client: Partial (not all clients have meetings)|
|                   | Meeting: Total (every meeting must have a client) |

**Visual Representation:**
- Draw a **line** connecting Client to Meeting
- Place "1" near the Client entity
- Place "N" or "*" or use crow's foot notation near Meeting entity
- Label the line with "schedules" or "has"

---

## Diagram Layout Instructions

### For MySQL Workbench:

1. Open MySQL Workbench
2. Go to **File > New Model**
3. Double-click "Add Diagram"
4. From the catalog tree, drag tables onto the canvas
5. Or use **Table** tool to create entities:
   - Create "Client" table with specified columns
   - Create "Meeting" table with specified columns
6. Create relationship:
   - Use **1:n Non-Identifying Relationship** tool
   - Click on Meeting table, then Client table
   - This creates the foreign key relationship

### For draw.io / Lucidchart:

1. Use **Entity** shapes (rectangles) for each table
2. List attributes inside each rectangle
3. Use these symbols:
   - **PK** or underline for Primary Key
   - **FK** for Foreign Key
   - **U** for Unique constraint
4. Connect with relationship line
5. Add cardinality notation:
   - Crow's foot: `──||────<` (one to many)
   - Or Chen notation: `1` and `N`

---

## Crow's Foot Notation Reference

```
Exactly One:     ──||──
Zero or One:     ──o|──
One or Many:     ──|<──
Zero or Many:    ──o<──
```

**For this database:**
```
Client ──||────────<── Meeting
  │                      │
  │  One Client has      │
  │  Many Meetings       │
  └──────────────────────┘
```

---

## Text-Based ER Diagram (ASCII)

```
┌───────────────────────┐          ┌─────────────────────────┐
│        CLIENT         │          │         MEETING         │
├───────────────────────┤          ├─────────────────────────┤
│ PK  clientID     INT  │          │ PK  meetingID      INT  │
│     clientName   VC   │────┐     │     meetingTopic   VC   │
│ U   clientEmail  VC   │    │     │     numberOfPeople INT  │
│     clientPassword VC │    │     │     meetingDate    DATE │
└───────────────────────┘    │  ┌──│ FK  clientID       INT  │
                             │  │  └─────────────────────────┘
                             │  │
                             └──┘
                              1:N
                         "schedules"

Legend:
  PK = Primary Key
  FK = Foreign Key
  U  = Unique Constraint
  VC = VARCHAR
```

---

## Relationship Details

### Referential Integrity

| Action on Client | Effect on Meeting        |
|------------------|--------------------------|
| DELETE           | CASCADE (delete meetings)|
| UPDATE clientID  | CASCADE (update FK)      |

### Business Rules Enforced

1. **Every meeting must belong to a client** - enforced by NOT NULL on clientID FK
2. **Client email must be unique** - enforced by UNIQUE constraint
3. **Meeting must have at least 1 attendee** - enforced by CHECK constraint
4. **Deleting a client removes their meetings** - enforced by ON DELETE CASCADE

---

## Index Information (for Performance)

| Table   | Index Name          | Column(s)    | Purpose                        |
|---------|---------------------|--------------|--------------------------------|
| Client  | PRIMARY             | clientID     | Primary key lookup O(log n)    |
| Client  | idx_client_email    | clientEmail  | Login/search by email O(log n) |
| Meeting | PRIMARY             | meetingID    | Primary key lookup O(log n)    |
| Meeting | idx_meeting_client  | clientID     | JOIN performance O(log n)      |
| Meeting | idx_meeting_date    | meetingDate  | Date range queries O(log n)    |

---

## Sample Data Visualization

```
CLIENT                              MEETING
┌────┬─────────────┐               ┌────┬──────────────────┬───────────┬────┐
│ ID │ Name        │               │ ID │ Topic            │ Date      │ CID│
├────┼─────────────┤               ├────┼──────────────────┼───────────┼────┤
│ 1  │ Anna Smith  │──────────────>│ 1  │ Project Kickoff  │ 2025-05-05│ 1  │
│    │             │──────────────>│ 2  │ Design Review    │ 2025-05-10│ 1  │
│    │             │──────────────>│ 5  │ Site Inspection  │ 2025-05-20│ 1  │
├────┼─────────────┤               ├────┼──────────────────┼───────────┼────┤
│ 2  │ John Doe    │──────────────>│ 3  │ Final Presentation│2025-05-15│ 2  │
│    │             │──────────────>│ 8  │ Progress Update  │ 2025-05-28│ 2  │
├────┼─────────────┤               ├────┼──────────────────┼───────────┼────┤
│ 3  │ Sarah Johnson│─────────────>│ 4  │ Budget Planning  │ 2025-05-18│ 3  │
│    │             │──────────────>│ 9  │ Material Selection│2025-06-01│ 3  │
├────┼─────────────┤               ├────┼──────────────────┼───────────┼────┤
│ 4  │ Michael Chen│──────────────>│ 6  │ Contract Negotiation│2025-05-22│4 │
│    │             │──────────────>│ 10 │ Completion Walk  │ 2025-06-05│ 4  │
├────┼─────────────┤               ├────┼──────────────────┼───────────┼────┤
│ 5  │ Emily Davis │──────────────>│ 7  │ Blueprint Review │ 2025-05-25│ 5  │
└────┴─────────────┘               └────┴──────────────────┴───────────┴────┘
```

---

## Summary

- **2 Entities**: Client, Meeting
- **1 Relationship**: One-to-Many (Client to Meeting)
- **Primary Keys**: clientID, meetingID (both AUTO_INCREMENT)
- **Foreign Key**: clientID in Meeting references Client
- **Cascade Rules**: DELETE and UPDATE cascade from Client to Meeting
