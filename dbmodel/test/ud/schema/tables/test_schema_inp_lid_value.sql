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
SELECT has_table('inp_lid_value'::name, 'Table inp_lid_value should exist');

-- Check columns
SELECT columns_are(
    'inp_lid_value',
    ARRAY[
        'id', 'lidco_id', 'lidlayer', 'value_2', 'value_3', 'value_4',
        'value_5', 'value_6', 'value_7', 'value_8'
    ],
    'Table inp_lid_value should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_lid_value', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('inp_lid_value', 'lidco_id', 'varchar(16)', 'Column lidco_id should be varchar(16)');
SELECT col_type_is('inp_lid_value', 'lidlayer', 'varchar(10)', 'Column lidlayer should be varchar(10)');
SELECT col_type_is('inp_lid_value', 'value_2', 'numeric(12,4)', 'Column value_2 should be numeric(12,4)');
SELECT col_type_is('inp_lid_value', 'value_3', 'numeric(12,4)', 'Column value_3 should be numeric(12,4)');
SELECT col_type_is('inp_lid_value', 'value_4', 'numeric(12,4)', 'Column value_4 should be numeric(12,4)');
SELECT col_type_is('inp_lid_value', 'value_5', 'numeric(12,4)', 'Column value_5 should be numeric(12,4)');
SELECT col_type_is('inp_lid_value', 'value_6', 'text', 'Column value_6 should be text');
SELECT col_type_is('inp_lid_value', 'value_7', 'text', 'Column value_7 should be text');
SELECT col_type_is('inp_lid_value', 'value_8', 'text', 'Column value_8 should be text');

-- Check foreign keys
SELECT has_fk('inp_lid_value', 'Table inp_lid_value should have foreign keys');

SELECT fk_ok('inp_lid_value', 'lidco_id', 'inp_lid', 'lidco_id', 'FK lidco_id → inp_lid.lidco_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
