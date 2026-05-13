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
SELECT has_table('inp_frvalve'::name, 'Table inp_frvalve should exist');

-- Check columns
SELECT columns_are(
    'inp_frvalve',
    ARRAY[
        'element_id', 'valve_type', 'custom_dint', 'setting', 'curve_id', 'minorloss',
        'add_settings', 'init_quality', 'status'
    ],
    'Table inp_frvalve should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_frvalve', 'element_id', 'int4', 'Column element_id should be int4');
SELECT col_type_is('inp_frvalve', 'valve_type', 'varchar(18)', 'Column valve_type should be varchar(18)');
SELECT col_type_is('inp_frvalve', 'custom_dint', 'numeric(12,4)', 'Column custom_dint should be numeric(12,4)');
SELECT col_type_is('inp_frvalve', 'setting', 'numeric(12,4)', 'Column setting should be numeric(12,4)');
SELECT col_type_is('inp_frvalve', 'curve_id', 'varchar(16)', 'Column curve_id should be varchar(16)');
SELECT col_type_is('inp_frvalve', 'minorloss', 'numeric(12,4)', 'Column minorloss should be numeric(12,4)');
SELECT col_type_is('inp_frvalve', 'add_settings', 'float8', 'Column add_settings should be float8');
SELECT col_type_is('inp_frvalve', 'init_quality', 'float8', 'Column init_quality should be float8');
SELECT col_type_is('inp_frvalve', 'status', 'varchar(16)', 'Column status should be varchar(16)');

-- Check foreign keys
SELECT has_fk('inp_frvalve', 'Table inp_frvalve should have foreign keys');

SELECT fk_ok('inp_frvalve', 'curve_id', 'inp_curve', 'id', 'FK curve_id → inp_curve.id');
SELECT fk_ok('inp_frvalve', 'element_id', 'element', 'element_id', 'FK element_id → element.element_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
