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

-- Check table omzone
SELECT has_table('omzone'::name, 'Table omzone should exist');

-- Check columns
SELECT columns_are(
    'omzone',
    ARRAY[
        'omzone_id', 'code', 'name', 'descript', 'omzone_type', 'muni_id', 'expl_id', 'macroomzone_id',
        'link', 'lock_level', 'active', 'the_geom', 'created_at', 'created_by', 'updated_at', 'updated_by',
        'addparam', 'graphconfig', 'sector_id', 'stylesheet'
    ],
    'Table omzone should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('omzone', ARRAY['omzone_id'], 'Column omzone_id should be primary key');

-- Check column types
SELECT col_type_is('omzone', 'omzone_id', 'integer', 'Column omzone_id should be integer');
SELECT col_type_is('omzone', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('omzone', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('omzone', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('omzone', 'omzone_type', 'varchar(16)', 'Column omzone_type should be varchar(16)');
SELECT col_type_is('omzone', 'muni_id', 'integer[]', 'Column muni_id should be integer[]');
SELECT col_type_is('omzone', 'expl_id', 'integer[]', 'Column expl_id should be integer[]');
SELECT col_type_is('omzone', 'macroomzone_id', 'integer', 'Column macroomzone_id should be integer');
SELECT col_type_is('omzone', 'link', 'text', 'Column link should be text');
SELECT col_type_is('omzone', 'lock_level', 'integer', 'Column lock_level should be integer');
SELECT col_type_is('omzone', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('omzone', 'the_geom', 'geometry(MultiPolygon,SRID_VALUE)', 'Column the_geom should be geometry(MultiPolygon,SRID_VALUE)');
SELECT col_type_is('omzone', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('omzone', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('omzone', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('omzone', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');

-- Check foreign keys
SELECT has_fk('omzone', 'Table omzone should have foreign keys');
SELECT fk_ok('omzone', 'macroomzone_id', 'macroomzone', 'macroomzone_id', 'FK omzone_macroomzone_id_fkey should exist');

-- Check triggers
SELECT has_trigger('omzone', 'gw_trg_typevalue_fk_insert', 'Table should have gw_trg_typevalue_fk_insert trigger');
SELECT has_trigger('omzone', 'gw_trg_typevalue_fk_update', 'Table should have gw_trg_typevalue_fk_update trigger');

-- Check rules
SELECT has_rule('omzone', 'omzone_conflict', 'Table should have omzone_conflict rule');
SELECT has_rule('omzone', 'omzone_del_conflict', 'Table should have omzone_del_conflict rule');
SELECT has_rule('omzone', 'omzone_del_undefined', 'Table should have omzone_del_undefined rule');
SELECT has_rule('omzone', 'omzone_undefined', 'Table should have omzone_undefined rule');

-- Check sequences
SELECT has_sequence('omzone_omzone_id_seq', 'Sequence omzone_omzone_id_seq should exist');

-- Check constraints
SELECT col_default_is('omzone', 'active', 'true', 'Column active should default to true');
SELECT col_default_is('omzone', 'created_at', 'now()', 'Column created_at should default to now()');
SELECT col_default_is('omzone', 'created_by', 'CURRENT_USER', 'Column created_by should default to CURRENT_USER');

SELECT * FROM finish();

ROLLBACK;
