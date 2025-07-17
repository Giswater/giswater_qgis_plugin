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
SELECT has_table('archived_psector_link_traceability'::name, 'Table archived_psector_link_traceability should exist');

-- Check columns
SELECT columns_are(
    'archived_psector_link_traceability',
    ARRAY[
        'id', 'psector_id', 'psector_state', 'doable', 'audit_tstamp', 'audit_user', 'action',
        'link_id', 'code', 'feature_id', 'feature_type', 'exit_id', 'exit_type', 'userdefined_geom',
        'state', 'expl_id', 'the_geom', 'exit_topelev', 'exit_elev', 'sector_id', 'dma_id',
        'fluid_type', 'presszone_id', 'dqa_id', 'minsector_id', 'expl_visibility', 'epa_type',
        'is_operative', 'insert_user', 'lastupdate', 'lastupdate_user', 'staticpressure',
        'conneccat_id', 'workcat_id', 'workcat_id_end', 'builtdate', 'enddate', 'uncertain',
        'muni_id', 'verified', 'supplyzone_id', 'n_hydrometer', 'custom_length', 'datasource'
    ],
    'Table archived_psector_link_traceability should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('archived_psector_link_traceability', 'id', 'Column id should be primary key');


-- HIER CHECKEN OF HET GOED IS
-- Check coulmn types
SELECT col_type_is('archived_psector_link_traceability', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('archived_psector_link_traceability', 'psector_id', 'integer', 'Column psector_id should be integer');
SELECT col_type_is('archived_psector_link_traceability', 'psector_state', 'int2', 'Column psector_state should be int2');
SELECT col_type_is('archived_psector_link_traceability', 'doable', 'boolean', 'Column doable should be boolean');
SELECT col_type_is('archived_psector_link_traceability', 'audit_tstamp', 'timestamp', 'Column audit_tstamp should be timestamp');
SELECT col_type_is('archived_psector_link_traceability', 'audit_user', 'text', 'Column audit_user should be text');
SELECT col_type_is('archived_psector_link_traceability', 'action', 'varchar(16)', 'Column action should be varchar(16)');
SELECT col_type_is('archived_psector_link_traceability', 'link_id', 'integer', 'Column link_id should be integer');
SELECT col_type_is('archived_psector_link_traceability', 'code', 'text', 'Column code should be text');
SELECT col_type_is('archived_psector_link_traceability', 'feature_id', 'integer', 'Column feature_id should be integer');
SELECT col_type_is('archived_psector_link_traceability', 'feature_type', 'varchar(16)', 'Column feature_type should be varchar(16)');
SELECT col_type_is('archived_psector_link_traceability', 'exit_id', 'integer', 'Column exit_id should be integer');
SELECT col_type_is('archived_psector_link_traceability', 'exit_type', 'varchar(16)', 'Column exit_type should be varchar(16)');
SELECT col_type_is('archived_psector_link_traceability', 'userdefined_geom', 'boolean', 'Column userdefined_geom should be boolean');
SELECT col_type_is('archived_psector_link_traceability', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('archived_psector_link_traceability', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('archived_psector_link_traceability', 'the_geom', 'geometry(linestring, 25831)', 'Column the_geom should be geometry(linestring, 25831)');
SELECT col_type_is('archived_psector_link_traceability', 'exit_topelev', 'double precision', 'Column exit_topelev should be float8');
SELECT col_type_is('archived_psector_link_traceability', 'exit_elev', 'numeric(12,3)', 'Column exit_elev should be numeric(12,3)');
SELECT col_type_is('archived_psector_link_traceability', 'sector_id', 'integer', 'Column sector_id should be integer');
SELECT col_type_is('archived_psector_link_traceability', 'dma_id', 'integer', 'Column dma_id should be integer');
SELECT col_type_is('archived_psector_link_traceability', 'fluid_type', 'varchar(50)', 'Column fluid_type should be varchar(50)');
SELECT col_type_is('archived_psector_link_traceability', 'presszone_id', 'integer', 'Column presszone_id should be integer');
SELECT col_type_is('archived_psector_link_traceability', 'dqa_id', 'integer', 'Column dqa_id should be integer');
SELECT col_type_is('archived_psector_link_traceability', 'minsector_id', 'integer', 'Column minsector_id should be integer');
SELECT col_type_is('archived_psector_link_traceability', 'expl_visibility', 'smallint[]', 'Column expl_visibility should be smallint[]');
SELECT col_type_is('archived_psector_link_traceability', 'epa_type', 'varchar(16)', 'Column epa_type should be varchar(16)');
SELECT col_type_is('archived_psector_link_traceability', 'is_operative', 'boolean', 'Column is_operative should be boolean');
SELECT col_type_is('archived_psector_link_traceability', 'insert_user', 'varchar(50)', 'Column insert_user should be varchar(50)');
SELECT col_type_is('archived_psector_link_traceability', 'lastupdate', 'timestamp', 'Column lastupdate should be timestamp');
SELECT col_type_is('archived_psector_link_traceability', 'lastupdate_user', 'varchar(50)', 'Column lastupdate_user should be varchar(50)');
SELECT col_type_is('archived_psector_link_traceability', 'staticpressure', 'numeric', 'Column staticpressure should be numeric(12,3)');
SELECT col_type_is('archived_psector_link_traceability', 'conneccat_id', 'varchar(30)', 'Column conneccat_id should be varchar(30)');
SELECT col_type_is('archived_psector_link_traceability', 'workcat_id', 'varchar(255)', 'Column workcat_id should be varchar(255)');
SELECT col_type_is('archived_psector_link_traceability', 'workcat_id_end', 'varchar(255)', 'Column workcat_id_end should be varchar(255)');
SELECT col_type_is('archived_psector_link_traceability', 'builtdate', 'date', 'Column builtdate should be date');
SELECT col_type_is('archived_psector_link_traceability', 'enddate', 'date', 'Column enddate should be date');
SELECT col_type_is('archived_psector_link_traceability', 'uncertain', 'boolean', 'Column uncertain should be boolean');
SELECT col_type_is('archived_psector_link_traceability', 'muni_id', 'integer', 'Column muni_id should be integer');
SELECT col_type_is('archived_psector_link_traceability', 'verified', 'int2', 'Column verified should be int2');
SELECT col_type_is('archived_psector_link_traceability', 'supplyzone_id', 'integer', 'Column supplyzone_id should be integer');
SELECT col_type_is('archived_psector_link_traceability', 'n_hydrometer', 'integer', 'Column n_hydrometer should be integer');
SELECT col_type_is('archived_psector_link_traceability', 'custom_length', 'numeric', 'Column custom_length should be numeric(12,2)');
SELECT col_type_is('archived_psector_link_traceability', 'datasource', 'integer', 'Column datasource should be integer');

-- Check default values
SELECT col_has_default('archived_psector_link_traceability', 'id', 'Column id should have default value');
SELECT col_has_default('archived_psector_link_traceability', 'audit_tstamp', 'Column audit_tstamp should have default value');
SELECT col_has_default('archived_psector_link_traceability', 'audit_user', 'Column audit_user should have default value');

-- Check foreign keys

-- Check indexes
SELECT has_index('archived_psector_link_traceability', 'id', 'Table should have index on id');

-- Check triggers
SELECT has_trigger('archived_psector_link_traceability', 'gw_trg_typevalue_fk_insert', 'Table should have trigger gw_trg_typevalue_fk_insert');
SELECT has_trigger('archived_psector_link_traceability', 'gw_trg_typevalue_fk_update', 'Table should have trigger gw_trg_typevalue_fk_update');

-- Check rules

-- Finish
SELECT * FROM finish();

ROLLBACK;