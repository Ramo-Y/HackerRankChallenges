--
-- Solution for 'New Companies' (MS SQL)
--
SELECT com.company_code
	,com.founder
	,COUNT(DISTINCT lem.lead_manager_code)
	,COUNT(DISTINCT sen.senior_manager_code)
	,COUNT(DISTINCT man.manager_code)
	,COUNT(DISTINCT emp.employee_code)
FROM Company com
INNER JOIN Lead_Manager lem ON lem.company_code = com.company_code
INNER JOIN Senior_Manager sen ON sen.company_code = com.company_code
INNER JOIN Manager man ON man.company_code = com.company_code
INNER JOIN Employee emp ON emp.company_code = com.company_code
GROUP BY com.company_code
	,com.founder
ORDER BY com.company_code

--
-- Second Solution with less joins
--
SELECT com.Company_code
	,com.founder
	,COUNT(DISTINCT emp.Lead_Manager_code)
	,COUNT(DISTINCT emp.senior_manager_code)
	,COUNT(DISTINCT emp.manager_code)
	,COUNT(DISTINCT emp.employee_code)
FROM Company com
INNER JOIN Employee emp ON emp.Company_Code = com.Company_Code
GROUP BY com.Company_Code
	,com.founder
ORDER BY com.Company_code
