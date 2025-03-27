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

-- Check table audit_fid_log
SELECT has_table('audit_fid_log'::name, 'Table audit_fid_log should exist');

-- Check columns
SELECT columns_are(
    'audit_fid_log',
    ARRAY[
        'id', 'fid', 'fcount', 'groupby', 'criticity', 'tstamp'
    ],
    'Table audit_fid_log should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('audit_fid_log', 'id', 'Column id should be primary key');

-- Check column types
SELECT col_type_is('audit_fid_log', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('audit_fid_log', 'fid', 'smallint', 'Column fid should be smallint');
SELECT col_type_is('audit_fid_log', 'fcount', 'integer', 'Column fcount should be integer');
SELECT col_type_is('audit_fid_log', 'groupby', 'text', 'Column groupby should be text');
SELECT col_type_is('audit_fid_log', 'criticity', 'integer', 'Column criticity should be integer');
SELECT col_type_is('audit_fid_log', 'tstamp', 'timestamp without time zone', 'Column tstamp should be timestamp');

-- Check foreign keys
SELECT hasnt_fk('audit_fid_log', 'Table audit_fid_log should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('audit_fid_log_id_seq', 'Sequence audit_fid_log_id_seq should exist');

SELECT * FROM finish();

ROLLBACK;
