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

-- Check table om_visit_x_connec
SELECT has_table('om_visit_x_connec'::name, 'Table om_visit_x_connec should exist');

-- Check columns
SELECT columns_are(
    'om_visit_x_connec',
    ARRAY[
        'id', 'visit_id', 'connec_id', 'is_last', 'connec_uuid'
    ],
    'Table om_visit_x_connec should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('om_visit_x_connec', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('om_visit_x_connec', 'id', 'bigint', 'Column id should be bigint');
SELECT col_type_is('om_visit_x_connec', 'visit_id', 'bigint', 'Column visit_id should be bigint');
SELECT col_type_is('om_visit_x_connec', 'connec_id', 'integer', 'Column connec_id should be integer');
SELECT col_type_is('om_visit_x_connec', 'is_last', 'boolean', 'Column is_last should be boolean');
SELECT col_type_is('om_visit_x_connec', 'connec_uuid', 'uuid', 'Column connec_uuid should be uuid');

-- Check default values
SELECT col_default_is('om_visit_x_connec', 'is_last', 'true', 'Column is_last should default to true');

-- Check unique constraints
SELECT col_is_unique('om_visit_x_connec', ARRAY['connec_id', 'visit_id'], 'Columns connec_id and visit_id should have a unique constraint');

-- Check foreign keys
SELECT has_fk('om_visit_x_connec', 'Table om_visit_x_connec should have foreign keys');
SELECT fk_ok('om_visit_x_connec', 'connec_id', 'connec', 'connec_id', 'FK connec_id should reference connec.connec_id');
SELECT fk_ok('om_visit_x_connec', 'visit_id', 'om_visit', 'id', 'FK visit_id should reference om_visit.id');

-- Check constraints
SELECT col_not_null('om_visit_x_connec', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('om_visit_x_connec', 'visit_id', 'Column visit_id should be NOT NULL');
SELECT col_not_null('om_visit_x_connec', 'connec_id', 'Column connec_id should be NOT NULL');

-- Check triggers
SELECT has_trigger('om_visit_x_connec', 'gw_trg_om_visit', 'Table should have gw_trg_om_visit trigger');

SELECT * FROM finish();

ROLLBACK;