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

-- Check view v_anl_connec
SELECT has_view('v_anl_connec'::name, 'View v_anl_connec should exist');

-- Check view columns
SELECT columns_are(
    'v_anl_connec',
    ARRAY[
        'id', 'connec_id', 'connecat_id', 'state', 'connec_id_aux', 'state_aux',
        'fprocesscat_id', 'expl_name', 'the_geom', 'result_id', 'descript'
    ],
    'View v_anl_connec should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_anl_connec', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_anl_connec', 'connec_id', 'varchar(16)', 'Column connec_id should be varchar(16)');
SELECT col_type_is('v_anl_connec', 'connecat_id', 'varchar(30)', 'Column connecat_id should be varchar(30)');
SELECT col_type_is('v_anl_connec', 'state', 'int4', 'Column state should be int4');
SELECT col_type_is('v_anl_connec', 'connec_id_aux', 'varchar(16)', 'Column connec_id_aux should be varchar(16)');
SELECT col_type_is('v_anl_connec', 'state_aux', 'varchar(30)', 'Column state_aux should be varchar(30)');
SELECT col_type_is('v_anl_connec', 'fprocesscat_id', 'int4', 'Column fprocesscat_id should be int4');
SELECT col_type_is('v_anl_connec', 'expl_name', 'varchar(100)', 'Column expl_name should be varchar(100)');
SELECT col_type_is('v_anl_connec', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('v_anl_connec', 'result_id', 'varchar(16)', 'Column result_id should be varchar(16)');
SELECT col_type_is('v_anl_connec', 'descript', 'text', 'Column descript should be text');

SELECT * FROM finish();

ROLLBACK;
