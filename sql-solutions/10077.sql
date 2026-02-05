--Link: https://platform.stratascratch.com/coding/10077-income-by-title-and-gender?code_type=1

-- Roll up bonuses for each employee
WITH bonus_agg_table AS (
    SELECT
        worker_ref_id,
        SUM(bonus) as total_bonus
    FROM
        sf_bonus
    GROUP BY
        worker_ref_id
),

-- Inner join to salary table to bonus_agg_table + calculate total compensation
full_emp_table AS (
    SELECT
        sfe.*,
        bat.total_bonus,
        sfe.salary + bat.total_bonus as total_compensation
    FROM
        sf_employee sfe
    INNER JOIN
        bonus_agg_table bat ON sfe.id = bat.worker_ref_id
)

-- Calculate average total compensation by gender and title
SELECT
    employee_title as title,
    sex as gender,
    AVG(total_compensation) as average_total_compensation
FROM
    full_emp_table
GROUP BY
    employee_title, sex