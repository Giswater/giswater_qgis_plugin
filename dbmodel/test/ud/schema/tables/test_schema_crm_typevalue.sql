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
SELECT has_table('crm_typevalue'::name, 'Table crm_typevalue should exist');

-- Check columns
SELECT columns_are(
    'crm_typevalue',
    ARRAY[
        'typevalue', 'id', 'idval', 'descript', 'addparam'
    ],
    'Table crm_typevalue should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('crm_typevalue', 'typevalue', 'Column typevalue should be primary key'); 
SELECT col_is_pk('crm_typevalue', 'id', 'Column id should be primary key'); 

-- Check column types
SELECT col_type_is('crm_typevalue', 'typevalue', 'varchar(50)', 'Column typevalue should be varchar(50)');
SELECT col_type_is('crm_typevalue', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('crm_typevalue', 'idval', 'varchar(100)', 'Column idval should be varchar(100)');
SELECT col_type_is('crm_typevalue', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('crm_typevalue', 'addparam', 'json', 'Column addparam should be json');

-- Check indexes
SELECT has_index('crm_typevalue', 'typevalue', 'Table should have index on typevalue');
SELECT has_index('crm_typevalue', 'id', 'Table should have index on id');

-- Finish
SELECT * FROM finish();

ROLLBACK;