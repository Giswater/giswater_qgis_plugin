/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check table temp_demand
SELECT has_table('temp_demand'::name, 'Table temp_demand should exist');

-- Check columns
SELECT columns_are(
    'temp_demand',
    ARRAY[
        'id', 'feature_id', 'demand', 'pattern_id', 'demand_type', 'dscenario_id', 'source'
    ],
    'Table temp_demand should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('temp_demand', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('temp_demand', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('temp_demand', 'feature_id', 'character varying(16)', 'Column feature_id should be character varying(16)');
SELECT col_type_is('temp_demand', 'demand', 'numeric(12,6)', 'Column demand should be numeric(12,6)');
SELECT col_type_is('temp_demand', 'pattern_id', 'character varying(16)', 'Column pattern_id should be character varying(16)');
SELECT col_type_is('temp_demand', 'demand_type', 'character varying(18)', 'Column demand_type should be character varying(18)');
SELECT col_type_is('temp_demand', 'dscenario_id', 'integer', 'Column dscenario_id should be integer');
SELECT col_type_is('temp_demand', 'source', 'text', 'Column source should be text');

-- Check default values
SELECT col_has_default('temp_demand', 'id', 'Column id should have a default value');

-- Check constraints
SELECT col_not_null('temp_demand', 'feature_id', 'Column feature_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK; 