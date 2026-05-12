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

-- Check table om_visit
SELECT has_table('om_visit'::name, 'Table om_visit should exist');

-- Check columns
SELECT columns_are(
    'om_visit',
    ARRAY[
        'id', 'visitcat_id', 'ext_code', 'startdate', 'enddate', 'user_name', 'webclient_id', 'expl_id',
        'the_geom', 'descript', 'is_done', 'lot_id', 'class_id', 'status', 'visit_type', 'publish',
        'unit_id', 'vehicle_id', 'muni_id', 'sector_id'
    ],
    'Table om_visit should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('om_visit', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('om_visit', 'id', 'bigint', 'Column id should be bigint');
SELECT col_type_is('om_visit', 'visitcat_id', 'integer', 'Column visitcat_id should be integer');
SELECT col_type_is('om_visit', 'ext_code', 'varchar(30)', 'Column ext_code should be varchar(30)');
SELECT col_type_is('om_visit', 'startdate', 'timestamp(6) without time zone', 'Column startdate should be timestamp(6)');
SELECT col_type_is('om_visit', 'enddate', 'timestamp(6) without time zone', 'Column enddate should be timestamp(6)');
SELECT col_type_is('om_visit', 'user_name', 'varchar(50)', 'Column user_name should be varchar(50)');
SELECT col_type_is('om_visit', 'webclient_id', 'varchar(50)', 'Column webclient_id should be varchar(50)');
SELECT col_type_is('om_visit', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('om_visit', 'the_geom', 'geometry(Point,25831)', 'Column the_geom should be geometry(Point,25831)');
SELECT col_type_is('om_visit', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('om_visit', 'is_done', 'boolean', 'Column is_done should be boolean');
SELECT col_type_is('om_visit', 'lot_id', 'integer', 'Column lot_id should be integer');
SELECT col_type_is('om_visit', 'class_id', 'integer', 'Column class_id should be integer');
SELECT col_type_is('om_visit', 'status', 'integer', 'Column status should be integer');
SELECT col_type_is('om_visit', 'visit_type', 'integer', 'Column visit_type should be integer');
SELECT col_type_is('om_visit', 'publish', 'boolean', 'Column publish should be boolean');
SELECT col_type_is('om_visit', 'unit_id', 'integer', 'Column unit_id should be integer');
SELECT col_type_is('om_visit', 'vehicle_id', 'integer', 'Column vehicle_id should be integer');
SELECT col_type_is('om_visit', 'muni_id', 'integer', 'Column muni_id should be integer');
SELECT col_type_is('om_visit', 'sector_id', 'integer', 'Column sector_id should be integer');

-- Check default values
SELECT col_has_default('om_visit', 'startdate', 'Column startdate should have a default value');
SELECT col_default_is('om_visit', 'user_name', 'USER', 'Column user_name should default to USER');
SELECT col_default_is('om_visit', 'is_done', 'true', 'Column is_done should default to true');
SELECT col_default_is('om_visit', 'sector_id', '0', 'Column sector_id should default to 0');

-- Check foreign keys
SELECT has_fk('om_visit', 'Table om_visit should have foreign keys');
SELECT fk_ok('om_visit', 'expl_id', 'exploitation', 'expl_id', 'FK expl_id should reference exploitation.expl_id');
SELECT fk_ok('om_visit', 'muni_id', 'ext_municipality', 'muni_id', 'FK muni_id should reference ext_municipality.muni_id');
SELECT fk_ok('om_visit', 'visitcat_id', 'om_visit_cat', 'id', 'FK visitcat_id should reference om_visit_cat.id');

-- Check constraints
SELECT col_not_null('om_visit', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('om_visit', 'sector_id', 'Column sector_id should be NOT NULL');

-- Check triggers
SELECT has_trigger('om_visit', 'gw_trg_om_visit', 'Table should have gw_trg_om_visit trigger');
SELECT has_trigger('om_visit', 'gw_trg_typevalue_fk_insert', 'Table should have gw_trg_typevalue_fk_insert trigger');
SELECT has_trigger('om_visit', 'gw_trg_typevalue_fk_update', 'Table should have gw_trg_typevalue_fk_update trigger');
SELECT has_trigger('om_visit', 'gw_trg_visit_expl', 'Table should have gw_trg_visit_expl trigger');

-- Check indexes
SELECT has_index('om_visit', 'om_visit_muni', 'Table should have om_visit_muni index');
SELECT has_index('om_visit', 'om_visit_sector', 'Table should have om_visit_sector index');
SELECT has_index('om_visit', 'visit_index', 'Table should have visit_index on the_geom');

SELECT * FROM finish();

ROLLBACK; 