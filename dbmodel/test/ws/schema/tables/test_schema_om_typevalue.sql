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

-- Check table om_typevalue
SELECT has_table('om_typevalue'::name, 'Table om_typevalue should exist');

-- Check columns
SELECT columns_are(
    'om_typevalue',
    ARRAY[
        'typevalue', 'id', 'idval', 'descript', 'addparam'
    ],
    'Table om_typevalue should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('om_typevalue', ARRAY['typevalue', 'id'], 'Columns typevalue and id should be primary key');

-- Check column types
SELECT col_type_is('om_typevalue', 'typevalue', 'text', 'Column typevalue should be text');
SELECT col_type_is('om_typevalue', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('om_typevalue', 'idval', 'text', 'Column idval should be text');
SELECT col_type_is('om_typevalue', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('om_typevalue', 'addparam', 'json', 'Column addparam should be json');

-- Check constraints
SELECT col_not_null('om_typevalue', 'typevalue', 'Column typevalue should be NOT NULL');
SELECT col_not_null('om_typevalue', 'id', 'Column id should be NOT NULL');

-- Check triggers
SELECT has_trigger('om_typevalue', 'gw_trg_typevalue_config_fk', 'Table should have gw_trg_typevalue_config_fk trigger');

SELECT * FROM finish();

ROLLBACK; 