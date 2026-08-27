-- Remove data
TRUNCATE TABLE silver.crm_prd_info;

-- Insert data into silver layer - crm_prd_info table
INSERT INTO silver.crm_prd_info (
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)


SELECT
	prd_id,
	-- Extract Category Id
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
	-- Extract Product Key
	SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
	prd_nm,
	-- Handling missing info
	COALESCE(Prd_cost,0) AS prd_cost,
	-- Map product line codes to descriptive values
	CASE UPPER(TRIM(prd_line))
		 WHEN 'M' THEN 'Mountain'
		 WHEN 'R' THEN 'Road'
		 WHEN 'S' THEN 'Other Sales'
		 WHEN 'T' THEN 'Touring'
		 ELSE 'n/a'
	END AS prd_line,
	CAST(prd_start_dt AS DATE) AS prd_start_dt,
	-- Calculate end date as one day before next start date
	CAST(LEAD(prd_start_dt) OVER (
			PARTITION BY prd_key 
			ORDER BY prd_start_dt
	) - INTERVAL '1 day' AS DATE) AS prd_end_dt
FROM bronze.crm_prd_info;

---------------------------------------------------------------------------------------------

-- Checking the uploaded data [Quality check after loading]

SELECT
*
FROM silver.crm_prd_info


-- Checking Primary Key

SELECT
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*)>1 OR prd_id IS NULL;

-- Check spaces

SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check Null and -ve number

SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data Standardization and Consistency

SELECT DISTINCT prd_line
FROM silver.crm_prd_info

-- Check for invalid Date order

SELECT *
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt