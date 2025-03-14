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

-- Check table config_report
SELECT has_table('config_report'::name, 'Table config_report should exist');

-- Check columns
SELECT columns_are(
    'config_report',
    ARRAY[
        'id', 'alias', 'query_text', 'addparam', 'filterparam', 'sys_role', 'descript', 'active', 'device'
    ],
    'Table config_report should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('config_report', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('config_report', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('config_report', 'alias', 'text', 'Column alias should be text');
SELECT col_type_is('config_report', 'query_text', 'text', 'Column query_text should be text');
SELECT col_type_is('config_report', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('config_report', 'filterparam', 'json', 'Column filterparam should be json');
SELECT col_type_is('config_report', 'sys_role', 'text', 'Column sys_role should be text');
SELECT col_type_is('config_report', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('config_report', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('config_report', 'device', '_int4', 'Column device should be _int4');

-- Check foreign keys
SELECT has_fk('config_report', 'Table config_report should have foreign keys');
SELECT fk_ok('config_report', 'sys_role', 'sys_role', 'id', 'FK config_report_sys_role_id_fkey should exist');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('config_report_id_seq', 'Sequence config_report_id_seq should exist');

-- Check constraints
SELECT col_not_null('config_report', 'id', 'Column id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
