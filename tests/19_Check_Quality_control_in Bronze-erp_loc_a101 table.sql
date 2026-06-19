
SELECT *
FROM bronze.erp_loc_a101

-- Quality Check

-- Checking for invalid cid
SELECT 
	cid
FROM bronze.erp_loc_a101
WHERE cid IN (
				SELECT cst_key 
				FROM silver.crm_cust_info
				);

-- >> ther is a - minus sign which make both connecting key different

--- Checking cntry coumn
SELECT DISTINCT
	cntry
FROM bronze.erp_loc_a101
ORDER BY cntry;
