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
SELECT has_table('archived_psector_connec_traceability'::name, 'Table archived_psector_connec_traceability should exist');

-- check columns names 


SELECT columns_are(
    'archived_psector_connec_traceability',
    ARRAY[
        'id', 'psector_id', 'psector_state','doable','psector_arc_id','link_id', 'link_the_geom', 'audit_tstamp',
         'audit_user', 'action','connec_id', 'code', 'top_elev','y1','y2','connec_type', 'conneccat_id', 
         'sector_id','customer_code', 'private_conneccat_id', 'demand','state', 'state_type','connec_depth','connec_length', 'arc_id', 'annotation', 'observ',
         '"comment"','dma_id', 'soilcat_id', 'function_type','category_type', 'fluid_type','location_type','workcat_id', 'workcat_id_end', 'builtdate', 'enddate',
         'ownercat_id','muni_id', 'postcode', 'streetaxis_id', 'postnumber','postcomplement','streetaxis2_id', 'postnumber2', 'postcomplement2', 'descript',
         'link','verified', 'rotation', 'the_geom', 'label_x','label_y','label_rotation', 'accessibility', 'publish', 'inventory',
          'uncertain','expl_id', 'num_value', 'feature_type', 'pjoint_type','pjoint_id','lastupdate', 'lastupdate_user', 'insert_user', 'matcat_id',
          'district_id','workcat_id_plan', 'asset_id', 'drainzone_id', 'adate','adescript','plot_code', 'placement_type', 'access_type', 'label_quadrant',
          'n_hydrometer','minsector_id', 'streetname', 'streetname2', 'dwfzone_id','datasource','omunit_id', 'lock_level', 'expl_visibility', 'label_quadrant'
    ],
    'Table archived_psector_connec_traceability should have the correct columns'
);
-- check columns names
SELECT col_type_is('archived_psector_connec_traceability', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('archived_psector_connec_traceability', 'psector_id', 'int4', 'Column psector_id should be int4');
SELECT col_type_is('archived_psector_connec_traceability', 'psector_state', 'int2', 'Column psector_state should be int2');
SELECT col_type_is('archived_psector_connec_traceability', 'doable', 'bool', 'Column doable should be bool');
SELECT col_type_is('archived_psector_connec_traceability', 'psector_arc_id', 'varchar(16)', 'Column psector_arc_id should be varchar(16)');
SELECT col_type_is('archived_psector_connec_traceability', 'link_id', 'int4', 'Column link_id should be int4');
SELECT col_type_is('archived_psector_connec_traceability', 'link_the_geom', 'geometry(linestring, 25831)', 'Column link_the_geom should be geometry(linestring, 25831)');
SELECT col_type_is('archived_psector_connec_traceability', 'audit_tstamp', 'timestamp', 'Column audit_tstamp should be timestamp');
SELECT col_type_is('archived_psector_connec_traceability', 'audit_user', 'text', 'Column audit_user should be text');
SELECT col_type_is('archived_psector_connec_traceability', 'action', 'varchar(16)', 'Column action should be varchar(16)');
SELECT col_type_is('archived_psector_connec_traceability', 'connec_id', 'int4', 'Column connec_id should be int4');
SELECT col_type_is('archived_psector_connec_traceability', 'code', 'text', 'Column code should be text');
SELECT col_type_is('archived_psector_connec_traceability', 'top_elev', 'numeric(12, 4)', 'Column top_elev should be numeric(12, 4)');
SELECT col_type_is('archived_psector_connec_traceability', 'y1', 'numeric(12, 4)', 'Column y1 should be numeric(12, 4)');
SELECT col_type_is('archived_psector_connec_traceability', 'y2', 'numeric(12, 4)', 'Column y2 should be numeric(12, 4)');
SELECT col_type_is('archived_psector_connec_traceability', 'connec_type', 'varchar(30)', 'Column connec_type should be varchar(30)');
SELECT col_type_is('archived_psector_connec_traceability', 'conneccat_id', 'varchar(30)', 'Column conneccat_id should be varchar(30)');
SELECT col_type_is('archived_psector_connec_traceability', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('archived_psector_connec_traceability', 'customer_code', 'varchar(30)', 'Column customer_code should be varchar(30)');
SELECT col_type_is('archived_psector_connec_traceability', 'private_conneccat_id', 'varchar(30)', 'Column private_conneccat_id should be varchar(30)');
SELECT col_type_is('archived_psector_connec_traceability', 'demand', 'numeric(12, 8)', 'Column demand should be numeric(12, 8)');
SELECT col_type_is('archived_psector_connec_traceability', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('archived_psector_connec_traceability', 'state_type', 'int2', 'Column state_type should be int2');
SELECT col_type_is('archived_psector_connec_traceability', 'connec_depth', 'numeric(12, 3)', 'Column connec_depth should be numeric(12, 3)');
SELECT col_type_is('archived_psector_connec_traceability', 'connec_length', 'numeric(12, 3)', 'Column connec_length should be numeric(12, 3)');
SELECT col_type_is('archived_psector_connec_traceability', 'arc_id', 'varchar(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('archived_psector_connec_traceability', 'annotation', 'text', 'Column annotation should be text');
SELECT col_type_is('archived_psector_connec_traceability', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('archived_psector_connec_traceability', 'comment', 'text', 'Column comment should be text');
SELECT col_type_is('archived_psector_connec_traceability', 'dma_id', 'int4', 'Column dma_id should be int4');
SELECT col_type_is('archived_psector_connec_traceability', 'soilcat_id', 'varchar(16)', 'Column soilcat_id should be varchar(16)');
SELECT col_type_is('archived_psector_connec_traceability', 'function_type', 'varchar(50)', 'Column function_type should be varchar(50)');
SELECT col_type_is('archived_psector_connec_traceability', 'category_type', 'varchar(50)', 'Column category_type should be varchar(50)');
SELECT col_type_is('archived_psector_connec_traceability', 'fluid_type', 'varchar(50)', 'Column fluid_type should be varchar(50)');
SELECT col_type_is('archived_psector_connec_traceability', 'location_type', 'varchar(50)', 'Column location_type should be varchar(50)');
SELECT col_type_is('archived_psector_connec_traceability', 'workcat_id', 'varchar(255)', 'Column workcat_id should be varchar(255)');
SELECT col_type_is('archived_psector_connec_traceability', 'workcat_id_end', 'varchar(255)', 'Column workcat_id_end should be varchar(255)');
SELECT col_type_is('archived_psector_connec_traceability', 'builtdate', 'date', 'Column builtdate should be date');
SELECT col_type_is('archived_psector_connec_traceability', 'enddate', 'date', 'Column enddate should be date');
SELECT col_type_is('archived_psector_connec_traceability', 'ownercat_id', 'varchar(30)', 'Column ownercat_id should be varchar(30)');
SELECT col_type_is('archived_psector_connec_traceability', 'muni_id', 'int4', 'Column muni_id should be int4');
SELECT col_type_is('archived_psector_connec_traceability', 'postcode', 'varchar(16)', 'Column postcode should be varchar(16)');
SELECT col_type_is('archived_psector_connec_traceability', 'streetaxis_id', 'varchar(16)', 'Column streetaxis_id should be varchar(16)');
SELECT col_type_is('archived_psector_connec_traceability', 'postnumber', 'int4', 'Column postnumber should be int4');
SELECT col_type_is('archived_psector_connec_traceability', 'postcomplement', 'varchar(100)', 'Column postcomplement should be varchar(100)');
SELECT col_type_is('archived_psector_connec_traceability', 'streetaxis2_id', 'varchar(16)', 'Column streetaxis2_id should be varchar(16)');
SELECT col_type_is('archived_psector_connec_traceability', 'postnumber2', 'int4', 'Column postnumber2 should be int4');
SELECT col_type_is('archived_psector_connec_traceability', 'postcomplement2', 'varchar(100)', 'Column postcomplement2 should be varchar(100)');
SELECT col_type_is('archived_psector_connec_traceability', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('archived_psector_connec_traceability', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('archived_psector_connec_traceability', 'verified', 'int4', 'Column verified should be int4');
SELECT col_type_is('archived_psector_connec_traceability', 'rotation', 'numeric(6, 3)', 'Column rotation should be numeric(6, 3)');
SELECT col_type_is('archived_psector_connec_traceability', 'the_geom', 'public.geometry(point, 25831)', 'Column the_geom should be geometry(point, 25831)');
SELECT col_type_is('archived_psector_connec_traceability', 'label_x', 'varchar(30)', 'Column label_x should be varchar(30)');
SELECT col_type_is('archived_psector_connec_traceability', 'label_y', 'varchar(30)', 'Column label_y should be varchar(30)');
SELECT col_type_is('archived_psector_connec_traceability', 'label_rotation', 'numeric(6, 3)', 'Column label_rotation should be numeric(6, 3)');
SELECT col_type_is('archived_psector_connec_traceability', 'accessibility', 'bool', 'Column accessibility should be bool');
SELECT col_type_is('archived_psector_connec_traceability', 'diagonal', 'varchar(50)', 'Column diagonal should be varchar(50)');
SELECT col_type_is('archived_psector_connec_traceability', 'publish', 'bool', 'Column publish should be bool');
SELECT col_type_is('archived_psector_connec_traceability', 'inventory', 'bool', 'Column inventory should be bool');
SELECT col_type_is('archived_psector_connec_traceability', 'uncertain', 'bool', 'Column uncertain should be bool');
SELECT col_type_is('archived_psector_connec_traceability', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('archived_psector_connec_traceability', 'num_value', 'numeric(12, 3)', 'Column num_value should be numeric(12, 3)');
SELECT col_type_is('archived_psector_connec_traceability', 'feature_type', 'varchar(16)', 'Column feature_type should be varchar(16)');
SELECT col_type_is('archived_psector_connec_traceability', 'tstamp', 'timestamp', 'Column tstamp should be timestamp');
SELECT col_type_is('archived_psector_connec_traceability', 'pjoint_type', 'varchar(16)', 'Column pjoint_type should be varchar(16)');
SELECT col_type_is('archived_psector_connec_traceability', 'pjoint_id', 'int4', 'Column pjoint_id should be int4');
SELECT col_type_is('archived_psector_connec_traceability', 'lastupdate', 'timestamp', 'Column lastupdate should be timestamp');
SELECT col_type_is('archived_psector_connec_traceability', 'lastupdate_user', 'varchar(50)', 'Column lastupdate_user should be varchar(50)');
SELECT col_type_is('archived_psector_connec_traceability', 'insert_user', 'varchar(50)', 'Column insert_user should be varchar(50)');
SELECT col_type_is('archived_psector_connec_traceability', 'matcat_id', 'varchar(16)', 'Column matcat_id should be varchar(16)');
SELECT col_type_is('archived_psector_connec_traceability', 'district_id', 'int4', 'Column district_id should be int4');
SELECT col_type_is('archived_psector_connec_traceability', 'workcat_id_plan', 'varchar(255)', 'Column workcat_id_plan should be varchar(255)');
SELECT col_type_is('archived_psector_connec_traceability', 'asset_id', 'varchar(50)', 'Column asset_id should be varchar(50)');
SELECT col_type_is('archived_psector_connec_traceability', 'drainzone_id', 'int4', 'Column drainzone_id should be int4');
SELECT col_type_is('archived_psector_connec_traceability', 'adate', 'text', 'Column adate should be text');
SELECT col_type_is('archived_psector_connec_traceability', 'adescript', 'text', 'Column adescript should be text');
SELECT col_type_is('archived_psector_connec_traceability', 'plot_code', 'varchar', 'Column plot_code should be varchar');
SELECT col_type_is('archived_psector_connec_traceability', 'placement_type', 'varchar(50)', 'Column placement_type should be varchar(50)');
SELECT col_type_is('archived_psector_connec_traceability', 'access_type', 'text', 'Column access_type should be text');
SELECT col_type_is('archived_psector_connec_traceability', 'label_quadrant', 'varchar(12)', 'Column label_quadrant should be varchar(12)');
SELECT col_type_is('archived_psector_connec_traceability', 'n_hydrometer', 'int4', 'Column n_hydrometer should be int4');
SELECT col_type_is('archived_psector_connec_traceability', 'minsector_id', 'int4', 'Column minsector_id should be int4');
SELECT col_type_is('archived_psector_connec_traceability', 'streetname', 'varchar(100)', 'Column streetname should be varchar(100)');
SELECT col_type_is('archived_psector_connec_traceability', 'streetname2', 'varchar(100)', 'Column streetname2 should be varchar(100)');
SELECT col_type_is('archived_psector_connec_traceability', 'dwfzone_id', 'int4', 'Column dwfzone_id should be int4');
SELECT col_type_is('archived_psector_connec_traceability', 'datasource', 'int4', 'Column datasource should be int4');
SELECT col_type_is('archived_psector_connec_traceability', 'omunit_id', 'int4', 'Column omunit_id should be int4');
SELECT col_type_is('archived_psector_connec_traceability', 'lock_level', 'int4', 'Column lock_level should be int4');
SELECT col_type_is('archived_psector_connec_traceability', 'expl_visibility', '_int4', 'Column expl_visibility should be _int4');

--check default values
SELECT col_has_default('archived_psector_connec_traceability', 'audit_tstamp', 'Column audit_tstamp should have default value');
SELECT col_has_default('archived_psector_connec_traceability', 'audit_user', 'Column audit_user should have default value');

-- check foreign keys



-- check index
SELECT has_index('archived_psector_connec_traceability', 'id', 'Table archived_psector_connec_traceability should have index on id');

--check trigger 
SELECT has_trigger('archived_psector_connec_traceability', 'gw_trg_typevalue_fk_insert', 'Table should have trigger gw_trg_typevalue_fk_insert');
SELECT has_trigger('archived_psector_connec_traceability', 'gw_trg_typevalue_fk_update', 'Table should have trigger gw_trg_typevalue_fk_update');
--check rule 

SELECT * FROM finish();

ROLLBACK;