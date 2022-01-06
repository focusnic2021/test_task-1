USE [new_db]
GO
/*
�������� ������, ������� ������� ��� ������, ������� ������� �� ������ ���� ������� ������������ ������������� ����� ��������.
*/

/*******
������ ������, �� ����� �������. 
��� ���� �����, ��� ��� ������, ������� ����������� � ��������� (������ ���������� ��������).
����� ������������ ��������� �����: ���������� = 0
*******/

SELECT S.shop_name, P.product_name
FROM product_remains as PR
  INNER JOIN dbo.shops as S ON PR.shop_id = S.id
  INNER JOIN dbo.products as P ON PR.product_id = P.id
WHERE PR.amount = 0
GROUP BY S.shop_name, P.product_name
ORDER BY S.shop_name, P.product_name
