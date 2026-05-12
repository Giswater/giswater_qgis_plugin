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

-- Check table plan_arc_x_pavement
SELECT has_table('plan_arc_x_pavement'::name, 'Table plan_arc_x_pavement should exist');

-- Check columns
SELECT columns_are(
    'plan_arc_x_pavement',
    ARRAY[
        'id', 'arc_id', 'pavcat_id', 'percent'
    ],
    'Table plan_arc_x_pavement should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('plan_arc_x_pavement', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('plan_arc_x_pavement', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('plan_arc_x_pavement', 'arc_id', 'integer', 'Column arc_id should be integer');
SELECT col_type_is('plan_arc_x_pavement', 'pavcat_id', 'varchar(16)', 'Column pavcat_id should be varchar(16)');
SELECT col_type_is('plan_arc_x_pavement', 'percent', 'numeric(3,2)', 'Column percent should be numeric(3,2)');

-- Check foreign keys
SELECT has_fk('plan_arc_x_pavement', 'Table plan_arc_x_pavement should have foreign keys');
SELECT fk_ok('plan_arc_x_pavement', 'arc_id', 'arc', 'arc_id', 'FK arc_id should reference arc.arc_id');
SELECT fk_ok('plan_arc_x_pavement', 'pavcat_id', 'cat_pavement', 'id', 'FK pavcat_id should reference cat_pavement.id');

-- Check constraints
SELECT col_not_null('plan_arc_x_pavement', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('plan_arc_x_pavement', 'arc_id', 'Column arc_id should be NOT NULL');
SELECT col_not_null('plan_arc_x_pavement', 'percent', 'Column percent should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;