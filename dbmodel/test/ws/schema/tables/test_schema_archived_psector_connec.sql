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

-- Check table archived_psector_connec
SELECT has_table('archived_psector_connec'::name, 'Table archived_psector_connec should exist');

-- Check columns
SELECT columns_are(
    'archived_psector_connec',
    ARRAY[
        'id', 'psector_id', 'psector_state', 'doable', 'psector_arc_id', 'link_id', 'link_the_geom', 'audit_tstamp', 'audit_user',
        'action', 'connec_id', 'code', 'top_elev', 'depth', 'conneccat_id', 'sector_id', 'customer_code', 'state', 'state_type',
        'arc_id', 'connec_length', 'annotation', 'observ', 'comment', 'dma_id', 'presszone_id', 'soilcat_id', 'function_type',
        'category_type', 'fluid_type', 'location_type', 'workcat_id', 'workcat_id_end', 'builtdate', 'enddate', 'ownercat_id',
        'muni_id', 'postcode', 'streetaxis_id', 'postnumber', 'postcomplement', 'streetaxis2_id', 'postnumber2', 'postcomplement2',
        'descript', 'link', 'verified', 'rotation', 'the_geom', 'label_x', 'label_y', 'label_rotation', 'publish',
        'inventory', 'expl_id', 'num_value', 'feature_type', 'created_at', 'pjoint_type', 'pjoint_id', 'updated_at', 'updated_by',
        'created_by', 'minsector_id', 'dqa_id', 'staticpressure', 'district_id', 'adate', 'adescript', 'accessibility',
        'workcat_id_plan', 'asset_id', 'epa_type', 'om_state', 'conserv_state', 'priority', 'access_type', 'placement_type',
        'crmzone_id', 'expl_visibility', 'plot_code', 'brand_id', 'model_id', 'serial_number', 'label_quadrant',
        'n_inhabitants', 'supplyzone_id', 'datasource', 'lock_level', 'block_zone', 'n_hydrometer'
    ],
    'Table archived_psector_connec should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('archived_psector_connec', 'id', 'Column id should be primary key');

-- Check column types
SELECT col_type_is('archived_psector_connec', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('archived_psector_connec', 'psector_id', 'integer', 'Column psector_id should be integer');
SELECT col_type_is('archived_psector_connec', 'psector_state', 'smallint', 'Column psector_state should be smallint');
SELECT col_type_is('archived_psector_connec', 'doable', 'boolean', 'Column doable should be boolean');
SELECT col_type_is('archived_psector_connec', 'psector_arc_id', 'character varying(16)', 'Column psector_arc_id should be varchar(16)');
SELECT col_type_is('archived_psector_connec', 'link_id', 'integer', 'Column link_id should be integer');
SELECT col_type_is('archived_psector_connec', 'link_the_geom', 'geometry(LineString,25831)', 'Column link_the_geom should be geometry(LineString,25831)');
SELECT col_type_is('archived_psector_connec', 'audit_tstamp', 'timestamp without time zone', 'Column audit_tstamp should be timestamp');
SELECT col_type_is('archived_psector_connec', 'audit_user', 'text', 'Column audit_user should be text');
SELECT col_type_is('archived_psector_connec', 'action', 'character varying(16)', 'Column action should be varchar(16)');
SELECT col_type_is('archived_psector_connec', 'the_geom', 'geometry(Point,25831)', 'Column the_geom should be geometry(Point,25831)');
SELECT col_type_is('archived_psector_connec', 'verified', 'integer', 'Column verified should be integer');
SELECT col_type_is('archived_psector_connec', 'top_elev', 'numeric(12,4)', 'Column top_elev should be numeric(12,4)');
SELECT col_type_is('archived_psector_connec', 'presszone_id', 'integer', 'Column presszone_id should be integer');
SELECT col_type_is('archived_psector_connec', 'n_inhabitants', 'integer', 'Column n_inhabitants should be integer');
SELECT col_type_is('archived_psector_connec', 'supplyzone_id', 'integer', 'Column supplyzone_id should be integer');
SELECT col_type_is('archived_psector_connec', 'datasource', 'integer', 'Column datasource should be integer');
SELECT col_type_is('archived_psector_connec', 'lock_level', 'integer', 'Column lock_level should be integer');
SELECT col_type_is('archived_psector_connec', 'block_zone', 'text', 'Column block_zone should be text');
SELECT col_type_is('archived_psector_connec', 'n_hydrometer', 'integer', 'Column n_hydrometer should be integer');

-- Check foreign keys
SELECT hasnt_fk('archived_psector_connec', 'Table archived_psector_connec should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('archived_psector_connec_id_seq', 'Sequence archived_psector_connec_id_seq should exist');

SELECT * FROM finish();

ROLLBACK;
