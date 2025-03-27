/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check table ext_cat_hydrometer
SELECT has_table('ext_cat_hydrometer'::name, 'Table ext_cat_hydrometer should exist');

-- Check columns
SELECT columns_are(
    'ext_cat_hydrometer',
    ARRAY[
        'id', 'hydrometer_type', 'madeby', 'class', 'ulmc', 'voltman_flow', 'multi_jet_flow', 'dnom', 'link', 'url', 'picture', 'svg', 'code', 'observ'
    ],
    'Table ext_cat_hydrometer should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('ext_cat_hydrometer', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('ext_cat_hydrometer', 'id', 'varchar(16)', 'Column id should be varchar(16)');
SELECT col_type_is('ext_cat_hydrometer', 'hydrometer_type', 'varchar(100)', 'Column hydrometer_type should be varchar(100)');
SELECT col_type_is('ext_cat_hydrometer', 'madeby', 'varchar(100)', 'Column madeby should be varchar(100)');
SELECT col_type_is('ext_cat_hydrometer', 'class', 'varchar(100)', 'Column class should be varchar(100)');
SELECT col_type_is('ext_cat_hydrometer', 'ulmc', 'varchar(100)', 'Column ulmc should be varchar(100)');
SELECT col_type_is('ext_cat_hydrometer', 'voltman_flow', 'varchar(100)', 'Column voltman_flow should be varchar(100)');
SELECT col_type_is('ext_cat_hydrometer', 'multi_jet_flow', 'varchar(100)', 'Column multi_jet_flow should be varchar(100)');
SELECT col_type_is('ext_cat_hydrometer', 'dnom', 'varchar(100)', 'Column dnom should be varchar(100)');
SELECT col_type_is('ext_cat_hydrometer', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('ext_cat_hydrometer', 'url', 'varchar(512)', 'Column url should be varchar(512)');
SELECT col_type_is('ext_cat_hydrometer', 'picture', 'varchar(512)', 'Column picture should be varchar(512)');
SELECT col_type_is('ext_cat_hydrometer', 'svg', 'varchar(50)', 'Column svg should be varchar(50)');
SELECT col_type_is('ext_cat_hydrometer', 'code', 'text', 'Column code should be text');
SELECT col_type_is('ext_cat_hydrometer', 'observ', 'text', 'Column observ should be text');

-- Check foreign keys
SELECT hasnt_fk('ext_cat_hydrometer', 'Table ext_cat_hydrometer should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('ext_cat_hydrometer', 'id', 'Column id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
