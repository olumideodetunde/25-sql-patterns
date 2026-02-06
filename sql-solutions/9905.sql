--Link:https://platform.stratascratch.com/coding/9905-highest-target-under-manager?code_type=1

-- Trialling subqueries by getting employees under manager 13 that achieved highest target
SELECT
    first_name,
    target
FROM
    salesforce_employees
WHERE
    manager_id=13 AND target = (
                SELECT
                    MAX(target) as maximum_target
                FROM
                    salesforce_employees
                WHERE
                    manager_id=13
                )