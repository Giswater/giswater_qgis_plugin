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

-- Check table config_form_help
SELECT has_table('config_form_help'::name, 'Table config_form_help should exist');

-- Check columns
SELECT columns_are(
    'config_form_help',
    ARRAY[
        'formtype', 'formname', 'tabname', 'path'
    ],
    'Table config_form_help should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('config_form_help', ARRAY['formtype', 'formname', 'tabname'], 'Columns formtype, formname, tabname should be primary key');

-- Check column types
SELECT col_type_is('config_form_help', 'formtype', 'character varying(50)', 'Column formtype should be varchar(50)');
SELECT col_type_is('config_form_help', 'formname', 'character varying(50)', 'Column formname should be varchar(50)');
SELECT col_type_is('config_form_help', 'tabname', 'character varying(30)', 'Column tabname should be varchar(30)');
SELECT col_type_is('config_form_help', 'path', 'text', 'Column path should be text');

-- Check foreign keys
SELECT hasnt_fk('config_form_help', 'Table config_form_help should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_default_is('config_form_help', 'formtype', 'generic', 'Column formtype should have default value');
SELECT col_default_is('config_form_help', 'tabname', 'tab_none', 'Column tabname should have default value');
SELECT col_not_null('config_form_help', 'formtype', 'Column formtype should be NOT NULL');
SELECT col_not_null('config_form_help', 'formname', 'Column formname should be NOT NULL');
SELECT col_not_null('config_form_help', 'tabname', 'Column tabname should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
