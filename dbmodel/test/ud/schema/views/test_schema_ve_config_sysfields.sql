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

-- Check view ve_config_sysfields
SELECT has_view('ve_config_sysfields'::name, 'View ve_config_sysfields should exist');

-- Check view columns
SELECT columns_are(
    've_config_sysfields',
    ARRAY[
        'rid', 'formname', 'formtype', 'columnname', 'label', 'hidden',
        'layoutname', 'layoutorder', 'iseditable', 'ismandatory', 'datatype', 'widgettype',
        'tooltip', 'placeholder', 'stylesheet', 'isparent', 'isautoupdate', 'dv_querytext',
        'dv_orderby_id', 'dv_isnullvalue', 'dv_parent_id', 'dv_querytext_filterc', 'widgetcontrols', 'widgetfunction',
        'linkedobject', 'cat_feature_id'
    ],
    'View ve_config_sysfields should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_config_sysfields', 'rid', 'int8', 'Column rid should be int8');
SELECT col_type_is('ve_config_sysfields', 'formname', 'varchar(50)', 'Column formname should be varchar(50)');
SELECT col_type_is('ve_config_sysfields', 'formtype', 'varchar(50)', 'Column formtype should be varchar(50)');
SELECT col_type_is('ve_config_sysfields', 'columnname', 'varchar(30)', 'Column columnname should be varchar(30)');
SELECT col_type_is('ve_config_sysfields', 'label', 'text', 'Column label should be text');
SELECT col_type_is('ve_config_sysfields', 'hidden', 'bool', 'Column hidden should be bool');
SELECT col_type_is('ve_config_sysfields', 'layoutname', 'text', 'Column layoutname should be text');
SELECT col_type_is('ve_config_sysfields', 'layoutorder', 'int4', 'Column layoutorder should be int4');
SELECT col_type_is('ve_config_sysfields', 'iseditable', 'bool', 'Column iseditable should be bool');
SELECT col_type_is('ve_config_sysfields', 'ismandatory', 'bool', 'Column ismandatory should be bool');
SELECT col_type_is('ve_config_sysfields', 'datatype', 'varchar(30)', 'Column datatype should be varchar(30)');
SELECT col_type_is('ve_config_sysfields', 'widgettype', 'varchar(30)', 'Column widgettype should be varchar(30)');
SELECT col_type_is('ve_config_sysfields', 'tooltip', 'text', 'Column tooltip should be text');
SELECT col_type_is('ve_config_sysfields', 'placeholder', 'text', 'Column placeholder should be text');
SELECT col_type_is('ve_config_sysfields', 'stylesheet', 'text', 'Column stylesheet should be text');
SELECT col_type_is('ve_config_sysfields', 'isparent', 'bool', 'Column isparent should be bool');
SELECT col_type_is('ve_config_sysfields', 'isautoupdate', 'bool', 'Column isautoupdate should be bool');
SELECT col_type_is('ve_config_sysfields', 'dv_querytext', 'text', 'Column dv_querytext should be text');
SELECT col_type_is('ve_config_sysfields', 'dv_orderby_id', 'bool', 'Column dv_orderby_id should be bool');
SELECT col_type_is('ve_config_sysfields', 'dv_isnullvalue', 'bool', 'Column dv_isnullvalue should be bool');
SELECT col_type_is('ve_config_sysfields', 'dv_parent_id', 'text', 'Column dv_parent_id should be text');
SELECT col_type_is('ve_config_sysfields', 'dv_querytext_filterc', 'text', 'Column dv_querytext_filterc should be text');
SELECT col_type_is('ve_config_sysfields', 'widgetcontrols', 'text', 'Column widgetcontrols should be text');
SELECT col_type_is('ve_config_sysfields', 'widgetfunction', 'json', 'Column widgetfunction should be json');
SELECT col_type_is('ve_config_sysfields', 'linkedobject', 'text', 'Column linkedobject should be text');
SELECT col_type_is('ve_config_sysfields', 'cat_feature_id', 'varchar(30)', 'Column cat_feature_id should be varchar(30)');

SELECT * FROM finish();

ROLLBACK;
