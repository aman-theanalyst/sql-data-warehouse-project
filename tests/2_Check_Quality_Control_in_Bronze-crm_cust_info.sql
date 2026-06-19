-- We will clean data from bronze layer and insert it into silver layer

SELECT 
*
FROM bronze.crm_cust_info;

-- QUALITY CHECK

-- 1. Check for Nulls or Duplicate in Primary Key
SELECT
cst_id,
COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*)>1 OR cst_id IS NULL;


-- 2. Check for unwanted spaces in String datatype

SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

SELECT cst_marital_status
FROM bronze.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status);

SELECT cst_gndr
FROM bronze.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);


-- Check for data standardization & Consistency

SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info;

SELECT DISTINCT cst_marital_status
FROM bronze.crm_cust_info;

'''
Here we see, 
	- There are null and duplicate value in primary key.
	- There is unwanted space in string column - first and last name
	- There is no unwanted space in gender & marital_status,
	But has 3 category which include null and abbrevaitions.
'''
