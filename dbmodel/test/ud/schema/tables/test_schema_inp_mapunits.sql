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
SELECT has_table('inp_mapunits'::name, 'Table inp_mapunits should exist');

-- Check columns
SELECT columns_are(
    'inp_mapunits',
    ARRAY[
        'type_units', 'map_type'
    ],
    'Table inp_mapunits should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_mapunits', 'type_units', 'varchar(18)', 'Column type_units should be varchar(18)');
SELECT col_type_is('inp_mapunits', 'map_type', 'varchar(18)', 'Column map_type should be varchar(18)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
