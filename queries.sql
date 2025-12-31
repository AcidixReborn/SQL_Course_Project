-- CRUD Operations and JOIN Queries for clientDB

USE clientDB;

-- INSERT: Single client
INSERT INTO Client (clientName, clientEmail, clientPassword)
VALUES ('Robert Wilson', 'robert@newclient.com', 'newpass789');

-- INSERT: Multiple clients
INSERT INTO Client (clientName, clientEmail, clientPassword) VALUES
    ('Lisa Anderson', 'lisa@company.com', 'lisapass123'),
    ('David Brown', 'david@enterprise.com', 'davidpass456');

-- INSERT: Single meeting
INSERT INTO Meeting (meetingTopic, numberOfPeople, meetingDate, clientID)
VALUES ('New Project Discussion', 4, '2025-06-10', 1);

-- INSERT: Meeting using subquery to find clientID
INSERT INTO Meeting (meetingTopic, numberOfPeople, meetingDate, clientID)
VALUES (
    'Initial Consultation',
    2,
    '2025-06-15',
    (SELECT clientID FROM Client WHERE clientEmail = 'robert@newclient.com')
);

-- SELECT: All records
SELECT * FROM Client;
SELECT * FROM Meeting;

-- SELECT: Specific columns
SELECT clientID, clientName, clientEmail FROM Client;

-- SELECT: By primary key
SELECT * FROM Client WHERE clientID = 1;

-- SELECT: By email
SELECT * FROM Client WHERE clientEmail = 'anna@architectfirm.com';

-- SELECT: Pattern matching
SELECT * FROM Client WHERE clientName LIKE 'Anna%';

-- SELECT: Meetings for specific client
SELECT * FROM Meeting WHERE clientID = 1;

-- SELECT: Date range filter
SELECT * FROM Meeting
WHERE meetingDate BETWEEN '2025-05-01' AND '2025-05-31';

-- SELECT: With sorting
SELECT * FROM Meeting ORDER BY meetingDate ASC;

-- SELECT: Aggregate functions
SELECT
    COUNT(*) AS totalMeetings,
    SUM(numberOfPeople) AS totalAttendees,
    AVG(numberOfPeople) AS avgAttendees,
    MIN(meetingDate) AS earliestMeeting,
    MAX(meetingDate) AS latestMeeting
FROM Meeting;

-- SELECT: Group by client
SELECT
    clientID,
    COUNT(*) AS meetingCount,
    SUM(numberOfPeople) AS totalAttendees
FROM Meeting
GROUP BY clientID;

-- UPDATE: Single record by primary key
UPDATE Client
SET clientEmail = 'anna.smith@architectfirm.com'
WHERE clientID = 1;

-- UPDATE: Multiple columns
UPDATE Client
SET clientName = 'Anna M. Smith',
    clientPassword = 'newSecurePass123'
WHERE clientID = 1;

-- UPDATE: Meeting details
UPDATE Meeting
SET numberOfPeople = 8,
    meetingTopic = 'Extended Design Review'
WHERE meetingID = 2;

-- UPDATE: Multiple records
UPDATE Meeting
SET numberOfPeople = numberOfPeople + 2
WHERE clientID = 1;

-- UPDATE: Using subquery
UPDATE Meeting
SET meetingDate = '2025-06-20'
WHERE clientID = (SELECT clientID FROM Client WHERE clientEmail = 'john@architectfirm.com')
  AND meetingTopic = 'Final Presentation';

-- DELETE: Test record (create then delete)
INSERT INTO Meeting (meetingTopic, numberOfPeople, meetingDate, clientID)
VALUES ('Test Meeting to Delete', 1, '2025-12-31', 1);
DELETE FROM Meeting WHERE meetingTopic = 'Test Meeting to Delete';

-- DELETE: By meeting ID (commented out)
-- DELETE FROM Meeting WHERE meetingID = 10;

