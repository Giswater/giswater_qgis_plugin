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

-- Check view v_ui_om_visit_x_doc
SELECT has_view('v_ui_om_visit_x_doc'::name, 'View v_ui_om_visit_x_doc should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_om_visit_x_doc',
    ARRAY[
        'doc_id', 'visit_id'
    ],
    'View v_ui_om_visit_x_doc should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_om_visit_x_doc', 'doc_id', 'int4', 'Column doc_id should be int4');
SELECT col_type_is('v_ui_om_visit_x_doc', 'visit_id', 'int4', 'Column visit_id should be int4');

SELECT * FROM finish();

ROLLBACK;
