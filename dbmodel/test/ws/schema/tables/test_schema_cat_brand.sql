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
SELECT has_table('cat_brand'::name, 'Table cat_brand should exist');

-- Check columns
SELECT columns_are(
    'cat_brand',
    ARRAY[
        'id', 'descript', 'link', 'active', 'featurecat_id'
    ],
    'Table cat_brand should have the correct columns'
);

-- Check column types
SELECT col_type_is('cat_brand', 'id', 'varchar(50)', 'Column id should be varchar(50)');
SELECT col_type_is('cat_brand', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('cat_brand', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('cat_brand', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('cat_brand', 'featurecat_id', 'text[]', 'Column featurecat_id should be text[]');

-- Finish
SELECT * FROM finish();

ROLLBACK;
