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
SELECT has_table('plan_psector_x_other'::name, 'Table plan_psector_x_other should exist');

-- Check columns
SELECT columns_are(
    'plan_psector_x_other',
    ARRAY[
        'id', 'price_id', 'measurement', 'psector_id', 'observ', 'insert_tstamp',
        'insert_user', 'the_geom'
    ],
    'Table plan_psector_x_other should have the correct columns'
);

-- Check column types
SELECT col_type_is('plan_psector_x_other', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('plan_psector_x_other', 'price_id', 'varchar(16)', 'Column price_id should be varchar(16)');
SELECT col_type_is('plan_psector_x_other', 'measurement', 'numeric(12,2)', 'Column measurement should be numeric(12,2)');
SELECT col_type_is('plan_psector_x_other', 'psector_id', 'int4', 'Column psector_id should be int4');
SELECT col_type_is('plan_psector_x_other', 'observ', 'varchar(254)', 'Column observ should be varchar(254)');
SELECT col_type_is('plan_psector_x_other', 'insert_tstamp', 'timestamp without time zone', 'Column insert_tstamp should be timestamp without time zone');
SELECT col_type_is('plan_psector_x_other', 'insert_user', 'text', 'Column insert_user should be text');
SELECT col_type_is('plan_psector_x_other', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');

-- Check foreign keys
SELECT has_fk('plan_psector_x_other', 'Table plan_psector_x_other should have foreign keys');

SELECT fk_ok('plan_psector_x_other', 'price_id', 'plan_price', 'id', 'FK price_id → plan_price.id');
SELECT fk_ok('plan_psector_x_other', 'psector_id', 'plan_psector', 'psector_id', 'FK psector_id → plan_psector.psector_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
