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
SELECT has_table('ext_address'::name, 'Table ext_address should exist');

-- Check columns
SELECT columns_are(
    'ext_address',
    ARRAY[
        'id', 'muni_id', 'postcode', 'streetaxis_id', 'postnumber', 'plot_id',
        'the_geom', 'postcomplement', 'code', 'source'
    ],
    'Table ext_address should have the correct columns'
);

-- Check column types
SELECT col_type_is('ext_address', 'id', 'varchar(16)', 'Column id should be varchar(16)');
SELECT col_type_is('ext_address', 'muni_id', 'int4', 'Column muni_id should be int4');
SELECT col_type_is('ext_address', 'postcode', 'varchar(16)', 'Column postcode should be varchar(16)');
SELECT col_type_is('ext_address', 'streetaxis_id', 'varchar(16)', 'Column streetaxis_id should be varchar(16)');
SELECT col_type_is('ext_address', 'postnumber', 'varchar(16)', 'Column postnumber should be varchar(16)');
SELECT col_type_is('ext_address', 'plot_id', 'varchar(16)', 'Column plot_id should be varchar(16)');
SELECT col_type_is('ext_address', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('ext_address', 'postcomplement', 'text', 'Column postcomplement should be text');
SELECT col_type_is('ext_address', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('ext_address', 'source', 'text', 'Column source should be text');

-- Check foreign keys
SELECT has_fk('ext_address', 'Table ext_address should have foreign keys');

SELECT fk_ok('ext_address', 'muni_id', 'ext_municipality', 'muni_id', 'FK muni_id → ext_municipality.muni_id');
SELECT fk_ok('ext_address', 'streetaxis_id', 'ext_streetaxis', 'id', 'FK streetaxis_id → ext_streetaxis.id');
SELECT fk_ok('ext_address', 'plot_id', 'ext_plot', 'id', 'FK plot_id → ext_plot.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
