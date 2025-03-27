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

-- Check table link
SELECT has_table('link'::name, 'Table link should exist');

-- Check columns
SELECT columns_are(
    'link',
    ARRAY[
        'link_id', 'code', 'feature_id', 'feature_type', 'exit_id', 'exit_type', 'userdefined_geom', 'state', 'expl_id',
        'the_geom', 'tstamp', 'exit_topelev', 'exit_elev', 'sector_id', 'dma_id', 'fluid_type', 'presszone_id',
        'dqa_id', 'minsector_id', 'expl_id2', 'epa_type', 'is_operative', 'insert_user', 'lastupdate',
        'lastupdate_user', 'staticpressure', 'conneccat_id', 'workcat_id', 'workcat_id_end', 'builtdate',
        'enddate', 'uncertain', 'muni_id', 'macrominsector_id', 'verified', 'supplyzone_id', 'n_hydrometer',
        'custom_length', 'datasource'
    ],
    'Table link should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('link', ARRAY['link_id'], 'Column link_id should be primary key');

-- Check column types
SELECT col_type_is('link', 'link_id', 'integer', 'Column link_id should be integer');
SELECT col_type_is('link', 'code', 'text', 'Column code should be text');
SELECT col_type_is('link', 'feature_id', 'varchar(16)', 'Column feature_id should be varchar(16)');
SELECT col_type_is('link', 'feature_type', 'varchar(16)', 'Column feature_type should be varchar(16)');
SELECT col_type_is('link', 'exit_id', 'varchar(16)', 'Column exit_id should be varchar(16)');
SELECT col_type_is('link', 'exit_type', 'varchar(16)', 'Column exit_type should be varchar(16)');
SELECT col_type_is('link', 'userdefined_geom', 'boolean', 'Column userdefined_geom should be boolean');
SELECT col_type_is('link', 'state', 'smallint', 'Column state should be smallint');
SELECT col_type_is('link', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('link', 'the_geom', 'geometry(LineString,25831)', 'Column the_geom should be geometry(LineString,25831)');

-- Check not null constraints
SELECT col_not_null('link', 'state', 'Column state should be NOT NULL');
SELECT col_not_null('link', 'expl_id', 'Column expl_id should be NOT NULL');

-- Check default values
SELECT col_default_is('link', 'tstamp', 'now()', 'Column tstamp should default to now()');
SELECT col_default_is('link', 'insert_user', 'CURRENT_USER', 'Column insert_user should default to CURRENT_USER');
SELECT col_default_is('link', 'macrominsector_id', '0', 'Column macrominsector_id should default to 0');

-- Check indexes
SELECT has_index('link', 'link_exit_id', 'Should have index on exit_id');
SELECT has_index('link', 'link_expl_id2', 'Should have index on expl_id2');
SELECT has_index('link', 'link_exploitation2', 'Should have index on expl_id2');
SELECT has_index('link', 'link_feature_id', 'Should have index on feature_id');
SELECT has_index('link', 'link_index', 'Should have index on the_geom');
SELECT has_index('link', 'link_muni', 'Should have index on muni_id');

-- Check triggers
SELECT has_trigger('link', 'gw_trg_link_connecrotation_update', 'Trigger gw_trg_link_connecrotation_update should exist');
SELECT has_trigger('link', 'gw_trg_link_data', 'Trigger gw_trg_link_data should exist');

-- Check foreign keys
SELECT fk_ok('link', 'conneccat_id', 'cat_connec', 'id', 'FK conneccat_id should reference cat_connec(id)');
SELECT fk_ok('link', 'exit_type', 'sys_feature_type', 'id', 'FK exit_type should reference sys_feature_type(id)');
SELECT fk_ok('link', 'expl_id', 'exploitation', 'expl_id', 'FK expl_id should reference exploitation(expl_id)');
SELECT fk_ok('link', 'feature_type', 'sys_feature_type', 'id', 'FK feature_type should reference sys_feature_type(id)');
SELECT fk_ok('link', 'muni_id', 'ext_municipality', 'muni_id', 'FK muni_id should reference ext_municipality(muni_id)');
SELECT fk_ok('link', 'presszone_id', 'presszone', 'presszone_id', 'FK presszone_id should reference presszone(presszone_id)');
SELECT fk_ok('link', 'sector_id', 'sector', 'sector_id', 'FK sector_id should reference sector(sector_id)');
SELECT fk_ok('link', 'state', 'value_state', 'id', 'FK state should reference value_state(id)');
SELECT fk_ok('link', 'supplyzone_id', 'supplyzone', 'supplyzone_id', 'FK supplyzone_id should reference supplyzone(supplyzone_id)');
SELECT fk_ok('link', 'workcat_id', 'cat_work', 'id', 'FK workcat_id should reference cat_work(id)');
SELECT fk_ok('link', 'workcat_id_end', 'cat_work', 'id', 'FK workcat_id_end should reference cat_work(id)');

-- Check rules

-- Check sequences


SELECT * FROM finish();

ROLLBACK;