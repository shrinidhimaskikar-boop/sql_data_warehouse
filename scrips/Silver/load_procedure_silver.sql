/*
=============================================================================================================
Stored Procedure: Loading  cleaned and organized data from Bronze to Silver layer
============================================================================================================
Purpose:
The purpose of this  procedure sript is to exctract,transform and load  the  data from 'Bronze' schemas to 
'Silver' schemas.

STEPS:
1.Truncate the silver tabel.
2.Insert cleaned and tranformed data from Bronze layer into Silver layer.

EXECUTION;
EXEC Silver.load_silver;
=================================================================================================================
*/
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME; 
    BEGIN TRY
    PRINT '================================================';
    PRINT 'Loading Silver Layer';
    PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '------------------------------------------------';

		-- Updating silver.crm_cust_info
    SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_cust_info';
		TRUNCATE TABLE silver.crm_cust_id;
		PRINT '>> Inserting Data Into: silver.crm_cust_info';
    INSERT INTO silver.crm_cust_id
  ( 
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
  )
  SELECT 
  	cst_id,
  	cst_key,
  	TRIM(cst_firstname) AS cst_firstname,   --Triming the values of fist and last name to avoind any mismatch
  	TRIM(cst_lastname) AS cst_lastname,
  	CASE 
  	     WHEN TRIM(UPPER(cst_marital_status))='S' THEN 'Single'
  		 WHEN TRIM(UPPER(cst_marital_status))='M' THEN 'Married'
  		 ELSE 'N/A'
      END cst_marital_status, --Coverting the marital status value to redable format
  	CASE 
  	     WHEN TRIM(UPPER(cst_gndr))='F' THEN 'Female'
  		 WHEN TRIM(UPPER(cst_gndr))='M' THEN 'Male'
  		 ELSE 'N/A'
      END cst_gndr,           --Converting gender values to redable format 
  	cst_create_date
  FROM
  (
  	SELECT 
  	*,
  	ROW_NUMBER () OVER( PARTITION BY cst_id ORDER BY cst_create_date DESC) AS ranking
  	FROM bronze.crm_cust_id
  	WHERE cst_id IS NOT NULL
  )t
  WHERE ranking=1  
  SET @end_time = GETDATE();
  PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
  PRINT '>> -------------';

--Updating for silver.crm_prd_info
 SET @start_time = GETDATE();
 PRINT '>> Truncating Table: silver.crm_prd_info';
 TRUNCATE TABLE silver.crm_prd_info;
 PRINT '>> Inserting Data Into: silver.crm_prd_info';
 INSERT INTO silver.crm_prd_info
 (
    prd_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
 )

SELECT 
      prd_id,   --Extracted category ID
      SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,    --Extracted product key
      TRIM(prd_nm) AS prd_nm,
      ISNULL(prd_cost, 0)AS prd_cost,
      CASE          
        WHEN UPPER(TRIM(prd_line))='M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line))='R' THEN 'Road'
        WHEN UPPER(TRIM(prd_line))='S' THEN 'Other Sales'
        WHEN UPPER(TRIM(prd_line))='T' THEN 'Touring'
        ELSE 'N/A'                                        --Transformed the map line code into readable format
      END prd_line,
      CAST(prd_start_dt AS DATE) AS prd_start_dt,         
      CAST(LEAD(prd_start_dt)  OVER (PARTITION BY prd_key ORDER BY prd_start_dt )-1 AS DATE) AS prd_end_dt--Calculated the edn date as one day before the next start date
 FROM bronze.crm_prd_info
 SET @end_time = GETDATE()
 PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
 PRINT '>> -------------';


