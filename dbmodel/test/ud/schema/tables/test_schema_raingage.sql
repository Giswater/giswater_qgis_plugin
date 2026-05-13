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
SELECT has_table('raingage'::name, 'Table raingage should exist');

-- Check columns
SELECT columns_are(
    'raingage',
    ARRAY[
        'rg_id', 'form_type', 'intvl', 'scf', 'rgage_type', 'timser_id',
        'fname', 'sta', 'units', 'expl_id', 'the_geom', 'muni_id'
    ],
    'Table raingage should have the correct columns'
);

-- Check column types
SELECT col_type_is('raingage', 'rg_id', 'varchar(16)', 'Column rg_id should be varchar(16)');
SELECT col_type_is('raingage', 'form_type', 'varchar(12)', 'Column form_type should be varchar(12)');
SELECT col_type_is('raingage', 'intvl', 'varchar(10)', 'Column intvl should be varchar(10)');
SELECT col_type_is('raingage', 'scf', 'numeric(12,4)', 'Column scf should be numeric(12,4)');
SELECT col_type_is('raingage', 'rgage_type', 'varchar(18)', 'Column rgage_type should be varchar(18)');
SELECT col_type_is('raingage', 'timser_id', 'varchar(16)', 'Column timser_id should be varchar(16)');
SELECT col_type_is('raingage', 'fname', 'varchar(254)', 'Column fname should be varchar(254)');
SELECT col_type_is('raingage', 'sta', 'varchar(12)', 'Column sta should be varchar(12)');
SELECT col_type_is('raingage', 'units', 'varchar(3)', 'Column units should be varchar(3)');
SELECT col_type_is('raingage', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('raingage', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('raingage', 'muni_id', 'int4', 'Column muni_id should be int4');

-- Check foreign keys
SELECT has_fk('raingage', 'Table raingage should have foreign keys');

SELECT fk_ok('raingage', 'timser_id', 'inp_timeseries', 'id', 'FK timser_id → inp_timeseries.id');
SELECT fk_ok('raingage', 'expl_id', 'exploitation', 'expl_id', 'FK expl_id → exploitation.expl_id');
SELECT fk_ok('raingage', 'muni_id', 'ext_municipality', 'muni_id', 'FK muni_id → ext_municipality.muni_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
