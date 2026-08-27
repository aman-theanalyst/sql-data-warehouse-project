-- Remove Data
TRUNCATE TABLE silver.erp_loc_a101;

-- Load cleaned data into silver layer table from bronze layer

INSERT INTO silver.erp_loc_a101 (
	cid,
	cntry
)
SELECT 
	-- Handled invalid cid
	REPLACE(cid,'-','') AS cid,
	-- Normalize an handle missing or blank country codes
	CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
		 WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
		 WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
		 ELSE TRIM(cntry)
	END AS cntry
FROM bronze.erp_loc_a101;


---------------------------------------------------------------------------------------

-- Quality check after Loading

SELECT *
FROM silver.erp_loc_a101

-- Cntry data check
SELECT DISTINCT
	cntry
FROM silver.erp_loc_a101
ORDER BY cntry;