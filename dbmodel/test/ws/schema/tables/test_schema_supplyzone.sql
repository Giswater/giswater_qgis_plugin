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

-- Check table supplyzone
SELECT has_table('supplyzone'::name, 'Table supplyzone should exist');

-- Check columns
SELECT columns_are(
    'supplyzone',
    ARRAY[
        'supplyzone_id', 'code', 'name', 'descript', 'supplyzone_type', 'muni_id', 'expl_id', 'graphconfig',
        'stylesheet', 'parent_id', 'pattern_id', 'avg_press', 'link', 'lock_level', 'active', 'the_geom',
        'created_at', 'created_by', 'updated_at', 'updated_by', 'addparam', 'sector_id'
    ],
    'Table supplyzone should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('supplyzone', ARRAY['supplyzone_id'], 'Column supplyzone_id should be primary key');

-- Check column types
SELECT col_type_is('supplyzone', 'supplyzone_id', 'integer', 'Column supplyzone_id should be integer');
SELECT col_type_is('supplyzone', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('supplyzone', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('supplyzone', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('supplyzone', 'supplyzone_type', 'character varying(16)', 'Column supplyzone_type should be character varying(16)');
SELECT col_type_is('supplyzone', 'muni_id', 'integer[]', 'Column muni_id should be integer[]');
SELECT col_type_is('supplyzone', 'expl_id', 'integer[]', 'Column expl_id should be integer[]');
SELECT col_type_is('supplyzone', 'graphconfig', 'json', 'Column graphconfig should be json');
SELECT col_type_is('supplyzone', 'stylesheet', 'json', 'Column stylesheet should be json');
SELECT col_type_is('supplyzone', 'parent_id', 'integer', 'Column parent_id should be integer');
SELECT col_type_is('supplyzone', 'pattern_id', 'character varying(20)', 'Column pattern_id should be character varying(20)');
SELECT col_type_is('supplyzone', 'avg_press', 'double precision', 'Column avg_press should be double precision');
SELECT col_type_is('supplyzone', 'link', 'text', 'Column link should be text');
SELECT col_type_is('supplyzone', 'lock_level', 'integer', 'Column lock_level should be integer');
SELECT col_type_is('supplyzone', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('supplyzone', 'the_geom', 'geometry(MultiPolygon,SRID_VALUE)', 'Column the_geom should be geometry(MultiPolygon,SRID_VALUE)');
SELECT col_type_is('supplyzone', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('supplyzone', 'created_by', 'character varying(50)', 'Column created_by should be character varying(50)');
SELECT col_type_is('supplyzone', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('supplyzone', 'updated_by', 'character varying(50)', 'Column updated_by should be character varying(50)');

-- Check default values
SELECT col_default_is('supplyzone', 'active', 'true', 'Column active should default to true');
SELECT col_default_is('supplyzone', 'created_at', 'now()', 'Column created_at should default to now()');
SELECT col_default_is('supplyzone', 'created_by', 'CURRENT_USER', 'Column created_by should default to CURRENT_USER');

-- Check constraints
SELECT col_not_null('supplyzone', 'supplyzone_id', 'Column supplyzone_id should be NOT NULL');

-- Check foreign keys
SELECT has_fk('supplyzone', 'Table supplyzone should have foreign keys');
SELECT fk_ok('supplyzone', 'parent_id', 'supplyzone', 'supplyzone_id', 'FK parent_id should reference supplyzone.supplyzone_id');
SELECT fk_ok('supplyzone', 'pattern_id', 'inp_pattern', 'pattern_id', 'FK pattern_id should reference inp_pattern.pattern_id');

-- Check triggers
SELECT has_trigger('supplyzone', 'gw_trg_edit_controls', 'Table supplyzone should have gw_trg_edit_controls trigger');
SELECT has_trigger('supplyzone', 'gw_trg_typevalue_fk_insert', 'Table supplyzone should have gw_trg_typevalue_fk_insert trigger');
SELECT has_trigger('supplyzone', 'gw_trg_typevalue_fk_update', 'Table supplyzone should have gw_trg_typevalue_fk_update trigger');

SELECT * FROM finish();

ROLLBACK;