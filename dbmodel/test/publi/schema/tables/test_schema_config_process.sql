/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

BEGIN;

SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

SELECT has_table('config_process'::name, 'Table config_process should exist');

SELECT columns_are(
    'config_process',
    ARRAY[
        'function_name', 'description', 'selector_config', 'active'
    ],
    'Table config_process should have the correct columns'
);

SELECT col_type_is('config_process', 'function_name', 'text', 'Column function_name should be text');
SELECT col_type_is('config_process', 'description', 'text', 'Column description should be text');
SELECT col_type_is('config_process', 'selector_config', 'jsonb', 'Column selector_config should be jsonb');
SELECT col_type_is('config_process', 'active', 'bool', 'Column active should be bool');

SELECT has_pk('config_process', 'Table config_process should have a primary key on function_name');

SELECT * FROM finish();

ROLLBACK;
