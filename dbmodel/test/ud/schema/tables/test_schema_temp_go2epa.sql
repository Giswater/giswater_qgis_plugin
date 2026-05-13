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
SELECT has_table('temp_go2epa'::name, 'Table temp_go2epa should exist');

-- Check columns
SELECT columns_are(
    'temp_go2epa',
    ARRAY[
        'id', 'arc_id', 'vnode_id', 'locate', 'top_elev', 'ymax',
        'idmin'
    ],
    'Table temp_go2epa should have the correct columns'
);

-- Check column types
SELECT col_type_is('temp_go2epa', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('temp_go2epa', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('temp_go2epa', 'vnode_id', 'varchar(20)', 'Column vnode_id should be varchar(20)');
SELECT col_type_is('temp_go2epa', 'locate', 'float8', 'Column locate should be float8');
SELECT col_type_is('temp_go2epa', 'top_elev', 'float8', 'Column top_elev should be float8');
SELECT col_type_is('temp_go2epa', 'ymax', 'float8', 'Column ymax should be float8');
SELECT col_type_is('temp_go2epa', 'idmin', 'int4', 'Column idmin should be int4');

-- Finish
SELECT * FROM finish();

ROLLBACK;
