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
SELECT has_table('cat_soil'::name, 'Table cat_soil should exist');

-- Check columns
SELECT columns_are(
    'cat_soil',
    ARRAY[
        'id', 'code', 'descript', 'link', 'y_param', 'b', 'trenchlining', 'm3exc_cost', 'm3fill_cost', 'm3excess_cost', 'm2trenchl_cost',
        'active'
    ],
    'Table cat_soil should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('cat_soil', 'id', 'Column id should be primary key'); 

-- Check column types
SELECT col_type_is('cat_soil', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_soil', 'descript', 'varchar(512)', 'Column descript should be varchar(512)');
SELECT col_type_is('cat_soil', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('cat_soil', 'y_param', 'numeric(5, 2)', 'Column y_param should be numeric(5, 2)');
SELECT col_type_is('cat_soil', 'b', 'numeric(5, 2)', 'Column b should be numeric(5, 2)');
SELECT col_type_is('cat_soil', 'trenchlining', 'numeric(3, 2)', 'Column trenchlining should be numeric(3, 2)');
SELECT col_type_is('cat_soil', 'm3exc_cost', 'varchar(16)', 'Column m3exc_cost should be varchar(16)');
SELECT col_type_is('cat_soil', 'm3fill_cost', 'varchar(16)', 'Column m3fill_cost should be varchar(16)');
SELECT col_type_is('cat_soil', 'm3excess_cost', 'varchar(16)', 'Column m3excess_cost should be varchar(16)');
SELECT col_type_is('cat_soil', 'm2trenchl_cost', 'varchar(16)', 'Column m2trenchl_cost should be varchar(16)');
SELECT col_type_is('cat_soil', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('cat_soil', 'code', 'text', 'Column code should be text');

-- Check default values
SELECT col_has_default('cat_soil', 'active', 'Column active should have default value');

-- Check foreign keys
SELECT has_fk('cat_soil', 'Table cat_soil should have foreign keys');

SELECT fk_ok('cat_soil', 'm2trenchl_cost', 'plan_price', 'id','Table should have foreign key from m2trenchl_cost to plan_price.id');
SELECT fk_ok('cat_soil', 'm3exc_cost', 'plan_price', 'id','Table should have foreign key from m3exc_cost to plan_price.id');
SELECT fk_ok('cat_soil', 'm3excess_cost', 'plan_price', 'id','Table should have foreign key from m3excess_cost to plan_price.id');
SELECT fk_ok('cat_soil', 'm3fill_cost', 'plan_price', 'id','Table should have foreign key from m3fill_cost to plan_price.id');

-- Check indexes
SELECT has_index('cat_soil', 'cat_soil_pkey', ARRAY['id'], 'Table should have index on id');

-- Finish
SELECT * FROM finish();

ROLLBACK;