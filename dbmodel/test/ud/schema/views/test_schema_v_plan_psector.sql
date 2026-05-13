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

-- Check view v_plan_psector
SELECT has_view('v_plan_psector'::name, 'View v_plan_psector should exist');

-- Check view columns
SELECT columns_are(
    'v_plan_psector',
    ARRAY[
        'psector_id', 'name', 'psector_type', 'descript', 'priority', 'total_arc',
        'total_node', 'total_other', 'text1', 'text2', 'observ', 'rotation',
        'scale', 'active', 'pem', 'gexpenses', 'pec', 'vat',
        'pec_vat', 'other', 'pca', 'the_geom'
    ],
    'View v_plan_psector should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_plan_psector', 'psector_id', 'int4', 'Column psector_id should be int4');
SELECT col_type_is('v_plan_psector', 'name', 'varchar(50)', 'Column name should be varchar(50)');
SELECT col_type_is('v_plan_psector', 'psector_type', 'int4', 'Column psector_type should be int4');
SELECT col_type_is('v_plan_psector', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('v_plan_psector', 'priority', 'varchar(16)', 'Column priority should be varchar(16)');
SELECT col_type_is('v_plan_psector', 'total_arc', 'numeric(14,2)', 'Column total_arc should be numeric(14,2)');
SELECT col_type_is('v_plan_psector', 'total_node', 'numeric(14,2)', 'Column total_node should be numeric(14,2)');
SELECT col_type_is('v_plan_psector', 'total_other', 'numeric(14,2)', 'Column total_other should be numeric(14,2)');
SELECT col_type_is('v_plan_psector', 'text1', 'text', 'Column text1 should be text');
SELECT col_type_is('v_plan_psector', 'text2', 'text', 'Column text2 should be text');
SELECT col_type_is('v_plan_psector', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('v_plan_psector', 'rotation', 'numeric(8,4)', 'Column rotation should be numeric(8,4)');
SELECT col_type_is('v_plan_psector', 'scale', 'numeric(8,2)', 'Column scale should be numeric(8,2)');
SELECT col_type_is('v_plan_psector', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('v_plan_psector', 'pem', 'numeric(14,2)', 'Column pem should be numeric(14,2)');
SELECT col_type_is('v_plan_psector', 'gexpenses', 'numeric(4,2)', 'Column gexpenses should be numeric(4,2)');
SELECT col_type_is('v_plan_psector', 'pec', 'numeric(14,2)', 'Column pec should be numeric(14,2)');
SELECT col_type_is('v_plan_psector', 'vat', 'numeric(4,2)', 'Column vat should be numeric(4,2)');
SELECT col_type_is('v_plan_psector', 'pec_vat', 'numeric(14,2)', 'Column pec_vat should be numeric(14,2)');
SELECT col_type_is('v_plan_psector', 'other', 'numeric(4,2)', 'Column other should be numeric(4,2)');
SELECT col_type_is('v_plan_psector', 'pca', 'numeric(14,2)', 'Column pca should be numeric(14,2)');
SELECT col_type_is('v_plan_psector', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
