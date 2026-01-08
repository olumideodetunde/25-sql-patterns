--Link: https://platform.stratascratch.com/coding/10308-salaries-differences?code_type=1
WITH max_salary_engineering AS (
    SELECT MAX(salary) AS max_sal
    FROM db_employee
    WHERE department_id = 1
),

max_salary_marketing AS (
    SELECT MAX(salary) AS max_sal
    FROM db_employee
    WHERE department_id = 4
)

SELECT ABS(e.max_sal - m.max_sal)
FROM max_salary_engineering AS e, max_salary_marketing AS m