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
SELECT has_table('node'::name, 'Table node should exist');

-- Check columns (physical order)
SELECT columns_are(
    'node',
    ARRAY[
        'node_id', 'code', 'sys_code', 'top_elev', 'custom_top_elev', 'ymax', 'elev', 'custom_elev',
        'feature_type', 'node_type', 'matcat_id', 'nodecat_id', 'epa_type', 'state', 'state_type',
        'arc_id', 'parent_id', 'expl_id', 'muni_id', 'sector_id', 'dma_id', 'dwfzone_id', 'omzone_id',
        'omunit_id', 'omstate', 'minsector_id', 'dwfzone_outfall', 'drainzone_outfall', 'pavcat_id',
        'soilcat_id', 'function_type', 'category_type', 'location_type', '_fluid_type', 'fluid_type',
        'treatment_type', 'has_treatment', 'annotation', 'observ', 'comment', 'descript', 'link',
        'num_value', 'district_id', 'postcode', 'streetaxis_id', 'postnumber', 'postcomplement',
        'streetaxis2_id', 'postnumber2', 'postcomplement2', 'workcat_id', 'workcat_id_end',
        'workcat_id_plan', 'builtdate', 'enddate', 'ownercat_id', 'conserv_state', 'om_state',
        'access_type', 'placement_type', 'brand_id', 'model_id', 'serial_number', 'asset_id',
        'adate', 'adescript', 'verified', 'xyz_date', 'uncertain', 'datasource', 'unconnected',
        'label_x', 'label_y', 'label_rotation', 'rotation', 'label_quadrant', 'hemisphere',
        'inventory', 'publish', 'is_scadamap', 'lock_level', 'expl_visibility', 'created_at',
        'created_by', 'updated_at', 'updated_by', 'the_geom', 'uuid'
    ],
    'Table node should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('node', 'node_id', 'Column node_id should be primary key');

-- Check constraints
SELECT col_has_check('node', 'epa_type', 'Table should have check on epa_type');

-- Check column types
SELECT col_type_is('node', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('node', 'code', 'text', 'Column code should be text');
SELECT col_type_is('node', 'sys_code', 'text', 'Column sys_code should be text');
SELECT col_type_is('node', 'top_elev', 'numeric(12,3)', 'Column top_elev should be numeric(12,3)');
SELECT col_type_is('node', 'custom_top_elev', 'numeric(12,3)', 'Column custom_top_elev should be numeric(12,3)');
SELECT col_type_is('node', 'ymax', 'numeric(12,3)', 'Column ymax should be numeric(12,3)');
SELECT col_type_is('node', 'elev', 'numeric(12,3)', 'Column elev should be numeric(12,3)');
SELECT col_type_is('node', 'custom_elev', 'numeric(12,3)', 'Column custom_elev should be numeric(12,3)');
SELECT col_type_is('node', 'feature_type', 'varchar(16)', 'Column feature_type should be varchar(16)');
SELECT col_type_is('node', 'node_type', 'varchar(30)', 'Column node_type should be varchar(30)');
SELECT col_type_is('node', 'matcat_id', 'varchar(16)', 'Column matcat_id should be varchar(16)');
SELECT col_type_is('node', 'nodecat_id', 'varchar(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('node', 'epa_type', 'varchar(16)', 'Column epa_type should be varchar(16)');
SELECT col_type_is('node', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('node', 'state_type', 'int2', 'Column state_type should be int2');
SELECT col_type_is('node', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('node', 'parent_id', 'int4', 'Column parent_id should be int4');
SELECT col_type_is('node', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('node', 'muni_id', 'int4', 'Column muni_id should be int4');
SELECT col_type_is('node', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('node', 'dma_id', 'int4', 'Column dma_id should be int4');
SELECT col_type_is('node', 'dwfzone_id', 'int4', 'Column dwfzone_id should be int4');
SELECT col_type_is('node', 'omzone_id', 'int4', 'Column omzone_id should be int4');
SELECT col_type_is('node', 'omunit_id', 'int4', 'Column omunit_id should be int4');
SELECT col_type_is('node', 'omstate', 'int4', 'Column omstate should be int4');
SELECT col_type_is('node', 'minsector_id', 'int4', 'Column minsector_id should be int4');
SELECT col_type_is('node', 'dwfzone_outfall', 'integer[]', 'Column dwfzone_outfall should be integer[]');
SELECT col_type_is('node', 'drainzone_outfall', 'integer[]', 'Column drainzone_outfall should be integer[]');
SELECT col_type_is('node', 'pavcat_id', 'text', 'Column pavcat_id should be text');
SELECT col_type_is('node', 'soilcat_id', 'varchar(16)', 'Column soilcat_id should be varchar(16)');
SELECT col_type_is('node', 'function_type', 'varchar(50)', 'Column function_type should be varchar(50)');
SELECT col_type_is('node', 'category_type', 'varchar(50)', 'Column category_type should be varchar(50)');
SELECT col_type_is('node', 'location_type', 'varchar(50)', 'Column location_type should be varchar(50)');
SELECT col_type_is('node', '_fluid_type', 'varchar(50)', 'Column _fluid_type should be varchar(50)');
SELECT col_type_is('node', 'fluid_type', 'int4', 'Column fluid_type should be int4');
SELECT col_type_is('node', 'treatment_type', 'int4', 'Column treatment_type should be int4');
SELECT col_type_is('node', 'has_treatment', 'bool', 'Column has_treatment should be bool');
SELECT col_type_is('node', 'annotation', 'text', 'Column annotation should be text');
SELECT col_type_is('node', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('node', 'comment', 'text', 'Column comment should be text');
SELECT col_type_is('node', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('node', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('node', 'num_value', 'numeric(12,3)', 'Column num_value should be numeric(12,3)');
SELECT col_type_is('node', 'district_id', 'int4', 'Column district_id should be int4');
SELECT col_type_is('node', 'postcode', 'varchar(16)', 'Column postcode should be varchar(16)');
SELECT col_type_is('node', 'streetaxis_id', 'varchar(16)', 'Column streetaxis_id should be varchar(16)');
SELECT col_type_is('node', 'postnumber', 'int4', 'Column postnumber should be int4');
SELECT col_type_is('node', 'postcomplement', 'varchar(100)', 'Column postcomplement should be varchar(100)');
SELECT col_type_is('node', 'streetaxis2_id', 'varchar(16)', 'Column streetaxis2_id should be varchar(16)');
SELECT col_type_is('node', 'postnumber2', 'int4', 'Column postnumber2 should be int4');
SELECT col_type_is('node', 'postcomplement2', 'varchar(100)', 'Column postcomplement2 should be varchar(100)');
SELECT col_type_is('node', 'workcat_id', 'varchar(255)', 'Column workcat_id should be varchar(255)');
SELECT col_type_is('node', 'workcat_id_end', 'varchar(255)', 'Column workcat_id_end should be varchar(255)');
SELECT col_type_is('node', 'workcat_id_plan', 'varchar(255)', 'Column workcat_id_plan should be varchar(255)');
SELECT col_type_is('node', 'builtdate', 'date', 'Column builtdate should be date');
SELECT col_type_is('node', 'enddate', 'date', 'Column enddate should be date');
SELECT col_type_is('node', 'ownercat_id', 'varchar(30)', 'Column ownercat_id should be varchar(30)');
SELECT col_type_is('node', 'conserv_state', 'text', 'Column conserv_state should be text');
SELECT col_type_is('node', 'om_state', 'int4', 'Column om_state should be int4');
SELECT col_type_is('node', 'access_type', 'text', 'Column access_type should be text');
SELECT col_type_is('node', 'placement_type', 'varchar(50)', 'Column placement_type should be varchar(50)');
SELECT col_type_is('node', 'brand_id', 'varchar(50)', 'Column brand_id should be varchar(50)');
SELECT col_type_is('node', 'model_id', 'varchar(50)', 'Column model_id should be varchar(50)');
SELECT col_type_is('node', 'serial_number', 'varchar(100)', 'Column serial_number should be varchar(100)');
SELECT col_type_is('node', 'asset_id', 'varchar(50)', 'Column asset_id should be varchar(50)');
SELECT col_type_is('node', 'adate', 'text', 'Column adate should be text');
SELECT col_type_is('node', 'adescript', 'text', 'Column adescript should be text');
SELECT col_type_is('node', 'verified', 'int4', 'Column verified should be int4');
SELECT col_type_is('node', 'xyz_date', 'date', 'Column xyz_date should be date');
SELECT col_type_is('node', 'uncertain', 'bool', 'Column uncertain should be bool');
SELECT col_type_is('node', 'datasource', 'int4', 'Column datasource should be int4');
SELECT col_type_is('node', 'unconnected', 'bool', 'Column unconnected should be bool');
SELECT col_type_is('node', 'label_x', 'varchar(30)', 'Column label_x should be varchar(30)');
SELECT col_type_is('node', 'label_y', 'varchar(30)', 'Column label_y should be varchar(30)');
SELECT col_type_is('node', 'label_rotation', 'numeric(6,3)', 'Column label_rotation should be numeric(6,3)');
SELECT col_type_is('node', 'rotation', 'numeric(6,3)', 'Column rotation should be numeric(6,3)');
SELECT col_type_is('node', 'label_quadrant', 'varchar(12)', 'Column label_quadrant should be varchar(12)');
SELECT col_type_is('node', 'hemisphere', 'float8', 'Column hemisphere should be float8');
SELECT col_type_is('node', 'inventory', 'bool', 'Column inventory should be bool');
SELECT col_type_is('node', 'publish', 'bool', 'Column publish should be bool');
SELECT col_type_is('node', 'is_scadamap', 'bool', 'Column is_scadamap should be bool');
SELECT col_type_is('node', 'lock_level', 'int4', 'Column lock_level should be int4');
SELECT col_type_is('node', 'expl_visibility', 'smallint[]', 'Column expl_visibility should be smallint[]');
SELECT col_type_is('node', 'created_at', 'timestamptz', 'Column created_at should be timestamptz');
SELECT col_type_is('node', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('node', 'updated_at', 'timestamptz', 'Column updated_at should be timestamptz');
SELECT col_type_is('node', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');
SELECT col_type_is('node', 'the_geom', 'geometry(point, 25831)', 'Column the_geom should be geometry(point, 25831)');
SELECT col_type_is('node', 'uuid', 'uuid', 'Column uuid should be uuid');

-- Check default values
SELECT col_has_default('node', 'node_id', 'Column node_id should have default value');
SELECT col_has_default('node', 'feature_type', 'Column feature_type should have default value');
SELECT col_has_default('node', 'expl_id', 'Column expl_id should have default value');
SELECT col_has_default('node', 'muni_id', 'Column muni_id should have default value');
SELECT col_has_default('node', 'sector_id', 'Column sector_id should have default value');
SELECT col_has_default('node', 'dma_id', 'Column dma_id should have default value');
SELECT col_has_default('node', 'dwfzone_id', 'Column dwfzone_id should have default value');
SELECT col_has_default('node', 'omzone_id', 'Column omzone_id should have default value');
SELECT col_has_default('node', 'omunit_id', 'Column omunit_id should have default value');
SELECT col_has_default('node', 'omstate', 'Column omstate should have default value');
SELECT col_has_default('node', 'minsector_id', 'Column minsector_id should have default value');
SELECT col_has_default('node', 'fluid_type', 'Column fluid_type should have default value');
SELECT col_has_default('node', 'treatment_type', 'Column treatment_type should have default value');
SELECT col_has_default('node', 'created_at', 'Column created_at should have default value');
SELECT col_has_default('node', 'created_by', 'Column created_by should have default value');

-- Check foreign keys
SELECT has_fk('node', 'Table node should have foreign keys');

SELECT fk_ok('node', 'pavcat_id', 'cat_pavement', 'id', 'Table should have foreign key from pavcat_id to cat_pavement.id');
SELECT fk_ok('node', 'brand_id', 'cat_brand', 'id', 'Table should have foreign key from brand_id to cat_brand.id');
SELECT fk_ok('node', 'district_id', 'ext_district', 'district_id', 'Table should have foreign key from district_id to ext_district.district_id');
SELECT fk_ok('node', 'dma_id', 'dma', 'dma_id', 'Table should have foreign key from dma_id to dma.dma_id');
SELECT fk_ok('node', 'dwfzone_id', 'dwfzone', 'dwfzone_id', 'Table should have foreign key from dwfzone_id to dwfzone.dwfzone_id');
SELECT fk_ok('node', 'expl_id', 'exploitation', 'expl_id', 'Table should have foreign key from expl_id to exploitation.expl_id');
SELECT fk_ok('node', 'feature_type', 'sys_feature_type', 'id', 'Table should have foreign key from feature_type to sys_feature_type.id');
SELECT fk_ok('node', 'category_type', 'man_type_category', 'category_type', 'Table should have foreign key from category_type to man_type_category.category_type');
SELECT fk_ok('node', 'function_type', 'man_type_function', 'function_type', 'Table should have foreign key from function_type to man_type_function.function_type');
SELECT fk_ok('node', 'location_type', 'man_type_location', 'location_type', 'Table should have foreign key from location_type to man_type_location.location_type');
SELECT fk_ok('node', 'minsector_id', 'minsector', 'minsector_id', 'Table should have foreign key from minsector_id to minsector.minsector_id');
SELECT fk_ok('node', 'model_id', 'cat_brand_model', 'id', 'Table should have foreign key from model_id to cat_brand_model.id');
SELECT fk_ok('node', 'muni_id', 'ext_municipality', 'muni_id', 'Table should have foreign key from muni_id to ext_municipality.muni_id');
SELECT fk_ok('node', 'node_type', 'cat_feature_node', 'id', 'Table should have foreign key from node_type to cat_feature_node.id');
SELECT fk_ok('node', 'nodecat_id', 'cat_node', 'id', 'Table should have foreign key from nodecat_id to cat_node.id');
SELECT fk_ok('node', 'omunit_id', 'omunit', 'omunit_id', 'Table should have foreign key from omunit_id to omunit.omunit_id');
SELECT fk_ok('node', 'omzone_id', 'omzone', 'omzone_id', 'Table should have foreign key from omzone_id to omzone.omzone_id');
SELECT fk_ok('node', 'ownercat_id', 'cat_owner', 'id', 'Table should have foreign key from ownercat_id to cat_owner.id');
SELECT fk_ok('node', 'parent_id', 'node', 'node_id', 'Table should have foreign key from parent_id to node.node_id');
SELECT fk_ok('node', 'sector_id', 'sector', 'sector_id', 'Table should have foreign key from sector_id to sector.sector_id');
SELECT fk_ok('node', 'soilcat_id', 'cat_soil', 'id', 'Table should have foreign key from soilcat_id to cat_soil.id');
SELECT fk_ok('node', 'state', 'value_state', 'id', 'Table should have foreign key from state to value_state.id');
SELECT fk_ok('node', 'state_type', 'value_state_type', 'id', 'Table should have foreign key from state_type to value_state_type.id');
SELECT fk_ok('node', ARRAY['muni_id','streetaxis_id'], 'ext_streetaxis', ARRAY['muni_id','id'], 'Table should have foreign key from muni_id,streetaxis_id to ext_streetaxis.muni_id,id');
SELECT fk_ok('node', ARRAY['muni_id','streetaxis2_id'], 'ext_streetaxis', ARRAY['muni_id','id'], 'Table should have foreign key from muni_id,streetaxis2_id to ext_streetaxis.muni_id,id');
SELECT fk_ok('node', 'workcat_id_end', 'cat_work', 'id', 'Table should have foreign key from workcat_id_end to cat_work.id');
SELECT fk_ok('node', 'workcat_id', 'cat_work', 'id', 'Table should have foreign key from workcat_id to cat_work.id');

-- Check indexes
SELECT has_index('node', 'node_arc_id', 'Table should have index on arc_id');
SELECT has_index('node', 'node_asset_id_idx', 'Table should have index on asset_id');
SELECT has_index('node', 'node_dma_id_idx', 'Table should have index on dma_id');
SELECT has_index('node', 'node_expl_visibility_gin', 'Table should have gin index on expl_visibility');
SELECT has_index('node', 'node_exploitation', 'Table should have index on expl_id');
SELECT has_index('node', 'node_index', 'Table should have index on the_geom');
SELECT has_index('node', 'node_minsector_id_idx', 'Table should have index on minsector_id');
SELECT has_index('node', 'node_muni', 'Table should have index on muni_id');
SELECT has_index('node', 'node_nodecat', 'Table should have index on nodecat_id');
SELECT has_index('node', 'node_nodetype_index', 'Table should have index on node_type');
SELECT has_index('node', 'node_omunit_id_idx', 'Table should have index on omunit_id');
SELECT has_index('node', 'node_omzone', 'Table should have index on omzone_id');
SELECT has_index('node', 'node_pkey', 'Table should have primary key index on node_id');
SELECT has_index('node', 'node_sector', 'Table should have index on sector_id');
SELECT has_index('node', 'node_street1', 'Table should have index on streetaxis_id');
SELECT has_index('node', 'node_street2', 'Table should have index on streetaxis2_id');
SELECT has_index('node', 'node_sys_code_idx', 'Table should have index on sys_code');

-- Check triggers
SELECT has_trigger('node', 'gw_trg_typevalue_fk_update', 'Table should have trigger gw_trg_typevalue_fk_update');
SELECT has_trigger('node', 'gw_trg_topocontrol_node', 'Table should have trigger gw_trg_topocontrol_node');
SELECT has_trigger('node', 'gw_trg_node_statecontrol', 'Table should have trigger gw_trg_node_statecontrol');
SELECT has_trigger('node', 'gw_trg_node_arc_divide', 'Table should have trigger gw_trg_node_arc_divide');
SELECT has_trigger('node', 'gw_trg_plan_psector_after_node', 'Table should have trigger gw_trg_plan_psector_after_node');
SELECT has_trigger('node', 'gw_trg_node_rotation_update', 'Table should have trigger gw_trg_node_rotation_update');
SELECT has_trigger('node', 'gw_trg_cat_material_fk_update', 'Table should have trigger gw_trg_cat_material_fk_update');
SELECT has_trigger('node', 'gw_trg_typevalue_fk_insert', 'Table should have trigger gw_trg_typevalue_fk_insert');
SELECT has_trigger('node', 'gw_trg_edit_controls', 'Table should have trigger gw_trg_edit_controls');
SELECT has_trigger('node', 'gw_trg_fk_array_array_table_expl', 'Table should have trigger gw_trg_fk_array_array_table_expl');
SELECT has_trigger('node', 'gw_trg_cat_material_fk_insert', 'Table should have trigger gw_trg_cat_material_fk_insert');

-- Finish
SELECT * FROM finish();

ROLLBACK;
