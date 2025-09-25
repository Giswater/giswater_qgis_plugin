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

-- Check table link
SELECT has_table('link'::name, 'Table link should exist');

-- Check columns
SELECT columns_are(
    'link',
    ARRAY[
        'link_id', 'code', 'sys_code', 'feature_id', 'feature_type', 'linkcat_id', 'top_elev1', 'depth1', 'exit_id', 'exit_type',
        'top_elev2', 'depth2', 'userdefined_geom', 'state', 'expl_id', 'sector_id', 'dma_id',
        'fluid_type', 'presszone_id', 'dqa_id', 'minsector_id', 'expl_visibility', 'is_operative',
        'staticpressure1', 'staticpressure2', 'workcat_id', 'workcat_id_end', 'builtdate', 'enddate',
        'uncertain', 'muni_id', 'verified', 'supplyzone_id', 'custom_length', 'datasource',
        'omzone_id', 'lock_level', 'annotation', 'comment', 'descript', 'link', 'location_type', 'num_value', 'observ',
        'the_geom', 'created_at', 'created_by', 'updated_at', 'updated_by', 'state_type', 'brand_id', 'model_id', 'uuid'
    ],
    'Table link should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('link', ARRAY['link_id'], 'Column link_id should be primary key');

-- Check column types
SELECT col_type_is('link', 'link_id', 'integer', 'Column link_id should be integer');
SELECT col_type_is('link', 'code', 'text', 'Column code should be text');
SELECT col_type_is('link', 'sys_code', 'text', 'Column sys_code should be text');
SELECT col_type_is('link', 'feature_id', 'integer', 'Column feature_id should be integer');
SELECT col_type_is('link', 'feature_type', 'varchar(16)', 'Column feature_type should be varchar(16)');
SELECT col_type_is('link', 'linkcat_id', 'varchar(30)', 'Column linkcat_id should be varchar(30)');
SELECT col_type_is('link', 'top_elev1', 'double precision', 'Column top_elev1 should be double precision');
SELECT col_type_is('link', 'depth1', 'numeric(12,4)', 'Column depth1 should be numeric(12,4)');
SELECT col_type_is('link', 'exit_id', 'integer', 'Column exit_id should be integer');
SELECT col_type_is('link', 'exit_type', 'varchar(16)', 'Column exit_type should be varchar(16)');
SELECT col_type_is('link', 'top_elev2', 'double precision', 'Column top_elev2 should be double precision');
SELECT col_type_is('link', 'depth2', 'numeric(12,4)', 'Column depth2 should be numeric(12,4)');
SELECT col_type_is('link', 'userdefined_geom', 'boolean', 'Column userdefined_geom should be boolean');
SELECT col_type_is('link', 'state', 'smallint', 'Column state should be smallint');
SELECT col_type_is('link', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('link', 'omzone_id', 'integer', 'Column omzone_id should be integer');
SELECT col_type_is('link', 'lock_level', 'integer', 'Column lock_level should be integer');
SELECT col_type_is('link', 'the_geom', 'geometry(LineString,SRID_VALUE)', 'Column the_geom should be geometry(LineString,SRID_VALUE)');
SELECT col_type_is('link', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('link', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('link', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('link', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');
SELECT col_type_is('link', 'location_type', 'varchar(50)', 'Column location_type should be varchar(50)');
SELECT col_type_is('link', 'annotation', 'text', 'Column annotation should be text');
SELECT col_type_is('link', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('link', 'comment', 'text', 'Column comment should be text');
SELECT col_type_is('link', 'descript', 'varchar(254)', 'Column descript should be varchar(254)');
SELECT col_type_is('link', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('link', 'num_value', 'numeric(12,3)', 'Column num_value should be numeric(12,3)');
SELECT col_type_is('link', 'state_type', 'smallint', 'Column state_type should be smallint');
SELECT col_type_is('link', 'staticpressure1', 'numeric(12,3)', 'Column staticpressure1 should be numeric(12,3)');
SELECT col_type_is('link', 'staticpressure2', 'numeric(12,3)', 'Column staticpressure2 should be numeric(12,3)');
SELECT col_type_is('link', 'brand_id', 'varchar(50)', 'Column brand_id should be varchar(50)');
SELECT col_type_is('link', 'model_id', 'varchar(50)', 'Column model_id should be varchar(50)');
SELECT col_type_is('link', 'uuid', 'uuid', 'Column uuid should be uuid');

-- Check not null constraints
SELECT col_not_null('link', 'linkcat_id', 'Column linkcat_id should be NOT NULL');
SELECT col_not_null('link', 'state', 'Column state should be NOT NULL');
SELECT col_not_null('link', 'expl_id', 'Column expl_id should be NOT NULL');

-- Check default values
SELECT col_default_is('link', 'created_at', 'now()', 'Column created_at should default to now()');
SELECT col_default_is('link', 'created_by', 'CURRENT_USER', 'Column created_by should default to CURRENT_USER');

-- Check indexes
SELECT has_index('link', 'link_exit_id', 'Should have index on exit_id');
SELECT has_index('link', 'link_expl_visibility_idx', 'Should have index on expl_visibility');
SELECT has_index('link', 'link_feature_id', 'Should have index on feature_id');
SELECT has_index('link', 'link_index', 'Should have index on the_geom');
SELECT has_index('link', 'link_muni', 'Should have index on muni_id');

-- Check triggers
SELECT has_trigger('link', 'gw_trg_link_connecrotation_update', 'Trigger gw_trg_link_connecrotation_update should exist');
SELECT has_trigger('link', 'gw_trg_link_data', 'Trigger gw_trg_link_data should exist');

-- Check foreign keys
SELECT fk_ok('link', 'linkcat_id', 'cat_link', 'id', 'FK linkcat_id should reference cat_link(id)');
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