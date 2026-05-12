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

-- Check table config_form_tableview
SELECT has_table('config_form_tableview'::name, 'Table config_form_tableview should exist');

-- Check columns
SELECT columns_are(
    'config_form_tableview',
    ARRAY[
        'location_type', 'project_type', 'objectname', 'columnname', 'columnindex', 'visible', 'width', 'alias', 'style', 'addparam'
    ],
    'Table config_form_tableview should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('config_form_tableview', ARRAY['objectname', 'columnname'], 'Columns objectname, columnname should be primary key');

-- Check column types
SELECT col_type_is('config_form_tableview', 'location_type', 'character varying(50)', 'Column location_type should be varchar(50)');
SELECT col_type_is('config_form_tableview', 'project_type', 'character varying(50)', 'Column project_type should be varchar(50)');
SELECT col_type_is('config_form_tableview', 'objectname', 'character varying(50)', 'Column objectname should be varchar(50)');
SELECT col_type_is('config_form_tableview', 'columnname', 'character varying(50)', 'Column columnname should be varchar(50)');
SELECT col_type_is('config_form_tableview', 'columnindex', 'smallint', 'Column columnindex should be smallint');
SELECT col_type_is('config_form_tableview', 'visible', 'boolean', 'Column visible should be boolean');
SELECT col_type_is('config_form_tableview', 'width', 'integer', 'Column width should be integer');
SELECT col_type_is('config_form_tableview', 'alias', 'character varying(50)', 'Column alias should be varchar(50)');
SELECT col_type_is('config_form_tableview', 'style', 'json', 'Column style should be json');
SELECT col_type_is('config_form_tableview', 'addparam', 'json', 'Column addparam should be json');

-- Check foreign keys
SELECT hasnt_fk('config_form_tableview', 'Table config_form_tableview should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('config_form_tableview', 'location_type', 'Column location_type should be NOT NULL');
SELECT col_not_null('config_form_tableview', 'project_type', 'Column project_type should be NOT NULL');
SELECT col_not_null('config_form_tableview', 'objectname', 'Column objectname should be NOT NULL');
SELECT col_not_null('config_form_tableview', 'columnname', 'Column columnname should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
