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

-- Check view ve_cat_dwf
SELECT has_view('ve_cat_dwf'::name, 'View ve_cat_dwf should exist');

-- Check view columns
SELECT columns_are(
    've_cat_dwf',
    ARRAY[
        'id', 'idval', 'startdate', 'enddate', 'observ', 'expl_id',
        'active', 'log'
    ],
    'View ve_cat_dwf should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_cat_dwf', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('ve_cat_dwf', 'idval', 'varchar(30)', 'Column idval should be varchar(30)');
SELECT col_type_is('ve_cat_dwf', 'startdate', 'timestamp without time zone', 'Column startdate should be timestamp without time zone');
SELECT col_type_is('ve_cat_dwf', 'enddate', 'timestamp without time zone', 'Column enddate should be timestamp without time zone');
SELECT col_type_is('ve_cat_dwf', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('ve_cat_dwf', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('ve_cat_dwf', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('ve_cat_dwf', 'log', 'text', 'Column log should be text');

SELECT * FROM finish();

ROLLBACK;
