--Link: https://platform.stratascratch.com/coding/10304-risky-projects?code_type=1
-- Know the project length in days for each project
WITH linkedin_projects_day AS (
    SELECT
        budget,
        end_date,
        id,
        start_date,
        title,
        end_date - start_date as project_lenght_in_days
    FROM
        linkedin_projects
    ),

-- Know the employees assigned to each project
employees_to_project AS (
    SELECT
        b.id as employment_id,
        b.first_name,
        b.salary,
        a.project_id
    FROM
        linkedin_emp_projects a
    LEFT JOIN
        linkedin_employees b ON a.emp_id = b.id
    ),

-- Calculate the prorated salary for each project
prorated_salary AS (
    SELECT
        l.project_lenght_in_days,
        e.employment_id,
        e.first_name,
        e.salary,
        e.project_id,
        ((e.salary::NUMERIC  / 365) * l.project_lenght_in_days) as salary_for_project --had to cast to numeric to prevent rounding here
    FROM
        employees_to_project e
    LEFT JOIN
        linkedin_projects_day l ON e.project_id = l.id
    ),

-- Roll up the salary for each project
project_expense_table AS (
    SELECT
        project_id,
        CEILING(SUM(salary_for_project)) as prorated_employee_expense
    FROM
        prorated_salary
    GROUP BY
        project_id
)

-- Select the overbudget project
SELECT
    l.title,
    l.budget,
    p.prorated_employee_expense
FROM
    linkedin_projects_day l
LEFT JOIN
    project_expense_table P ON l.id = p.project_id
WHERE p.prorated_employee_expense > l.budget;