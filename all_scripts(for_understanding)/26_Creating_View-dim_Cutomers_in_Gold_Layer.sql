-- CREATING VIEW dim_customers

-- Joining the tables of Customer object
-- Giving friendly names but following naming priciples
-- Sorting the columns into logical group to improve readability

DROP VIEW  IF EXISTS gold.dim_customers;

CREATE VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER( ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.cntry AS country,
	ci.cst_marital_status AS marital_status,
	-- crm is the master source for customer data
	CASE 
		WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		ELSE COALESCE(ca.gen, 'n/a')
	END AS gender,
	ca.bdate AS birth_date,
	ci.cst_create_date AS create_date	
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid;

'''
Surrogate Key (SK) is an artificially generated unique identifier assigned to each record in a dimension table. 
It has no business meaning and is usually an auto-increment integer or sequence.

Surrogate keys help create a unique and stable identifier for the integrated data.
'''
-------------------------------------------------------------------------------
-- The table formed after joining  3 tables
-- 								- silver.crm_cust_info
-- 								- silver.erp_cust_az12
-- 								- silver.erp_loc_a101
-- is a Dimension Table bcz it contain descriptive data about customer.

----------------------------------------------------------------------------
-- Data Quality Check + Surrogate key check

SELECT *
FROM gold.dim_customers
-----------------------------------------------------------------------------
-- Check gender data consistency

SELECT DISTINCT
	gender
FROM gold.dim_customers
