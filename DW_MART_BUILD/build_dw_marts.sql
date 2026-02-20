-- duckdb data/dw_marts.duckdb -c ".read build_dw_marts.sql"

-- Step 1: DW - Create start schema tables
.read 01_create_tables_dw.sql

-- Step 2: Load Data from CSV and Insert data into fact and dimensions tables
.read 02_load_schema_dw.sql