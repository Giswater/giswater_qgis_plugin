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
SELECT has_table('ext_arc'::name, 'Table ext_arc should exist');

-- Check columns
SELECT columns_are(
    'ext_arc',
    ARRAY[
        'id', 'fid', 'arc_id', 'val', 'tstamp', 'observ',
        'cur_user'
    ],
    'Table ext_arc should have the correct columns'
);

-- Check column types
SELECT col_type_is('ext_arc', 'id', 'int8', 'Column id should be int8');
SELECT col_type_is('ext_arc', 'fid', 'int4', 'Column fid should be int4');
SELECT col_type_is('ext_arc', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('ext_arc', 'val', 'float8', 'Column val should be float8');
SELECT col_type_is('ext_arc', 'tstamp', 'timestamp without time zone', 'Column tstamp should be timestamp without time zone');
SELECT col_type_is('ext_arc', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('ext_arc', 'cur_user', 'text', 'Column cur_user should be text');

-- Finish
SELECT * FROM finish();

ROLLBACK;
