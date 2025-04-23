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

-- Check table temp_go2epa
SELECT has_table('temp_go2epa'::name, 'Table temp_go2epa should exist');

-- Check columns
SELECT columns_are(
    'temp_go2epa',
    ARRAY[
        'id', 'arc_id', 'vnode_id', 'locate', 'elevation', 'depth', 'idmin'
    ],
    'Table temp_go2epa should have the correct columns'
);

-- Check primary key

-- Check column types
SELECT col_type_is('temp_go2epa', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('temp_go2epa', 'arc_id', 'character varying(20)', 'Column arc_id should be character varying(20)');
SELECT col_type_is('temp_go2epa', 'vnode_id', 'character varying(20)', 'Column vnode_id should be character varying(20)');
SELECT col_type_is('temp_go2epa', 'locate', 'double precision', 'Column locate should be double precision');
SELECT col_type_is('temp_go2epa', 'elevation', 'double precision', 'Column elevation should be double precision');
SELECT col_type_is('temp_go2epa', 'depth', 'double precision', 'Column depth should be double precision');
SELECT col_type_is('temp_go2epa', 'idmin', 'integer', 'Column idmin should be integer');

-- Check default values
SELECT col_has_default('temp_go2epa', 'id', 'Column id should have a default value');

-- Check indexes
SELECT has_index('temp_go2epa', 'temp_go2epa_arc_id', 'Index temp_go2epa_arc_id should exist');

SELECT * FROM finish();

ROLLBACK;