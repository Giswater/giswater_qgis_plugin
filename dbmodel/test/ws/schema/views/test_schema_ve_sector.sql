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

-- Check view ve_sector
SELECT has_view('ve_sector'::name, 'View ve_sector should exist');

-- Check view columns
SELECT columns_are(
    've_sector',
    ARRAY[
        'sector_id',
        'code',
        'name',
        'descript',
        'active',
        'sector_type',
        'macrosector_id',
        'expl_id',
        'muni_id',
        'avg_press',
        'pattern_id',
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
    'View ve_sector should have the correct columns'
);


SELECT * FROM finish();

ROLLBACK;