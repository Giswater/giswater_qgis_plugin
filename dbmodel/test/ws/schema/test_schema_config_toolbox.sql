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

-- Check table config_toolbox
SELECT has_table('config_toolbox'::name, 'Table config_toolbox should exist');

-- Check columns
SELECT columns_are(
    'config_toolbox',
    ARRAY[
        'id', 'alias', 'functionparams', 'inputparams', 'observ', 'active', 'device'
    ],
    'Table config_toolbox should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('config_toolbox', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('config_toolbox', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('config_toolbox', 'alias', 'text', 'Column alias should be text');
SELECT col_type_is('config_toolbox', 'functionparams', 'json', 'Column functionparams should be json');
SELECT col_type_is('config_toolbox', 'inputparams', 'json', 'Column inputparams should be json');
SELECT col_type_is('config_toolbox', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('config_toolbox', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('config_toolbox', 'device', '_int4', 'Column device should be _int4');

-- Check foreign keys
SELECT has_fk('config_toolbox', 'Table config_toolbox should have foreign keys');
SELECT fk_ok('config_toolbox', 'id', 'sys_function', 'id', 'FK config_toolbox_id_fkey should exist');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('config_toolbox', 'id', 'Column id should be NOT NULL');
SELECT col_default_is('config_toolbox', 'active', 'true', 'Column active should default to true');

SELECT * FROM finish();

ROLLBACK;
