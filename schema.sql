-- ============================================================================
-- SQL Course Project: Client Database Schema
-- Database: clientDB
-- Purpose: Manage client details and meetings for an architectural firm
-- ============================================================================

-- Create the database
CREATE DATABASE IF NOT EXISTS clientDB;
USE clientDB;

-- ============================================================================
-- PASSWORD SECURITY NOTICE
-- ============================================================================
-- NOTE: In production, NEVER store plain text passwords!
-- Use password hashing algorithms like:
--   - bcrypt (recommended, includes salt)
--   - Argon2 (modern, memory-hard)
--   - PBKDF2 (widely supported)
--
-- Example with application code:
--   Python: bcrypt.hashpw(password.encode(), bcrypt.gensalt())
--   Node.js: await bcrypt.hash(password, 10)
--   PHP: password_hash($password, PASSWORD_DEFAULT)
--
-- The clientPassword field uses VARCHAR(255) to accommodate bcrypt hash output
-- For this demo, plain text passwords are used for simplicity
-- ============================================================================

-- ============================================================================
-- TABLE: Client
-- ============================================================================
-- Stores client information for the architectural firm
-- ============================================================================
CREATE TABLE Client (
    clientID INT AUTO_INCREMENT PRIMARY KEY,
    clientName VARCHAR(100) NOT NULL,
    clientEmail VARCHAR(100) UNIQUE NOT NULL,
    clientPassword VARCHAR(255) NOT NULL,

    INDEX idx_client_email (clientEmail)
);

-- ============================================================================
-- TABLE: Meeting
-- ============================================================================
-- Stores meeting information linked to clients
-- Relationship: Many meetings belong to one client (N:1)
-- ============================================================================
CREATE TABLE Meeting (
    meetingID INT AUTO_INCREMENT PRIMARY KEY,
    meetingTopic VARCHAR(200) NOT NULL,
    numberOfPeople INT NOT NULL CHECK (numberOfPeople > 0),
    meetingDate DATE NOT NULL,
    clientID INT NOT NULL,

    -- Foreign key constraint with cascade options
    -- ON DELETE CASCADE: If a client is deleted, their meetings are also deleted
    -- ON UPDATE CASCADE: If clientID changes, it propagates to meetings
    FOREIGN KEY (clientID) REFERENCES Client(clientID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    INDEX idx_meeting_client (clientID),
    INDEX idx_meeting_date (meetingDate)
);
