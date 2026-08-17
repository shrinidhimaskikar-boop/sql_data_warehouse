/*  
=====================================================================================
Creating Database And Schemas :
====================================================================================

Purpose:
1.The purpose of writing this script is to create a new Database -DataWarehouse.
2.If the database already exists then first step will be drop the database and create a brand new one 
3.Creating 3 schemas as Bronze,Silver,Gold

*/

USE master;
GO 

--Droping the databse if it exists
IF EXISTS ( SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
  
     ALTER Database DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
     DROP Database DataWarehouse;
END;
GO

--Creating DataWarehouse Database:
CREATE DATABASE DataWarehouse;
GO
--Entering into DataWarehouse Database:
USE DataWarehouse;
GO
--Creating 3 schemas:
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO

