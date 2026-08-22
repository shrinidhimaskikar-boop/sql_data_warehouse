/*
=====================================================================================================================
QUALITY CHECK:
=======================================================================================================================
Purpose:
The purpose of this script is to create a view for GOLD layer in the Data Warehouse.
The gold layer represents the final dimensions and fact values
Each view performs operations like transformation and combines the data from Silver Layer to produce clean data,
consistency in the formatting by providing values which are business related.

Execution:
SELECT 
*
FROM gold.dim_customers
===========================================================================================================================
*/

CREATE VIEW gold.dim_customers AS
SELECT 
  ROW_NUMBER() OVER( ORDER BY cst_id) AS customer_key,
  ci.cst_id AS Customer_ID,
  ci.cst_key AS Customer_name,
  ci.cst_firstname AS Customer_firstname,
  ci.cst_firstname AS Customer_lastname,
  ci.cst_marital_status AS Customer_maritalstatus,
  CASE 
      WHEN  cst_gndr != 'N/A' THEN cst_gndr
      ELSE COALESCE(cst_gndr,'N/A')
  END AS Customer_gender,   
  ci.cst_create_date,
  ca.BDATE,
  la.CNTRY
FROM silver.crm_cust_id ci
LEFT JOIN silver.erp_cust_AZ12 ca
  ON ci.cst_key=ca.CID
LEFT JOIN silver.erp_loc_A101 la 
   ON ci.cst_key=la.CID
