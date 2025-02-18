-- Initial SQLite setup
.open fittrackpro.sqlite
.mode column

-- Enable foreign key support

-- Membership Management Queries

-- 1. List all active memberships
-- TODO: Write a query to list all active memberships

-- 2. Calculate the average duration of gym visits for each membership type
-- TODO: Write a query to calculate the average duration of gym visits for each membership type

-- 3. Identify members with expiring memberships this year
-- TODO: Write a query to identify members with expiring memberships this year

-- 1. List all active memberships
SELECT m.member_id, m.first_name, m.last_name, mb.type AS membership_type, mb.start_date AS join_date
FROM members m
JOIN memberships mb ON m.member_id = mb.member_id
WHERE mb.status = 'Active';

-- 2. Calculate the average duration of gym visits for each membership type
SELECT mb.type AS membership_type, AVG(CAST((JULIANDAY(a.check_out_time) - JULIANDAY(a.check_in_time)) * 24 * 60 AS INTEGER)) AS avg_visit_duration_minutes
FROM memberships mb
JOIN members m ON mb.member_id = m.member_id
JOIN attendance a ON m.member_id = a.member_id
WHERE mb.status = 'Active'
GROUP BY mb.type;

-- 3. Identify members with expiring memberships this year
SELECT m.member_id, m.first_name, m.last_name, m.email, mb.end_date
FROM members m
JOIN memberships mb ON m.member_id = mb.member_id
WHERE mb.end_date BETWEEN DATE('now') AND DATE('now', '+1 year')
AND mb.status = 'Active';