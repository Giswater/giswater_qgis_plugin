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

-- Check table archived_psector_arc
SELECT has_table('archived_psector_arc'::name, 'Table archived_psector_arc should exist');

-- Check columns
SELECT columns_are(
    'archived_psector_arc',
    ARRAY[
        'id', 'psector_id', 'psector_state', 'doable', 'addparam', 'audit_tstamp', 'audit_user', 'action', 'arc_id', 'code',
        'node_1', 'node_2', 'arccat_id', 'epa_type', 'sector_id', 'state', 'state_type', 'annotation', 'observ', 'comment',
        'custom_length', 'dma_id', 'presszone_id', 'soilcat_id', 'function_type', 'category_type', 'fluid_type',
        'location_type', 'workcat_id', 'workcat_id_end', 'builtdate', 'enddate', 'ownercat_id', 'muni_id', 'postcode',
        'streetaxis_id', 'postnumber', 'postcomplement', 'streetaxis2_id', 'postnumber2', 'postcomplement2', 'descript',
        'link', 'verified', 'the_geom', 'label_x', 'label_y', 'label_rotation', 'publish', 'inventory', 'expl_id',
        'num_value', 'feature_type', 'created_at', 'created_by', 'updated_at', 'updated_by', 'minsector_id', 'dqa_id',
        'district_id', 'adate', 'adescript', 'workcat_id_plan', 'asset_id', 'pavcat_id',
        'nodetype_1', 'elevation1', 'depth1', 'staticpressure1', 'nodetype_2', 'elevation2', 'depth2', 'staticpressure2',
        'om_state', 'conserv_state', 'parent_id', 'expl_visibility', 'brand_id', 'model_id', 'serial_number', 'label_quadrant',
        'supplyzone_id', 'datasource', 'lock_level', 'is_scadamap', 'psector_descript'
    ],
    'Table archived_psector_arc should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('archived_psector_arc', 'id', 'Column id should be primary key');

-- Check column types
SELECT col_type_is('archived_psector_arc', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('archived_psector_arc', 'psector_id', 'integer', 'Column psector_id should be integer');
SELECT col_type_is('archived_psector_arc', 'psector_state', 'smallint', 'Column psector_state should be smallint');
SELECT col_type_is('archived_psector_arc', 'doable', 'boolean', 'Column doable should be boolean');
SELECT col_type_is('archived_psector_arc', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('archived_psector_arc', 'audit_tstamp', 'timestamp without time zone', 'Column audit_tstamp should be timestamp');
SELECT col_type_is('archived_psector_arc', 'audit_user', 'text', 'Column audit_user should be text');
SELECT col_type_is('archived_psector_arc', 'action', 'character varying(16)', 'Column action should be varchar(16)');
SELECT col_type_is('archived_psector_arc', 'arc_id', 'character varying(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('archived_psector_arc', 'the_geom', 'geometry(LineString,25831)', 'Column the_geom should be geometry(LineString,25831)');
SELECT col_type_is('archived_psector_arc', 'supplyzone_id', 'integer', 'Column supplyzone_id should be integer');
SELECT col_type_is('archived_psector_arc', 'datasource', 'integer', 'Column datasource should be integer');
SELECT col_type_is('archived_psector_arc', 'lock_level', 'integer', 'Column lock_level should be integer');
SELECT col_type_is('archived_psector_arc', 'is_scadamap', 'boolean', 'Column is_scadamap should be boolean');
SELECT col_type_is('archived_psector_arc', 'psector_descript', 'text', 'Column psector_descript should be text');

-- Check foreign keys
SELECT hasnt_fk('archived_psector_arc', 'Table archived_psector_arc should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('archived_psector_arc_id_seq', 'Sequence archived_psector_arc_id_seq should exist');

SELECT * FROM finish();

ROLLBACK;
