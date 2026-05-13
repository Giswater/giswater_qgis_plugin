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

-- Check view ve_visit_node_singlevent
SELECT has_view('ve_visit_node_singlevent'::name, 'View ve_visit_node_singlevent should exist');

-- Check view columns
SELECT columns_are(
    've_visit_node_singlevent',
    ARRAY[
        'visit_id', 'node_id', 'visitcat_id', 'ext_code', 'startdate', 'enddate',
        'user_name', 'webclient_id', 'expl_id', 'the_geom', 'descript', 'is_done',
        'class_id', 'status', 'event_code', 'position_id', 'position_value', 'parameter_id',
        'value', 'value1', 'value2', 'geom1', 'geom2', 'geom3',
        'xcoord', 'ycoord', 'compass', 'tstamp', 'text', 'index_val',
        'is_last'
    ],
    'View ve_visit_node_singlevent should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_visit_node_singlevent', 'visit_id', 'int8', 'Column visit_id should be int8');
SELECT col_type_is('ve_visit_node_singlevent', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('ve_visit_node_singlevent', 'visitcat_id', 'int4', 'Column visitcat_id should be int4');
SELECT col_type_is('ve_visit_node_singlevent', 'ext_code', 'varchar(30)', 'Column ext_code should be varchar(30)');
SELECT col_type_is('ve_visit_node_singlevent', 'startdate', 'timestamp without time zone', 'Column startdate should be timestamp without time zone');
SELECT col_type_is('ve_visit_node_singlevent', 'enddate', 'timestamp without time zone', 'Column enddate should be timestamp without time zone');
SELECT col_type_is('ve_visit_node_singlevent', 'user_name', 'varchar(50)', 'Column user_name should be varchar(50)');
SELECT col_type_is('ve_visit_node_singlevent', 'webclient_id', 'varchar(50)', 'Column webclient_id should be varchar(50)');
SELECT col_type_is('ve_visit_node_singlevent', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('ve_visit_node_singlevent', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('ve_visit_node_singlevent', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('ve_visit_node_singlevent', 'is_done', 'bool', 'Column is_done should be bool');
SELECT col_type_is('ve_visit_node_singlevent', 'class_id', 'int4', 'Column class_id should be int4');
SELECT col_type_is('ve_visit_node_singlevent', 'status', 'int4', 'Column status should be int4');
SELECT col_type_is('ve_visit_node_singlevent', 'event_code', 'varchar(16)', 'Column event_code should be varchar(16)');
SELECT col_type_is('ve_visit_node_singlevent', 'position_id', 'varchar(50)', 'Column position_id should be varchar(50)');
SELECT col_type_is('ve_visit_node_singlevent', 'position_value', 'float8', 'Column position_value should be float8');
SELECT col_type_is('ve_visit_node_singlevent', 'parameter_id', 'varchar(50)', 'Column parameter_id should be varchar(50)');
SELECT col_type_is('ve_visit_node_singlevent', 'value', 'text', 'Column value should be text');
SELECT col_type_is('ve_visit_node_singlevent', 'value1', 'int4', 'Column value1 should be int4');
SELECT col_type_is('ve_visit_node_singlevent', 'value2', 'int4', 'Column value2 should be int4');
SELECT col_type_is('ve_visit_node_singlevent', 'geom1', 'float8', 'Column geom1 should be float8');
SELECT col_type_is('ve_visit_node_singlevent', 'geom2', 'float8', 'Column geom2 should be float8');
SELECT col_type_is('ve_visit_node_singlevent', 'geom3', 'float8', 'Column geom3 should be float8');
SELECT col_type_is('ve_visit_node_singlevent', 'xcoord', 'float8', 'Column xcoord should be float8');
SELECT col_type_is('ve_visit_node_singlevent', 'ycoord', 'float8', 'Column ycoord should be float8');
SELECT col_type_is('ve_visit_node_singlevent', 'compass', 'float8', 'Column compass should be float8');
SELECT col_type_is('ve_visit_node_singlevent', 'tstamp', 'timestamp(6) without time zone', 'Column tstamp should be timestamp(6) without time zone');
SELECT col_type_is('ve_visit_node_singlevent', 'text', 'text', 'Column text should be text');
SELECT col_type_is('ve_visit_node_singlevent', 'index_val', 'int2', 'Column index_val should be int2');
SELECT col_type_is('ve_visit_node_singlevent', 'is_last', 'bool', 'Column is_last should be bool');

SELECT * FROM finish();

ROLLBACK;
