USE AdventureWorks2019
SET STATISTICS IO, TIME ON

SELECT City, StateProvinceID, PostalCode
FROM Person.Address
WHERE StateProvinceID = 1;
GO







Create Index NCI_KeylookupDemo ON Person.Address (StateProvinceID)
Include (AddressID, PostalCode, City)

