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

-- Check table sys_version
SELECT has_table('sys_version'::name, 'Table sys_version should exist');

-- Check columns
SELECT columns_are(
    'sys_version',
    ARRAY[
        'id', 'giswater', 'project_type', 'postgres', 'postgis', 'date', 'language', 'epsg'
    ],
    'Table sys_version should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('sys_version', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('sys_version', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('sys_version', 'giswater', 'character varying(16)', 'Column giswater should be character varying(16)');
SELECT col_type_is('sys_version', 'project_type', 'character varying(16)', 'Column project_type should be character varying(16)');
SELECT col_type_is('sys_version', 'postgres', 'character varying(512)', 'Column postgres should be character varying(512)');
SELECT col_type_is('sys_version', 'postgis', 'character varying(512)', 'Column postgis should be character varying(512)');
SELECT col_type_is('sys_version', 'date', 'timestamp(6) without time zone', 'Column date should be timestamp(6) without time zone');
SELECT col_type_is('sys_version', 'language', 'character varying(50)', 'Column language should be character varying(50)');
SELECT col_type_is('sys_version', 'epsg', 'integer', 'Column epsg should be integer');

-- Check default values
SELECT col_has_default('sys_version', 'id', 'Column id should have a default value');
SELECT col_default_is('sys_version', 'date', 'now()', 'Column date should default to now()');

-- Check constraints
SELECT col_not_null('sys_version', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('sys_version', 'giswater', 'Column giswater should be NOT NULL');
SELECT col_not_null('sys_version', 'project_type', 'Column project_type should be NOT NULL');
SELECT col_not_null('sys_version', 'postgres', 'Column postgres should be NOT NULL');
SELECT col_not_null('sys_version', 'postgis', 'Column postgis should be NOT NULL');
SELECT col_not_null('sys_version', 'date', 'Column date should be NOT NULL');
SELECT col_not_null('sys_version', 'language', 'Column language should be NOT NULL');
SELECT col_not_null('sys_version', 'epsg', 'Column epsg should be NOT NULL');

SELECT * FROM finish();

ROLLBACK; 