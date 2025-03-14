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

-- Check table doc_type
SELECT has_table('doc_type'::name, 'Table doc_type should exist');

-- Check columns
SELECT columns_are(
    'doc_type',
    ARRAY[
        'id', 'comment'
    ],
    'Table doc_type should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('doc_type', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('doc_type', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('doc_type', 'comment', 'varchar(512)', 'Column comment should be varchar(512)');

-- Check foreign keys
SELECT hasnt_fk('doc_type', 'Table doc_type should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('doc_type', 'id', 'Column id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
