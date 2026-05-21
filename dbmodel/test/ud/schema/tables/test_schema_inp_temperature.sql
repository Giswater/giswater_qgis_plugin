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
SELECT has_table('inp_temperature'::name, 'Table inp_temperature should exist');

-- Check columns
SELECT columns_are(
    'inp_temperature',
    ARRAY[
        'id', 'temp_type', 'value'
    ],
    'Table inp_temperature should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_temperature', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('inp_temperature', 'temp_type', 'varchar(60)', 'Column temp_type should be varchar(60)');
SELECT col_type_is('inp_temperature', 'value', 'text', 'Column value should be text');

-- Finish
SELECT * FROM finish();

ROLLBACK;
