--Link: https://platform.stratascratch.com/coding/10318-new-products?code_type=1
-- For each company get product count for each year
WITH product_count_2019 AS (
    SELECT
        company_name,
        Count(product_name) as count_2019
    FROM
        car_launches
    WHERE
        year = '2019'
    GROUP BY
        company_name
),

product_count_2020 AS (
    SELECT
        company_name,
        Count(product_name) as count_2020
    FROM
        car_launches
    WHERE
        year = '2020'
    GROUP BY
        company_name

)

-- Take the difference between both counts
SELECT
    COALESCE(a.company_name, b.company_name) as company_name,
    COALESCE (b.count_2020, 0) - COALESCE(a.count_2019,  0) AS net_products
FROM
    product_count_2019 a
FULL JOIN
    product_count_2020 b ON a.company_name = b.company_name