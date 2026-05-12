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

-- Check table config_form_list
SELECT has_table('config_form_list'::name, 'Table config_form_list should exist');

-- Check columns
SELECT columns_are(
    'config_form_list',
    ARRAY[
        'listname', 'query_text', 'device', 'listtype', 'listclass', 'vdefault', 'addparam'
    ],
    'Table config_form_list should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('config_form_list', ARRAY['listname', 'device'], 'Columns listname, device should be primary key');

-- Check column types
SELECT col_type_is('config_form_list', 'listname', 'character varying(50)', 'Column listname should be varchar(50)');
SELECT col_type_is('config_form_list', 'query_text', 'text', 'Column query_text should be text');
SELECT col_type_is('config_form_list', 'device', 'smallint', 'Column device should be smallint');
SELECT col_type_is('config_form_list', 'listtype', 'character varying(30)', 'Column listtype should be varchar(30)');
SELECT col_type_is('config_form_list', 'listclass', 'character varying(30)', 'Column listclass should be varchar(30)');
SELECT col_type_is('config_form_list', 'vdefault', 'json', 'Column vdefault should be json');
SELECT col_type_is('config_form_list', 'addparam', 'json', 'Column addparam should be json');

-- Check foreign keys
SELECT hasnt_fk('config_form_list', 'Table config_form_list should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('config_form_list', 'listname', 'Column listname should be NOT NULL');
SELECT col_not_null('config_form_list', 'device', 'Column device should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
