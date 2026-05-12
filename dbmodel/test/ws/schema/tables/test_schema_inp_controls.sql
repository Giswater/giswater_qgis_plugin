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

-- Check table inp_controls
SELECT has_table('inp_controls'::name, 'Table inp_controls should exist');

-- Check columns
SELECT columns_are(
    'inp_controls',
    ARRAY[
        'id', 'sector_id', 'text', 'active'
    ],
    'Table inp_controls should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('inp_controls', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('inp_controls', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('inp_controls', 'sector_id', 'integer', 'Column sector_id should be integer');
SELECT col_type_is('inp_controls', 'text', 'text', 'Column text should be text');
SELECT col_type_is('inp_controls', 'active', 'boolean', 'Column active should be boolean');

-- Check foreign keys
SELECT has_fk('inp_controls', 'Table inp_controls should have foreign keys');
SELECT fk_ok('inp_controls', 'sector_id', 'sector', 'sector_id', 'FK sector_id should reference sector.sector_id');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('inp_controls_id_seq', 'Sequence inp_controls_id_seq should exist');
-- Check constraints
SELECT col_not_null('inp_controls', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('inp_controls', 'sector_id', 'Column sector_id should be NOT NULL');
SELECT col_not_null('inp_controls', 'text', 'Column text should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
