--Link:https://platform.stratascratch.com/coding/2053-retention-rate?code_type=1


-- Filter for accounts with activities between December and Jan as the base table
WITH base_table AS (
    SELECT
        account_id,
        user_id,
        EXTRACT(MONTH FROM record_date) as month
    FROM
        sf_events
    WHERE
        record_date BETWEEN '2020-12-01' AND '2021-01-31'
    GROUP BY
        account_id, user_id, EXTRACT(MONTH FROM record_date)
    ),

-- For each user, flag if they are retained or not

base_table_flagged AS(
    SELECT
        account_id,
        user_id,
        month,
        CASE
        WHEN LEAD(month) OVER(PARTITION BY account_id,user_id ORDER BY month DESC) IS NOT NULL
        THEN 'retained'
        ELSE NULL
        END as retainership
    FROM
        base_table
    )

-- Calculate the retention rate for the other accounts
SELECT
    account_id,
    SUM(CASE WHEN retainership = 'retained' THEN 1 ELSE 0 END)::NUMERIC / COUNT(user_id)
FROM
    base_table_flagged
GROUP BY
    account_id

--WIP: Need to calculate the retention rate for Dec and Jan separately and then take the ratio of the two