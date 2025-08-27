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
SELECT has_table('archived_psector_link'::name, 'Table archived_psector_link should exist');

-- Check columns
SELECT columns_are(
    'archived_psector_link',
    ARRAY[
        'id', 'psector_id', 'psector_state', 'doable', 'audit_tstamp', 'audit_user', 'action',
        'link_id', 'code', 'feature_id', 'feature_type', 'exit_id', 'exit_type', 'userdefined_geom',
        'state', 'expl_id', 'the_geom', 'top_elev2', 'y1', 'y2', 'sector_id', 'dma_id',
        'fluid_type', 'expl_visibility',
        'is_operative', 'created_by', 'updated_at', 'updated_by',
        'linkcat_id', 'workcat_id', 'workcat_id_end', 'builtdate', 'enddate', 'uncertain',
        'muni_id', 'verified', 'custom_length', 'datasource', 'created_at',
        'dwfzone_id', '_fluid_type', 'addparam', 'annotation', 'brand_id', 'comment', 'descript',
        'drainzone_outfall', 'dwfzone_outfall', 'expl_id2', 'link', 'link_type', 'location_type',
        'lock_level', 'model_id', 'num_value', 'observ', 'omzone_id', 'private_linkcat_id',
        'state_type', 'sys_code', 'sys_slope', 'top_elev1'
    ],
    'Table archived_psector_link should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('archived_psector_link', 'id', 'Column id should be primary key');


-- HIER CHECKEN OF HET GOED IS
-- Check coulmn types
SELECT col_type_is('archived_psector_link', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('archived_psector_link', 'psector_id', 'integer', 'Column psector_id should be integer');
SELECT col_type_is('archived_psector_link', 'psector_state', 'int2', 'Column psector_state should be int2');
SELECT col_type_is('archived_psector_link', 'doable', 'boolean', 'Column doable should be boolean');
SELECT col_type_is('archived_psector_link', 'audit_tstamp', 'timestamp', 'Column audit_tstamp should be timestamp');
SELECT col_type_is('archived_psector_link', 'audit_user', 'text', 'Column audit_user should be text');
SELECT col_type_is('archived_psector_link', 'action', 'varchar(16)', 'Column action should be varchar(16)');
SELECT col_type_is('archived_psector_link', 'link_id', 'integer', 'Column link_id should be integer');
SELECT col_type_is('archived_psector_link', 'code', 'text', 'Column code should be text');
SELECT col_type_is('archived_psector_link', 'feature_id', 'integer', 'Column feature_id should be integer');
SELECT col_type_is('archived_psector_link', 'feature_type', 'varchar(16)', 'Column feature_type should be varchar(16)');
SELECT col_type_is('archived_psector_link', 'exit_id', 'integer', 'Column exit_id should be integer');
SELECT col_type_is('archived_psector_link', 'exit_type', 'varchar(16)', 'Column exit_type should be varchar(16)');
SELECT col_type_is('archived_psector_link', 'userdefined_geom', 'boolean', 'Column userdefined_geom should be boolean');
SELECT col_type_is('archived_psector_link', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('archived_psector_link', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('archived_psector_link', 'the_geom', 'geometry(linestring, 25831)', 'Column the_geom should be geometry(linestring, 25831)');
SELECT col_type_is('archived_psector_link', 'top_elev2', 'double precision', 'Column top_elev2 should be float8');
SELECT col_type_is('archived_psector_link', 'y1', 'numeric(12,4)', 'Column y1 should be numeric(12,4)');
SELECT col_type_is('archived_psector_link', 'y2', 'numeric(12,4)', 'Column y2 should be numeric(12,4)');
SELECT col_type_is('archived_psector_link', 'sector_id', 'integer', 'Column sector_id should be integer');
SELECT col_type_is('archived_psector_link', 'dma_id', 'integer', 'Column dma_id should be integer');
SELECT col_type_is('archived_psector_link', 'fluid_type', 'integer', 'Column fluid_type should be integer');
SELECT col_type_is('archived_psector_link', 'expl_visibility', 'smallint[]', 'Column expl_visibility should be smallint[]');
SELECT col_type_is('archived_psector_link', 'is_operative', 'boolean', 'Column is_operative should be boolean');
SELECT col_type_is('archived_psector_link', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('archived_psector_link', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('archived_psector_link', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');
SELECT col_type_is('archived_psector_link', 'linkcat_id', 'varchar(30)', 'Column linkcat_id should be varchar(30)');
SELECT col_type_is('archived_psector_link', 'workcat_id', 'varchar(255)', 'Column workcat_id should be varchar(255)');
SELECT col_type_is('archived_psector_link', 'workcat_id_end', 'varchar(255)', 'Column workcat_id_end should be varchar(255)');
SELECT col_type_is('archived_psector_link', 'builtdate', 'date', 'Column builtdate should be date');
SELECT col_type_is('archived_psector_link', 'enddate', 'date', 'Column enddate should be date');
SELECT col_type_is('archived_psector_link', 'uncertain', 'boolean', 'Column uncertain should be boolean');
SELECT col_type_is('archived_psector_link', 'muni_id', 'integer', 'Column muni_id should be integer');
SELECT col_type_is('archived_psector_link', 'verified', 'int2', 'Column verified should be int2');
SELECT col_type_is('archived_psector_link', 'custom_length', 'numeric(12,2)', 'Column custom_length should be numeric(12,2)');
SELECT col_type_is('archived_psector_link', 'datasource', 'integer', 'Column datasource should be integer');
SELECT col_type_is('archived_psector_link', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('archived_psector_link', 'dwfzone_id', 'integer', 'Column dwfzone_id should be integer');

-- Check default values
SELECT col_has_default('archived_psector_link', 'id', 'Column id should have default value');
SELECT col_has_default('archived_psector_link', 'audit_tstamp', 'Column audit_tstamp should have default value');
SELECT col_has_default('archived_psector_link', 'audit_user', 'Column audit_user should have default value');

-- Check foreign keys

-- Check indexes
SELECT has_index('archived_psector_link', 'archived_psector_link_pkey', ARRAY['id'], 'Table should have index on id');

-- Check triggers
SELECT has_trigger('archived_psector_link', 'gw_trg_typevalue_fk_insert', 'Table should have trigger gw_trg_typevalue_fk_insert');
SELECT has_trigger('archived_psector_link', 'gw_trg_typevalue_fk_update', 'Table should have trigger gw_trg_typevalue_fk_update');

-- Check rules

-- Finish
SELECT * FROM finish();

ROLLBACK;