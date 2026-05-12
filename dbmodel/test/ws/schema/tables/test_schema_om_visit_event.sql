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

-- Check table om_visit_event
SELECT has_table('om_visit_event'::name, 'Table om_visit_event should exist');

-- Check columns
SELECT columns_are(
    'om_visit_event',
    ARRAY[
        'id', 'event_code', 'visit_id', 'position_id', 'position_value', 'parameter_id', 'value', 'value1',
        'value2', 'geom1', 'geom2', 'geom3', 'xcoord', 'ycoord', 'compass', 'tstamp', 'text', 'index_val', 'is_last'
    ],
    'Table om_visit_event should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('om_visit_event', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('om_visit_event', 'id', 'bigint', 'Column id should be bigint');
SELECT col_type_is('om_visit_event', 'event_code', 'varchar(16)', 'Column event_code should be varchar(16)');
SELECT col_type_is('om_visit_event', 'visit_id', 'bigint', 'Column visit_id should be bigint');
SELECT col_type_is('om_visit_event', 'position_id', 'varchar(50)', 'Column position_id should be varchar(50)');
SELECT col_type_is('om_visit_event', 'position_value', 'double precision', 'Column position_value should be double precision');
SELECT col_type_is('om_visit_event', 'parameter_id', 'varchar(50)', 'Column parameter_id should be varchar(50)');
SELECT col_type_is('om_visit_event', 'value', 'text', 'Column value should be text');
SELECT col_type_is('om_visit_event', 'value1', 'integer', 'Column value1 should be integer');
SELECT col_type_is('om_visit_event', 'value2', 'integer', 'Column value2 should be integer');
SELECT col_type_is('om_visit_event', 'geom1', 'double precision', 'Column geom1 should be double precision');
SELECT col_type_is('om_visit_event', 'geom2', 'double precision', 'Column geom2 should be double precision');
SELECT col_type_is('om_visit_event', 'geom3', 'double precision', 'Column geom3 should be double precision');
SELECT col_type_is('om_visit_event', 'xcoord', 'double precision', 'Column xcoord should be double precision');
SELECT col_type_is('om_visit_event', 'ycoord', 'double precision', 'Column ycoord should be double precision');
SELECT col_type_is('om_visit_event', 'compass', 'double precision', 'Column compass should be double precision');
SELECT col_type_is('om_visit_event', 'tstamp', 'timestamp(6) without time zone', 'Column tstamp should be timestamp(6)');
SELECT col_type_is('om_visit_event', 'text', 'text', 'Column text should be text');
SELECT col_type_is('om_visit_event', 'index_val', 'smallint', 'Column index_val should be smallint');
SELECT col_type_is('om_visit_event', 'is_last', 'boolean', 'Column is_last should be boolean');

-- Check default values
SELECT col_default_is('om_visit_event', 'tstamp', 'now()', 'Column tstamp should default to now()');

-- Check foreign keys
SELECT has_fk('om_visit_event', 'Table om_visit_event should have foreign keys');
SELECT fk_ok('om_visit_event', 'parameter_id', 'config_visit_parameter', 'id', 'FK parameter_id should reference config_visit_parameter.id');
SELECT fk_ok('om_visit_event', 'visit_id', 'om_visit', 'id', 'FK visit_id should reference om_visit.id');

-- Check constraints
SELECT col_not_null('om_visit_event', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('om_visit_event', 'visit_id', 'Column visit_id should be NOT NULL');
SELECT col_not_null('om_visit_event', 'parameter_id', 'Column parameter_id should be NOT NULL');

-- Check triggers
SELECT has_trigger('om_visit_event', 'gw_trg_visit_event_update_xy', 'Table should have gw_trg_visit_event_update_xy trigger');

SELECT * FROM finish();

ROLLBACK; 