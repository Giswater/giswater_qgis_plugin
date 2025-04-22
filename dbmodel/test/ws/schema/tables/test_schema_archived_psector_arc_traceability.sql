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

-- Check table archived_psector_arc_traceability
SELECT has_table('archived_psector_arc_traceability'::name, 'Table archived_psector_arc_traceability should exist');

-- Check columns
SELECT columns_are(
    'archived_psector_arc_traceability',
    ARRAY[
        'id', 'psector_id', 'psector_state', 'doable', 'addparam', 'audit_tstamp', 'audit_user', 'action', 'arc_id', 'code',
        'node_1', 'node_2', 'arccat_id', 'epa_type', 'sector_id', 'state', 'state_type', 'annotation', 'observ', 'comment',
        'custom_length', 'dma_id', 'presszone_id', 'soilcat_id', 'function_type', 'category_type', 'fluid_type',
        'location_type', 'workcat_id', 'workcat_id_end', 'builtdate', 'enddate', 'ownercat_id', 'muni_id', 'postcode',
        'streetaxis_id', 'postnumber', 'postcomplement', 'streetaxis2_id', 'postnumber2', 'postcomplement2', 'descript',
        'link', 'verified', 'the_geom', 'label_x', 'label_y', 'label_rotation', 'publish', 'inventory', 'expl_id',
        'num_value', 'feature_type', 'tstamp', 'lastupdate', 'lastupdate_user', 'insert_user', 'minsector_id', 'dqa_id',
        'district_id', 'adate', 'adescript', 'workcat_id_plan', 'asset_id', 'pavcat_id',
        'nodetype_1', 'elevation1', 'depth1', 'staticpress1', 'nodetype_2', 'elevation2', 'depth2', 'staticpress2',
        'om_state', 'conserv_state', 'parent_id', 'expl_id2', 'brand_id', 'model_id', 'serial_number', 'label_quadrant',
        'macrominsector_id', 'streetname', 'streetname2', 'supplyzone_id', 'datasource', 'lock_level', 'is_scadamap'
    ],
    'Table archived_psector_arc_traceability should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('archived_psector_arc_traceability', 'id', 'Column id should be primary key');

-- Check column types
SELECT col_type_is('archived_psector_arc_traceability', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('archived_psector_arc_traceability', 'psector_id', 'integer', 'Column psector_id should be integer');
SELECT col_type_is('archived_psector_arc_traceability', 'psector_state', 'smallint', 'Column psector_state should be smallint');
SELECT col_type_is('archived_psector_arc_traceability', 'doable', 'boolean', 'Column doable should be boolean');
SELECT col_type_is('archived_psector_arc_traceability', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('archived_psector_arc_traceability', 'audit_tstamp', 'timestamp without time zone', 'Column audit_tstamp should be timestamp');
SELECT col_type_is('archived_psector_arc_traceability', 'audit_user', 'text', 'Column audit_user should be text');
SELECT col_type_is('archived_psector_arc_traceability', 'action', 'character varying(16)', 'Column action should be varchar(16)');
SELECT col_type_is('archived_psector_arc_traceability', 'arc_id', 'character varying(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('archived_psector_arc_traceability', 'the_geom', 'geometry(LineString,25831)', 'Column the_geom should be geometry(LineString,25831)');
SELECT col_type_is('archived_psector_arc_traceability', 'supplyzone_id', 'integer', 'Column supplyzone_id should be integer');
SELECT col_type_is('archived_psector_arc_traceability', 'datasource', 'integer', 'Column datasource should be integer');
SELECT col_type_is('archived_psector_arc_traceability', 'lock_level', 'integer', 'Column lock_level should be integer');
SELECT col_type_is('archived_psector_arc_traceability', 'is_scadamap', 'boolean', 'Column is_scadamap should be boolean');

-- Check foreign keys
SELECT hasnt_fk('archived_psector_arc_traceability', 'Table archived_psector_arc_traceability should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('archived_psector_arc_traceability_id_seq', 'Sequence archived_psector_arc_traceability_id_seq should exist');

SELECT * FROM finish();

ROLLBACK;
