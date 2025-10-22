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

-- Check table arc
SELECT has_table('arc'::name, 'Table arc should exist');

-- Check columns
SELECT columns_are(
    'arc',
    ARRAY[
        'arc_id', 'code', 'sys_code', 'node_1', 'node_2', 'arccat_id', 'epa_type', 'sector_id', 'state', 'state_type', 'annotation',
        'observ', 'comment', 'custom_length', 'dma_id', 'presszone_id', 'soilcat_id', 'function_type', 'category_type',
        'fluid_type', 'location_type', 'workcat_id', 'workcat_id_end', 'builtdate', 'enddate', 'ownercat_id', 'muni_id',
        'postcode', 'streetaxis_id', 'postnumber', 'postcomplement', 'streetaxis2_id', 'postnumber2', 'postcomplement2',
        'descript', 'link', 'verified', 'label_x', 'label_y', 'label_rotation', 'publish',
        'inventory', 'expl_id', 'num_value', 'feature_type',
        'minsector_id', 'dqa_id', 'district_id', 'adate', 'adescript', 'workcat_id_plan', 'asset_id', 'pavcat_id',
        'nodetype_1', 'elevation1', 'depth1', 'staticpressure1', 'nodetype_2', 'elevation2', 'depth2', 'staticpressure2',
        'om_state', 'conserv_state', 'parent_id', 'expl_visibility', 'brand_id', 'model_id', 'serial_number', 'label_quadrant',
        'supplyzone_id', 'datasource', 'lock_level', 'is_scadamap',
        'omzone_id', 'the_geom', 'created_at', 'created_by', 'updated_at', 'updated_by', 'uuid'
    ],
    'Table arc should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('arc', 'arc_id', 'Column arc_id should be primary key');

-- Check indexes
SELECT has_index('arc', 'arc_arccat', 'Table should have index on arccat_id');
SELECT has_index('arc', 'arc_dma', 'Table should have index on dma_id');
SELECT has_index('arc', 'arc_dqa', 'Table should have index on dqa_id');
SELECT has_index('arc', 'arc_exploitation', 'Table should have index on expl_id');
SELECT has_index('arc', 'arc_expl_visibility_idx', 'Table should have index on expl_visibility');
SELECT has_index('arc', 'arc_index', 'Table should have spatial index');
SELECT has_index('arc', 'arc_muni', 'Table should have index on muni_id');
SELECT has_index('arc', 'arc_node1', 'Table should have index on node_1');
SELECT has_index('arc', 'arc_node2', 'Table should have index on node_2');
SELECT has_index('arc', 'arc_presszone', 'Table should have index on presszone_id');
SELECT has_index('arc', 'arc_sector', 'Table should have index on sector_id');
SELECT has_index('arc', 'arc_street1', 'Table should have index on streetaxis_id');
SELECT has_index('arc', 'arc_street2', 'Table should have index on streetaxis2_id');
SELECT has_index('arc', 'arc_sys_code_idx', 'Table should have index on sys_code');
SELECT has_index('arc', 'arc_asset_id_idx', 'Table should have index on asset_id');

-- Check column types
SELECT col_type_is('arc', 'arc_id', 'integer', 'Column arc_id should be integer');
SELECT col_type_is('arc', 'code', 'text', 'Column code should be text');
SELECT col_type_is('arc', 'sys_code', 'text', 'Column sys_code should be text');
SELECT col_type_is('arc', 'node_1', 'integer', 'Column node_1 should be integer');
SELECT col_type_is('arc', 'node_2', 'integer', 'Column node_2 should be integer');
SELECT col_type_is('arc', 'arccat_id', 'varchar(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('arc', 'epa_type', 'varchar(16)', 'Column epa_type should be varchar(16)');
SELECT col_type_is('arc', 'sector_id', 'integer', 'Column sector_id should be integer');
SELECT col_type_is('arc', 'state', 'smallint', 'Column state should be smallint');
SELECT col_type_is('arc', 'state_type', 'smallint', 'Column state_type should be smallint');
SELECT col_type_is('arc', 'annotation', 'text', 'Column annotation should be text');
SELECT col_type_is('arc', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('arc', 'comment', 'text', 'Column comment should be text');
SELECT col_type_is('arc', 'custom_length', 'numeric(12,2)', 'Column custom_length should be numeric(12,2)');
SELECT col_type_is('arc', 'dma_id', 'integer', 'Column dma_id should be integer');
SELECT col_type_is('arc', 'presszone_id', 'integer', 'Column presszone_id should be integer');
SELECT col_type_is('arc', 'soilcat_id', 'varchar(30)', 'Column soilcat_id should be varchar(30)');
SELECT col_type_is('arc', 'function_type', 'varchar(50)', 'Column function_type should be varchar(50)');
SELECT col_type_is('arc', 'category_type', 'varchar(50)', 'Column category_type should be varchar(50)');
SELECT col_type_is('arc', 'fluid_type', 'varchar(50)', 'Column fluid_type should be varchar(50)');
SELECT col_type_is('arc', 'location_type', 'varchar(50)', 'Column location_type should be varchar(50)');
SELECT col_type_is('arc', 'workcat_id', 'varchar(255)', 'Column workcat_id should be varchar(255)');
SELECT col_type_is('arc', 'workcat_id_end', 'varchar(255)', 'Column workcat_id_end should be varchar(255)');
SELECT col_type_is('arc', 'builtdate', 'date', 'Column builtdate should be date');
SELECT col_type_is('arc', 'enddate', 'date', 'Column enddate should be date');
SELECT col_type_is('arc', 'ownercat_id', 'varchar(30)', 'Column ownercat_id should be varchar(30)');
SELECT col_type_is('arc', 'muni_id', 'integer', 'Column muni_id should be integer');
SELECT col_type_is('arc', 'postcode', 'varchar(16)', 'Column postcode should be varchar(16)');
SELECT col_type_is('arc', 'streetaxis_id', 'varchar(16)', 'Column streetaxis_id should be varchar(16)');
SELECT col_type_is('arc', 'postnumber', 'integer', 'Column postnumber should be integer');
SELECT col_type_is('arc', 'postcomplement', 'varchar(100)', 'Column postcomplement should be varchar(100)');
SELECT col_type_is('arc', 'streetaxis2_id', 'varchar(16)', 'Column streetaxis2_id should be varchar(16)');
SELECT col_type_is('arc', 'postnumber2', 'integer', 'Column postnumber2 should be integer');
SELECT col_type_is('arc', 'postcomplement2', 'varchar(100)', 'Column postcomplement2 should be varchar(100)');
SELECT col_type_is('arc', 'descript', 'varchar(254)', 'Column descript should be varchar(254)');
SELECT col_type_is('arc', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('arc', 'verified', 'integer', 'Column verified should be integer');
SELECT col_type_is('arc', 'label_x', 'varchar(30)', 'Column label_x should be varchar(30)');
SELECT col_type_is('arc', 'label_y', 'varchar(30)', 'Column label_y should be varchar(30)');
SELECT col_type_is('arc', 'label_rotation', 'numeric(6,3)', 'Column label_rotation should be numeric(6,3)');
SELECT col_type_is('arc', 'publish', 'boolean', 'Column publish should be boolean');
SELECT col_type_is('arc', 'inventory', 'boolean', 'Column inventory should be boolean');
SELECT col_type_is('arc', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('arc', 'num_value', 'numeric(12,3)', 'Column num_value should be numeric(12,3)');
SELECT col_type_is('arc', 'feature_type', 'varchar(16)', 'Column feature_type should be varchar(16)');
SELECT col_type_is('arc', 'minsector_id', 'integer', 'Column minsector_id should be integer');
SELECT col_type_is('arc', 'dqa_id', 'integer', 'Column dqa_id should be integer');
SELECT col_type_is('arc', 'district_id', 'integer', 'Column district_id should be integer');
SELECT col_type_is('arc', 'adate', 'text', 'Column adate should be text');
SELECT col_type_is('arc', 'adescript', 'text', 'Column adescript should be text');
SELECT col_type_is('arc', 'workcat_id_plan', 'varchar(255)', 'Column workcat_id_plan should be varchar(255)');
SELECT col_type_is('arc', 'asset_id', 'varchar(50)', 'Column asset_id should be varchar(50)');
SELECT col_type_is('arc', 'pavcat_id', 'varchar(30)', 'Column pavcat_id should be varchar(30)');
SELECT col_type_is('arc', 'nodetype_1', 'varchar(30)', 'Column nodetype_1 should be varchar(30)');
SELECT col_type_is('arc', 'elevation1', 'numeric(12,4)', 'Column elevation1 should be numeric(12,4)');
SELECT col_type_is('arc', 'depth1', 'numeric(12,4)', 'Column depth1 should be numeric(12,4)');
SELECT col_type_is('arc', 'staticpressure1', 'numeric(12,3)', 'Column staticpressure1 should be numeric(12,3)');
SELECT col_type_is('arc', 'nodetype_2', 'varchar(30)', 'Column nodetype_2 should be varchar(30)');
SELECT col_type_is('arc', 'elevation2', 'numeric(12,4)', 'Column elevation2 should be numeric(12,4)');
SELECT col_type_is('arc', 'depth2', 'numeric(12,4)', 'Column depth2 should be numeric(12,4)');
SELECT col_type_is('arc', 'staticpressure2', 'numeric(12,3)', 'Column staticpressure2 should be numeric(12,3)');
SELECT col_type_is('arc', 'om_state', 'text', 'Column om_state should be text');
SELECT col_type_is('arc', 'conserv_state', 'text', 'Column conserv_state should be text');
SELECT col_type_is('arc', 'parent_id', 'integer', 'Column parent_id should be integer');
SELECT col_type_is('arc', 'expl_visibility', 'smallint[]', 'Column expl_visibility should be integer[]');
SELECT col_type_is('arc', 'brand_id', 'varchar(50)', 'Column brand_id should be varchar(50)');
SELECT col_type_is('arc', 'model_id', 'varchar(50)', 'Column model_id should be varchar(50)');
SELECT col_type_is('arc', 'serial_number', 'varchar(100)', 'Column serial_number should be varchar(100)');
SELECT col_type_is('arc', 'label_quadrant', 'varchar(12)', 'Column label_quadrant should be varchar(12)');
SELECT col_type_is('arc', 'supplyzone_id', 'integer', 'Column supplyzone_id should be integer');
SELECT col_type_is('arc', 'datasource', 'integer', 'Column datasource should be integer');
SELECT col_type_is('arc', 'lock_level', 'integer', 'Column lock_level should be integer');
SELECT col_type_is('arc', 'is_scadamap', 'boolean', 'Column is_scadamap should be boolean');
SELECT col_type_is('arc', 'omzone_id', 'integer', 'Column omzone_id should be integer');
SELECT col_type_is('arc', 'the_geom', 'geometry(LineString,SRID_VALUE)', 'Column the_geom should be geometry(LineString,SRID_VALUE)');
SELECT col_type_is('arc', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('arc', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('arc', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('arc', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');
SELECT col_type_is('arc', 'uuid', 'uuid', 'Column uuid should be uuid');

-- Check foreign keys
SELECT has_fk('arc', 'Table arc should have foreign keys');
SELECT fk_ok('arc', ARRAY['arccat_id'], 'cat_arc', ARRAY['id'], 'Table should have foreign key from arccat_id to cat_arc.id');
SELECT fk_ok('arc', ARRAY['district_id'], 'ext_district', ARRAY['district_id'], 'Table should have foreign key from district_id to ext_district.district_id');
SELECT fk_ok('arc', ARRAY['dma_id'], 'dma', ARRAY['dma_id'], 'Table should have foreign key from dma_id to dma.dma_id');
SELECT fk_ok('arc', ARRAY['dqa_id'], 'dqa', ARRAY['dqa_id'], 'Table should have foreign key from dqa_id to dqa.dqa_id');
SELECT fk_ok('arc', ARRAY['expl_id'], 'exploitation', ARRAY['expl_id'], 'Table should have foreign key from expl_id to exploitation.expl_id');
SELECT fk_ok('arc', ARRAY['feature_type'], 'sys_feature_type', ARRAY['id'], 'Table should have foreign key from feature_type to sys_feature_type.id');
SELECT fk_ok('arc', ARRAY['muni_id'], 'ext_municipality', ARRAY['muni_id'], 'Table should have foreign key from muni_id to ext_municipality.muni_id');
SELECT fk_ok('arc', ARRAY['node_1'], 'node', ARRAY['node_id'], 'Table should have foreign key from node_1 to node.node_id');
SELECT fk_ok('arc', ARRAY['node_2'], 'node', ARRAY['node_id'], 'Table should have foreign key from node_2 to node.node_id');
SELECT fk_ok('arc', ARRAY['ownercat_id'], 'cat_owner', ARRAY['id'], 'Table should have foreign key from ownercat_id to cat_owner.id');
SELECT fk_ok('arc', ARRAY['parent_id'], 'node', ARRAY['node_id'], 'Table should have foreign key from parent_id to node.node_id');
SELECT fk_ok('arc', ARRAY['pavcat_id'], 'cat_pavement', ARRAY['id'], 'Table should have foreign key from pavcat_id to cat_pavement.id');
SELECT fk_ok('arc', ARRAY['presszone_id'], 'presszone', ARRAY['presszone_id'], 'Table should have foreign key from presszone_id to presszone.presszone_id');
SELECT fk_ok('arc', ARRAY['sector_id'], 'sector', ARRAY['sector_id'], 'Table should have foreign key from sector_id to sector.sector_id');
SELECT fk_ok('arc', ARRAY['soilcat_id'], 'cat_soil', ARRAY['id'], 'Table should have foreign key from soilcat_id to cat_soil.id');
SELECT fk_ok('arc', ARRAY['state'], 'value_state', ARRAY['id'], 'Table should have foreign key from state to value_state.id');
SELECT fk_ok('arc', ARRAY['state_type'], 'value_state_type', ARRAY['id'], 'Table should have foreign key from state_type to value_state_type.id');
SELECT fk_ok('arc', ARRAY['muni_id', 'streetaxis2_id'], 'ext_streetaxis', ARRAY['muni_id', 'id'], 'Table should have foreign key from muni_id,streetaxis2_id to ext_streetaxis.muni_id,id');
SELECT fk_ok('arc', ARRAY['muni_id', 'streetaxis_id'], 'ext_streetaxis', ARRAY['muni_id', 'id'], 'Table should have foreign key from muni_id,streetaxis_id to ext_streetaxis.muni_id,id');
SELECT fk_ok('arc', ARRAY['supplyzone_id'], 'supplyzone', ARRAY['supplyzone_id'], 'Table should have foreign key from supplyzone_id to supplyzone.supplyzone_id');
SELECT fk_ok('arc', ARRAY['workcat_id_end'], 'cat_work', ARRAY['id'], 'Table should have foreign key from workcat_id_end to cat_work.id');
SELECT fk_ok('arc', ARRAY['workcat_id'], 'cat_work', ARRAY['id'], 'Table should have foreign key from workcat_id to cat_work.id');
SELECT fk_ok('arc', ARRAY['omzone_id'], 'omzone', ARRAY['omzone_id'], 'Table should have foreign key from omzone_id to omzone.omzone_id');


-- Check triggers
SELECT has_trigger('arc', 'gw_trg_arc_link_update', 'Table should have trigger gw_trg_arc_link_update');
SELECT has_trigger('arc', 'gw_trg_arc_node_values', 'Table should have trigger gw_trg_arc_node_values');
SELECT has_trigger('arc', 'gw_trg_arc_noderotation_update', 'Table should have trigger gw_trg_arc_noderotation_update');
SELECT has_trigger('arc', 'gw_trg_edit_controls', 'Table should have trigger gw_trg_edit_controls');
SELECT has_trigger('arc', 'gw_trg_topocontrol_arc', 'Table should have trigger gw_trg_topocontrol_arc');
SELECT has_trigger('arc', 'gw_trg_typevalue_fk_insert', 'Table should have trigger gw_trg_typevalue_fk_insert');
SELECT has_trigger('arc', 'gw_trg_typevalue_fk_update', 'Table should have trigger gw_trg_typevalue_fk_update');
SELECT has_trigger('arc', 'gw_trg_plan_psector_after_arc', 'Table should have trigger gw_trg_plan_psector_after_arc');

-- Check rules

-- Check sequences

-- Check constraints

SELECT * FROM finish();

ROLLBACK;
