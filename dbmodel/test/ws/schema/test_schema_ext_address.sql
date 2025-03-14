/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check table ext_address
SELECT has_table('ext_address'::name, 'Table ext_address should exist');

-- Check columns
SELECT columns_are(
    'ext_address',
    ARRAY[
        'id', 'muni_id', 'postcode', 'streetaxis_id', 'postnumber', 'plot_id', 'the_geom', 'expl_id', 'postcomplement', 'ext_code', 'source'
    ],
    'Table ext_address should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('ext_address', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('ext_address', 'id', 'varchar(16)', 'Column id should be varchar(16)');
SELECT col_type_is('ext_address', 'muni_id', 'integer', 'Column muni_id should be integer');
SELECT col_type_is('ext_address', 'postcode', 'varchar(16)', 'Column postcode should be varchar(16)');
SELECT col_type_is('ext_address', 'streetaxis_id', 'varchar(16)', 'Column streetaxis_id should be varchar(16)');
SELECT col_type_is('ext_address', 'postnumber', 'varchar(16)', 'Column postnumber should be varchar(16)');
SELECT col_type_is('ext_address', 'plot_id', 'varchar(16)', 'Column plot_id should be varchar(16)');
SELECT col_type_is('ext_address', 'the_geom', 'geometry(Point,25831)', 'Column the_geom should be geometry(Point,25831)');
SELECT col_type_is('ext_address', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('ext_address', 'postcomplement', 'text', 'Column postcomplement should be text');
SELECT col_type_is('ext_address', 'ext_code', 'text', 'Column ext_code should be text');
SELECT col_type_is('ext_address', 'source', 'text', 'Column source should be text');

-- Check indexes
SELECT has_index('ext_address', 'idx_ext_address_plot_id', ARRAY['plot_id'], 'Should have index on plot_id');
SELECT has_index('ext_address', 'idx_ext_address_postcode', ARRAY['postcode'], 'Should have index on postcode');
SELECT has_index('ext_address', 'idx_ext_address_streetaxis_id', ARRAY['streetaxis_id'], 'Should have index on streetaxis_id');
SELECT has_index('ext_address', 'idx_ext_address_the_geom', ARRAY['the_geom'], 'Should have index on the_geom');

-- Check foreign keys
SELECT has_fk('ext_address', 'Table ext_address should have foreign keys');
SELECT fk_ok('ext_address', 'expl_id', 'exploitation', 'expl_id', 'FK ext_address_exploitation_id_fkey should exist');
SELECT fk_ok('ext_address', 'muni_id', 'ext_municipality', 'muni_id', 'FK ext_address_muni_id_fkey should exist');
SELECT fk_ok('ext_address', 'plot_id', 'ext_plot', 'id', 'FK ext_address_plot_id_fkey should exist');
SELECT fk_ok('ext_address', 'streetaxis_id', 'ext_streetaxis', 'id', 'FK ext_address_streetaxis_id_fkey should exist');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('ext_address', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('ext_address', 'muni_id', 'Column muni_id should be NOT NULL');
SELECT col_not_null('ext_address', 'streetaxis_id', 'Column streetaxis_id should be NOT NULL');
SELECT col_not_null('ext_address', 'postnumber', 'Column postnumber should be NOT NULL');
SELECT col_not_null('ext_address', 'expl_id', 'Column expl_id should be NOT NULL');


SELECT * FROM finish();

ROLLBACK;
