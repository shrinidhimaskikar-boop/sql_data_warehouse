

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

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key, --  Creating surrogate key
    pn.prd_id  AS Product_id,
    pn.prd_key  AS Product_number,
    pn.cat_id  AS Category_id,
    pc.cat  AS Category,
    pn.prd_nm  AS Product_name,
    pc.subcat   AS Subcategory,
    pc.maintenance  AS Maintenance,
    pn.prd_cost  AS Cost,
    pn.prd_line  AS Product_line,
    pn.prd_start_dt AS Start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id
GO

/*============================================================================================================
  Creating dimension: gold.fact_sales
  Execution : SELECT * FROM gold.fact_sales
==============================================================================================================*/
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num  AS Order_number,
    pr.product_key  AS Product_key,
    cu.customer_key AS Customer_key,
    sd.sls_order_dt AS Order_date,
    sd.sls_ship_dt  AS Shipping_date,
    sd.sls_due_dt   AS Due_date,
    sd.sls_sales    AS Sales_amount,
    sd.sls_quantity AS Quantity,
    sd.sls_price    AS Price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;
GO

