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
SELECT has_table('sys_feature_type'::name, 'Table sys_feature_type should exist');

-- Check columns
SELECT columns_are(
    'sys_feature_type',
    ARRAY[
        'id', 'classlevel'
    ],
    'Table sys_feature_type should have the correct columns'
);

-- Check column types
SELECT col_type_is('sys_feature_type', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('sys_feature_type', 'classlevel', 'int2', 'Column classlevel should be int2');

-- Finish
SELECT * FROM finish();

ROLLBACK;
