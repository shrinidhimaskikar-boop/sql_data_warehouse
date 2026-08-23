/*==========================================================================================================
Quality Checks Gold Layer:
=============================================================================================================

Purpose:
The purpose of this cript is to:
1.Check the uniqness of surrogate keys which are generated in the gold layer.
2.Looking after the valididty over the relations genrated between various dimension tables

======================================================================================================================
*/

---------------------------------------------------------------------------------------------------------------------------
--Checking:gold.dim_customers
--Checking the duplicate surrogate key if present
--------------------------------------------------------------------------------------------------------------------------------
SELECT 
  customer_key,
  COUNT(*) AS duplicate 
FROM gold.dim_customers
GROUP BY customer_key 
HAVING COUNT(*) > 1;

---------------------------------------------------------------------------------------------------------------------------
--Checking:gold.fact_sales
--Checking the relations whcih are genrated
-------------------------------------------------------------------------------------------------------------------------------
SELECT 
  *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
 ON c.customer_key = f.Customer_key
LEFT JOIN gold.dim_products p
 ON p.product_key = f.Product_key
WHERE c.customer_key IS  NULL OR p.product_key IS  NULL


