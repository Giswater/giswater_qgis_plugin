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
SELECT has_table('audit_log_data'::name, 'Table audit_log_data should exist');

-- Check columns
SELECT columns_are(
    'audit_log_data',
    ARRAY[
        'id', 'fid', 'feature_type', 'feature_id', 'enabled', 'log_message',
        'tstamp', 'cur_user', 'addparam'
    ],
    'Table audit_log_data should have the correct columns'
);

-- Check column types
SELECT col_type_is('audit_log_data', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('audit_log_data', 'fid', 'int2', 'Column fid should be int2');
SELECT col_type_is('audit_log_data', 'feature_type', 'varchar(16)', 'Column feature_type should be varchar(16)');
SELECT col_type_is('audit_log_data', 'feature_id', 'varchar(16)', 'Column feature_id should be varchar(16)');
SELECT col_type_is('audit_log_data', 'enabled', 'bool', 'Column enabled should be bool');
SELECT col_type_is('audit_log_data', 'log_message', 'text', 'Column log_message should be text');
SELECT col_type_is('audit_log_data', 'tstamp', 'timestamp without time zone', 'Column tstamp should be timestamp without time zone');
SELECT col_type_is('audit_log_data', 'cur_user', 'text', 'Column cur_user should be text');
SELECT col_type_is('audit_log_data', 'addparam', 'json', 'Column addparam should be json');

-- Finish
SELECT * FROM finish();

ROLLBACK;
