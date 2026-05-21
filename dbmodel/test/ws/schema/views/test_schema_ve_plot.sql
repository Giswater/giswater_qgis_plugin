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

-- Check view ve_plot
SELECT has_view('ve_plot'::name, 'View ve_plot should exist');

-- Check view columns
SELECT columns_are(
    've_plot',
    ARRAY[
        'id', 'code', 'muni_id', 'postcode', 'streetaxis_id', 'postnumber',
        'complement', 'placement', 'square', 'observ', 'text', 'the_geom'
    ],
    'View ve_plot should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_plot', 'id', 'varchar(16)', 'Column id should be varchar(16)');
SELECT col_type_is('ve_plot', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('ve_plot', 'muni_id', 'int4', 'Column muni_id should be int4');
SELECT col_type_is('ve_plot', 'postcode', 'varchar(16)', 'Column postcode should be varchar(16)');
SELECT col_type_is('ve_plot', 'streetaxis_id', 'varchar(16)', 'Column streetaxis_id should be varchar(16)');
SELECT col_type_is('ve_plot', 'postnumber', 'varchar(16)', 'Column postnumber should be varchar(16)');
SELECT col_type_is('ve_plot', 'complement', 'varchar(16)', 'Column complement should be varchar(16)');
SELECT col_type_is('ve_plot', 'placement', 'varchar(16)', 'Column placement should be varchar(16)');
SELECT col_type_is('ve_plot', 'square', 'varchar(16)', 'Column square should be varchar(16)');
SELECT col_type_is('ve_plot', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('ve_plot', 'text', 'text', 'Column text should be text');
SELECT col_type_is('ve_plot', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
