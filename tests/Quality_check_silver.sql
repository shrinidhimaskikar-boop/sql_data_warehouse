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





