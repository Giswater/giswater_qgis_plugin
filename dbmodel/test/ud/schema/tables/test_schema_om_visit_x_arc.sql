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
SELECT has_table('om_visit_x_arc'::name, 'Table om_visit_x_arc should exist');

-- Check columns
SELECT columns_are(
    'om_visit_x_arc',
    ARRAY[
        'id', 'visit_id', 'arc_id', 'is_last', 'arc_uuid'
    ],
    'Table om_visit_x_arc should have the correct columns'
);

-- Check column types
SELECT col_type_is('om_visit_x_arc', 'id', 'int8', 'Column id should be int8');
SELECT col_type_is('om_visit_x_arc', 'visit_id', 'int8', 'Column visit_id should be int8');
SELECT col_type_is('om_visit_x_arc', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('om_visit_x_arc', 'is_last', 'bool', 'Column is_last should be bool');
SELECT col_type_is('om_visit_x_arc', 'arc_uuid', 'uuid', 'Column arc_uuid should be uuid');

-- Check foreign keys
SELECT has_fk('om_visit_x_arc', 'Table om_visit_x_arc should have foreign keys');

SELECT fk_ok('om_visit_x_arc', 'visit_id', 'om_visit', 'id', 'FK visit_id → om_visit.id');
SELECT fk_ok('om_visit_x_arc', 'arc_id', 'arc', 'arc_id', 'FK arc_id → arc.arc_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
