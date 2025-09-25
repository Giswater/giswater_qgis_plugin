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

-- Check table connec
SELECT has_table('connec'::name, 'Table connec should exist');

-- Check columns
SELECT columns_are(
    'connec',
    ARRAY[
        'connec_id', 'code', 'sys_code', 'top_elev', 'depth', 'conneccat_id', 'sector_id', 'customer_code', 'state', 'state_type',
        'arc_id', 'connec_length', 'annotation', 'observ', 'comment', 'dma_id', 'presszone_id', 'soilcat_id',
        'function_type', 'category_type', 'fluid_type', 'location_type', 'workcat_id', 'workcat_id_end', 'builtdate',
        'enddate', 'ownercat_id', 'muni_id', 'postcode', 'streetaxis_id', 'postnumber', 'postcomplement',
        'streetaxis2_id', 'postnumber2', 'postcomplement2', 'descript', 'link', 'verified', 'rotation',
        'label_x', 'label_y', 'label_rotation', 'publish', 'inventory', 'expl_id', 'num_value',
        'feature_type', 'pjoint_type', 'pjoint_id',
        'minsector_id', 'dqa_id', 'staticpressure', 'district_id', 'adate', 'adescript', 'accessibility',
        'workcat_id_plan', 'asset_id', 'epa_type', 'om_state', 'conserv_state', 'priority',
        'access_type', 'placement_type', 'crmzone_id', 'expl_visibility', 'plot_code',
        'brand_id', 'model_id', 'serial_number', 'label_quadrant', 'n_hydrometer',
        'n_inhabitants', 'supplyzone_id', 'datasource', 'lock_level', 'block_code',
        'omzone_id', 'the_geom', 'created_at', 'created_by', 'updated_at', 'updated_by', 'uuid'
    ],
    'Table connec should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('connec', ARRAY['connec_id'], 'Column connec_id should be primary key');

-- Check column types
SELECT col_type_is('connec', 'connec_id', 'integer', 'Column connec_id should be integer');
SELECT col_type_is('connec', 'code', 'text', 'Column code should be text');
SELECT col_type_is('connec', 'sys_code', 'text', 'Column sys_code should be text');
SELECT col_type_is('connec', 'top_elev', 'numeric(12,4)', 'Column top_elev should be numeric(12,4)');
SELECT col_type_is('connec', 'depth', 'numeric(12,4)', 'Column depth should be numeric(12,4)');
SELECT col_type_is('connec', 'conneccat_id', 'varchar(30)', 'Column conneccat_id should be varchar(30)');
SELECT col_type_is('connec', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('connec', 'customer_code', 'varchar(30)', 'Column customer_code should be varchar(30)');
SELECT col_type_is('connec', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('connec', 'state_type', 'int2', 'Column state_type should be int2');
SELECT col_type_is('connec', 'arc_id', 'integer', 'Column arc_id should be integer');
SELECT col_type_is('connec', 'connec_length', 'numeric(12,3)', 'Column connec_length should be numeric(12,3)');
SELECT col_type_is('connec', 'annotation', 'text', 'Column annotation should be text');
SELECT col_type_is('connec', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('connec', 'comment', 'text', 'Column comment should be text');
SELECT col_type_is('connec', 'dma_id', 'int4', 'Column dma_id should be int4');
SELECT col_type_is('connec', 'presszone_id', 'int4', 'Column presszone_id should be int4');
SELECT col_type_is('connec', 'soilcat_id', 'varchar(16)', 'Column soilcat_id should be varchar(16)');
SELECT col_type_is('connec', 'function_type', 'varchar(50)', 'Column function_type should be varchar(50)');
SELECT col_type_is('connec', 'category_type', 'varchar(50)', 'Column category_type should be varchar(50)');
SELECT col_type_is('connec', 'fluid_type', 'varchar(50)', 'Column fluid_type should be varchar(50)');
SELECT col_type_is('connec', 'location_type', 'varchar(50)', 'Column location_type should be varchar(50)');
SELECT col_type_is('connec', 'workcat_id', 'varchar(255)', 'Column workcat_id should be varchar(255)');
SELECT col_type_is('connec', 'workcat_id_end', 'varchar(255)', 'Column workcat_id_end should be varchar(255)');
SELECT col_type_is('connec', 'builtdate', 'date', 'Column builtdate should be date');
SELECT col_type_is('connec', 'enddate', 'date', 'Column enddate should be date');
SELECT col_type_is('connec', 'ownercat_id', 'varchar(30)', 'Column ownercat_id should be varchar(30)');
SELECT col_type_is('connec', 'muni_id', 'int4', 'Column muni_id should be int4');
SELECT col_type_is('connec', 'postcode', 'varchar(16)', 'Column postcode should be varchar(16)');
SELECT col_type_is('connec', 'streetaxis_id', 'varchar(16)', 'Column streetaxis_id should be varchar(16)');
SELECT col_type_is('connec', 'postnumber', 'int4', 'Column postnumber should be int4');
SELECT col_type_is('connec', 'postcomplement', 'varchar(100)', 'Column postcomplement should be varchar(100)');
SELECT col_type_is('connec', 'streetaxis2_id', 'varchar(16)', 'Column streetaxis2_id should be varchar(16)');
SELECT col_type_is('connec', 'postnumber2', 'int4', 'Column postnumber2 should be int4');
SELECT col_type_is('connec', 'postcomplement2', 'varchar(100)', 'Column postcomplement2 should be varchar(100)');
SELECT col_type_is('connec', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('connec', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('connec', 'verified', 'int4', 'Column verified should be int4');
SELECT col_type_is('connec', 'rotation', 'numeric(6,3)', 'Column rotation should be numeric(6,3)');
SELECT col_type_is('connec', 'label_x', 'varchar(30)', 'Column label_x should be varchar(30)');
SELECT col_type_is('connec', 'label_y', 'varchar(30)', 'Column label_y should be varchar(30)');
SELECT col_type_is('connec', 'label_rotation', 'numeric(6,3)', 'Column label_rotation should be numeric(6,3)');
SELECT col_type_is('connec', 'publish', 'bool', 'Column publish should be bool');
SELECT col_type_is('connec', 'inventory', 'bool', 'Column inventory should be bool');
SELECT col_type_is('connec', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('connec', 'num_value', 'numeric(12,3)', 'Column num_value should be numeric(12,3)');
SELECT col_type_is('connec', 'feature_type', 'varchar(16)', 'Column feature_type should be varchar(16)');
SELECT col_type_is('connec', 'pjoint_type', 'varchar(16)', 'Column pjoint_type should be varchar(16)');
SELECT col_type_is('connec', 'pjoint_id', 'integer', 'Column pjoint_id should be integer');
SELECT col_type_is('connec', 'minsector_id', 'int4', 'Column minsector_id should be int4');
SELECT col_type_is('connec', 'dqa_id', 'int4', 'Column dqa_id should be int4');
SELECT col_type_is('connec', 'staticpressure', 'numeric(12,3)', 'Column staticpressure should be numeric(12,3)');
SELECT col_type_is('connec', 'district_id', 'int4', 'Column district_id should be int4');
SELECT col_type_is('connec', 'adate', 'text', 'Column adate should be text');
SELECT col_type_is('connec', 'adescript', 'text', 'Column adescript should be text');
SELECT col_type_is('connec', 'accessibility', 'int2', 'Column accessibility should be int2');
SELECT col_type_is('connec', 'workcat_id_plan', 'varchar(255)', 'Column workcat_id_plan should be varchar(255)');
SELECT col_type_is('connec', 'asset_id', 'varchar(50)', 'Column asset_id should be varchar(50)');
SELECT col_type_is('connec', 'epa_type', 'text', 'Column epa_type should be text');
SELECT col_type_is('connec', 'om_state', 'text', 'Column om_state should be text');
SELECT col_type_is('connec', 'conserv_state', 'text', 'Column conserv_state should be text');
SELECT col_type_is('connec', 'priority', 'text', 'Column priority should be text');
SELECT col_type_is('connec', 'access_type', 'text', 'Column access_type should be text');
SELECT col_type_is('connec', 'placement_type', 'text', 'Column placement_type should be text');
SELECT col_type_is('connec', 'crmzone_id', 'int4', 'Column crmzone_id should be int4');
SELECT col_type_is('connec', 'expl_visibility', 'smallint[]', 'Column expl_visibility should be integer[]');
SELECT col_type_is('connec', 'plot_code', 'text', 'Column plot_code should be varchar');
SELECT col_type_is('connec', 'brand_id', 'varchar(50)', 'Column brand_id should be varchar(50)');
SELECT col_type_is('connec', 'model_id', 'varchar(50)', 'Column model_id should be varchar(50)');
SELECT col_type_is('connec', 'serial_number', 'varchar(100)', 'Column serial_number should be varchar(100)');
SELECT col_type_is('connec', 'label_quadrant', 'varchar(12)', 'Column label_quadrant should be varchar(12)');
SELECT col_type_is('connec', 'n_hydrometer', 'int4', 'Column n_hydrometer should be int4');
SELECT col_type_is('connec', 'n_inhabitants', 'int4', 'Column n_inhabitants should be int4');
SELECT col_type_is('connec', 'supplyzone_id', 'int4', 'Column supplyzone_id should be int4');
SELECT col_type_is('connec', 'datasource', 'int4', 'Column datasource should be int4');
SELECT col_type_is('connec', 'lock_level', 'int4', 'Column lock_level should be int4');
SELECT col_type_is('connec', 'block_code', 'text', 'Column block_code should be text');
SELECT col_type_is('connec', 'omzone_id', 'integer', 'Column omzone_id should be integer');
SELECT col_type_is('connec', 'the_geom', 'geometry(Point,SRID_VALUE)', 'Column the_geom should be geometry(Point,SRID_VALUE)');
SELECT col_type_is('connec', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('connec', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('connec', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('connec', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');
SELECT col_type_is('connec', 'uuid', 'uuid', 'Column uuid should be uuid');

-- Check foreign keys
SELECT has_fk('connec', 'Table connec should have foreign keys');
SELECT fk_ok('connec', 'arc_id', 'arc', 'arc_id', 'FK connec_arc_id_fkey should exist');
SELECT fk_ok('connec', 'conneccat_id', 'cat_connec', 'id', 'FK connec_connecat_id_fkey should exist');
SELECT fk_ok('connec', 'sector_id', 'sector', 'sector_id', 'FK connec_sector_id_fkey should exist');
SELECT fk_ok('connec', 'state', 'value_state', 'id', 'FK connec_state_fkey should exist');
SELECT fk_ok('connec', 'state_type', 'value_state_type', 'id', 'FK connec_state_type_fkey should exist');

-- Check triggers
SELECT has_trigger('connec', 'gw_trg_connec_proximity_insert', 'Table should have gw_trg_connec_proximity_insert trigger');
SELECT has_trigger('connec', 'gw_trg_connec_proximity_update', 'Table should have gw_trg_connec_proximity_update trigger');
SELECT has_trigger('connec', 'gw_trg_connect_update', 'Table should have gw_trg_connect_update trigger');
SELECT has_trigger('connec', 'gw_trg_edit_controls', 'Table should have gw_trg_edit_controls trigger');
SELECT has_trigger('connec', 'gw_trg_link_data', 'Table should have gw_trg_link_data trigger');
SELECT has_trigger('connec', 'gw_trg_mantypevalue_fk_insert', 'Table should have gw_trg_mantypevalue_fk_insert trigger');
SELECT has_trigger('connec', 'gw_trg_mantypevalue_fk_update', 'Table should have gw_trg_mantypevalue_fk_update trigger');
SELECT has_trigger('connec', 'gw_trg_typevalue_fk_insert', 'Table should have gw_trg_typevalue_fk_insert trigger');
SELECT has_trigger('connec', 'gw_trg_typevalue_fk_update', 'Table should have gw_trg_typevalue_fk_update trigger');
SELECT has_trigger('connec', 'gw_trg_unique_field', 'Table should have gw_trg_unique_field trigger');
SELECT has_trigger('connec', 'gw_trg_plan_psector_after_connec', 'Table should have gw_trg_plan_psector_after_connec trigger');

-- Check rules

-- Check sequences
SELECT has_sequence('urn_id_seq', 'Sequence urn_id_seq should exist');

-- Check constraints
SELECT col_not_null('connec', 'connec_id', 'Column connec_id should be NOT NULL');
SELECT col_not_null('connec', 'conneccat_id', 'Column conneccat_id should be NOT NULL');
SELECT col_not_null('connec', 'sector_id', 'Column sector_id should be NOT NULL');
SELECT col_not_null('connec', 'state', 'Column state should be NOT NULL');
SELECT col_not_null('connec', 'state_type', 'Column state_type should be NOT NULL');
SELECT col_not_null('connec', 'muni_id', 'Column muni_id should be NOT NULL');
SELECT col_not_null('connec', 'expl_id', 'Column expl_id should be NOT NULL');
SELECT col_not_null('connec', 'epa_type', 'Column epa_type should be NOT NULL');

SELECT col_default_is('connec', 'connec_id', 'nextval(''urn_id_seq''::regclass)', 'Column connec_id should default to nextval');
SELECT col_default_is('connec', 'feature_type', 'CONNEC', 'Column feature_type should default to CONNEC');
SELECT col_default_is('connec', 'created_at', 'now()', 'Column created_at should default to now()');
SELECT col_default_is('connec', 'created_by', 'CURRENT_USER', 'Column created_by should default to CURRENT_USER');

-- Check indexes
SELECT has_index('connec', 'connec_sys_code_idx', 'Table should have index on sys_code');
SELECT has_index('connec', 'connec_asset_id_idx', 'Table should have index on asset_id');
SELECT has_index('connec', 'connec_expl_visibility_idx', 'Table should have index on expl_visibility');

SELECT col_has_check('connec', 'epa_type', 'Column epa_type should have check constraint');

SELECT * FROM finish();

ROLLBACK;
