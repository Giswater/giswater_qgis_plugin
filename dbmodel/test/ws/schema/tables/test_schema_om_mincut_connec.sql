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

-- Check table om_mincut_connec
SELECT has_table('om_mincut_connec'::name, 'Table om_mincut_connec should exist');

-- Check columns
SELECT columns_are(
    'om_mincut_connec',
    ARRAY[
        'id', 'result_id', 'connec_id', 'the_geom', 'customer_code'
    ],
    'Table om_mincut_connec should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('om_mincut_connec', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('om_mincut_connec', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('om_mincut_connec', 'result_id', 'integer', 'Column result_id should be integer');
SELECT col_type_is('om_mincut_connec', 'connec_id', 'varchar(16)', 'Column connec_id should be varchar(16)');
SELECT col_type_is('om_mincut_connec', 'the_geom', 'geometry(Point,25831)', 'Column the_geom should be geometry(Point,25831)');
SELECT col_type_is('om_mincut_connec', 'customer_code', 'varchar(30)', 'Column customer_code should be varchar(30)');

-- Check unique constraints
SELECT col_is_unique('om_mincut_connec', ARRAY['result_id', 'connec_id'], 'Columns result_id and connec_id should have a unique constraint');

-- Check foreign keys
SELECT has_fk('om_mincut_connec', 'Table om_mincut_connec should have foreign keys');
SELECT fk_ok('om_mincut_connec', 'result_id', 'om_mincut', 'id', 'FK result_id should reference om_mincut.id');

-- Check constraints
SELECT col_not_null('om_mincut_connec', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('om_mincut_connec', 'result_id', 'Column result_id should be NOT NULL');
SELECT col_not_null('om_mincut_connec', 'connec_id', 'Column connec_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK; 