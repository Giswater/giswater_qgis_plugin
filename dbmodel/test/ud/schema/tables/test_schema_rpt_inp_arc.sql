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
SELECT has_table('rpt_inp_arc'::name, 'Table rpt_inp_arc should exist');

-- Check columns
SELECT columns_are(
    'rpt_inp_arc',
    ARRAY[
        'id', 'result_id', 'arc_id', 'node_1', 'node_2', 'elevmax1',
        'elevmax2', 'arc_type', 'arccat_id', 'epa_type', 'sector_id', 'state',
        'state_type', 'annotation', 'length', 'n', 'the_geom', 'expl_id',
        'addparam', 'arcparent', 'q0', 'qmax', 'barrels', 'slope',
        'culvert', 'kentry', 'kexit', 'kavg', 'flap', 'seepage',
        'age'
    ],
    'Table rpt_inp_arc should have the correct columns'
);

-- Check column types
SELECT col_type_is('rpt_inp_arc', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('rpt_inp_arc', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('rpt_inp_arc', 'arc_id', 'varchar(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('rpt_inp_arc', 'node_1', 'varchar(16)', 'Column node_1 should be varchar(16)');
SELECT col_type_is('rpt_inp_arc', 'node_2', 'varchar(16)', 'Column node_2 should be varchar(16)');
SELECT col_type_is('rpt_inp_arc', 'elevmax1', 'numeric(12,3)', 'Column elevmax1 should be numeric(12,3)');
SELECT col_type_is('rpt_inp_arc', 'elevmax2', 'numeric(12,3)', 'Column elevmax2 should be numeric(12,3)');
SELECT col_type_is('rpt_inp_arc', 'arc_type', 'varchar(30)', 'Column arc_type should be varchar(30)');
SELECT col_type_is('rpt_inp_arc', 'arccat_id', 'varchar(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('rpt_inp_arc', 'epa_type', 'varchar(16)', 'Column epa_type should be varchar(16)');
SELECT col_type_is('rpt_inp_arc', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('rpt_inp_arc', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('rpt_inp_arc', 'state_type', 'int2', 'Column state_type should be int2');
SELECT col_type_is('rpt_inp_arc', 'annotation', 'varchar(254)', 'Column annotation should be varchar(254)');
SELECT col_type_is('rpt_inp_arc', 'length', 'numeric(12,3)', 'Column length should be numeric(12,3)');
SELECT col_type_is('rpt_inp_arc', 'n', 'numeric(12,3)', 'Column n should be numeric(12,3)');
SELECT col_type_is('rpt_inp_arc', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');
SELECT col_type_is('rpt_inp_arc', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('rpt_inp_arc', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('rpt_inp_arc', 'arcparent', 'varchar(16)', 'Column arcparent should be varchar(16)');
SELECT col_type_is('rpt_inp_arc', 'q0', 'float8', 'Column q0 should be float8');
SELECT col_type_is('rpt_inp_arc', 'qmax', 'float8', 'Column qmax should be float8');
SELECT col_type_is('rpt_inp_arc', 'barrels', 'int4', 'Column barrels should be int4');
SELECT col_type_is('rpt_inp_arc', 'slope', 'float8', 'Column slope should be float8');
SELECT col_type_is('rpt_inp_arc', 'culvert', 'varchar(10)', 'Column culvert should be varchar(10)');
SELECT col_type_is('rpt_inp_arc', 'kentry', 'numeric(12,4)', 'Column kentry should be numeric(12,4)');
SELECT col_type_is('rpt_inp_arc', 'kexit', 'numeric(12,4)', 'Column kexit should be numeric(12,4)');
SELECT col_type_is('rpt_inp_arc', 'kavg', 'numeric(12,4)', 'Column kavg should be numeric(12,4)');
SELECT col_type_is('rpt_inp_arc', 'flap', 'varchar(3)', 'Column flap should be varchar(3)');
SELECT col_type_is('rpt_inp_arc', 'seepage', 'numeric(12,4)', 'Column seepage should be numeric(12,4)');
SELECT col_type_is('rpt_inp_arc', 'age', 'int4', 'Column age should be int4');

-- Check foreign keys
SELECT has_fk('rpt_inp_arc', 'Table rpt_inp_arc should have foreign keys');

SELECT fk_ok('rpt_inp_arc', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id → rpt_cat_result.result_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
