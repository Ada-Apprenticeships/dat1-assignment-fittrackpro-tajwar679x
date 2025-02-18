-- Initial SQLite setup
.open fittrackpro.sqlite
.mode column

-- Enable foreign key support

-- Class Scheduling Queries

-- 1. List all classes with their instructors
-- TODO: Write a query to list all classes with their instructors

-- 2. Find available classes for a specific date
-- TODO: Write a query to find available classes for a specific date

-- 3. Register a member for a class
-- TODO: Write a query to register a member for a class

-- 4. Cancel a class registration
-- TODO: Write a query to cancel a class registration

-- 5. List top 5 most popular classes
-- TODO: Write a query to list top 5 most popular classes

-- 6. Calculate average number of classes per member
-- TODO: Write a query to calculate average number of classes per member
-- 1. List all classes with their instructors
SELECT c.class_id, c.name AS class_name, s.first_name || ' ' || s.last_name AS instructor_name
FROM classes c
JOIN class_schedule cs ON c.class_id = cs.class_id
JOIN staff s ON cs.staff_id = s.staff_id;

-- 2. Find available classes for a specific date
SELECT c.class_id, c.name, cs.start_time, cs.end_time, c.capacity - COALESCE(COUNT(ca.class_attendance_id), 0) AS available_spots
FROM classes c
JOIN class_schedule cs ON c.class_id = cs.class_id
LEFT JOIN class_attendance ca ON cs.schedule_id = ca.schedule_id
WHERE cs.start_time BETWEEN '2025-02-01 00:00:00' AND '2025-02-01 23:59:59'
GROUP BY c.class_id, cs.schedule_id
ORDER BY cs.start_time;

-- 3. Register a member for a class
INSERT INTO class_attendance (schedule_id, member_id, attendance_status)
SELECT cs.schedule_id, 11, 'Registered'
FROM class_schedule cs
JOIN classes c ON cs.class_id = c.class_id
WHERE c.name = 'Spin Class' AND cs.start_time BETWEEN '2025-02-01 00:00:00' AND '2025-02-01 23:59:59';

-- 4. Cancel a class registration
UPDATE class_attendance
SET attendance_status = 'Unattended'
WHERE schedule_id = (
  SELECT schedule_id
  FROM class_schedule cs
  JOIN classes c ON cs.class_id = c.class_id
  WHERE c.name = 'Yoga Basics' AND cs.start_time BETWEEN '2025-02-01 00:00:00' AND '2025-02-01 23:59:59'
)
AND member_id = 2;

-- 5. List top 5 most popular classes
SELECT c.class_id, c.name, COUNT(ca.class_attendance_id) AS registration_count
FROM classes c
LEFT JOIN class_attendance ca ON c.class_id = (
  SELECT class_id
  FROM class_schedule
  WHERE schedule_id = ca.schedule_id
)
GROUP BY c.class_id
ORDER BY registration_count DESC
LIMIT 5;

-- 6. Calculate average number of classes per member
SELECT ROUND(CAST(COUNT(*) AS FLOAT) / (SELECT COUNT(DISTINCT member_id) FROM members), 2) AS avg_classes_per_member
FROM class_attendance;