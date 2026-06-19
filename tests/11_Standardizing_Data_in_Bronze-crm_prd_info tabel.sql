-- DATA TRANSFORMATION AND STANDARDIZATION

-- 1. There is no dupicacy and Null values in primary key

-- 2. Column Seperation to form diffrent columns
SELECT
	prd_key,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
	SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key
FROM bronze.crm_prd_info

-- 3. No spaces in prd_nm

-- 4. Removing Null from prd_cost 
SELECT
	COALESCE(Prd_cost,0) AS prd_cost
FROM bronze.crm_prd_info

-- 5. Normalizing prd_line to readable format
SELECT
	prd_key,
	CASE UPPER(TRIM(prd_line))
		 WHEN 'M' THEN 'Mountain'
		 WHEN 'R' THEN 'Road'
		 WHEN 'S' THEN 'Other Sales'
		 WHEN 'T' THEN 'Touring'
		 ELSE 'n/a'
	END AS prd_line
FROM bronze.crm_prd_info

-- 6. Invalid Date order solving

-- Checking for 2 product key for reference

SELECT
	prd_id,
	prd_key,
	prd_nm,
	CAST(prd_start_dt AS DATE) AS prd_start_dt,
	CAST(LEAD(prd_start_dt) OVER (
			PARTITION BY prd_key 
			ORDER BY prd_start_dt
	) - INTERVAL '1 day' AS DATE) AS prd_end_dt
FROM bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R', 'AC-HE-HL-U509')