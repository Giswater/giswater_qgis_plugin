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

-- Check table om_mincut_conflict
SELECT has_table('om_mincut_conflict'::name, 'Table om_mincut_conflict should exist');

-- Check columns
SELECT columns_are(
    'om_mincut_conflict',
    ARRAY[
        'id', 'mincut_id'
    ],
    'Table om_mincut_conflict should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('om_mincut_conflict', ARRAY['id','mincut_id'], 'Columns id, mincut_id should be primary key');

-- Check column types and defaults
SELECT col_type_is('om_mincut_conflict', 'id', 'uuid', 'Column id should be uuid');
SELECT col_has_default('om_mincut_conflict', 'id', 'Column id should have a default value');
SELECT col_type_is('om_mincut_conflict', 'mincut_id', 'integer', 'Column mincut_id should be int4');

-- Check foreign key
SELECT has_fk('om_mincut_conflict', 'Table om_mincut_conflict should have foreign keys');
SELECT fk_ok(
  'om_mincut_conflict', 
  'mincut_id', 
  'om_mincut', 
  'id', 
  'FK mincut_id should reference om_mincut.id'
);

-- Check index
SELECT has_index('om_mincut_conflict', 'om_mincut_conflict_mincut_id_idx', ARRAY['mincut_id'], 'There should be an index on mincut_id');

SELECT * FROM finish();

ROLLBACK; 