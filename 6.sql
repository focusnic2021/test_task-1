USE [new_db]
GO
/*
6. Напишите запрос, который вернет количество купленного товара во всех магазинах, относительно Покупателя:
“ФИО покупателя | Номер телефона покупателя | Количество”
(Не может быть более 1 строки с одинаковым значением: ФИО покупателя)
*/
SELECT C.id,C.first_name+' '+C.last_name AS "ФИО покупателя"
, C.phone AS "Номер телефона покупателя"
, sum(SO.product_amount) AS "Количество" --, S.shop_name
FROM dbo.single_orders as SO
  INNER JOIN dbo.customers as C ON SO.customer_id = C.id
--  INNER JOIN dbo.shops as S ON SO.shop_id = S.id
GROUP BY C.id,C.first_name+' '+C.last_name, C.phone --, S.shop_name
ORDER BY C.first_name+' '+C.last_name, C.phone --, S.shop_name  


