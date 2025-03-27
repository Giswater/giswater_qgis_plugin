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

-- Check view v_edit_anl_hydrant
SELECT has_view('v_edit_anl_hydrant'::name, 'View v_edit_anl_hydrant should exist');

-- Check view columns
SELECT columns_are(
    'v_edit_anl_hydrant',
    ARRAY[
        'node_id', 'nodecat_id', 'expl_id', 'the_geom'
    ],
    'View v_edit_anl_hydrant should have the correct columns'
);

-- Check if trigger exists
SELECT has_trigger('v_edit_anl_hydrant', 'gw_trg_edit_anl_hydrant', 'Trigger gw_trg_edit_anl_hydrant should exist on v_edit_anl_hydrant');

SELECT * FROM finish();

ROLLBACK;