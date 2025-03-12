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

-- Check table config_form_fields
SELECT has_table('config_form_fields'::name, 'Table config_form_fields should exist');

-- Check columns
SELECT columns_are(
    'config_form_fields',
    ARRAY[
        'formname', 'formtype', 'tabname', 'columnname', 'layoutname', 'layoutorder', 'datatype', 'widgettype', 'label', 'tooltip',
        'placeholder', 'ismandatory', 'isparent', 'iseditable', 'isautoupdate', 'isfilter', 'dv_querytext', 'dv_orderby_id',
        'dv_isnullvalue', 'dv_parent_id', 'dv_querytext_filterc', 'stylesheet', 'widgetcontrols', 'widgetfunction', 'linkedobject',
        'hidden', 'web_layoutorder'
    ],
    'Table config_form_fields should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('config_form_fields', ARRAY['formname', 'formtype', 'columnname', 'tabname'], 'Columns formname, formtype, columnname, tabname should be primary key');

-- Check column types
SELECT col_type_is('config_form_fields', 'formname', 'character varying(50)', 'Column formname should be varchar(50)');
SELECT col_type_is('config_form_fields', 'formtype', 'character varying(50)', 'Column formtype should be varchar(50)');
SELECT col_type_is('config_form_fields', 'tabname', 'character varying(30)', 'Column tabname should be varchar(30)');
SELECT col_type_is('config_form_fields', 'columnname', 'character varying(30)', 'Column columnname should be varchar(30)');
SELECT col_type_is('config_form_fields', 'layoutname', 'text', 'Column layoutname should be text');
SELECT col_type_is('config_form_fields', 'layoutorder', 'integer', 'Column layoutorder should be integer');
SELECT col_type_is('config_form_fields', 'datatype', 'character varying(30)', 'Column datatype should be varchar(30)');
SELECT col_type_is('config_form_fields', 'widgettype', 'character varying(30)', 'Column widgettype should be varchar(30)');
SELECT col_type_is('config_form_fields', 'label', 'text', 'Column label should be text');
SELECT col_type_is('config_form_fields', 'tooltip', 'text', 'Column tooltip should be text');
SELECT col_type_is('config_form_fields', 'placeholder', 'text', 'Column placeholder should be text');
SELECT col_type_is('config_form_fields', 'ismandatory', 'boolean', 'Column ismandatory should be boolean');
SELECT col_type_is('config_form_fields', 'isparent', 'boolean', 'Column isparent should be boolean');
SELECT col_type_is('config_form_fields', 'iseditable', 'boolean', 'Column iseditable should be boolean');
SELECT col_type_is('config_form_fields', 'isautoupdate', 'boolean', 'Column isautoupdate should be boolean');
SELECT col_type_is('config_form_fields', 'isfilter', 'boolean', 'Column isfilter should be boolean');
SELECT col_type_is('config_form_fields', 'dv_querytext', 'text', 'Column dv_querytext should be text');
SELECT col_type_is('config_form_fields', 'dv_orderby_id', 'boolean', 'Column dv_orderby_id should be boolean');
SELECT col_type_is('config_form_fields', 'dv_isnullvalue', 'boolean', 'Column dv_isnullvalue should be boolean');
SELECT col_type_is('config_form_fields', 'dv_parent_id', 'text', 'Column dv_parent_id should be text');
SELECT col_type_is('config_form_fields', 'dv_querytext_filterc', 'text', 'Column dv_querytext_filterc should be text');
SELECT col_type_is('config_form_fields', 'stylesheet', 'json', 'Column stylesheet should be json');
SELECT col_type_is('config_form_fields', 'widgetcontrols', 'json', 'Column widgetcontrols should be json');
SELECT col_type_is('config_form_fields', 'widgetfunction', 'json', 'Column widgetfunction should be json');
SELECT col_type_is('config_form_fields', 'linkedobject', 'text', 'Column linkedobject should be text');
SELECT col_type_is('config_form_fields', 'hidden', 'boolean', 'Column hidden should be boolean');
SELECT col_type_is('config_form_fields', 'web_layoutorder', 'integer', 'Column web_layoutorder should be integer');

-- Check foreign keys
SELECT hasnt_fk('config_form_fields', 'Table config_form_fields should have no foreign keys');

-- Check triggers
SELECT has_trigger('config_form_fields', 'gw_trg_config_control', 'Table should have gw_trg_config_control trigger');
SELECT has_trigger('config_form_fields', 'gw_trg_typevalue_fk_insert', 'Table should have gw_trg_typevalue_fk_insert trigger');
SELECT has_trigger('config_form_fields', 'gw_trg_typevalue_fk_update', 'Table should have gw_trg_typevalue_fk_update trigger');

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_default_is('config_form_fields', 'hidden', false, 'Column hidden should have default value false');
SELECT col_not_null('config_form_fields', 'formname', 'Column formname should be NOT NULL');
SELECT col_not_null('config_form_fields', 'formtype', 'Column formtype should be NOT NULL');
SELECT col_not_null('config_form_fields', 'columnname', 'Column columnname should be NOT NULL');
SELECT col_not_null('config_form_fields', 'tabname', 'Column tabname should be NOT NULL');
SELECT col_not_null('config_form_fields', 'hidden', 'Column hidden should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
