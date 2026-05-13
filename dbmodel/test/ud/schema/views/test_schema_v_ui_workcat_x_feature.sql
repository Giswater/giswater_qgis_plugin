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

-- Check view v_ui_workcat_x_feature
SELECT has_view('v_ui_workcat_x_feature'::name, 'View v_ui_workcat_x_feature should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_workcat_x_feature',
    ARRAY[
        'rid', 'feature_type', 'featurecat_id', 'feature_id', 'code', 'expl_name',
        'workcat_id', 'expl_id'
    ],
    'View v_ui_workcat_x_feature should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_workcat_x_feature', 'rid', 'int8', 'Column rid should be int8');
SELECT col_type_is('v_ui_workcat_x_feature', 'feature_type', 'varchar(16)', 'Column feature_type should be varchar(16)');
SELECT col_type_is('v_ui_workcat_x_feature', 'featurecat_id', 'varchar(30)', 'Column featurecat_id should be varchar(30)');
SELECT col_type_is('v_ui_workcat_x_feature', 'feature_id', 'int4', 'Column feature_id should be int4');
SELECT col_type_is('v_ui_workcat_x_feature', 'code', 'text', 'Column code should be text');
SELECT col_type_is('v_ui_workcat_x_feature', 'expl_name', 'varchar(100)', 'Column expl_name should be varchar(100)');
SELECT col_type_is('v_ui_workcat_x_feature', 'workcat_id', 'varchar', 'Column workcat_id should be varchar');
SELECT col_type_is('v_ui_workcat_x_feature', 'expl_id', 'int4', 'Column expl_id should be int4');

SELECT * FROM finish();

ROLLBACK;
