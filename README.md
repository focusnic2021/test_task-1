# test_task-1
My solution to the test problem at the interview

В ходе тестирования при моём поступлении на работу была поставлена следующая задачка:
---------------------------------------------
Тестовое задание SQL. Среднее время выполнения - 2-4 часа.
1. Создайте следующие таблицы:
1) Магазины
2) Товары
3) Остатки товара в магазинах
4) Покупатели
5) Документы
2. Заполните таблицы:
1) Магазины: не менее 100 объектов
2) Товары: не менее 1000 объектов
3) Остатки товара: в каждом магазине должно оказаться на остатке не менее 15% и не более 30% позиций товара от общей номенклатуры (1000 товаров всего / В каждый магазин не менее 150 и не более 300 позиций товара на остаток). Количество каждого товара не более 15 шт.
4) Покупатели: не менее 100 объектов
3. Инициация покупок.
В результате должен получиться скрипт, который создаст документы по следующему алгоритму:
- Каждый покупатель должен купить в каждом магазине не менее 3% и не более 7% от находящегося на остатке товара
4. Напишите запрос, который покажет количество товара, оставшегося на остатке и его количество, на каждый магазин:
“Наименование магазина | Наименование товара | Количество на остатке”
(Не может быть более 1 строки с одинаковым значением: Наименование магазина | Наименование товара)
5. Напишите запрос, который вернет информацию о последней покупке каждого товара:
“Наименование товара | Наименование Магазина| Дата и время покупки”.
(Не может быть более 1 строки с одинаковым значением: Наименование товара)
6. Напишите запрос, который вернет количество купленного товара во всех магазинах, относительно Покупателя:
“ФИО покупателя | Номер телефона покупателя | Количество”
(Не может быть более 1 строки с одинаковым значением: ФИО покупателя)
7. Напишите запрос, который вернет все товары, которые никогда не продавались ни в одном магазинов, но есть на остатках.
8. Напишите запрос, который покажет все товары, которые никогда не смогут быть проданы относительно произведенных ранее действий
---------------------------

Здесь предствлено моё решение данной задачи.
Файлы:

00_create_db.sql - создание тестовой базы данных

01_shops_table.sql - создание таблицы МАГАЗИНЫ и заполнение её тестовыми значениями (не менее 100 объектов)

02_products_table.sql - создание таблицы ТОВАРЫ и заполнение её тестовыми значениями (не менее 1000 объектов)

03_customers_table.sql - создание таблицы ПОКУПАТЕЛИ и заполнение её тестовыми значениями (не менее 100 объектов)

04_product_remains_table.sql - создание таблицы ОСТАТКИ ТОВАРА и заполнение её тестовыми значениями. В каждом магазина на каждую позицию товара генератором случайных чисел формировался процент товара (не менее 15% и не более 30%)

05_single_orders.sql - создание таблицы ДОКУМЕНТЫ

Выполннеие операций, предписанных заданием:

3.sql - Инициация покупок. Каждый покупатель в каждом магазине покупал не менее 3% и не более 7% от находящегося на остатке товара (процент формаруется каждый раз заново в пределах указанных границ)

4.sql, 5.sql, 6.sql, 7.sql, 8.sql - SELECT запросы
