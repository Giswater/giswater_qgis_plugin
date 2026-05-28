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
SELECT has_table('sys_version'::name, 'Table sys_version should exist');

-- Check columns
SELECT columns_are(
    'sys_version',
    ARRAY[
        'id', 'giswater', 'project_type', 'postgres', 'postgis', 'date',
        'language', 'epsg', 'addparam'
    ],
    'Table sys_version should have the correct columns'
);

-- Check column types
SELECT col_type_is('sys_version', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('sys_version', 'giswater', 'varchar(16)', 'Column giswater should be varchar(16)');
SELECT col_type_is('sys_version', 'project_type', 'varchar(16)', 'Column project_type should be varchar(16)');
SELECT col_type_is('sys_version', 'postgres', 'varchar(512)', 'Column postgres should be varchar(512)');
SELECT col_type_is('sys_version', 'postgis', 'varchar(512)', 'Column postgis should be varchar(512)');
SELECT col_type_is('sys_version', 'date', 'timestamp(6) without time zone', 'Column date should be timestamp(6) without time zone');
SELECT col_type_is('sys_version', 'language', 'varchar(50)', 'Column language should be varchar(50)');
SELECT col_type_is('sys_version', 'epsg', 'int4', 'Column epsg should be int4');
SELECT col_type_is('sys_version', 'addparam', 'jsonb', 'Column addparam should be jsonb');

-- Finish
SELECT * FROM finish();

ROLLBACK;
