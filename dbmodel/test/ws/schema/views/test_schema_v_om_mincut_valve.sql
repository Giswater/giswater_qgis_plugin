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

-- Check view v_om_mincut_valve
SELECT has_view('v_om_mincut_valve'::name, 'View v_om_mincut_valve should exist');

-- Check view columns
SELECT columns_are(
    'v_om_mincut_valve',
    ARRAY[
        'id', 'result_id', 'work_order', 'node_id', 'closed', 'broken',
        'unaccess', 'proposed', 'to_arc', 'the_geom', 'changestatus'
    ],
    'View v_om_mincut_valve should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_om_mincut_valve', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_om_mincut_valve', 'result_id', 'int4', 'Column result_id should be int4');
SELECT col_type_is('v_om_mincut_valve', 'work_order', 'varchar(50)', 'Column work_order should be varchar(50)');
SELECT col_type_is('v_om_mincut_valve', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('v_om_mincut_valve', 'closed', 'bool', 'Column closed should be bool');
SELECT col_type_is('v_om_mincut_valve', 'broken', 'bool', 'Column broken should be bool');
SELECT col_type_is('v_om_mincut_valve', 'unaccess', 'bool', 'Column unaccess should be bool');
SELECT col_type_is('v_om_mincut_valve', 'proposed', 'bool', 'Column proposed should be bool');
SELECT col_type_is('v_om_mincut_valve', 'to_arc', 'int4', 'Column to_arc should be int4');
SELECT col_type_is('v_om_mincut_valve', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('v_om_mincut_valve', 'changestatus', 'bool', 'Column changestatus should be bool');

SELECT * FROM finish();

ROLLBACK;
