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

-- Check table cat_feature_arc
SELECT has_table('cat_feature_arc'::name, 'Table cat_feature_arc should exist');

-- Check columns
SELECT columns_are(
    'cat_feature_arc',
    ARRAY[
        'id', 'epa_default'
    ],
    'Table cat_feature_arc should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('cat_feature_arc', 'id', 'Column id should be primary key');

-- Check indexes


-- Check column types
SELECT col_type_is('cat_feature_arc', 'id', 'character varying(30)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_feature_arc', 'epa_default', 'character varying(30)', 'Column epa_default should be varchar(30)');

-- Check foreign keys
SELECT has_fk('cat_feature_arc', 'Table cat_feature_arc should have foreign keys');
SELECT fk_ok(
    'cat_feature_arc', 'id',
    'cat_feature', 'id',
    'Column id should reference cat_feature(id)'
);

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_has_check('cat_feature_arc', 'epa_default', 'Column epa_default should have check constraint');

SELECT * FROM finish();

ROLLBACK;
