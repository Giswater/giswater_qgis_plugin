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
SELECT has_table('doc_x_gully'::name, 'Table doc_x_gully should exist');

-- Check columns
SELECT columns_are(
    'doc_x_gully',
    ARRAY[
        'doc_id', 'gully_id', 'gully_uuid'
    ],
    'Table doc_x_gully should have the correct columns'
);

-- Check column types
SELECT col_type_is('doc_x_gully', 'doc_id', 'int4', 'Column doc_id should be int4');
SELECT col_type_is('doc_x_gully', 'gully_id', 'int4', 'Column gully_id should be int4');
SELECT col_type_is('doc_x_gully', 'gully_uuid', 'uuid', 'Column gully_uuid should be uuid');

-- Check foreign keys
SELECT has_fk('doc_x_gully', 'Table doc_x_gully should have foreign keys');

SELECT fk_ok('doc_x_gully', 'gully_id', 'gully', 'gully_id', 'FK gully_id → gully.gully_id');
SELECT fk_ok('doc_x_gully', 'doc_id', 'doc', 'id', 'FK doc_id → doc.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
