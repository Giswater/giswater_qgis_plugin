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

-- Check table om_mincut_hydrometer
SELECT has_table('om_mincut_hydrometer'::name, 'Table om_mincut_hydrometer should exist');

-- Check columns
SELECT columns_are(
    'om_mincut_hydrometer',
    ARRAY[
        'id', 'result_id', 'hydrometer_id'
    ],
    'Table om_mincut_hydrometer should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('om_mincut_hydrometer', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('om_mincut_hydrometer', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('om_mincut_hydrometer', 'result_id', 'integer', 'Column result_id should be integer');
SELECT col_type_is('om_mincut_hydrometer', 'hydrometer_id', 'integer', 'Column hydrometer_id should be integer');

-- Check unique constraints
SELECT col_is_unique('om_mincut_hydrometer', ARRAY['result_id', 'hydrometer_id'], 'Columns result_id and hydrometer_id should have a unique constraint');

-- Check foreign keys
SELECT has_fk('om_mincut_hydrometer', 'Table om_mincut_hydrometer should have foreign keys');
SELECT fk_ok('om_mincut_hydrometer', 'result_id', 'om_mincut', 'id', 'FK result_id should reference om_mincut.id');

-- Check constraints
SELECT col_not_null('om_mincut_hydrometer', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('om_mincut_hydrometer', 'result_id', 'Column result_id should be NOT NULL');
SELECT col_not_null('om_mincut_hydrometer', 'hydrometer_id', 'Column hydrometer_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK; 