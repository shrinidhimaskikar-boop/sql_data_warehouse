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







