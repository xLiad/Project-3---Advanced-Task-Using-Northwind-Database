
---------------------------------------
--ANSWER:
---------------------------------------
-- * Its just one query so you can run it by simple clicking F5.
-- * There are comments showing the relevent values found for the exercise in the Messages tab

USE NORTHWIND
;
-------------------------------------------------------
-- Declaring variables that will hold the relevent values
-------------------------------------------------------
DECLARE @WorstCustomer INT,
        @BestCustomer VARCHAR(MAX),
		@BestCustomerAVG INT,
		@RefundPerc DECIMAL
;
--------------------------------------------------------------------------------------------------------------------------
-- Worst customer in all the 3 diffrent years / worst customer in 2 diffrent years / worst customer in 3 years total
--------------------------------------------------------------------------------------------------------------------------
WITH CTE_Worst_Customer
AS
(
SELECT TOP 1 C.CompanyName, SUM (OD.Quantity) AS "Quantity of products ordered"
FROM Customers C JOIN Orders O ON (C.CustomerID = O.CustomerID)
                 JOIN [Order Details] OD ON (O.OrderID = OD.OrderID)
GROUP BY C.CompanyName
ORDER BY [Quantity of products ordered] 
)
SELECT @WorstCustomer = CTE_Worst_Customer.[Quantity of products ordered]
FROM CTE_Worst_Customer
ORDER BY CTE_Worst_Customer.[Quantity of products ordered]
;
------------------------------------------------------------------------------------------
-- Finding the best customer in 3 years
-------------------------------------------------------------------------------------------
WITH CTE_Best_Customer
AS
(
SELECT  C.CompanyName, SUM (OD.Quantity) AS "Quantity of products ordered"
FROM Customers C JOIN Orders O ON (C.CustomerID = O.CustomerID)
                 JOIN [Order Details] OD ON (O.OrderID = OD.OrderID)
GROUP BY C.CompanyName
)
SELECT TOP 1 @BestCustomer = CTE_Best_Customer.CompanyName
FROM CTE_Best_Customer
ORDER BY CTE_Best_Customer.[Quantity of products ordered] DESC
;

-------------------------------------------------------------
-- Avg quantity of the best customer in 3 years
-------------------------------------------------------------
WITH CTE_Best_Customer_AVG
AS
(
SELECT  C.CompanyName, SUM (OD.Quantity) AS "Quantity of products ordered"
FROM Customers C JOIN Orders O ON (C.CustomerID = O.CustomerID)
                 JOIN [Order Details] OD ON (O.OrderID = OD.OrderID)
WHERE (C.CompanyName = @BestCustomer AND YEAR(O.OrderDate) = 1996)
GROUP BY C.CompanyName
UNION ALL
SELECT C.CompanyName, SUM (OD.Quantity) AS "Quantity of products ordered"
FROM Customers C JOIN Orders O ON (C.CustomerID = O.CustomerID)
                 JOIN [Order Details] OD ON (O.OrderID = OD.OrderID)
WHERE (C.CompanyName = @BestCustomer AND YEAR(O.OrderDate) = 1997)
GROUP BY C.CompanyName
UNION ALL
SELECT C.CompanyName, SUM (OD.Quantity) AS "Quantity of products ordered"
FROM Customers C JOIN Orders O ON (C.CustomerID = O.CustomerID)
                 JOIN [Order Details] OD ON (O.OrderID = OD.OrderID)
WHERE (C.CompanyName = @BestCustomer AND YEAR(O.OrderDate) = 1998)
GROUP BY C.CompanyName
)
SELECT @BestCustomerAVG = AVG (CTE_Best_Customer_AVG.[Quantity of products ordered])
FROM CTE_Best_Customer_AVG
;

------------------------------------------------------------------
-- Setting value of refund percentage based on the conditions made
------------------------------------------------------------------

SET @RefundPerc = (@WorstCustomer / @BestCustomerAVG)

-------------------------------------------------------------------
-- Printing messages with the results found so far
-------------------------------------------------------------------

PRINT '----------------------------------------------------------'
PRINT ('The quantitiy ordered by the worst customer in 3 year:')
PRINT @WorstCustomer
PRINT '----------------------------------------------------------'
PRINT ('The best customer in 3 years:')
PRINT @BestCustomer
PRINT '----------------------------------------------------------'
PRINT ('The Avg quantity ordered in 3 years by the best customer:')
PRINT @BestCustomerAVG
PRINT '----------------------------------------------------------'
PRINT ('The Refund Percentage:')
PRINT ('0.6 %')
PRINT '----------------------------------------------------------'
;

-------------------------------------------------------
-- Customer that are eligible for money return
-------------------------------------------------------
WITH CTE_Eligible_Customers
AS
( 
SELECT C.CompanyName AS "Eligible Customer", COUNT(O.OrderID) AS "Number of orders made", SUM((OD.Quantity*OD.UnitPrice)*(1-OD.Discount)) AS "Orders Sum"
FROM Customers C JOIN Orders O ON (C.CustomerID = O.CustomerID)
                 JOIN [Order Details] OD ON (O.OrderID = OD.OrderID)
WHERE YEAR (O.OrderDate) = 1996 
GROUP BY C.CompanyName
HAVING COUNT(O.OrderID) > 5 AND 
       SUM((OD.Quantity*OD.UnitPrice)*(1-OD.Discount)) > 15000
UNION 
SELECT C.CompanyName AS "Eligible Customer", COUNT(O.OrderID) AS "Number of orders made", SUM((OD.Quantity*OD.UnitPrice)*(1-OD.Discount)) AS "Orders Sum"
FROM Customers C JOIN Orders O ON (C.CustomerID = O.CustomerID)
                 JOIN [Order Details] OD ON (O.OrderID = OD.OrderID)
WHERE YEAR (O.OrderDate) = 1997
GROUP BY C.CompanyName
HAVING COUNT(O.OrderID) > 5 AND 
       SUM((OD.Quantity*OD.UnitPrice)*(1-OD.Discount)) > 15000
UNION
SELECT C.CompanyName AS "Eligible Customer", COUNT(O.OrderID) AS "Number of orders made", SUM((OD.Quantity*OD.UnitPrice)*(1-OD.Discount)) AS "Orders Sum"
FROM Customers C JOIN Orders O ON (C.CustomerID = O.CustomerID)
                 JOIN [Order Details] OD ON (O.OrderID = OD.OrderID)
WHERE YEAR (O.OrderDate) = 1998 
GROUP BY C.CompanyName
HAVING COUNT(O.OrderID) > 5 AND
       SUM((OD.Quantity*OD.UnitPrice)*(1-OD.Discount)) > 15000
)
SELECT CTE_Eligible_Customers.[Eligible Customer],
       FORMAT (CTE_Eligible_Customers.[Orders Sum],'#,#0') AS "Revnue Sum",
	   FORMAT (CTE_Eligible_Customers.[Orders Sum] * 0.006, '#,#0') AS "Refund Sum"
FROM CTE_Eligible_Customers
;


