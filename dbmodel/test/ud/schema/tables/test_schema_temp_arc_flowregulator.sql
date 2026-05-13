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
SELECT has_table('temp_arc_flowregulator'::name, 'Table temp_arc_flowregulator should exist');

-- Check columns
SELECT columns_are(
    'temp_arc_flowregulator',
    ARRAY[
        'arc_id', 'type', 'weir_type', 'offsetval', 'cd', 'ec',
        'cd2', 'flap', 'geom1', 'geom2', 'geom3', 'geom4',
        'surcharge', 'road_width', 'road_surf', 'coef_curve', 'curve_id', 'status',
        'startup', 'shutoff', 'ori_type', 'orate', 'shape', 'close_time',
        'outlet_type', 'cd1'
    ],
    'Table temp_arc_flowregulator should have the correct columns'
);

-- Check column types
SELECT col_type_is('temp_arc_flowregulator', 'arc_id', 'varchar(30)', 'Column arc_id should be varchar(30)');
SELECT col_type_is('temp_arc_flowregulator', 'type', 'varchar(18)', 'Column type should be varchar(18)');
SELECT col_type_is('temp_arc_flowregulator', 'weir_type', 'varchar(18)', 'Column weir_type should be varchar(18)');
SELECT col_type_is('temp_arc_flowregulator', 'offsetval', 'numeric(12,4)', 'Column offsetval should be numeric(12,4)');
SELECT col_type_is('temp_arc_flowregulator', 'cd', 'numeric(12,4)', 'Column cd should be numeric(12,4)');
SELECT col_type_is('temp_arc_flowregulator', 'ec', 'numeric(12,4)', 'Column ec should be numeric(12,4)');
SELECT col_type_is('temp_arc_flowregulator', 'cd2', 'numeric(12,4)', 'Column cd2 should be numeric(12,4)');
SELECT col_type_is('temp_arc_flowregulator', 'flap', 'varchar(3)', 'Column flap should be varchar(3)');
SELECT col_type_is('temp_arc_flowregulator', 'geom1', 'numeric(12,4)', 'Column geom1 should be numeric(12,4)');
SELECT col_type_is('temp_arc_flowregulator', 'geom2', 'numeric(12,4)', 'Column geom2 should be numeric(12,4)');
SELECT col_type_is('temp_arc_flowregulator', 'geom3', 'numeric(12,4)', 'Column geom3 should be numeric(12,4)');
SELECT col_type_is('temp_arc_flowregulator', 'geom4', 'numeric(12,4)', 'Column geom4 should be numeric(12,4)');
SELECT col_type_is('temp_arc_flowregulator', 'surcharge', 'varchar(3)', 'Column surcharge should be varchar(3)');
SELECT col_type_is('temp_arc_flowregulator', 'road_width', 'float8', 'Column road_width should be float8');
SELECT col_type_is('temp_arc_flowregulator', 'road_surf', 'varchar(16)', 'Column road_surf should be varchar(16)');
SELECT col_type_is('temp_arc_flowregulator', 'coef_curve', 'float8', 'Column coef_curve should be float8');
SELECT col_type_is('temp_arc_flowregulator', 'curve_id', 'varchar(16)', 'Column curve_id should be varchar(16)');
SELECT col_type_is('temp_arc_flowregulator', 'status', 'varchar(3)', 'Column status should be varchar(3)');
SELECT col_type_is('temp_arc_flowregulator', 'startup', 'numeric(12,4)', 'Column startup should be numeric(12,4)');
SELECT col_type_is('temp_arc_flowregulator', 'shutoff', 'numeric(12,4)', 'Column shutoff should be numeric(12,4)');
SELECT col_type_is('temp_arc_flowregulator', 'ori_type', 'varchar(18)', 'Column ori_type should be varchar(18)');
SELECT col_type_is('temp_arc_flowregulator', 'orate', 'numeric(12,4)', 'Column orate should be numeric(12,4)');
SELECT col_type_is('temp_arc_flowregulator', 'shape', 'varchar(18)', 'Column shape should be varchar(18)');
SELECT col_type_is('temp_arc_flowregulator', 'close_time', 'int4', 'Column close_time should be int4');
SELECT col_type_is('temp_arc_flowregulator', 'outlet_type', 'varchar(16)', 'Column outlet_type should be varchar(16)');
SELECT col_type_is('temp_arc_flowregulator', 'cd1', 'numeric(12,4)', 'Column cd1 should be numeric(12,4)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
