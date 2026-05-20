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
SELECT has_table('temp_data'::name, 'Table temp_data should exist');

-- Check columns
SELECT columns_are(
    'temp_data',
    ARRAY[
        'id', 'fid', 'feature_type', 'feature_id', 'enabled', 'log_message',
        'tstamp', 'cur_user', 'addparam', 'float_value', 'int_value', 'flag',
        'date_value', 'text_value'
    ],
    'Table temp_data should have the correct columns'
);

-- Check column types
SELECT col_type_is('temp_data', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('temp_data', 'fid', 'int2', 'Column fid should be int2');
SELECT col_type_is('temp_data', 'feature_type', 'varchar(16)', 'Column feature_type should be varchar(16)');
SELECT col_type_is('temp_data', 'feature_id', 'int4', 'Column feature_id should be int4');
SELECT col_type_is('temp_data', 'enabled', 'bool', 'Column enabled should be bool');
SELECT col_type_is('temp_data', 'log_message', 'text', 'Column log_message should be text');
SELECT col_type_is('temp_data', 'tstamp', 'timestamp without time zone', 'Column tstamp should be timestamp without time zone');
SELECT col_type_is('temp_data', 'cur_user', 'text', 'Column cur_user should be text');
SELECT col_type_is('temp_data', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('temp_data', 'float_value', 'float8', 'Column float_value should be float8');
SELECT col_type_is('temp_data', 'int_value', 'int4', 'Column int_value should be int4');
SELECT col_type_is('temp_data', 'flag', 'bool', 'Column flag should be bool');
SELECT col_type_is('temp_data', 'date_value', 'timestamp without time zone', 'Column date_value should be timestamp without time zone');
SELECT col_type_is('temp_data', 'text_value', 'text', 'Column text_value should be text');

-- Finish
SELECT * FROM finish();

ROLLBACK;
