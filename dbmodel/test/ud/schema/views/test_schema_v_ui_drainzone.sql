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

-- Check view v_ui_drainzone
SELECT has_view('v_ui_drainzone'::name, 'View v_ui_drainzone should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_drainzone',
    ARRAY[
        'drainzone_id', 'code', 'name', 'descript', 'active', 'drainzone_type',
        'expl_id', 'sector_id', 'muni_id', 'graphconfig', 'stylesheet', 'lock_level',
        'link', 'addparam', 'created_at', 'created_by', 'updated_at', 'updated_by'
    ],
    'View v_ui_drainzone should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_drainzone', 'drainzone_id', 'int4', 'Column drainzone_id should be int4');
SELECT col_type_is('v_ui_drainzone', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('v_ui_drainzone', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('v_ui_drainzone', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('v_ui_drainzone', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('v_ui_drainzone', 'drainzone_type', 'varchar(100)', 'Column drainzone_type should be varchar(100)');
SELECT col_type_is('v_ui_drainzone', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('v_ui_drainzone', 'sector_id', 'int4[]', 'Column sector_id should be int4[]');
SELECT col_type_is('v_ui_drainzone', 'muni_id', 'int4[]', 'Column muni_id should be int4[]');
SELECT col_type_is('v_ui_drainzone', 'graphconfig', 'text', 'Column graphconfig should be text');
SELECT col_type_is('v_ui_drainzone', 'stylesheet', 'text', 'Column stylesheet should be text');
SELECT col_type_is('v_ui_drainzone', 'lock_level', 'int4', 'Column lock_level should be int4');
SELECT col_type_is('v_ui_drainzone', 'link', 'text', 'Column link should be text');
SELECT col_type_is('v_ui_drainzone', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('v_ui_drainzone', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('v_ui_drainzone', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('v_ui_drainzone', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('v_ui_drainzone', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');

SELECT * FROM finish();

ROLLBACK;
