SELECT *
FROM bronze.crm_sales_details

-- Remove data
TRUNCATE TABLE silver.crm_sales_details;

-- Inserting Data into silver.crm_sales_details table
INSERT INTO silver.crm_sales_details (
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
)

SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,

	-- Handling invalid date data and converting it to DATE data type
	CASE WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt::TEXT) != 8 THEN NULL
	ELSE TO_DATE(sls_order_dt::TEXT, 'YYYYMMDD')
	END AS sls_order_dt,
	
	CASE WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt::TEXT) != 8 THEN NULL
	ELSE TO_DATE(sls_ship_dt::TEXT, 'YYYYMMDD')
	END AS sls_ship_dt,
	
	CASE WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt::TEXT) != 8 THEN NULL
	ELSE TO_DATE(sls_due_dt::TEXT, 'YYYYMMDD')
	END AS sls_due_dt,

	-- Recalculate sales if original value is missing or incorrect
	CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) 
			THEN sls_quantity * ABS(sls_price)
		 ELSE sls_sales
	END AS sls_sales,

	sls_quantity,

	-- Derive Price if original price is invalid
	CASE WHEN sls_price IS NULL OR sls_price <= 0
			THEN sls_sales / COALESCE(sls_quantity, 0)
		ELSE sls_price
	END AS sls_price
FROM bronze.crm_sales_details;


------------------------------------------------------------------------------------------------------------

-- Quality Check

SELECT *
FROM silver.crm_sales_details;

-- Check invalid date order

SELECT
*
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt OR sls_ship_dt > sls_due_dt; 


-- Check Data Consistency : sales, quantity and price data

SELECT DISTINCT
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
	  OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
	  OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales,	sls_quantity, sls_price;