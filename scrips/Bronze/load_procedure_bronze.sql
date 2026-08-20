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
  DECLARE @start_time DATETIME ,@end_time DATETIME,@batch_start DATETIME, @batch_end DATETIME;
  BEGIN TRY
         SET @batch_start=GETDATE();
		 PRINT('===================================================================================')
		 PRINT('Loading Bronze Layer:')
		 PRINT('===================================================================================')

		 PRINT('===================================================================================')
		 PRINT('Loading CRM Tables:')
		 PRINT('===================================================================================')

		SET @start_time=GETDATE();
		PRINT('>>Truncating  bronze.crm_cust_id Table:')
		TRUNCATE TABLE bronze.crm_cust_id
		PRINT('>>Inserting  into  bronze.crm_cust_id Table:')
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
		PRINT('>>Truncating bronze.crm_prd_info  Table:')
		TRUNCATE TABLE bronze.crm_prd_info
		PRINT('>>Inserting  into  bronze.crm_prd_info Table:')
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
		PRINT '-----------------------------------------------------------------------------------------'	


		SET @start_time=GETDATE();
		PRINT('>>Truncating bronze.crm_sales_details Table:')
		TRUNCATE TABLE bronze.crm_sales_details
		PRINT('>>Inserting  into  bronze.crm_sales_details Table:')
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
        PRINT '-----------------------------------------------------------------------------------------'


		SET @start_time=GETDATE();
		PRINT('>>Truncating  bronze.erp_cust_AZ12 Table:')
		TRUNCATE TABLE bronze.erp_cust_AZ12
		 PRINT('>>Inserting  into  bronze.erp_cust_AZ12 Table:')
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
        PRINT '-----------------------------------------------------------------------------------------'



		 PRINT('===================================================================================')
		 PRINT('Loading ERP Tables:')
		 PRINT('===================================================================================')

		SET @start_time=GETDATE();
		PRINT('>>Truncating  bronze.erp_loc_A101 Table:')
		TRUNCATE TABLE bronze.erp_loc_A101
		PRINT('>>Inserting  into  bronze.erp_loc_A101 Table:')
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
        PRINT '-----------------------------------------------------------------------------------------'

		SET @start_time=GETDATE();
		PRINT('>>Truncating bronze.erp_PX_CAT_G1V2 Table:')
		TRUNCATE TABLE bronze.erp_PX_CAT_G1V2
		PRINT('>>Inserting  into  bronze.erp_PX_CAT_G1V2 Table:')
		BULK INSERT bronze.erp_PX_CAT_G1V2
		FROM 'C:\Users\CAPRICON\OneDrive\Desktop\SQL Project1-Data warehouse\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH
		(
		  FIRSTROW=2,
		  FIELDTERMINATOR=',',
		  TABLOCK
		);
		SET @end_time=GETDATE();
		PRINT '>>Load Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'secounds'
        PRINT '-----------------------------------------------------------------------------------------'

			
		SET @batch_end=GETDATE();
		PRINT 'LOADING OF BRONZE IS COMPLETED'
		PRINT 'TOTAL TIME DURATION:' + CAST(DATEDIFF(second,@batch_start, @batch_end) AS NVARCHAR) +'secounds'
        PRINT '-----------------------------------------------------------------------------------------'

			
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
 

