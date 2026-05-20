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

-- Check view ve_config_addfields
SELECT has_view('ve_config_addfields'::name, 'View ve_config_addfields should exist');

-- Check view columns
SELECT columns_are(
    've_config_addfields',
    ARRAY[
        'columnname', 'datatype', 'widgettype', 'label', 'hidden', 'layoutname',
        'layout_order', 'addfield_order', 'active', 'tooltip', 'placeholder', 'ismandatory',
        'isparent', 'iseditable', 'isautoupdate', 'dv_querytext', 'dv_orderby_id', 'dv_isnullvalue',
        'dv_parent_id', 'dv_querytext_filterc', 'widgetfunction', 'linkedobject', 'stylesheet', 'widgetcontrols',
        'formname', 'param_id', 'cat_feature_id'
    ],
    'View ve_config_addfields should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_config_addfields', 'columnname', 'varchar(50)', 'Column columnname should be varchar(50)');
SELECT col_type_is('ve_config_addfields', 'datatype', 'varchar(30)', 'Column datatype should be varchar(30)');
SELECT col_type_is('ve_config_addfields', 'widgettype', 'varchar(30)', 'Column widgettype should be varchar(30)');
SELECT col_type_is('ve_config_addfields', 'label', 'text', 'Column label should be text');
SELECT col_type_is('ve_config_addfields', 'hidden', 'bool', 'Column hidden should be bool');
SELECT col_type_is('ve_config_addfields', 'layoutname', 'text', 'Column layoutname should be text');
SELECT col_type_is('ve_config_addfields', 'layout_order', 'int4', 'Column layout_order should be int4');
SELECT col_type_is('ve_config_addfields', 'addfield_order', 'int4', 'Column addfield_order should be int4');
SELECT col_type_is('ve_config_addfields', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('ve_config_addfields', 'tooltip', 'text', 'Column tooltip should be text');
SELECT col_type_is('ve_config_addfields', 'placeholder', 'text', 'Column placeholder should be text');
SELECT col_type_is('ve_config_addfields', 'ismandatory', 'bool', 'Column ismandatory should be bool');
SELECT col_type_is('ve_config_addfields', 'isparent', 'bool', 'Column isparent should be bool');
SELECT col_type_is('ve_config_addfields', 'iseditable', 'bool', 'Column iseditable should be bool');
SELECT col_type_is('ve_config_addfields', 'isautoupdate', 'bool', 'Column isautoupdate should be bool');
SELECT col_type_is('ve_config_addfields', 'dv_querytext', 'text', 'Column dv_querytext should be text');
SELECT col_type_is('ve_config_addfields', 'dv_orderby_id', 'bool', 'Column dv_orderby_id should be bool');
SELECT col_type_is('ve_config_addfields', 'dv_isnullvalue', 'bool', 'Column dv_isnullvalue should be bool');
SELECT col_type_is('ve_config_addfields', 'dv_parent_id', 'text', 'Column dv_parent_id should be text');
SELECT col_type_is('ve_config_addfields', 'dv_querytext_filterc', 'text', 'Column dv_querytext_filterc should be text');
SELECT col_type_is('ve_config_addfields', 'widgetfunction', 'json', 'Column widgetfunction should be json');
SELECT col_type_is('ve_config_addfields', 'linkedobject', 'text', 'Column linkedobject should be text');
SELECT col_type_is('ve_config_addfields', 'stylesheet', 'json', 'Column stylesheet should be json');
SELECT col_type_is('ve_config_addfields', 'widgetcontrols', 'json', 'Column widgetcontrols should be json');
SELECT col_type_is('ve_config_addfields', 'formname', 'varchar', 'Column formname should be varchar');
SELECT col_type_is('ve_config_addfields', 'param_id', 'int4', 'Column param_id should be int4');
SELECT col_type_is('ve_config_addfields', 'cat_feature_id', 'varchar(30)', 'Column cat_feature_id should be varchar(30)');

SELECT * FROM finish();

ROLLBACK;
