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

-- Check table config_csv
SELECT has_table('config_csv'::name, 'Table config_csv should exist');

-- Check columns
SELECT columns_are(
    'config_csv',
    ARRAY[
        'fid', 'alias', 'descript', 'functionname', 'active', 'orderby', 'addparam'
    ],
    'Table config_csv should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('config_csv', 'fid', 'Column fid should be primary key');

-- Check column types
SELECT col_type_is('config_csv', 'fid', 'integer', 'Column fid should be integer');
SELECT col_type_is('config_csv', 'alias', 'text', 'Column alias should be text');
SELECT col_type_is('config_csv', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('config_csv', 'functionname', 'character varying(50)', 'Column functionname should be varchar(50)');
SELECT col_type_is('config_csv', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('config_csv', 'orderby', 'integer', 'Column orderby should be integer');
SELECT col_type_is('config_csv', 'addparam', 'json', 'Column addparam should be json');

-- Check foreign keys
SELECT hasnt_fk('config_csv', 'Table config_csv should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('config_csv_id_seq', 'Sequence config_csv_id_seq should exist');

-- Check constraints
SELECT col_default_is('config_csv', 'active', true, 'Column active should have default value');
SELECT col_not_null('config_csv', 'fid', 'Column fid should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
