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

-- Check table config_form_tabs
SELECT has_table('config_form_tabs'::name, 'Table config_form_tabs should exist');

-- Check columns
SELECT columns_are(
    'config_form_tabs',
    ARRAY[
        'formname', 'tabname', 'label', 'tooltip', 'sys_role', 'tabfunction', 'tabactions', 'orderby', 'device'
    ],
    'Table config_form_tabs should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('config_form_tabs', ARRAY['formname', 'tabname'], 'Columns formname, tabname should be primary key');

-- Check column types
SELECT col_type_is('config_form_tabs', 'formname', 'character varying(50)', 'Column formname should be varchar(50)');
SELECT col_type_is('config_form_tabs', 'tabname', 'text', 'Column tabname should be text');
SELECT col_type_is('config_form_tabs', 'label', 'text', 'Column label should be text');
SELECT col_type_is('config_form_tabs', 'tooltip', 'text', 'Column tooltip should be text');
SELECT col_type_is('config_form_tabs', 'sys_role', 'text', 'Column sys_role should be text');
SELECT col_type_is('config_form_tabs', 'tabfunction', 'json', 'Column tabfunction should be json');
SELECT col_type_is('config_form_tabs', 'tabactions', 'json', 'Column tabactions should be json');
SELECT col_type_is('config_form_tabs', 'orderby', 'integer', 'Column orderby should be integer');
SELECT col_type_is('config_form_tabs', 'device', 'integer[]', 'Column device should be integer[]');

-- Check foreign keys
SELECT hasnt_fk('config_form_tabs', 'Table config_form_tabs should have no foreign keys');

-- Check triggers
SELECT has_trigger('config_form_tabs', 'gw_trg_typevalue_fk_insert', 'Table should have gw_trg_typevalue_fk_insert trigger');
SELECT has_trigger('config_form_tabs', 'gw_trg_typevalue_fk_update', 'Table should have gw_trg_typevalue_fk_update trigger');

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('config_form_tabs', 'formname', 'Column formname should be NOT NULL');
SELECT col_not_null('config_form_tabs', 'tabname', 'Column tabname should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
