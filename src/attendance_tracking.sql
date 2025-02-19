-- Initial SQLite setup
.open fittrackpro.sqlite
.mode column


-- 1. Record a member's gym visit
-- TODO: Write a query to record a member's gym visit

-- 2. Retrieve a member's attendance history
-- TODO: Write a query to retrieve a member's attendance history

-- 3. Find the busiest day of the week based on gym visits
-- TODO: Write a query to find the busiest day of the week based on gym visits

-- 4. Calculate the average daily attendance for each location
-- TODO: Write a query to calculate the average daily attendance for each location

-- 1. Record a member's gym visit
INSERT INTO attendance (member_id, location_id, check_in_time)
VALUES (7, 1, CURRENT_TIMESTAMP);

-- 2. Retrieve a member's attendance history
SELECT DATE(check_in_time) AS visit_date, check_in_time, check_out_time
FROM attendance
WHERE member_id = 5
ORDER BY check_in_time DESC;


-- 4. Calculate the average daily attendance for each location
SELECT l.name AS location_name, ROUND(COUNT(*) / (
  SELECT COUNT(DISTINCT DATE(check_in_time))
  FROM attendance
  WHERE location_id = l.location_id
), 2) AS avg_daily_attendance
FROM attendance a
JOIN locations l ON a.location_id = l.location_id
GROUP BY l.location_id;