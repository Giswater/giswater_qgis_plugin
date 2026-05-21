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

-- Check view v_ui_arc_x_relations
SELECT has_view('v_ui_arc_x_relations'::name, 'View v_ui_arc_x_relations should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_arc_x_relations',
    ARRAY[
        'rid', 'arc_id', 'featurecat_id', 'catalog', 'feature_id', 'feature_code',
        'sys_type', 'arc_state', 'feature_state', 'x', 'y', 'proceed_from',
        'proceed_from_id', 'sys_table_id'
    ],
    'View v_ui_arc_x_relations should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_arc_x_relations', 'rid', 'int8', 'Column rid should be int8');
SELECT col_type_is('v_ui_arc_x_relations', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('v_ui_arc_x_relations', 'featurecat_id', 'varchar(18)', 'Column featurecat_id should be varchar(18)');
SELECT col_type_is('v_ui_arc_x_relations', 'catalog', 'varchar(30)', 'Column catalog should be varchar(30)');
SELECT col_type_is('v_ui_arc_x_relations', 'feature_id', 'int4', 'Column feature_id should be int4');
SELECT col_type_is('v_ui_arc_x_relations', 'feature_code', 'text', 'Column feature_code should be text');
SELECT col_type_is('v_ui_arc_x_relations', 'sys_type', 'varchar(30)', 'Column sys_type should be varchar(30)');
SELECT col_type_is('v_ui_arc_x_relations', 'arc_state', 'int2', 'Column arc_state should be int2');
SELECT col_type_is('v_ui_arc_x_relations', 'feature_state', 'int2', 'Column feature_state should be int2');
SELECT col_type_is('v_ui_arc_x_relations', 'x', 'float8', 'Column x should be float8');
SELECT col_type_is('v_ui_arc_x_relations', 'y', 'float8', 'Column y should be float8');
SELECT col_type_is('v_ui_arc_x_relations', 'proceed_from', 'varchar(16)', 'Column proceed_from should be varchar(16)');
SELECT col_type_is('v_ui_arc_x_relations', 'proceed_from_id', 'int4', 'Column proceed_from_id should be int4');
SELECT col_type_is('v_ui_arc_x_relations', 'sys_table_id', 'text', 'Column sys_table_id should be text');

SELECT * FROM finish();

ROLLBACK;
