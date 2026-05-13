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
SELECT has_table('element_add'::name, 'Table element_add should exist');

-- Check columns
SELECT columns_are(
    'element_add',
    ARRAY[
        'element_id', 'result_id', 'flow_max', 'flow_min', 'flow_avg', 'vel_max',
        'vel_min', 'vel_avg', 'tot_headloss_max', 'tot_headloss_min', 'mincut_connecs', 'mincut_hydrometers',
        'mincut_length', 'mincut_watervol', 'mincut_criticality', 'hydraulic_criticality', 'pipe_capacity', 'mincut_impact_topo',
        'mincut_impact_hydro'
    ],
    'Table element_add should have the correct columns'
);

-- Check column types
SELECT col_type_is('element_add', 'element_id', 'int4', 'Column element_id should be int4');
SELECT col_type_is('element_add', 'result_id', 'text', 'Column result_id should be text');
SELECT col_type_is('element_add', 'flow_max', 'numeric(12,2)', 'Column flow_max should be numeric(12,2)');
SELECT col_type_is('element_add', 'flow_min', 'numeric(12,2)', 'Column flow_min should be numeric(12,2)');
SELECT col_type_is('element_add', 'flow_avg', 'numeric(12,2)', 'Column flow_avg should be numeric(12,2)');
SELECT col_type_is('element_add', 'vel_max', 'numeric(12,2)', 'Column vel_max should be numeric(12,2)');
SELECT col_type_is('element_add', 'vel_min', 'numeric(12,2)', 'Column vel_min should be numeric(12,2)');
SELECT col_type_is('element_add', 'vel_avg', 'numeric(12,2)', 'Column vel_avg should be numeric(12,2)');
SELECT col_type_is('element_add', 'tot_headloss_max', 'numeric(12,2)', 'Column tot_headloss_max should be numeric(12,2)');
SELECT col_type_is('element_add', 'tot_headloss_min', 'numeric(12,2)', 'Column tot_headloss_min should be numeric(12,2)');
SELECT col_type_is('element_add', 'mincut_connecs', 'int4', 'Column mincut_connecs should be int4');
SELECT col_type_is('element_add', 'mincut_hydrometers', 'int4', 'Column mincut_hydrometers should be int4');
SELECT col_type_is('element_add', 'mincut_length', 'numeric(12,3)', 'Column mincut_length should be numeric(12,3)');
SELECT col_type_is('element_add', 'mincut_watervol', 'numeric(12,3)', 'Column mincut_watervol should be numeric(12,3)');
SELECT col_type_is('element_add', 'mincut_criticality', 'numeric(12,3)', 'Column mincut_criticality should be numeric(12,3)');
SELECT col_type_is('element_add', 'hydraulic_criticality', 'numeric(12,3)', 'Column hydraulic_criticality should be numeric(12,3)');
SELECT col_type_is('element_add', 'pipe_capacity', 'float8', 'Column pipe_capacity should be float8');
SELECT col_type_is('element_add', 'mincut_impact_topo', 'json', 'Column mincut_impact_topo should be json');
SELECT col_type_is('element_add', 'mincut_impact_hydro', 'json', 'Column mincut_impact_hydro should be json');

-- Check foreign keys
SELECT has_fk('element_add', 'Table element_add should have foreign keys');

SELECT fk_ok('element_add', 'element_id', 'element', 'element_id', 'FK element_id → element.element_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
