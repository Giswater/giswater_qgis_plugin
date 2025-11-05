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

-- Check view ve_omzone
SELECT has_view('ve_omzone'::name, 'View ve_omzone should exist');

-- Check view columns
SELECT columns_are(
    've_omzone',
    ARRAY[
        'omzone_id',
        'code',
        'name',
        'descript',
        'active',
        'omzone_type',
        'macroomzone_id',
        'expl_id',
        'sector_id',
        'muni_id',
        'graphconfig',
        'stylesheet',
        'lock_level',
        'link',
        'the_geom',
        'addparam',
        'created_at',
        'created_by',
        'updated_at',
        'updated_by',
    ],
    'View ve_omzone should have the correct columns'
);


SELECT * FROM finish();

ROLLBACK;