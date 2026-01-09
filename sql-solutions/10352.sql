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
        timestamp as page_load_timestamp,
        DENSE_RANK() OVER (PARTITION BY user_id, DATE(timestamp) ORDER BY time_format DESC) as ranked
    FROM base_table
    WHERE action = 'page_load'
)

-- Get each clients earliest exit for each day
--client_exit_page_ranked AS (
    SELECT
        user_id,
        action,
        timestamp as page_exit_timestamp,
        DENSE_RANK() OVER (PARTITION BY user_id, DATE(timestamp) ORDER BY time_format) as ranked
    FROM base_table
    WHERE action = 'page_exit';
--)

--filter both tables
--filtered_exit_page AS (
    -- SELECT *
    -- FROM client_exit_page_ranked
    -- WHERE ranked = 1;
--)

-- filtered_load_page AS (
--     SELECT *
--     FROM client_load_page_ranked
--     WHERE ranked = 1
-- )


-- Calculate the average for each client
-- SELECT
--     a.user_id,
--     a.page_load_timestamp,
--     b.page_exit_timestamp
--     AVG(a.page_load)
-- FROM
--     filtered_load_page a
-- LEFT JOIN filtered_exit_page b ON a.user_id = b.user_id
-- WHERE b.page_exit_timestamp IS NOT NULL;