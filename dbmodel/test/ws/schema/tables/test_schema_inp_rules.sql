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
SELECT has_table('inp_rules'::name, 'Table inp_rules should exist');

-- Check columns
SELECT columns_are(
    'inp_rules',
    ARRAY[
        'id', 'sector_id', 'text', 'active'
    ],
    'Table inp_rules should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_rules', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('inp_rules', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('inp_rules', 'text', 'text', 'Column text should be text');
SELECT col_type_is('inp_rules', 'active', 'bool', 'Column active should be bool');

-- Check foreign keys
SELECT has_fk('inp_rules', 'Table inp_rules should have foreign keys');

SELECT fk_ok('inp_rules', 'sector_id', 'sector', 'sector_id', 'FK sector_id → sector.sector_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
