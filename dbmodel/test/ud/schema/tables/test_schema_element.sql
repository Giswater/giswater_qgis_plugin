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

--check if table exists
SELECT has_table('element'::name, 'Table element should exist');

-- check columns names 


SELECT columns_are(
    'element',
    ARRAY[
  'element_id', 'code', 'sys_code', 'top_elev', 'feature_type', 'elementcat_id', 'epa_type', 'num_elements', 'state', 'state_type', 
  'expl_id', 'muni_id', 'sector_id', 'omzone_id', 'omunit_id', 'function_type', 'category_type', 'location_type', 'observ', 'comment', 'link',
  'workcat_id', 'workcat_id_end', 'builtdate', 'enddate', 'ownercat_id', 'brand_id', 'model_id', 'serial_number', 'asset_id', 'verified', 'datasource',
  'label_x', 'label_y', 'label_rotation', 'rotation', 'inventory', 'publish', 'trace_featuregeom', 'lock_level', 'expl_visibility', 'created_at', 
  'created_by', 'updated_at', 'updated_by', 'the_geom', 'uuid'
    ],
    'Table element should have the correct columns'

);
-- check columns names
SELECT col_type_is('element', 'element_id', 'int4', 'Column element_id should be int4 DEFAULT nextval(''ud_2025juli4.urn_id_seq''::regclass)');
SELECT col_type_is('element', 'code', 'text', 'Column code should be text');
SELECT col_type_is('element', 'sys_code', 'text', 'Column sys_code should be text');
SELECT col_type_is('element', 'top_elev', 'numeric(12, 3)', 'Column top_elev should be numeric(12, 3)');
SELECT col_type_is('element', 'feature_type', 'varchar(16)', 'Column feature_type should be varchar(16) DEFAULT ''ELEMENT''');
SELECT col_type_is('element', 'elementcat_id', 'varchar(30)', 'Column elementcat_id should be varchar(30)');
SELECT col_type_is('element', 'epa_type', 'varchar(16)', 'Column epa_type should be varchar(16)');
SELECT col_type_is('element', 'num_elements', 'int4', 'Column num_elements should be int4');
SELECT col_type_is('element', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('element', 'state_type', 'int2', 'Column state_type should be int2');
SELECT col_type_is('element', 'expl_id', 'int4', 'Column expl_id should be int4 DEFAULT 0');
SELECT col_type_is('element', 'muni_id', 'int4', 'Column muni_id should be int4 DEFAULT 0');
SELECT col_type_is('element', 'sector_id', 'int4', 'Column sector_id should be int4 DEFAULT 0');
SELECT col_type_is('element', 'omzone_id', 'int4', 'Column omzone_id should be int4');
SELECT col_type_is('element', 'omunit_id', 'int4', 'Column unit_id should be int4');
SELECT col_type_is('element', 'function_type', 'varchar(50)', 'Column function_type should be varchar(50)');
SELECT col_type_is('element', 'category_type', 'varchar(50)', 'Column category_type should be varchar(50)');
SELECT col_type_is('element', 'location_type', 'varchar(50)', 'Column location_type should be varchar(50)');
SELECT col_type_is('element', 'observ', 'varchar(254)', 'Column observ should be varchar(254)');
SELECT col_type_is('element', 'comment', 'varchar(254)', 'Column comment should be varchar(254)');
SELECT col_type_is('element', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('element', 'workcat_id', 'varchar(30)', 'Column workcat_id should be varchar(30)');
SELECT col_type_is('element', 'workcat_id_end', 'varchar(30)', 'Column workcat_id_end should be varchar(30)');
SELECT col_type_is('element', 'builtdate', 'date', 'Column builtdate should be date');
SELECT col_type_is('element', 'enddate', 'date', 'Column enddate should be date');
SELECT col_type_is('element', 'ownercat_id', 'varchar(30)', 'Column ownercat_id should be varchar(30)');
SELECT col_type_is('element', 'brand_id', 'varchar(50)', 'Column brand_id should be varchar(50)');
SELECT col_type_is('element', 'model_id', 'varchar(50)', 'Column model_id should be varchar(50)');
SELECT col_type_is('element', 'serial_number', 'varchar(30)', 'Column serial_number should be varchar(30)');
SELECT col_type_is('element', 'asset_id', 'varchar(50)', 'Column asset_id should be varchar(50)');
SELECT col_type_is('element', 'verified', 'int4', 'Column verified should be int4');
SELECT col_type_is('element', 'datasource', 'int4', 'Column datasource should be int4');
SELECT col_type_is('element', 'label_x', 'varchar(30)', 'Column label_x should be varchar(30)');
SELECT col_type_is('element', 'label_y', 'varchar(30)', 'Column label_y should be varchar(30)');
SELECT col_type_is('element', 'label_rotation', 'numeric(6, 3)', 'Column label_rotation should be numeric(6, 3)');
SELECT col_type_is('element', 'rotation', 'numeric(6, 3)', 'Column rotation should be numeric(6, 3)');
SELECT col_type_is('element', 'inventory', 'bool', 'Column inventory should be bool');
SELECT col_type_is('element', 'publish', 'bool', 'Column publish should be bool');
SELECT col_type_is('element', 'trace_featuregeom', 'bool', 'Column trace_featuregeom should be bool DEFAULT true');
SELECT col_type_is('element', 'lock_level', 'int4', 'Column lock_level should be int4');
SELECT col_type_is('element', 'expl_visibility', '_int2', 'Column expl_visibility should be _int2');
SELECT col_type_is('element', 'created_at', 'timestamptz', 'Column created_at should be timestamptz DEFAULT now()');
SELECT col_type_is('element', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50) DEFAULT CURRENT_USER');
SELECT col_type_is('element', 'updated_at', 'timestamptz', 'Column updated_at should be timestamptz');
SELECT col_type_is('element', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');
SELECT col_type_is('element', 'the_geom', 'public.geometry(point, 25831)', 'Column the_geom should be public.geometry(point, 25831)');
SELECT col_type_is('element', 'uuid', 'uuid', 'Column uuid should be uuid');



--check default values
SELECT col_has_default('element', 'feature_type', 'Column feature_type should have default value');
SELECT col_has_default('element', 'expl_id', 'Column expl_id should have default value');
SELECT col_has_default('element', 'muni_id', 'Column muni_id should have default value');
SELECT col_has_default('element', 'sector_id', 'Column sector_id should have default value');
SELECT col_has_default('element', 'omzone_id', 'Column omzone_id should have default value');
SELECT col_has_default('element', 'omunit_id', 'Column omunit_id should have default value');
SELECT col_has_default('element', 'trace_featuregeom', 'Column trace_featuregeom should have default value');
SELECT col_has_default('element', 'created_at', 'Column created_at should have default value');
SELECT col_has_default('element', 'created_by', 'Column created_by should have default value');

-- check foreign keys
SELECT has_fk('element', 'Table element should have foreign keys');

SELECT fk_ok('element','elementcat_id','cat_element','id','Table should have foreign key from elementcat_id to cat_element.id');
SELECT fk_ok('element','feature_type','sys_feature_type','id','Table should have foreign key from feature_type to sys_feature_type.id');
SELECT fk_ok('element','muni_id','ext_municipality','muni_id','Table should have foreign key from muni_id to ext_municipality.muni_id');
SELECT fk_ok('element','ownercat_id','cat_owner','id','Table should have foreign key from ownercat_id to cat_owner.id');
SELECT fk_ok( 'element','sector_id','sector','sector_id','Table should have foreign key from sector_id to sector.sector_id');
SELECT fk_ok('element','state','value_state','id','Table should have foreign key from state to value_state.id');
SELECT fk_ok('element','state_type','value_state_type','id', 'Table should have foreign key from state_type to value_state_type.id');
SELECT fk_ok('element','workcat_id_end','cat_work','id','Table should have foreign key from workcat_id_end to cat_work.id');
SELECT fk_ok('element','workcat_id','cat_work','id','Table should have foreign key from workcat_id to cat_work.id');


-- check indexes
SELECT has_index('element', 'element_asset_id_idx', 'Table element should have index on asset_id');
SELECT has_index('element', 'element_index', 'Table element should have index on the_geom');
SELECT has_index('element', 'element_muni', 'Table element should have index on muni_id');
SELECT has_index('element', 'element_pkey', 'Table element should have index on element_id');
SELECT has_index('element', 'element_sector', 'Table element should have index on sector_id');
SELECT has_index('element', 'element_sys_code_idx', 'Table element should have index on sys_code');


--check trigger 
SELECT has_trigger('element', 'gw_trg_edit_controls', 'Table element should have trigger gw_trg_edit_controls');
SELECT has_trigger('element', 'gw_trg_typevalue_fk_insert', 'Table element should have trigger gw_trg_typevalue_fk_insert');
SELECT has_trigger('element', 'gw_trg_typevalue_fk_update', 'Table element should have trigger gw_trg_typevalue_fk_update');


--check rule 

SELECT * FROM finish();

ROLLBACK;