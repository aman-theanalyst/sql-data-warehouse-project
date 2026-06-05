/*
=====================================================================================
Create Database and Schemas
=====================================================================================
Script Purpose:
  This Script creates a new database named 'DataWarehouse' after checking if it already exists.
  If the dataabse exists, it is dropped and recreated. 
  Additionally, the script sets up three schemas within the database: 'bronze', 'silver', 'gold'.

WARNINGS:
  Don't Run the entire script together, it will drop the entire 'DataWarehouse' database if it exists.
  All data will be permanantly deleted. Proceed with caution.

Note: In PostgreSQL, CREATE DATABASE does not automatically switch your connection to the new database.

*/


-- Verify Conncetion & Check Current Database
SELECT current_database();

-- Create 'DataWarehouse' Database
DROP DATABASE IF EXISTS datawarehouse; 
CREATE DATABASE datawarehouse;

-- Connect to 'DataWarehouse' Database and open the Query tool

-- Verifying the connection
SELECT current_database();

-- Create Medallion Schemas
CREATE SCHEMA IF NOT EXISTS bronze; 
CREATE SCHEMA IF NOT EXISTS silver; 
CREATE SCHEMA IF NOT EXISTS gold;

-- Verify Schema Creation
SELECT schema_name 
FROM information_schema.schemata 
WHERE schema_name IN ('bronze', 'silver', 'gold');

