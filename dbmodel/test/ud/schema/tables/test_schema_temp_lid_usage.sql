/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check table
SELECT has_table('temp_lid_usage'::name, 'Table temp_lid_usage should exist');

-- Check columns
SELECT columns_are(
    'temp_lid_usage',
    ARRAY[
        'subc_id', 'lidco_id', 'numelem', 'area', 'width', 'initsat',
        'fromimp', 'toperv', 'rptfile'
    ],
    'Table temp_lid_usage should have the correct columns'
);

-- Check column types
SELECT col_type_is('temp_lid_usage', 'subc_id', 'varchar(16)', 'Column subc_id should be varchar(16)');
SELECT col_type_is('temp_lid_usage', 'lidco_id', 'varchar(16)', 'Column lidco_id should be varchar(16)');
SELECT col_type_is('temp_lid_usage', 'numelem', 'int2', 'Column numelem should be int2');
SELECT col_type_is('temp_lid_usage', 'area', 'numeric(16,6)', 'Column area should be numeric(16,6)');
SELECT col_type_is('temp_lid_usage', 'width', 'numeric(12,4)', 'Column width should be numeric(12,4)');
SELECT col_type_is('temp_lid_usage', 'initsat', 'numeric(12,4)', 'Column initsat should be numeric(12,4)');
SELECT col_type_is('temp_lid_usage', 'fromimp', 'numeric(12,4)', 'Column fromimp should be numeric(12,4)');
SELECT col_type_is('temp_lid_usage', 'toperv', 'int2', 'Column toperv should be int2');
SELECT col_type_is('temp_lid_usage', 'rptfile', 'varchar(10)', 'Column rptfile should be varchar(10)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
