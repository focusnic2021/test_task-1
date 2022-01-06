USE [new_db]
GO

/* создание таблицы документов - покупки со склада */
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[single_orders]') AND type in (N'U'))
DROP TABLE [dbo].[single_orders]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[single_orders](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[shop_id] [int] NOT NULL,
	[product_id] [int] NOT NULL,
	[customer_id] [int] NOT NULL,
	[product_amount] [int] NOT NULL,
	[order_date] [date] NOT NULL,
 CONSTRAINT [PK_orders] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (	PAD_INDEX  = OFF,
		STATISTICS_NORECOMPUTE  = OFF, 
		IGNORE_DUP_KEY = OFF, 
		ALLOW_ROW_LOCKS  = ON, 
		ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[single_orders] ADD  CONSTRAINT [DF_single_orders_order_date]  DEFAULT (getdate()) FOR [order_date]
GO
/* ...создание таблицы документов - покупки со склада */




--просмотреть таблицу (д.б. пуста после этого скрипта, но не после работы _3.sql)
SELECT * FROM [dbo].[single_orders] ORDER BY customer_id, shop_id, product_id