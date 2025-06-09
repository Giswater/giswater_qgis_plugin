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

-- Check table audit_check_data
SELECT has_table('audit_check_data'::name, 'Table audit_check_data should exist');

-- Check columns
SELECT columns_are(
    'audit_check_data',
    ARRAY[
        'id', 'fid', 'result_id', 'table_id', 'column_id', 'criticity', 'enabled', 'error_message', 'tstamp', 'cur_user',
        'feature_type', 'feature_id', 'addparam', 'fcount'
    ],
    'Table audit_check_data should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('audit_check_data', 'id', 'Column id should be primary key');

-- Check column types
SELECT col_type_is('audit_check_data', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('audit_check_data', 'fid', 'smallint', 'Column fid should be smallint');
SELECT col_type_is('audit_check_data', 'result_id', 'character varying(50)', 'Column result_id should be varchar(50)');
SELECT col_type_is('audit_check_data', 'table_id', 'text', 'Column table_id should be text');
SELECT col_type_is('audit_check_data', 'column_id', 'text', 'Column column_id should be text');
SELECT col_type_is('audit_check_data', 'criticity', 'smallint', 'Column criticity should be smallint');
SELECT col_type_is('audit_check_data', 'enabled', 'boolean', 'Column enabled should be boolean');
SELECT col_type_is('audit_check_data', 'error_message', 'text', 'Column error_message should be text');
SELECT col_type_is('audit_check_data', 'tstamp', 'timestamp without time zone', 'Column tstamp should be timestamp');
SELECT col_type_is('audit_check_data', 'cur_user', 'text', 'Column cur_user should be text');
SELECT col_type_is('audit_check_data', 'feature_type', 'text', 'Column feature_type should be text');
SELECT col_type_is('audit_check_data', 'feature_id', 'text', 'Column feature_id should be text');
SELECT col_type_is('audit_check_data', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('audit_check_data', 'fcount', 'integer', 'Column fcount should be integer');

-- Check foreign keys
SELECT hasnt_fk('audit_check_data', 'Table audit_check_data should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('audit_check_data_id_seq', 'Sequence audit_check_data_id_seq should exist');

SELECT * FROM finish();

ROLLBACK;
