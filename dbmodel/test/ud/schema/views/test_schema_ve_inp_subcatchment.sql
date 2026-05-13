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

-- Check view ve_inp_subcatchment
SELECT has_view('ve_inp_subcatchment'::name, 'View ve_inp_subcatchment should exist');

-- Check view columns
SELECT columns_are(
    've_inp_subcatchment',
    ARRAY[
        'hydrology_id', 'subc_id', 'sector_id', 'minelev', 'outlet_id', 'rg_id',
        'area', 'imperv', 'width', 'slope', 'clength', 'snow_id',
        'nimp', 'nperv', 'simp', 'sperv', 'zero', 'routeto',
        'rted', 'maxrate', 'minrate', 'decay', 'drytime', 'maxinfil',
        'suction', 'conduct', 'initdef', 'curveno', 'conduct_2', 'drytime_2',
        'nperv_pattern_id', 'dstore_pattern_id', 'infil_pattern_id', 'muni_id', 'descript', 'the_geom'
    ],
    'View ve_inp_subcatchment should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_inp_subcatchment', 'hydrology_id', 'int4', 'Column hydrology_id should be int4');
SELECT col_type_is('ve_inp_subcatchment', 'subc_id', 'varchar(16)', 'Column subc_id should be varchar(16)');
SELECT col_type_is('ve_inp_subcatchment', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('ve_inp_subcatchment', 'minelev', 'float8', 'Column minelev should be float8');
SELECT col_type_is('ve_inp_subcatchment', 'outlet_id', 'varchar(100)', 'Column outlet_id should be varchar(100)');
SELECT col_type_is('ve_inp_subcatchment', 'rg_id', 'varchar(16)', 'Column rg_id should be varchar(16)');
SELECT col_type_is('ve_inp_subcatchment', 'area', 'numeric(16,6)', 'Column area should be numeric(16,6)');
SELECT col_type_is('ve_inp_subcatchment', 'imperv', 'numeric(12,4)', 'Column imperv should be numeric(12,4)');
SELECT col_type_is('ve_inp_subcatchment', 'width', 'numeric(12,4)', 'Column width should be numeric(12,4)');
SELECT col_type_is('ve_inp_subcatchment', 'slope', 'numeric(12,4)', 'Column slope should be numeric(12,4)');
SELECT col_type_is('ve_inp_subcatchment', 'clength', 'numeric(12,4)', 'Column clength should be numeric(12,4)');
SELECT col_type_is('ve_inp_subcatchment', 'snow_id', 'varchar(16)', 'Column snow_id should be varchar(16)');
SELECT col_type_is('ve_inp_subcatchment', 'nimp', 'numeric(12,4)', 'Column nimp should be numeric(12,4)');
SELECT col_type_is('ve_inp_subcatchment', 'nperv', 'numeric(12,4)', 'Column nperv should be numeric(12,4)');
SELECT col_type_is('ve_inp_subcatchment', 'simp', 'numeric(12,4)', 'Column simp should be numeric(12,4)');
SELECT col_type_is('ve_inp_subcatchment', 'sperv', 'numeric(12,4)', 'Column sperv should be numeric(12,4)');
SELECT col_type_is('ve_inp_subcatchment', 'zero', 'numeric(12,4)', 'Column zero should be numeric(12,4)');
SELECT col_type_is('ve_inp_subcatchment', 'routeto', 'varchar(20)', 'Column routeto should be varchar(20)');
SELECT col_type_is('ve_inp_subcatchment', 'rted', 'numeric(12,4)', 'Column rted should be numeric(12,4)');
SELECT col_type_is('ve_inp_subcatchment', 'maxrate', 'numeric(12,4)', 'Column maxrate should be numeric(12,4)');
SELECT col_type_is('ve_inp_subcatchment', 'minrate', 'numeric(12,4)', 'Column minrate should be numeric(12,4)');
SELECT col_type_is('ve_inp_subcatchment', 'decay', 'numeric(12,4)', 'Column decay should be numeric(12,4)');
SELECT col_type_is('ve_inp_subcatchment', 'drytime', 'numeric(12,4)', 'Column drytime should be numeric(12,4)');
SELECT col_type_is('ve_inp_subcatchment', 'maxinfil', 'numeric(12,4)', 'Column maxinfil should be numeric(12,4)');
SELECT col_type_is('ve_inp_subcatchment', 'suction', 'numeric(12,4)', 'Column suction should be numeric(12,4)');
SELECT col_type_is('ve_inp_subcatchment', 'conduct', 'numeric(12,4)', 'Column conduct should be numeric(12,4)');
SELECT col_type_is('ve_inp_subcatchment', 'initdef', 'numeric(12,4)', 'Column initdef should be numeric(12,4)');
SELECT col_type_is('ve_inp_subcatchment', 'curveno', 'numeric(12,4)', 'Column curveno should be numeric(12,4)');
SELECT col_type_is('ve_inp_subcatchment', 'conduct_2', 'numeric(12,4)', 'Column conduct_2 should be numeric(12,4)');
SELECT col_type_is('ve_inp_subcatchment', 'drytime_2', 'numeric(12,4)', 'Column drytime_2 should be numeric(12,4)');
SELECT col_type_is('ve_inp_subcatchment', 'nperv_pattern_id', 'varchar(16)', 'Column nperv_pattern_id should be varchar(16)');
SELECT col_type_is('ve_inp_subcatchment', 'dstore_pattern_id', 'varchar(16)', 'Column dstore_pattern_id should be varchar(16)');
SELECT col_type_is('ve_inp_subcatchment', 'infil_pattern_id', 'varchar(16)', 'Column infil_pattern_id should be varchar(16)');
SELECT col_type_is('ve_inp_subcatchment', 'muni_id', 'int4', 'Column muni_id should be int4');
SELECT col_type_is('ve_inp_subcatchment', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('ve_inp_subcatchment', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
