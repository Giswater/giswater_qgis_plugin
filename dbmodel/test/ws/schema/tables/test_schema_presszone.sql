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

-- Check table presszone
SELECT has_table('presszone'::name, 'Table presszone should exist');

-- Check columns
SELECT columns_are(
    'presszone',
    ARRAY[
        'presszone_id', 'name', 'presszone_type', 'muni_id', 'expl_id', 'sector_id', 'link', 'the_geom',
        'graphconfig', 'stylesheet', 'head', 'active', 'descript', 'tstamp', 'insert_user',
        'lastupdate', 'lastupdate_user', 'avg_press', 'lock_level'
    ],
    'Table presszone should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('presszone', ARRAY['presszone_id'], 'Column presszone_id should be primary key');

-- Check column types
SELECT col_type_is('presszone', 'presszone_id', 'integer', 'Column presszone_id should be integer');
SELECT col_type_is('presszone', 'name', 'text', 'Column name should be text');
SELECT col_type_is('presszone', 'presszone_type', 'text', 'Column presszone_type should be text');
SELECT col_type_is('presszone', 'muni_id', 'integer[]', 'Column muni_id should be integer[]');
SELECT col_type_is('presszone', 'expl_id', 'integer[]', 'Column expl_id should be integer[]');
SELECT col_type_is('presszone', 'sector_id', 'integer[]', 'Column sector_id should be integer[]');
SELECT col_type_is('presszone', 'link', 'character varying(512)', 'Column link should be character varying(512)');
SELECT col_type_is('presszone', 'the_geom', 'geometry(MultiPolygon,25831)', 'Column the_geom should be geometry(MultiPolygon,25831)');
SELECT col_type_is('presszone', 'graphconfig', 'json', 'Column graphconfig should be json');
SELECT col_type_is('presszone', 'stylesheet', 'json', 'Column stylesheet should be json');
SELECT col_type_is('presszone', 'head', 'numeric(12,2)', 'Column head should be numeric(12,2)');
SELECT col_type_is('presszone', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('presszone', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('presszone', 'tstamp', 'timestamp without time zone', 'Column tstamp should be timestamp without time zone');
SELECT col_type_is('presszone', 'insert_user', 'character varying(50)', 'Column insert_user should be character varying(50)');
SELECT col_type_is('presszone', 'lastupdate', 'timestamp without time zone', 'Column lastupdate should be timestamp without time zone');
SELECT col_type_is('presszone', 'lastupdate_user', 'character varying(50)', 'Column lastupdate_user should be character varying(50)');
SELECT col_type_is('presszone', 'avg_press', 'double precision', 'Column avg_press should be double precision');
SELECT col_type_is('presszone', 'lock_level', 'integer', 'Column lock_level should be integer');

-- Check default values
SELECT col_default_is('presszone', 'active', 'true', 'Default value for active should be true');
SELECT col_has_default('presszone', 'tstamp', 'Column tstamp should have a default value');
SELECT col_default_is('presszone', 'insert_user', 'CURRENT_USER', 'Default value for insert_user should be CURRENT_USER');

-- Check constraints
SELECT col_not_null('presszone', 'presszone_id', 'Column presszone_id should be NOT NULL');
SELECT col_not_null('presszone', 'name', 'Column name should be NOT NULL');
SELECT col_not_null('presszone', 'expl_id', 'Column expl_id should be NOT NULL');

-- Check triggers
SELECT has_trigger('presszone', 'gw_trg_edit_controls', 'Table should have trigger gw_trg_edit_controls');
SELECT has_trigger('presszone', 'gw_trg_typevalue_fk_insert', 'Table should have trigger gw_trg_typevalue_fk_insert');
SELECT has_trigger('presszone', 'gw_trg_typevalue_fk_update', 'Table should have trigger gw_trg_typevalue_fk_update');

-- Check rules
SELECT has_rule('presszone', 'presszone_conflict', 'Table should have rule presszone_conflict');
SELECT has_rule('presszone', 'presszone_del_uconflict', 'Table should have rule presszone_del_uconflict');
SELECT has_rule('presszone', 'presszone_del_undefined', 'Table should have rule presszone_del_undefined');
SELECT has_rule('presszone', 'presszone_undefined', 'Table should have rule presszone_undefined');

SELECT * FROM finish();

ROLLBACK;