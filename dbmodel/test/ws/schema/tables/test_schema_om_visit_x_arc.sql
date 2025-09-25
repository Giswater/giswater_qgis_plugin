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

-- Check table om_visit_x_arc
SELECT has_table('om_visit_x_arc'::name, 'Table om_visit_x_arc should exist');

-- Check columns
SELECT columns_are(
    'om_visit_x_arc',
    ARRAY[
        'id', 'visit_id', 'arc_id', 'is_last', 'arc_uuid'
    ],
    'Table om_visit_x_arc should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('om_visit_x_arc', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('om_visit_x_arc', 'id', 'bigint', 'Column id should be bigint');
SELECT col_type_is('om_visit_x_arc', 'visit_id', 'bigint', 'Column visit_id should be bigint');
SELECT col_type_is('om_visit_x_arc', 'arc_id', 'integer', 'Column arc_id should be integer');
SELECT col_type_is('om_visit_x_arc', 'is_last', 'boolean', 'Column is_last should be boolean');
SELECT col_type_is('om_visit_x_arc', 'arc_uuid', 'uuid', 'Column arc_uuid should be uuid');

-- Check default values
SELECT col_default_is('om_visit_x_arc', 'is_last', 'true', 'Column is_last should default to true');

-- Check unique constraints
SELECT col_is_unique('om_visit_x_arc', ARRAY['arc_id', 'visit_id'], 'Columns arc_id and visit_id should have a unique constraint');

-- Check foreign keys
SELECT has_fk('om_visit_x_arc', 'Table om_visit_x_arc should have foreign keys');
SELECT fk_ok('om_visit_x_arc', 'arc_id', 'arc', 'arc_id', 'FK arc_id should reference arc.arc_id');
SELECT fk_ok('om_visit_x_arc', 'visit_id', 'om_visit', 'id', 'FK visit_id should reference om_visit.id');

-- Check constraints
SELECT col_not_null('om_visit_x_arc', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('om_visit_x_arc', 'visit_id', 'Column visit_id should be NOT NULL');
SELECT col_not_null('om_visit_x_arc', 'arc_id', 'Column arc_id should be NOT NULL');

-- Check triggers
SELECT has_trigger('om_visit_x_arc', 'gw_trg_om_visit', 'Table should have gw_trg_om_visit trigger');

SELECT * FROM finish();

ROLLBACK;