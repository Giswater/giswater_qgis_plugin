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
SELECT has_table('config_form_help'::name, 'Table config_form_help should exist');

-- Check columns
SELECT columns_are(
    'config_form_help',
    ARRAY[
        'formtype', 'formname', 'tabname', 'path'
    ],
    'Table config_form_help should have the correct columns'
);

-- Check column types
SELECT col_type_is('config_form_help', 'formtype', 'varchar(50)', 'Column formtype should be varchar(50)');
SELECT col_type_is('config_form_help', 'formname', 'varchar(50)', 'Column formname should be varchar(50)');
SELECT col_type_is('config_form_help', 'tabname', 'varchar(30)', 'Column tabname should be varchar(30)');
SELECT col_type_is('config_form_help', 'path', 'text', 'Column path should be text');

-- Finish
SELECT * FROM finish();

ROLLBACK;
