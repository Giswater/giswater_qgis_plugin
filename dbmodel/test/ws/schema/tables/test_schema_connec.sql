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

-- Check table connec
SELECT has_table('connec'::name, 'Table connec should exist');

-- Check columns
SELECT columns_are(
    'connec',
    ARRAY[
        'connec_id', 'code', 'top_elev', 'depth', 'conneccat_id', 'sector_id', 'customer_code', 'state', 'state_type',
        'arc_id', 'connec_length', 'annotation', 'observ', 'comment', 'dma_id', 'presszone_id', 'soilcat_id',
        'function_type', 'category_type', 'fluid_type', 'location_type', 'workcat_id', 'workcat_id_end', 'builtdate',
        'enddate', 'ownercat_id', 'muni_id', 'postcode', 'streetaxis_id', 'postnumber', 'postcomplement',
        'streetaxis2_id', 'postnumber2', 'postcomplement2', 'descript', 'link', 'verified', 'rotation', 'the_geom',
        'undelete', 'label_x', 'label_y', 'label_rotation', 'publish', 'inventory', 'expl_id', 'num_value',
        'feature_type', 'tstamp', 'pjoint_type', 'pjoint_id', 'lastupdate', 'lastupdate_user', 'insert_user',
        'minsector_id', 'dqa_id', 'staticpressure', 'district_id', 'adate', 'adescript', 'accessibility',
        'workcat_id_plan', 'asset_id', 'epa_type', 'om_state', 'conserv_state', 'priority', 'valve_location',
        'valve_type', 'shutoff_valve', 'access_type', 'placement_type', 'crmzone_id', 'expl_id2', 'plot_code',
        'brand_id', 'model_id', 'serial_number', 'label_quadrant', 'cat_valve', 'macrominsector_id', 'n_hydrometer',
        'streetname', 'streetname2', 'n_inhabitants', 'supplyzone_id', 'datasource', 'lock_level', 'block_zone'
    ],
    'Table connec should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('connec', ARRAY['connec_id'], 'Column connec_id should be primary key');

-- Check column types
SELECT col_type_is('connec', 'connec_id', 'varchar(16)', 'Column connec_id should be varchar(16)');
SELECT col_type_is('connec', 'code', 'text', 'Column code should be text');
SELECT col_type_is('connec', 'top_elev', 'numeric(12,4)', 'Column top_elev should be numeric(12,4)');
SELECT col_type_is('connec', 'depth', 'numeric(12,4)', 'Column depth should be numeric(12,4)');
SELECT col_type_is('connec', 'conneccat_id', 'varchar(30)', 'Column conneccat_id should be varchar(30)');
SELECT col_type_is('connec', 'sector_id', 'integer', 'Column sector_id should be integer');
SELECT col_type_is('connec', 'customer_code', 'varchar(30)', 'Column customer_code should be varchar(30)');
SELECT col_type_is('connec', 'state', 'smallint', 'Column state should be smallint');
SELECT col_type_is('connec', 'state_type', 'smallint', 'Column state_type should be smallint');
SELECT col_type_is('connec', 'arc_id', 'varchar(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('connec', 'the_geom', 'geometry(Point,25831)', 'Column the_geom should be geometry(Point,25831)');

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

-- Check rules
SELECT has_rule('connec', 'undelete_connec', 'Table should have undelete_connec rule');

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
SELECT col_default_is('connec', 'tstamp', 'now()', 'Column tstamp should default to now()');
SELECT col_default_is('connec', 'insert_user', 'CURRENT_USER', 'Column insert_user should default to CURRENT_USER');
SELECT col_default_is('connec', 'macrominsector_id', '0', 'Column macrominsector_id should default to 0');

SELECT col_has_check('connec', 'epa_type', 'Column epa_type should have check constraint');

SELECT * FROM finish();

ROLLBACK;
