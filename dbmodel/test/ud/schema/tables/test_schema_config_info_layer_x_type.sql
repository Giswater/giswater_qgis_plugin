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
SELECT col_is_pk('config_info_layer_x_type', ARRAY['tableinfo_id','infotype_id'], 'Columns tableinfo_id and infotype_id should be primary key');

-- Check column types
SELECT col_type_is('config_info_layer_x_type', 'tableinfo_id', 'varchar(50)', 'Column tableinfo_id should be varchar(50)');
SELECT col_type_is('config_info_layer_x_type', 'infotype_id', 'int4', 'Column infotype_id should be int4');
SELECT col_type_is('config_info_layer_x_type', 'tableinfotype_id', 'text', 'Column tableinfotype_id should be text');

-- Check indexes
SELECT has_index('config_info_layer_x_type', 'config_info_layer_x_type_pkey', ARRAY['tableinfo_id','infotype_id'], 'Table should have index on tableinfo_id, infotype_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;