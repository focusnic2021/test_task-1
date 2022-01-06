USE [new_db]
GO

/****  Покупатели: не менее 100 объектов */
/* создание таблицы customers (покупатели) */
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[customers]') AND type in (N'U'))
DROP TABLE [dbo].[customers]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[customers](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[first_name] [varchar](50) NOT NULL,
	[last_name] [varchar](50) NOT NULL,
	[phone] [varchar](15) NOT NULL,
 CONSTRAINT [PK_customers] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/* ...создание таблицы customers (покупатели) */



		/** таблица-справочник фамилий **/
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dict_first_name]') AND type in (N'U'))
		DROP TABLE [dbo].[dict_first_name]
		GO
		CREATE TABLE [dbo].[dict_first_name](
			[id] [int] IDENTITY(1,1) NOT NULL,
			[first_name] [varchar](50) NOT NULL,
		 CONSTRAINT [PK_dict_first_name] PRIMARY KEY CLUSTERED 
		(
			[id] ASC
		)) ON [PRIMARY]
		GO

		INSERT INTO [dbo].[dict_first_name](first_name)
		VALUES
			('Абакумов'),
			('Баранов'),
			('Вагонов'),
			('Гаишкин'),
			('Дятлов'),
			('Евдокимов'),
			('Жиглов'),
			('Закиров'),
			('Иванов'),
			('Йдовкин'),
			('Ковров'),
			('Ломов'),
			('Михайлов'),
			('Немов'),
			('Оболенский'),
			('Петров'),
			('Ржевский'),
			('Сидоров'),
			('Табаков'),
			('Ухов'),
			('Федоров'),
			('Хрипунов'),
			('Шарапов'),
			('Щеглов'),
			('Эпохин'),
			('Юрочкин'),
			('Янкин')
		GO
		-- SELECT * FROM [dbo].[dict_first_name]
		/** ...таблица-справочник фамилий **/

		/** таблица-справочник имён **/
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dict_last_name]') AND type in (N'U'))
		DROP TABLE [dbo].[dict_last_name]
		GO
		CREATE TABLE [dbo].[dict_last_name](
			[id] [int] IDENTITY(1,1) NOT NULL,
			[last_name] [varchar](50) NOT NULL,
		 CONSTRAINT [PK_dict_last_name] PRIMARY KEY CLUSTERED 
		(
			[id] ASC
		)) ON [PRIMARY]
		GO

		INSERT INTO [dbo].[dict_last_name](last_name)
		VALUES
			('Афанасий'),
			('Борис'),
			('Виталий'),
			('Гоша'),
			('Дмитрий'),
			('Егор'),
			('Женя'),
			('Захар'),
			('Иван'),
			('Йода (мастер)'),
			('Константин'),
			('Леонид'),
			('Михаил'),
			('Николай'),
			('Осип'),
			('Петр'),
			('Радион'),
			('Сергей'),
			('Тихон'),
			('Умар'),
			('Федор'),
			('Харитон'),
			('Шура'),
			('Щ.'),
			('Эдуард'),
			('Юрий'),
			('Яков')
		GO
		-- SELECT * FROM [dbo].[dict_last_name]
		/** ...таблица-справочник имён **/


/* генератор наименований покупателей */
DECLARE @customer_amount SMALLINT		-- общее количество покупателей
DECLARE @customer_number SMALLINT	-- текущий номер покупателя
DECLARE @first_name varchar(50)		-- 
DECLARE @last_name varchar(50)		-- 
DECLARE @phone varchar(15)		
DECLARE @first_name_count SMALLINT		-- общее количество фамилий в справочнике-фамилий
DECLARE @last_name_count SMALLINT		-- общее количество имён в справочнике-имён

SET @customer_amount = 120
SET @customer_number = 1
SELECT @first_name_count = COUNT(id) FROM dict_first_name
SELECT @last_name_count  = COUNT(id) FROM dict_last_name

begin transaction
delete from [dbo].[customers] -- удалить предыдущие записи

while @customer_number <= @customer_amount
	begin
	select @first_name = first_name 
	from [dbo].[dict_first_name] 
	where id = ROUND(RAND()*@first_name_count,0)
	
	select @last_name = last_name 
	from [dbo].[dict_last_name] 
	where id = ROUND(RAND()*@last_name_count,0)

	select @phone = '8 '
		+CAST(ROUND(RAND()*9,0) as CHAR(1))+CAST(ROUND(RAND()*9,0) as CHAR(1))+CAST(ROUND(RAND()*9,0) as CHAR(1))+'-'
		+CAST(ROUND(RAND()*9,0) as CHAR(1))+CAST(ROUND(RAND()*9,0) as CHAR(1))+CAST(ROUND(RAND()*9,0) as CHAR(1))+'-'
		+CAST(ROUND(RAND()*9,0) as CHAR(1))+CAST(ROUND(RAND()*9,0) as CHAR(1))+'-'
		+CAST(ROUND(RAND()*9,0) as CHAR(1))+CAST(ROUND(RAND()*9,0) as CHAR(1))


	INSERT INTO [dbo].[customers](first_name, last_name, phone)
	VALUES(ISNULL(@first_name,''), ISNULL(@last_name,''), ISNULL(@phone,'-'))
	
	set @customer_number = @customer_number + 1
	end
	
commit	

--просмотр таблицы Покупатели:
SELECT * FROM [dbo].[customers] order by first_name, last_name, id