--Link: https://platform.stratascratch.com/coding/10353-workers-with-the-highest-salaries?code_type=1

--Get the maximum salary for workers with official titles
WITH max_salary_official AS (
    SELECT
        MAX(a.salary) as max_sal
    FROM
        worker a
    INNER JOIN title b on a.worker_id = b.worker_ref_id
)

-- Get the title using the max salary as a condition
SELECT
    b.worker_title as best_paid_title
FROM
    worker a
INNER JOIN
    title b on a.worker_id = b.worker_ref_id
WHERE a.salary = (SELECT max_sal FROM max_salary_official)