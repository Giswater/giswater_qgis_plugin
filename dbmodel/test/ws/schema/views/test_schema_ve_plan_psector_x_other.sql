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

-- Check view ve_plan_psector_x_other
SELECT has_view('ve_plan_psector_x_other'::name, 'View ve_plan_psector_x_other should exist');

-- Check view columns
SELECT columns_are(
    've_plan_psector_x_other',
    ARRAY[
        'id', 'psector_id', 'price_id', 'unit', 'price_descript', 'price',
        'measurement', 'total_budget', 'observ', 'atlas_id', 'the_geom'
    ],
    'View ve_plan_psector_x_other should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_plan_psector_x_other', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('ve_plan_psector_x_other', 'psector_id', 'int4', 'Column psector_id should be int4');
SELECT col_type_is('ve_plan_psector_x_other', 'price_id', 'varchar(16)', 'Column price_id should be varchar(16)');
SELECT col_type_is('ve_plan_psector_x_other', 'unit', 'varchar(5)', 'Column unit should be varchar(5)');
SELECT col_type_is('ve_plan_psector_x_other', 'price_descript', 'text', 'Column price_descript should be text');
SELECT col_type_is('ve_plan_psector_x_other', 'price', 'numeric(14,2)', 'Column price should be numeric(14,2)');
SELECT col_type_is('ve_plan_psector_x_other', 'measurement', 'numeric(12,2)', 'Column measurement should be numeric(12,2)');
SELECT col_type_is('ve_plan_psector_x_other', 'total_budget', 'numeric(14,2)', 'Column total_budget should be numeric(14,2)');
SELECT col_type_is('ve_plan_psector_x_other', 'observ', 'varchar(254)', 'Column observ should be varchar(254)');
SELECT col_type_is('ve_plan_psector_x_other', 'atlas_id', 'int4', 'Column atlas_id should be int4');
SELECT col_type_is('ve_plan_psector_x_other', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
