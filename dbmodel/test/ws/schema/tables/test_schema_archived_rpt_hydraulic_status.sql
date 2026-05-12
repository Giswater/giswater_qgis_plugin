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

-- Check table archived_rpt_hydraulic_status
SELECT has_table('archived_rpt_hydraulic_status'::name, 'Table archived_rpt_hydraulic_status should exist');

-- Check columns
SELECT columns_are(
    'archived_rpt_hydraulic_status',
    ARRAY[
        'id', 'result_id', 'time', 'text'
    ],
    'Table archived_rpt_hydraulic_status should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('archived_rpt_hydraulic_status', 'id', 'Column id should be primary key');

-- Check column types
SELECT col_type_is('archived_rpt_hydraulic_status', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('archived_rpt_hydraulic_status', 'result_id', 'character varying(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('archived_rpt_hydraulic_status', 'time', 'character varying(20)', 'Column time should be varchar(20)');
SELECT col_type_is('archived_rpt_hydraulic_status', 'text', 'text', 'Column text should be text');

-- Check foreign keys
SELECT hasnt_fk('archived_rpt_hydraulic_status', 'Table archived_rpt_hydraulic_status should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('archived_rpt_hydraulic_status_id_seq', 'Sequence archived_rpt_hydraulic_status_id_seq should exist');

SELECT * FROM finish();

ROLLBACK;
