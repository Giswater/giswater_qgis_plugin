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
SELECT has_table('selector_inp_dscenario'::name, 'Table selector_inp_dscenario should exist');

-- Check columns
SELECT columns_are(
    'selector_inp_dscenario',
    ARRAY[
        'dscenario_id', 'cur_user'
    ],
    'Table selector_inp_dscenario should have the correct columns'
);

-- Check column types
SELECT col_type_is('selector_inp_dscenario', 'dscenario_id', 'int4', 'Column dscenario_id should be int4');
SELECT col_type_is('selector_inp_dscenario', 'cur_user', 'text', 'Column cur_user should be text');

-- Check foreign keys
SELECT has_fk('selector_inp_dscenario', 'Table selector_inp_dscenario should have foreign keys');

SELECT fk_ok('selector_inp_dscenario', 'dscenario_id', 'cat_dscenario', 'dscenario_id', 'FK dscenario_id → cat_dscenario.dscenario_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
