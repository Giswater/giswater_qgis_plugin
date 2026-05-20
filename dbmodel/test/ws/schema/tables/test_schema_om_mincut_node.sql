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
SELECT has_table('om_mincut_node'::name, 'Table om_mincut_node should exist');

-- Check columns
SELECT columns_are(
    'om_mincut_node',
    ARRAY[
        'id', 'result_id', 'node_id', 'the_geom', 'node_type', 'minsector_id'
    ],
    'Table om_mincut_node should have the correct columns'
);

-- Check column types
SELECT col_type_is('om_mincut_node', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('om_mincut_node', 'result_id', 'int4', 'Column result_id should be int4');
SELECT col_type_is('om_mincut_node', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('om_mincut_node', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('om_mincut_node', 'node_type', 'varchar(30)', 'Column node_type should be varchar(30)');
SELECT col_type_is('om_mincut_node', 'minsector_id', 'int4', 'Column minsector_id should be int4');

-- Check foreign keys
SELECT has_fk('om_mincut_node', 'Table om_mincut_node should have foreign keys');

SELECT fk_ok('om_mincut_node', 'result_id', 'om_mincut', 'id', 'FK result_id → om_mincut.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
