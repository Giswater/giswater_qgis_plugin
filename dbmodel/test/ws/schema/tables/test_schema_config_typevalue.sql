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

-- Check table config_typevalue
SELECT has_table('config_typevalue'::name, 'Table config_typevalue should exist');

-- Check columns
SELECT columns_are(
    'config_typevalue',
    ARRAY[
        'typevalue', 'id', 'idval', 'camelstyle', 'addparam'
    ],
    'Table config_typevalue should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('config_typevalue', ARRAY['typevalue', 'id'], 'Columns typevalue, id should be primary key');

-- Check column types
SELECT col_type_is('config_typevalue', 'typevalue', 'varchar(50)', 'Column typevalue should be varchar(50)');
SELECT col_type_is('config_typevalue', 'id', 'varchar(100)', 'Column id should be varchar(100)');
SELECT col_type_is('config_typevalue', 'idval', 'varchar(100)', 'Column idval should be varchar(100)');
SELECT col_type_is('config_typevalue', 'camelstyle', 'text', 'Column camelstyle should be text');
SELECT col_type_is('config_typevalue', 'addparam', 'json', 'Column addparam should be json');

-- Check foreign keys
SELECT hasnt_fk('config_typevalue', 'Table config_typevalue should have no foreign keys');

-- Check triggers
SELECT has_trigger('config_typevalue', 'gw_trg_typevalue_config_fk', 'Table should have gw_trg_typevalue_config_fk trigger');

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('config_typevalue', 'typevalue', 'Column typevalue should be NOT NULL');
SELECT col_not_null('config_typevalue', 'id', 'Column id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
