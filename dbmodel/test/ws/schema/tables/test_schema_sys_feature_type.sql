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

-- Check table sys_feature_type
SELECT has_table('sys_feature_type'::name, 'Table sys_feature_type should exist');

-- Check columns
SELECT columns_are(
    'sys_feature_type',
    ARRAY[
        'id', 'classlevel'
    ],
    'Table sys_feature_type should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('sys_feature_type', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('sys_feature_type', 'id', 'character varying(30)', 'Column id should be character varying(30)');
SELECT col_type_is('sys_feature_type', 'classlevel', 'smallint', 'Column classlevel should be smallint');

-- Check constraints
SELECT col_not_null('sys_feature_type', 'id', 'Column id should be NOT NULL');
SELECT col_has_check('sys_feature_type', 'id', 'Table sys_feature_type should have check constraint on id');

SELECT * FROM finish();

ROLLBACK;