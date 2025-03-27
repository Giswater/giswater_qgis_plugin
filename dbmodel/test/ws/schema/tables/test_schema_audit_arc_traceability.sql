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

-- Check table audit_arc_traceability
SELECT has_table('audit_arc_traceability'::name, 'Table audit_arc_traceability should exist');

-- Check columns
SELECT columns_are(
    'audit_arc_traceability',
    ARRAY[
        'id', 'type', 'arc_id', 'arc_id1', 'arc_id2', 'node_id', 'tstamp', 'cur_user', 'code'
    ],
    'Table audit_arc_traceability should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('audit_arc_traceability', 'id', 'Column id should be primary key');

-- Check column types
SELECT col_type_is('audit_arc_traceability', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('audit_arc_traceability', 'type', 'character varying(50)', 'Column type should be varchar(50)');
SELECT col_type_is('audit_arc_traceability', 'arc_id', 'character varying(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('audit_arc_traceability', 'arc_id1', 'character varying(16)', 'Column arc_id1 should be varchar(16)');
SELECT col_type_is('audit_arc_traceability', 'arc_id2', 'character varying(16)', 'Column arc_id2 should be varchar(16)');
SELECT col_type_is('audit_arc_traceability', 'node_id', 'character varying(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('audit_arc_traceability', 'tstamp', 'timestamp(6) without time zone', 'Column tstamp should be timestamp(6)');
SELECT col_type_is('audit_arc_traceability', 'cur_user', 'character varying(50)', 'Column cur_user should be varchar(50)');
SELECT col_type_is('audit_arc_traceability', 'code', 'text', 'Column code should be text');

-- Check foreign keys
SELECT hasnt_fk('audit_arc_traceability', 'Table audit_arc_traceability should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('audit_arc_traceability_id_seq', 'Sequence audit_arc_traceability_id_seq should exist');

SELECT * FROM finish();

ROLLBACK;
