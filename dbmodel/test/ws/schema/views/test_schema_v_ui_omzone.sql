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

-- Check view v_ui_omzone
SELECT has_view('v_ui_omzone'::name, 'View v_ui_omzone should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_omzone',
    ARRAY[
        'omzone_id', 'code', 'name', 'descript', 'active', 'omzone_type',
        'macroomzone', 'expl_id', 'sector_id', 'muni_id', 'graphconfig', 'stylesheet',
        'lock_level', 'link', 'addparam', 'created_at', 'created_by', 'updated_at',
        'updated_by'
    ],
    'View v_ui_omzone should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_omzone', 'omzone_id', 'int4', 'Column omzone_id should be int4');
SELECT col_type_is('v_ui_omzone', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('v_ui_omzone', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('v_ui_omzone', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('v_ui_omzone', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('v_ui_omzone', 'omzone_type', 'varchar(100)', 'Column omzone_type should be varchar(100)');
SELECT col_type_is('v_ui_omzone', 'macroomzone', 'varchar(100)', 'Column macroomzone should be varchar(100)');
SELECT col_type_is('v_ui_omzone', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('v_ui_omzone', 'sector_id', 'int4[]', 'Column sector_id should be int4[]');
SELECT col_type_is('v_ui_omzone', 'muni_id', 'int4[]', 'Column muni_id should be int4[]');
SELECT col_type_is('v_ui_omzone', 'graphconfig', 'json', 'Column graphconfig should be json');
SELECT col_type_is('v_ui_omzone', 'stylesheet', 'json', 'Column stylesheet should be json');
SELECT col_type_is('v_ui_omzone', 'lock_level', 'int4', 'Column lock_level should be int4');
SELECT col_type_is('v_ui_omzone', 'link', 'text', 'Column link should be text');
SELECT col_type_is('v_ui_omzone', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('v_ui_omzone', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('v_ui_omzone', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('v_ui_omzone', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('v_ui_omzone', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');

SELECT * FROM finish();

ROLLBACK;
