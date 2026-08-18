/*===================================================================================
STORED PROCEDURE: Extracting and loading data  from CSV files.(Bronze_layer_
==================================================================================

Purpose:
1.This script is regarding the procedure which will  extract all the data from CSV files and load it into the Bronze schemas.
2.First it will truncate the bronze tables.
3.Once the entire table becomes empty only then it will load the entire data from CSV files using bulk statments.

Excecution:
The stored procedure can be executed as:
EXEC  bronze.load_bronze
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
  DECLARE @start_time DATETIME ,@end_time DATETIME ,@batch_start DATETIME, @batch_end DATETIME;
  BEGIN TRY

        SET @batch_start=GETDATE();
		PRINT('=============================================')
		PRINT('LOADING CRM TABLE:')
		PRINT('=============================================')

		SET @start_time=GETDATE();
		PRINT('>>TRUNCATION TABLE: bronze.crm_cust_id')
		TRUNCATE TABLE bronze.crm_cust_id;
		PRINT('>>INSERTING DATA INTO TABLE: bronze.crm_cust_id')	
		BULK INSERT bronze.crm_cust_id
		FROM 'C:\Users\CAPRICON\OneDrive\Desktop\SQL Project1-Data warehouse\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH 
		(
		   FIRSTROW=2,
		   FIELDTERMINATOR=',',
		   TABLOCK
		);
		SET @end_time=GETDATE();
		PRINT '>>Load Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'secounds'
		
		SET @start_time=GETDATE();
		PRINT('>>TRUNCATION TABLE: bronze.crm_prd_info')
		TRUNCATE TABLE bronze.crm_prd_info;
		PRINT('>>INSERTING DATA INTO TABLE: bronze.crm_prd_info')
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\CAPRICON\OneDrive\Desktop\SQL Project1-Data warehouse\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH 
		(
		   FIRSTROW=2,
		   FIELDTERMINATOR=',',
		   TABLOCK
		);
		SET @end_time=GETDATE();
		PRINT '>>Load Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'secounds'

	    SET @start_time=GETDATE();
		PRINT('>>TRUNCATION TABLE: bronze.crm_sales_details')
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT('>>INSERTING DATA INTO TABLE: bronze.crm_sales_details')
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\CAPRICON\OneDrive\Desktop\SQL Project1-Data warehouse\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH 
		(
		   FIRSTROW=2,
		   FIELDTERMINATOR=',',
		   TABLOCK
		);
        SET @end_time=GETDATE();
		PRINT '>>Load Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'secounds'

		PRINT('=============================================')
		PRINT('LOADING ERP TABLE:')
		PRINT('=============================================')

		
		SET @start_time=GETDATE();
		PRINT('>>TRUNCATION TABLE: bronze.erp_cust_AZ12')
		TRUNCATE TABLE bronze.erp_cust_AZ12;
		PRINT('>>INSERTING DATA INTO TABLE: bronze.erp_cust_AZ12')
		BULK INSERT bronze.erp_cust_AZ12
		FROM 'C:\Users\CAPRICON\OneDrive\Desktop\SQL Project1-Data warehouse\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH 
		(
		   FIRSTROW=2,
		   FIELDTERMINATOR=',',
		   TABLOCK
		);
        SET @end_time=GETDATE();
		PRINT '>>Load Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'secounds'

		SET @start_time=GETDATE();
		PRINT('>>TRUNCATION TABLE: bronze.erp_loc_A101')
		TRUNCATE TABLE bronze.erp_loc_A101;
		PRINT('>>INSERTING DATA INTO TABLE: bronze.erp_loc_A101')
		BULK INSERT bronze.erp_loc_A101
		FROM 'C:\Users\CAPRICON\OneDrive\Desktop\SQL Project1-Data warehouse\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH 
		(
		   FIRSTROW=2,
		   FIELDTERMINATOR=',',
		   TABLOCK
		);
		SET @end_time=GETDATE();
		PRINT '>>Load Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'secounds'

		SET @start_time=GETDATE();
		PRINT('>>TRUNCATION TABLE: bronze.erp_px_cat_g1v2')
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		PRINT('>>INSERTING DATA INTO TABLE: bronze.erp_px_cat_g1v2')
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\CAPRICON\OneDrive\Desktop\SQL Project1-Data warehouse\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH 
		(
		   FIRSTROW=2,
		   FIELDTERMINATOR=',',
		   TABLOCK
		);
		SET @end_time=GETDATE();
		PRINT '>>Load Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'secounds'

		SET @batch_end=GETDATE();
		PRINT 'LOADING OF BRONZE IS COMPLETED'
		PRINT 'TOTAL TIME DURATION:' + CAST(DATEDIFF(second,@batch_start, @batch_end) AS NVARCHAR) +'secounds'

	END TRY
	BEGIN CATCH  
	    PRINT ('================================================')
	    PRINT('ERROR OCCURED DURING LOADING THE BRONZE LAYER')
		PRINT(' ERROR MESSAGR' + ERROR_MESSAGE());
		PRINT(' ERROR MESSAGR' + CAST(ERROR_NUMBER() AS NVARCHAR));
	    PRINT(' ERROR MESSAGR' + CAST(ERROR_STATE() AS NVARCHAR));
		PRINT ('================================================')
     END CATCH
END
 

