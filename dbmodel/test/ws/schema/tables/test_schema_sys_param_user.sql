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

-- Check table sys_param_user
SELECT has_table('sys_param_user'::name, 'Table sys_param_user should exist');

-- Check columns
SELECT columns_are(
    'sys_param_user',
    ARRAY[
        'id', 'formname', 'descript', 'sys_role', 'idval', 'label', 'dv_querytext', 'dv_parent_id', 
        'isenabled', 'layoutorder', 'project_type', 'isparent', 'dv_querytext_filterc', 'feature_field_id', 
        'feature_dv_parent_value', 'isautoupdate', 'datatype', 'widgettype', 'ismandatory', 'widgetcontrols', 
        'vdefault', 'layoutname', 'iseditable', 'dv_orderby_id', 'dv_isnullvalue', 'stylesheet', 'placeholder', 'source'
    ],
    'Table sys_param_user should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('sys_param_user', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('sys_param_user', 'id', 'text', 'Column id should be text');
SELECT col_type_is('sys_param_user', 'formname', 'text', 'Column formname should be text');
SELECT col_type_is('sys_param_user', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('sys_param_user', 'sys_role', 'character varying(30)', 'Column sys_role should be character varying(30)');
SELECT col_type_is('sys_param_user', 'idval', 'text', 'Column idval should be text');
SELECT col_type_is('sys_param_user', 'label', 'text', 'Column label should be text');
SELECT col_type_is('sys_param_user', 'dv_querytext', 'text', 'Column dv_querytext should be text');
SELECT col_type_is('sys_param_user', 'dv_parent_id', 'text', 'Column dv_parent_id should be text');
SELECT col_type_is('sys_param_user', 'isenabled', 'boolean', 'Column isenabled should be boolean');
SELECT col_type_is('sys_param_user', 'layoutorder', 'integer', 'Column layoutorder should be integer');
SELECT col_type_is('sys_param_user', 'project_type', 'character varying', 'Column project_type should be character varying');
SELECT col_type_is('sys_param_user', 'isparent', 'boolean', 'Column isparent should be boolean');
SELECT col_type_is('sys_param_user', 'dv_querytext_filterc', 'text', 'Column dv_querytext_filterc should be text');
SELECT col_type_is('sys_param_user', 'feature_field_id', 'text', 'Column feature_field_id should be text');
SELECT col_type_is('sys_param_user', 'feature_dv_parent_value', 'text', 'Column feature_dv_parent_value should be text');
SELECT col_type_is('sys_param_user', 'isautoupdate', 'boolean', 'Column isautoupdate should be boolean');
SELECT col_type_is('sys_param_user', 'datatype', 'character varying(30)', 'Column datatype should be character varying(30)');
SELECT col_type_is('sys_param_user', 'widgettype', 'character varying(30)', 'Column widgettype should be character varying(30)');
SELECT col_type_is('sys_param_user', 'ismandatory', 'boolean', 'Column ismandatory should be boolean');
SELECT col_type_is('sys_param_user', 'widgetcontrols', 'json', 'Column widgetcontrols should be json');
SELECT col_type_is('sys_param_user', 'vdefault', 'text', 'Column vdefault should be text');
SELECT col_type_is('sys_param_user', 'layoutname', 'text', 'Column layoutname should be text');
SELECT col_type_is('sys_param_user', 'iseditable', 'boolean', 'Column iseditable should be boolean');
SELECT col_type_is('sys_param_user', 'dv_orderby_id', 'boolean', 'Column dv_orderby_id should be boolean');
SELECT col_type_is('sys_param_user', 'dv_isnullvalue', 'boolean', 'Column dv_isnullvalue should be boolean');
SELECT col_type_is('sys_param_user', 'stylesheet', 'json', 'Column stylesheet should be json');
SELECT col_type_is('sys_param_user', 'placeholder', 'text', 'Column placeholder should be text');
SELECT col_type_is('sys_param_user', 'source', 'text', 'Column source should be text');

-- Check constraints
SELECT col_not_null('sys_param_user', 'id', 'Column id should be NOT NULL');

-- Check triggers
SELECT has_trigger('sys_param_user', 'gw_trg_config_control', 'Table sys_param_user should have gw_trg_config_control trigger');

SELECT * FROM finish();

ROLLBACK; 