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
SELECT has_table('doc_x_element'::name, 'Table doc_x_element should exist');

-- Check columns
SELECT columns_are(
    'doc_x_element',
    ARRAY[
        'doc_id', 'element_id', 'element_uuid'
    ],
    'Table doc_x_element should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('doc_x_element', ARRAY['doc_id', 'element_id'], 'Columns doc_id and element_id should be primary key');

-- Check column types
SELECT col_type_is('doc_x_element', 'doc_id', 'integer', 'Column doc_id should be integer');
SELECT col_type_is('doc_x_element', 'element_id', 'int4', 'Column element_id should be int4');
SELECT col_type_is('doc_x_element', 'element_uuid', 'uuid', 'Column element_uuid should be uuid');

-- Check foreign keys
SELECT has_fk('doc_x_element', 'Table doc_x_element should have foreign keys');

SELECT fk_ok('doc_x_element', 'doc_id', 'doc', 'id', 'Table should have foreign key from doc_id to doc.id');
SELECT fk_ok('doc_x_element', 'element_id', 'element', 'element_id', 'Table should have foreign key from element_id to element.element_id');

-- Check indexes
SELECT has_index('doc_x_element', 'doc_x_element_pkey', ARRAY['doc_id', 'element_id'], 'Table should have index on doc_id, element_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;