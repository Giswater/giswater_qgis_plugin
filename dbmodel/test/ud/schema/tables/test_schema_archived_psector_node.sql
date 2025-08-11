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
SELECT has_table('archived_psector_node'::name, 'Table archived_psector_node should exist');

-- Check columns
SELECT columns_are(
    'archived_psector_node',
    ARRAY[
        'id','psector_id','psector_state','doable','addparam','audit_tstamp','audit_user','action',
        'node_id','code','top_elev','ymax','elev','custom_top_elev','custom_ymax','custom_elev',
        'node_type','nodecat_id','epa_type','sector_id','state','state_type','annotation','observ',
        'comment','dma_id','soilcat_id','function_type','category_type','fluid_type','location_type',
        'workcat_id','workcat_id_end','builtdate','enddate','ownercat_id','muni_id','postcode',
        'streetaxis_id','postnumber','postcomplement','streetaxis2_id','postnumber2','postcomplement2',
        'descript','rotation','link','verified','the_geom','label_x','label_y','label_rotation',
        'publish','inventory','xyz_date','uncertain','unconnected','expl_id','num_value','feature_type',
        'created_at','arc_id','updated_at','updated_by','created_by','matcat_id','district_id',
        'workcat_id_plan','asset_id','drainzone_id','parent_id','adate','adescript','placement_type',
        'access_type','label_quadrant','minsector_id','brand_id','model_id','serial_number',
        'dwfzone_id','datasource','omunit_id','lock_level','pavcat_id',
        'conserv_state','expl_visibility'
    ],
    'Table archived_psector_node should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('archived_psector_node','id','Column id should be primary key');

-- Check column types
SELECT col_type_is('archived_psector_node','id','integer','Column id should be integer');
SELECT col_type_is('archived_psector_node','psector_id','integer','Column psector_id should be integer');
SELECT col_type_is('archived_psector_node','psector_state','smallint','Column psector_state should be smallint');
SELECT col_type_is('archived_psector_node','doable','boolean','Column doable should be boolean');
SELECT col_type_is('archived_psector_node','addparam','json','Column addparam should be json');
SELECT col_type_is('archived_psector_node','audit_tstamp','timestamp','Column audit_tstamp should be timestamp');
SELECT col_type_is('archived_psector_node','audit_user','text','Column audit_user should be text');
SELECT col_type_is('archived_psector_node','action','varchar(16)','Column action should be varchar(16)');
SELECT col_type_is('archived_psector_node','node_id','integer','Column node_id should be integer');
SELECT col_type_is('archived_psector_node','code','text','Column code should be text');
SELECT col_type_is('archived_psector_node','top_elev','numeric(12,3)','Column top_elev should be numeric(12,3)');
SELECT col_type_is('archived_psector_node','ymax','numeric(12,3)','Column ymax should be numeric(12,3)');
SELECT col_type_is('archived_psector_node','elev','numeric(12,3)','Column elev should be numeric(12,3)');
SELECT col_type_is('archived_psector_node','custom_top_elev','numeric(12,3)','Column custom_top_elev should be numeric(12,3)');
SELECT col_type_is('archived_psector_node','custom_ymax','numeric(12,3)','Column custom_ymax should be numeric(12,3)');
SELECT col_type_is('archived_psector_node','custom_elev','numeric(12,3)','Column custom_elev should be numeric(12,3)');
SELECT col_type_is('archived_psector_node','node_type','varchar(30)','Column node_type should be varchar(30)');
SELECT col_type_is('archived_psector_node','nodecat_id','varchar(30)','Column nodecat_id should be varchar(30)');
SELECT col_type_is('archived_psector_node','epa_type','varchar(16)','Column epa_type should be varchar(16)');
SELECT col_type_is('archived_psector_node','sector_id','integer','Column sector_id should be integer');
SELECT col_type_is('archived_psector_node','state','smallint','Column state should be smallint');
SELECT col_type_is('archived_psector_node','state_type','smallint','Column state_type should be smallint');
SELECT col_type_is('archived_psector_node','annotation','text','Column annotation should be text');
SELECT col_type_is('archived_psector_node','observ','text','Column observ should be text');
SELECT col_type_is('archived_psector_node','comment','text','Column comment should be text');
SELECT col_type_is('archived_psector_node','dma_id','integer','Column dma_id should be integer');
SELECT col_type_is('archived_psector_node','soilcat_id','varchar(16)','Column soilcat_id should be varchar(16)');
SELECT col_type_is('archived_psector_node','function_type','varchar(50)','Column function_type should be varchar(50)');
SELECT col_type_is('archived_psector_node','category_type','varchar(50)','Column category_type should be varchar(50)');
SELECT col_type_is('archived_psector_node','fluid_type','varchar(50)','Column fluid_type should be varchar(50)');
SELECT col_type_is('archived_psector_node','location_type','varchar(50)','Column location_type should be varchar(50)');
SELECT col_type_is('archived_psector_node','workcat_id','varchar(255)','Column workcat_id should be varchar(255)');
SELECT col_type_is('archived_psector_node','workcat_id_end','varchar(255)','Column workcat_id_end should be varchar(255)');
SELECT col_type_is('archived_psector_node','builtdate','date','Column builtdate should be date');
SELECT col_type_is('archived_psector_node','enddate','date','Column enddate should be date');
SELECT col_type_is('archived_psector_node','ownercat_id','varchar(30)','Column ownercat_id should be varchar(30)');
SELECT col_type_is('archived_psector_node','muni_id','integer','Column muni_id should be integer');
SELECT col_type_is('archived_psector_node','postcode','varchar(16)','Column postcode should be varchar(16)');
SELECT col_type_is('archived_psector_node','streetaxis_id','varchar(16)','Column streetaxis_id should be varchar(16)');
SELECT col_type_is('archived_psector_node','postnumber','integer','Column postnumber should be integer');
SELECT col_type_is('archived_psector_node','postcomplement','varchar(100)','Column postcomplement should be varchar(100)');
SELECT col_type_is('archived_psector_node','streetaxis2_id','varchar(16)','Column streetaxis2_id should be varchar(16)');
SELECT col_type_is('archived_psector_node','postnumber2','integer','Column postnumber2 should be integer');
SELECT col_type_is('archived_psector_node','postcomplement2','varchar(100)','Column postcomplement2 should be varchar(100)');
SELECT col_type_is('archived_psector_node','descript','text','Column descript should be text');
SELECT col_type_is('archived_psector_node','rotation','numeric(6,3)','Column rotation should be numeric(6,3)');
SELECT col_type_is('archived_psector_node','link','varchar(512)','Column link should be varchar(512)');
SELECT col_type_is('archived_psector_node','verified','integer','Column verified should be integer');
SELECT col_type_is('archived_psector_node','the_geom','geometry(Point,25831)','Column the_geom should be geometry(Point,25831)');
SELECT col_type_is('archived_psector_node','label_x','varchar(30)','Column label_x should be varchar(30)');
SELECT col_type_is('archived_psector_node','label_y','varchar(30)','Column label_y should be varchar(30)');
SELECT col_type_is('archived_psector_node','label_rotation','numeric(6,3)','Column label_rotation should be numeric(6,3)');
SELECT col_type_is('archived_psector_node','publish','boolean','Column publish should be boolean');
SELECT col_type_is('archived_psector_node','inventory','boolean','Column inventory should be boolean');
SELECT col_type_is('archived_psector_node','xyz_date','date','Column xyz_date should be date');
SELECT col_type_is('archived_psector_node','uncertain','boolean','Column uncertain should be boolean');
SELECT col_type_is('archived_psector_node','unconnected','boolean','Column unconnected should be boolean');
SELECT col_type_is('archived_psector_node','expl_id','integer','Column expl_id should be integer');
SELECT col_type_is('archived_psector_node','num_value','numeric(12,3)','Column num_value should be numeric(12,3)');
SELECT col_type_is('archived_psector_node','feature_type','varchar(16)','Column feature_type should be varchar(16)');
SELECT col_type_is('archived_psector_node','created_at','timestamp','Column created_at should be timestamp');
SELECT col_type_is('archived_psector_node','arc_id','varchar(16)','Column arc_id should be varchar(16)');
SELECT col_type_is('archived_psector_node','updated_at','timestamp','Column updated_at should be timestamp');
SELECT col_type_is('archived_psector_node','updated_by','varchar(50)','Column updated_by should be varchar(50)');
SELECT col_type_is('archived_psector_node','created_by','varchar(50)','Column created_by should be varchar(50)');
SELECT col_type_is('archived_psector_node','matcat_id','varchar(16)','Column matcat_id should be varchar(16)');
SELECT col_type_is('archived_psector_node','district_id','integer','Column district_id should be integer');
SELECT col_type_is('archived_psector_node','workcat_id_plan','varchar(255)','Column workcat_id_plan should be varchar(255)');
SELECT col_type_is('archived_psector_node','asset_id','varchar(50)','Column asset_id should be varchar(50)');
SELECT col_type_is('archived_psector_node','drainzone_id','integer','Column drainzone_id should be integer');
SELECT col_type_is('archived_psector_node','parent_id','varchar(16)','Column parent_id should be varchar(16)');
SELECT col_type_is('archived_psector_node','adate','text','Column adate should be text');
SELECT col_type_is('archived_psector_node','adescript','text','Column adescript should be text');
SELECT col_type_is('archived_psector_node','placement_type','varchar(50)','Column placement_type should be varchar(50)');
SELECT col_type_is('archived_psector_node','access_type','text','Column access_type should be text');
SELECT col_type_is('archived_psector_node','label_quadrant','varchar(12)','Column label_quadrant should be varchar(12)');
SELECT col_type_is('archived_psector_node','minsector_id','integer','Column minsector_id should be integer');
SELECT col_type_is('archived_psector_node','brand_id','varchar(50)','Column brand_id should be varchar(50)');
SELECT col_type_is('archived_psector_node','model_id','varchar(50)','Column model_id should be varchar(50)');
SELECT col_type_is('archived_psector_node','serial_number','varchar(100)','Column serial_number should be varchar(100)');
SELECT col_type_is('archived_psector_node','dwfzone_id','integer','Column dwfzone_id should be integer');
SELECT col_type_is('archived_psector_node','datasource','integer','Column datasource should be integer');
SELECT col_type_is('archived_psector_node','omunit_id','integer','Column omunit_id should be integer');
SELECT col_type_is('archived_psector_node','lock_level','integer','Column lock_level should be integer');
SELECT col_type_is('archived_psector_node','pavcat_id','varchar(30)','Column pavcat_id should be varchar(30)');
SELECT col_type_is('archived_psector_node','conserv_state','text','Column conserv_state should be text');
SELECT col_type_is('archived_psector_node','expl_visibility','integer[]','Column expl_visibility should be integer[]');


-- Check default values
SELECT col_has_default('archived_psector_node','audit_tstamp','Column audit_tstamp should have default value');
SELECT col_has_default('archived_psector_node','audit_user','Column audit_user should have default value');

-- Check triggers
SELECT has_trigger('archived_psector_node','gw_trg_typevalue_fk_insert','Table should have trigger gw_trg_typevalue_fk_insert');
SELECT has_trigger('archived_psector_node','gw_trg_typevalue_fk_update','Table should have trigger gw_trg_typevalue_fk_update');

-- Finish
SELECT * FROM finish();

ROLLBACK;