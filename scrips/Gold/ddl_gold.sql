

/*============================================================================================================
  Creating dimension: gold.dim_customers
  Execution : SELECT * FROM gold.dim_customers
==============================================================================================================*/


IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key, -- Creating  surrogate key
    ci.cst_id  AS Customer_id,
    ci.cst_key  AS Customer_number,
    ci.cst_firstname   AS First_name,
    ci.cst_lastname AS Last_name,
    la.cntry AS Country,
    ci.cst_marital_status AS Marital_status,
    CASE 
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr  -- Here crm is the primary source
        ELSE COALESCE(ca.gen, 'n/a')  			         --If condition not satisfied them it will consider values from erp source
    END AS Gender,
    ca.bdate AS Birthdate,
    ci.cst_create_date AS Create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.cid;
GO

/*============================================================================================================
  Creating dimension: gold.dim_products
  Execution : SELECT * FROM gold.dim_products
==============================================================================================================*/
