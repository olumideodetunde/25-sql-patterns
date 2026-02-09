--Link: https://platform.stratascratch.com/coding/10296-facebook-accounts?code_type=1

-- Get all accounts for jan 10 2020 with status record
WITH account_10_jan AS (
    SELECT
        *
    FROM
        fb_account_status
    WHERE
        status_date = '2020-01-10' AND status IS NOT NULL
    )

-- Calculate the ratio, i.e. closed over total
SELECT
    SUM(CASE WHEN status='closed' THEN 1 ELSE 0 END)::NUMERIC / COUNT(status)::NUMERIC as ratio
FROM
    account_10_jan