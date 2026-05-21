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
SELECT has_table('om_visit_event_photo'::name, 'Table om_visit_event_photo should exist');

-- Check columns
SELECT columns_are(
    'om_visit_event_photo',
    ARRAY[
        'id', 'visit_id', 'event_id', 'tstamp', 'value', 'text',
        'compass', 'hash', 'filetype', 'xcoord', 'ycoord', 'fextension'
    ],
    'Table om_visit_event_photo should have the correct columns'
);

-- Check column types
SELECT col_type_is('om_visit_event_photo', 'id', 'int8', 'Column id should be int8');
SELECT col_type_is('om_visit_event_photo', 'visit_id', 'int8', 'Column visit_id should be int8');
SELECT col_type_is('om_visit_event_photo', 'event_id', 'int8', 'Column event_id should be int8');
SELECT col_type_is('om_visit_event_photo', 'tstamp', 'timestamp(6) without time zone', 'Column tstamp should be timestamp(6) without time zone');
SELECT col_type_is('om_visit_event_photo', 'value', 'text', 'Column value should be text');
SELECT col_type_is('om_visit_event_photo', 'text', 'text', 'Column text should be text');
SELECT col_type_is('om_visit_event_photo', 'compass', 'float8', 'Column compass should be float8');
SELECT col_type_is('om_visit_event_photo', 'hash', 'text', 'Column hash should be text');
SELECT col_type_is('om_visit_event_photo', 'filetype', 'text', 'Column filetype should be text');
SELECT col_type_is('om_visit_event_photo', 'xcoord', 'float8', 'Column xcoord should be float8');
SELECT col_type_is('om_visit_event_photo', 'ycoord', 'float8', 'Column ycoord should be float8');
SELECT col_type_is('om_visit_event_photo', 'fextension', 'varchar(16)', 'Column fextension should be varchar(16)');

-- Check foreign keys
SELECT has_fk('om_visit_event_photo', 'Table om_visit_event_photo should have foreign keys');

SELECT fk_ok('om_visit_event_photo', 'visit_id', 'om_visit', 'id', 'FK visit_id → om_visit.id');
SELECT fk_ok('om_visit_event_photo', 'event_id', 'om_visit_event', 'id', 'FK event_id → om_visit_event.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
