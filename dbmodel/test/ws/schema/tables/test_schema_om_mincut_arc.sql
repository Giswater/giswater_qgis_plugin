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

-- Check table om_mincut_arc
SELECT has_table('om_mincut_arc'::name, 'Table om_mincut_arc should exist');

-- Check columns
SELECT columns_are(
    'om_mincut_arc',
    ARRAY[
        'id', 'result_id', 'arc_id', 'the_geom', 'minsector_id'
    ],
    'Table om_mincut_arc should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('om_mincut_arc', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('om_mincut_arc', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('om_mincut_arc', 'result_id', 'integer', 'Column result_id should be integer');
SELECT col_type_is('om_mincut_arc', 'arc_id', 'varchar(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('om_mincut_arc', 'the_geom', 'geometry(LineString,25831)', 'Column the_geom should be geometry(LineString,25831)');
SELECT col_type_is('om_mincut_arc', 'minsector_id', 'integer', 'Column minsector_id should be integer');

-- Check unique constraints
SELECT col_is_unique('om_mincut_arc', ARRAY['result_id', 'arc_id'], 'Columns result_id and arc_id should have a unique constraint');

-- Check foreign keys
SELECT has_fk('om_mincut_arc', 'Table om_mincut_arc should have foreign keys');
SELECT fk_ok('om_mincut_arc', 'result_id', 'om_mincut', 'id', 'FK result_id should reference om_mincut.id');

-- Check constraints
SELECT col_not_null('om_mincut_arc', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('om_mincut_arc', 'result_id', 'Column result_id should be NOT NULL');
SELECT col_not_null('om_mincut_arc', 'arc_id', 'Column arc_id should be NOT NULL');

-- Check indexes
SELECT has_index('om_mincut_arc', 'mincut_arc_index', 'Table should have mincut_arc_index on the_geom');

SELECT * FROM finish();

ROLLBACK; 