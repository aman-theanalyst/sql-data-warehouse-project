-- Data Transformation and Cleaning

SELECT * 
FROM bronze.erp_cust_az12;

-- Remove 'NAS' prefix if present
SELECT
	cid,
	CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LENGTH(cid))
		ELSE cid
	END AS cid
FROM bronze.erp_cust_az12;

-- Set future bdate to null
SELECT
	bdate,
	CASE WHEN bdate > NOW() THEN NULL
		ELSE bdate
	END AS bdate
FROM bronze.erp_cust_az12;

-- Normalize gender values and ahndle unkown cases
SELECT DISTINCT
	gen,
	CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
		 WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
		 ELSE 'n/a'
	END AS gen
FROM bronze.erp_cust_az12;

