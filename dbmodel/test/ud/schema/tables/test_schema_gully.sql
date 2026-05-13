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
SELECT has_table('gully'::name, 'Table gully should exist');

-- Check columns
SELECT columns_are(
    'gully',
    ARRAY[
        'gully_id', 'code', 'sys_code', 'top_elev', 'ymax', 'length', 'width', 'sandbox', 'matcat_id',
        'feature_type', 'gullycat_id', 'gully_type', 'units', 'units_placement', 'groove', 'groove_height',
        'groove_length', 'siphon', 'siphon_type', 'odorflap', 'connec_length', 'connec_depth', 'connec_y2',
        'arc_id', 'epa_type', 'state', 'state_type', 'expl_id', 'muni_id', 'sector_id', 'dma_id',
        'drainzone_outfall', 'dwfzone_id', 'dwfzone_outfall', 'omzone_id', 'omunit_id', 'minsector_id',
        'soilcat_id', 'function_type', 'category_type', 'location_type', '_fluid_type', 'fluid_type',
        'treatment_type', 'has_treatment', 'descript', 'annotation', 'observ', 'comment', 'link',
        'num_value', 'district_id', 'postcode', 'streetaxis_id', 'postnumber', 'postcomplement',
        'streetaxis2_id', 'postnumber2', 'postcomplement2', 'workcat_id', 'workcat_id_end',
        'workcat_id_plan', 'builtdate', 'enddate', 'ownercat_id', 'om_state', 'brand_id', 'model_id',
        'pjoint_id', 'pjoint_type', 'placement_type', 'access_type', 'asset_id', 'adate', 'adescript',
        'verified', 'uncertain', 'datasource', 'label_x', 'label_y', 'label_rotation', 'rotation',
        'label_quadrant', 'inventory', 'publish', 'lock_level', 'expl_visibility', 'created_at',
        'created_by', 'updated_at', 'updated_by', 'the_geom', '_connec_arccat_id', '_pol_id_',
        '_connec_matcat_id', 'uuid', 'xyz_date'
    ],
    'Table gully should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('gully', 'gully_id', 'Column gully_id should be primary key');

-- Check check columns
SELECT col_has_check('gully', 'pjoint_type', 'Table should have check on pjoint_type');

-- Check column types
SELECT col_type_is('gully', 'gully_id', 'int4', 'Column gully_id should be int4');
SELECT col_type_is('gully', 'code', 'text', 'Column code should be text');
SELECT col_type_is('gully', 'sys_code', 'text', 'Column sys_code should be text');
SELECT col_type_is('gully', 'top_elev', 'numeric(12,4)', 'Column top_elev should be numeric(12,4)');
SELECT col_type_is('gully', 'ymax', 'numeric(12,4)', 'Column ymax should be numeric(12,4)');
SELECT col_type_is('gully', 'length', 'numeric(12,3)', 'Column length should be numeric(12,3)');
SELECT col_type_is('gully', 'width', 'numeric(12,3)', 'Column width should be numeric(12,3)');
SELECT col_type_is('gully', 'sandbox', 'numeric(12,4)', 'Column sandbox should be numeric(12,4)');
SELECT col_type_is('gully', 'matcat_id', 'varchar(18)', 'Column matcat_id should be varchar(18)');
SELECT col_type_is('gully', 'feature_type', 'varchar(16)', 'Column feature_type should be varchar(16)');
SELECT col_type_is('gully', 'gullycat_id', 'varchar(30)', 'Column gullycat_id should be varchar(30)');
SELECT col_type_is('gully', 'gully_type', 'varchar(30)', 'Column gully_type should be varchar(30)');
SELECT col_type_is('gully', 'units', 'numeric(12,2)', 'Column units should be numeric(12,2)');
SELECT col_type_is('gully', 'units_placement', 'varchar(16)', 'Column units_placement should be varchar(16)');
SELECT col_type_is('gully', 'groove', 'bool', 'Column groove should be bool');
SELECT col_type_is('gully', 'groove_height', 'float8', 'Column groove_height should be float8');
SELECT col_type_is('gully', 'groove_length', 'float8', 'Column groove_length should be float8');
SELECT col_type_is('gully', 'siphon', 'bool', 'Column siphon should be bool');
SELECT col_type_is('gully', 'siphon_type', 'text', 'Column siphon_type should be text');
SELECT col_type_is('gully', 'odorflap', 'text', 'Column odorflap should be text');
SELECT col_type_is('gully', 'connec_length', 'numeric(12,3)', 'Column connec_length should be numeric(12,3)');
SELECT col_type_is('gully', 'connec_depth', 'numeric(12,3)', 'Column connec_depth should be numeric(12,3)');
SELECT col_type_is('gully', 'connec_y2', 'numeric(12,3)', 'Column connec_y2 should be numeric(12,3)');
SELECT col_type_is('gully', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('gully', 'epa_type', 'varchar(16)', 'Column epa_type should be varchar(16)');
SELECT col_type_is('gully', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('gully', 'state_type', 'int2', 'Column state_type should be int2');
SELECT col_type_is('gully', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('gully', 'muni_id', 'int4', 'Column muni_id should be int4');
SELECT col_type_is('gully', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('gully', 'dma_id', 'int4', 'Column dma_id should be int4');
SELECT col_type_is('gully', 'drainzone_outfall', 'integer[]', 'Column drainzone_outfall should be integer[]');
SELECT col_type_is('gully', 'dwfzone_id', 'int4', 'Column dwfzone_id should be int4');
SELECT col_type_is('gully', 'dwfzone_outfall', 'integer[]', 'Column dwfzone_outfall should be integer[]');
SELECT col_type_is('gully', 'omzone_id', 'int4', 'Column omzone_id should be int4');
SELECT col_type_is('gully', 'omunit_id', 'int4', 'Column omunit_id should be int4');
SELECT col_type_is('gully', 'minsector_id', 'int4', 'Column minsector_id should be int4');
SELECT col_type_is('gully', 'soilcat_id', 'varchar(16)', 'Column soilcat_id should be varchar(16)');
SELECT col_type_is('gully', 'function_type', 'varchar(50)', 'Column function_type should be varchar(50)');
SELECT col_type_is('gully', 'category_type', 'varchar(50)', 'Column category_type should be varchar(50)');
SELECT col_type_is('gully', 'location_type', 'varchar(50)', 'Column location_type should be varchar(50)');
SELECT col_type_is('gully', '_fluid_type', 'varchar(50)', 'Column _fluid_type should be varchar(50)');
SELECT col_type_is('gully', 'fluid_type', 'int4', 'Column fluid_type should be int4');
SELECT col_type_is('gully', 'treatment_type', 'int4', 'Column treatment_type should be int4');
SELECT col_type_is('gully', 'has_treatment', 'bool', 'Column has_treatment should be bool');
SELECT col_type_is('gully', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('gully', 'annotation', 'text', 'Column annotation should be text');
SELECT col_type_is('gully', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('gully', 'comment', 'text', 'Column comment should be text');
SELECT col_type_is('gully', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('gully', 'num_value', 'numeric(12,3)', 'Column num_value should be numeric(12,3)');
SELECT col_type_is('gully', 'district_id', 'int4', 'Column district_id should be int4');
SELECT col_type_is('gully', 'postcode', 'varchar(16)', 'Column postcode should be varchar(16)');
SELECT col_type_is('gully', 'streetaxis_id', 'varchar(16)', 'Column streetaxis_id should be varchar(16)');
SELECT col_type_is('gully', 'postnumber', 'int4', 'Column postnumber should be int4');
SELECT col_type_is('gully', 'postcomplement', 'varchar(100)', 'Column postcomplement should be varchar(100)');
SELECT col_type_is('gully', 'streetaxis2_id', 'varchar(16)', 'Column streetaxis2_id should be varchar(16)');
SELECT col_type_is('gully', 'postnumber2', 'int4', 'Column postnumber2 should be int4');
SELECT col_type_is('gully', 'postcomplement2', 'varchar(100)', 'Column postcomplement2 should be varchar(100)');
SELECT col_type_is('gully', 'workcat_id', 'varchar(255)', 'Column workcat_id should be varchar(255)');
SELECT col_type_is('gully', 'workcat_id_end', 'varchar(255)', 'Column workcat_id_end should be varchar(255)');
SELECT col_type_is('gully', 'workcat_id_plan', 'varchar(255)', 'Column workcat_id_plan should be varchar(255)');
SELECT col_type_is('gully', 'builtdate', 'date', 'Column builtdate should be date');
SELECT col_type_is('gully', 'enddate', 'date', 'Column enddate should be date');
SELECT col_type_is('gully', 'ownercat_id', 'varchar(30)', 'Column ownercat_id should be varchar(30)');
SELECT col_type_is('gully', 'om_state', 'int4', 'Column om_state should be int4');
SELECT col_type_is('gully', 'brand_id', 'varchar(50)', 'Column brand_id should be varchar(50)');
SELECT col_type_is('gully', 'model_id', 'varchar(50)', 'Column model_id should be varchar(50)');
SELECT col_type_is('gully', 'pjoint_id', 'int4', 'Column pjoint_id should be int4');
SELECT col_type_is('gully', 'pjoint_type', 'varchar(16)', 'Column pjoint_type should be varchar(16)');
SELECT col_type_is('gully', 'placement_type', 'varchar(50)', 'Column placement_type should be varchar(50)');
SELECT col_type_is('gully', 'access_type', 'text', 'Column access_type should be text');
SELECT col_type_is('gully', 'asset_id', 'varchar(50)', 'Column asset_id should be varchar(50)');
SELECT col_type_is('gully', 'adate', 'text', 'Column adate should be text');
SELECT col_type_is('gully', 'adescript', 'text', 'Column adescript should be text');
SELECT col_type_is('gully', 'verified', 'int4', 'Column verified should be int4');
SELECT col_type_is('gully', 'uncertain', 'bool', 'Column uncertain should be bool');
SELECT col_type_is('gully', 'datasource', 'int4', 'Column datasource should be int4');
SELECT col_type_is('gully', 'label_x', 'varchar(30)', 'Column label_x should be varchar(30)');
SELECT col_type_is('gully', 'label_y', 'varchar(30)', 'Column label_y should be varchar(30)');
SELECT col_type_is('gully', 'label_rotation', 'numeric(6,3)', 'Column label_rotation should be numeric(6,3)');
SELECT col_type_is('gully', 'rotation', 'numeric(6,3)', 'Column rotation should be numeric(6,3)');
SELECT col_type_is('gully', 'label_quadrant', 'varchar(12)', 'Column label_quadrant should be varchar(12)');
SELECT col_type_is('gully', 'inventory', 'bool', 'Column inventory should be bool');
SELECT col_type_is('gully', 'publish', 'bool', 'Column publish should be bool');
SELECT col_type_is('gully', 'lock_level', 'int4', 'Column lock_level should be int4');
SELECT col_type_is('gully', 'expl_visibility', 'smallint[]', 'Column expl_visibility should be smallint[]');
SELECT col_type_is('gully', 'created_at', 'timestamptz', 'Column created_at should be timestamptz');
SELECT col_type_is('gully', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('gully', 'updated_at', 'timestamptz', 'Column updated_at should be timestamptz');
SELECT col_type_is('gully', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');
SELECT col_type_is('gully', 'the_geom', 'geometry(point, 25831)', 'Column the_geom should be geometry(point, 25831)');
SELECT col_type_is('gully', '_connec_arccat_id', 'varchar(18)', 'Column _connec_arccat_id should be varchar(18)');
SELECT col_type_is('gully', '_pol_id_', 'varchar(16)', 'Column _pol_id_ should be varchar(16)');
SELECT col_type_is('gully', '_connec_matcat_id', 'text', 'Column _connec_matcat_id should be text');
SELECT col_type_is('gully', 'uuid', 'uuid', 'Column uuid should be uuid');
SELECT col_type_is('gully', 'xyz_date', 'date', 'Column xyz_date should be date');

-- Check default values
SELECT col_has_default('gully', 'gully_id', 'Column gully_id should have default value');
SELECT col_has_default('gully', 'feature_type', 'Column feature_type should have default value');
SELECT col_has_default('gully', 'expl_id', 'Column expl_id should have default value');
SELECT col_has_default('gully', 'muni_id', 'Column muni_id should have default value');
SELECT col_has_default('gully', 'sector_id', 'Column sector_id should have default value');
SELECT col_has_default('gully', 'dma_id', 'Column dma_id should have default value');
SELECT col_has_default('gully', 'dwfzone_id', 'Column dwfzone_id should have default value');
SELECT col_has_default('gully', 'omzone_id', 'Column omzone_id should have default value');
SELECT col_has_default('gully', 'omunit_id', 'Column omunit_id should have default value');
SELECT col_has_default('gully', 'minsector_id', 'Column minsector_id should have default value');
SELECT col_has_default('gully', 'fluid_type', 'Column fluid_type should have default value');
SELECT col_has_default('gully', 'treatment_type', 'Column treatment_type should have default value');
SELECT col_has_default('gully', 'created_at', 'Column created_at should have default value');
SELECT col_has_default('gully', 'created_by', 'Column created_by should have default value');

-- Check foreign keys
SELECT has_fk('gully', 'Table gully should have foreign keys');

SELECT fk_ok('gully', 'arc_id', 'arc', 'arc_id', 'Table should have foreign key from arc_id to arc.arc_id');
SELECT fk_ok('gully', '_connec_arccat_id', 'cat_connec', 'id', 'Table should have foreign key from _connec_arccat_id to cat_connec.id');
SELECT fk_ok('gully', 'district_id', 'ext_district', 'district_id', 'Table should have foreign key from district_id to ext_district.district_id');
SELECT fk_ok('gully', 'dma_id', 'dma', 'dma_id', 'Table should have foreign key from dma_id to dma.dma_id');
SELECT fk_ok('gully', 'dwfzone_id', 'dwfzone', 'dwfzone_id', 'Table should have foreign key from dwfzone_id to dwfzone.dwfzone_id');
SELECT fk_ok('gully', 'expl_id', 'exploitation', 'expl_id', 'Table should have foreign key from expl_id to exploitation.expl_id');
SELECT fk_ok('gully', 'feature_type', 'sys_feature_type', 'id', 'Table should have foreign key from feature_type to sys_feature_type.id');
SELECT fk_ok('gully', 'gullycat_id', 'cat_gully', 'id', 'Table should have foreign key from gullycat_id to cat_gully.id');
SELECT fk_ok('gully', 'gully_type', 'cat_feature_gully', 'id', 'Table should have foreign key from gully_type to cat_feature_gully.id');
SELECT fk_ok('gully', 'category_type', 'man_type_category', 'category_type', 'Table should have foreign key from category_type to man_type_category.category_type');
SELECT fk_ok('gully', 'function_type', 'man_type_function', 'function_type', 'Table should have foreign key from function_type to man_type_function.function_type');
SELECT fk_ok('gully', 'location_type', 'man_type_location', 'location_type', 'Table should have foreign key from location_type to man_type_location.location_type');
SELECT fk_ok('gully', 'minsector_id', 'minsector', 'minsector_id', 'Table should have foreign key from minsector_id to minsector.minsector_id');
SELECT fk_ok('gully', 'muni_id', 'ext_municipality', 'muni_id', 'Table should have foreign key from muni_id to ext_municipality.muni_id');
SELECT fk_ok('gully', 'omunit_id', 'omunit', 'omunit_id', 'Table should have foreign key from omunit_id to omunit.omunit_id');
SELECT fk_ok('gully', 'omzone_id', 'omzone', 'omzone_id', 'Table should have foreign key from omzone_id to omzone.omzone_id');
SELECT fk_ok('gully', 'ownercat_id', 'cat_owner', 'id', 'Table should have foreign key from ownercat_id to cat_owner.id');
SELECT fk_ok('gully', 'pjoint_type', 'sys_feature_type', 'id', 'Table should have foreign key from pjoint_type to sys_feature_type.id');
SELECT fk_ok('gully', '_pol_id_', 'polygon', 'pol_id', 'Table should have foreign key from _pol_id_ to polygon.pol_id');
SELECT fk_ok('gully', 'sector_id', 'sector', 'sector_id', 'Table should have foreign key from sector_id to sector.sector_id');
SELECT fk_ok('gully', 'soilcat_id', 'cat_soil', 'id', 'Table should have foreign key from soilcat_id to cat_soil.id');
SELECT fk_ok('gully', 'state', 'value_state', 'id', 'Table should have foreign key from state to value_state.id');
SELECT fk_ok('gully', 'state_type', 'value_state_type', 'id', 'Table should have foreign key from state_type to value_state_type.id');
SELECT fk_ok('gully', ARRAY['muni_id','streetaxis_id'], 'ext_streetaxis', ARRAY['muni_id','id'], 'Table should have foreign key from muni_id,streetaxis_id to ext_streetaxis.muni_id,id');
SELECT fk_ok('gully', ARRAY['muni_id','streetaxis2_id'], 'ext_streetaxis', ARRAY['muni_id','id'], 'Table should have foreign key from muni_id,streetaxis2_id to ext_streetaxis.muni_id,id');
SELECT fk_ok('gully', 'workcat_id_end', 'cat_work', 'id', 'Table should have foreign key from workcat_id_end to cat_work.id');
SELECT fk_ok('gully', 'workcat_id', 'cat_work', 'id', 'Table should have foreign key from workcat_id to cat_work.id');

-- Check indexes
SELECT has_index('gully', 'gully_asset_id_idx', 'Table should have index on asset_id');
SELECT has_index('gully', 'gully_dma_id_idx', 'Table should have index on dma_id');
SELECT has_index('gully', 'gully_expl_visibility_gin', 'Table should have index on expl_visibility');
SELECT has_index('gully', 'gully_exploitation', 'Table should have index on expl_id');
SELECT has_index('gully', 'gully_gratecat', 'Table should have index on gullycat_id');
SELECT has_index('gully', 'gully_index', 'Table should have index on the_geom');
SELECT has_index('gully', 'gully_minsector_id_idx', 'Table should have index on minsector_id');
SELECT has_index('gully', 'gully_muni', 'Table should have index on muni_id');
SELECT has_index('gully', 'gully_omunit_id_idx', 'Table should have index on omunit_id');
SELECT has_index('gully', 'gully_omzone', 'Table should have index on omzone_id');
SELECT has_index('gully', 'gully_pkey', 'Table should have index on gully_id');
SELECT has_index('gully', 'gully_sector', 'Table should have index on sector_id');
SELECT has_index('gully', 'gully_street1', 'Table should have index on streetaxis_id');
SELECT has_index('gully', 'gully_street2', 'Table should have index on streetaxis2_id');
SELECT has_index('gully', 'gully_sys_code_idx', 'Table should have index on sys_code');
SELECT has_index('gully', 'idx_gully_arc_id', 'Table should have index on arc_id');

-- Check triggers
SELECT has_trigger('gully', 'gw_trg_cat_material_fk_insert', 'Table should have trigger gw_trg_cat_material_fk_insert');
SELECT has_trigger('gully', 'gw_trg_cat_material_fk_update', 'Table should have trigger gw_trg_cat_material_fk_update');
SELECT has_trigger('gully', 'gw_trg_gully_proximity_insert', 'Table should have trigger gw_trg_gully_proximity_insert');
SELECT has_trigger('gully', 'gw_trg_gully_proximity_update', 'Table should have trigger gw_trg_gully_proximity_update');
SELECT has_trigger('gully', 'gw_trg_connect_update', 'Table should have trigger gw_trg_connect_update');
SELECT has_trigger('gully', 'gw_trg_edit_controls', 'Table should have trigger gw_trg_edit_controls');
SELECT has_trigger('gully', 'gw_trg_link_data', 'Table should have trigger gw_trg_link_data');
SELECT has_trigger('gully', 'gw_trg_typevalue_fk_insert', 'Table should have trigger gw_trg_typevalue_fk_insert');
SELECT has_trigger('gully', 'gw_trg_typevalue_fk_update', 'Table should have trigger gw_trg_typevalue_fk_update');
SELECT has_trigger('gully', 'gw_trg_fk_array_array_table_expl', 'Table should have trigger gw_trg_fk_array_array_table_expl');
SELECT has_trigger('gully', 'gw_trg_plan_psector_after_gully', 'Table should have trigger gw_trg_plan_psector_after_gully');

-- Finish
SELECT * FROM finish();

ROLLBACK;
