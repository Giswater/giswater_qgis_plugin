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

-- Check view v_audit_check_project
SELECT has_view('v_audit_check_project'::name, 'View v_audit_check_project should exist');

-- Check view columns
SELECT columns_are(
    'v_audit_check_project',
    ARRAY[
        'id', 'table_id', 'table_host', 'table_dbname', 'table_schema', 'fprocesscat_id',
        'criticity', 'enabled', 'message', 'tstamp', 'user_name', 'observ'
    ],
    'View v_audit_check_project should have the correct columns'
);

SELECT * FROM finish();

ROLLBACK;