-- DELETE: Client with cascade (commented out - removes all their meetings too)
-- DELETE FROM Client WHERE clientID = 5;

-- DELETE: By date (commented out)
-- DELETE FROM Meeting WHERE meetingDate < '2025-01-01';

-- Safe delete: Check first, then delete
SELECT * FROM Meeting WHERE clientID = 3;
-- DELETE FROM Meeting WHERE clientID = 3;

-- INNER JOIN: Clients with their meetings
SELECT
    c.clientID,
    c.clientName,
    c.clientEmail,
    m.meetingID,
    m.meetingTopic,
    m.numberOfPeople,
    m.meetingDate
FROM Client c
INNER JOIN Meeting m ON c.clientID = m.clientID
ORDER BY c.clientName, m.meetingDate;

-- LEFT JOIN: All clients including those without meetings
SELECT
    c.clientID,
    c.clientName,
    c.clientEmail,
    m.meetingTopic,
    m.meetingDate
FROM Client c
LEFT JOIN Meeting m ON c.clientID = m.clientID
ORDER BY c.clientName;

-- RIGHT JOIN: All meetings with client info
SELECT
    c.clientName,
    m.meetingID,
    m.meetingTopic,
    m.meetingDate
FROM Client c
RIGHT JOIN Meeting m ON c.clientID = m.clientID
ORDER BY m.meetingDate;

-- JOIN: Meeting count per client
SELECT
    c.clientID,
    c.clientName,
    COUNT(m.meetingID) AS meetingCount,
    COALESCE(SUM(m.numberOfPeople), 0) AS totalAttendees
FROM Client c
LEFT JOIN Meeting m ON c.clientID = m.clientID
GROUP BY c.clientID, c.clientName
ORDER BY meetingCount DESC;

-- JOIN: Clients with meetings in date range
SELECT DISTINCT
    c.clientID,
    c.clientName,
    c.clientEmail
FROM Client c
INNER JOIN Meeting m ON c.clientID = m.clientID
WHERE m.meetingDate BETWEEN '2025-05-01' AND '2025-05-31';

-- JOIN: Meetings with 5+ attendees
SELECT
    c.clientName,
    m.meetingTopic,
    m.numberOfPeople,
    m.meetingDate
FROM Client c
INNER JOIN Meeting m ON c.clientID = m.clientID
WHERE m.numberOfPeople >= 5
ORDER BY m.numberOfPeople DESC;

-- JOIN: Formatted report
SELECT
    c.clientName AS 'Client Name',
    m.meetingTopic AS 'Meeting Topic',
    m.numberOfPeople AS 'Attendees',
    DATE_FORMAT(m.meetingDate, '%M %d, %Y') AS 'Meeting Date'
FROM Client c
INNER JOIN Meeting m ON c.clientID = m.clientID
ORDER BY m.meetingDate;

-- Subquery: Clients with more than 2 meetings
SELECT clientID, clientName, clientEmail
FROM Client
WHERE clientID IN (
    SELECT clientID
    FROM Meeting
    GROUP BY clientID
    HAVING COUNT(*) > 2
);

-- Subquery: Next upcoming meeting per client
SELECT
    c.clientName,
    m.meetingTopic,
    m.meetingDate
FROM Client c
INNER JOIN Meeting m ON c.clientID = m.clientID
WHERE m.meetingDate = (
    SELECT MIN(m2.meetingDate)
    FROM Meeting m2
    WHERE m2.clientID = c.clientID
      AND m2.meetingDate >= CURDATE()
);

-- Summary statistics
SELECT
    (SELECT COUNT(*) FROM Client) AS totalClients,
    (SELECT COUNT(*) FROM Meeting) AS totalMeetings,
    (SELECT AVG(numberOfPeople) FROM Meeting) AS avgMeetingSize,
    (SELECT COUNT(DISTINCT clientID) FROM Meeting) AS clientsWithMeetings;
