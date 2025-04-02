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

-- Check table archived_psector_connec_traceability
SELECT has_table('archived_psector_connec_traceability'::name, 'Table archived_psector_connec_traceability should exist');

-- Check columns
SELECT columns_are(
    'archived_psector_connec_traceability',
    ARRAY[
        'id', 'psector_id', 'psector_state', 'doable', 'psector_arc_id', 'link_id', 'link_the_geom', 'audit_tstamp', 'audit_user',
        'action', 'connec_id', 'code', 'top_elev', 'depth', 'conneccat_id', 'sector_id', 'customer_code', 'state', 'state_type',
        'arc_id', 'connec_length', 'annotation', 'observ', 'comment', 'dma_id', 'presszone_id', 'soilcat_id', 'function_type',
        'category_type', 'fluid_type', 'location_type', 'workcat_id', 'workcat_id_end', 'builtdate', 'enddate', 'ownercat_id',
        'muni_id', 'postcode', 'streetaxis_id', 'postnumber', 'postcomplement', 'streetaxis2_id', 'postnumber2', 'postcomplement2',
        'descript', 'link', 'verified', 'rotation', 'the_geom', 'undelete', 'label_x', 'label_y', 'label_rotation', 'publish',
        'inventory', 'expl_id', 'num_value', 'feature_type', 'tstamp', 'pjoint_type', 'pjoint_id', 'lastupdate', 'lastupdate_user',
        'insert_user', 'minsector_id', 'dqa_id', 'staticpressure', 'district_id', 'adate', 'adescript', 'accessibility',
        'workcat_id_plan', 'asset_id', 'epa_type', 'om_state', 'conserv_state', 'priority', 'access_type', 'placement_type',
        'crmzone_id', 'expl_id2', 'plot_code', 'brand_id', 'model_id', 'serial_number', 'label_quadrant', 'macrominsector_id',
        'streetname', 'streetname2', 'n_inhabitants', 'supplyzone_id', 'datasource', 'lock_level', 'block_zone', 'n_hydrometer', 'is_scadamap'
    ],
    'Table archived_psector_connec_traceability should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('archived_psector_connec_traceability', 'id', 'Column id should be primary key');

-- Check column types
SELECT col_type_is('archived_psector_connec_traceability', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('archived_psector_connec_traceability', 'psector_id', 'integer', 'Column psector_id should be integer');
SELECT col_type_is('archived_psector_connec_traceability', 'psector_state', 'smallint', 'Column psector_state should be smallint');
SELECT col_type_is('archived_psector_connec_traceability', 'doable', 'boolean', 'Column doable should be boolean');
SELECT col_type_is('archived_psector_connec_traceability', 'psector_arc_id', 'character varying(16)', 'Column psector_arc_id should be varchar(16)');
SELECT col_type_is('archived_psector_connec_traceability', 'link_id', 'integer', 'Column link_id should be integer');
SELECT col_type_is('archived_psector_connec_traceability', 'link_the_geom', 'geometry(LineString,25831)', 'Column link_the_geom should be geometry(LineString,25831)');
SELECT col_type_is('archived_psector_connec_traceability', 'audit_tstamp', 'timestamp without time zone', 'Column audit_tstamp should be timestamp');
SELECT col_type_is('archived_psector_connec_traceability', 'audit_user', 'text', 'Column audit_user should be text');
SELECT col_type_is('archived_psector_connec_traceability', 'action', 'character varying(16)', 'Column action should be varchar(16)');
SELECT col_type_is('archived_psector_connec_traceability', 'the_geom', 'geometry(Point,25831)', 'Column the_geom should be geometry(Point,25831)');
SELECT col_type_is('archived_psector_connec_traceability', 'verified', 'integer', 'Column verified should be integer');
SELECT col_type_is('archived_psector_connec_traceability', 'top_elev', 'numeric(12,4)', 'Column top_elev should be numeric(12,4)');
SELECT col_type_is('archived_psector_connec_traceability', 'presszone_id', 'integer', 'Column presszone_id should be integer');
SELECT col_type_is('archived_psector_connec_traceability', 'n_inhabitants', 'integer', 'Column n_inhabitants should be integer');
SELECT col_type_is('archived_psector_connec_traceability', 'supplyzone_id', 'integer', 'Column supplyzone_id should be integer');
SELECT col_type_is('archived_psector_connec_traceability', 'datasource', 'integer', 'Column datasource should be integer');
SELECT col_type_is('archived_psector_connec_traceability', 'lock_level', 'integer', 'Column lock_level should be integer');
SELECT col_type_is('archived_psector_connec_traceability', 'block_zone', 'text', 'Column block_zone should be text');
SELECT col_type_is('archived_psector_connec_traceability', 'n_hydrometer', 'integer', 'Column n_hydrometer should be integer');
SELECT col_type_is('archived_psector_connec_traceability', 'is_scadamap', 'boolean', 'Column is_scadamap should be boolean');

-- Check foreign keys
SELECT hasnt_fk('archived_psector_connec_traceability', 'Table archived_psector_connec_traceability should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('archived_psector_connec_traceability_id_seq', 'Sequence archived_psector_connec_traceability_id_seq should exist');

SELECT * FROM finish();

ROLLBACK;
