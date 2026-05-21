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
SELECT has_table('doc_x_visit'::name, 'Table doc_x_visit should exist');

-- Check columns
SELECT columns_are(
    'doc_x_visit',
    ARRAY[
        'doc_id', 'visit_id'
    ],
    'Table doc_x_visit should have the correct columns'
);

-- Check column types
SELECT col_type_is('doc_x_visit', 'doc_id', 'int4', 'Column doc_id should be int4');
SELECT col_type_is('doc_x_visit', 'visit_id', 'int4', 'Column visit_id should be int4');

-- Check foreign keys
SELECT has_fk('doc_x_visit', 'Table doc_x_visit should have foreign keys');

SELECT fk_ok('doc_x_visit', 'visit_id', 'om_visit', 'id', 'FK visit_id → om_visit.id');
SELECT fk_ok('doc_x_visit', 'doc_id', 'doc', 'id', 'FK doc_id → doc.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
