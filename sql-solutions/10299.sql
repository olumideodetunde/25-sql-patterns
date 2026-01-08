--Link - https://platform.stratascratch.com/coding/10299-finding-updated-records?code_type=1
--Get all the ids and current salary
WITH max_sal_table AS (
    SELECT
        id,
        MAX(salary) AS current_salary
    FROM ms_employee_salary
    GROUP BY id
)

--Select the details needed and filter with max_sal_table
SELECT
    id,
    first_name,
    last_name,
    department_id,
    salary
FROM ms_employee_salary
WHERE (id, salary) IN (SELECT
    id,
    current_salary
FROM max_sal_table)
ORDER BY id