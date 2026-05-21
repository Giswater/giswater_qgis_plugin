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
SELECT has_table('om_mincut_connec'::name, 'Table om_mincut_connec should exist');

-- Check columns
SELECT columns_are(
    'om_mincut_connec',
    ARRAY[
        'id', 'result_id', 'connec_id', 'the_geom', 'customer_code'
    ],
    'Table om_mincut_connec should have the correct columns'
);

-- Check column types
SELECT col_type_is('om_mincut_connec', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('om_mincut_connec', 'result_id', 'int4', 'Column result_id should be int4');
SELECT col_type_is('om_mincut_connec', 'connec_id', 'int4', 'Column connec_id should be int4');
SELECT col_type_is('om_mincut_connec', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('om_mincut_connec', 'customer_code', 'varchar(30)', 'Column customer_code should be varchar(30)');

-- Check foreign keys
SELECT has_fk('om_mincut_connec', 'Table om_mincut_connec should have foreign keys');

SELECT fk_ok('om_mincut_connec', 'result_id', 'om_mincut', 'id', 'FK result_id → om_mincut.id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
