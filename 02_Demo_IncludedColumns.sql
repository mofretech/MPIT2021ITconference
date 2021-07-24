--Demo2_IncludedColumns

USE AdventureWorks2019
GO
SET STATISTICS IO, TIME ON

SELECT AddressLine1, AddressLine2, City, StateProvinceID, PostalCode
FROM Person.Address
WHERE PostalCode BETWEEN '98000' and '99999';
GO
-- Create this index without included columns first
Create INDEX IX_Address_PostalCode
ON Person.Address (PostalCode)

--Create included column index
CREATE INDEX IX_Address_PostalCode
ON Person.Address (PostalCode)
INCLUDE (AddressLine1, AddressLine2, City, StateProvinceID);
GO

--drop index
DROP INDEX IX_Address_PostalCode
ON Person.Address

--key lookups 
SELECT NationalIDNumber, HireDate, MaritalStatus
FROM HumanResources.Employee
WHERE NationalIDNumber = N'14417807'


--create an index to include the other two columns in that query
CREATE INDEX NCI_KL_Demo on HumanResources.Employee (NationalIDNumber) INCLUDE (HireDate, MaritalStatus)

--Drop INDEX NCI_KL_Demo on HumanResources.Employee




--We are going to select a a comment field
SELECT Comments
FROM Production.ProductReview 
WHERE ProductID = 937;
GO

-- Should have error due to large column
CREATE NONCLUSTERED INDEX IX_ProductReview_ProductID_ReviewerName
ON Production.ProductReview (ProductID, ReviewerName,Comments);
GO

CREATE NONCLUSTERED INDEX IX_ProductReview_ProductID_ReviewerName_Included
ON Production.ProductReview (ProductID, ReviewerName)
INCLUDE (Comments);
GO

Drop INdex IX_ProductReview_ProductID_ReviewerName

ON Production.ProductReview


CREATE NONCLUSTERED INDEX IX_ProductReview_ProductID_ReviewerName_Included
ON Production.ProductReview (ProductID, ReviewerName)
INCLUDE (Comments);
GO