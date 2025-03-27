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

-- Check table temp_csv
SELECT has_table('temp_csv'::name, 'Table temp_csv should exist');

-- Check columns
SELECT columns_are(
    'temp_csv',
    ARRAY[
        'id', 'fid', 'cur_user', 'source', 'csv1', 'csv2', 'csv3', 'csv4', 'csv5', 
        'csv6', 'csv7', 'csv8', 'csv9', 'csv10', 'csv11', 'csv12', 'csv13', 'csv14', 
        'csv15', 'csv16', 'csv17', 'csv18', 'csv19', 'csv20', 'csv21', 'csv22', 
        'csv23', 'csv24', 'csv25', 'csv26', 'csv27', 'csv28', 'csv29', 'csv30', 
        'csv31', 'csv32', 'csv33', 'csv34', 'csv35', 'csv36', 'csv37', 'csv38', 
        'csv39', 'csv40', 'tstamp'
    ],
    'Table temp_csv should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('temp_csv', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('temp_csv', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('temp_csv', 'fid', 'integer', 'Column fid should be integer');
SELECT col_type_is('temp_csv', 'cur_user', 'text', 'Column cur_user should be text');
SELECT col_type_is('temp_csv', 'source', 'text', 'Column source should be text');
SELECT col_type_is('temp_csv', 'csv1', 'text', 'Column csv1 should be text');
SELECT col_type_is('temp_csv', 'csv2', 'text', 'Column csv2 should be text');
SELECT col_type_is('temp_csv', 'csv3', 'text', 'Column csv3 should be text');
SELECT col_type_is('temp_csv', 'csv4', 'text', 'Column csv4 should be text');
SELECT col_type_is('temp_csv', 'csv5', 'text', 'Column csv5 should be text');
SELECT col_type_is('temp_csv', 'csv6', 'text', 'Column csv6 should be text');
SELECT col_type_is('temp_csv', 'csv7', 'text', 'Column csv7 should be text');
SELECT col_type_is('temp_csv', 'csv8', 'text', 'Column csv8 should be text');
SELECT col_type_is('temp_csv', 'csv9', 'text', 'Column csv9 should be text');
SELECT col_type_is('temp_csv', 'csv10', 'text', 'Column csv10 should be text');
SELECT col_type_is('temp_csv', 'csv11', 'text', 'Column csv11 should be text');
SELECT col_type_is('temp_csv', 'csv12', 'text', 'Column csv12 should be text');
SELECT col_type_is('temp_csv', 'csv13', 'text', 'Column csv13 should be text');
SELECT col_type_is('temp_csv', 'csv14', 'text', 'Column csv14 should be text');
SELECT col_type_is('temp_csv', 'csv15', 'text', 'Column csv15 should be text');
SELECT col_type_is('temp_csv', 'csv16', 'text', 'Column csv16 should be text');
SELECT col_type_is('temp_csv', 'csv17', 'text', 'Column csv17 should be text');
SELECT col_type_is('temp_csv', 'csv18', 'text', 'Column csv18 should be text');
SELECT col_type_is('temp_csv', 'csv19', 'text', 'Column csv19 should be text');
SELECT col_type_is('temp_csv', 'csv20', 'text', 'Column csv20 should be text');
SELECT col_type_is('temp_csv', 'csv21', 'text', 'Column csv21 should be text');
SELECT col_type_is('temp_csv', 'csv22', 'text', 'Column csv22 should be text');
SELECT col_type_is('temp_csv', 'csv23', 'text', 'Column csv23 should be text');
SELECT col_type_is('temp_csv', 'csv24', 'text', 'Column csv24 should be text');
SELECT col_type_is('temp_csv', 'csv25', 'text', 'Column csv25 should be text');
SELECT col_type_is('temp_csv', 'csv26', 'text', 'Column csv26 should be text');
SELECT col_type_is('temp_csv', 'csv27', 'text', 'Column csv27 should be text');
SELECT col_type_is('temp_csv', 'csv28', 'text', 'Column csv28 should be text');
SELECT col_type_is('temp_csv', 'csv29', 'text', 'Column csv29 should be text');
SELECT col_type_is('temp_csv', 'csv30', 'text', 'Column csv30 should be text');
SELECT col_type_is('temp_csv', 'csv31', 'text', 'Column csv31 should be text');
SELECT col_type_is('temp_csv', 'csv32', 'text', 'Column csv32 should be text');
SELECT col_type_is('temp_csv', 'csv33', 'text', 'Column csv33 should be text');
SELECT col_type_is('temp_csv', 'csv34', 'text', 'Column csv34 should be text');
SELECT col_type_is('temp_csv', 'csv35', 'text', 'Column csv35 should be text');
SELECT col_type_is('temp_csv', 'csv36', 'text', 'Column csv36 should be text');
SELECT col_type_is('temp_csv', 'csv37', 'text', 'Column csv37 should be text');
SELECT col_type_is('temp_csv', 'csv38', 'text', 'Column csv38 should be text');
SELECT col_type_is('temp_csv', 'csv39', 'text', 'Column csv39 should be text');
SELECT col_type_is('temp_csv', 'csv40', 'text', 'Column csv40 should be text');
SELECT col_type_is('temp_csv', 'tstamp', 'timestamp without time zone', 'Column tstamp should be timestamp without time zone');

-- Check default values
SELECT col_has_default('temp_csv', 'id', 'Column id should have a default value');
SELECT col_default_is('temp_csv', 'cur_user', '"current_user"()', 'Column cur_user should default to "current_user"()');
SELECT col_default_is('temp_csv', 'tstamp', 'now()', 'Column tstamp should default to now()');

-- Check foreign keys
SELECT has_fk('temp_csv', 'Table temp_csv should have foreign keys');
SELECT fk_ok('temp_csv', 'fid', 'sys_fprocess', 'fid', 'FK fid should reference sys_fprocess.fid');

-- Check indexes
SELECT has_index('temp_csv', 'temp_csv_source', 'Index temp_csv_source should exist');

SELECT * FROM finish();

ROLLBACK; 