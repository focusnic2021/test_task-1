USE [new_db]
GO

/*
3. »нициаци€ покупок.
¬ результате должен получитьс€ скрипт, который создаст документы по следующему алгоритму:
-  аждый покупатель должен купить в каждом магазине не менее 3% и не более 7% от наход€щегос€ на остатке товара
*/
/*****************
—крипт реализован через двойной курсор - цикл в цикле. ѕоэтому долго. –аботает около 30 сек
*****************/

delete from dbo.single_orders; -- удалить предыдущие записи

DECLARE @lower_percent_sale DECIMAL(5,2)
DECLARE @upper_percent_sale DECIMAL(5,2)
	SET @lower_percent_sale = 3
	SET @upper_percent_sale = 7
DECLARE @percent_sale DECIMAL(5,2)
DECLARE @customer_id INT
DECLARE @shop_id INT
DECLARE @product_id INT
DECLARE @dd TINYINT, @mm TINYINT, @yyyy SMALLINT
	select @dd = DAY(GETDATE()), @mm = MONTH(GETDATE()), @yyyy = YEAR(GETDATE())
DECLARE @order_date DATE


-- создание курсора дл€ прохождени€ по всем запис€м ѕќ ”ѕј“≈Ћ»
DECLARE customers_Cursor CURSOR SCROLL_LOCKS FOR
SELECT id as customer_id FROM dbo.customers;
OPEN customers_Cursor;

FETCH NEXT FROM customers_Cursor
INTO @customer_id;

WHILE @@FETCH_STATUS = 0
BEGIN

	-- ¬нутренний цикл по всем магазинам, где скупает товары ѕќ ”ѕј“≈Ћ№...
	DECLARE shops_Cursor CURSOR SCROLL_LOCKS FOR
	SELECT id as shop_id FROM dbo.shops;
	OPEN shops_Cursor;

	FETCH NEXT FROM shops_Cursor
	INTO @shop_id;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN	
		-- текущий ѕќ ”ѕј“≈Ћ№ скупает в каждом магазине от 3% до 7% всех товаров (скупает весь остаток, что есть)
		-- процент записей о товарах дл€ данного ѕќ ”ѕј“≈Ћя и магазина 
		SET @percent_sale = @lower_percent_sale + ROUND(RAND()*(@upper_percent_sale - @lower_percent_sale),2)	
		-- PRINT '@customer_id='+CAST(@customer_id as char(3))+', @shop_id='+CAST(@shop_id as char(3))+', @percent_sale='+CAST(@percent_sale as char(5))
		SET @order_date = 
			CAST(CAST(@yyyy as CHAR(4))+'-'+
				CAST(1+ROUND(RAND()*(@mm-1),0) as CHAR(2))+'-'+
				CAST(1+ROUND(RAND()*(@dd-1),0) as CHAR(2)) 
			as DATE)
		
		--добавить документ о продаже товара
		INSERT INTO dbo.single_orders(customer_id, shop_id, product_id, product_amount, order_date)
		SELECT TOP (@percent_sale) PERCENT @customer_id, @shop_id, product_id, amount, @order_date 
		FROM (	SELECT * FROM dbo.product_remains
				WHERE shop_id = @shop_id AND amount > 0 AND order_id is null) as non_sales_remains
		ORDER BY newid();
		
		FETCH NEXT FROM shops_Cursor
		INTO @shop_id;
	END;
	CLOSE shops_Cursor;
	DEALLOCATE shops_Cursor;
	-- ...¬нутренний цикл по всем магазинам, где скупает товары ѕќ ”ѕј“≈Ћ№
	
	-- изменить записи в "ќстатках": 
	--  уменьшить количество на купленное (в ноль), 
	--  приписать номер ƒокумента, по которому прошла сделка (order_id)
	UPDATE PR
	SET order_id = SO.id, amount = PR.amount - SO.product_amount
	FROM dbo.single_orders as SO
	  INNER JOIN product_remains as PR ON SO.shop_id = PR.shop_id AND SO.product_id = PR.product_id
	WHERE SO.customer_id = @customer_id
	
	FETCH NEXT FROM customers_Cursor
	INTO @customer_id;
END;
CLOSE customers_Cursor;
DEALLOCATE customers_Cursor;
GO

	
-- что в итоге в singe_orders (продажи) и product_remains(остатки в магазинах)?
SELECT PR.id as pr_id, PR.shop_id as pr_shop_id, PR.product_id as pr_product_id, PR.amount as pr_amount, PR.order_id as pr_order_id
, SO.id as so_id, SO.shop_id as so_shop_id, SO.product_id as so_product_id, SO.customer_id as so_customer_id, SO.product_amount as so_product_amount, SO.order_date as so_order_date 
FROM dbo.single_orders as SO
  INNER JOIN product_remains as PR ON SO.shop_id = PR.shop_id AND SO.product_id = PR.product_id
--WHERE PR.order_id <> SO.id
ORDER BY so.customer_id, so.shop_id, so.product_id