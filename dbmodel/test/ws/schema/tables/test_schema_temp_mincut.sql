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

-- Check table temp_mincut
SELECT has_table('temp_mincut'::name, 'Table temp_mincut should exist');

-- Check columns
SELECT columns_are(
    'temp_mincut',
    ARRAY[
        'id', 'source', 'target', 'cost', 'reverse_cost'
    ],
    'Table temp_mincut should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('temp_mincut', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('temp_mincut', 'id', 'bigint', 'Column id should be bigint');
SELECT col_type_is('temp_mincut', 'source', 'bigint', 'Column source should be bigint');
SELECT col_type_is('temp_mincut', 'target', 'bigint', 'Column target should be bigint');
SELECT col_type_is('temp_mincut', 'cost', 'smallint', 'Column cost should be smallint');
SELECT col_type_is('temp_mincut', 'reverse_cost', 'smallint', 'Column reverse_cost should be smallint');

-- Check default values
SELECT col_has_default('temp_mincut', 'id', 'Column id should have a default value');

SELECT * FROM finish();

ROLLBACK; 