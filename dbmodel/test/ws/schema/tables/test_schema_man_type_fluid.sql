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

-- Check table man_type_fluid
SELECT has_table('man_type_fluid'::name, 'Table man_type_fluid should exist');

-- Check columns
SELECT columns_are(
    'man_type_fluid',
    ARRAY[
        'id', 'fluid_type', 'feature_type', 'featurecat_id', 'observ', 'active'
    ],
    'Table man_type_fluid should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('man_type_fluid', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('man_type_fluid', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('man_type_fluid', 'fluid_type', 'varchar(50)', 'Column fluid_type should be varchar(50)');
SELECT col_type_is('man_type_fluid', 'feature_type', 'varchar(30)', 'Column feature_type should be varchar(30)');
SELECT col_type_is('man_type_fluid', 'featurecat_id', 'text[]', 'Column featurecat_id should be text[]');
SELECT col_type_is('man_type_fluid', 'observ', 'varchar(150)', 'Column observ should be varchar(150)');
SELECT col_type_is('man_type_fluid', 'active', 'boolean', 'Column active should be boolean');

-- Check default values
SELECT col_default_is('man_type_fluid', 'active', 'true', 'Column active should default to true');

-- Check unique constraints
SELECT col_is_unique('man_type_fluid', ARRAY['fluid_type', 'feature_type'], 'Columns fluid_type and feature_type should have a unique constraint');

-- Check foreign keys
SELECT has_fk('man_type_fluid', 'Table man_type_fluid should have foreign keys');
SELECT fk_ok('man_type_fluid', 'feature_type', 'sys_feature_type', 'id', 'FK feature_type should reference sys_feature_type.id');

-- Check not null constraints
SELECT col_not_null('man_type_fluid', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('man_type_fluid', 'fluid_type', 'Column fluid_type should be NOT NULL');

-- Check triggers
SELECT has_trigger('man_type_fluid', 'gw_trg_config_control', 'Trigger gw_trg_config_control should exist');

SELECT * FROM finish();

ROLLBACK;