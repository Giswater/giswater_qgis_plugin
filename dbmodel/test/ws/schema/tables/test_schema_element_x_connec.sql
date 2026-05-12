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

-- Check table element_x_connec
SELECT has_table('element_x_connec'::name, 'Table element_x_connec should exist');

-- Check columns
SELECT columns_are(
    'element_x_connec',
    ARRAY[
        'element_id', 'connec_id', 'connec_uuid'
    ],
    'Table element_x_connec should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('element_x_connec', ARRAY['element_id', 'connec_id'], 'Columns element_id and connec_id should be primary key');

-- Check column types
SELECT col_type_is('element_x_connec', 'element_id', 'integer', 'Column element_id should be integer');
SELECT col_type_is('element_x_connec', 'connec_id', 'integer', 'Column connec_id should be integer');
SELECT col_type_is('element_x_connec', 'connec_uuid', 'uuid', 'Column connec_uuid should be uuid');

-- Check foreign keys
SELECT has_fk('element_x_connec', 'Table element_x_connec should have foreign keys');
SELECT fk_ok('element_x_connec', 'element_id', 'element', 'element_id', 'FK element_x_connec_element_id_fkey should exist');
SELECT fk_ok('element_x_connec', 'connec_id', 'connec', 'connec_id', 'FK element_x_connec_connec_id_fkey should exist');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('element_x_connec', 'element_id', 'Column element_id should be NOT NULL');
SELECT col_not_null('element_x_connec', 'connec_id', 'Column connec_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
