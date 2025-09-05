SELECT column_name, column_name
FROM table
WHERE search_condition;

-- For example:
SELECT first_name, last_name
FROM employees
WHERE DATE BETWEEN '2023-01-01' AND '2023-12-31' AND status = 'active';