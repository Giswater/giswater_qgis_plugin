/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check table sys_image
SELECT has_table('sys_image'::name, 'Table sys_image should exist');

-- Check columns
SELECT columns_are(
    'sys_image',
    ARRAY[
        'id', 'idval', 'image'
    ],
    'Table sys_image should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('sys_image', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('sys_image', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('sys_image', 'idval', 'text', 'Column idval should be text');
SELECT col_type_is('sys_image', 'image', 'bytea', 'Column image should be bytea');

-- Check default values
SELECT col_has_default('sys_image', 'id', 'Column id should have a default value');

-- Check constraints
SELECT col_not_null('sys_image', 'id', 'Column id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK; 