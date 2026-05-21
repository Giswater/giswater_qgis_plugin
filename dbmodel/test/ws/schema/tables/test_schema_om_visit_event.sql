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
SELECT has_table('om_visit_event'::name, 'Table om_visit_event should exist');

-- Check columns
SELECT columns_are(
    'om_visit_event',
    ARRAY[
        'id', 'event_code', 'visit_id', 'position_id', 'position_value', 'parameter_id',
        'value', 'value1', 'value2', 'geom1', 'geom2', 'geom3',
        'xcoord', 'ycoord', 'compass', 'tstamp', 'text', 'index_val',
        'is_last'
    ],
    'Table om_visit_event should have the correct columns'
);

-- Check column types
SELECT col_type_is('om_visit_event', 'id', 'int8', 'Column id should be int8');
SELECT col_type_is('om_visit_event', 'event_code', 'varchar(16)', 'Column event_code should be varchar(16)');
SELECT col_type_is('om_visit_event', 'visit_id', 'int8', 'Column visit_id should be int8');
SELECT col_type_is('om_visit_event', 'position_id', 'varchar(50)', 'Column position_id should be varchar(50)');
SELECT col_type_is('om_visit_event', 'position_value', 'float8', 'Column position_value should be float8');
SELECT col_type_is('om_visit_event', 'parameter_id', 'varchar(50)', 'Column parameter_id should be varchar(50)');
SELECT col_type_is('om_visit_event', 'value', 'text', 'Column value should be text');
SELECT col_type_is('om_visit_event', 'value1', 'int4', 'Column value1 should be int4');
SELECT col_type_is('om_visit_event', 'value2', 'int4', 'Column value2 should be int4');
SELECT col_type_is('om_visit_event', 'geom1', 'float8', 'Column geom1 should be float8');
SELECT col_type_is('om_visit_event', 'geom2', 'float8', 'Column geom2 should be float8');
SELECT col_type_is('om_visit_event', 'geom3', 'float8', 'Column geom3 should be float8');
SELECT col_type_is('om_visit_event', 'xcoord', 'float8', 'Column xcoord should be float8');
SELECT col_type_is('om_visit_event', 'ycoord', 'float8', 'Column ycoord should be float8');
SELECT col_type_is('om_visit_event', 'compass', 'float8', 'Column compass should be float8');
SELECT col_type_is('om_visit_event', 'tstamp', 'timestamp(6) without time zone', 'Column tstamp should be timestamp(6) without time zone');
SELECT col_type_is('om_visit_event', 'text', 'text', 'Column text should be text');
SELECT col_type_is('om_visit_event', 'index_val', 'int2', 'Column index_val should be int2');
SELECT col_type_is('om_visit_event', 'is_last', 'bool', 'Column is_last should be bool');

-- Check foreign keys
SELECT has_fk('om_visit_event', 'Table om_visit_event should have foreign keys');

SELECT fk_ok('om_visit_event', 'parameter_id', 'config_visit_parameter', 'id', 'FK parameter_id → config_visit_parameter.id');
SELECT fk_ok('om_visit_event', 'visit_id', 'om_visit', 'id', 'FK visit_id → om_visit.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
