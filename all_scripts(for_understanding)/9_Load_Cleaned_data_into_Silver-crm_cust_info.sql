-- Remove data
TRUNCATE TABLE silver.crm_cust_info;

-- Loading the cleaned data from bronze layer to silver[crm_cust_info]
INSERT INTO silver.crm_cust_info (
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date
)

SELECT 
cst_id,
cst_key,
INITCAP(TRIM(cst_firstname)) AS cst_firstname,
INITCAP(TRIM(cst_lastname)) AS cst_lastname,
-- normalize marital status to readable format
CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
	 WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'	
	 ELSE 'n/a'
END AS cst_marital_status,
-- normalize gender values to readable format
CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	 WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'	
	 ELSE 'n/a'
END AS cst_gndr,
cst_create_date
FROM (
SELECT
*,
ROW_NUMBER() OVER (
			PARTITION BY cst_id 
			ORDER BY cst_create_date DESC
) AS flag_last
FROM bronze.crm_cust_info
WHERE cst_id IS NOT NULL
)t 
WHERE flag_last = 1


-------------------------------------------------------------------------------

-- Checking the uploaded data [Quality check after loading]

SELECT
*
FROM silver.crm_cust_info


-- Checking Primary Key

SELECT
cst_id,
COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*)>1 OR cst_id IS NULL;

-- Check for extra spaces

SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

SELECT cst_marital_status
FROM silver.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status);

SELECT cst_gndr
FROM silver.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);


-- Check for data standardization & Consistency

SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;

SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;