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

-- Check view ve_pol_netgully
SELECT has_view('ve_pol_netgully'::name, 'View ve_pol_netgully should exist');

-- Check view columns
SELECT columns_are(
    've_pol_netgully',
    ARRAY[
        'pol_id', 'node_id', 'the_geom'
    ],
    'View ve_pol_netgully should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_pol_netgully', 'pol_id', 'varchar(16)', 'Column pol_id should be varchar(16)');
SELECT col_type_is('ve_pol_netgully', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('ve_pol_netgully', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
