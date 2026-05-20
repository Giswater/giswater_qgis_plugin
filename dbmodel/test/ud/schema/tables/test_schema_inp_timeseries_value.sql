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
SELECT has_table('inp_timeseries_value'::name, 'Table inp_timeseries_value should exist');

-- Check columns
SELECT columns_are(
    'inp_timeseries_value',
    ARRAY[
        'id', 'timser_id', 'date', 'hour', 'time', 'value'
    ],
    'Table inp_timeseries_value should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_timeseries_value', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('inp_timeseries_value', 'timser_id', 'varchar(16)', 'Column timser_id should be varchar(16)');
SELECT col_type_is('inp_timeseries_value', 'date', 'varchar(12)', 'Column date should be varchar(12)');
SELECT col_type_is('inp_timeseries_value', 'hour', 'varchar(10)', 'Column hour should be varchar(10)');
SELECT col_type_is('inp_timeseries_value', 'time', 'varchar(10)', 'Column time should be varchar(10)');
SELECT col_type_is('inp_timeseries_value', 'value', 'numeric(12,4)', 'Column value should be numeric(12,4)');

-- Check foreign keys
SELECT has_fk('inp_timeseries_value', 'Table inp_timeseries_value should have foreign keys');

SELECT fk_ok('inp_timeseries_value', 'timser_id', 'inp_timeseries', 'id', 'FK timser_id → inp_timeseries.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
