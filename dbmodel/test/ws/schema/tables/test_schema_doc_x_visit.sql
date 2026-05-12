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

-- Check table doc_x_visit
SELECT has_table('doc_x_visit'::name, 'Table doc_x_visit should exist');

-- Check columns
SELECT columns_are(
    'doc_x_visit',
    ARRAY[
        'doc_id', 'visit_id'
    ],
    'Table doc_x_visit should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('doc_x_visit', ARRAY['doc_id', 'visit_id'], 'Columns doc_id and visit_id should be primary key');

-- Check column types
SELECT col_type_is('doc_x_visit', 'doc_id', 'integer', 'Column doc_id should be integer');
SELECT col_type_is('doc_x_visit', 'visit_id', 'integer', 'Column visit_id should be integer');

-- Check foreign keys
SELECT has_fk('doc_x_visit', 'Table doc_x_visit should have foreign keys');
SELECT fk_ok('doc_x_visit', 'visit_id', 'om_visit', 'id', 'FK doc_x_visit_visit_id_fkey should exist');
SELECT fk_ok('doc_x_visit', 'doc_id', 'doc', 'id', 'FK doc_x_visit_doc_id_fkey should exist');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('doc_x_visit', 'doc_id', 'Column doc_id should be NOT NULL');
SELECT col_not_null('doc_x_visit', 'visit_id', 'Column visit_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
