-- Sample Data for clientDB

USE clientDB;

-- Insert 5 clients
INSERT INTO Client (clientName, clientEmail, clientPassword) VALUES
    ('Anna Smith', 'anna@architectfirm.com', 'password123'),
    ('John Doe', 'john@architectfirm.com', 'securepass456'),
    ('Sarah Johnson', 'sarah@clientcorp.com', 'clientpass789'),
    ('Michael Chen', 'michael@buildingco.com', 'buildpass321'),
    ('Emily Davis', 'emily@designstudio.com', 'designpass654');

-- Insert 10 meetings
INSERT INTO Meeting (meetingTopic, numberOfPeople, meetingDate, clientID) VALUES
    ('Project Kickoff', 5, '2025-05-05', 1),
    ('Design Review', 3, '2025-05-10', 1),
    ('Site Inspection', 6, '2025-05-20', 1),
    ('Final Presentation', 8, '2025-05-15', 2),
    ('Progress Update', 4, '2025-05-28', 2),
    ('Budget Planning', 4, '2025-05-18', 3),
    ('Material Selection', 7, '2025-06-01', 3),
    ('Contract Negotiation', 3, '2025-05-22', 4),
    ('Completion Walkthrough', 10, '2025-06-05', 4),
    ('Blueprint Review', 5, '2025-05-25', 5);

-- Verify data
SELECT 'Clients inserted:' AS Status, COUNT(*) AS Count FROM Client;
SELECT 'Meetings inserted:' AS Status, COUNT(*) AS Count FROM Meeting;
SELECT * FROM Client;
SELECT * FROM Meeting;
