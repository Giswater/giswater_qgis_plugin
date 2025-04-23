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

-- Check view v_edit_cad_auxline
SELECT has_view('v_edit_cad_auxline'::name, 'View v_edit_cad_auxline should exist');

-- Check view columns
SELECT columns_are(
    'v_edit_cad_auxline',
    ARRAY[
        'id', 'geom_line'
    ],
    'View v_edit_cad_auxline should have the correct columns'
);

-- Check if trigger exists
SELECT has_trigger('v_edit_cad_auxline', 'gw_trg_edit_cad_aux', 'Trigger gw_trg_edit_cad_aux should exist on v_edit_cad_auxline');

SELECT * FROM finish();

ROLLBACK;