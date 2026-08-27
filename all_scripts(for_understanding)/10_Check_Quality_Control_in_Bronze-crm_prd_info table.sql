-- We will clean data from bronze layer and insert it into silver layer

SELECT 
*
FROM bronze.crm_prd_info;

-- QUALITY CHECK

-- 1. Check for Nulls or Duplicate in Primary Key
SELECT
prd_id,
COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*)>1 OR prd_id IS NULL;


-- Check spaces

SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check Null and -ve number

SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data Standardization and Consistency

SELECT DISTINCT prd_line
FROM bronze.crm_prd_info

-- Check for invalid Date order

SELECT *
FROM bronze.crm_prd_info
WHERE prd_start_dt > prd_end_dt

'''
Based on analyzing data after quering --
Solution :
			1. Switch start date with end date (not recommended as there is date overlapping)
			2. Derive all end_date from satrt date for inconsistent data 
			   [End_date = Start date of Next Record - 1]
'''




