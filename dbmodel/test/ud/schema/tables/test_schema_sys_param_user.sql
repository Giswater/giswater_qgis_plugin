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
SELECT has_table('sys_param_user'::name, 'Table sys_param_user should exist');

-- Check columns
SELECT columns_are(
    'sys_param_user',
    ARRAY[
        'id', 'formname', 'descript', 'sys_role', 'idval', 'label',
        'dv_querytext', 'dv_parent_id', 'isenabled', 'layoutorder', 'project_type', 'isparent',
        'dv_querytext_filterc', 'feature_field_id', 'feature_dv_parent_value', 'isautoupdate', 'datatype', 'widgettype',
        'ismandatory', 'widgetcontrols', 'vdefault', 'layoutname', 'iseditable', 'dv_orderby_id',
        'dv_isnullvalue', 'stylesheet', 'placeholder', 'source'
    ],
    'Table sys_param_user should have the correct columns'
);

-- Check column types
SELECT col_type_is('sys_param_user', 'id', 'text', 'Column id should be text');
SELECT col_type_is('sys_param_user', 'formname', 'text', 'Column formname should be text');
SELECT col_type_is('sys_param_user', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('sys_param_user', 'sys_role', 'varchar(30)', 'Column sys_role should be varchar(30)');
SELECT col_type_is('sys_param_user', 'idval', 'text', 'Column idval should be text');
SELECT col_type_is('sys_param_user', 'label', 'text', 'Column label should be text');
SELECT col_type_is('sys_param_user', 'dv_querytext', 'text', 'Column dv_querytext should be text');
SELECT col_type_is('sys_param_user', 'dv_parent_id', 'text', 'Column dv_parent_id should be text');
SELECT col_type_is('sys_param_user', 'isenabled', 'bool', 'Column isenabled should be bool');
SELECT col_type_is('sys_param_user', 'layoutorder', 'int4', 'Column layoutorder should be int4');
SELECT col_type_is('sys_param_user', 'project_type', 'varchar', 'Column project_type should be varchar');
SELECT col_type_is('sys_param_user', 'isparent', 'bool', 'Column isparent should be bool');
SELECT col_type_is('sys_param_user', 'dv_querytext_filterc', 'text', 'Column dv_querytext_filterc should be text');
SELECT col_type_is('sys_param_user', 'feature_field_id', 'text', 'Column feature_field_id should be text');
SELECT col_type_is('sys_param_user', 'feature_dv_parent_value', 'text', 'Column feature_dv_parent_value should be text');
SELECT col_type_is('sys_param_user', 'isautoupdate', 'bool', 'Column isautoupdate should be bool');
SELECT col_type_is('sys_param_user', 'datatype', 'varchar(30)', 'Column datatype should be varchar(30)');
SELECT col_type_is('sys_param_user', 'widgettype', 'varchar(30)', 'Column widgettype should be varchar(30)');
SELECT col_type_is('sys_param_user', 'ismandatory', 'bool', 'Column ismandatory should be bool');
SELECT col_type_is('sys_param_user', 'widgetcontrols', 'json', 'Column widgetcontrols should be json');
SELECT col_type_is('sys_param_user', 'vdefault', 'text', 'Column vdefault should be text');
SELECT col_type_is('sys_param_user', 'layoutname', 'text', 'Column layoutname should be text');
SELECT col_type_is('sys_param_user', 'iseditable', 'bool', 'Column iseditable should be bool');
SELECT col_type_is('sys_param_user', 'dv_orderby_id', 'bool', 'Column dv_orderby_id should be bool');
SELECT col_type_is('sys_param_user', 'dv_isnullvalue', 'bool', 'Column dv_isnullvalue should be bool');
SELECT col_type_is('sys_param_user', 'stylesheet', 'json', 'Column stylesheet should be json');
SELECT col_type_is('sys_param_user', 'placeholder', 'text', 'Column placeholder should be text');
SELECT col_type_is('sys_param_user', 'source', 'text', 'Column source should be text');

-- Finish
SELECT * FROM finish();

ROLLBACK;
