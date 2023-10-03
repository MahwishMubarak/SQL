
CREATE TABLE EmployeeErrors 
(EmpID VARCHAR(50),
FirstName varchar(50),
LastName varchar (50)
)
INSERT INTO EmployeeErrors VALUES
(1001   , 'KIN', 'CRUISEkl'),
(   1002, 'TOM', 'HORTON'),
(1005, 'HELLO', 'NIMRAT_hty')
-- TRIM STRING
SELECT EMPID, TRIM(EMPID)
FROM EmployeeErrors
--LTRIM
SELECT EMPID, LTRIM(EMPID)
FROM EmployeeErrors
--RTRIM
SELECT EMPID, RTRIM(EMPID)
FROM EmployeeErrors
-- USING REPLACE
SELECT LastName , REPLACE(LastName, '_hty', '')
from EmployeeErrors
--USING SUBSTRING(FUZZY MATCHING)
SELECT SUBSTRING(err.LastName,1,3), SUBSTRING(dem.LastName,1,3)
from EmployeeErrors err
join [first database]..EmployeeDemographics dem
on SUBSTRING(err.LastName,1,3) = SUBSTRING(dem.LastName,1,3)
-- USING UPPER, LOWER 
SELECT FirstName, upper(firstname) uppfir
from EmployeeErrors
SELECT FirstName, LOWER(firstname) LOWfir
from EmployeeErrors

--STORED PROCEDURES 
Create Procedure Test 
AS 
SELECT * 
FROM [first database]..EmployeeDemographics
EXEC TEST

-- USING SUBQUERIES 
--SUBQUERY in SELECT
SELECT EmployeeID, Salary, (Select AVG(Salary) from [first database]..EmployeeSalary) avgsal
FROM [first database]..EmployeeSalary
--by partition by 
SELECT EmployeeID, Salary, AVG(Salary) over () avgsal
FROM [first database]..EmployeeSalary
--group by does not work
--subquery in from statement
 select a.EmployeeID,avgsal from (SELECT EmployeeID, Salary, AVG(Salary) over () avgsal
FROM [first database]..EmployeeSalary) a
--using in where statement
select employeeID, Salary, jobtitle
from [first database]..EmployeeSalary
where EmployeeID in (select EmployeeID from [first database]..EmployeeDemographics
where age > 30)