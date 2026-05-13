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
SELECT has_table('ext_timeseries'::name, 'Table ext_timeseries should exist');

-- Check columns
SELECT columns_are(
    'ext_timeseries',
    ARRAY[
        'id', 'code', 'operator_id', 'catalog_id', 'element', 'param',
        'period', 'timestep', 'val', 'descript'
    ],
    'Table ext_timeseries should have the correct columns'
);

-- Check column types
SELECT col_type_is('ext_timeseries', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('ext_timeseries', 'code', 'text', 'Column code should be text');
SELECT col_type_is('ext_timeseries', 'operator_id', 'int4', 'Column operator_id should be int4');
SELECT col_type_is('ext_timeseries', 'catalog_id', 'text', 'Column catalog_id should be text');
SELECT col_type_is('ext_timeseries', 'element', 'json', 'Column element should be json');
SELECT col_type_is('ext_timeseries', 'param', 'json', 'Column param should be json');
SELECT col_type_is('ext_timeseries', 'period', 'json', 'Column period should be json');
SELECT col_type_is('ext_timeseries', 'timestep', 'json', 'Column timestep should be json');
SELECT col_type_is('ext_timeseries', 'val', 'float8[]', 'Column val should be float8[]');
SELECT col_type_is('ext_timeseries', 'descript', 'text', 'Column descript should be text');

-- Finish
SELECT * FROM finish();

ROLLBACK;
