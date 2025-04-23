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

-- Check table ext_cat_raster
SELECT has_table('ext_cat_raster'::name, 'Table ext_cat_raster should exist');

-- Check columns
SELECT columns_are(
    'ext_cat_raster',
    ARRAY[
        'id', 'code', 'alias', 'raster_type', 'descript', 'source', 'provider', 'year', 'tstamp', 'insert_user'
    ],
    'Table ext_cat_raster should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('ext_cat_raster', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('ext_cat_raster', 'id', 'text', 'Column id should be text');
SELECT col_type_is('ext_cat_raster', 'code', 'text', 'Column code should be text');
SELECT col_type_is('ext_cat_raster', 'alias', 'varchar(50)', 'Column alias should be varchar(50)');
SELECT col_type_is('ext_cat_raster', 'raster_type', 'varchar(30)', 'Column raster_type should be varchar(30)');
SELECT col_type_is('ext_cat_raster', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('ext_cat_raster', 'source', 'text', 'Column source should be text');
SELECT col_type_is('ext_cat_raster', 'provider', 'varchar(30)', 'Column provider should be varchar(30)');
SELECT col_type_is('ext_cat_raster', 'year', 'varchar(4)', 'Column year should be varchar(4)');
SELECT col_type_is('ext_cat_raster', 'tstamp', 'timestamp', 'Column tstamp should be timestamp');
SELECT col_type_is('ext_cat_raster', 'insert_user', 'varchar(50)', 'Column insert_user should be varchar(50)');

-- Check foreign keys
SELECT hasnt_fk('ext_cat_raster', 'Table ext_cat_raster should have no foreign keys');

-- Check triggers
SELECT has_trigger('ext_cat_raster', 'gw_trg_typevalue_fk_insert', 'Table should have gw_trg_typevalue_fk_insert trigger');
SELECT has_trigger('ext_cat_raster', 'gw_trg_typevalue_fk_update', 'Table should have gw_trg_typevalue_fk_update trigger');

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('ext_cat_raster', 'id', 'Column id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
