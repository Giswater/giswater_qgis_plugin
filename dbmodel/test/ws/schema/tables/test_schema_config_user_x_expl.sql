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

-- Check table config_user_x_expl
SELECT has_table('config_user_x_expl'::name, 'Table config_user_x_expl should exist');

-- Check columns
SELECT columns_are(
    'config_user_x_expl',
    ARRAY[
        'expl_id', 'username'
    ],
    'Table config_user_x_expl should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('config_user_x_expl', ARRAY['expl_id', 'username'], 'Columns expl_id, username should be primary key');

-- Check column types
SELECT col_type_is('config_user_x_expl', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('config_user_x_expl', 'username', 'varchar(50)', 'Column username should be varchar(50)');

-- Check foreign keys
SELECT has_fk('config_user_x_expl', 'Table config_user_x_expl should have foreign keys');
SELECT fk_ok('config_user_x_expl', 'expl_id', 'exploitation', 'expl_id', 'FK config_user_x_expl_expl_id_fkey should exist');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('config_user_x_expl', 'expl_id', 'Column expl_id should be NOT NULL');
SELECT col_not_null('config_user_x_expl', 'username', 'Column username should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
