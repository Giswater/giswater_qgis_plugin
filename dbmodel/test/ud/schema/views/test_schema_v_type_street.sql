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

-- Check view v_type_street
SELECT has_view('v_type_street'::name, 'View v_type_street should exist');

-- Check view columns
SELECT columns_are(
    'v_type_street',
    ARRAY[
        'id', 'observ'
    ],
    'View v_type_street should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_type_street', 'id', 'varchar(20)', 'Column id should be varchar(20)');
SELECT col_type_is('v_type_street', 'observ', 'varchar(50)', 'Column observ should be varchar(50)');

SELECT * FROM finish();

ROLLBACK;
