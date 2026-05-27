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
SELECT has_table('ext_scada_x_data'::name, 'Table ext_scada_x_data should exist');

-- Check columns
SELECT columns_are(
    'ext_scada_x_data',
    ARRAY[
        'scada_id', 'node_id', 'value_date', 'value', 'value_status', 'annotation'
    ],
    'Table ext_scada_x_data should have the correct columns'
);

-- Check column types
SELECT col_type_is('ext_scada_x_data', 'scada_id', 'text', 'Column scada_id should be text');
SELECT col_type_is('ext_scada_x_data', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('ext_scada_x_data', 'value_date', 'date', 'Column value_date should be date');
SELECT col_type_is('ext_scada_x_data', 'value', 'float8', 'Column value should be float8');
SELECT col_type_is('ext_scada_x_data', 'value_status', 'int4', 'Column value_status should be int4');
SELECT col_type_is('ext_scada_x_data', 'annotation', 'text', 'Column annotation should be text');

-- Check foreign keys
SELECT has_fk('ext_scada_x_data', 'Table ext_scada_x_data should have foreign keys');

SELECT fk_ok('ext_scada_x_data', 'node_id', 'node', 'node_id', 'FK node_id → node.node_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
