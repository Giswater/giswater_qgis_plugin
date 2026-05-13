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

-- Check view v_plan_aux_arc_pavement
SELECT has_view('v_plan_aux_arc_pavement'::name, 'View v_plan_aux_arc_pavement should exist');

-- Check view columns
SELECT columns_are(
    'v_plan_aux_arc_pavement',
    ARRAY[
        'arc_id', 'thickness', 'm2pav_cost', 'pavcat_id', 'percent', 'price_id'
    ],
    'View v_plan_aux_arc_pavement should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_plan_aux_arc_pavement', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('v_plan_aux_arc_pavement', 'thickness', 'numeric(12,2)', 'Column thickness should be numeric(12,2)');
SELECT col_type_is('v_plan_aux_arc_pavement', 'm2pav_cost', 'numeric', 'Column m2pav_cost should be numeric');
SELECT col_type_is('v_plan_aux_arc_pavement', 'pavcat_id', 'varchar', 'Column pavcat_id should be varchar');
SELECT col_type_is('v_plan_aux_arc_pavement', 'percent', 'int4', 'Column percent should be int4');
SELECT col_type_is('v_plan_aux_arc_pavement', 'price_id', 'varchar', 'Column price_id should be varchar');

SELECT * FROM finish();

ROLLBACK;
