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

-- Check table audit_check_project
SELECT has_table('audit_check_project'::name, 'Table audit_check_project should exist');

-- Check columns
SELECT columns_are(
    'audit_check_project',
    ARRAY[
        'id', 'table_id', 'table_host', 'table_dbname', 'table_schema', 'fid', 'criticity', 'enabled', 'message', 'tstamp',
        'cur_user', 'observ', 'table_user'
    ],
    'Table audit_check_project should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('audit_check_project', 'id', 'Column id should be primary key');

-- Check column types
SELECT col_type_is('audit_check_project', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('audit_check_project', 'table_id', 'text', 'Column table_id should be text');
SELECT col_type_is('audit_check_project', 'table_host', 'text', 'Column table_host should be text');
SELECT col_type_is('audit_check_project', 'table_dbname', 'text', 'Column table_dbname should be text');
SELECT col_type_is('audit_check_project', 'table_schema', 'text', 'Column table_schema should be text');
SELECT col_type_is('audit_check_project', 'fid', 'integer', 'Column fid should be integer');
SELECT col_type_is('audit_check_project', 'criticity', 'smallint', 'Column criticity should be smallint');
SELECT col_type_is('audit_check_project', 'enabled', 'boolean', 'Column enabled should be boolean');
SELECT col_type_is('audit_check_project', 'message', 'text', 'Column message should be text');
SELECT col_type_is('audit_check_project', 'tstamp', 'timestamp without time zone', 'Column tstamp should be timestamp');
SELECT col_type_is('audit_check_project', 'cur_user', 'text', 'Column cur_user should be text');
SELECT col_type_is('audit_check_project', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('audit_check_project', 'table_user', 'text', 'Column table_user should be text');

-- Check foreign keys
SELECT has_fk('audit_check_project', 'Table audit_check_project should have foreign keys');
SELECT fk_ok('audit_check_project', ARRAY['fid'], 'sys_fprocess', ARRAY['fid'], 'Table should have foreign key from fid to sys_fprocess.fid');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('audit_check_project_id_seq', 'Sequence audit_check_project_id_seq should exist');

SELECT * FROM finish();

ROLLBACK;
