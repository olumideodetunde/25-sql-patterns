--Link: https://platform.stratascratch.com/coding/9891-customer-details?code_type=1
SELECT
    c.first_name,
    c.last_name,
    c.city,
    o.order_detailS
FROM
    customerS c
LEFT JOIN
    orderS o ON c.id = o.cust_id