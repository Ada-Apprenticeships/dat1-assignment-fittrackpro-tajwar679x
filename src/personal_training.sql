-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support

-- Personal Training Queries

-- 1. List all personal training sessions for a specific trainer
-- TODO: Write a query to list all personal training sessions for a specific trainer
SELECT pts.session_id, m.first_name, m.last_name, pts.session_date, pts.start_time, pts.end_time, pts.notes
FROM personal_training_sessions pts
JOIN members m ON pts.member_id = m.member_id
JOIN staff s ON pts.staff_id = s.staff_id
WHERE s.first_name = 'Ivy' AND s.last_name = 'Irwin'
ORDER BY pts.session_date, pts.start_time;
