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

-- Check table node_addve_link
SELECT has_table('node_add'::name, 'Table node_add should exist');

-- Check columns
SELECT columns_are(
    'node_add',
    ARRAY[
        'node_id', 'demand_max', 'demand_min', 'demand_avg', 'press_max', 'press_min', 'press_avg',
        'head_max', 'head_min', 'head_avg', 'quality_max', 'quality_min', 'quality_avg', 'result_id',
        'flow_max', 'flow_min', 'flow_avg', 'vel_max', 'vel_min', 'vel_avg'
    ],
    'Table node_add should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('node_add', ARRAY['node_id'], 'Column node_id should be primary key');

-- Check column types
SELECT col_type_is('node_add', 'node_id', 'integer', 'Column node_id should be integer');
SELECT col_type_is('node_add', 'demand_max', 'numeric(12,2)', 'Column demand_max should be numeric(12,2)');
SELECT col_type_is('node_add', 'demand_min', 'numeric(12,2)', 'Column demand_min should be numeric(12,2)');
SELECT col_type_is('node_add', 'demand_avg', 'numeric(12,2)', 'Column demand_avg should be numeric(12,2)');
SELECT col_type_is('node_add', 'press_max', 'numeric(12,2)', 'Column press_max should be numeric(12,2)');
SELECT col_type_is('node_add', 'press_min', 'numeric(12,2)', 'Column press_min should be numeric(12,2)');
SELECT col_type_is('node_add', 'press_avg', 'numeric(12,2)', 'Column press_avg should be numeric(12,2)');
SELECT col_type_is('node_add', 'head_max', 'numeric(12,2)', 'Column head_max should be numeric(12,2)');
SELECT col_type_is('node_add', 'head_min', 'numeric(12,2)', 'Column head_min should be numeric(12,2)');
SELECT col_type_is('node_add', 'head_avg', 'numeric(12,2)', 'Column head_avg should be numeric(12,2)');
SELECT col_type_is('node_add', 'quality_max', 'numeric(12,2)', 'Column quality_max should be numeric(12,2)');
SELECT col_type_is('node_add', 'quality_min', 'numeric(12,2)', 'Column quality_min should be numeric(12,2)');
SELECT col_type_is('node_add', 'quality_avg', 'numeric(12,2)', 'Column quality_avg should be numeric(12,2)');
SELECT col_type_is('node_add', 'result_id', 'text', 'Column result_id should be text');
SELECT col_type_is('node_add', 'flow_max', 'numeric(12,2)', 'Column flow_max should be numeric(12,2)');
SELECT col_type_is('node_add', 'flow_min', 'numeric(12,2)', 'Column flow_min should be numeric(12,2)');
SELECT col_type_is('node_add', 'flow_avg', 'numeric(12,2)', 'Column flow_avg should be numeric(12,2)');
SELECT col_type_is('node_add', 'vel_max', 'numeric(12,2)', 'Column vel_max should be numeric(12,2)');
SELECT col_type_is('node_add', 'vel_min', 'numeric(12,2)', 'Column vel_min should be numeric(12,2)');
SELECT col_type_is('node_add', 'vel_avg', 'numeric(12,2)', 'Column vel_avg should be numeric(12,2)');

-- Check constraints
SELECT col_not_null('node_add', 'node_id', 'Column node_id should be NOT NULL');

-- Check foreign keys
SELECT has_fk('node_add', 'Table node_add should have foreign keys');
SELECT fk_ok('node_add', 'node_id', 'node', 'node_id', 'FK node_id should reference node.node_id');

SELECT * FROM finish();

ROLLBACK;