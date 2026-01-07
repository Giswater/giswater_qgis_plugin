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
SELECT has_table('arc'::name, 'Table arc should exist');


-- Check columns
SELECT columns_are(
    'arc',
    ARRAY[
        'arc_id', 'code', 'sys_code', 'node_1', 'nodetype_1', 'node_top_elev_1', 'node_custom_top_elev_1', 'node_elev_1', 'node_custom_elev_1', 'elev1',
        'custom_elev1', 'y1', 'node_2', 'nodetype_2', 'node_top_elev_2', 'node_custom_top_elev_2', 'node_elev_2', 'node_custom_elev_2',
        'elev2', 'custom_elev2', 'y2', 'feature_type', 'arc_type', 'matcat_id', 'arccat_id',
        'epa_type', 'state', 'state_type', 'parent_id', 'expl_id', 'muni_id', 'sector_id', 'dma_id',
        'drainzone_outfall', 'dwfzone_id', 'dwfzone_outfall', 'omzone_id', 'omunit_id', 'minsector_id', 'pavcat_id',
        'soilcat_id', 'function_type', 'category_type', 'location_type', '_fluid_type', 'fluid_type', 'treatment_type',
        'custom_length', 'sys_slope', 'descript', 'annotation', 'observ', 'comment', 'link', 'num_value',
        'district_id', 'postcode', 'streetaxis_id', 'postnumber', 'postcomplement', 'streetaxis2_id', 'postnumber2',
        'postcomplement2', 'workcat_id', 'workcat_id_end', 'workcat_id_plan', 'builtdate', 'registration_date',
        'enddate', 'ownercat_id', 'last_visitdate', 'visitability', 'om_state', 'conserv_state', 'brand_id',
        'model_id', 'serial_number', 'asset_id', 'adate', 'adescript', 'verified', 'uncertain', 'datasource',
        'label_x', 'label_y', 'label_rotation', 'label_quadrant', 'inventory', 'publish', 'is_scadamap',
        'lock_level', 'initoverflowpath', 'inverted_slope', 'negative_offset', 'expl_visibility', 'created_at',
        'created_by', 'updated_at', 'updated_by', 'the_geom', 'meandering', 'uuid'
    ],
    'Table arc should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('arc', 'arc_id', 'Column arc_id should be primary key');

-- Check check columns
SELECT col_has_check('arc', 'epa_type', 'Table should have check on epa_type');

-- Check column types
SELECT col_type_is('arc', 'arc_id', 'integer', 'Column arc_id should be integer');
SELECT col_type_is('arc', 'code', 'text', 'Column code should be text');
SELECT col_type_is('arc', 'sys_code', 'text', 'Column sys_code should be text');
SELECT col_type_is('arc', 'node_1', 'integer', 'Column node_1 should be integer');
SELECT col_type_is('arc', 'nodetype_1', 'varchar(30)', 'Column nodetype_1 should be varchar(30)');
SELECT col_type_is('arc', 'node_top_elev_1', 'numeric(12,3)', 'Column node_top_elev_1 should be numeric(12,3)');
SELECT col_type_is('arc', 'node_custom_top_elev_1', 'numeric(12,3)', 'Column node_custom_top_elev_1 should be numeric(12,3)');
SELECT col_type_is('arc', 'node_elev_1', 'numeric(12,3)', 'Column node_elev_1 should be numeric(12,3)');
SELECT col_type_is('arc', 'node_custom_elev_1', 'numeric(12,3)', 'Column node_custom_elev_1 should be numeric(12,3)');
SELECT col_type_is('arc', 'elev1', 'numeric(12,3)', 'Column elev1 should be numeric(12,3)');
SELECT col_type_is('arc', 'custom_elev1', 'numeric(12,3)', 'Column custom_elev1 should be numeric(12,3)');
SELECT col_type_is('arc', 'y1', 'numeric(12,3)', 'Column y1 should be numeric(12,3)');
SELECT col_type_is('arc', 'node_2', 'integer', 'Column node_2 should be integer');
SELECT col_type_is('arc', 'nodetype_2', 'varchar(30)', 'Column nodetype_2 should be varchar(30)');
SELECT col_type_is('arc', 'node_top_elev_2', 'numeric(12,3)', 'Column node_top_elev_2 should be numeric(12,3)');
SELECT col_type_is('arc', 'node_custom_top_elev_2', 'numeric(12,3)', 'Column node_custom_top_elev_2 should be numeric(12,3)');
SELECT col_type_is('arc', 'node_elev_2', 'numeric(12,3)', 'Column node_elev_2 should be numeric(12,3)');
SELECT col_type_is('arc', 'node_custom_elev_2', 'numeric(12,3)', 'Column node_custom_elev_2 should be numeric(12,3)');
SELECT col_type_is('arc', 'elev2', 'numeric(12,3)', 'Column elev2 should be numeric(12,3)');
SELECT col_type_is('arc', 'custom_elev2', 'numeric(12,3)', 'Column custom_elev2 should be numeric(12,3)');
SELECT col_type_is('arc', 'y2', 'numeric(12,3)', 'Column y2 should be numeric(12,3)');
SELECT col_type_is('arc', 'feature_type', 'varchar(16)', 'Column feature_type should be varchar(16)');
SELECT col_type_is('arc', 'arc_type', 'varchar(18)', 'Column arc_type should be varchar(18)');
SELECT col_type_is('arc', 'matcat_id', 'varchar(30)', 'Column matcat_id should be varchar(30)');
SELECT col_type_is('arc', 'arccat_id', 'varchar(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('arc', 'epa_type', 'varchar(16)', 'Column epa_type should be varchar(16)');
SELECT col_type_is('arc', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('arc', 'state_type', 'int2', 'Column state_type should be int2');
SELECT col_type_is('arc', 'parent_id', 'integer', 'Column parent_id should be integer');
SELECT col_type_is('arc', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('arc', 'muni_id', 'integer', 'Column muni_id should be integer');
SELECT col_type_is('arc', 'sector_id', 'integer', 'Column sector_id should be integer');
SELECT col_type_is('arc', 'dma_id', 'integer', 'Column dma_id should be integer');
SELECT col_type_is('arc', 'drainzone_outfall', 'integer[]', 'Column drainzone_outfall should be integer[]');
SELECT col_type_is('arc', 'dwfzone_id', 'integer', 'Column dwfzone_id should be integer');
SELECT col_type_is('arc', 'dwfzone_outfall', 'integer[]', 'Column dwfzone_outfall should be integer[]');
SELECT col_type_is('arc', 'omzone_id', 'integer', 'Column omzone_id should be integer');
SELECT col_type_is('arc', 'omunit_id', 'integer', 'Column omunit_id should be integer');
SELECT col_type_is('arc', 'minsector_id', 'integer', 'Column minsector_id should be integer');
SELECT col_type_is('arc', 'pavcat_id', 'varchar(30)', 'Column pavcat_id should be varchar(30)');
SELECT col_type_is('arc', 'soilcat_id', 'varchar(16)', 'Column soilcat_id should be varchar(16)');
SELECT col_type_is('arc', 'function_type', 'varchar(50)', 'Column function_type should be varchar(50)');
SELECT col_type_is('arc', 'category_type', 'varchar(50)', 'Column category_type should be varchar(50)');
SELECT col_type_is('arc', 'location_type', 'varchar(50)', 'Column location_type should be varchar(50)');
SELECT col_type_is('arc', '_fluid_type', 'varchar(50)', 'Column _fluid_type should be varchar(50)');
SELECT col_type_is('arc', 'fluid_type', 'integer', 'Column fluid_type should be integer');
SELECT col_type_is('arc', 'treatment_type', 'integer', 'Column treatment_type should be integer');
SELECT col_type_is('arc', 'custom_length', 'numeric(12,2)', 'Column custom_length should be numeric(12,2)');
SELECT col_type_is('arc', 'sys_slope', 'numeric(12,4)', 'Column sys_slope should be numeric(12,4)');
SELECT col_type_is('arc', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('arc', 'annotation', 'text', 'Column annotation should be text');
SELECT col_type_is('arc', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('arc', 'comment', 'text', 'Column comment should be text');
SELECT col_type_is('arc', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('arc', 'num_value', 'numeric(12,3)', 'Column num_value should be numeric(12,3)');
SELECT col_type_is('arc', 'district_id', 'integer', 'Column district_id should be integer');
SELECT col_type_is('arc', 'postcode', 'varchar(16)', 'Column postcode should be varchar(16)');
SELECT col_type_is('arc', 'streetaxis_id', 'varchar(16)', 'Column streetaxis_id should be varchar(16)');
SELECT col_type_is('arc', 'postnumber', 'integer', 'Column postnumber should be integer');
SELECT col_type_is('arc', 'postcomplement', 'varchar(100)', 'Column postcomplement should be varchar(100)');
SELECT col_type_is('arc', 'streetaxis2_id', 'varchar(16)', 'Column streetaxis2_id should be varchar(16)');
SELECT col_type_is('arc', 'postnumber2', 'integer', 'Column postnumber2 should be integer');
SELECT col_type_is('arc', 'postcomplement2', 'varchar(100)', 'Column postcomplement2 should be varchar(100)');
SELECT col_type_is('arc', 'workcat_id', 'varchar(255)', 'Column workcat_id should be varchar(255)');
SELECT col_type_is('arc', 'workcat_id_end', 'varchar(255)', 'Column workcat_id_end should be varchar(255)');
SELECT col_type_is('arc', 'workcat_id_plan', 'varchar(255)', 'Column workcat_id_plan should be varchar(255)');
SELECT col_type_is('arc', 'builtdate', 'date', 'Column builtdate should be date');
SELECT col_type_is('arc', 'registration_date', 'date', 'Column registration_date should be date');
SELECT col_type_is('arc', 'enddate', 'date', 'Column enddate should be date');
SELECT col_type_is('arc', 'ownercat_id', 'varchar(30)', 'Column ownercat_id should be varchar(30)');
SELECT col_type_is('arc', 'last_visitdate', 'date', 'Column last_visitdate should be date');
SELECT col_type_is('arc', 'visitability', 'integer', 'Column visitability should be integer');
SELECT col_type_is('arc', 'om_state', 'text', 'Column om_state should be text');
SELECT col_type_is('arc', 'conserv_state', 'text', 'Column conserv_state should be text');
SELECT col_type_is('arc', 'brand_id', 'varchar(50)', 'Column brand_id should be varchar(50)');
SELECT col_type_is('arc', 'model_id', 'varchar(50)', 'Column model_id should be varchar(50)');
SELECT col_type_is('arc', 'serial_number', 'varchar(100)', 'Column serial_number should be varchar(100)');
SELECT col_type_is('arc', 'asset_id', 'varchar(50)', 'Column asset_id should be varchar(50)');
SELECT col_type_is('arc', 'adate', 'text', 'Column adate should be text');
SELECT col_type_is('arc', 'adescript', 'text', 'Column adescript should be text');
SELECT col_type_is('arc', 'verified', 'integer', 'Column verified should be integer');
SELECT col_type_is('arc', 'uncertain', 'boolean', 'Column uncertain should be boolean');
SELECT col_type_is('arc', 'datasource', 'integer', 'Column datasource should be integer');
SELECT col_type_is('arc', 'label_x', 'varchar(30)', 'Column label_x should be varchar(30)');
SELECT col_type_is('arc', 'label_y', 'varchar(30)', 'Column label_y should be varchar(30)');
SELECT col_type_is('arc', 'label_rotation', 'numeric(6,3)', 'Column label_rotation should be numeric(6,3)');
SELECT col_type_is('arc', 'label_quadrant', 'varchar(12)', 'Column label_quadrant should be varchar(12)');
SELECT col_type_is('arc', 'inventory', 'boolean', 'Column inventory should be boolean');
SELECT col_type_is('arc', 'publish', 'boolean', 'Column publish should be boolean');
SELECT col_type_is('arc', 'is_scadamap', 'boolean', 'Column is_scadamap should be boolean');
SELECT col_type_is('arc', 'lock_level', 'integer', 'Column lock_level should be integer');
SELECT col_type_is('arc', 'initoverflowpath', 'boolean', 'Column initoverflowpath should be boolean');
SELECT col_type_is('arc', 'inverted_slope', 'boolean', 'Column inverted_slope should be boolean');
SELECT col_type_is('arc', 'negative_offset', 'boolean', 'Column negative_offset should be boolean');
SELECT col_type_is('arc', 'expl_visibility', 'smallint[]', 'Column expl_visibility should be smallint[]');
SELECT col_type_is('arc', 'created_at', 'timestamptz', 'Column created_at should be timestamptz');
SELECT col_type_is('arc', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('arc', 'updated_at', 'timestamptz', 'Column updated_at should be timestamptz');
SELECT col_type_is('arc', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');
SELECT col_type_is('arc', 'the_geom', 'geometry(linestring, 25831)', 'Column the_geom should be geometry(linestring, 25831)');
SELECT col_type_is('arc', 'meandering', 'integer', 'Column meandering should be integer');
SELECT col_type_is('arc', 'uuid', 'uuid', 'Column uuid should be uuid');

-- Check default values
SELECT col_has_default('arc', 'arc_id', 'Column arc_id should have default value');
SELECT col_has_default('arc', 'feature_type', 'Column feature_type should have default value');
SELECT col_has_default('arc', 'expl_id', 'Column expl_id should have default value');
SELECT col_has_default('arc', 'muni_id', 'Column muni_id should have default value');
SELECT col_has_default('arc', 'sector_id', 'Column sector_id should have default value');
SELECT col_has_default('arc', 'dwfzone_id', 'Column dwfzone_id should have default value');
SELECT col_has_default('arc', 'omzone_id', 'Column omzone_id should have default value');
SELECT col_has_default('arc', 'omunit_id', 'Column omunit_id should have default value');
SELECT col_has_default('arc', 'minsector_id', 'Column minsector_id should have default value');
SELECT col_has_default('arc', 'fluid_type', 'Column fluid_type should have default value');
SELECT col_has_default('arc', 'initoverflowpath', 'Column initoverflowpath should have default value');
SELECT col_has_default('arc', 'inverted_slope', 'Column inverted_slope should have default value');
SELECT col_has_default('arc', 'negative_offset', 'Column negative_offset should have default value');
SELECT col_has_default('arc', 'created_at', 'Column created_at should have default value');
SELECT col_has_default('arc', 'created_by', 'Column created_by should have default value');

-- Check foreign keys
SELECT has_fk('arc', 'Table arc should have foreign keys');

SELECT fk_ok('arc','arc_type','cat_feature_arc','id','Table should have foreign key from arc_type to cat_feature_arc.id');
SELECT fk_ok('arc','arccat_id','cat_arc','id','Table should have foreign key from arccat_id to cat_arc.id');
SELECT fk_ok('arc','district_id','ext_district','district_id','Table should have foreign key from district_id to ext_district.district_id');
SELECT fk_ok('arc','dma_id','dma','dma_id','Table should have foreign key from dma_id to dma.dma_id');
SELECT fk_ok('arc','dwfzone_id','dwfzone','dwfzone_id','Table should have foreign key from dwfzone_id to dwfzone.dwfzone_id');
SELECT fk_ok('arc','expl_id','exploitation','expl_id','Table should have foreign key from expl_id to exploitation.expl_id');
SELECT fk_ok('arc','feature_type','sys_feature_type','id','Table should have foreign key from feature_type to sys_feature_type.id');
SELECT fk_ok('arc','muni_id','ext_municipality','muni_id','Table should have foreign key from muni_id to ext_municipality.muni_id');
SELECT fk_ok('arc','node_1','node','node_id','Table should have foreign key from node_1 to node.node_id');
SELECT fk_ok('arc','node_2','node','node_id','Table should have foreign key from node_2 to node.node_id');
SELECT fk_ok('arc','omzone_id','omzone','omzone_id','Table should have foreign key from omzone_id to omzone.omzone_id');
SELECT fk_ok('arc','ownercat_id','cat_owner','id','Table should have foreign key from ownercat_id to cat_owner.id');
SELECT fk_ok('arc','parent_id','node','node_id','Table should have foreign key from parent_id to node.node_id');
SELECT fk_ok('arc','pavcat_id','cat_pavement','id','Table should have foreign key from pavcat_id to cat_pavement.id');
SELECT fk_ok('arc','sector_id','sector','sector_id','Table should have foreign key from sector_id to sector.sector_id');
SELECT fk_ok('arc','soilcat_id','cat_soil','id','Table should have foreign key from soilcat_id to cat_soil.id');
SELECT fk_ok('arc','state','value_state','id','Table should have foreign key from state to value_state.id');
SELECT fk_ok('arc','state_type','value_state_type','id','Table should have foreign key from state_type to value_state_type.id');
SELECT fk_ok('arc',ARRAY['muni_id','streetaxis2_id'],'ext_streetaxis',ARRAY['muni_id','id'],'Table should have foreign key from muni_id,streetaxis2_id to ext_streetaxis.muni_id,id');
SELECT fk_ok('arc',ARRAY['muni_id','streetaxis_id'],'ext_streetaxis',ARRAY['muni_id','id'],'Table should have foreign key from muni_id,streetaxis_id to ext_streetaxis.muni_id,id');
SELECT fk_ok('arc','workcat_id_end','cat_work','id','Table should have foreign key from workcat_id_end to cat_work.id');
SELECT fk_ok('arc','workcat_id','cat_work','id','Table should have foreign key from workcat_id to cat_work.id');


-- Check indexes
SELECT has_index('arc', 'arc_arccat', ARRAY['arccat_id'], 'Table should have index on arccat_id');
SELECT has_index('arc', 'arc_pkey', ARRAY['arc_id'], 'Table should have index on arc_id');
SELECT has_index('arc', 'arc_asset_id_idx', ARRAY['asset_id'], 'Table should have index on asset_id');
SELECT has_index('arc', 'arc_expl_visibility_gin', ARRAY['expl_visibility'], 'Table should have index on expl_visibility');
SELECT has_index('arc', 'arc_exploitation', ARRAY['expl_id'], 'Table should have index on expl_id');
SELECT has_index('arc', 'arc_index', ARRAY['the_geom'], 'Table should have index on the_geom');
SELECT has_index('arc', 'arc_muni', ARRAY['muni_id'], 'Table should have index on muni_id');
SELECT has_index('arc', 'arc_node1', ARRAY['node_1'], 'Table should have index on node_1');
SELECT has_index('arc', 'arc_node2', ARRAY['node_2'], 'Table should have index on node_2');
SELECT has_index('arc', 'arc_omzone', ARRAY['omzone_id'], 'Table should have index on omzone_id');
SELECT has_index('arc', 'arc_sector', ARRAY['sector_id'], 'Table should have index on sector_id');
SELECT has_index('arc', 'arc_street1', ARRAY['streetaxis_id'], 'Table should have index on streetaxis_id');
SELECT has_index('arc', 'arc_street2', ARRAY['streetaxis2_id'], 'Table should have index on streetaxis2_id');
SELECT has_index('arc', 'arc_sys_code_idx', ARRAY['sys_code'], 'Table should have index on sys_code');

-- Check triggers
SELECT has_trigger('arc','gw_trg_cat_material_fk_insert','Table should have trigger gw_trg_cat_material_fk_insert');
SELECT has_trigger('arc','gw_trg_cat_material_fk_update','Table should have trigger gw_trg_cat_material_fk_update');
SELECT has_trigger('arc','gw_trg_arc_link_update','Table should have trigger gw_trg_arc_link_update');
SELECT has_trigger('arc','gw_trg_arc_node_values','Table should have trigger gw_trg_arc_node_values');
SELECT has_trigger('arc','gw_trg_arc_noderotation_update','Table should have trigger gw_trg_arc_noderotation_update');
SELECT has_trigger('arc','gw_trg_edit_controls','Table should have trigger gw_trg_edit_controls');
SELECT has_trigger('arc','gw_trg_topocontrol_arc','Table should have trigger gw_trg_topocontrol_arc');
SELECT has_trigger('arc','gw_trg_typevalue_fk_insert','Table should have trigger gw_trg_typevalue_fk_insert');
SELECT has_trigger('arc','gw_trg_typevalue_fk_update','Table should have trigger gw_trg_typevalue_fk_update');
SELECT has_trigger('arc', 'gw_trg_plan_psector_after_arc', 'Table should have trigger gw_trg_plan_psector_after_arc');

-- Check rules

-- Finish
SELECT * FROM finish();

ROLLBACK;