--Updating silver.crm_sales_details
	 SET @start_time = GETDATE();
	 PRINT '>> Truncating Table: silver.crm_sales_detail ';
	 TRUNCATE TABLE silver.crm_sales_details;
	 PRINT '>> Inserting Data Into: silver.crm_sales_detail';
	INSERT INTO  silver.crm_sales_details
	(
	  sls_ord_num ,
	  sls_prd_key,
	  sls_cust_id  ,
	  sls_order_dt ,
	  sls_ship_dt,
	  sls_due_dt ,
	  sls_sales  ,
	  sls_quantity ,
	  sls_price
	)
SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE 
		WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
	   ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
    END AS sls_order_dt,
	CASE 
	    WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
		ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
    END AS sls_ship_dt,
	CASE 
	     WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
		 ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
	END AS sls_due_dt,
	CASE 
	   WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales!= sls_quantity* ABS(sls_price) THEN sls_quantity* ABS(sls_price) 
	   ELSE sls_sales
    END AS sls_sales,
	sls_quantity,
	CASE 
	   WHEN sls_price IS NULL OR sls_price <=0 THEN sls_sales/sls_quantity
	   ELSE sls_price
	 END AS sls_price
FROM bronze.crm_sales_details
SET @end_time = GETDATE()
PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
PRINT '>> -------------';

--Updating silver.erp_cust_AZ12
 SET @start_time = GETDATE();
 PRINT '>> Truncating Table: silver.erp_cust_AZ12';
 TRUNCATE TABLE silver.erp_cust_AZ12;
 PRINT '>> Inserting Data Into: silver.erp_cust_AZ12';
INSERT INTO silver.erp_cust_AZ12
(
  CID,
  BDATE,
  GEN
  )

SELECT 
	CASE
	   WHEN CID  LIKE'NAS%' THEN SUBSTRING(CID,4,LEN(CID)) --Removal of 'NAS' prefix if present
	   ELSE CID
	END AS CID,
	CASE
	     WHEN BDATE> GETDATE() THEN NULL
	     ELSE BDATE 
	END AS BDATE,    --Set future birthdates as NULL
	CASE 
	     WHEN UPPER(TRIM(GEN)) IN('F','Female') THEN 'FEMALE'
	     WHEN UPPER(TRIM(GEN)) IN('M','MALE') THEN 'MALE'
	     ELSE 'N/A'
	END AS GEN
FROM bronze.erp_cust_AZ12 
SET @end_time = GETDATE()
PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
PRINT '>> -------------';

--Updating silver.erp_loc_A101
SET @start_time = GETDATE();
PRINT '>> Truncating Table: silver.erp_loc_a101';
TRUNCATE TABLE silver.erp_loc_a101;
PRINT '>> Inserting Data Into: silver.erp_loc_a101';
INSERT INTO silver.erp_loc_A101
(
  CID,
  CNTRY
)

SELECT
	REPLACE(CID,'-','') AS CID,
	CASE 
	  WHEN TRIM(CNTRY) = 'DE' THEN 'Germany'
	  WHEN TRIM(CNTRY) IN('US','USA') THEN 'United States'
	  WHEN TRIM(CNTRY) IS NULL OR  TRIM(CNTRY)='' THEN 'N/A'
	  ELSE TRIM(CNTRY)
	END AS CNTRY
FROM bronze.erp_loc_A101
SET @end_time = GETDATE();
PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
PRINT '>> -------------';

--Updating silver.erp_px_cat_g1v2
SET @start_time = GETDATE();
PRINT '>> Truncating Table: silver.erp_px_cat_g1v2';
TRUNCATE TABLE silver.erp_px_cat_g1v2;
PRINT '>> Inserting Data Into: silver.erp_px_cat_g1v2';
INSERT INTO silver.erp_px_cat_g1v2
(
  ID,
  CAT,
  SUBCAT,
  MAINTENANCE
 )
SELECT
ID,
CAT,
SUBCAT,
MAINTENANCE
FROM bronze.erp_px_cat_g1v2
SET @end_time = GETDATE();
PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
PRINT '>> -------------';
END TRY
BEGIN CATCH
  PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
END CATCH 
END 

