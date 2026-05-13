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
SELECT has_table('om_mincut_valve_unaccess'::name, 'Table om_mincut_valve_unaccess should exist');

-- Check columns
SELECT columns_are(
    'om_mincut_valve_unaccess',
    ARRAY[
        'id', 'result_id', 'node_id'
    ],
    'Table om_mincut_valve_unaccess should have the correct columns'
);

-- Check column types
SELECT col_type_is('om_mincut_valve_unaccess', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('om_mincut_valve_unaccess', 'result_id', 'int4', 'Column result_id should be int4');
SELECT col_type_is('om_mincut_valve_unaccess', 'node_id', 'int4', 'Column node_id should be int4');

-- Check foreign keys
SELECT has_fk('om_mincut_valve_unaccess', 'Table om_mincut_valve_unaccess should have foreign keys');

SELECT fk_ok('om_mincut_valve_unaccess', 'result_id', 'om_mincut', 'id', 'FK result_id → om_mincut.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
