USE [new_db]
GO
/*
6. �������� ������, ������� ������ ���������� ���������� ������ �� ���� ���������, ������������ ����������:
���� ���������� | ����� �������� ���������� | ����������
(�� ����� ���� ����� 1 ������ � ���������� ���������: ��� ����������)
*/
SELECT C.id,C.first_name+' '+C.last_name AS "��� ����������"
, C.phone AS "����� �������� ����������"
, sum(SO.product_amount) AS "����������" --, S.shop_name
FROM dbo.single_orders as SO
  INNER JOIN dbo.customers as C ON SO.customer_id = C.id
--  INNER JOIN dbo.shops as S ON SO.shop_id = S.id
GROUP BY C.id,C.first_name+' '+C.last_name, C.phone --, S.shop_name
ORDER BY C.first_name+' '+C.last_name, C.phone --, S.shop_name  


