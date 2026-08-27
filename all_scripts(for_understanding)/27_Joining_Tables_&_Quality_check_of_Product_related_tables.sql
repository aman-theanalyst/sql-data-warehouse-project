SELECT *
FROM silver.crm_prd_info pn;

-- Joining Tables of Product object

SELECT 
	pn.prd_id,
	pn.cat_id,
	pn.prd_key,
	pn.prd_nm,
	pn.prd_cost,
	pn.prd_line,
	pn.prd_start_dt,
	pc.cat,
	pc.subcat,
	pc.maintenance
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
-- FILTER : Select only current information and leave historical data
WHERE prd_end_dt IS NULL


------------------------------------------------------------------------------

-- Quality Check after Join

SELECT
	prd_key,
	COUNT(*)
FROM (
		SELECT 
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			pc.cat,
			pc.subcat,
			pc.maintenance
		FROM silver.crm_prd_info pn
		LEFT JOIN silver.erp_px_cat_g1v2 pc
		ON pn.cat_id = pc.id
		-- FILTER : Select only current information and leave historical data
		WHERE prd_end_dt IS NULL
)t
GROUP BY prd_key
HAVING COUNT(*)>1

-- >> No duplicate 

-------------------------------------------------------------------------------

-- >> No two columns for integration after join..










