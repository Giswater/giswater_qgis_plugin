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
SELECT has_table('cat_feature_element'::name, 'Table cat_feature_element should exist');

-- Check columns
SELECT columns_are(
    'cat_feature_element',
    ARRAY[
        'id', 'epa_default'
    ],
    'Table cat_feature_element should have the correct columns'
);

-- Check column types
SELECT col_type_is('cat_feature_element', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_feature_element', 'epa_default', 'varchar(30)', 'Column epa_default should be varchar(30)');

-- Check foreign keys
SELECT has_fk('cat_feature_element', 'Table cat_feature_element should have foreign keys');

SELECT fk_ok('cat_feature_element', 'id', 'cat_feature', 'id', 'FK id → cat_feature.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
