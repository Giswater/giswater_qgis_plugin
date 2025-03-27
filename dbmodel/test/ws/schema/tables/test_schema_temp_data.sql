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

-- Check table temp_data
SELECT has_table('temp_data'::name, 'Table temp_data should exist');

-- Check columns
SELECT columns_are(
    'temp_data',
    ARRAY[
        'id', 'fid', 'feature_type', 'feature_id', 'enabled', 'log_message', 'tstamp', 
        'cur_user', 'addparam', 'float_value', 'int_value', 'flag', 'date_value', 'text_value'
    ],
    'Table temp_data should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('temp_data', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('temp_data', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('temp_data', 'fid', 'smallint', 'Column fid should be smallint');
SELECT col_type_is('temp_data', 'feature_type', 'character varying(16)', 'Column feature_type should be character varying(16)');
SELECT col_type_is('temp_data', 'feature_id', 'character varying(16)', 'Column feature_id should be character varying(16)');
SELECT col_type_is('temp_data', 'enabled', 'boolean', 'Column enabled should be boolean');
SELECT col_type_is('temp_data', 'log_message', 'text', 'Column log_message should be text');
SELECT col_type_is('temp_data', 'tstamp', 'timestamp without time zone', 'Column tstamp should be timestamp without time zone');
SELECT col_type_is('temp_data', 'cur_user', 'text', 'Column cur_user should be text');
SELECT col_type_is('temp_data', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('temp_data', 'float_value', 'double precision', 'Column float_value should be double precision');
SELECT col_type_is('temp_data', 'int_value', 'integer', 'Column int_value should be integer');
SELECT col_type_is('temp_data', 'flag', 'boolean', 'Column flag should be boolean');
SELECT col_type_is('temp_data', 'date_value', 'timestamp without time zone', 'Column date_value should be timestamp without time zone');
SELECT col_type_is('temp_data', 'text_value', 'text', 'Column text_value should be text');

-- Check default values
SELECT col_has_default('temp_data', 'id', 'Column id should have a default value');
SELECT col_default_is('temp_data', 'tstamp', 'now()', 'Column tstamp should default to now()');
SELECT col_default_is('temp_data', 'cur_user', '"current_user"()', 'Column cur_user should default to "current_user"()');

-- Check indexes
SELECT has_index('temp_data', 'temp_data_feature_id', 'Index temp_data_feature_id should exist');
SELECT has_index('temp_data', 'temp_data_feature_type', 'Index temp_data_feature_type should exist');

SELECT * FROM finish();

ROLLBACK; 