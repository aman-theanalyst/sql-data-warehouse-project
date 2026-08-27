-- CREATING VIEW dim_products

-- Joining the tables of Customer object
-- Giving friendly names but following naming priciples
-- Sorting the columns into logical group to improve readability

DROP VIEW IF EXISTS gold.dim_products;

CREATE VIEW gold.dim_products AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt	AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
-- FILTER : Select only current information and leave historical data
WHERE prd_end_dt IS NULL


'''
Surrogate Key (SK) is an artificially generated unique identifier assigned to each record in a dimension table. 
It has no business meaning and is usually an auto-increment integer or sequence.

Surrogate keys help create a unique and stable identifier for the integrated data.
'''

-------------------------------------------------------------------------------
-- The table formed after joining 2 tables
-- 								- silver.crm_prd_info
-- 								- silver.erp_px_cat_g1v2
-- is a Dimension Table bcz it contain descriptive data about product.
-------------------------------------------------------------------------------

-- Quality Check

SELECT *
FROM gold.dim_products

