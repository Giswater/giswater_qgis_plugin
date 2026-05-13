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
SELECT has_table('temp_arc'::name, 'Table temp_arc should exist');

-- Check columns
SELECT columns_are(
    'temp_arc',
    ARRAY[
        'id', 'result_id', 'arc_id', 'node_1', 'node_2', 'arc_type',
        'arccat_id', 'epa_type', 'sector_id', 'state', 'state_type', 'annotation',
        'diameter', 'roughness', 'length', 'status', 'the_geom', 'expl_id',
        'flw_code', 'minorloss', 'addparam', 'arcparent', 'flag', 'dma_id',
        'presszone_id', 'dqa_id', 'minsector_id', 'age', 'omzone_id', 'family',
        'builtdate'
    ],
    'Table temp_arc should have the correct columns'
);

-- Check column types
SELECT col_type_is('temp_arc', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('temp_arc', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('temp_arc', 'arc_id', 'varchar(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('temp_arc', 'node_1', 'varchar(16)', 'Column node_1 should be varchar(16)');
SELECT col_type_is('temp_arc', 'node_2', 'varchar(16)', 'Column node_2 should be varchar(16)');
SELECT col_type_is('temp_arc', 'arc_type', 'varchar(30)', 'Column arc_type should be varchar(30)');
SELECT col_type_is('temp_arc', 'arccat_id', 'varchar(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('temp_arc', 'epa_type', 'varchar(16)', 'Column epa_type should be varchar(16)');
SELECT col_type_is('temp_arc', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('temp_arc', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('temp_arc', 'state_type', 'int2', 'Column state_type should be int2');
SELECT col_type_is('temp_arc', 'annotation', 'varchar(254)', 'Column annotation should be varchar(254)');
SELECT col_type_is('temp_arc', 'diameter', 'numeric(12,3)', 'Column diameter should be numeric(12,3)');
SELECT col_type_is('temp_arc', 'roughness', 'numeric(12,6)', 'Column roughness should be numeric(12,6)');
SELECT col_type_is('temp_arc', 'length', 'numeric(12,3)', 'Column length should be numeric(12,3)');
SELECT col_type_is('temp_arc', 'status', 'varchar(18)', 'Column status should be varchar(18)');
SELECT col_type_is('temp_arc', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');
SELECT col_type_is('temp_arc', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('temp_arc', 'flw_code', 'varchar(512)', 'Column flw_code should be varchar(512)');
SELECT col_type_is('temp_arc', 'minorloss', 'numeric(12,6)', 'Column minorloss should be numeric(12,6)');
SELECT col_type_is('temp_arc', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('temp_arc', 'arcparent', 'varchar(16)', 'Column arcparent should be varchar(16)');
SELECT col_type_is('temp_arc', 'flag', 'bool', 'Column flag should be bool');
SELECT col_type_is('temp_arc', 'dma_id', 'int4', 'Column dma_id should be int4');
SELECT col_type_is('temp_arc', 'presszone_id', 'int4', 'Column presszone_id should be int4');
SELECT col_type_is('temp_arc', 'dqa_id', 'int4', 'Column dqa_id should be int4');
SELECT col_type_is('temp_arc', 'minsector_id', 'int4', 'Column minsector_id should be int4');
SELECT col_type_is('temp_arc', 'age', 'int4', 'Column age should be int4');
SELECT col_type_is('temp_arc', 'omzone_id', 'int4', 'Column omzone_id should be int4');
SELECT col_type_is('temp_arc', 'family', 'varchar(100)', 'Column family should be varchar(100)');
SELECT col_type_is('temp_arc', 'builtdate', 'date', 'Column builtdate should be date');

-- Finish
SELECT * FROM finish();

ROLLBACK;
