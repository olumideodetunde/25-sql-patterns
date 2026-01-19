--Link: https://platform.stratascratch.com/coding/10172-best-selling-item?code_type=1

-- Identify returns and cancellations
WITH return AS (
    SELECT
        invoiceno
    FROM
        online_retail
    WHERE
        invoiceno LIKE 'C%'
    ),

-- filter for values with months extracted
online_retail_with_months AS (
    SELECT
        invoiceno,
        invoicedate,
        EXTRACT(month FROM invoicedate) as month,
        quantity,
        description,
        stockcode,
        unitprice
    FROM
        online_retail
    ),

-- Calculate how much is made on each item each month - exclude returns
total_paid_table AS (
    SELECT
        month,
        description,
        SUM(unitprice * quantity) OVER (PARTITION BY month,stockcode) as total_paid
    FROM online_retail_with_months
    WHERE invoiceno NOT IN (SELECT invoiceno FROM return)
    ),

-- Rank items based on total paid amount for each month
total_paid_table_ranked AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY month ORDER BY total_paid DESC) as ranked
    FROM
        total_paid_table
    )

-- Pull best-selling item for each month [deduplication not handled so using distinct to return a row for each month]
SELECT
    DISTINCT (month) as month,
    description,
    total_paid
FROM
    total_paid_table_ranked
WHERE ranked=1
ORDER BY month;