USE [new_db]
GO
/*
7. �������� ������, ������� ������ ��� ������, ������� ������� �� ����������� �� � ����� ���������, �� ���� �� ��������.
*/

SELECT DISTINCT P.id, P.product_name
FROM dbo.product_remains as PR
  INNER JOIN dbo.products as P ON PR.product_id = P.id
WHERE PR.product_id NOT IN (SELECT DISTINCT product_id FROM dbo.single_orders)