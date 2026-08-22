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
--------------------------------------------------------------------------------------------------------------------------
--Creating Dimensions: gold.dim_customers
--------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO
  
CREATE VIEW gold.dim_customers AS
SELECT 
  ROW_NUMBER() OVER( ORDER BY cst_id) AS customer_key,  --Surrogate key
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
GO
--------------------------------------------------------------------------------------------------------------------------
--Creating Dimensions: gold.dim_products
--------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key, -- Surrogate key
    pn.prd_id       AS product_id,
    pn.prd_key      AS product_number,
    pn.prd_nm       AS product_name,
    pn.cat_id       AS category_id,
    pc.cat          AS category,
    pc.subcat       AS subcategory,
    pc.maintenance  AS maintenance,
    pn.prd_cost     AS cost,
    pn.prd_line     AS product_line,
    pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL; -- Filter out all historical data
GO

--------------------------------------------------------------------------------------------------------------------------
--Creating Dimensions: gold.fact_sales
--------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num  AS order_number,
    pr.product_key  AS product_key,
    cu.customer_key AS customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt  AS shipping_date,
    sd.sls_due_dt   AS due_date,
    sd.sls_sales    AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price    AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;
GO
