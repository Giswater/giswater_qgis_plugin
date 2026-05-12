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

-- Check table rtc_hydrometer_x_node
SELECT has_table('rtc_hydrometer_x_node'::name, 'Table rtc_hydrometer_x_node should exist');

-- Check columns
SELECT columns_are(
    'rtc_hydrometer_x_node',
    ARRAY[
        'hydrometer_id', 'node_id'
    ],
    'Table rtc_hydrometer_x_node should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('rtc_hydrometer_x_node', ARRAY['hydrometer_id'], 'Column hydrometer_id should be primary key');

-- Check column types
SELECT col_type_is('rtc_hydrometer_x_node', 'hydrometer_id', 'integer', 'Column hydrometer_id should be integer');
SELECT col_type_is('rtc_hydrometer_x_node', 'node_id', 'integer', 'Column node_id should be integer');

-- Check constraints
SELECT col_not_null('rtc_hydrometer_x_node', 'hydrometer_id', 'Column hydrometer_id should be NOT NULL');
SELECT col_not_null('rtc_hydrometer_x_node', 'node_id', 'Column node_id should be NOT NULL');

-- Check foreign keys
SELECT has_fk('rtc_hydrometer_x_node', 'Table rtc_hydrometer_x_node should have foreign keys');
SELECT fk_ok('rtc_hydrometer_x_node', 'hydrometer_id', 'ext_rtc_hydrometer', 'hydrometer_id', 'FK hydrometer_id should reference ext_rtc_hydrometer.hydrometer_id');
SELECT fk_ok('rtc_hydrometer_x_node', 'node_id', 'node', 'node_id', 'FK node_id should reference node.node_id');

-- Check indexes
SELECT has_index('rtc_hydrometer_x_node', 'rtc_hydrometer_x_node_index_node_id', 'Index rtc_hydrometer_x_node_index_node_id should exist');

SELECT * FROM finish();

ROLLBACK;