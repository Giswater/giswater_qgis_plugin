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

-- Check view v_value_relation
SELECT has_view('v_value_relation'::name, 'View v_value_relation should exist');

-- Check view columns
SELECT columns_are(
    'v_value_relation',
    ARRAY[
        'rid', 'typevalue', 'id', 'idval'
    ],
    'View v_value_relation should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_value_relation', 'rid', 'int8', 'Column rid should be int8');
SELECT col_type_is('v_value_relation', 'typevalue', 'varchar(50)', 'Column typevalue should be varchar(50)');
SELECT col_type_is('v_value_relation', 'id', 'varchar(30)', 'Column id should be varchar(30)');
SELECT col_type_is('v_value_relation', 'idval', 'varchar(100)', 'Column idval should be varchar(100)');

SELECT * FROM finish();

ROLLBACK;
