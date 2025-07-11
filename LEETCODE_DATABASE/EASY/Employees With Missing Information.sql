SELECT EMPLOYEE_ID 
FROM (
    SELECT s.employee_id 
    FROM Employees e
    RIGHT JOIN Salaries s ON e.employee_id = s.employee_id
    WHERE e.employee_id IS NULL  -- Salaries without matching Employees

    UNION 

    SELECT e.employee_id
    FROM Employees e
    LEFT JOIN Salaries s ON e.employee_id = s.employee_id
    WHERE s.employee_id IS NULL  -- Employees without matching Salaries
) AS NULLTABLE
ORDER BY EMPLOYEE_ID;
