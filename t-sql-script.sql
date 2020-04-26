--建立標準 View
--DROP VIEW [Sales].[SalesOrdersNormalView]
--GO
CREATE VIEW [Sales].[SalesOrdersNormalView]
AS
SELECT [Header].[SalesOrderID]
	,[Detail].[SalesOrderDetailID]
	,[Product].[ProductID]

	,[Header].[SalesOrderNumber]
	,[Header].[AccountNumber]
	,[Product].[Name] [ProductName]
	,[Product].[ProductNumber]
	,[Product].[Color]
	,[Detail].[UnitPrice]
	,[Detail].[UnitPriceDiscount]
	,[Detail].[LineTotal]

FROM [Sales].[SalesOrderHeader] [Header]
	INNER JOIN [Sales].[SalesOrderDetail] [Detail]
		ON [Header].[SalesOrderID] = [Detail].[SalesOrderID]
	INNER JOIN [Production].[Product]
		ON [Detail].[ProductID] = [Product].[ProductID]
GO

DECLARE @SalesOrderID INT

SET @SalesOrderID = 43659

SET STATISTICS IO ON

SELECT [SalesOrderID]
	,[SalesOrderDetailID]
	,[ProductID]
	,[SalesOrderNumber]
	,[AccountNumber]
	,[ProductName]
	,[ProductNumber]
	,[Color]
	,[UnitPrice]
	,[UnitPriceDiscount]
	,[LineTotal]
FROM [Sales].[SalesOrdersNormalView]
WHERE [SalesOrderID] = @SalesOrderID

SET STATISTICS IO OFF

/*
Table 'Product'. Scan count 0, logical reads 24, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'SalesOrderDetail'. Scan count 1, logical reads 3, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'SalesOrderHeader'. Scan count 0, logical reads 3, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
*/
GO

--建立 Index View
--DROP VIEW [Sales].[SalesOrdersIndexedView]
--GO
CREATE VIEW [Sales].[SalesOrdersIndexedView]
	WITH SCHEMABINDING
AS
SELECT [Header].[SalesOrderID]
	,[Detail].[SalesOrderDetailID]
	,[Product].[ProductID]

	,[Header].[SalesOrderNumber]
	,[Header].[AccountNumber]
	,[Product].[Name] [ProductName]
	,[Product].[ProductNumber]
	,[Product].[Color]
	,[Detail].[UnitPrice]
	,[Detail].[UnitPriceDiscount]
	,[Detail].[LineTotal]

FROM [Sales].[SalesOrderHeader] [Header]
	INNER JOIN [Sales].[SalesOrderDetail] [Detail]
		ON [Header].[SalesOrderID] = [Detail].[SalesOrderID]
	INNER JOIN [Production].[Product]
		ON [Detail].[ProductID] = [Product].[ProductID]
GO

CREATE UNIQUE CLUSTERED INDEX [UN_SalesOrdersIndexedView]
	ON [Sales].[SalesOrdersIndexedView]([SalesOrderDetailID])
GO

--確認執行計畫
DECLARE @SalesOrderID INT

SET @SalesOrderID = 43659

SET STATISTICS IO ON

SELECT [SalesOrderID]
	,[SalesOrderDetailID]
	,[ProductID]
	,[SalesOrderNumber]
	,[AccountNumber]
	,[ProductName]
	,[ProductNumber]
	,[Color]
	,[UnitPrice]
	,[UnitPriceDiscount]
	,[LineTotal]
FROM [Sales].[SalesOrdersIndexedView] WITH (NOEXPAND)
WHERE [SalesOrderID] = @SalesOrderID

SET STATISTICS IO OFF

/*
Table 'SalesOrdersIndexedView'. Scan count 1, logical reads 2636, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
*/
GO