--Missing Index Warning Demo 1

USE AdventureWorks2019
GO
SET STATISTICS IO, TIME ON
-- run the 3 below querries at the same time --If you create an index on a table that has a couple of recommendations, you may loose all of the recommendation
SELECT ProductID
FROM   Sales.SalesOrderDetail
WHERE  UnitPriceDiscount = 0.40;
GO

SELECT SalesOrderID
FROM   Sales.SalesOrderDetail
WHERE  LineTotal = 236.421500;
GO

SELECT SalesOrderID
FROM   Sales.SalesOrderHeader
WHERE  TaxAmt = '10.316';

GO
--find missing indexes 
SELECT s.last_user_seek ,
       d.object_id ,
       d.equality_columns ,
       d.inequality_columns ,
       d.included_columns ,
       d.statement ,
       s.avg_user_impact
FROM   sys.dm_db_missing_index_group_stats AS s
       INNER JOIN sys.dm_db_missing_index_groups AS g ON ( s.group_handle = g.index_group_handle )
       INNER JOIN sys.dm_db_missing_index_details AS d ON ( g.index_handle = d.index_handle );



	   -- get missing index with creation print

	   -- FIND MISSING INDEX - Exact

SELECT  sys.objects.name
, (avg_total_user_cost * avg_user_impact) * (user_seeks + user_scans) AS Impact
,  'CREATE NONCLUSTERED INDEX ix_IndexName ON ' + sys.objects.name COLLATE DATABASE_DEFAULT + ' ( ' + IsNull(mid.equality_columns, '') + CASE WHEN mid.inequality_columns IS NULL 
                THEN ''  
    ELSE CASE WHEN mid.equality_columns IS NULL 
                    THEN ''  
        ELSE ',' END + mid.inequality_columns END + ' ) ' + CASE WHEN mid.included_columns IS NULL 
                THEN ''  
    ELSE 'INCLUDE (' + mid.included_columns + ')' END + ';' AS CreateIndexStatement
, mid.equality_columns
, mid.inequality_columns
, mid.included_columns 
    FROM sys.dm_db_missing_index_group_stats AS migs 
            INNER JOIN sys.dm_db_missing_index_groups AS mig ON migs.group_handle = mig.index_group_handle 
            INNER JOIN sys.dm_db_missing_index_details AS mid ON mig.index_handle = mid.index_handle AND mid.database_id = DB_ID() 
            INNER JOIN sys.objects WITH (nolock) ON mid.OBJECT_ID = sys.objects.OBJECT_ID 
    WHERE     (migs.group_handle IN 
        ( 
        SELECT     TOP (500) group_handle 
            FROM          sys.dm_db_missing_index_group_stats WITH (nolock) 
            ORDER BY (avg_total_user_cost * avg_user_impact) * (user_seeks + user_scans) DESC))  
        AND OBJECTPROPERTY(sys.objects.OBJECT_ID, 'isusertable')=1 
    ORDER BY 2 DESC , 3 DESC 


	   --Create only one of the index 
-- DROP INDEX NCI_SalesOrderDetail_UnitPriceDiscount ON [Sales].[SalesOrderDetail]
CREATE INDEX NCI_SalesOrderDetail_UnitPriceDiscount
ON [Sales].[SalesOrderDetail] ([UnitPriceDiscount])
INCLUDE ([ProductID])



Drop index NCI_SalesOrderDetail_UnitPriceDiscount
ON [Sales].[SalesOrderDetail] --([UnitPriceDiscount])