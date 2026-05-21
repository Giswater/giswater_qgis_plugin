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

-- Check view v_ui_dwfzone
SELECT has_view('v_ui_dwfzone'::name, 'View v_ui_dwfzone should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_dwfzone',
    ARRAY[
        'dwfzone_id', 'code', 'name', 'descript', 'active', 'dwfzone_type',
        'drainzone', 'expl_id', 'sector_id', 'muni_id', 'graphconfig', 'stylesheet',
        'lock_level', 'link', 'addparam', 'created_at', 'created_by', 'updated_at',
        'updated_by'
    ],
    'View v_ui_dwfzone should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_dwfzone', 'dwfzone_id', 'int4', 'Column dwfzone_id should be int4');
SELECT col_type_is('v_ui_dwfzone', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('v_ui_dwfzone', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('v_ui_dwfzone', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('v_ui_dwfzone', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('v_ui_dwfzone', 'dwfzone_type', 'varchar(100)', 'Column dwfzone_type should be varchar(100)');
SELECT col_type_is('v_ui_dwfzone', 'drainzone', 'varchar(100)', 'Column drainzone should be varchar(100)');
SELECT col_type_is('v_ui_dwfzone', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('v_ui_dwfzone', 'sector_id', 'int4[]', 'Column sector_id should be int4[]');
SELECT col_type_is('v_ui_dwfzone', 'muni_id', 'int4[]', 'Column muni_id should be int4[]');
SELECT col_type_is('v_ui_dwfzone', 'graphconfig', 'text', 'Column graphconfig should be text');
SELECT col_type_is('v_ui_dwfzone', 'stylesheet', 'text', 'Column stylesheet should be text');
SELECT col_type_is('v_ui_dwfzone', 'lock_level', 'int4', 'Column lock_level should be int4');
SELECT col_type_is('v_ui_dwfzone', 'link', 'text', 'Column link should be text');
SELECT col_type_is('v_ui_dwfzone', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('v_ui_dwfzone', 'created_at', 'timestamp without time zone', 'Column created_at should be timestamp without time zone');
SELECT col_type_is('v_ui_dwfzone', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('v_ui_dwfzone', 'updated_at', 'timestamp without time zone', 'Column updated_at should be timestamp without time zone');
SELECT col_type_is('v_ui_dwfzone', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');

SELECT * FROM finish();

ROLLBACK;
