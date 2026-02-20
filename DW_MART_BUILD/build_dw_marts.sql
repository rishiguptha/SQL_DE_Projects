-- duckdb data/dw_marts.duckdb -c ".read build_dw_marts.sql"

-- Step 1: DW - Create start schema tables
.read 01_create_tables_dw.sql

-- Step 2: Load Data from CSV and Insert data into fact and dimensions tables
.read 02_load_schema_dw.sql

-- STEP 3: Creating Flat Table Mart
.read 03_create_flat_mart.sql

-- STEP 4: Creating Skills Mart
.read 04_create_skills_mart.sql

-- step 5: Creating Priority roles Mart
.read 05_create_priority_mart.sql

--STEP 6 : Update PRiority roles Mart
.read 06_update_priority_mart.sql