USE [new_db]
GO
/*
5. �������� ������, ������� ������ ���������� � ��������� ������� ������� ������:
������������� ������ | ������������ ��������| ���� � ����� �������.
(�� ����� ���� ����� 1 ������ � ���������� ���������: ������������ ������)
*/

SELECT P.product_name, S.shop_name, MAX(SO.order_date) as last_order_date
FROM dbo.single_orders as SO
  INNER JOIN dbo.products as P ON SO.product_id = P.id
  INNER JOIN dbo.shops as S ON SO.shop_id = S.id
GROUP BY P.product_name, S.shop_name
ORDER BY P.product_name, S.shop_name


-- �� ����� ���� ����� 1 ������ � ���������� ���������: ������������ ������
SELECT P.product_name, S.shop_name, MAX(SO.order_date) as last_order_date, COUNT(SO.id)
FROM dbo.single_orders as SO
  INNER JOIN dbo.products as P ON SO.product_id = P.id
  INNER JOIN dbo.shops as S ON SO.shop_id = S.id
GROUP BY P.product_name, S.shop_name
HAVING COUNT(SO.id)>1