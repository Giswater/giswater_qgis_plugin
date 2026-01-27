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

-- Check table temp_arc
SELECT has_table('temp_arc'::name, 'Table temp_arc should exist');

-- Check columns
SELECT columns_are(
    'temp_arc',
    ARRAY[
        'id', 'result_id', 'arc_id', 'node_1', 'node_2', 'arc_type', 'arccat_id', 'epa_type',
        'sector_id', 'state', 'state_type', 'annotation', 'diameter', 'roughness', 'length',
        'status', 'the_geom', 'expl_id', 'flw_code', 'minorloss', 'addparam', 'arcparent',
        'flag', 'dma_id', 'presszone_id', 'dqa_id', 'minsector_id', 'age', 'omzone_id', 'family', 'builtdate'
    ],
    'Table temp_arc should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('temp_arc', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('temp_arc', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('temp_arc', 'result_id', 'character varying(30)', 'Column result_id should be character varying(30)');
SELECT col_type_is('temp_arc', 'arc_id', 'character varying(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('temp_arc', 'node_1', 'character varying(16)', 'Column node_1 should be varchar(16)');
SELECT col_type_is('temp_arc', 'node_2', 'character varying(16)', 'Column node_2 should be varchar(16)');
SELECT col_type_is('temp_arc', 'arc_type', 'character varying(30)', 'Column arc_type should be character varying(30)');
SELECT col_type_is('temp_arc', 'arccat_id', 'character varying(30)', 'Column arccat_id should be character varying(30)');
SELECT col_type_is('temp_arc', 'epa_type', 'character varying(16)', 'Column epa_type should be character varying(16)');
SELECT col_type_is('temp_arc', 'sector_id', 'integer', 'Column sector_id should be integer');
SELECT col_type_is('temp_arc', 'state', 'smallint', 'Column state should be smallint');
SELECT col_type_is('temp_arc', 'state_type', 'smallint', 'Column state_type should be smallint');
SELECT col_type_is('temp_arc', 'annotation', 'character varying(254)', 'Column annotation should be character varying(254)');
SELECT col_type_is('temp_arc', 'diameter', 'numeric(12,3)', 'Column diameter should be numeric(12,3)');
SELECT col_type_is('temp_arc', 'roughness', 'numeric(12,6)', 'Column roughness should be numeric(12,6)');
SELECT col_type_is('temp_arc', 'length', 'numeric(12,3)', 'Column length should be numeric(12,3)');
SELECT col_type_is('temp_arc', 'status', 'character varying(18)', 'Column status should be character varying(18)');
SELECT col_type_is('temp_arc', 'the_geom', 'geometry(LineString,25831)', 'Column the_geom should be geometry(LineString,25831)');
SELECT col_type_is('temp_arc', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('temp_arc', 'flw_code', 'character varying(512)', 'Column flw_code should be character varying(512)');
SELECT col_type_is('temp_arc', 'minorloss', 'numeric(12,6)', 'Column minorloss should be numeric(12,6)');
SELECT col_type_is('temp_arc', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('temp_arc', 'arcparent', 'character varying(16)', 'Column arcparent should be varchar(16)');
SELECT col_type_is('temp_arc', 'flag', 'boolean', 'Column flag should be boolean');
SELECT col_type_is('temp_arc', 'dma_id', 'integer', 'Column dma_id should be integer');
SELECT col_type_is('temp_arc', 'presszone_id', 'integer', 'Column presszone_id should be integer');
SELECT col_type_is('temp_arc', 'dqa_id', 'integer', 'Column dqa_id should be integer');
SELECT col_type_is('temp_arc', 'minsector_id', 'integer', 'Column minsector_id should be integer');
SELECT col_type_is('temp_arc', 'age', 'integer', 'Column age should be integer');
SELECT col_type_is('temp_arc', 'omzone_id', 'integer', 'Column omzone_id should be integer');
SELECT col_type_is('temp_arc', 'family', 'varchar(100)', 'Column family should be varchar(100)');
SELECT col_type_is('temp_arc', 'builtdate', 'date', 'Column builtdate should be date');

-- Check default values
SELECT col_has_default('temp_arc', 'id', 'Column id should have a default value');

-- Check indexes
SELECT has_index('temp_arc', 'temp_arc_arc_id', 'Index temp_arc_arc_id should exist');
SELECT has_index('temp_arc', 'temp_arc_arc_type', 'Index temp_arc_arc_type should exist');
SELECT has_index('temp_arc', 'temp_arc_epa_type', 'Index temp_arc_epa_type should exist');
SELECT has_index('temp_arc', 'temp_arc_index', 'Index temp_arc_index should exist');
SELECT has_index('temp_arc', 'temp_arc_node_1_type', 'Index temp_arc_node_1_type should exist');
SELECT has_index('temp_arc', 'temp_arc_node_2_type', 'Index temp_arc_node_2_type should exist');

SELECT * FROM finish();

ROLLBACK;