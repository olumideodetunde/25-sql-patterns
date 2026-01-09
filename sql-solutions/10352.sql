--Link: https://platform.stratascratch.com/coding/10352-users-by-avg-session-time?code_type=1
WITH base_table AS (
    SELECT
        user_id,
        timestamp,
        action,
        DATE(timestamp) as date,
        TO_CHAR(timestamp, 'HH24:MI:SS') AS time_format
    FROM
        facebook_web_log
    WHERE action IN ('page_load', 'page_exit')
),

-- Get each clients page load ranked from highest to lowest for each day
client_load_page_ranked AS (
    SELECT
        user_id,
        action,
        time_format,
        date,
        DENSE_RANK() OVER (PARTITION BY user_id, date ORDER BY time_format DESC) as ranked
    FROM base_table
    WHERE action = 'page_load'),

-- Get each clients earliest exit for each day
client_exit_page_ranked AS (
    SELECT
        user_id,
        action,
        time_format,
        date,
        DENSE_RANK() OVER (PARTITION BY user_id, DATE(timestamp) ORDER BY time_format ) as ranked
    FROM base_table
    WHERE action = 'page_exit'
),

--filter both tables
filtered_exit_page AS (
    SELECT
        user_id,
        date,
        time_format as time_format_exit
        --page_exit_timestamp
    FROM client_exit_page_ranked
    WHERE ranked = 1
),

filtered_load_page AS (
    SELECT
        user_id,
        date,
        time_format as time_format_load
        --page_load_timestamp
    FROM client_load_page_ranked
    WHERE ranked = 1
),


-- Calculate session duration
session_duration_table AS (
  SELECT
    a.user_id,
    a.date,
    a.time_format_load,
    b.time_format_exit,
    EXTRACT(EPOCH FROM (b.time_format_exit::TIME - a.time_format_load::TIME))::INTEGER as session_duration
FROM
    filtered_load_page a
LEFT JOIN filtered_exit_page b ON a.user_id = b.user_id AND a.date = b.date
WHERE b.time_format_exit IS NOT NULL
)

-- Get average session duration for each user_id
SELECT
    user_id,
    AVG(session_duration) as avg_session_duration
FROM
    session_duration_table
GROUP BY
    user_id;