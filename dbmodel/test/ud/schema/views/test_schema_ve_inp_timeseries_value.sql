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

-- Check view ve_inp_timeseries_value
SELECT has_view('ve_inp_timeseries_value'::name, 'View ve_inp_timeseries_value should exist');

-- Check view columns
SELECT columns_are(
    've_inp_timeseries_value',
    ARRAY[
        'id', 'timser_id', 'timser_type', 'times_type', 'expl_id', 'date',
        'hour', 'time', 'value'
    ],
    'View ve_inp_timeseries_value should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_inp_timeseries_value', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('ve_inp_timeseries_value', 'timser_id', 'varchar(16)', 'Column timser_id should be varchar(16)');
SELECT col_type_is('ve_inp_timeseries_value', 'timser_type', 'varchar(20)', 'Column timser_type should be varchar(20)');
SELECT col_type_is('ve_inp_timeseries_value', 'times_type', 'varchar(16)', 'Column times_type should be varchar(16)');
SELECT col_type_is('ve_inp_timeseries_value', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('ve_inp_timeseries_value', 'date', 'varchar(12)', 'Column date should be varchar(12)');
SELECT col_type_is('ve_inp_timeseries_value', 'hour', 'varchar(10)', 'Column hour should be varchar(10)');
SELECT col_type_is('ve_inp_timeseries_value', 'time', 'varchar(10)', 'Column time should be varchar(10)');
SELECT col_type_is('ve_inp_timeseries_value', 'value', 'numeric(12,4)', 'Column value should be numeric(12,4)');

SELECT * FROM finish();

ROLLBACK;
