/*
=========================================================================================================================
Script Name   : ddl_gold.sql
Layer         : Gold (Business Presentation Layer)
=========================================================================================================================
Purpose:
    Create the Gold layer dimensional model for analytics and reporting.
=========================================================================================================================
Description:
    This script creates the Gold layer views following a Star Schema design:
    
    1. dim_customers
       - Consolidates customer information from CRM and ERP systems.
       - Applies business rules for gender and customer attributes.
       - Generates a surrogate key for dimensional modeling.

    2. dim_products
       - Combines product master and category information.
       - Filters to retain only active/current product records.
       - Generates a surrogate key for the product dimension.

    3. fact_sales
       - Stores transactional sales data.
       - Links sales transactions to customer and product dimensions.
       - Contains business measures such as sales amount, quantity, and price.
=========================================================================================================================
Business Rules:
    - CRM is treated as the master source for customer information.
    - ERP data supplements missing customer attributes.
    - Only active product records (prd_end_dt IS NULL) are included.
    - Surrogate keys are generated using ROW_NUMBER().
    - LEFT JOINs preserve fact and dimension completeness.
=========================================================================================================================
Data Model:
    
    dim_products ---- fact_sales ---- dim_customers

=========================================================================================================================
Objects Created:
    - gold.dim_customers
    - gold.dim_products
    - gold.fact_sales
=========================================================================================================================
Dependencies:
    - silver.crm_cust_info
    - silver.erp_cust_az12
    - silver.erp_loc_a101
    - silver.crm_prd_info
    - silver.erp_px_cat_g1v2
    - silver.crm_sales_details
=========================================================================================================================
Execution Notes:
    - Existing views are dropped before recreation.
    - Execute after the Silver layer has been successfully populated.
    - Intended for BI tools, dashboards, and analytical workloads.
=========================================================================================================================
*/

-- =========================================================================================================================
-- CREATING VIEW : gold.dim_customers
-- =========================================================================================================================
DROP VIEW  IF EXISTS gold.dim_customers;

CREATE VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER( ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.cntry AS country,
	ci.cst_marital_status AS marital_status,
	-- crm is the master source for customer data
	CASE 
		WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		ELSE COALESCE(ca.gen, 'n/a')
	END AS gender,
	ca.bdate AS birth_date,
	ci.cst_create_date AS create_date	
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid;

-- =========================================================================================================================
-- CREATING VIEW : gold.dim_products  
-- =========================================================================================================================
DROP VIEW IF EXISTS gold.dim_products;

CREATE VIEW gold.dim_products AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt	AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
-- FILTER : Select only current information and leave historical data
WHERE prd_end_dt IS NULL

-- =========================================================================================================================
-- CREATING VIEW : gold.fact_sales 
-- =========================================================================================================================
  
  
DROP VIEW IF EXISTS gold.fact_sales;

CREATE VIEW gold.fact_sales AS
SELECT 
	sd.sls_ord_num AS order_number,
	pr.product_key,
	cu.customer_key,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS shipping_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS sales_amount,
	sd.sls_quantity AS quantity,
	sd.sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id;




