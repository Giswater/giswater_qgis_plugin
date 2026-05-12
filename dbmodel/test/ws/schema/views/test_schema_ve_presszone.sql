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

-- Check view ve_presszone
SELECT has_view('ve_presszone'::name, 'View ve_presszone should exist');

-- Check view columns
SELECT columns_are(
    've_presszone',
    ARRAY[
        'presszone_id',
        'code',
        'name',
        'descript',
        'active',
        'presszone_type',
        'expl_id',
        'sector_id',
        'muni_id',
        'avg_press',
        'head',
        'graphconfig',
        'stylesheet',
        'lock_level',
        'link',
        'addparam',
        'created_at',
        'created_by',
        'updated_at',
        'updated_by',
        'the_geom'
    ],
    'View ve_presszone should have the correct columns'
);


SELECT * FROM finish();

ROLLBACK;