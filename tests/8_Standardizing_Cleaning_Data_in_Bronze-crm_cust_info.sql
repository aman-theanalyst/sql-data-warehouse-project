-- Checking for particular duplicate primary key for analysis
SELECT 
*
FROM bronze.crm_cust_info
WHERE cst_id = 29466;

-- Ranking the duplicate data 
SELECT
*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
FROM bronze.crm_cust_info

-- Data that we dont need based on primary key duplicacy or null values
SELECT 
*
FROM (
SELECT
*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
FROM bronze.crm_cust_info
)t 
WHERE flag_last != 1

-- This code ensures the primary key is unique and not null
SELECT 
*
FROM (
SELECT
*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
FROM bronze.crm_cust_info
)t 
WHERE flag_last = 1


------------------------------------------------------------------------------------------------------------------------
-- Data Standardization and cleaning

SELECT 
cst_id,
cst_key,
INITCAP(TRIM(cst_firstname)) AS cst_firstname,
INITCAP(TRIM(cst_lastname)) AS cst_lastname,
CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
	 WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'	
	 ELSE 'n/a'
END cst_marital_status,
CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	 WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'	
	 ELSE 'n/a'
END cst_gndr,
cst_create_date
FROM (
SELECT
*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
FROM bronze.crm_cust_info
)t 
WHERE flag_last = 1


