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

-- Check table ext_plot
SELECT has_table('ext_plot'::name, 'Table ext_plot should exist');

-- Check columns
SELECT columns_are(
    'ext_plot',
    ARRAY[
        'id', 'plot_code', 'muni_id', 'postcode', 'streetaxis_id', 'postnumber', 'complement', 'placement', 'square', 'observ', 'text', 'the_geom', 'expl_id'
    ],
    'Table ext_plot should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('ext_plot', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('ext_plot', 'id', 'varchar(16)', 'Column id should be varchar(16)');
SELECT col_type_is('ext_plot', 'plot_code', 'varchar(30)', 'Column plot_code should be varchar(30)');
SELECT col_type_is('ext_plot', 'muni_id', 'integer', 'Column muni_id should be integer');
SELECT col_type_is('ext_plot', 'postcode', 'varchar(16)', 'Column postcode should be varchar(16)');
SELECT col_type_is('ext_plot', 'streetaxis_id', 'varchar(16)', 'Column streetaxis_id should be varchar(16)');
SELECT col_type_is('ext_plot', 'postnumber', 'varchar(16)', 'Column postnumber should be varchar(16)');
SELECT col_type_is('ext_plot', 'complement', 'varchar(16)', 'Column complement should be varchar(16)');
SELECT col_type_is('ext_plot', 'placement', 'varchar(16)', 'Column placement should be varchar(16)');
SELECT col_type_is('ext_plot', 'square', 'varchar(16)', 'Column square should be varchar(16)');
SELECT col_type_is('ext_plot', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('ext_plot', 'text', 'text', 'Column text should be text');
SELECT col_type_is('ext_plot', 'the_geom', 'geometry(MultiPolygon,25831)', 'Column the_geom should be geometry(MultiPolygon,25831)');
SELECT col_type_is('ext_plot', 'expl_id', 'integer', 'Column expl_id should be integer');

-- Check indexes
SELECT has_index('ext_plot', 'idx_ext_plot_muni_id', 'Should have index on muni_id');
SELECT has_index('ext_plot', 'idx_ext_plot_plot_code', 'Should have index on plot_code');
SELECT has_index('ext_plot', 'idx_ext_plot_postcode', 'Should have index on postcode');
SELECT has_index('ext_plot', 'idx_ext_plot_streetaxis_id', 'Should have index on streetaxis_id');
SELECT has_index('ext_plot', 'idx_ext_plot_the_geom', 'Should have index on the_geom');

-- Check foreign keys
SELECT has_fk('ext_plot', 'Table ext_plot should have foreign keys');
SELECT fk_ok('ext_plot', 'muni_id', 'ext_municipality', 'muni_id', 'FK ext_plot_muni_id_fkey should exist');
SELECT fk_ok('ext_plot', 'streetaxis_id', 'ext_streetaxis', 'id', 'FK ext_plot_streetaxis_id_fkey should exist');
SELECT fk_ok('ext_plot', 'expl_id', 'exploitation', 'expl_id', 'FK ext_plot_exploitation_id_fkey should exist');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('ext_plot', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('ext_plot', 'muni_id', 'Column muni_id should be NOT NULL');
SELECT col_not_null('ext_plot', 'streetaxis_id', 'Column streetaxis_id should be NOT NULL');
SELECT col_not_null('ext_plot', 'expl_id', 'Column expl_id should be NOT NULL');


SELECT * FROM finish();

ROLLBACK;
