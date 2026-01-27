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

-- Check table temp_node
SELECT has_table('temp_node'::name, 'Table temp_node should exist');

-- Check columns
SELECT columns_are(
    'temp_node',
    ARRAY[
        'id', 'result_id', 'node_id', 'top_elev', 'elev', 'node_type', 'nodecat_id', 'epa_type',
        'sector_id', 'state', 'state_type', 'annotation', 'demand', 'the_geom', 'expl_id',
        'pattern_id', 'addparam', 'nodeparent', 'arcposition', 'dma_id', 'presszone_id',
        'dqa_id', 'minsector_id', 'age', 'omzone_id', 'family', 'builtdate'
    ],
    'Table temp_node should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('temp_node', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('temp_node', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('temp_node', 'result_id', 'character varying(30)', 'Column result_id should be character varying(30)');
SELECT col_type_is('temp_node', 'node_id', 'character varying(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('temp_node', 'top_elev', 'numeric(12,3)', 'Column top_elev should be numeric(12,3)');
SELECT col_type_is('temp_node', 'elev', 'numeric(12,3)', 'Column elev should be numeric(12,3)');
SELECT col_type_is('temp_node', 'node_type', 'character varying(30)', 'Column node_type should be character varying(30)');
SELECT col_type_is('temp_node', 'nodecat_id', 'character varying(30)', 'Column nodecat_id should be character varying(30)');
SELECT col_type_is('temp_node', 'epa_type', 'character varying(16)', 'Column epa_type should be character varying(16)');
SELECT col_type_is('temp_node', 'sector_id', 'integer', 'Column sector_id should be integer');
SELECT col_type_is('temp_node', 'state', 'smallint', 'Column state should be smallint');
SELECT col_type_is('temp_node', 'state_type', 'smallint', 'Column state_type should be smallint');
SELECT col_type_is('temp_node', 'annotation', 'character varying(254)', 'Column annotation should be character varying(254)');
SELECT col_type_is('temp_node', 'demand', 'double precision', 'Column demand should be double precision');
SELECT col_type_is('temp_node', 'the_geom', 'geometry(Point,25831)', 'Column the_geom should be geometry(Point,25831)');
SELECT col_type_is('temp_node', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('temp_node', 'pattern_id', 'character varying(16)', 'Column pattern_id should be character varying(16)');
SELECT col_type_is('temp_node', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('temp_node', 'nodeparent', 'character varying(16)', 'Column nodeparent should be varchar(16)');
SELECT col_type_is('temp_node', 'arcposition', 'smallint', 'Column arcposition should be smallint');
SELECT col_type_is('temp_node', 'dma_id', 'integer', 'Column dma_id should be integer');
SELECT col_type_is('temp_node', 'presszone_id', 'integer', 'Column presszone_id should be integer');
SELECT col_type_is('temp_node', 'dqa_id', 'integer', 'Column dqa_id should be integer');
SELECT col_type_is('temp_node', 'minsector_id', 'integer', 'Column minsector_id should be integer');
SELECT col_type_is('temp_node', 'age', 'integer', 'Column age should be integer');
SELECT col_type_is('temp_node', 'omzone_id', 'integer', 'Column omzone_id should be integer');
SELECT col_type_is('temp_node', 'family', 'varchar(100)', 'Column family should be varchar(100)');
SELECT col_type_is('temp_node', 'builtdate', 'date', 'Column builtdate should be date');

-- Check default values
SELECT col_has_default('temp_node', 'id', 'Column id should have a default value');

-- Check indexes
SELECT has_index('temp_node', 'temp_node_epa_type', 'Index temp_node_epa_type should exist');
SELECT has_index('temp_node', 'temp_node_index', 'Index temp_node_index should exist');
SELECT has_index('temp_node', 'temp_node_node_id', 'Index temp_node_node_id should exist');
SELECT has_index('temp_node', 'temp_node_node_type', 'Index temp_node_node_type should exist');
SELECT has_index('temp_node', 'temp_node_nodeparent', 'Index temp_node_nodeparent should exist');

SELECT * FROM finish();

ROLLBACK;