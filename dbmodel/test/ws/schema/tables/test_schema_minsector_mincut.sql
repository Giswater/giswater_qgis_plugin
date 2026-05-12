/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/
BEGIN;

SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check table minsector_mincut
SELECT has_table('minsector_mincut'::name, 'Table minsector_mincut should exist');

-- Check columns
SELECT columns_are(
    'minsector_mincut',
    ARRAY[
        'minsector_id', 'mincut_minsector_id'
    ],
    'Table minsector_mincut should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('minsector_mincut', ARRAY['minsector_id', 'mincut_minsector_id'], 'Columns minsector_id and mincut_minsector_id should be primary key');

-- Check column types
SELECT col_type_is('minsector_mincut', 'minsector_id', 'integer', 'Column minsector_id should be integer');
SELECT col_type_is('minsector_mincut', 'mincut_minsector_id', 'integer', 'Column mincut_minsector_id should be integer');

-- Check foreign keys
SELECT has_fk('minsector_mincut', 'Table minsector_mincut should have foreign keys');
SELECT fk_ok('minsector_mincut', 'minsector_id', 'minsector', 'minsector_id', 'FK minsector_mincut_minsector_id_fkey should exist');
SELECT fk_ok('minsector_mincut', 'mincut_minsector_id', 'minsector', 'minsector_id', 'FK minsector_mincut_mincut_minsector_id_fkey should exist');


SELECT * FROM finish();

ROLLBACK;
