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

-- Check view exists
SELECT has_view('v_anl_arc'::name, 'View v_anl_arc should exist');

-- Check view columns
SELECT columns_are('v_anl_arc', ARRAY[
    'id',
    'arc_id',
    'arc_type',
    'state',
    'arc_id_aux',
    'fprocesscat_id',
    'expl_name',
    'the_geom',
    'result_id',
    'descript'
], 'View v_anl_arc should have the correct columns');

SELECT * FROM finish();

ROLLBACK;
