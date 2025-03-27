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

-- Check table archived_psector_node_traceability
SELECT has_table('archived_psector_node_traceability'::name, 'Table archived_psector_node_traceability should exist');

-- Check columns
SELECT columns_are(
    'archived_psector_node_traceability',
    ARRAY[
        'id', 'psector_id', 'psector_state', 'doable', 'addparam', 'audit_tstamp', 'audit_user', 'action', 'node_id', 'code',
        'elevation', 'depth', 'nodecat_id', 'epa_type', 'sector_id', 'arc_id', 'parent_id', 'state', 'state_type', 'annotation',
        'observ', 'comment', 'dma_id', 'presszone_id', 'soilcat_id', 'function_type', 'category_type', 'fluid_type',
        'location_type', 'workcat_id', 'workcat_id_end', 'builtdate', 'enddate', 'ownercat_id', 'muni_id', 'postcode',
        'streetaxis_id', 'postnumber', 'postcomplement', 'streetaxis2_id', 'postnumber2', 'postcomplement2', 'descript',
        'link', 'verified', 'rotation', 'the_geom', 'undelete', 'label_x', 'label_y', 'label_rotation', 'publish', 'inventory',
        'hemisphere', 'expl_id', 'num_value', 'feature_type', 'tstamp', 'lastupdate', 'lastupdate_user', 'insert_user',
        'minsector_id', 'dqa_id', 'staticpressure', 'district_id', 'adate', 'adescript', 'accessibility', 'workcat_id_plan',
        'asset_id', 'om_state', 'conserv_state', 'access_type', 'placement_type', 'expl_id2', 'brand_id', 'model_id',
        'serial_number', 'label_quadrant', 'macrominsector_id', 'streetname', 'streetname2'
    ],
    'Table archived_psector_node_traceability should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('archived_psector_node_traceability', 'id', 'Column id should be primary key');

-- Check column types
SELECT col_type_is('archived_psector_node_traceability', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('archived_psector_node_traceability', 'psector_id', 'integer', 'Column psector_id should be integer');
SELECT col_type_is('archived_psector_node_traceability', 'psector_state', 'smallint', 'Column psector_state should be smallint');
SELECT col_type_is('archived_psector_node_traceability', 'doable', 'boolean', 'Column doable should be boolean');
SELECT col_type_is('archived_psector_node_traceability', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('archived_psector_node_traceability', 'audit_tstamp', 'timestamp without time zone', 'Column audit_tstamp should be timestamp');
SELECT col_type_is('archived_psector_node_traceability', 'audit_user', 'text', 'Column audit_user should be text');
SELECT col_type_is('archived_psector_node_traceability', 'action', 'character varying(16)', 'Column action should be varchar(16)');
SELECT col_type_is('archived_psector_node_traceability', 'node_id', 'character varying(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('archived_psector_node_traceability', 'the_geom', 'geometry(Point,25831)', 'Column the_geom should be geometry(Point,25831)');

-- Check foreign keys
SELECT hasnt_fk('archived_psector_node_traceability', 'Table archived_psector_node_traceability should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('archived_psector_node_traceability_id_seq', 'Sequence archived_psector_node_traceability_id_seq should exist');

SELECT * FROM finish();

ROLLBACK;
