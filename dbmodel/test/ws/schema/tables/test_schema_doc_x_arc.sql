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

-- Check table doc_x_arc
SELECT has_table('doc_x_arc'::name, 'Table doc_x_arc should exist');

-- Check columns
SELECT columns_are(
    'doc_x_arc',
    ARRAY[
        'doc_id', 'arc_id', 'arc_uuid'
    ],
    'Table doc_x_arc should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('doc_x_arc', ARRAY['doc_id', 'arc_id'], 'Columns doc_id and arc_id should be primary key');

-- Check column types
SELECT col_type_is('doc_x_arc', 'doc_id', 'integer', 'Column doc_id should be integer');
SELECT col_type_is('doc_x_arc', 'arc_id', 'integer', 'Column arc_id should be integer');
SELECT col_type_is('doc_x_arc', 'arc_uuid', 'uuid', 'Column arc_uuid should be uuid');

-- Check foreign keys
SELECT has_fk('doc_x_arc', 'Table doc_x_arc should have foreign keys');
SELECT fk_ok('doc_x_arc', 'arc_id', 'arc', 'arc_id', 'FK doc_x_arc_arc_id_fkey should exist');
SELECT fk_ok('doc_x_arc', 'doc_id', 'doc', 'id', 'FK doc_x_arc_doc_id_fkey should exist');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('doc_x_arc', 'doc_id', 'Column doc_id should be NOT NULL');
SELECT col_not_null('doc_x_arc', 'arc_id', 'Column arc_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
