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

-- Check table inp_typevalue
SELECT has_table('inp_typevalue'::name, 'Table inp_typevalue should exist');

-- Check columns
SELECT columns_are(
    'inp_typevalue',
    ARRAY[
        'typevalue', 'id', 'idval', 'descript', 'addparam'
    ],
    'Table inp_typevalue should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('inp_typevalue', ARRAY['typevalue', 'id'], 'Columns typevalue, id should be primary key');

-- Check column types
SELECT col_type_is('inp_typevalue', 'typevalue', 'varchar(50)', 'Column typevalue should be varchar(50)');
SELECT col_type_is('inp_typevalue', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('inp_typevalue', 'idval', 'varchar(100)', 'Column idval should be varchar(100)');
SELECT col_type_is('inp_typevalue', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('inp_typevalue', 'addparam', 'json', 'Column addparam should be json');

-- Check foreign keys

-- Check triggers
SELECT has_trigger('inp_typevalue', 'gw_trg_typevalue_config_fk', 'Trigger gw_trg_typevalue_config_fk should exist');

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('inp_typevalue', 'typevalue', 'Column typevalue should be NOT NULL');
SELECT col_not_null('inp_typevalue', 'id', 'Column id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;