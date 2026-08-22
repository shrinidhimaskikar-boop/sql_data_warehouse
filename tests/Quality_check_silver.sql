/*==========================================================================================================
Quality Checks Silver Layer:
=============================================================================================================

Purpose:
The purpose of this script is to check the quality , consistency , formating , standarlization  and accuracy of 
data present in the silver layer.It includes checking of 

-Checking for duplicate or NULL  values for primary keys.
-Unwanted spacing present in the string format vaues.
-Data standarlization and consitency.
-Checking for invalid date ranges.

*/

-- ==============================================================================================================
--CHECKING: 'silver.crm_cust_id'
-- =============================================================================================================
--1.Checking for NULL or duplicate primary key for customer 
SELECT
  cst_id,
  COUNT(*)
FROM silver.crm_cust_id
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

--2.Checking for unwanted spaces
SELECT
  cst_key
FROM silver.crm_cust_id
WHERE cst_key != TRIM(cst_key)

--3.Distinct gender values
SELECT DISTINCT 
cst_gndr
FROM silver.crm_cust_id

--4.Checking of DISTINCT Gender values 
SELECT DISTINCT 
    cst_marital_status 
FROM silver.crm_cust_info;

-- ==============================================================================================================
--CHECKING: 'silver.crm_prd_info'
-- ===============================================================================================================

--1.Checking for NULL OR Duplicate keys.
SELECT
  prd_id,
  COUNT(*) 
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

--2.Checking for invalid cost.
SELECT 
  prd_cost
FROM silver.crm_prd_info
WHERE prd_cost<0 OR prd_cost IS NULL

--3. Unwanting spaces 
SELECT
  prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

--4.Data standarlization and consistency
SELECT  DISTINCT 
  prd_line
FROM silver.crm_prd_info

--5.Invalid Dates 
SELECT
*
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

-- ==============================================================================================================
--CHECKING: 'silver.crm_sales_details'
-- ===============================================================================================================

--1.Checking for invalid date ranges.
SELECT 
    NULLIF(sls_due_dt, 0) AS sls_due_dt 
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
    OR LEN(sls_due_dt) != 8 
    OR sls_due_dt > 20500101 
    OR sls_due_dt < 19000101;

--2.Invalid order dates.
SELECT 
  *
FROM bronze.crm_sales_details
WHERE  sls_order_dt > sls_ship_dt
OR     sls_order_dt > sls_end_dt;

--3.Checking Data consistency i.e (sls_sales = sls_quantity * sls_price )--valid calculation
SELECT DISTINCT 
    sls_sales,
    sls_quantity,
    sls_price 
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- ==============================================================================================================
--CHECKING: 'silver.erp_cust_az12'
-- ===============================================================================================================

--1.Invalid bdate of the customers
SELECT 
  bdate
FROM silver.erp_cust_az12
WHERE bdate > GETDATE()
   OR bdate < '1924-01-01'

--2.Distinct gender values
SELECT  DISTINCT 
   gen
FROM silver.erp_cust_az12;

-- ==============================================================================================================
--CHECKING: 'silver.erp_loc_a101'
-- ===============================================================================================================

--1.Distinct country values 
SELECT DISTINCT
  cntry           
FROM silver.erp_loc_a101
ORDER BY cntry   


-- ==============================================================================================================
--CHECKING: 'silver.erp_px_cat_g1v2'
-- ===============================================================================================================

--1.Checking for unwanted spaces.
SELECT 
 *
FROM silver.erp_loc_a101
WHERE cat != TRIM(cat)
   OR subcat != TRIM(subcat)
   OR maintenance != TRIM(maintenance)

--2.Distinct maintanance values
SELECT DISTINCT 
  maintanance 
FROM silver.erp_loc_a101








  





