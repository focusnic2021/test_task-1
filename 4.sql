USE [new_db]
GO

/*
�������� ������, ������� ������� ���������� ������, ����������� �� ������� � ��� ����������, �� ������ �������:
������������� �������� | ������������ ������ | ���������� �� �������
(�� ����� ���� ����� 1 ������ � ���������� ���������: ������������ �������� | ������������ ������)
*/
SELECT S.shop_name, P.product_name, COUNT(PR.product_id) as count_product_id, SUM(PR.amount) as sum_amount
FROM product_remains as PR
  INNER JOIN shops as S ON PR.shop_id = S.id
  INNER JOIN products as P ON PR.product_id = P.id
GROUP BY S.shop_name, P.product_name
ORDER BY S.shop_name, P.product_name

--�� ����� ���� ����� 1 ������ � ���������� ���������: ������������ �������� | ������������ ������
SELECT S.shop_name, P.product_name, COUNT(PR.product_id) as count_product_id, SUM(PR.amount) as sum_amount
FROM product_remains as PR
  INNER JOIN shops as S ON PR.shop_id = S.id
  INNER JOIN products as P ON PR.product_id = P.id
GROUP BY S.shop_name, P.product_name
HAVING COUNT(PR.product_id)>1