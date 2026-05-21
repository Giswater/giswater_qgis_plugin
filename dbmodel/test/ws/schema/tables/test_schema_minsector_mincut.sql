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
SELECT has_table('minsector_mincut'::name, 'Table minsector_mincut should exist');

-- Check columns
SELECT columns_are(
    'minsector_mincut',
    ARRAY[
        'minsector_id', 'mincut_minsector_id'
    ],
    'Table minsector_mincut should have the correct columns'
);

-- Check column types
SELECT col_type_is('minsector_mincut', 'minsector_id', 'int4', 'Column minsector_id should be int4');
SELECT col_type_is('minsector_mincut', 'mincut_minsector_id', 'int4', 'Column mincut_minsector_id should be int4');

-- Check foreign keys
SELECT has_fk('minsector_mincut', 'Table minsector_mincut should have foreign keys');

SELECT fk_ok('minsector_mincut', 'minsector_id', 'minsector', 'minsector_id', 'FK minsector_id → minsector.minsector_id');
SELECT fk_ok('minsector_mincut', 'mincut_minsector_id', 'minsector', 'minsector_id', 'FK mincut_minsector_id → minsector.minsector_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
