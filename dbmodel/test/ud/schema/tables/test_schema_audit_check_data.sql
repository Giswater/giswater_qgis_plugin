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
SELECT col_type_is('audit_check_data', 'id', 'serial4', 'Column id should be serial4');
SELECT col_type_is('audit_check_data', 'fid', 'int2', 'Column fid should be int2');
SELECT col_type_is('audit_check_data', 'result_id', 'varchar(50)', 'Column result_id should be varchar(50)');
SELECT col_type_is('audit_check_data', 'table_id', 'text', 'Column table_id should be text');
SELECT col_type_is('audit_check_data', 'column_id', 'text', 'Column column_id should be text');
SELECT col_type_is('audit_check_data', 'criticity', 'int2', 'Column criticity should be int2');
SELECT col_type_is('audit_check_data', 'enabled', 'bool', 'Column enabled should be bool');
SELECT col_type_is('audit_check_data', 'error_message', 'text', 'Column error_message should be text');
SELECT col_type_is('audit_check_data', 'tstamp', 'timestamp', 'Column tstamp should be timestamp');
SELECT col_type_is('audit_check_data', 'cur_user', 'text', 'Column cur_user should be text');
SELECT col_type_is('audit_check_data', 'feature_type', 'text', 'Column feature_type should be text');
SELECT col_type_is('audit_check_data', 'feature_id', 'text', 'Column feature_id should be text');
SELECT col_type_is('audit_check_data', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('audit_check_data', 'fcount', 'int4', 'Column fcount should be int4');

-- Check default values
SELECT col_has_default('audit_check_data', 'tstamp', 'Column tstamp should have default value');
SELECT col_has_default('audit_check_data', 'cur_user', 'Column cur_user should have default value');

-- Check indexes
SELECT has_index('audit_check_data', 'id', 'Table should have index on id');

-- Finish
SELECT * FROM finish();

ROLLBACK;