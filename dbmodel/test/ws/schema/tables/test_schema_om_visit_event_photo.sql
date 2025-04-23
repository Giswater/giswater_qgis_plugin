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

-- Check table om_visit_event_photo
SELECT has_table('om_visit_event_photo'::name, 'Table om_visit_event_photo should exist');

-- Check columns
SELECT columns_are(
    'om_visit_event_photo',
    ARRAY[
        'id', 'visit_id', 'event_id', 'tstamp', 'value', 'text', 'compass', 'hash', 'filetype',
        'xcoord', 'ycoord', 'fextension'
    ],
    'Table om_visit_event_photo should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('om_visit_event_photo', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('om_visit_event_photo', 'id', 'bigint', 'Column id should be bigint');
SELECT col_type_is('om_visit_event_photo', 'visit_id', 'bigint', 'Column visit_id should be bigint');
SELECT col_type_is('om_visit_event_photo', 'event_id', 'bigint', 'Column event_id should be bigint');
SELECT col_type_is('om_visit_event_photo', 'tstamp', 'timestamp(6) without time zone', 'Column tstamp should be timestamp(6)');
SELECT col_type_is('om_visit_event_photo', 'value', 'text', 'Column value should be text');
SELECT col_type_is('om_visit_event_photo', 'text', 'text', 'Column text should be text');
SELECT col_type_is('om_visit_event_photo', 'compass', 'double precision', 'Column compass should be double precision');
SELECT col_type_is('om_visit_event_photo', 'hash', 'text', 'Column hash should be text');
SELECT col_type_is('om_visit_event_photo', 'filetype', 'text', 'Column filetype should be text');
SELECT col_type_is('om_visit_event_photo', 'xcoord', 'double precision', 'Column xcoord should be double precision');
SELECT col_type_is('om_visit_event_photo', 'ycoord', 'double precision', 'Column ycoord should be double precision');
SELECT col_type_is('om_visit_event_photo', 'fextension', 'varchar(16)', 'Column fextension should be varchar(16)');

-- Check default values
SELECT col_default_is('om_visit_event_photo', 'tstamp', 'now()', 'Column tstamp should default to now()');

-- Check foreign keys
SELECT has_fk('om_visit_event_photo', 'Table om_visit_event_photo should have foreign keys');
SELECT fk_ok('om_visit_event_photo', 'visit_id', 'om_visit', 'id', 'FK visit_id should reference om_visit.id');
SELECT fk_ok('om_visit_event_photo', 'event_id', 'om_visit_event', 'id', 'FK event_id should reference om_visit_event.id');

-- Check constraints
SELECT col_not_null('om_visit_event_photo', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('om_visit_event_photo', 'visit_id', 'Column visit_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK; 