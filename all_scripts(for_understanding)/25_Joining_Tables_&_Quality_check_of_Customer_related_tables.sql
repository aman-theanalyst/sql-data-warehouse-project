SELECT * 
FROM silver.crm_cust_info;

-- Joining Tables of Customer Object

SELECT 
	ci.cst_id,
	ci.cst_key,
	ci.cst_firstname,
	ci.cst_lastname,
	ci.cst_marital_status,
	ci.cst_gndr,
	ci.cst_create_date,
	ca.bdate,
	ca.gen,
	la.cntry
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid;

----------------------------------------------------------------------------
-- QUALITY CHECK AFTER JOIN

-- Checking for Duplicates
SELECT
	cst_id,
	COUNT(*)
FROM (
		SELECT 
			ci.cst_id,
			ci.cst_key,
			ci.cst_firstname,
			ci.cst_lastname,
			ci.cst_marital_status,
			ci.cst_gndr,
			ci.cst_create_date,
			ca.bdate,
			ca.gen,
			la.cntry
		FROM silver.crm_cust_info ci
		LEFT JOIN silver.erp_cust_az12 ca
		ON ci.cst_key = ca.cid
		LEFT JOIN silver.erp_loc_a101 la
		ON ci.cst_key = la.cid
)t
GROUP BY cst_id
HAVING COUNT(*) > 1;

-- >>> No Duplicate found after joining Customer tables.

---------------------------------------------------------------------------

-- Two gender column after join : checking for data consistency
SELECT 
	ci.cst_gndr,
	ca.gen
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid
ORDER BY 1,2

-- Solving gender columns Data problem by Integrating both column into one.
SELECT 
	ci.cst_gndr,
	ca.gen,
	CASE 
		WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		ELSE COALESCE(ca.gen, 'n/a')
	END AS new_gender
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid
ORDER BY 1,2



