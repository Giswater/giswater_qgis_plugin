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
SELECT has_table('archived_psector_arc_traceability'::name, 'Table archived_psector_arc_traceability should exist');

-- check columns names 


SELECT columns_are(
    'archived_psector_arc_traceability',
    ARRAY[
        'id','psector_id','psector_state','doable','addparam',
        'audit_tstamp','audit_user','action','arc_id','code','node_1','node_2','y1','y2','elev1','elev2','custom_y1','custom_y2','custom_elev1',
        'custom_elev2','sys_elev1','sys_elev2','arc_type','arccat_id','matcat_id','epa_type','sector_id',
        'state','state_type','annotation','observ','comment','sys_slope','inverted_slope','custom_length','dma_id',
        'soilcat_id','function_type','category_type','fluid_type','location_type','workcat_id','workcat_id_end','builtdate','enddate','ownercat_id','muni_id','postcode','streetaxis_id',
        'postnumber','postcomplement','streetaxis2_id','postnumber2','postcomplement2','descript',
        'link','verified','the_geom','label_x','label_y','label_rotation','publish','inventory','uncertain','expl_id','num_value','feature_type','tstamp',
        'lastupdate','lastupdate_user','insert_user','district_id','workcat_id_plan','asset_id','pavcat_id','drainzone_id',
        'nodetype_1','node_sys_top_elev_1','node_sys_elev_1','nodetype_2','node_sys_top_elev_2','node_sys_elev_2','parent_id','adate','adescript','visitability',
        'label_quadrant','minsector_id','brand_id','model_id','serial_number','streetname','streetname2','dwfzone_id','initoverflowpath','omunit_id','registration_date',
        'meandering','conserv_state','om_state','last_visitdate','negative_offset','expl_visibility'
    ],
    'Table archived_psector_arc_traceability should have the correct columns'
);
-- check columns names
SELECT col_type_is('archived_psector_arc_traceability', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('archived_psector_arc_traceability', 'psector_id', 'int4', 'Column psector_id should be int4');
SELECT col_type_is('archived_psector_arc_traceability', 'psector_state', 'int2', 'Column psector_state should be int2');
SELECT col_type_is('archived_psector_arc_traceability', 'doable', 'bool', 'Column doable should be bool');
SELECT col_type_is('archived_psector_arc_traceability', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('archived_psector_arc_traceability', 'audit_tstamp', 'timestamp', 'Column audit_tstamp should be timestamp');
SELECT col_type_is('archived_psector_arc_traceability', 'audit_user', 'text', 'Column audit_user should be text');
SELECT col_type_is('archived_psector_arc_traceability', 'action', 'varchar(16)', 'Column action should be varchar(16)');
SELECT col_type_is('archived_psector_arc_traceability', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('archived_psector_arc_traceability', 'code', 'text', 'Column code should be text');
SELECT col_type_is('archived_psector_arc_traceability', 'node_1', 'int4', 'Column node_1 should be int4');
SELECT col_type_is('archived_psector_arc_traceability', 'node_2', 'int4', 'Column node_2 should be int4');
SELECT col_type_is('archived_psector_arc_traceability', 'y1', 'numeric(12, 3)', 'Column y1 should be numeric(12, 3)');
SELECT col_type_is('archived_psector_arc_traceability', 'y2', 'numeric(12, 3)', 'Column y2 should be numeric(12, 3)');
SELECT col_type_is('archived_psector_arc_traceability', 'elev1', 'numeric(12, 3)', 'Column elev1 should be numeric(12, 3)');
SELECT col_type_is('archived_psector_arc_traceability', 'elev2', 'numeric(12, 3)', 'Column elev2 should be numeric(12, 3)');
SELECT col_type_is('archived_psector_arc_traceability', 'custom_y1', 'numeric(12, 3)', 'Column custom_y1 should be numeric(12, 3)');
SELECT col_type_is('archived_psector_arc_traceability', 'custom_y2', 'numeric(12, 3)', 'Column custom_y2 should be numeric(12, 3)');
SELECT col_type_is('archived_psector_arc_traceability', 'custom_elev1', 'numeric(12, 3)', 'Column custom_elev1 should be numeric(12, 3)');
SELECT col_type_is('archived_psector_arc_traceability', 'custom_elev2', 'numeric(12, 3)', 'Column custom_elev2 should be numeric(12, 3)');
SELECT col_type_is('archived_psector_arc_traceability', 'sys_elev1', 'numeric(12, 3)', 'Column sys_elev1 should be numeric(12, 3)');
SELECT col_type_is('archived_psector_arc_traceability', 'sys_elev2', 'numeric(12, 3)', 'Column sys_elev2 should be numeric(12, 3)');
SELECT col_type_is('archived_psector_arc_traceability', 'arc_type', 'varchar(18)', 'Column arc_type should be varchar(18)');
SELECT col_type_is('archived_psector_arc_traceability', 'arccat_id', 'varchar(30)', 'Column arccat_id should be varchar(30)');
SELECT col_type_is('archived_psector_arc_traceability', 'matcat_id', 'varchar(30)', 'Column matcat_id should be varchar(30)');
SELECT col_type_is('archived_psector_arc_traceability', 'epa_type', 'varchar(16)', 'Column epa_type should be varchar(16)');
SELECT col_type_is('archived_psector_arc_traceability', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('archived_psector_arc_traceability', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('archived_psector_arc_traceability', 'state_type', 'int2', 'Column state_type should be int2');
SELECT col_type_is('archived_psector_arc_traceability', 'annotation', 'text', 'Column annotation should be text');
SELECT col_type_is('archived_psector_arc_traceability', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('archived_psector_arc_traceability', 'comment', 'text', 'Column comment should be text');
SELECT col_type_is('archived_psector_arc_traceability', 'sys_slope', 'numeric(12, 4)', 'Column sys_slope should be numeric(12, 4)');
SELECT col_type_is('archived_psector_arc_traceability', 'inverted_slope', 'bool', 'Column inverted_slope should be bool');
SELECT col_type_is('archived_psector_arc_traceability', 'custom_length', 'numeric(12, 2)', 'Column custom_length should be numeric(12, 2)');
SELECT col_type_is('archived_psector_arc_traceability', 'dma_id', 'int4', 'Column dma_id should be int4');
SELECT col_type_is('archived_psector_arc_traceability', 'soilcat_id', 'varchar(16)', 'Column soilcat_id should be varchar(16)');
SELECT col_type_is('archived_psector_arc_traceability', 'function_type', 'varchar(50)', 'Column function_type should be varchar(50)');
SELECT col_type_is('archived_psector_arc_traceability', 'category_type', 'varchar(50)', 'Column category_type should be varchar(50)');
SELECT col_type_is('archived_psector_arc_traceability', 'fluid_type', 'varchar(50)', 'Column fluid_type should be varchar(50)');
SELECT col_type_is('archived_psector_arc_traceability', 'location_type', 'varchar(50)', 'Column location_type should be varchar(50)');
SELECT col_type_is('archived_psector_arc_traceability', 'workcat_id', 'varchar(255)', 'Column workcat_id should be varchar(255)');
SELECT col_type_is('archived_psector_arc_traceability', 'workcat_id_end', 'varchar(255)', 'Column workcat_id_end should be varchar(255)');
SELECT col_type_is('archived_psector_arc_traceability', 'builtdate', 'date', 'Column builtdate should be date');
SELECT col_type_is('archived_psector_arc_traceability', 'enddate', 'date', 'Column enddate should be date');
SELECT col_type_is('archived_psector_arc_traceability', 'ownercat_id', 'varchar(30)', 'Column ownercat_id should be varchar(30)');
SELECT col_type_is('archived_psector_arc_traceability', 'muni_id', 'int4', 'Column muni_id should be int4');
SELECT col_type_is('archived_psector_arc_traceability', 'postcode', 'varchar(16)', 'Column postcode should be varchar(16)');
SELECT col_type_is('archived_psector_arc_traceability', 'streetaxis_id', 'varchar(16)', 'Column streetaxis_id should be varchar(16)');
SELECT col_type_is('archived_psector_arc_traceability', 'postnumber', 'int4', 'Column postnumber should be int4');
SELECT col_type_is('archived_psector_arc_traceability', 'postcomplement', 'varchar(100)', 'Column postcomplement should be varchar(100)');
SELECT col_type_is('archived_psector_arc_traceability', 'streetaxis2_id', 'varchar(16)', 'Column streetaxis2_id should be varchar(16)');
SELECT col_type_is('archived_psector_arc_traceability', 'postnumber2', 'int4', 'Column postnumber2 should be int4');
SELECT col_type_is('archived_psector_arc_traceability', 'postcomplement2', 'varchar(100)', 'Column postcomplement2 should be varchar(100)');
SELECT col_type_is('archived_psector_arc_traceability', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('archived_psector_arc_traceability', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('archived_psector_arc_traceability', 'verified', 'int4', 'Column verified should be int4');
SELECT col_type_is('archived_psector_arc_traceability', 'the_geom', 'geometry(linestring, 25831)', 'Column the_geom should be geometry(linestring, 25831)');
SELECT col_type_is('archived_psector_arc_traceability', 'label_x', 'varchar(30)', 'Column label_x should be varchar(30)');
SELECT col_type_is('archived_psector_arc_traceability', 'label_y', 'varchar(30)', 'Column label_y should be varchar(30)');
SELECT col_type_is('archived_psector_arc_traceability', 'label_rotation', 'numeric(6, 3)', 'Column label_rotation should be numeric(6, 3)');
SELECT col_type_is('archived_psector_arc_traceability', 'publish', 'bool', 'Column publish should be bool');
SELECT col_type_is('archived_psector_arc_traceability', 'inventory', 'bool', 'Column inventory should be bool');
SELECT col_type_is('archived_psector_arc_traceability', 'uncertain', 'bool', 'Column uncertain should be bool');
SELECT col_type_is('archived_psector_arc_traceability', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('archived_psector_arc_traceability', 'num_value', 'numeric(12, 3)', 'Column num_value should be numeric(12, 3)');
SELECT col_type_is('archived_psector_arc_traceability', 'feature_type', 'varchar(16)', 'Column feature_type should be varchar(16)');
SELECT col_type_is('archived_psector_arc_traceability', 'tstamp', 'timestamp', 'Column tstamp should be timestamp');
SELECT col_type_is('archived_psector_arc_traceability', 'lastupdate', 'timestamp', 'Column lastupdate should be timestamp');
SELECT col_type_is('archived_psector_arc_traceability', 'lastupdate_user', 'varchar(50)', 'Column lastupdate_user should be varchar(50)');
SELECT col_type_is('archived_psector_arc_traceability', 'insert_user', 'varchar(50)', 'Column insert_user should be varchar(50)');
SELECT col_type_is('archived_psector_arc_traceability', 'district_id', 'int4', 'Column district_id should be int4');
SELECT col_type_is('archived_psector_arc_traceability', 'workcat_id_plan', 'varchar(255)', 'Column workcat_id_plan should be varchar(255)');
SELECT col_type_is('archived_psector_arc_traceability', 'asset_id', 'varchar(50)', 'Column asset_id should be varchar(50)');
SELECT col_type_is('archived_psector_arc_traceability', 'pavcat_id', 'varchar(30)', 'Column pavcat_id should be varchar(30)');
SELECT col_type_is('archived_psector_arc_traceability', 'drainzone_id', 'int4', 'Column drainzone_id should be int4');
SELECT col_type_is('archived_psector_arc_traceability', 'nodetype_1', 'varchar(30)', 'Column nodetype_1 should be varchar(30)');
SELECT col_type_is('archived_psector_arc_traceability', 'node_sys_top_elev_1', 'numeric(12, 3)', 'Column node_sys_top_elev_1 should be numeric(12, 3)');
SELECT col_type_is('archived_psector_arc_traceability', 'node_sys_elev_1', 'numeric(12, 3)', 'Column node_sys_elev_1 should be numeric(12, 3)');
SELECT col_type_is('archived_psector_arc_traceability', 'nodetype_2', 'varchar(30)', 'Column nodetype_2 should be varchar(30)');
SELECT col_type_is('archived_psector_arc_traceability', 'node_sys_top_elev_2', 'numeric(12, 3)', 'Column node_sys_top_elev_2 should be numeric(12, 3)');
SELECT col_type_is('archived_psector_arc_traceability', 'node_sys_elev_2', 'numeric(12, 3)', 'Column node_sys_elev_2 should be numeric(12, 3)');
SELECT col_type_is('archived_psector_arc_traceability', 'parent_id', 'varchar(16)', 'Column parent_id should be varchar(16)');
SELECT col_type_is('archived_psector_arc_traceability', 'adate', 'text', 'Column adate should be text');
SELECT col_type_is('archived_psector_arc_traceability', 'adescript', 'text', 'Column adescript should be text');
SELECT col_type_is('archived_psector_arc_traceability', 'visitability', 'int4', 'Column visitability should be int4');
SELECT col_type_is('archived_psector_arc_traceability', 'label_quadrant', 'varchar(12)', 'Column label_quadrant should be varchar(12)');
SELECT col_type_is('archived_psector_arc_traceability', 'minsector_id', 'int4', 'Column minsector_id should be int4');
SELECT col_type_is('archived_psector_arc_traceability', 'brand_id', 'varchar(50)', 'Column brand_id should be varchar(50)');
SELECT col_type_is('archived_psector_arc_traceability', 'model_id', 'varchar(50)', 'Column model_id should be varchar(50)');
SELECT col_type_is('archived_psector_arc_traceability', 'serial_number', 'varchar(100)', 'Column serial_number should be varchar(100)');
SELECT col_type_is('archived_psector_arc_traceability', 'streetname', 'varchar(100)', 'Column streetname should be varchar(100)');
SELECT col_type_is('archived_psector_arc_traceability', 'streetname2', 'varchar(100)', 'Column streetname2 should be varchar(100)');
SELECT col_type_is('archived_psector_arc_traceability', 'dwfzone_id', 'int4', 'Column dwfzone_id should be int4');
SELECT col_type_is('archived_psector_arc_traceability', 'initoverflowpath', 'bool', 'Column initoverflowpath should be bool');
SELECT col_type_is('archived_psector_arc_traceability', 'omunit_id', 'int4', 'Column omunit_id should be int4');
SELECT col_type_is('archived_psector_arc_traceability', 'registration_date', 'date', 'Column registration_date should be date');
SELECT col_type_is('archived_psector_arc_traceability', 'meandering', 'text', 'Column meandering should be text');
SELECT col_type_is('archived_psector_arc_traceability', 'conserv_state', 'text', 'Column conserv_state should be text');
SELECT col_type_is('archived_psector_arc_traceability', 'om_state', 'text', 'Column om_state should be text');
SELECT col_type_is('archived_psector_arc_traceability', 'last_visitdate', 'date', 'Column last_visitdate should be date');
SELECT col_type_is('archived_psector_arc_traceability', 'negative_offset', 'bool', 'Column negative_offset should be bool');
SELECT col_type_is('archived_psector_arc_traceability', 'expl_visibility', 'integer[]', 'Column expl_visibility should be int4');


--check default values
SELECT col_has_default('archived_psector_arc_traceability', 'audit_tstamp', 'Column audit_tstamp should have default value');
SELECT col_has_default('archived_psector_arc_traceability', 'audit_user', 'Column audit_user should have default value');

-- check foreign keys



-- check index
SELECT has_index('archived_psector_arc_traceability', 'id', 'Table archived_psector_arc_traceability should have index on id');

--check trigger 
SELECT has_trigger('archived_psector_arc_traceability', 'gw_trg_typevalue_fk_insert', 'Table should have trigger gw_trg_typevalue_fk_insert');
SELECT has_trigger('archived_psector_arc_traceability', 'gw_trg_typevalue_fk_update', 'Table should have trigger gw_trg_typevalue_fk_update');
--check rule 

SELECT * FROM finish();

ROLLBACK;