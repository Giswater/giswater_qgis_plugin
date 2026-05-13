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

-- Check view v_ui_doc
SELECT has_view('v_ui_doc'::name, 'View v_ui_doc should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_doc',
    ARRAY[
        'id', 'name', 'observ', 'doc_type', 'path', 'date',
        'user_name', 'tstamp'
    ],
    'View v_ui_doc should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_doc', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_ui_doc', 'name', 'varchar(30)', 'Column name should be varchar(30)');
SELECT col_type_is('v_ui_doc', 'observ', 'varchar(512)', 'Column observ should be varchar(512)');
SELECT col_type_is('v_ui_doc', 'doc_type', 'varchar(30)', 'Column doc_type should be varchar(30)');
SELECT col_type_is('v_ui_doc', 'path', 'varchar(512)', 'Column path should be varchar(512)');
SELECT col_type_is('v_ui_doc', 'date', 'timestamp(6) without time zone', 'Column date should be timestamp(6) without time zone');
SELECT col_type_is('v_ui_doc', 'user_name', 'varchar(50)', 'Column user_name should be varchar(50)');
SELECT col_type_is('v_ui_doc', 'tstamp', 'timestamp without time zone', 'Column tstamp should be timestamp without time zone');

SELECT * FROM finish();

ROLLBACK;
