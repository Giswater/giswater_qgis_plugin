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
        'id', 'result_id', 'node_id', 'top_elev', 'elev', 'node_type',
        'nodecat_id', 'epa_type', 'sector_id', 'state', 'state_type', 'annotation',
        'demand', 'the_geom', 'expl_id', 'pattern_id', 'addparam', 'nodeparent',
        'arcposition', 'dma_id', 'presszone_id', 'dqa_id', 'minsector_id', 'age',
        'omzone_id', 'family', 'builtdate'
    ],
    'Table temp_node should have the correct columns'
);

-- Check column types
SELECT col_type_is('temp_node', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('temp_node', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('temp_node', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('temp_node', 'top_elev', 'numeric(12,3)', 'Column top_elev should be numeric(12,3)');
SELECT col_type_is('temp_node', 'elev', 'numeric(12,3)', 'Column elev should be numeric(12,3)');
SELECT col_type_is('temp_node', 'node_type', 'varchar(30)', 'Column node_type should be varchar(30)');
SELECT col_type_is('temp_node', 'nodecat_id', 'varchar(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('temp_node', 'epa_type', 'varchar(16)', 'Column epa_type should be varchar(16)');
SELECT col_type_is('temp_node', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('temp_node', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('temp_node', 'state_type', 'int2', 'Column state_type should be int2');
SELECT col_type_is('temp_node', 'annotation', 'varchar(254)', 'Column annotation should be varchar(254)');
SELECT col_type_is('temp_node', 'demand', 'float8', 'Column demand should be float8');
SELECT col_type_is('temp_node', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('temp_node', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('temp_node', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('temp_node', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('temp_node', 'nodeparent', 'varchar(16)', 'Column nodeparent should be varchar(16)');
SELECT col_type_is('temp_node', 'arcposition', 'int2', 'Column arcposition should be int2');
SELECT col_type_is('temp_node', 'dma_id', 'int4', 'Column dma_id should be int4');
SELECT col_type_is('temp_node', 'presszone_id', 'int4', 'Column presszone_id should be int4');
SELECT col_type_is('temp_node', 'dqa_id', 'int4', 'Column dqa_id should be int4');
SELECT col_type_is('temp_node', 'minsector_id', 'int4', 'Column minsector_id should be int4');
SELECT col_type_is('temp_node', 'age', 'int4', 'Column age should be int4');
SELECT col_type_is('temp_node', 'omzone_id', 'int4', 'Column omzone_id should be int4');
SELECT col_type_is('temp_node', 'family', 'varchar(100)', 'Column family should be varchar(100)');
SELECT col_type_is('temp_node', 'builtdate', 'date', 'Column builtdate should be date');

-- Finish
SELECT * FROM finish();

ROLLBACK;
