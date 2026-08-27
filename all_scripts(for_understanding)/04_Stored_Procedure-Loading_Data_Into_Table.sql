 -- Stored Procedure for to execute these repeatedly

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE
	rows_loaded INTEGER;
    start_time        TIMESTAMP;
    end_time          TIMESTAMP;
    batch_start_time  TIMESTAMP;
    batch_end_time    TIMESTAMP;
BEGIN
	batch_start_time := clock_timestamp();
	
	RAISE NOTICE '=======================================================';
	RAISE NOTICE 'Loading Bronze Layer';
	RAISE NOTICE '=======================================================';

	RAISE NOTICE '------------------------------------------------';
	RAISE NOTICE 'Loading CRM Tables';
	RAISE NOTICE '------------------------------------------------';

	-- CRM Customer Info
	start_time := clock_timestamp();
	
	RAISE NOTICE '>> Truncating Table : bronze.crm_cust_info';
	TRUNCATE TABLE bronze.crm_cust_info;

	RAISE NOTICE '>> Inserting Data Into : bronze.crm_cust_info';
	COPY bronze.crm_cust_info
	FROM 'C:\Users\DELL G15\Desktop\Projects\SQL Project 1 - sql-data-warehouse-project-end-to-end\1. Creating Data Warehouse\Datasets\source_crm\cust_info.csv'
	WITH(
		FORMAT CSV,
		DELIMITER ',',
		HEADER TRUE    -- bcz 1st row is headers
	);

	end_time := clock_timestamp();
	
	GET DIAGNOSTICS rows_loaded = ROW_COUNT;
	RAISE NOTICE 'Rows Loaded: %', rows_loaded;
	
	RAISE NOTICE '>> Load Duration: % seconds',
    	ROUND(EXTRACT(EPOCH FROM (end_time - start_time)));
    RAISE NOTICE '>> -------------';

	-- 
	start_time := clock_timestamp();
	
	RAISE NOTICE '>> Truncating Table: bronze.crm_prd_info';
	TRUNCATE TABLE bronze.crm_prd_info;

	RAISE NOTICE '>> Inserting Data Into: bronze.crm_prd_info';
	COPY bronze.crm_prd_info
	FROM 'C:\Users\DELL G15\Desktop\Projects\SQL Project 1 - sql-data-warehouse-project-end-to-end\1. Creating Data Warehouse\Datasets\source_crm\prd_info.csv'
	WITH(
		FORMAT CSV,
		DELIMITER ',',
		HEADER TRUE    -- bcz 1st row is headers
	);

	end_time := clock_timestamp();

	GET DIAGNOSTICS rows_loaded = ROW_COUNT;
	RAISE NOTICE 'Rows Loaded: %', rows_loaded;
	
	RAISE NOTICE '>> Load Duration: % seconds',
    	ROUND(EXTRACT(EPOCH FROM (end_time - start_time)));
    RAISE NOTICE '>> -------------';
	
	--
	start_time := clock_timestamp();
	
	RAISE NOTICE '>> Truncating Table: bronze.crm_sales_details';
	TRUNCATE TABLE bronze.crm_sales_details;
	
	RAISE NOTICE '>> Inserting Data Into: bronze.crm_sales_details';
	COPY bronze.crm_sales_details
	FROM 'C:\Users\DELL G15\Desktop\Projects\SQL Project 1 - sql-data-warehouse-project-end-to-end\1. Creating Data Warehouse\Datasets\source_crm\sales_details.csv'
	WITH(
		FORMAT CSV,
		DELIMITER ',',
		HEADER TRUE    -- bcz 1st row is headers
	);

	end_time := clock_timestamp();

	GET DIAGNOSTICS rows_loaded = ROW_COUNT;
	RAISE NOTICE 'Rows Loaded: %', rows_loaded;
	
	RAISE NOTICE '>> Load Duration: % seconds',
    	ROUND(EXTRACT(EPOCH FROM (end_time - start_time)));
    RAISE NOTICE '>> -------------';
	

	RAISE NOTICE '------------------------------------------------';
	RAISE NOTICE 'Loading ERP Tables';
	RAISE NOTICE '------------------------------------------------';

	--
	start_time := clock_timestamp();
	
	RAISE NOTICE '>> Truncating Table: bronze.erp_loc_a101';
	TRUNCATE TABLE bronze.erp_loc_a101;
	
	RAISE NOTICE '>> Inserting Data Into: bronze.erp_loc_a101';
	COPY bronze.erp_loc_a101
	FROM 'C:\Users\DELL G15\Desktop\Projects\SQL Project 1 - sql-data-warehouse-project-end-to-end\1. Creating Data Warehouse\Datasets\source_erp\loc_a101.csv'
	WITH(
		FORMAT CSV,
		DELIMITER ',',
		HEADER TRUE    -- bcz 1st row is headers
	);

	end_time := clock_timestamp();

	GET DIAGNOSTICS rows_loaded = ROW_COUNT;
	RAISE NOTICE 'Rows Loaded: %', rows_loaded;
	
    RAISE NOTICE '>> Load Duration: % seconds',
        ROUND(EXTRACT(EPOCH FROM (end_time - start_time)));
    RAISE NOTICE '>> -------------';

	--
	start_time := clock_timestamp();
	
	RAISE NOTICE '>> Truncating Table: bronze.erp_cust_az12';
	TRUNCATE TABLE bronze.erp_cust_az12;
	
	RAISE NOTICE '>> Inserting Data Into: bronze.erp_cust_az12';
	COPY bronze.erp_cust_az12
	FROM 'C:\Users\DELL G15\Desktop\Projects\SQL Project 1 - sql-data-warehouse-project-end-to-end\1. Creating Data Warehouse\Datasets\source_erp\cust_az12.csv'
	WITH(
		FORMAT CSV,
		DELIMITER ',',
		HEADER TRUE    -- bcz 1st row is headers
	);

	end_time := clock_timestamp();

	GET DIAGNOSTICS rows_loaded = ROW_COUNT;
	RAISE NOTICE 'Rows Loaded: %', rows_loaded;
	
    RAISE NOTICE '>> Load Duration: % seconds',
        ROUND(EXTRACT(EPOCH FROM (end_time - start_time)));
    RAISE NOTICE '>> -------------';

	--
	start_time := clock_timestamp();
	
	RAISE NOTICE '>> Truncating Table: bronze.erp_px_cat_g1v2';
	TRUNCATE TABLE bronze.erp_px_cat_g1v2;
	
	RAISE NOTICE '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
	COPY bronze.erp_px_cat_g1v2
	FROM 'C:\Users\DELL G15\Desktop\Projects\SQL Project 1 - sql-data-warehouse-project-end-to-end\1. Creating Data Warehouse\Datasets\source_erp\px_cat_g1v2.csv'
	WITH(
		FORMAT CSV,
		DELIMITER ',',
		HEADER TRUE    -- bcz 1st row is headers
	);

	end_time := clock_timestamp();

	GET DIAGNOSTICS rows_loaded = ROW_COUNT;
	RAISE NOTICE 'Rows Loaded: %', rows_loaded;
	
    RAISE NOTICE '>> Load Duration: % seconds',
        ROUND(EXTRACT(EPOCH FROM (end_time - start_time)));
    RAISE NOTICE '>> -------------';

	batch_end_time := clock_timestamp();
	 
	RAISE NOTICE '=======================================================';
    RAISE NOTICE 'Bronze Layer Loaded Successfully';
	RAISE NOTICE 'Total Load Duration: % seconds',
        ROUND(EXTRACT(EPOCH FROM (batch_end_time - batch_start_time)));
    RAISE NOTICE '=======================================================';

	EXCEPTION
		WHEN OTHERS THEN
			RAISE NOTICE '==========================================';
	        RAISE NOTICE 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
	        RAISE NOTICE 'Error Message: %', SQLERRM;
	        RAISE NOTICE 'SQLSTATE: %', SQLSTATE;
	        RAISE NOTICE '==========================================';
	
	        RAISE;
END;
$$;

-- EXECUTE 
CALL bronze.load_bronze();
