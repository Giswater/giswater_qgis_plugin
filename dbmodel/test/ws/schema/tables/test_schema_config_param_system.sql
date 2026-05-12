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

-- Check table config_param_system
SELECT has_table('config_param_system'::name, 'Table config_param_system should exist');

-- Check columns
SELECT columns_are(
    'config_param_system',
    ARRAY[
        'parameter', 'value', 'descript', 'label', 'dv_querytext', 'dv_filterbyfield', 'isenabled', 'layoutorder',
        'project_type', 'dv_isparent', 'isautoupdate', 'datatype', 'widgettype', 'ismandatory', 'iseditable',
        'dv_orderby_id', 'dv_isnullvalue', 'stylesheet', 'widgetcontrols', 'placeholder', 'standardvalue', 'layoutname'
    ],
    'Table config_param_system should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('config_param_system', ARRAY['parameter'], 'Column parameter should be primary key');

-- Check column types
SELECT col_type_is('config_param_system', 'parameter', 'varchar(50)', 'Column parameter should be varchar(50)');
SELECT col_type_is('config_param_system', 'value', 'text', 'Column value should be text');
SELECT col_type_is('config_param_system', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('config_param_system', 'label', 'text', 'Column label should be text');
SELECT col_type_is('config_param_system', 'dv_querytext', 'text', 'Column dv_querytext should be text');
SELECT col_type_is('config_param_system', 'dv_filterbyfield', 'text', 'Column dv_filterbyfield should be text');
SELECT col_type_is('config_param_system', 'isenabled', 'boolean', 'Column isenabled should be boolean');
SELECT col_type_is('config_param_system', 'layoutorder', 'integer', 'Column layoutorder should be integer');
SELECT col_type_is('config_param_system', 'project_type', 'varchar', 'Column project_type should be varchar');
SELECT col_type_is('config_param_system', 'dv_isparent', 'boolean', 'Column dv_isparent should be boolean');
SELECT col_type_is('config_param_system', 'isautoupdate', 'boolean', 'Column isautoupdate should be boolean');
SELECT col_type_is('config_param_system', 'datatype', 'varchar', 'Column datatype should be varchar');
SELECT col_type_is('config_param_system', 'widgettype', 'varchar', 'Column widgettype should be varchar');
SELECT col_type_is('config_param_system', 'ismandatory', 'boolean', 'Column ismandatory should be boolean');
SELECT col_type_is('config_param_system', 'iseditable', 'boolean', 'Column iseditable should be boolean');
SELECT col_type_is('config_param_system', 'dv_orderby_id', 'boolean', 'Column dv_orderby_id should be boolean');
SELECT col_type_is('config_param_system', 'dv_isnullvalue', 'boolean', 'Column dv_isnullvalue should be boolean');
SELECT col_type_is('config_param_system', 'stylesheet', 'json', 'Column stylesheet should be json');
SELECT col_type_is('config_param_system', 'widgetcontrols', 'json', 'Column widgetcontrols should be json');
SELECT col_type_is('config_param_system', 'placeholder', 'text', 'Column placeholder should be text');
SELECT col_type_is('config_param_system', 'standardvalue', 'text', 'Column standardvalue should be text');
SELECT col_type_is('config_param_system', 'layoutname', 'text', 'Column layoutname should be text');

-- Check foreign keys
SELECT hasnt_fk('config_param_system', 'Table config_param_system should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('config_param_system', 'parameter', 'Column parameter should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
