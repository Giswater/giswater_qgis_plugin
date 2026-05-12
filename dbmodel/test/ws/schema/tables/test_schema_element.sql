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

-- Check table element
SELECT has_table('element'::name, 'Table element should exist');

-- Check columns
SELECT columns_are(
    'element',
    ARRAY[
        'element_id', 'code', 'sys_code', 'elementcat_id', 'serial_number', 'num_elements', 'state', 'state_type',
        'observ', 'comment', 'function_type', 'category_type', 'location_type', 'workcat_id',
        'workcat_id_end', 'builtdate', 'enddate', 'ownercat_id', 'rotation', 'link', 'verified',
        'label_x', 'label_y', 'label_rotation', 'publish', 'inventory', 'expl_id', 'feature_type',
        'top_elev', 'expl_visibility', 'trace_featuregeom', 'geometry_type', 'epa_type',
        'muni_id', 'sector_id', 'omzone_id', 'brand_id', 'model_id', 'asset_id', 'datasource', 'lock_level',
        'the_geom', 'created_at', 'created_by', 'updated_at', 'updated_by', 'uuid'
    ],
    'Table element should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('element', ARRAY['element_id'], 'Column element_id should be primary key');

-- Check column types
SELECT col_type_is('element', 'element_id', 'integer', 'Column element_id should be integer');
SELECT col_type_is('element', 'code', 'text', 'Column code should be text');
SELECT col_type_is('element', 'sys_code', 'text', 'Column sys_code should be text');
SELECT col_type_is('element', 'elementcat_id', 'varchar(30)', 'Column elementcat_id should be varchar(30)');
SELECT col_type_is('element', 'serial_number', 'varchar(30)', 'Column serial_number should be varchar(30)');
SELECT col_type_is('element', 'num_elements', 'integer', 'Column num_elements should be integer');
SELECT col_type_is('element', 'state', 'smallint', 'Column state should be smallint');
SELECT col_type_is('element', 'state_type', 'smallint', 'Column state_type should be smallint');
SELECT col_type_is('element', 'observ', 'varchar(254)', 'Column observ should be varchar(254)');
SELECT col_type_is('element', 'comment', 'varchar(254)', 'Column comment should be varchar(254)');
SELECT col_type_is('element', 'function_type', 'varchar(50)', 'Column function_type should be varchar(50)');
SELECT col_type_is('element', 'category_type', 'varchar(50)', 'Column category_type should be varchar(50)');
SELECT col_type_is('element', 'location_type', 'varchar(50)', 'Column location_type should be varchar(50)');
SELECT col_type_is('element', 'workcat_id', 'varchar(30)', 'Column workcat_id should be varchar(30)');
SELECT col_type_is('element', 'workcat_id_end', 'varchar(30)', 'Column workcat_id_end should be varchar(30)');
SELECT col_type_is('element', 'builtdate', 'date', 'Column builtdate should be date');
SELECT col_type_is('element', 'enddate', 'date', 'Column enddate should be date');
SELECT col_type_is('element', 'ownercat_id', 'varchar(30)', 'Column ownercat_id should be varchar(30)');
SELECT col_type_is('element', 'rotation', 'numeric(6,3)', 'Column rotation should be numeric(6,3)');
SELECT col_type_is('element', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('element', 'verified', 'integer', 'Column verified should be integer');
SELECT col_type_is('element', 'label_x', 'varchar(30)', 'Column label_x should be varchar(30)');
SELECT col_type_is('element', 'label_y', 'varchar(30)', 'Column label_y should be varchar(30)');
SELECT col_type_is('element', 'label_rotation', 'numeric(6,3)', 'Column label_rotation should be numeric(6,3)');
SELECT col_type_is('element', 'publish', 'boolean', 'Column publish should be boolean');
SELECT col_type_is('element', 'inventory', 'boolean', 'Column inventory should be boolean');
SELECT col_type_is('element', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('element', 'feature_type', 'varchar(16)', 'Column feature_type should be varchar(16)');
SELECT col_type_is('element', 'top_elev', 'numeric(12,4)', 'Column top_elev should be numeric(12,4)');
SELECT col_type_is('element', 'expl_visibility', 'smallint[]', 'Column expl_visibility should be integer[]');
SELECT col_type_is('element', 'trace_featuregeom', 'boolean', 'Column trace_featuregeom should be boolean');
SELECT col_type_is('element', 'muni_id', 'integer', 'Column muni_id should be integer');
SELECT col_type_is('element', 'sector_id', 'integer', 'Column sector_id should be integer');
SELECT col_type_is('element', 'brand_id', 'varchar(50)', 'Column brand_id should be varchar(50)');
SELECT col_type_is('element', 'model_id', 'varchar(50)', 'Column model_id should be varchar(50)');
SELECT col_type_is('element', 'asset_id', 'varchar(50)', 'Column asset_id should be varchar(50)');
SELECT col_type_is('element', 'datasource', 'integer', 'Column datasource should be integer');
SELECT col_type_is('element', 'lock_level', 'integer', 'Column lock_level should be integer');
SELECT col_type_is('element', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('element', 'geometry_type', 'text', 'Column geometry_type should be text');
SELECT col_type_is('element', 'epa_type', 'varchar(16)', 'Column epa_type should be varchar(16)');
SELECT col_type_is('element', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('element', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('element', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');
SELECT col_type_is('element', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('element', 'uuid', 'uuid', 'Column uuid should be uuid');

-- Check foreign keys
SELECT has_fk('element', 'Table element should have foreign keys');
SELECT fk_ok('element', 'brand_id', 'cat_brand', 'id', 'FK element_brand_id should exist');
SELECT fk_ok('element', 'elementcat_id', 'cat_element', 'id', 'FK element_elementcat_id_fkey should exist');
SELECT fk_ok('element', 'feature_type', 'sys_feature_type', 'id', 'FK element_feature_type_fkey should exist');
SELECT fk_ok('element', 'model_id', 'cat_brand_model', 'id', 'FK element_model_id should exist');
SELECT fk_ok('element', 'muni_id', 'ext_municipality', 'muni_id', 'FK element_muni_id should exist');
SELECT fk_ok('element', 'ownercat_id', 'cat_owner', 'id', 'FK element_ownercat_id_fkey should exist');
SELECT fk_ok('element', 'sector_id', 'sector', 'sector_id', 'FK element_sector_id should exist');
SELECT fk_ok('element', 'state', 'value_state', 'id', 'FK element_state_fkey should exist');
SELECT fk_ok('element', 'state_type', 'value_state_type', 'id', 'FK element_state_type_fkey should exist');
SELECT fk_ok('element', 'workcat_id_end', 'cat_work', 'id', 'FK element_workcat_id_end_fkey should exist');
SELECT fk_ok('element', 'workcat_id', 'cat_work', 'id', 'FK element_workcat_id_fkey should exist');

-- Check triggers
SELECT has_trigger('element', 'gw_trg_edit_controls', 'Table should have gw_trg_edit_controls trigger');
SELECT has_trigger('element', 'gw_trg_typevalue_fk_insert', 'Table should have gw_trg_typevalue_fk_insert trigger');
SELECT has_trigger('element', 'gw_trg_typevalue_fk_update', 'Table should have gw_trg_typevalue_fk_update trigger');

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('element', 'element_id', 'Column element_id should be NOT NULL');
SELECT col_not_null('element', 'elementcat_id', 'Column elementcat_id should be NOT NULL');
SELECT col_not_null('element', 'state', 'Column state should be NOT NULL');
SELECT col_not_null('element', 'state_type', 'Column state_type should be NOT NULL');

SELECT col_default_is('element', 'element_id', 'nextval(''urn_id_seq''::regclass)', 'Column element_id should have default value');
SELECT col_default_is('element', 'feature_type', 'ELEMENT', 'Column feature_type should have default value');
SELECT col_default_is('element', 'created_at', 'now()', 'Column created_at should have default value');
SELECT col_default_is('element', 'created_by', 'CURRENT_USER', 'Column created_by should have default value');
SELECT col_default_is('element', 'trace_featuregeom', 'true', 'Column trace_featuregeom should have default value');
SELECT col_default_is('element', 'sector_id', '0', 'Column sector_id should have default value');

-- Check indexes
SELECT has_index('element', 'element_expl_visibility_gin', 'Table should have index on expl_visibility');

SELECT * FROM finish();

ROLLBACK;
