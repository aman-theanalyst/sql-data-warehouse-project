/*
======================================================================================================
Script Name   : bronze_tables_ddl.sql
Layer         : Bronze (Raw Data Layer)
Purpose       : Create all Bronze layer tables required for raw data ingestion.
======================================================================================================
Description   :
    - Creates the table structures for the Bronze layer of the Data Warehouse.
    - Drops and recreates existing Bronze tables to ensure schema consistency.
    - Stores raw data ingested directly from source systems without applying
      any business transformations or cleansing rules.
======================================================================================================
Execution Notes:
    - Execute this script during the initial database setup or when rebuilding
      the Bronze layer schema.
    - Existing Bronze tables and their data will be permanently removed.
    - Ensure the 'bronze' schema exists before executing this script.
======================================================================================================
Data Sources  :
    - CRM System
    - ERP System
======================================================================================================
Dependencies  :
    - Database: DataWarehouse
    - Schema   : bronze
======================================================================================================
Warning       :
    This script performs destructive operations (DROP TABLE IF EXISTS).
    Execute with caution in production environments.
======================================================================================================
*/


-- Check Current Database
SELECT current_database();

-- Check if table already exists
DROP TABLE IF EXISTS bronze.crm_cust_info;
	
CREATE TABLE bronze.crm_cust_info (
	cst_id INTEGER,
	cst_key VARCHAR(50),
	cst_firstname VARCHAR(50),
	cst_lastname VARCHAR(50),
	cst_material_status VARCHAR(50),
	cst_gndr VARCHAR(50),
	cst_create_date DATE
);

-- Check if table already exists
DROP TABLE IF EXISTS bronze.crm_prd_info;

CREATE TABLE bronze.crm_prd_info(
	prd_id INTEGER,
	prd_key VARCHAR(50),
	prd_nm VARCHAR(50),
	prd_cost INTEGER,
	prd_line VARCHAR(50),
	prd_start_dt TIMESTAMP,
	prd_end_dt TIMESTAMP
);

-- Check if table already exists
DROP TABLE IF EXISTS bronze.crm_sales_details;

CREATE TABLE bronze.crm_sales_details(
	sls_ord_num VARCHAR(50),
	sls_prd_key VARCHAR(50),
	sls_cust_id INTEGER,
	sls_order_dt INTEGER,
	sls_ship_dt INTEGER,
	sls_due_dt INTEGER,
	sls_sales INTEGER,
	sls_quantity INTEGER,
	sls_price INTEGER
);

-- Check if table already exists
DROP TABLE IF EXISTS bronze.erp_loc_a101;

CREATE TABLE bronze.erp_loc_a101(
	cid VARCHAR(50),
	cntry VARCHAR(50)
);

-- Check if table already exists
DROP TABLE IF EXISTS bronze.erp_cust_az12;

CREATE TABLE bronze.erp_cust_az12(
	cid VARCHAR(50),
	bdate DATE,
	gen VARCHAR(50)
);

-- Check if table already exists
DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;

CREATE TABLE bronze.erp_px_cat_g1v2(
	id VARCHAR(50),
	cat VARCHAR(50),
	subcat VARCHAR(50),
	maintenance VARCHAR(50)
);
