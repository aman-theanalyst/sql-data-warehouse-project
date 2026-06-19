/*
======================================================================================================
Script   : silver_tables_ddl.sql
Layer    : Bronze (Raw Data Layer)
Purpose  : Create Silver layer tables for the Data Warehouse.
======================================================================================================
Description:
    - Creates the Silver layer table structures.
    - Drops and recreates existing tables to maintain schema consistency.
    - Stores cleansed, standardized, and transformed data from the Bronze layer.
    - Serves as the intermediate layer between raw ingestion and business-ready Gold models.
======================================================================================================
Source Systems:
    - CRM
    - ERP
======================================================================================================
Dependencies:
    - Database : DataWarehouse
    - Schema   : silver
    - Bronze layer tables must exist and be populated.
======================================================================================================
Execution:
    - Run after Bronze layer setup.
    - Intended for initial deployment or schema rebuilds.
======================================================================================================
Warning:
    - DROP TABLE IF EXISTS statements will permanently remove existing data.
    - Do not execute in production without appropriate backup and change control.
====================================================================================================
*/


-- Check Current Database
SELECT current_database();

-- Check if table already exists
DROP TABLE IF EXISTS silver.crm_cust_info;
	
CREATE TABLE silver.crm_cust_info (
	cst_id INTEGER,
	cst_key VARCHAR(50),
	cst_firstname VARCHAR(50),
	cst_lastname VARCHAR(50),
	cst_marital_status VARCHAR(50),
	cst_gndr VARCHAR(50),
	cst_create_date DATE,
	dwh_create_date TIMESTAMP DEFAULT NOW()
);

-- Check if table already exists
DROP TABLE IF EXISTS silver.crm_prd_info;

CREATE TABLE silver.crm_prd_info(
	prd_id INTEGER,
	cat_id VARCHAR(50),
	prd_key VARCHAR(50),
	prd_nm VARCHAR(50),
	prd_cost INTEGER,
	prd_line VARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE,
	dwh_create_date TIMESTAMP DEFAULT NOW()
);

-- Check if table already exists
DROP TABLE IF EXISTS silver.crm_sales_details;

CREATE TABLE silver.crm_sales_details(
	sls_ord_num VARCHAR(50),
	sls_prd_key VARCHAR(50),
	sls_cust_id INTEGER,
	sls_order_dt DATE,
	sls_ship_dt DATE,
	sls_due_dt DATE,
	sls_sales INTEGER,
	sls_quantity INTEGER,
	sls_price INTEGER,
	dwh_create_date TIMESTAMP DEFAULT NOW()
);

-- Check if table already exists
DROP TABLE IF EXISTS silver.erp_loc_a101;

CREATE TABLE silver.erp_loc_a101(
	cid VARCHAR(50),
	cntry VARCHAR(50),
	dwh_create_date TIMESTAMP DEFAULT NOW()
);

-- Check if table already exists
DROP TABLE IF EXISTS silver.erp_cust_az12;

CREATE TABLE silver.erp_cust_az12(
	cid VARCHAR(50),
	bdate DATE,
	gen VARCHAR(50),
	dwh_create_date TIMESTAMP DEFAULT NOW()
);

-- Check if table already exists
DROP TABLE IF EXISTS silver.erp_px_cat_g1v2;

CREATE TABLE silver.erp_px_cat_g1v2(
	id VARCHAR(50),
	cat VARCHAR(50),
	subcat VARCHAR(50),
	maintenance VARCHAR(50),
	dwh_create_date TIMESTAMP DEFAULT NOW()
);
