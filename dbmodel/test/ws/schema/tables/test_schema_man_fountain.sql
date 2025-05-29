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

-- Check table man_fountain
SELECT has_table('man_fountain'::name, 'Table man_fountain should exist');

-- Check columns
SELECT columns_are(
    'man_fountain',
    ARRAY[
        'connec_id', 'linked_connec', 'vmax', 'vtotal', 'container_number', 'pump_number',
        'power', 'regulation_tank', 'chlorinator', 'arq_patrimony', 'name'
    ],
    'Table man_fountain should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('man_fountain', ARRAY['connec_id'], 'Column connec_id should be primary key');

-- Check column types
SELECT col_type_is('man_fountain', 'connec_id', 'integer', 'Column connec_id should be integer');
SELECT col_type_is('man_fountain', 'linked_connec', 'integer', 'Column linked_connec should be integer');
SELECT col_type_is('man_fountain', 'vmax', 'numeric(12,3)', 'Column vmax should be numeric(12,3)');
SELECT col_type_is('man_fountain', 'vtotal', 'numeric(12,3)', 'Column vtotal should be numeric(12,3)');
SELECT col_type_is('man_fountain', 'container_number', 'integer', 'Column container_number should be integer');
SELECT col_type_is('man_fountain', 'pump_number', 'integer', 'Column pump_number should be integer');
SELECT col_type_is('man_fountain', 'power', 'numeric(12,3)', 'Column power should be numeric(12,3)');
SELECT col_type_is('man_fountain', 'regulation_tank', 'varchar(150)', 'Column regulation_tank should be varchar(150)');
SELECT col_type_is('man_fountain', 'chlorinator', 'varchar(100)', 'Column chlorinator should be varchar(100)');
SELECT col_type_is('man_fountain', 'arq_patrimony', 'boolean', 'Column arq_patrimony should be boolean');
SELECT col_type_is('man_fountain', 'name', 'varchar(254)', 'Column name should be varchar(254)');

-- Check not null constraints
SELECT col_not_null('man_fountain', 'connec_id', 'Column connec_id should be NOT NULL');

-- Check foreign keys
SELECT fk_ok('man_fountain', 'connec_id', 'connec', 'connec_id', 'FK connec_id should reference connec.connec_id');
SELECT fk_ok('man_fountain', 'linked_connec', 'connec', 'connec_id', 'FK linked_connec should reference connec.connec_id');

SELECT * FROM finish();

ROLLBACK;