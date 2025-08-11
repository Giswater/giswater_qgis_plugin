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

-- Check table archived_psector_node
SELECT has_table('archived_psector_node'::name, 'Table archived_psector_node should exist');

-- Check columns
SELECT columns_are(
    'archived_psector_node',
    ARRAY[
        'id', 'psector_id', 'psector_state', 'doable', 'addparam', 'audit_tstamp', 'audit_user', 'action', 'node_id', 'code',
        'elevation', 'depth', 'nodecat_id', 'epa_type', 'sector_id', 'arc_id', 'parent_id', 'state', 'state_type', 'annotation',
        'observ', 'comment', 'dma_id', 'presszone_id', 'soilcat_id', 'function_type', 'category_type', 'fluid_type',
        'location_type', 'workcat_id', 'workcat_id_end', 'builtdate', 'enddate', 'ownercat_id', 'muni_id', 'postcode',
        'streetaxis_id', 'postnumber', 'postcomplement', 'streetaxis2_id', 'postnumber2', 'postcomplement2', 'descript',
        'link', 'verified', 'rotation', 'the_geom', 'label_x', 'label_y', 'label_rotation', 'publish', 'inventory',
        'hemisphere', 'expl_id', 'num_value', 'feature_type', 'created_at', 'created_by', 'updated_at', 'updated_by',
        'minsector_id', 'dqa_id', 'staticpressure', 'district_id', 'adate', 'adescript', 'accessibility', 'workcat_id_plan',
        'asset_id', 'om_state', 'conserv_state', 'access_type', 'placement_type', 'expl_visibility', 'brand_id', 'model_id',
        'serial_number', 'label_quadrant', 'top_elev', 'custom_top_elev',
        'datasource', 'supplyzone_id', 'lock_level', 'is_scadamap'
    ],
    'Table archived_psector_node should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('archived_psector_node', 'id', 'Column id should be primary key');

-- Check column types
SELECT col_type_is('archived_psector_node', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('archived_psector_node', 'psector_id', 'integer', 'Column psector_id should be integer');
SELECT col_type_is('archived_psector_node', 'psector_state', 'smallint', 'Column psector_state should be smallint');
SELECT col_type_is('archived_psector_node', 'doable', 'boolean', 'Column doable should be boolean');
SELECT col_type_is('archived_psector_node', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('archived_psector_node', 'audit_tstamp', 'timestamp without time zone', 'Column audit_tstamp should be timestamp');
SELECT col_type_is('archived_psector_node', 'audit_user', 'text', 'Column audit_user should be text');
SELECT col_type_is('archived_psector_node', 'action', 'character varying(16)', 'Column action should be varchar(16)');
SELECT col_type_is('archived_psector_node', 'node_id', 'character varying(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('archived_psector_node', 'the_geom', 'geometry(Point,25831)', 'Column the_geom should be geometry(Point,25831)');
SELECT col_type_is('archived_psector_node', 'verified', 'integer', 'Column verified should be integer');
SELECT col_type_is('archived_psector_node', 'top_elev', 'numeric(12, 4)', 'Column top_elev should be numeric(12, 4)');
SELECT col_type_is('archived_psector_node', 'custom_top_elev', 'numeric(12, 4)', 'Column custom_top_elev should be numeric(12, 4)');
SELECT col_type_is('archived_psector_node', 'datasource', 'integer', 'Column datasource should be integer');
SELECT col_type_is('archived_psector_node', 'supplyzone_id', 'integer', 'Column supplyzone_id should be integer');
SELECT col_type_is('archived_psector_node', 'lock_level', 'integer', 'Column lock_level should be integer');
SELECT col_type_is('archived_psector_node', 'is_scadamap', 'boolean', 'Column is_scadamap should be boolean');

-- Check foreign keys
SELECT hasnt_fk('archived_psector_node', 'Table archived_psector_node should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('archived_psector_node_id_seq', 'Sequence archived_psector_node_id_seq should exist');

SELECT * FROM finish();

ROLLBACK;
