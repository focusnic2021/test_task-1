USE [new_db]
GO

/****  Товары: не менее 1000 объектов */
/* создание таблицы products (товары) */
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_product_remains_product_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[product_remains]'))
ALTER TABLE [dbo].[product_remains] DROP CONSTRAINT [FK_product_remains_product_id]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[products]') AND type in (N'U'))
DROP TABLE [dbo].[products]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[products](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[product_name] [varchar](50) NOT NULL,
	[property] [varchar](50) NOT NULL,
 CONSTRAINT [PK_products] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (	PAD_INDEX  = OFF, 
		STATISTICS_NORECOMPUTE  = OFF, 
		IGNORE_DUP_KEY = OFF, 
		ALLOW_ROW_LOCKS  = ON, 
		ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/* ...создание таблицы products (товары) */



		/** таблица-справочник свойств товара **/
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dict_product_property]') AND type in (N'U'))
		DROP TABLE [dbo].[dict_product_property]
		GO
		CREATE TABLE [dbo].[dict_product_property](
			[id] [int] IDENTITY(1,1) NOT NULL,
			[property_name] [varchar](50) NOT NULL,
		 CONSTRAINT [PK_dict_product_property] PRIMARY KEY CLUSTERED 
		(
			[id] ASC
		)) ON [PRIMARY]
		GO

		INSERT INTO [dbo].[dict_product_property](property_name)
		VALUES
			('Большой'),
			('Компактный'),
			('Удобный'),
			('Качественный'),
			('Уютный'),
			('Полезный'),
			('Приятный'),
			('Недорогой'),
			('Заманчивый'),
			('Всем нужный')
		GO
		-- SELECT * FROM [dbo].[dict_product_property]
			
		/** ...таблица-справочник свойств товара **/

/* генератор наименований товаров */
DECLARE @product_amount SMALLINT		-- общее количество товаров
DECLARE @product_name_number SMALLINT	-- текущий номер товара
DECLARE @product_name varchar(50)		-- наиманование конкретного товара
DECLARE @property_name varchar(50)		-- свойств конкретного товара  

SET @product_amount = 1000
SET @product_name_number = 1

begin transaction
delete from [dbo].[products] -- удалить предыдущие записи

while @product_name_number <= @product_amount
	begin
	select @product_name = 'Продукт '+ CAST(@product_name_number as CHAR(4))	
	
	select @property_name = property_name + ', '+CAST(ROUND(RAND()*1000,0)as CHAR(4))
	from [dbo].[dict_product_property] 
	where id = ROUND(RAND()*10,0)
	
	INSERT INTO [dbo].[products](product_name, property)
	VALUES(@product_name, @property_name)
	
	set @product_name_number = @product_name_number + 1
	end
	
commit	

--просмотр таблицы products:
SELECT * FROM [dbo].[products]