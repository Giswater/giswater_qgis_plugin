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
        'id', 'result_id', 'arc_id', 'node_1', 'node_2', 'elevmax1',
        'elevmax2', 'arc_type', 'arccat_id', 'epa_type', 'sector_id', 'state',
        'state_type', 'annotation', 'omzone_id', 'length', 'n', 'expl_id',
        'addparam', 'arcparent', 'q0', 'qmax', 'barrels', 'slope',
        'flag', 'culvert', 'kentry', 'kexit', 'kavg', 'flap',
        'seepage', 'age', 'the_geom', 'created_at', 'created_by', 'updated_at',
        'updated_by'
    ],
    'Table temp_arc should have the correct columns'
);

-- Check column types
SELECT col_type_is('temp_arc', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('temp_arc', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('temp_arc', 'arc_id', 'text', 'Column arc_id should be text');
SELECT col_type_is('temp_arc', 'node_1', 'text', 'Column node_1 should be text');
SELECT col_type_is('temp_arc', 'node_2', 'text', 'Column node_2 should be text');
SELECT col_type_is('temp_arc', 'elevmax1', 'numeric(12,3)', 'Column elevmax1 should be numeric(12,3)');
SELECT col_type_is('temp_arc', 'elevmax2', 'numeric(12,3)', 'Column elevmax2 should be numeric(12,3)');
SELECT col_type_is('temp_arc', 'arc_type', 'varchar(30)', 'Column arc_type should be varchar(30)');
SELECT col_type_is('temp_arc', 'arccat_id', 'varchar(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('temp_arc', 'epa_type', 'varchar(16)', 'Column epa_type should be varchar(16)');
SELECT col_type_is('temp_arc', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('temp_arc', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('temp_arc', 'state_type', 'int2', 'Column state_type should be int2');
SELECT col_type_is('temp_arc', 'annotation', 'varchar(254)', 'Column annotation should be varchar(254)');
SELECT col_type_is('temp_arc', 'omzone_id', 'int4', 'Column omzone_id should be int4');
SELECT col_type_is('temp_arc', 'length', 'numeric(12,3)', 'Column length should be numeric(12,3)');
SELECT col_type_is('temp_arc', 'n', 'numeric(12,3)', 'Column n should be numeric(12,3)');
SELECT col_type_is('temp_arc', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('temp_arc', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('temp_arc', 'arcparent', 'varchar(16)', 'Column arcparent should be varchar(16)');
SELECT col_type_is('temp_arc', 'q0', 'float8', 'Column q0 should be float8');
SELECT col_type_is('temp_arc', 'qmax', 'float8', 'Column qmax should be float8');
SELECT col_type_is('temp_arc', 'barrels', 'int4', 'Column barrels should be int4');
SELECT col_type_is('temp_arc', 'slope', 'float8', 'Column slope should be float8');
SELECT col_type_is('temp_arc', 'flag', 'bool', 'Column flag should be bool');
SELECT col_type_is('temp_arc', 'culvert', 'varchar(10)', 'Column culvert should be varchar(10)');
SELECT col_type_is('temp_arc', 'kentry', 'numeric(12,4)', 'Column kentry should be numeric(12,4)');
SELECT col_type_is('temp_arc', 'kexit', 'numeric(12,4)', 'Column kexit should be numeric(12,4)');
SELECT col_type_is('temp_arc', 'kavg', 'numeric(12,4)', 'Column kavg should be numeric(12,4)');
SELECT col_type_is('temp_arc', 'flap', 'varchar(3)', 'Column flap should be varchar(3)');
SELECT col_type_is('temp_arc', 'seepage', 'numeric(12,4)', 'Column seepage should be numeric(12,4)');
SELECT col_type_is('temp_arc', 'age', 'int4', 'Column age should be int4');
SELECT col_type_is('temp_arc', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');
SELECT col_type_is('temp_arc', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('temp_arc', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('temp_arc', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('temp_arc', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
