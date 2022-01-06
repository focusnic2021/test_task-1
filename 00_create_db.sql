/* создать новую базу данных. Имя - new_db */
CREATE DATABASE [new_db]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'new_db', FILENAME = N'd:\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\new_db.mdf' , SIZE = 5120KB , FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'new_db_log', FILENAME = N'd:\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\new_db_log.ldf' , SIZE = 1024KB , FILEGROWTH = 10%)
GO
