USE [new_db]
GO

/****  
ќстатки товара: в каждом магазине должно оказатьс€ на остатке не менее 15%
и не более 30% позиций товара от общей номенклатуры 
(1000 товаров всего / ¬ каждый магазин не менее 150 и не более 300 позиций товара на остаток).
 оличество каждого товара не более 15 шт. */

/* создание таблицы product_remains (ќстатки товара) */

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
	[order_id] [int] NULL, --по€вл€етс€ ссылка, если были покупки данного товара
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

--внешний ключ на справочник “оваров дл€ обеспечени€ ссылочной целостности:
ALTER TABLE [dbo].[product_remains]  WITH CHECK ADD  CONSTRAINT [FK_product_remains_product_id] FOREIGN KEY([product_id])
REFERENCES [dbo].[products] ([id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[product_remains] CHECK CONSTRAINT [FK_product_remains_product_id]
GO

--внешний ключ на справочник ћагазинов дл€ обеспечени€ ссылочной целостности:
ALTER TABLE [dbo].[product_remains]  WITH CHECK ADD  CONSTRAINT [FK_product_remains_shop_id] FOREIGN KEY([shop_id])
REFERENCES [dbo].[shops] ([id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[product_remains] CHECK CONSTRAINT [FK_product_remains_shop_id]
GO
/* ...создание таблицы product_remains (ќстатки товара) */


-- заполнение таблицы остатками согласно задани€:
DECLARE @lower_percent_product DECIMAL(5,2)
DECLARE @upper_percent_product DECIMAL(5,2)
	SET @lower_percent_product = 15.00
	SET @upper_percent_product = 30.00
DECLARE @percent_product DECIMAL(5,2)
DECLARE @max_product_value TINYINT
	SET @max_product_value = 15
DECLARE @shop_id INT

-- создание курсора дл€ прохождени€ по всем запис€м ћј√ј«»Ќџ
DECLARE shop_Cursor CURSOR FOR
SELECT id FROM shops;
OPEN shop_Cursor;
 
FETCH NEXT FROM shop_Cursor
INTO @shop_id;
 
WHILE @@FETCH_STATUS = 0
BEGIN

	-- случайным образом процент номенклатуры товаров (от 15% до 30%)
	SET @percent_product = @lower_percent_product + ROUND(RAND()*(@upper_percent_product - @lower_percent_product),2)
	
	-- запросить случайное количество случайных записей товара, и добавить его в остатки
	INSERT INTO dbo.product_remains(shop_id, product_id, amount)
	SELECT TOP (@percent_product) PERCENT @shop_id, id, 1 + ROUND(RAND(id*@shop_id* DATEPART(ms, GETDATE()))*( @max_product_value -1),0)  -- количество в этом остатке - от 1 до 15
	FROM dbo.products
	ORDER BY newid();
	
	FETCH NEXT FROM shop_Cursor
	INTO @shop_id;
END;
CLOSE shop_Cursor;
DEALLOCATE shop_Cursor;
GO


/* итоги операции вставки остатков: */
-- все записи в остатках:
SELECT [id],[product_id],[shop_id],[amount], order_id FROM [dbo].[product_remains] ORDER BY shop_id, product_id

-- рапределение остатков по магазинам:
-- SELECT shop_id, COUNT(product_id) as count_product_id FROM [dbo].[product_remains] GROUP BY shop_id ORDER BY shop_id

-- распределение количества на остатках, д.б. до 15шт
-- SELECT DISTINCT amount FROM dbo.product_remains ORDER BY amount