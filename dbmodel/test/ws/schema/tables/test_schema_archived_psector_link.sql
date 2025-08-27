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

-- Check table archived_psector_link
SELECT has_table('archived_psector_link'::name, 'Table archived_psector_link should exist');

-- Check columns
SELECT columns_are(
    'archived_psector_link',
    ARRAY[
        'id', 'psector_id', 'psector_state', 'doable', 'audit_tstamp', 'audit_user', 'action', 'link_id', 'code',
        'feature_id', 'feature_type', 'exit_id', 'exit_type', 'userdefined_geom', 'state', 'expl_id', 'the_geom',
        'top_elev2', 'depth2', 'sector_id', 'dma_id', 'fluid_type', 'presszone_id', 'dqa_id', 'minsector_id',
        'expl_visibility', 'is_operative', 'created_by', 'updated_at', 'updated_by', 'staticpressure1',
        'linkcat_id', 'workcat_id', 'workcat_id_end', 'builtdate', 'enddate', 'uncertain', 'muni_id',
        'verified', 'supplyzone_id', 'custom_length', 'datasource', 'created_at', 'staticpressure2',
        'annotation', 'brand_id', 'comment', 'depth1', 'descript', 'link', 'location_type', 'lock_level', 'model_id',
        'num_value', 'observ', 'omzone_id', 'omzone_id', 'state_type', 'sys_code', 'top_elev1'
    ],
    'Table archived_psector_link should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('archived_psector_link', 'link_id', 'Column link_id should be primary key');

-- Check column types
SELECT col_type_is('archived_psector_link', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('archived_psector_link', 'psector_id', 'integer', 'Column psector_id should be integer');
SELECT col_type_is('archived_psector_link', 'psector_state', 'smallint', 'Column psector_state should be smallint');
SELECT col_type_is('archived_psector_link', 'doable', 'boolean', 'Column doable should be boolean');
SELECT col_type_is('archived_psector_link', 'audit_tstamp', 'timestamp without time zone', 'Column audit_tstamp should be timestamp');
SELECT col_type_is('archived_psector_link', 'audit_user', 'text', 'Column audit_user should be text');
SELECT col_type_is('archived_psector_link', 'action', 'character varying(16)', 'Column action should be varchar(16)');
SELECT col_type_is('archived_psector_link', 'link_id', 'integer', 'Column link_id should be integer');
SELECT col_type_is('archived_psector_link', 'feature_id', 'integer', 'Column feature_id should be integer');
SELECT col_type_is('archived_psector_link', 'the_geom', 'geometry(LineString,25831)', 'Column the_geom should be geometry(LineString,25831)');
SELECT col_type_is('archived_psector_link', 'depth2', 'numeric(12,4)', 'Column depth2 should be numeric(12,4)');
SELECT col_type_is('archived_psector_link', 'staticpressure1', 'numeric(12,3)', 'Column staticpressure1 should be numeric(12,3)');
SELECT col_type_is('archived_psector_link', 'staticpressure2', 'numeric(12,3)', 'Column staticpressure2 should be numeric(12,3)');


-- Check foreign keys
SELECT hasnt_fk('archived_psector_link', 'Table archived_psector_link should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('archived_psector_link_id_seq', 'Sequence archived_psector_link_id_seq should exist');

SELECT * FROM finish();

ROLLBACK;
