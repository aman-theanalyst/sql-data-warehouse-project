-- Remove data from table
TRUNCATE TABLE silver.erp_px_cat_g1v2;

-- Loadd cleaned data ffrom bronze layer to silver layer table

INSERT INTO silver.erp_px_cat_g1v2 (
	id,
	cat,
	subcat,
	maintenance
)

SELECT
	id,
	cat,
	subcat,
	maintenance
FROM bronze.erp_px_cat_g1v2;


------------------------------------------------------------------------------

-- Data Quailty check after loading data into silver layer

SELECT *
FROM silver.erp_px_cat_g1v2;

-- Checking columns
SELECT *
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) or subcat != TRIM(subcat) 
	  OR maintenance != TRIM(maintenance)








