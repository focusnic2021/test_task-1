USE [new_db]
GO

/****  Магазины: не менее 100 объектов */
/* создание таблицы shops (магазины) */
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_product_remains_shop_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[product_remains]'))
ALTER TABLE [dbo].[product_remains] DROP CONSTRAINT [FK_product_remains_shop_id]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[shops]') AND type in (N'U'))
DROP TABLE [dbo].[shops]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[shops](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[shop_name] [varchar](50) NOT NULL,
	[address] [varchar](50) NOT NULL,
 CONSTRAINT [PK_shops] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/* ...создание таблицы shops (магазины) */



		/** таблица-справочник адресов **/
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dict_streets]') AND type in (N'U'))
		DROP TABLE [dbo].[dict_streets]
		GO
		CREATE TABLE [dbo].[dict_streets](
			[id] [int] IDENTITY(1,1) NOT NULL,
			[street_name] [varchar](50) NOT NULL,
		 CONSTRAINT [PK_dict_streets] PRIMARY KEY CLUSTERED 
		(
			[id] ASC
		)) ON [PRIMARY]
		GO

		INSERT INTO [dbo].[dict_streets](street_name)
		VALUES
			('Красная ул.'),
			('Оранжевая ул.'),
			('Жёлтая ул.'),
			('Зелёная ул.'),
			('Голубая ул.'),
			('Синяя ул.'),
			('Фиолетовая ул.'),
			('Абрикосовая ул.'),
			('Виноградная ул.'),
			('Тенистая ул.')
		GO
		-- SELECT * FROM [dbo].[dict_streets]
			
		/** ...таблица-справочник адресов **/

/* генератор наименований магазинов */
DECLARE @shops_amount SMALLINT		-- общее количество магазинов
DECLARE @shop_name_number SMALLINT	-- текущий номер магазина
DECLARE @shop_name varchar(50)		-- наиманование конкретного магазина
DECLARE @shop_address varchar(50)	-- адрес конкретного магазина

SET @shops_amount = 100
SET @shop_name_number = 1

begin transaction
delete from [dbo].[shops] -- удалить предыдущие записи

while @shop_name_number <= @shops_amount
	begin
	select @shop_name = 'Магазин '+ CAST(@shop_name_number as CHAR(3))	
	
	select @shop_address = street_name + ', '+CAST(ROUND(RAND()*100,0)as CHAR(3))
	from [dbo].[dict_streets] 
	where id = ROUND(RAND()*10,0)
	
	INSERT INTO [dbo].[shops](shop_name, address)
	VALUES(@shop_name, @shop_address)
	
	set @shop_name_number = @shop_name_number + 1
	end
	
commit	

--просмотр таблицы shops:
SELECT * FROM [dbo].[shops]