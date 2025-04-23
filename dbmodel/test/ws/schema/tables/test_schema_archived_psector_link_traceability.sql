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

-- Check table archived_psector_link_traceability
SELECT has_table('archived_psector_link_traceability'::name, 'Table archived_psector_link_traceability should exist');

-- Check columns
SELECT columns_are(
    'archived_psector_link_traceability',
    ARRAY[
        'id', 'psector_id', 'psector_state', 'doable', 'audit_tstamp', 'audit_user', 'action', 'link_id', 'code',
        'feature_id', 'feature_type', 'exit_id', 'exit_type', 'userdefined_geom', 'state', 'expl_id', 'the_geom',
        'exit_topelev', 'exit_elev', 'sector_id', 'dma_id', 'fluid_type', 'presszone_id', 'dqa_id', 'minsector_id',
        'expl_visibility', 'epa_type', 'is_operative', 'insert_user', 'lastupdate', 'lastupdate_user', 'staticpressure',
        'conneccat_id', 'workcat_id', 'workcat_id_end', 'builtdate', 'enddate', 'uncertain', 'muni_id',
        'macrominsector_id', 'verified', 'supplyzone_id', 'n_hydrometer', 'custom_length', 'datasource'
    ],
    'Table archived_psector_link_traceability should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('archived_psector_link_traceability', 'id', 'Column id should be primary key');

-- Check column types
SELECT col_type_is('archived_psector_link_traceability', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('archived_psector_link_traceability', 'psector_id', 'integer', 'Column psector_id should be integer');
SELECT col_type_is('archived_psector_link_traceability', 'psector_state', 'smallint', 'Column psector_state should be smallint');
SELECT col_type_is('archived_psector_link_traceability', 'doable', 'boolean', 'Column doable should be boolean');
SELECT col_type_is('archived_psector_link_traceability', 'audit_tstamp', 'timestamp without time zone', 'Column audit_tstamp should be timestamp');
SELECT col_type_is('archived_psector_link_traceability', 'audit_user', 'text', 'Column audit_user should be text');
SELECT col_type_is('archived_psector_link_traceability', 'action', 'character varying(16)', 'Column action should be varchar(16)');
SELECT col_type_is('archived_psector_link_traceability', 'link_id', 'integer', 'Column link_id should be integer');
SELECT col_type_is('archived_psector_link_traceability', 'feature_id', 'character varying(16)', 'Column feature_id should be varchar(16)');
SELECT col_type_is('archived_psector_link_traceability', 'the_geom', 'geometry(LineString,25831)', 'Column the_geom should be geometry(LineString,25831)');

-- Check foreign keys
SELECT hasnt_fk('archived_psector_link_traceability', 'Table archived_psector_link_traceability should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('archived_psector_link_traceability_id_seq', 'Sequence archived_psector_link_traceability_id_seq should exist');

SELECT * FROM finish();

ROLLBACK;
