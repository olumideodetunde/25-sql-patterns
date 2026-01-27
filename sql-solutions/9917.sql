--Link: https://platform.stratascratch.com/coding/9917-average-salaries?code_type=1

--Get the average salary for each department
WITH depart_avg_sal AS (
    SELECT
    department,
    AVG(salary) as average_dept_salary
    FROM
        employee
    GROUP BY
        department
    )
-- Join and pull what's needed
SELECT
    e.first_name,
    e.salary as emp_salary,
    e.department,
    d.average_dept_salary
FROM
    employee e
LEFT JOIN
    depart_avg_sal d ON e.department = d.department