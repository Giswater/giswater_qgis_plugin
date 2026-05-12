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

-- Check table om_mincut_valve
SELECT has_table('om_mincut_valve'::name, 'Table om_mincut_valve should exist');

-- Check columns
SELECT columns_are(
    'om_mincut_valve',
    ARRAY[
        'id', 'result_id', 'node_id', 'closed', 'broken', 'unaccess', 'proposed', 'the_geom', 'flag', 'to_arc', 'changestatus'
    ],
    'Table om_mincut_valve should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('om_mincut_valve', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('om_mincut_valve', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('om_mincut_valve', 'result_id', 'integer', 'Column result_id should be integer');
SELECT col_type_is('om_mincut_valve', 'node_id', 'integer', 'Column node_id should be integer');
SELECT col_type_is('om_mincut_valve', 'closed', 'boolean', 'Column closed should be boolean');
SELECT col_type_is('om_mincut_valve', 'broken', 'boolean', 'Column broken should be boolean');
SELECT col_type_is('om_mincut_valve', 'unaccess', 'boolean', 'Column unaccess should be boolean');
SELECT col_type_is('om_mincut_valve', 'proposed', 'boolean', 'Column proposed should be boolean');
SELECT col_type_is('om_mincut_valve', 'the_geom', 'geometry(Point,25831)', 'Column the_geom should be geometry(Point,25831)');
SELECT col_type_is('om_mincut_valve', 'flag', 'boolean', 'Column flag should be boolean');
SELECT col_type_is('om_mincut_valve', 'to_arc', 'integer', 'Column to_arc should be integer');

-- Check unique constraints
SELECT col_is_unique('om_mincut_valve', ARRAY['result_id', 'node_id'], 'Columns result_id and node_id should have a unique constraint');

-- Check foreign keys
SELECT has_fk('om_mincut_valve', 'Table om_mincut_valve should have foreign keys');
SELECT fk_ok('om_mincut_valve', 'result_id', 'om_mincut', 'id', 'FK result_id should reference om_mincut.id');

-- Check constraints
SELECT col_not_null('om_mincut_valve', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('om_mincut_valve', 'result_id', 'Column result_id should be NOT NULL');
SELECT col_not_null('om_mincut_valve', 'node_id', 'Column node_id should be NOT NULL');

-- Check indexes
SELECT has_index('om_mincut_valve', 'mincut_valve_index', 'Table should have mincut_valve_index on the_geom');

SELECT * FROM finish();

ROLLBACK;