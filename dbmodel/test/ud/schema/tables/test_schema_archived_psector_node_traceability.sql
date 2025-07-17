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
SELECT has_table('archived_psector_node_traceability'::name, 'Table archived_psector_node_traceability should exist');

-- Check columns
SELECT columns_are(
    'archived_psector_node_traceability',
    ARRAY[
        'id','psector_id','psector_state','doable','addparam','audit_tstamp','audit_user','action',
        'node_id','code','top_elev','ymax','elev','custom_top_elev','custom_ymax','custom_elev',
        'node_type','nodecat_id','epa_type','sector_id','state','state_type','annotation','observ',
        'comment','dma_id','soilcat_id','function_type','category_type','fluid_type','location_type',
        'workcat_id','workcat_id_end','builtdate','enddate','ownercat_id','muni_id','postcode',
        'streetaxis_id','postnumber','postcomplement','streetaxis2_id','postnumber2','postcomplement2',
        'descript','rotation','link','verified','the_geom','label_x','label_y','label_rotation',
        'publish','inventory','xyz_date','uncertain','unconnected','expl_id','num_value','feature_type',
        'tstamp','arc_id','lastupdate','lastupdate_user','insert_user','matcat_id','district_id',
        'workcat_id_plan','asset_id','drainzone_id','parent_id','adate','adescript','placement_type',
        'access_type','label_quadrant','minsector_id','brand_id','model_id','serial_number',
        'streetname','streetname2','dwfzone_id','datasource','omunit_id','lock_level','pavcat_id',
        'conserv_state','expl_visibility'
    ],
    'Table archived_psector_node_traceability should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('archived_psector_node_traceability','id','Column id should be primary key');

-- Check column types
SELECT col_type_is('archived_psector_node_traceability','id','integer','Column id should be integer');
SELECT col_type_is('archived_psector_node_traceability','psector_id','integer','Column psector_id should be integer');
SELECT col_type_is('archived_psector_node_traceability','psector_state','smallint','Column psector_state should be smallint');
SELECT col_type_is('archived_psector_node_traceability','doable','boolean','Column doable should be boolean');
SELECT col_type_is('archived_psector_node_traceability','addparam','json','Column addparam should be json');
SELECT col_type_is('archived_psector_node_traceability','audit_tstamp','timestamp','Column audit_tstamp should be timestamp');
SELECT col_type_is('archived_psector_node_traceability','audit_user','text','Column audit_user should be text');
SELECT col_type_is('archived_psector_node_traceability','action','varchar(16)','Column action should be varchar(16)');
SELECT col_type_is('archived_psector_node_traceability','node_id','integer','Column node_id should be integer');
SELECT col_type_is('archived_psector_node_traceability','code','text','Column code should be text');
SELECT col_type_is('archived_psector_node_traceability','top_elev','numeric(12,3)','Column top_elev should be numeric(12,3)');
SELECT col_type_is('archived_psector_node_traceability','ymax','numeric(12,3)','Column ymax should be numeric(12,3)');
SELECT col_type_is('archived_psector_node_traceability','elev','numeric(12,3)','Column elev should be numeric(12,3)');
SELECT col_type_is('archived_psector_node_traceability','custom_top_elev','numeric(12,3)','Column custom_top_elev should be numeric(12,3)');
SELECT col_type_is('archived_psector_node_traceability','custom_ymax','numeric(12,3)','Column custom_ymax should be numeric(12,3)');
SELECT col_type_is('archived_psector_node_traceability','custom_elev','numeric(12,3)','Column custom_elev should be numeric(12,3)');
SELECT col_type_is('archived_psector_node_traceability','node_type','varchar(30)','Column node_type should be varchar(30)');
SELECT col_type_is('archived_psector_node_traceability','nodecat_id','varchar(30)','Column nodecat_id should be varchar(30)');
SELECT col_type_is('archived_psector_node_traceability','epa_type','varchar(16)','Column epa_type should be varchar(16)');
SELECT col_type_is('archived_psector_node_traceability','sector_id','integer','Column sector_id should be integer');
SELECT col_type_is('archived_psector_node_traceability','state','smallint','Column state should be smallint');
SELECT col_type_is('archived_psector_node_traceability','state_type','smallint','Column state_type should be smallint');
SELECT col_type_is('archived_psector_node_traceability','annotation','text','Column annotation should be text');
SELECT col_type_is('archived_psector_node_traceability','observ','text','Column observ should be text');
SELECT col_type_is('archived_psector_node_traceability','comment','text','Column comment should be text');
SELECT col_type_is('archived_psector_node_traceability','dma_id','integer','Column dma_id should be integer');
SELECT col_type_is('archived_psector_node_traceability','soilcat_id','varchar(16)','Column soilcat_id should be varchar(16)');
SELECT col_type_is('archived_psector_node_traceability','function_type','varchar(50)','Column function_type should be varchar(50)');
SELECT col_type_is('archived_psector_node_traceability','category_type','varchar(50)','Column category_type should be varchar(50)');
SELECT col_type_is('archived_psector_node_traceability','fluid_type','varchar(50)','Column fluid_type should be varchar(50)');
SELECT col_type_is('archived_psector_node_traceability','location_type','varchar(50)','Column location_type should be varchar(50)');
SELECT col_type_is('archived_psector_node_traceability','workcat_id','varchar(255)','Column workcat_id should be varchar(255)');
SELECT col_type_is('archived_psector_node_traceability','workcat_id_end','varchar(255)','Column workcat_id_end should be varchar(255)');
SELECT col_type_is('archived_psector_node_traceability','builtdate','date','Column builtdate should be date');
SELECT col_type_is('archived_psector_node_traceability','enddate','date','Column enddate should be date');
SELECT col_type_is('archived_psector_node_traceability','ownercat_id','varchar(30)','Column ownercat_id should be varchar(30)');
SELECT col_type_is('archived_psector_node_traceability','muni_id','integer','Column muni_id should be integer');
SELECT col_type_is('archived_psector_node_traceability','postcode','varchar(16)','Column postcode should be varchar(16)');
SELECT col_type_is('archived_psector_node_traceability','streetaxis_id','varchar(16)','Column streetaxis_id should be varchar(16)');
SELECT col_type_is('archived_psector_node_traceability','postnumber','integer','Column postnumber should be integer');
SELECT col_type_is('archived_psector_node_traceability','postcomplement','varchar(100)','Column postcomplement should be varchar(100)');
SELECT col_type_is('archived_psector_node_traceability','streetaxis2_id','varchar(16)','Column streetaxis2_id should be varchar(16)');
SELECT col_type_is('archived_psector_node_traceability','postnumber2','integer','Column postnumber2 should be integer');
SELECT col_type_is('archived_psector_node_traceability','postcomplement2','varchar(100)','Column postcomplement2 should be varchar(100)');
SELECT col_type_is('archived_psector_node_traceability','descript','text','Column descript should be text');
SELECT col_type_is('archived_psector_node_traceability','rotation','numeric(6,3)','Column rotation should be numeric(6,3)');
SELECT col_type_is('archived_psector_node_traceability','link','varchar(512)','Column link should be varchar(512)');
SELECT col_type_is('archived_psector_node_traceability','verified','integer','Column verified should be integer');
SELECT col_type_is('archived_psector_node_traceability','the_geom','geometry(Point,25831)','Column the_geom should be geometry(Point,25831)');
SELECT col_type_is('archived_psector_node_traceability','label_x','varchar(30)','Column label_x should be varchar(30)');
SELECT col_type_is('archived_psector_node_traceability','label_y','varchar(30)','Column label_y should be varchar(30)');
SELECT col_type_is('archived_psector_node_traceability','label_rotation','numeric(6,3)','Column label_rotation should be numeric(6,3)');
SELECT col_type_is('archived_psector_node_traceability','publish','boolean','Column publish should be boolean');
SELECT col_type_is('archived_psector_node_traceability','inventory','boolean','Column inventory should be boolean');
SELECT col_type_is('archived_psector_node_traceability','xyz_date','date','Column xyz_date should be date');
SELECT col_type_is('archived_psector_node_traceability','uncertain','boolean','Column uncertain should be boolean');
SELECT col_type_is('archived_psector_node_traceability','unconnected','boolean','Column unconnected should be boolean');
SELECT col_type_is('archived_psector_node_traceability','expl_id','integer','Column expl_id should be integer');
SELECT col_type_is('archived_psector_node_traceability','num_value','numeric(12,3)','Column num_value should be numeric(12,3)');
SELECT col_type_is('archived_psector_node_traceability','feature_type','varchar(16)','Column feature_type should be varchar(16)');
SELECT col_type_is('archived_psector_node_traceability','tstamp','timestamp','Column tstamp should be timestamp');
SELECT col_type_is('archived_psector_node_traceability','arc_id','varchar(16)','Column arc_id should be varchar(16)');
SELECT col_type_is('archived_psector_node_traceability','lastupdate','timestamp','Column lastupdate should be timestamp');
SELECT col_type_is('archived_psector_node_traceability','lastupdate_user','varchar(50)','Column lastupdate_user should be varchar(50)');
SELECT col_type_is('archived_psector_node_traceability','insert_user','varchar(50)','Column insert_user should be varchar(50)');
SELECT col_type_is('archived_psector_node_traceability','matcat_id','varchar(16)','Column matcat_id should be varchar(16)');
SELECT col_type_is('archived_psector_node_traceability','district_id','integer','Column district_id should be integer');
SELECT col_type_is('archived_psector_node_traceability','workcat_id_plan','varchar(255)','Column workcat_id_plan should be varchar(255)');
SELECT col_type_is('archived_psector_node_traceability','asset_id','varchar(50)','Column asset_id should be varchar(50)');
SELECT col_type_is('archived_psector_node_traceability','drainzone_id','integer','Column drainzone_id should be integer');
SELECT col_type_is('archived_psector_node_traceability','parent_id','varchar(16)','Column parent_id should be varchar(16)');
SELECT col_type_is('archived_psector_node_traceability','adate','text','Column adate should be text');
SELECT col_type_is('archived_psector_node_traceability','adescript','text','Column adescript should be text');
SELECT col_type_is('archived_psector_node_traceability','placement_type','varchar(50)','Column placement_type should be varchar(50)');
SELECT col_type_is('archived_psector_node_traceability','access_type','text','Column access_type should be text');
SELECT col_type_is('archived_psector_node_traceability','label_quadrant','varchar(12)','Column label_quadrant should be varchar(12)');
SELECT col_type_is('archived_psector_node_traceability','minsector_id','integer','Column minsector_id should be integer');
SELECT col_type_is('archived_psector_node_traceability','brand_id','varchar(50)','Column brand_id should be varchar(50)');
SELECT col_type_is('archived_psector_node_traceability','model_id','varchar(50)','Column model_id should be varchar(50)');
SELECT col_type_is('archived_psector_node_traceability','serial_number','varchar(100)','Column serial_number should be varchar(100)');
SELECT col_type_is('archived_psector_node_traceability','streetname','varchar(100)','Column streetname should be varchar(100)');
SELECT col_type_is('archived_psector_node_traceability','streetname2','varchar(100)','Column streetname2 should be varchar(100)');
SELECT col_type_is('archived_psector_node_traceability','dwfzone_id','integer','Column dwfzone_id should be integer');
SELECT col_type_is('archived_psector_node_traceability','datasource','integer','Column datasource should be integer');
SELECT col_type_is('archived_psector_node_traceability','omunit_id','integer','Column omunit_id should be integer');
SELECT col_type_is('archived_psector_node_traceability','lock_level','integer','Column lock_level should be integer');
SELECT col_type_is('archived_psector_node_traceability','pavcat_id','varchar(30)','Column pavcat_id should be varchar(30)');
SELECT col_type_is('archived_psector_node_traceability','conserv_state','text','Column conserv_state should be text');
SELECT col_type_is('archived_psector_node_traceability','expl_visibility','integer[]','Column expl_visibility should be integer[]');


-- Check default values
SELECT col_has_default('archived_psector_node_traceability','audit_tstamp','Column audit_tstamp should have default value');
SELECT col_has_default('archived_psector_node_traceability','audit_user','Column audit_user should have default value');

-- Check triggers
SELECT has_trigger('archived_psector_node_traceability','gw_trg_typevalue_fk_insert','Table should have trigger gw_trg_typevalue_fk_insert');
SELECT has_trigger('archived_psector_node_traceability','gw_trg_typevalue_fk_update','Table should have trigger gw_trg_typevalue_fk_update');

-- Finish
SELECT * FROM finish();

ROLLBACK;