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

-- Check view ve_arc
SELECT has_view('ve_arc'::name, 'View ve_arc should exist');

-- Check view columns
SELECT columns_are(
    've_arc',
    ARRAY[
        'arc_id', 'code', 'sys_code', 'datasource', 'node_1', 'nodetype_1', 'elevation1', 'depth1', 'staticpressure1',
        'node_2', 'nodetype_2', 'staticpressure2', 'elevation2', 'depth2', 'depth', 'arccat_id',
        'arc_type', 'sys_type', 'cat_matcat_id', 'cat_pnom', 'cat_dnom', 'cat_dint', 'cat_dr', 'epa_type',
        'state', 'state_type', 'expl_id', 'macroexpl_id', 'sector_id', 'macrosector_id', 'sector_type',
        'presszone_id', 'presszone_type', 'presszone_head', 'dma_id', 'dma_type', 'macrodma_id', 'dqa_id',
        'dqa_type', 'macrodqa_id', 'supplyzone_id', 'supplyzone_type', 'annotation', 'observ', 'comment', 'gis_length',
        'custom_length', 'soilcat_id', 'function_type', 'category_type', 'fluid_type', 'location_type',
        'workcat_id', 'workcat_id_end', 'workcat_id_plan', 'builtdate', 'enddate', 'ownercat_id', 'muni_id',
        'postcode', 'district_id', 'streetaxis_id', 'postnumber', 'postcomplement', 'streetaxis2_id', 'postnumber2',
        'postcomplement2', 'region_id', 'province_id', 'descript', 'link', 'verified', 'label',
        'label_x', 'label_y', 'label_rotation', 'label_quadrant', 'publish', 'inventory', 'num_value',
        'adate', 'adescript', 'sector_style', 'dma_style', 'presszone_style', 'dqa_style', 'supplyzone_style',
        'asset_id', 'pavcat_id', 'om_state', 'macroomzone_id', 'conserv_state', 'parent_id', 'expl_visibility', 'is_operative',
        'brand_id', 'model_id', 'serial_number', 'minsector_id',
        'flow_max', 'flow_min', 'flow_avg', 'vel_max', 'vel_min', 'vel_avg',
        'tot_headloss_max', 'tot_headloss_min', 'mincut_connecs', 'mincut_hydrometers', 'mincut_length', 'mincut_watervol', 'mincut_criticality', 'hydraulic_criticality', 'result_id',
        'created_at', 'created_by', 'updated_at', 'updated_by',
        'the_geom', 'lock_level', 'inp_type', 'is_scadamap', 'omzone_id', 'omzone_type', 'pipe_capacity', 'mincut_impact_topo', 'mincut_impact_hydro', 'p_state'
    ],
    'View ve_arc should have the correct columns'
);

-- Check if trigger exists
SELECT has_trigger('ve_arc', 'gw_trg_edit_arc', 'Trigger gw_trg_edit_arc should exist on ve_arc');

SELECT * FROM finish();

ROLLBACK;