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

-- Check table plan_psector
SELECT has_table('plan_psector'::name, 'Table plan_psector should exist');

-- Check columns
SELECT columns_are(
    'plan_psector',
    ARRAY[
        'psector_id', 'name', 'psector_type', 'descript', 'expl_id', 'priority', 'text1', 'text2',
        'observ', 'rotation', 'scale', 'atlas_id', 'gexpenses', 'vat', 'other', 'active',
        'the_geom', 'enable_all', 'status', 'ext_code', 'text3', 'text4', 'text5', 'text6',
        'num_value', 'workcat_id', 'workcat_id_plan', 'parent_id', 'created_at', 'created_by', 'updated_at', 'updated_by',
        'archived', 'creation_date'
    ],
    'Table plan_psector should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('plan_psector', ARRAY['psector_id'], 'Column psector_id should be primary key');

-- Check column types
SELECT col_type_is('plan_psector', 'psector_id', 'integer', 'Column psector_id should be integer');
SELECT col_type_is('plan_psector', 'name', 'character varying(50)', 'Column name should be character varying(50)');
SELECT col_type_is('plan_psector', 'psector_type', 'integer', 'Column psector_type should be integer');
SELECT col_type_is('plan_psector', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('plan_psector', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('plan_psector', 'priority', 'character varying(16)', 'Column priority should be character varying(16)');
SELECT col_type_is('plan_psector', 'text1', 'text', 'Column text1 should be text');
SELECT col_type_is('plan_psector', 'text2', 'text', 'Column text2 should be text');
SELECT col_type_is('plan_psector', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('plan_psector', 'rotation', 'numeric(8,4)', 'Column rotation should be numeric(8,4)');
SELECT col_type_is('plan_psector', 'scale', 'numeric(8,2)', 'Column scale should be numeric(8,2)');
SELECT col_type_is('plan_psector', 'atlas_id', 'integer', 'Column atlas_id should be integer');
SELECT col_type_is('plan_psector', 'gexpenses', 'numeric(4,2)', 'Column gexpenses should be numeric(4,2)');
SELECT col_type_is('plan_psector', 'vat', 'numeric(4,2)', 'Column vat should be numeric(4,2)');
SELECT col_type_is('plan_psector', 'other', 'numeric(4,2)', 'Column other should be numeric(4,2)');
SELECT col_type_is('plan_psector', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('plan_psector', 'the_geom', 'geometry(MultiPolygon,25831)', 'Column the_geom should be geometry(MultiPolygon,25831)');
SELECT col_type_is('plan_psector', 'enable_all', 'boolean', 'Column enable_all should be boolean');
SELECT col_type_is('plan_psector', 'status', 'integer', 'Column status should be integer');
SELECT col_type_is('plan_psector', 'ext_code', 'text', 'Column ext_code should be text');
SELECT col_type_is('plan_psector', 'text3', 'text', 'Column text3 should be text');
SELECT col_type_is('plan_psector', 'text4', 'text', 'Column text4 should be text');
SELECT col_type_is('plan_psector', 'text5', 'text', 'Column text5 should be text');
SELECT col_type_is('plan_psector', 'text6', 'text', 'Column text6 should be text');
SELECT col_type_is('plan_psector', 'num_value', 'numeric', 'Column num_value should be numeric');
SELECT col_type_is('plan_psector', 'workcat_id', 'text', 'Column workcat_id should be text');
SELECT col_type_is('plan_psector', 'workcat_id_plan', 'text', 'Column workcat_id_plan should be text');
SELECT col_type_is('plan_psector', 'parent_id', 'integer', 'Column parent_id should be integer');
SELECT col_type_is('plan_psector', 'created_at', 'timestamp without time zone', 'Column created_at should be timestamp without time zone');
SELECT col_type_is('plan_psector', 'created_by', 'character varying(50)', 'Column created_by should be character varying(50)');
SELECT col_type_is('plan_psector', 'updated_at', 'timestamp without time zone', 'Column updated_at should be timestamp without time zone');
SELECT col_type_is('plan_psector', 'updated_by', 'character varying(50)', 'Column updated_by should be character varying(50)');
SELECT col_type_is('plan_psector', 'archived', 'boolean', 'Column archived should be boolean');

-- Check default values
SELECT col_has_default('plan_psector', 'psector_id', 'Column psector_id should have a default value');
SELECT col_default_is('plan_psector', 'psector_type', '1', 'Default value for psector_type should be 1');
SELECT col_default_is('plan_psector', 'active', 'true', 'Default value for active should be true');
SELECT col_default_is('plan_psector', 'enable_all', 'false', 'Default value for enable_all should be false');
SELECT col_default_is('plan_psector', 'status', '2', 'Default value for status should be 2');
SELECT col_has_default('plan_psector', 'created_at', 'Column created_at should have a default value');
SELECT col_default_is('plan_psector', 'created_by', 'CURRENT_USER', 'Default value for created_by should be CURRENT_USER');
-- Check foreign keys
SELECT has_fk('plan_psector', 'Table plan_psector should have foreign keys');
SELECT fk_ok('plan_psector', 'expl_id', 'exploitation', 'expl_id', 'FK expl_id should reference exploitation.expl_id');
SELECT fk_ok('plan_psector', 'parent_id', 'plan_psector', 'psector_id', 'FK parent_id should reference plan_psector.psector_id');
SELECT fk_ok('plan_psector', 'workcat_id', 'cat_work', 'id', 'FK workcat_id should reference cat_work.id');
SELECT fk_ok('plan_psector', 'workcat_id_plan', 'cat_work', 'id', 'FK workcat_id_plan should reference cat_work.id');

-- Check constraints
SELECT col_not_null('plan_psector', 'psector_id', 'Column psector_id should be NOT NULL');
SELECT col_not_null('plan_psector', 'name', 'Column name should be NOT NULL');
SELECT col_not_null('plan_psector', 'expl_id', 'Column expl_id should be NOT NULL');
SELECT col_not_null('plan_psector', 'enable_all', 'Column enable_all should be NOT NULL');
SELECT col_not_null('plan_psector', 'status', 'Column status should be NOT NULL');

-- Check unique constraints
SELECT col_is_unique('plan_psector', ARRAY['name', 'expl_id'], 'Columns name and expl_id should be unique together');

-- Check indexes
SELECT has_index('plan_psector', 'idx_plan_psector_expl_id', 'Table should have index on expl_id');
SELECT has_index('plan_psector', 'idx_plan_psector_name', 'Table should have index on name');
SELECT has_index('plan_psector', 'idx_plan_psector_status', 'Table should have index on status');
SELECT has_index('plan_psector', 'idx_plan_psector_workcat_id', 'Table should have index on workcat_id');
SELECT has_index('plan_psector', 'idx_plan_psector_workcat_id_plan', 'Table should have index on workcat_id_plan');
SELECT has_index('plan_psector', 'ifx_plan_psector_parent_id', 'Table should have index on parent_id');
SELECT has_index('plan_psector', 'ifx_plan_psector_the_geom', 'Table should have index on the_geom');
SELECT has_index('plan_psector', 'plan_psector_expl_id', 'Table should have index on expl_id');

-- Check triggers
SELECT has_trigger('plan_psector', 'gw_trg_plan_psector', 'Table should have trigger gw_trg_plan_psector');
SELECT has_trigger('plan_psector', 'gw_trg_typevalue_fk_insert', 'Table should have trigger gw_trg_typevalue_fk_insert');
SELECT has_trigger('plan_psector', 'gw_trg_typevalue_fk_update', 'Table should have trigger gw_trg_typevalue_fk_update');

SELECT * FROM finish();

ROLLBACK;