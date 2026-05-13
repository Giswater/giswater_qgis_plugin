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

-- Check table
SELECT has_table('ext_region_x_province'::name, 'Table ext_region_x_province should exist');

-- Check columns
SELECT columns_are(
    'ext_region_x_province',
    ARRAY[
        'region_id', 'province_id'
    ],
    'Table ext_region_x_province should have the correct columns'
);

-- Check column types
SELECT col_type_is('ext_region_x_province', 'region_id', 'int4', 'Column region_id should be int4');
SELECT col_type_is('ext_region_x_province', 'province_id', 'int4', 'Column province_id should be int4');

-- Finish
SELECT * FROM finish();

ROLLBACK;
