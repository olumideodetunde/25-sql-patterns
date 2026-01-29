--Link: https://platform.stratascratch.com/coding/10300-premium-vs-freemium?code_type=1

-- Build the table to see the paying or non-paying users using ms_user_dimension as the bridge table
WITH base_table AS (
    SELECT
        mud.user_id,
        mud.acc_id,
        mac.paying_customer,
        mdf.date,
        mdf.downloads
    FROM
        ms_user_dimension mud
    LEFT JOIN
        ms_acc_dimension mac ON mud.acc_id = mac.acc_id
    LEFT JOIN
        ms_download_facts mdf ON mud.user_id = mdf.user_id
    ),

-- Calculate the total paying user downloads by date
total_paying_table AS (
    SELECT
        date,
        SUM(downloads) as paying_user_download_totals
    FROM
        base_table
    WHERE
        paying_customer='yes'
    GROUP BY
        date
    ),

-- Calculate the total non-paying user downloads by date
total_non_paying_table AS (
    SELECT
        date,
        SUM(downloads) as non_paying_user_download_totals
    FROM
        base_table
    WHERE
        paying_customer='no'
    GROUP BY
        date
    )

-- Output results as needed
SELECT
    COALESCE(tpt.date, tnpt.date) as date,
    tnpt.non_paying_user_download_totals,
    tpt.paying_user_download_totals
FROM
    total_paying_table tpt
FULL JOIN
    total_non_paying_table tnpt ON tpt.date = tnpt.date
WHERE
    tnpt.non_paying_user_download_totals > tpt.paying_user_download_totals
ORDER BY
    date