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
SELECT has_table('temp_demand'::name, 'Table temp_demand should exist');

-- Check columns
SELECT columns_are(
    'temp_demand',
    ARRAY[
        'id', 'feature_id', 'demand', 'pattern_id', 'demand_type', 'dscenario_id',
        'source'
    ],
    'Table temp_demand should have the correct columns'
);

-- Check column types
SELECT col_type_is('temp_demand', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('temp_demand', 'feature_id', 'text', 'Column feature_id should be text');
SELECT col_type_is('temp_demand', 'demand', 'numeric(12,6)', 'Column demand should be numeric(12,6)');
SELECT col_type_is('temp_demand', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('temp_demand', 'demand_type', 'varchar(18)', 'Column demand_type should be varchar(18)');
SELECT col_type_is('temp_demand', 'dscenario_id', 'int4', 'Column dscenario_id should be int4');
SELECT col_type_is('temp_demand', 'source', 'text', 'Column source should be text');

-- Finish
SELECT * FROM finish();

ROLLBACK;
