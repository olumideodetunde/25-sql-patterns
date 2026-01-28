--Link:https://platform.stratascratch.com/coding/2053-retention-rate?code_type=1

-- Filter for accounts with activities between Dec and Feb as the base table
WITH base_table AS (
    SELECT
        account_id,
        user_id,
        EXTRACT(YEAR FROM record_date)::int as year,
        EXTRACT(MONTH FROM record_date)::int as month
    FROM
        sf_events
    WHERE
        record_date BETWEEN '2020-12-01' AND '2021-02-28'
    GROUP BY
        account_id, user_id, EXTRACT(YEAR FROM record_date), EXTRACT(MONTH FROM record_date)
    ),

-- Create retention flag for all users and account
retention_flags AS (
    SELECT
        account_id,
        user_id,
        year,
        month,
        CASE
            WHEN LEAD(month) OVER(PARTITION BY account_id, user_id ORDER BY year, month ASC) IS NOT NULL
            THEN 1
            ELSE 0
        END as is_retained
    FROM base_table
),

--Create a retention table for each month
dec_retention_table AS (
    SELECT
        account_id,
        SUM(is_retained)::NUMERIC / COUNT(DISTINCT user_id)::NUMERIC as retention_rate,
        SUM(is_retained) as retained_users,
        COUNT(DISTINCT user_id) as total_users
    FROM retention_flags
    WHERE year = 2020 AND month = 12
    GROUP BY account_id
),

jan_retention_table AS (
    SELECT
        account_id,
        SUM(is_retained)::NUMERIC / COUNT(DISTINCT user_id)::NUMERIC as retention_rate,
        SUM(is_retained) as retained_users,
        COUNT(DISTINCT user_id) as total_users
    FROM retention_flags
    WHERE year = 2021 AND month = 1
    GROUP BY account_id
)

-- Calculate the ratio for each account
SELECT
    j.account_id,
    j.retention_rate / d.retention_rate as ratio
FROM
    jan_retention_table j
LEFT JOIN
    dec_retention_table d ON j.account_id=d.account_id