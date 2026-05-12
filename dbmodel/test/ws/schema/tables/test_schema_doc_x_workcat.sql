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

-- Check table doc_x_workcat
SELECT has_table('doc_x_workcat'::name, 'Table doc_x_workcat should exist');

-- Check columns
SELECT columns_are(
    'doc_x_workcat',
    ARRAY[
        'doc_id', 'workcat_id'
    ],
    'Table doc_x_workcat should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('doc_x_workcat', ARRAY['doc_id', 'workcat_id'], 'Columns doc_id and workcat_id should be primary key');

-- Check column types
SELECT col_type_is('doc_x_workcat', 'doc_id', 'integer', 'Column doc_id should be integer');
SELECT col_type_is('doc_x_workcat', 'workcat_id', 'varchar(30)', 'Column workcat_id should be varchar(30)');

-- Check foreign keys
SELECT has_fk('doc_x_workcat', 'Table doc_x_workcat should have foreign keys');
SELECT fk_ok('doc_x_workcat', 'workcat_id', 'cat_work', 'id', 'FK doc_x_workcat_workcat_id_fkey should exist');
SELECT fk_ok('doc_x_workcat', 'doc_id', 'doc', 'id', 'FK doc_x_workcat_doc_id_fkey should exist');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('doc_x_workcat', 'doc_id', 'Column doc_id should be NOT NULL');
SELECT col_not_null('doc_x_workcat', 'workcat_id', 'Column workcat_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
