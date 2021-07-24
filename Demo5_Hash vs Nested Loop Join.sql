USE AdventureWorks2019
SET STATISTICS TIME, IO ON

--Nested Loops Example

SELECT OC.FirstName ,
       OC.LastName ,
       OH.SalesOrderID
FROM   Sales.SalesOrderHeader AS OH
      INNER  JOIN Person.Person AS OC ON OH.CustomerID = OC.BusinessEntityID
WHERE  OC.FirstName LIKE 'John%';

--Force Hash  Example

SELECT OC.FirstName ,
       OC.LastName ,
       OH.SalesOrderID
FROM   Sales.SalesOrderHeader AS OH
      INNER HASH JOIN Person.Person AS OC ON OH.CustomerID = OC.BusinessEntityID  --This is hinting the join operator that the optimizer should always use a hash. Dont use always!!! If you think a hash will be better, Then go for it. 
WHERE  OC.FirstName LIKE 'John%';