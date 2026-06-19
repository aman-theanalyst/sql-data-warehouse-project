-- DATA TRANSFORMATION

-- Handle inavlid cid
SELECT 
	REPLACE(cid,'-','') AS cid
FROM bronze.erp_loc_a101;

-- Data Standardization & Consistency
-- -- Normalize an handle missing or blank country codes
SELECT DISTINCT
	CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
		 WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
		 WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
		 ELSE TRIM(cntry)
	END AS cntry
FROM bronze.erp_loc_a101;