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
SELECT has_table('inp_timeseries'::name, 'Table inp_timeseries should exist');

-- Check columns
SELECT columns_are(
    'inp_timeseries',
    ARRAY[
        'id', 'timser_type', 'times_type', 'descript', 'fname', 'expl_id',
        'log', 'active', 'addparam'
    ],
    'Table inp_timeseries should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_timeseries', 'id', 'varchar(16)', 'Column id should be varchar(16)');
SELECT col_type_is('inp_timeseries', 'timser_type', 'varchar(20)', 'Column timser_type should be varchar(20)');
SELECT col_type_is('inp_timeseries', 'times_type', 'varchar(16)', 'Column times_type should be varchar(16)');
SELECT col_type_is('inp_timeseries', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('inp_timeseries', 'fname', 'varchar(254)', 'Column fname should be varchar(254)');
SELECT col_type_is('inp_timeseries', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('inp_timeseries', 'log', 'text', 'Column log should be text');
SELECT col_type_is('inp_timeseries', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('inp_timeseries', 'addparam', 'jsonb', 'Column addparam should be jsonb');

-- Check foreign keys
SELECT has_fk('inp_timeseries', 'Table inp_timeseries should have foreign keys');

SELECT fk_ok('inp_timeseries', 'expl_id', 'exploitation', 'expl_id', 'FK expl_id → exploitation.expl_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
