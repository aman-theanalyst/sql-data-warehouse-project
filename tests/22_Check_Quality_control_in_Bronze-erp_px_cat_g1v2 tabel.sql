
-- Quality Check

SELECT *
FROM bronze.erp_px_cat_g1v2

-- Check for invalid id

SELECT id
FROM bronze.erp_px_cat_g1v2
WHERE id NOT IN (SELECT cat_id FROM silver.crm_prd_info)

-- Check for unwanted sapces in cat and subcat column
SELECT *
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat);


SELECT *
FROM bronze.erp_px_cat_g1v2
WHERE subcat != TRIM(subcat);

-- Check maintenance category and unwanted space

SELECT DISTINCT
	maintenance
FROM bronze.erp_px_cat_g1v2;

SELECT
	maintenance
FROM bronze.erp_px_cat_g1v2
WHERE maintenance != TRIM(maintenance);

-- >> This table has very good data quality..