-- Delete all data in table
TRUNCATE TABLE silver.erp_cust_az12;

-- Load he data from bronze table to silver table

INSERT INTO silver.erp_cust_az12 (
	cid,
	bdate,
	gen
)
SELECT
	-- Remove 'NAS' prefix if present
	CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LENGTH(cid))
		ELSE cid
	END AS cid,

	-- Set future bdate to null
	CASE WHEN bdate > NOW() THEN NULL
		ELSE bdate
	END AS bdate,

	-- Normalize gender values and ahndle unkown cases
	CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
		 WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
		 ELSE 'n/a'
	END AS gen
FROM bronze.erp_cust_az12;


-----------------------------------------------------------------------------------------

-- Quality Check after inserting data into silver layer

SELECT * 
FROM silver.erp_cust_az12;

-- cid column check as it is foreign key
SELECT
	cid
FROM silver.erp_cust_az12
WHERE cid LIKE 'NAS%';

-- bdate check
SELECT
	bdate
FROM silver.erp_cust_az12
WHERE bdate > NOW();

-- gender data check
SELECT DISTINCT
	gen
FROM silver.erp_cust_az12
