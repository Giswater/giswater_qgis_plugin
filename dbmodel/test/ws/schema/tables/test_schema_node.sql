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

-- Check table node
SELECT has_table('node'::name, 'Table node should exist');

-- Check columns
SELECT columns_are(
    'node',
    ARRAY[
        'node_id', 'code', 'sys_code', 'top_elev', 'custom_top_elev', 'datasource', 'depth', 'nodecat_id', 'epa_type',
        'sector_id', 'arc_id', 'parent_id', 'state', 'state_type', 'annotation', 'observ', 'comment',
        'dma_id', 'presszone_id', 'soilcat_id', 'function_type', 'category_type', 'fluid_type',
        'location_type', 'workcat_id', 'workcat_id_end', 'builtdate', 'enddate', 'ownercat_id',
        'muni_id', 'postcode', 'streetaxis_id', 'postnumber', 'postcomplement', 'streetaxis2_id',
        'postnumber2', 'postcomplement2', 'descript', 'link', 'verified', 'rotation',
        'label_x', 'label_y', 'label_rotation', 'publish', 'inventory', 'hemisphere',
        'expl_id', 'num_value', 'feature_type', 'minsector_id', 'dqa_id', 'staticpressure', 'district_id', 'adate',
        'adescript', 'accessibility', 'workcat_id_plan', 'asset_id', 'om_state', 'conserv_state',
        'access_type', 'placement_type', 'expl_visibility', 'brand_id', 'model_id', 'serial_number',
        'label_quadrant', 'supplyzone_id', 'lock_level', 'is_scadamap', 'pavcat_id',
        'omzone_id',
        'the_geom', 'created_at', 'created_by', 'updated_at', 'updated_by', 'uuid', 'uncertain', 'xyz_date'
    ],
    'Table node should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('node', ARRAY['node_id'], 'Column node_id should be primary key');

-- Check column types and defaults
SELECT col_type_is('node', 'node_id', 'integer', 'Column node_id should be integer');
SELECT col_has_default('node', 'node_id', 'Column node_id should have a default value');
SELECT col_type_is('node', 'feature_type', 'varchar(16)', 'Column feature_type should be varchar(16)');
SELECT col_default_is('node', 'feature_type', 'NODE', 'Column feature_type should default to NODE');
SELECT col_type_is('node', 'uuid', 'uuid', 'Column uuid should be uuid');
SELECT col_type_is('node', 'uncertain', 'boolean', 'Column uncertain should be boolean');
SELECT col_type_is('node', 'xyz_date', 'date', 'Column xyz_date should be date');

-- Check foreign keys
SELECT has_fk('node', 'Table node should have foreign keys');
SELECT fk_ok('node', 'arc_id', 'arc', 'arc_id', 'FK arc_id should reference arc.arc_id');
SELECT fk_ok('node', 'district_id', 'ext_district', 'district_id', 'FK district_id should reference ext_district.district_id');
SELECT fk_ok('node', 'dma_id', 'dma', 'dma_id', 'FK dma_id should reference dma.dma_id');
SELECT fk_ok('node', 'dqa_id', 'dqa', 'dqa_id', 'FK dqa_id should reference dqa.dqa_id');
SELECT fk_ok('node', 'expl_id', 'exploitation', 'expl_id', 'FK expl_id should reference exploitation.expl_id');
SELECT fk_ok('node', 'feature_type', 'sys_feature_type', 'id', 'FK feature_type should reference sys_feature_type.id');
SELECT fk_ok('node', 'nodecat_id', 'cat_node', 'id', 'FK nodecat_id should reference cat_node.id');
SELECT fk_ok('node', 'ownercat_id', 'cat_owner', 'id', 'FK ownercat_id should reference cat_owner.id');
SELECT fk_ok('node', 'parent_id', 'node', 'node_id', 'FK parent_id should reference node.node_id');
SELECT fk_ok('node', 'sector_id', 'sector', 'sector_id', 'FK sector_id should reference sector.sector_id');
SELECT fk_ok('node', 'soilcat_id', 'cat_soil', 'id', 'FK soilcat_id should reference cat_soil.id');
SELECT fk_ok('node', 'state', 'value_state', 'id', 'FK state should reference value_state.id');
SELECT fk_ok('node', 'state_type', 'value_state_type', 'id', 'FK state_type should reference value_state_type.id');
SELECT fk_ok('node', 'omzone_id', 'omzone', 'omzone_id', 'FK omzone_id should reference omzone.omzone_id');

-- Check triggers
SELECT has_trigger('node', 'gw_trg_node_arc_divide', 'Table should have gw_trg_node_arc_divide trigger');
SELECT has_trigger('node', 'gw_trg_node_rotation_update', 'Table should have gw_trg_node_rotation_update trigger');
SELECT has_trigger('node', 'gw_trg_node_statecontrol', 'Table should have gw_trg_node_statecontrol trigger');
SELECT has_trigger('node', 'gw_trg_topocontrol_node', 'Table should have gw_trg_topocontrol_node trigger');
SELECT has_trigger('node', 'gw_trg_typevalue_fk_insert', 'Table should have gw_trg_typevalue_fk_insert trigger');
SELECT has_trigger('node', 'gw_trg_typevalue_fk_update', 'Table should have gw_trg_typevalue_fk_update trigger');
SELECT has_trigger('node', 'gw_trg_plan_psector_after_node', 'Table should have gw_trg_plan_psector_after_node trigger');

-- Check rules

-- Check constraints
SELECT col_not_null('node', 'node_id', 'Column node_id should be NOT NULL');
SELECT col_not_null('node', 'nodecat_id', 'Column nodecat_id should be NOT NULL');
SELECT col_not_null('node', 'epa_type', 'Column epa_type should be NOT NULL');
SELECT col_not_null('node', 'sector_id', 'Column sector_id should be NOT NULL');
SELECT col_not_null('node', 'state', 'Column state should be NOT NULL');
SELECT col_not_null('node', 'state_type', 'Column state_type should be NOT NULL');
SELECT col_not_null('node', 'muni_id', 'Column muni_id should be NOT NULL');
SELECT col_not_null('node', 'expl_id', 'Column expl_id should be NOT NULL');

-- Check indexes
SELECT has_index('node', 'node_sys_code_idx', 'Table should have index on sys_code');
SELECT has_index('node', 'node_asset_id_idx', 'Table should have index on asset_id');
SELECT has_index('node', 'node_expl_visibility_gin', 'Table should have index on expl_visibility');

-- Check value constraint
SELECT col_has_check('node', 'epa_type', 'Column epa_type should have a check constraint');

SELECT * FROM finish();

ROLLBACK;