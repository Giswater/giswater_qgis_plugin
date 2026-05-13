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
SELECT has_table('temp_node'::name, 'Table temp_node should exist');

-- Check columns
SELECT columns_are(
    'temp_node',
    ARRAY[
        'id', 'result_id', 'node_id', 'top_elev', 'ymax', 'elev',
        'node_type', 'nodecat_id', 'epa_type', 'sector_id', 'state', 'state_type',
        'annotation', 'omzone_id', 'y0', 'ysur', 'apond', 'expl_id',
        'addparam', 'parent', 'arcposition', 'fusioned_node', 'age', 'the_geom',
        'created_at', 'created_by', 'updated_at', 'updated_by'
    ],
    'Table temp_node should have the correct columns'
);

-- Check column types
SELECT col_type_is('temp_node', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('temp_node', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('temp_node', 'node_id', 'text', 'Column node_id should be text');
SELECT col_type_is('temp_node', 'top_elev', 'numeric(12,3)', 'Column top_elev should be numeric(12,3)');
SELECT col_type_is('temp_node', 'ymax', 'numeric(12,3)', 'Column ymax should be numeric(12,3)');
SELECT col_type_is('temp_node', 'elev', 'numeric(12,3)', 'Column elev should be numeric(12,3)');
SELECT col_type_is('temp_node', 'node_type', 'varchar(30)', 'Column node_type should be varchar(30)');
SELECT col_type_is('temp_node', 'nodecat_id', 'varchar(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('temp_node', 'epa_type', 'varchar(16)', 'Column epa_type should be varchar(16)');
SELECT col_type_is('temp_node', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('temp_node', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('temp_node', 'state_type', 'int2', 'Column state_type should be int2');
SELECT col_type_is('temp_node', 'annotation', 'varchar(254)', 'Column annotation should be varchar(254)');
SELECT col_type_is('temp_node', 'omzone_id', 'int4', 'Column omzone_id should be int4');
SELECT col_type_is('temp_node', 'y0', 'numeric(12,4)', 'Column y0 should be numeric(12,4)');
SELECT col_type_is('temp_node', 'ysur', 'numeric(12,4)', 'Column ysur should be numeric(12,4)');
SELECT col_type_is('temp_node', 'apond', 'numeric(12,4)', 'Column apond should be numeric(12,4)');
SELECT col_type_is('temp_node', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('temp_node', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('temp_node', 'parent', 'varchar(16)', 'Column parent should be varchar(16)');
SELECT col_type_is('temp_node', 'arcposition', 'int2', 'Column arcposition should be int2');
SELECT col_type_is('temp_node', 'fusioned_node', 'text', 'Column fusioned_node should be text');
SELECT col_type_is('temp_node', 'age', 'int4', 'Column age should be int4');
SELECT col_type_is('temp_node', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('temp_node', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('temp_node', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('temp_node', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('temp_node', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
