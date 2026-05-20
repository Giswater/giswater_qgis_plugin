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
SELECT has_table('config_form_tabs'::name, 'Table config_form_tabs should exist');

-- Check columns
SELECT columns_are(
    'config_form_tabs',
    ARRAY[
        'formname', 'tabname', 'label', 'tooltip', 'sys_role', 'tabfunction',
        'tabactions', 'orderby', 'device'
    ],
    'Table config_form_tabs should have the correct columns'
);

-- Check column types
SELECT col_type_is('config_form_tabs', 'formname', 'varchar(50)', 'Column formname should be varchar(50)');
SELECT col_type_is('config_form_tabs', 'tabname', 'text', 'Column tabname should be text');
SELECT col_type_is('config_form_tabs', 'label', 'text', 'Column label should be text');
SELECT col_type_is('config_form_tabs', 'tooltip', 'text', 'Column tooltip should be text');
SELECT col_type_is('config_form_tabs', 'sys_role', 'text', 'Column sys_role should be text');
SELECT col_type_is('config_form_tabs', 'tabfunction', 'json', 'Column tabfunction should be json');
SELECT col_type_is('config_form_tabs', 'tabactions', 'json', 'Column tabactions should be json');
SELECT col_type_is('config_form_tabs', 'orderby', 'int4', 'Column orderby should be int4');
SELECT col_type_is('config_form_tabs', 'device', 'int4[]', 'Column device should be int4[]');

-- Finish
SELECT * FROM finish();

ROLLBACK;
