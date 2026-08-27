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
