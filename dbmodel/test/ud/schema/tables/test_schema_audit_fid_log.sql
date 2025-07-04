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

-- Check table
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
SELECT col_type_is('audit_fid_log', 'id', 'serial4', 'Column id should be serial4');
SELECT col_type_is('audit_fid_log', 'fid', 'int2', 'Column fid should be int2');
SELECT col_type_is('audit_fid_log', 'fcount', 'int4', 'Column fcount should be int4');
SELECT col_type_is('audit_fid_log', 'groupby', 'text', 'Column groupby should be text');
SELECT col_type_is('audit_fid_log', 'criticity', 'int4', 'Column criticity should be int4');
SELECT col_type_is('audit_fid_log', 'tstamp', 'timestamp', 'Column tstamp should be timestamp');

-- Check default values
SELECT col_has_default('audit_fid_log', 'tstamp', 'Column tstamp should have default value');

-- Check indexes
SELECT has_index('audit_fid_log', 'id', 'Table should have index on id');

-- Finish
SELECT * FROM finish();

ROLLBACK;