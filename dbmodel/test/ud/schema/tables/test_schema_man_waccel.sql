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
SELECT has_table('man_waccel'::name, 'Table man_waccel should exist');

-- Check columns
SELECT columns_are(
    'man_waccel',
    ARRAY[
        'arc_id', 'sander_length', 'sander_depth', 'prot_surface', 'accessibility', 'name',
        'waccel_code'
    ],
    'Table man_waccel should have the correct columns'
);

-- Check column types
SELECT col_type_is('man_waccel', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('man_waccel', 'sander_length', 'numeric(12,3)', 'Column sander_length should be numeric(12,3)');
SELECT col_type_is('man_waccel', 'sander_depth', 'numeric(12,3)', 'Column sander_depth should be numeric(12,3)');
SELECT col_type_is('man_waccel', 'prot_surface', 'bool', 'Column prot_surface should be bool');
SELECT col_type_is('man_waccel', 'accessibility', 'varchar(16)', 'Column accessibility should be varchar(16)');
SELECT col_type_is('man_waccel', 'name', 'varchar(255)', 'Column name should be varchar(255)');
SELECT col_type_is('man_waccel', 'waccel_code', 'text', 'Column waccel_code should be text');

-- Check foreign keys
SELECT has_fk('man_waccel', 'Table man_waccel should have foreign keys');

SELECT fk_ok('man_waccel', 'arc_id', 'arc', 'arc_id', 'FK arc_id → arc.arc_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
