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

-- Check view ve_cad_auxcircle
SELECT has_view('ve_cad_auxcircle'::name, 'View ve_cad_auxcircle should exist');

-- Check view columns
SELECT columns_are(
    've_cad_auxcircle',
    ARRAY[
        'id', 'geom_multicurve'
    ],
    'View ve_cad_auxcircle should have the correct columns'
);

-- Check if trigger exists
SELECT has_trigger('ve_cad_auxcircle', 'gw_trg_edit_cad_aux', 'Trigger gw_trg_edit_cad_aux should exist on ve_cad_auxcircle');

SELECT * FROM finish();

ROLLBACK;