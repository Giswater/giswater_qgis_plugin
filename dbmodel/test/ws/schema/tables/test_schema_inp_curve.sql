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

-- Check table inp_curve
SELECT has_table('inp_curve'::name, 'Table inp_curve should exist');

-- Check columns
SELECT columns_are(
    'inp_curve',
    ARRAY[
        'id', 'curve_type', 'descript', 'expl_id', 'log', 'active'
    ],
    'Table inp_curve should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('inp_curve', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('inp_curve', 'id', 'varchar(16)', 'Column id should be varchar(16)');
SELECT col_type_is('inp_curve', 'curve_type', 'varchar(20)', 'Column curve_type should be varchar(20)');
SELECT col_type_is('inp_curve', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('inp_curve', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('inp_curve', 'log', 'text', 'Column log should be text');
SELECT col_type_is('inp_curve', 'active', 'boolean', 'Column active should be boolean');

-- Check foreign keys
SELECT has_fk('inp_curve', 'Table inp_curve should have foreign keys');
SELECT fk_ok('inp_curve', 'expl_id', 'exploitation', 'expl_id', 'FK expl_id should reference exploitation.expl_id');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('inp_curve', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('inp_curve', 'curve_type', 'Column curve_type should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
