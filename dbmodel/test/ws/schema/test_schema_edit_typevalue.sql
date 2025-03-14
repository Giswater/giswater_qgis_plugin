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

-- Check table edit_typevalue
SELECT has_table('edit_typevalue'::name, 'Table edit_typevalue should exist');

-- Check columns
SELECT columns_are(
    'edit_typevalue',
    ARRAY[
        'typevalue', 'id', 'idval', 'descript', 'addparam'
    ],
    'Table edit_typevalue should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('edit_typevalue', ARRAY['typevalue', 'id'], 'Columns typevalue and id should be primary key');

-- Check column types
SELECT col_type_is('edit_typevalue', 'typevalue', 'varchar(50)', 'Column typevalue should be varchar(50)');
SELECT col_type_is('edit_typevalue', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('edit_typevalue', 'idval', 'varchar(100)', 'Column idval should be varchar(100)');
SELECT col_type_is('edit_typevalue', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('edit_typevalue', 'addparam', 'json', 'Column addparam should be json');

-- Check foreign keys
SELECT hasnt_fk('edit_typevalue', 'Table edit_typevalue should have no foreign keys');

-- Check triggers
SELECT has_trigger('edit_typevalue', 'gw_trg_typevalue_config_fk', 'Table should have gw_trg_typevalue_config_fk trigger');

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('edit_typevalue', 'typevalue', 'Column typevalue should be NOT NULL');
SELECT col_not_null('edit_typevalue', 'id', 'Column id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
