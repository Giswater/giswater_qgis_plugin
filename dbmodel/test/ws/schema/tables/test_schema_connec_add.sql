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

-- Check table connec_add
SELECT has_table('connec_add'::name, 'Table connec_add should exist');

-- Check columns
SELECT columns_are(
    'connec_add',
    ARRAY[
        'connec_id', 'demand_base', 'demand_max', 'demand_min', 'demand_avg', 'press_max', 'press_min', 'press_avg',
        'quality_max', 'quality_min', 'quality_avg', 'flow_max', 'flow_min', 'flow_avg', 'vel_max', 'vel_min', 'vel_avg',
        'result_id'
    ],
    'Table connec_add should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('connec_add', ARRAY['connec_id'], 'Column connec_id should be primary key');

-- Check column types
SELECT col_type_is('connec_add', 'connec_id', 'varchar(16)', 'Column connec_id should be varchar(16)');
SELECT col_type_is('connec_add', 'demand_base', 'numeric(12,2)', 'Column demand_base should be numeric(12,2)');
SELECT col_type_is('connec_add', 'demand_max', 'numeric(12,2)', 'Column demand_max should be numeric(12,2)');
SELECT col_type_is('connec_add', 'demand_min', 'numeric(12,2)', 'Column demand_min should be numeric(12,2)');
SELECT col_type_is('connec_add', 'demand_avg', 'numeric(12,2)', 'Column demand_avg should be numeric(12,2)');
SELECT col_type_is('connec_add', 'press_max', 'numeric(12,2)', 'Column press_max should be numeric(12,2)');
SELECT col_type_is('connec_add', 'press_min', 'numeric(12,2)', 'Column press_min should be numeric(12,2)');
SELECT col_type_is('connec_add', 'press_avg', 'numeric(12,2)', 'Column press_avg should be numeric(12,2)');
SELECT col_type_is('connec_add', 'quality_max', 'numeric(12,4)', 'Column quality_max should be numeric(12,4)');
SELECT col_type_is('connec_add', 'quality_min', 'numeric(12,4)', 'Column quality_min should be numeric(12,4)');
SELECT col_type_is('connec_add', 'quality_avg', 'numeric(12,4)', 'Column quality_avg should be numeric(12,4)');
SELECT col_type_is('connec_add', 'flow_max', 'numeric(12,2)', 'Column flow_max should be numeric(12,2)');
SELECT col_type_is('connec_add', 'flow_min', 'numeric(12,2)', 'Column flow_min should be numeric(12,2)');
SELECT col_type_is('connec_add', 'flow_avg', 'numeric(12,2)', 'Column flow_avg should be numeric(12,2)');
SELECT col_type_is('connec_add', 'vel_max', 'numeric(12,2)', 'Column vel_max should be numeric(12,2)');
SELECT col_type_is('connec_add', 'vel_min', 'numeric(12,2)', 'Column vel_min should be numeric(12,2)');
SELECT col_type_is('connec_add', 'vel_avg', 'numeric(12,2)', 'Column vel_avg should be numeric(12,2)');
SELECT col_type_is('connec_add', 'result_id', 'text', 'Column result_id should be text');

-- Check foreign keys
SELECT hasnt_fk('connec_add', 'Table connec_add should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('connec_add', 'connec_id', 'Column connec_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
