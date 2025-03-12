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

-- Check table cat_feature
SELECT has_table('cat_feature'::name, 'Table cat_feature should exist');

-- Check columns
SELECT columns_are(
    'cat_feature',
    ARRAY[
        'id', 'feature_class', 'feature_type', 'shortcut_key', 'parent_layer', 'child_layer', 'descript', 'link_path', 'code_autofill', 'active', 'addparam'
    ],
    'Table cat_feature should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('cat_feature', 'id', 'Column id should be primary key');

-- Check indexes
SELECT has_index('cat_feature', 'shortcut_unique', 'Table should have index on shortcut_key');

-- Check column types
SELECT col_type_is('cat_feature', 'id', 'character varying(30)', 'Column id should be varchar(30)');
SELECT col_type_is('cat_feature', 'feature_class', 'character varying(30)', 'Column feature_class should be varchar(30)');
SELECT col_type_is('cat_feature', 'feature_type', 'character varying(30)', 'Column feature_type should be varchar(30)');
SELECT col_type_is('cat_feature', 'shortcut_key', 'character varying(100)', 'Column shortcut_key should be varchar(100)');
SELECT col_type_is('cat_feature', 'parent_layer', 'character varying(100)', 'Column parent_layer should be varchar(100)');
SELECT col_type_is('cat_feature', 'child_layer', 'character varying(100)', 'Column child_layer should be varchar(100)');
SELECT col_type_is('cat_feature', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('cat_feature', 'link_path', 'text', 'Column link_path should be text');
SELECT col_type_is('cat_feature', 'code_autofill', 'boolean', 'Column code_autofill should be boolean');
SELECT col_type_is('cat_feature', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('cat_feature', 'addparam', 'json', 'Column addparam should be json');

-- Check foreign keys
SELECT has_fk('cat_feature', 'Table cat_feature should have foreign keys');
SELECT fk_ok(
    'cat_feature', ARRAY['feature_class', 'feature_type'],
    'sys_feature_class', ARRAY['id', 'type'],
    'Columns feature_class,feature_type should reference sys_feature_class(id,type)'
);

-- Check triggers
SELECT has_trigger('cat_feature', 'gw_trg_cat_feature_after', 'Table cat_feature should have trigger gw_trg_cat_feature_after');
SELECT has_trigger('cat_feature', 'gw_trg_cat_feature_delete', 'Table cat_feature should have trigger gw_trg_cat_feature_delete');

-- Check rules

-- Check sequences

-- Check constraints


SELECT * FROM finish();

ROLLBACK;
