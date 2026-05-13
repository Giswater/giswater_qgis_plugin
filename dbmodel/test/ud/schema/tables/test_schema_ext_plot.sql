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
SELECT has_table('ext_plot'::name, 'Table ext_plot should exist');

-- Check columns
SELECT columns_are(
    'ext_plot',
    ARRAY[
        'id', 'code', 'muni_id', 'postcode', 'streetaxis_id', 'postnumber',
        'complement', 'placement', 'square', 'observ', 'text', 'the_geom'
    ],
    'Table ext_plot should have the correct columns'
);

-- Check column types
SELECT col_type_is('ext_plot', 'id', 'varchar(16)', 'Column id should be varchar(16)');
SELECT col_type_is('ext_plot', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('ext_plot', 'muni_id', 'int4', 'Column muni_id should be int4');
SELECT col_type_is('ext_plot', 'postcode', 'varchar(16)', 'Column postcode should be varchar(16)');
SELECT col_type_is('ext_plot', 'streetaxis_id', 'varchar(16)', 'Column streetaxis_id should be varchar(16)');
SELECT col_type_is('ext_plot', 'postnumber', 'varchar(16)', 'Column postnumber should be varchar(16)');
SELECT col_type_is('ext_plot', 'complement', 'varchar(16)', 'Column complement should be varchar(16)');
SELECT col_type_is('ext_plot', 'placement', 'varchar(16)', 'Column placement should be varchar(16)');
SELECT col_type_is('ext_plot', 'square', 'varchar(16)', 'Column square should be varchar(16)');
SELECT col_type_is('ext_plot', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('ext_plot', 'text', 'text', 'Column text should be text');
SELECT col_type_is('ext_plot', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');

-- Check foreign keys
SELECT has_fk('ext_plot', 'Table ext_plot should have foreign keys');

SELECT fk_ok('ext_plot', 'muni_id', 'ext_municipality', 'muni_id', 'FK muni_id → ext_municipality.muni_id');
SELECT fk_ok('ext_plot', 'streetaxis_id', 'ext_streetaxis', 'id', 'FK streetaxis_id → ext_streetaxis.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
