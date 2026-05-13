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
SELECT has_table('sys_label'::name, 'Table sys_label should exist');

-- Check columns
SELECT columns_are(
    'sys_label',
    ARRAY[
        'id', 'idval', 'label_type'
    ],
    'Table sys_label should have the correct columns'
);

-- Check column types
SELECT col_type_is('sys_label', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('sys_label', 'idval', 'text', 'Column idval should be text');
SELECT col_type_is('sys_label', 'label_type', 'text', 'Column label_type should be text');

-- Finish
SELECT * FROM finish();

ROLLBACK;
