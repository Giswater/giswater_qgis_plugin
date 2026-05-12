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

-- Check view v_ui_macroomzone
SELECT has_view('v_ui_macroomzone'::name, 'View v_ui_macroomzone should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_macroomzone',
    ARRAY[
        'macroomzone_id',
        'code',
        'name',
        'descript',
        'active',
        'expl_id',
        'sector_id',
        'muni_id',
        'stylesheet',
        'lock_level',
        'link',
        'addparam',
        'created_at',
        'created_by',
        'updated_at',
        'updated_by'
    ],
    'View v_ui_macroomzone should have the correct columns'
);


SELECT * FROM finish();

ROLLBACK;