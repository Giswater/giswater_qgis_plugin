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

-- Check view ve_anl_hydrant
SELECT has_view('ve_anl_hydrant'::name, 'View ve_anl_hydrant should exist');

-- Check view columns
SELECT columns_are(
    've_anl_hydrant',
    ARRAY[
        'node_id', 'nodecat_id', 'expl_id', 'the_geom'
    ],
    'View ve_anl_hydrant should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_anl_hydrant', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('ve_anl_hydrant', 'nodecat_id', 'varchar(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('ve_anl_hydrant', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('ve_anl_hydrant', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
