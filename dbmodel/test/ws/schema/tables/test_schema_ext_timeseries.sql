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

-- Check table ext_timeseries
SELECT has_table('ext_timeseries'::name, 'Table ext_timeseries should exist');

-- Check columns
SELECT columns_are(
    'ext_timeseries',
    ARRAY[
        'id', 'code', 'operator_id', 'catalog_id', 'element', 'param', 'period', 'timestep', 'val', 'descript'
    ],
    'Table ext_timeseries should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('ext_timeseries', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('ext_timeseries', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('ext_timeseries', 'code', 'text', 'Column code should be text');
SELECT col_type_is('ext_timeseries', 'operator_id', 'integer', 'Column operator_id should be integer');
SELECT col_type_is('ext_timeseries', 'catalog_id', 'text', 'Column catalog_id should be text');
SELECT col_type_is('ext_timeseries', 'element', 'json', 'Column element should be json');
SELECT col_type_is('ext_timeseries', 'param', 'json', 'Column param should be json');
SELECT col_type_is('ext_timeseries', 'period', 'json', 'Column period should be json');
SELECT col_type_is('ext_timeseries', 'timestep', 'json', 'Column timestep should be json');
SELECT col_type_is('ext_timeseries', 'val', 'double precision[]', 'Column val should be double precision[]');
SELECT col_type_is('ext_timeseries', 'descript', 'text', 'Column descript should be text');

-- Check foreign keys
SELECT hasnt_fk('ext_timeseries', 'Table ext_timeseries should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('ext_timeseries_id_seq', 'Sequence ext_timeseries_id_seq should exist');

-- Check constraints
SELECT col_not_null('ext_timeseries', 'id', 'Column id should be NOT NULL');
SELECT col_has_default('ext_timeseries', 'id', 'Column id should have default value');

SELECT * FROM finish();

ROLLBACK;
