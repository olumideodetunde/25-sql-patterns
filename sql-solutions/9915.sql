--Link: https://platform.stratascratch.com/coding/9915-highest-cost-orders?code_type=1

--Sum the cost for each day for each customer
WITH customer_daily_orders AS (
    SELECT
        cust_id,
        sum(total_order_cost) as cus_total_cost,
        order_date
    FROM
        orders
    GROUP BY
        cust_id, order_date
),

--rank all the orders for each day between the filter constraint
ranked_orders AS (
    SELECT
        c.first_name,
        cdo.cus_total_cost as highest_daily_order,
        cdo.order_date,
        DENSE_RANK() OVER (PARTITION BY cdo.order_date ORDER BY cdo.cus_total_cost DESC) as ranked
    FROM
        customers c
    LEFT OUTER JOIN customer_daily_orders cdo ON c.id = cdo.cust_id
    WHERE cdo.order_date BETWEEN '2019-02-01' AND '2019-05-01'
)

--Select customers with highest orders for each day
SELECT
    first_name,
    highest_daily_order,
    order_date
FROM
    ranked_orders
WHERE ranked = 1;