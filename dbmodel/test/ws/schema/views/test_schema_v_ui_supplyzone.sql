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

-- Check view v_ui_supplyzone
SELECT has_view('v_ui_supplyzone'::name, 'View v_ui_supplyzone should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_supplyzone',
    ARRAY[
        'supplyzone_id',
        'code',
        'name',
        'descript',
        'active',
        'supplyzone_type',
        'expl_id',
        'sector_id',
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
        'updated_by'
    ],
    'View v_ui_supplyzone should have the correct columns'
);


SELECT * FROM finish();

ROLLBACK;