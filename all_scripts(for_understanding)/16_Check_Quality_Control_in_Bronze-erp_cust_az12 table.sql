
-- DATA QUALITY CHECK
SELECT * 
FROM bronze.erp_cust_az12;

-- Check for cid from both crm_cust_info and erp_cust_az12
SELECT * 
FROM bronze.erp_cust_az12;

SELECT * FROM silver.crm_cust_info;

-- >> We found 'NAS' prefix which should be removed so data can match

SELECT
	cid,
	bdate,
	gen
FROM bronze.erp_cust_az12
WHERE cid LIKE '%AW00011000%';

-- Identify out-of-range bdate

SELECT
	cid,
	bdate,
	gen
FROM bronze.erp_cust_az12
WHERE bdate < '1900-01-01' OR bdate > NOW();

-- Check data standardization and consistency in gender column

SELECT DISTINCT
	gen
FROM bronze.erp_cust_az12




