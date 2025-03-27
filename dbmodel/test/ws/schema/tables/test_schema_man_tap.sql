/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check table man_tap
SELECT has_table('man_tap'::name, 'Table man_tap should exist');

-- Check columns
SELECT columns_are(
    'man_tap',
    ARRAY[
        'connec_id', 'linked_connec', 'drain_diam', 'drain_exit', 'drain_gully',
        'drain_distance', 'arq_patrimony', 'com_state'
    ],
    'Table man_tap should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('man_tap', ARRAY['connec_id'], 'Column connec_id should be primary key');

-- Check column types
SELECT col_type_is('man_tap', 'connec_id', 'varchar(16)', 'Column connec_id should be varchar(16)');
SELECT col_type_is('man_tap', 'linked_connec', 'varchar(16)', 'Column linked_connec should be varchar(16)');
SELECT col_type_is('man_tap', 'drain_diam', 'numeric(12,3)', 'Column drain_diam should be numeric(12,3)');
SELECT col_type_is('man_tap', 'drain_exit', 'varchar(100)', 'Column drain_exit should be varchar(100)');
SELECT col_type_is('man_tap', 'drain_gully', 'varchar(100)', 'Column drain_gully should be varchar(100)');
SELECT col_type_is('man_tap', 'drain_distance', 'numeric(12,3)', 'Column drain_distance should be numeric(12,3)');
SELECT col_type_is('man_tap', 'arq_patrimony', 'boolean', 'Column arq_patrimony should be boolean');
SELECT col_type_is('man_tap', 'com_state', 'varchar(254)', 'Column com_state should be varchar(254)');

-- Check foreign keys
SELECT has_fk('man_tap', 'Table man_tap should have foreign keys');
SELECT fk_ok('man_tap', 'connec_id', 'connec', 'connec_id', 'FK connec_id should reference connec.connec_id');
SELECT fk_ok('man_tap', 'linked_connec', 'connec', 'connec_id', 'FK linked_connec should reference connec.connec_id');

-- Check constraints
SELECT col_not_null('man_tap', 'connec_id', 'Column connec_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;