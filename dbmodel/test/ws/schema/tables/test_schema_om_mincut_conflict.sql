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
SELECT has_table('om_mincut_conflict'::name, 'Table om_mincut_conflict should exist');

-- Check columns
SELECT columns_are(
    'om_mincut_conflict',
    ARRAY[
        'id', 'mincut_id'
    ],
    'Table om_mincut_conflict should have the correct columns'
);

-- Check column types
SELECT col_type_is('om_mincut_conflict', 'id', 'uuid', 'Column id should be uuid');
SELECT col_type_is('om_mincut_conflict', 'mincut_id', 'int4', 'Column mincut_id should be int4');

-- Check foreign keys
SELECT has_fk('om_mincut_conflict', 'Table om_mincut_conflict should have foreign keys');

SELECT fk_ok('om_mincut_conflict', 'mincut_id', 'om_mincut', 'id', 'FK mincut_id → om_mincut.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
