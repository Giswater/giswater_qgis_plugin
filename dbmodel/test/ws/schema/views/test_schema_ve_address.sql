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

-- Check view ve_address
SELECT has_view('ve_address'::name, 'View ve_address should exist');

-- Check view columns
SELECT columns_are(
    've_address',
    ARRAY[
        'id', 'muni_id', 'postcode', 'streetaxis_id', 'postnumber', 'plot_id',
        'name', 'the_geom', 'postcomplement', 'code', 'source'
    ],
    'View ve_address should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_address', 'id', 'varchar(16)', 'Column id should be varchar(16)');
SELECT col_type_is('ve_address', 'muni_id', 'int4', 'Column muni_id should be int4');
SELECT col_type_is('ve_address', 'postcode', 'varchar(16)', 'Column postcode should be varchar(16)');
SELECT col_type_is('ve_address', 'streetaxis_id', 'varchar(16)', 'Column streetaxis_id should be varchar(16)');
SELECT col_type_is('ve_address', 'postnumber', 'varchar(16)', 'Column postnumber should be varchar(16)');
SELECT col_type_is('ve_address', 'plot_id', 'varchar(16)', 'Column plot_id should be varchar(16)');
SELECT col_type_is('ve_address', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('ve_address', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('ve_address', 'postcomplement', 'text', 'Column postcomplement should be text');
SELECT col_type_is('ve_address', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('ve_address', 'source', 'text', 'Column source should be text');

SELECT * FROM finish();

ROLLBACK;
