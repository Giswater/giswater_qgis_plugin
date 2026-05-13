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
SELECT has_table('om_visit'::name, 'Table om_visit should exist');

-- Check columns
SELECT columns_are(
    'om_visit',
    ARRAY[
        'id', 'visitcat_id', 'ext_code', 'startdate', 'enddate', 'user_name',
        'webclient_id', 'expl_id', 'the_geom', 'descript', 'is_done', 'lot_id',
        'class_id', 'status', 'visit_type', 'publish', 'unit_id', 'vehicle_id',
        'muni_id', 'sector_id', 'address', 'process_rejection_date', 'reassignment', 'comment',
        'comment_extra'
    ],
    'Table om_visit should have the correct columns'
);

-- Check column types
SELECT col_type_is('om_visit', 'id', 'int8', 'Column id should be int8');
SELECT col_type_is('om_visit', 'visitcat_id', 'int4', 'Column visitcat_id should be int4');
SELECT col_type_is('om_visit', 'ext_code', 'varchar(30)', 'Column ext_code should be varchar(30)');
SELECT col_type_is('om_visit', 'startdate', 'timestamp(6) without time zone', 'Column startdate should be timestamp(6) without time zone');
SELECT col_type_is('om_visit', 'enddate', 'timestamp(6) without time zone', 'Column enddate should be timestamp(6) without time zone');
SELECT col_type_is('om_visit', 'user_name', 'varchar(50)', 'Column user_name should be varchar(50)');
SELECT col_type_is('om_visit', 'webclient_id', 'varchar(50)', 'Column webclient_id should be varchar(50)');
SELECT col_type_is('om_visit', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('om_visit', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('om_visit', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('om_visit', 'is_done', 'bool', 'Column is_done should be bool');
SELECT col_type_is('om_visit', 'lot_id', 'int4', 'Column lot_id should be int4');
SELECT col_type_is('om_visit', 'class_id', 'int4', 'Column class_id should be int4');
SELECT col_type_is('om_visit', 'status', 'int4', 'Column status should be int4');
SELECT col_type_is('om_visit', 'visit_type', 'int4', 'Column visit_type should be int4');
SELECT col_type_is('om_visit', 'publish', 'bool', 'Column publish should be bool');
SELECT col_type_is('om_visit', 'unit_id', 'int4', 'Column unit_id should be int4');
SELECT col_type_is('om_visit', 'vehicle_id', 'int4', 'Column vehicle_id should be int4');
SELECT col_type_is('om_visit', 'muni_id', 'int4', 'Column muni_id should be int4');
SELECT col_type_is('om_visit', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('om_visit', 'address', 'text', 'Column address should be text');
SELECT col_type_is('om_visit', 'process_rejection_date', 'timestamp without time zone', 'Column process_rejection_date should be timestamp without time zone');
SELECT col_type_is('om_visit', 'reassignment', 'varchar(50)', 'Column reassignment should be varchar(50)');
SELECT col_type_is('om_visit', 'comment', 'text', 'Column comment should be text');
SELECT col_type_is('om_visit', 'comment_extra', 'text', 'Column comment_extra should be text');

-- Check foreign keys
SELECT has_fk('om_visit', 'Table om_visit should have foreign keys');

SELECT fk_ok('om_visit', 'visitcat_id', 'om_visit_cat', 'id', 'FK visitcat_id → om_visit_cat.id');
SELECT fk_ok('om_visit', 'expl_id', 'exploitation', 'expl_id', 'FK expl_id → exploitation.expl_id');
SELECT fk_ok('om_visit', 'muni_id', 'ext_municipality', 'muni_id', 'FK muni_id → ext_municipality.muni_id');
SELECT fk_ok('om_visit', 'reassignment', 'cat_users', 'id', 'FK reassignment → cat_users.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
