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

-- Check column types
SELECT col_type_is('man_fountain', 'connec_id', 'int4', 'Column connec_id should be int4');
SELECT col_type_is('man_fountain', 'linked_connec', 'int4', 'Column linked_connec should be int4');
SELECT col_type_is('man_fountain', 'vmax', 'numeric(12,3)', 'Column vmax should be numeric(12,3)');
SELECT col_type_is('man_fountain', 'vtotal', 'numeric(12,3)', 'Column vtotal should be numeric(12,3)');
SELECT col_type_is('man_fountain', 'container_number', 'int4', 'Column container_number should be int4');
SELECT col_type_is('man_fountain', 'pump_number', 'int4', 'Column pump_number should be int4');
SELECT col_type_is('man_fountain', 'power', 'numeric(12,3)', 'Column power should be numeric(12,3)');
SELECT col_type_is('man_fountain', 'regulation_tank', 'varchar(150)', 'Column regulation_tank should be varchar(150)');
SELECT col_type_is('man_fountain', 'chlorinator', 'varchar(100)', 'Column chlorinator should be varchar(100)');
SELECT col_type_is('man_fountain', 'arq_patrimony', 'bool', 'Column arq_patrimony should be bool');
SELECT col_type_is('man_fountain', 'name', 'varchar(254)', 'Column name should be varchar(254)');

-- Check foreign keys
SELECT has_fk('man_fountain', 'Table man_fountain should have foreign keys');

SELECT fk_ok('man_fountain', 'connec_id', 'connec', 'connec_id', 'FK connec_id → connec.connec_id');
SELECT fk_ok('man_fountain', 'linked_connec', 'connec', 'connec_id', 'FK linked_connec → connec.connec_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
