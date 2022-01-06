USE [new_db]
GO

/****  
������� ������: � ������ �������� ������ ��������� �� ������� �� ����� 15%
� �� ����� 30% ������� ������ �� ����� ������������ 
(1000 ������� ����� / � ������ ������� �� ����� 150 � �� ����� 300 ������� ������ �� �������).
���������� ������� ������ �� ����� 15 ��. */

/* �������� ������� product_remains (������� ������) */

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_product_remains_product_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[product_remains]'))
ALTER TABLE [dbo].[product_remains] DROP CONSTRAINT [FK_product_remains_product_id]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_product_remains_shop_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[product_remains]'))
ALTER TABLE [dbo].[product_remains] DROP CONSTRAINT [FK_product_remains_shop_id]
GO

/****** Object:  Table [dbo].[product_remains]    Script Date: 11/16/2021 13:51:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[product_remains]') AND type in (N'U'))
DROP TABLE [dbo].[product_remains]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[product_remains](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[product_id] [int] NOT NULL,
	[shop_id] [int] NOT NULL,
	[amount] [int] NOT NULL,
	[order_id] [int] NULL, --���������� ������, ���� ���� ������� ������� ������
 CONSTRAINT [PK_product_remains] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (	PAD_INDEX  = OFF, 
		STATISTICS_NORECOMPUTE  = OFF, 
		IGNORE_DUP_KEY = OFF, 
		ALLOW_ROW_LOCKS  = ON, 
		ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

--������� ���� �� ���������� ������� ��� ����������� ��������� �����������:
ALTER TABLE [dbo].[product_remains]  WITH CHECK ADD  CONSTRAINT [FK_product_remains_product_id] FOREIGN KEY([product_id])
REFERENCES [dbo].[products] ([id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[product_remains] CHECK CONSTRAINT [FK_product_remains_product_id]
GO

--������� ���� �� ���������� ��������� ��� ����������� ��������� �����������:
ALTER TABLE [dbo].[product_remains]  WITH CHECK ADD  CONSTRAINT [FK_product_remains_shop_id] FOREIGN KEY([shop_id])
REFERENCES [dbo].[shops] ([id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[product_remains] CHECK CONSTRAINT [FK_product_remains_shop_id]
GO
/* ...�������� ������� product_remains (������� ������) */


-- ���������� ������� ��������� �������� �������:
DECLARE @lower_percent_product DECIMAL(5,2)
DECLARE @upper_percent_product DECIMAL(5,2)
	SET @lower_percent_product = 15.00
	SET @upper_percent_product = 30.00
DECLARE @percent_product DECIMAL(5,2)
DECLARE @max_product_value TINYINT
	SET @max_product_value = 15
DECLARE @shop_id INT

-- �������� ������� ��� ����������� �� ���� ������� ��������
DECLARE shop_Cursor CURSOR FOR
SELECT id FROM shops;
OPEN shop_Cursor;
 
FETCH NEXT FROM shop_Cursor
INTO @shop_id;
 
WHILE @@FETCH_STATUS = 0
BEGIN

	-- ��������� ������� ������� ������������ ������� (�� 15% �� 30%)
	SET @percent_product = @lower_percent_product + ROUND(RAND()*(@upper_percent_product - @lower_percent_product),2)
	
	-- ��������� ��������� ���������� ��������� ������� ������, � �������� ��� � �������
	INSERT INTO dbo.product_remains(shop_id, product_id, amount)
	SELECT TOP (@percent_product) PERCENT @shop_id, id, 1 + ROUND(RAND(id*@shop_id* DATEPART(ms, GETDATE()))*( @max_product_value -1),0)  -- ���������� � ���� ������� - �� 1 �� 15
	FROM dbo.products
	ORDER BY newid();
	
	FETCH NEXT FROM shop_Cursor
	INTO @shop_id;
END;
CLOSE shop_Cursor;
DEALLOCATE shop_Cursor;
GO


/* ����� �������� ������� ��������: */
-- ��� ������ � ��������:
SELECT [id],[product_id],[shop_id],[amount], order_id FROM [dbo].[product_remains] ORDER BY shop_id, product_id

-- ������������ �������� �� ���������:
-- SELECT shop_id, COUNT(product_id) as count_product_id FROM [dbo].[product_remains] GROUP BY shop_id ORDER BY shop_id

-- ������������� ���������� �� ��������, �.�. �� 15��
-- SELECT DISTINCT amount FROM dbo.product_remains ORDER BY amount