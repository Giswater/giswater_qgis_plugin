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
SELECT has_table('cat_feature_link'::name, 'Table cat_feature_link should exist');

-- Check columns
SELECT columns_are(
    'cat_feature_link',
    ARRAY[
        'id'
    ],
    'Table cat_feature_link should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('cat_feature_link', 'id', 'Column id should be primary key'); 

-- Check column types
SELECT col_type_is('cat_feature_link', 'id', ' varchar(30)', 'Column id should be  varchar(30)');

-- Check foreign keys
SELECT has_fk('cat_feature_link', 'Table cat_feature_link should have foreign keys');

SELECT fk_ok('cat_feature_link', 'id', 'cat_feature', 'id', 'Table should have foreign key from id to cat_feature.id');

-- Check indexes
SELECT has_index('cat_feature_link', 'cat_feature_link_pkey', ARRAY['id'], 'Table should have index on id');

-- Finish
SELECT * FROM finish();

ROLLBACK;