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

-- Check view v_ui_doc_x_connec
SELECT has_view('v_ui_doc_x_connec'::name, 'View v_ui_doc_x_connec should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_doc_x_connec',
    ARRAY[
        'doc_id', 'connec_id', 'doc_name', 'doc_type', 'path', 'observ',
        'date', 'user_name', 'connec_uuid'
    ],
    'View v_ui_doc_x_connec should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_doc_x_connec', 'doc_id', 'int4', 'Column doc_id should be int4');
SELECT col_type_is('v_ui_doc_x_connec', 'connec_id', 'int4', 'Column connec_id should be int4');
SELECT col_type_is('v_ui_doc_x_connec', 'doc_name', 'varchar(30)', 'Column doc_name should be varchar(30)');
SELECT col_type_is('v_ui_doc_x_connec', 'doc_type', 'varchar(30)', 'Column doc_type should be varchar(30)');
SELECT col_type_is('v_ui_doc_x_connec', 'path', 'varchar(512)', 'Column path should be varchar(512)');
SELECT col_type_is('v_ui_doc_x_connec', 'observ', 'varchar(512)', 'Column observ should be varchar(512)');
SELECT col_type_is('v_ui_doc_x_connec', 'date', 'timestamp(6) without time zone', 'Column date should be timestamp(6) without time zone');
SELECT col_type_is('v_ui_doc_x_connec', 'user_name', 'varchar(50)', 'Column user_name should be varchar(50)');
SELECT col_type_is('v_ui_doc_x_connec', 'connec_uuid', 'uuid', 'Column connec_uuid should be uuid');

SELECT * FROM finish();

ROLLBACK;
