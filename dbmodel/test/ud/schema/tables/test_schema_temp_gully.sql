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
SELECT has_table('temp_gully'::name, 'Table temp_gully should exist');

-- Check columns
SELECT columns_are(
    'temp_gully',
    ARRAY[
        'gully_id', 'gully_type', 'gullycat_id', 'arc_id', 'node_id', 'sector_id',
        'state', 'state_type', 'top_elev', 'units', 'units_placement', 'outlet_type',
        'width', 'length', 'depth', 'method', 'weir_cd', 'orifice_cd',
        'a_param', 'b_param', 'efficiency', 'the_geom'
    ],
    'Table temp_gully should have the correct columns'
);

-- Check column types
SELECT col_type_is('temp_gully', 'gully_id', 'varchar(30)', 'Column gully_id should be varchar(30)');
SELECT col_type_is('temp_gully', 'gully_type', 'varchar(30)', 'Column gully_type should be varchar(30)');
SELECT col_type_is('temp_gully', 'gullycat_id', 'varchar(30)', 'Column gullycat_id should be varchar(30)');
SELECT col_type_is('temp_gully', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('temp_gully', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('temp_gully', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('temp_gully', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('temp_gully', 'state_type', 'int2', 'Column state_type should be int2');
SELECT col_type_is('temp_gully', 'top_elev', 'float8', 'Column top_elev should be float8');
SELECT col_type_is('temp_gully', 'units', 'int4', 'Column units should be int4');
SELECT col_type_is('temp_gully', 'units_placement', 'varchar(16)', 'Column units_placement should be varchar(16)');
SELECT col_type_is('temp_gully', 'outlet_type', 'varchar(30)', 'Column outlet_type should be varchar(30)');
SELECT col_type_is('temp_gully', 'width', 'float8', 'Column width should be float8');
SELECT col_type_is('temp_gully', 'length', 'float8', 'Column length should be float8');
SELECT col_type_is('temp_gully', 'depth', 'float8', 'Column depth should be float8');
SELECT col_type_is('temp_gully', 'method', 'varchar(30)', 'Column method should be varchar(30)');
SELECT col_type_is('temp_gully', 'weir_cd', 'float8', 'Column weir_cd should be float8');
SELECT col_type_is('temp_gully', 'orifice_cd', 'float8', 'Column orifice_cd should be float8');
SELECT col_type_is('temp_gully', 'a_param', 'float8', 'Column a_param should be float8');
SELECT col_type_is('temp_gully', 'b_param', 'float8', 'Column b_param should be float8');
SELECT col_type_is('temp_gully', 'efficiency', 'int4', 'Column efficiency should be int4');
SELECT col_type_is('temp_gully', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
