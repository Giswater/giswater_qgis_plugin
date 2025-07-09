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

--check if table exists
SELECT has_table('config_form_fields'::name, 'Table config_form_fields should exist');

-- check columns names 


SELECT columns_are(
    'config_form_fields',
    ARRAY[
      'formname', 'formtype', 'tabname', 'columnname', 'layoutname', 'layoutorder', 'datatype', 'widgettype', 'label', 'tooltip', 'placeholder',
      'ismandatory', 'isparent', 'iseditable', 'isautoupdate', 'isfilter', 'dv_querytext', 'dv_orderby_id', 'dv_isnullvalue', 'dv_parent_id', 'dv_querytext_filterc',
      'stylesheet', 'widgetcontrols', 'widgetfunction', 'linkedobject', 'hidden', 'web_layoutorder',
    ],
    'Table config_form_fields should have the correct columns'
);
-- check columns names
SELECT col_type_is('config_form_fields', 'formname', 'varchar(50)', 'Column formname should be varchar(50)');
SELECT col_type_is('config_form_fields', 'formtype', 'varchar(50)', 'Column formtype should be varchar(50)');
SELECT col_type_is('config_form_fields', 'tabname', 'varchar(30)', 'Column tabname should be varchar(30)');
SELECT col_type_is('config_form_fields', 'columnname', 'varchar(30)', 'Column columnname should be varchar(30)');
SELECT col_type_is('config_form_fields', 'layoutname', 'text', 'Column layoutname should be text');
SELECT col_type_is('config_form_fields', 'layoutorder', 'int4', 'Column layoutorder should be int4');
SELECT col_type_is('config_form_fields', 'datatype', 'varchar(30)', 'Column datatype should be varchar(30)');
SELECT col_type_is('config_form_fields', 'widgettype', 'varchar(30)', 'Column widgettype should be varchar(30)');
SELECT col_type_is('config_form_fields', 'label', 'text', 'Column label should be text');
SELECT col_type_is('config_form_fields', 'tooltip', 'text', 'Column tooltip should be text');
SELECT col_type_is('config_form_fields', 'placeholder', 'text', 'Column placeholder should be text');
SELECT col_type_is('config_form_fields', 'ismandatory', 'bool', 'Column ismandatory should be bool');
SELECT col_type_is('config_form_fields', 'isparent', 'bool', 'Column isparent should be bool');
SELECT col_type_is('config_form_fields', 'iseditable', 'bool', 'Column iseditable should be bool');
SELECT col_type_is('config_form_fields', 'isautoupdate', 'bool', 'Column isautoupdate should be bool');
SELECT col_type_is('config_form_fields', 'isfilter', 'bool', 'Column isfilter should be bool');
SELECT col_type_is('config_form_fields', 'dv_querytext', 'text', 'Column dv_querytext should be text');
SELECT col_type_is('config_form_fields', 'dv_orderby_id', 'bool', 'Column dv_orderby_id should be bool');
SELECT col_type_is('config_form_fields', 'dv_isnullvalue', 'bool', 'Column dv_isnullvalue should be bool');
SELECT col_type_is('config_form_fields', 'dv_parent_id', 'text', 'Column dv_parent_id should be text');
SELECT col_type_is('config_form_fields', 'dv_querytext_filterc', 'text', 'Column dv_querytext_filterc should be text');
SELECT col_type_is('config_form_fields', 'stylesheet', 'json', 'Column stylesheet should be json');
SELECT col_type_is('config_form_fields', 'widgetcontrols', 'json', 'Column widgetcontrols should be json');
SELECT col_type_is('config_form_fields', 'widgetfunction', 'json', 'Column widgetfunction should be json');
SELECT col_type_is('config_form_fields', 'linkedobject', 'text', 'Column linkedobject should be text');
SELECT col_type_is('config_form_fields', 'hidden', 'bool', 'Column hidden should be bool DEFAULT false');
SELECT col_type_is('config_form_fields', 'web_layoutorder', 'int4', 'Column web_layoutorder should be int4');




--check default values



-- check foreign keys


-- check indexes
SELECT has_index('config_form_fields', 'formname', 'Table config_form_fields should have index on formname');



--check trigger 
SELECT has_trigger('config_form_fields', 'gw_trg_config_control', 'Table config_form_fields should have trigger gw_trg_config_control');
SELECT has_trigger('config_form_fields', 'gw_trg_typevalue_fk_insert', 'Table config_form_fields should have trigger gw_trg_typevalue_fk_insert');
SELECT has_trigger('config_form_fields', 'gw_trg_typevalue_fk_update', 'Table config_form_fields should have trigger gw_trg_typevalue_fk_update');
--check rule 

SELECT * FROM finish();

ROLLBACK;