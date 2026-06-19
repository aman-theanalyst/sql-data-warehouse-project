SELECT *
FROM bronze.crm_sales_details

--- CHECK QUALITY CONTROL

-- Check spaces in sls_ord_num
SELECT *
FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num)

-- Check for foreign key that connect tabels

SELECT *
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info)

SELECT *
FROM bronze.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info)

-- Check for invalid dates

SELECT 
sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 OR LENGTH(sls_order_dt::TEXT) != 8 ;

SELECT 
sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0 OR LENGTH(sls_ship_dt::TEXT) != 8 ;

SELECT 
sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 OR LENGTH(sls_due_dt::TEXT) != 8 ;


-- Check invalid date order

SELECT
*
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt OR sls_ship_dt > sls_due_dt; 

--- Check Data Consistency btw sales, quantity, price
-- >> Cannot be NULL, Zero or -ve

SELECT DISTINCT
	sls_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
	  OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
	  OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales,	sls_quantity, sls_price;

-- 2 possible solution
-- Data issue fixed in source system or Data issue fixed in data warehouse