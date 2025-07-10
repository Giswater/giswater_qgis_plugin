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
        'id', 'muni_id', 'postcode', 'streetaxis_id', 'postnumber', 'plot_id', 'the_geom', 'expl_id', 'postcomplement', 'ext_code',
        'source'
    ],
    'Table ext_address should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('ext_address', 'id', 'Column id should be primary key'); 

-- Check column types
SELECT col_type_is('ext_address', 'id', 'varchar(16)', 'Column id should be varchar(16)');
SELECT col_type_is('ext_address', 'muni_id', 'int4', 'Column muni_id should be int4');
SELECT col_type_is('ext_address', 'postcode', 'varchar(16)', 'Column postcode should be varchar(16)');
SELECT col_type_is('ext_address', 'streetaxis_id', 'varchar(16)', 'Column streetaxis_id should be varchar(16)');
SELECT col_type_is('ext_address', 'postnumber', 'varchar(16)', 'Column postnumber should be varchar(16)');
SELECT col_type_is('ext_address', 'plot_id', 'varchar(16)', 'Column plot_id should be varchar(16)');
SELECT col_type_is('ext_address', 'the_geom', 'geometry(point, 25831)', 'Column the_geom should be geometry(point, 25831)');
SELECT col_type_is('ext_address', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('ext_address', 'postcomplement', 'text', 'Column postcomplement should be text');
SELECT col_type_is('ext_address', 'ext_code', 'text', 'Column ext_code should be text');
SELECT col_type_is('ext_address', 'source', 'text', 'Column source should be text');

-- Check foreign keys
SELECT has_fk('ext_address', 'Table ext_address should have foreign keys');

SELECT fk_ok('ext_address', 'expl_id', 'exploitation', 'expl_id', 'Table should have foreign key from expl_id to exploitation.expl_id');
SELECT fk_ok('ext_address', 'muni_id', 'ext_municipality', 'muni_id', 'Table should have foreign key from muni_id to ext_municipality.muni_id');
SELECT fk_ok('ext_address', 'plot_id', 'ext_plot', 'id', 'Table should have foreign key from plot_id to ext_plot.id');
SELECT fk_ok('ext_address', 'streetaxis_id', 'ext_streetaxis', 'id', 'Table should have foreign key from streetaxis_id to ext_streetaxis.id');

-- Check indexes
SELECT has_index('ext_address', 'id', 'Table should have index on id');
SELECT has_index('ext_address', 'plot_id', 'Table should have index on plot_id');
SELECT has_index('ext_address', 'postcode', 'Table should have index on postcode');
SELECT has_index('ext_address', 'streetaxis_id', 'Table should have index on streetaxis_id');
SELECT has_index('ext_address', 'the_geom', 'Table should have index on the_geom');

-- Finish
SELECT * FROM finish();

ROLLBACK;