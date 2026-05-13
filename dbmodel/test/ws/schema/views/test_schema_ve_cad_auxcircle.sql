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

-- Check column types
SELECT col_type_is('ve_cad_auxcircle', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('ve_cad_auxcircle', 'geom_multicurve', 'geometry(multicurve, SRID_VALUE)', 'Column geom_multicurve should be geometry(multicurve, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
