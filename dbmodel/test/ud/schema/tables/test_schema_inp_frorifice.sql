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
SELECT has_table('inp_frorifice'::name, 'Table inp_frorifice should exist');

-- Check columns
SELECT columns_are(
    'inp_frorifice',
    ARRAY[
        'element_id', 'orifice_type', 'offsetval', 'cd', 'orate', 'flap',
        'shape', 'geom1', 'geom2', 'geom3', 'geom4'
    ],
    'Table inp_frorifice should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_frorifice', 'element_id', 'int4', 'Column element_id should be int4');
SELECT col_type_is('inp_frorifice', 'orifice_type', 'varchar(18)', 'Column orifice_type should be varchar(18)');
SELECT col_type_is('inp_frorifice', 'offsetval', 'numeric(12,4)', 'Column offsetval should be numeric(12,4)');
SELECT col_type_is('inp_frorifice', 'cd', 'numeric(12,4)', 'Column cd should be numeric(12,4)');
SELECT col_type_is('inp_frorifice', 'orate', 'numeric(12,4)', 'Column orate should be numeric(12,4)');
SELECT col_type_is('inp_frorifice', 'flap', 'varchar(3)', 'Column flap should be varchar(3)');
SELECT col_type_is('inp_frorifice', 'shape', 'varchar(18)', 'Column shape should be varchar(18)');
SELECT col_type_is('inp_frorifice', 'geom1', 'numeric(12,4)', 'Column geom1 should be numeric(12,4)');
SELECT col_type_is('inp_frorifice', 'geom2', 'numeric(12,4)', 'Column geom2 should be numeric(12,4)');
SELECT col_type_is('inp_frorifice', 'geom3', 'numeric(12,4)', 'Column geom3 should be numeric(12,4)');
SELECT col_type_is('inp_frorifice', 'geom4', 'numeric(12,4)', 'Column geom4 should be numeric(12,4)');

-- Check foreign keys
SELECT has_fk('inp_frorifice', 'Table inp_frorifice should have foreign keys');

SELECT fk_ok('inp_frorifice', 'element_id', 'element', 'element_id', 'FK element_id → element.element_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
