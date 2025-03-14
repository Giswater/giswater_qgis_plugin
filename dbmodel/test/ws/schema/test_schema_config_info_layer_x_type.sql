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

-- Check table config_info_layer_x_type
SELECT has_table('config_info_layer_x_type'::name, 'Table config_info_layer_x_type should exist');

-- Check columns
SELECT columns_are(
    'config_info_layer_x_type',
    ARRAY[
        'tableinfo_id', 'infotype_id', 'tableinfotype_id'
    ],
    'Table config_info_layer_x_type should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('config_info_layer_x_type', ARRAY['tableinfo_id', 'infotype_id'], 'Columns tableinfo_id, infotype_id should be primary key');

-- Check column types
SELECT col_type_is('config_info_layer_x_type', 'tableinfo_id', 'varchar(50)', 'Column tableinfo_id should be varchar(50)');
SELECT col_type_is('config_info_layer_x_type', 'infotype_id', 'integer', 'Column infotype_id should be integer');
SELECT col_type_is('config_info_layer_x_type', 'tableinfotype_id', 'text', 'Column tableinfotype_id should be text');

-- Check foreign keys
SELECT hasnt_fk('config_info_layer_x_type', 'Table config_info_layer_x_type should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('config_info_layer_x_type', 'tableinfo_id', 'Column tableinfo_id should be NOT NULL');
SELECT col_not_null('config_info_layer_x_type', 'infotype_id', 'Column infotype_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
