/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_param_system set project_type='utils' WHERE parameter='utils_graphanalytics_status';

UPDATE sys_function SET function_name='gw_fct_massivemincut' where id=2712;

UPDATE config_toolbox SET alias = 'Mapzones analysis' WHERE id=2768;

UPDATE config_param_system SET value=value::jsonb || '{"node":"SELECT node_id AS node_id, code AS code FROM v_edit_node"}' WHERE parameter='om_profile_guitartext';


UPDATE config_form_fields SET columnname ='demand_max', label='demand_max' WHERE formname = 'v_rpt_node' and  columnname ='max_demand';
UPDATE config_form_fields SET columnname ='demand_min', label='demand_min' WHERE formname = 'v_rpt_node' and  columnname ='min_demand';
UPDATE config_form_fields SET columnname ='demand_avg', label='demand_avg' WHERE formname = 'v_rpt_node' and  columnname ='avg_demand';

UPDATE config_form_fields SET columnname ='press_max', label='press_max' WHERE formname = 'v_rpt_node' and  columnname ='max_pressure';
UPDATE config_form_fields SET columnname ='press_min', label='press_min' WHERE formname = 'v_rpt_node' and  columnname ='min_pressure';
UPDATE config_form_fields SET columnname ='press_avg', label='press_avg' WHERE formname = 'v_rpt_node' and  columnname ='avg_pressure';

UPDATE config_form_fields SET columnname ='quality_max', label='quality_max' WHERE formname = 'v_rpt_node' and  columnname ='max_quality';
UPDATE config_form_fields SET columnname ='quality_min', label='quality_min' WHERE formname = 'v_rpt_node' and  columnname ='min_quality';
UPDATE config_form_fields SET columnname ='quality_avg', label='quality_avg' WHERE formname = 'v_rpt_node' and  columnname ='avg_quality';

UPDATE config_form_fields SET columnname ='head_max', label='head_max' WHERE formname = 'v_rpt_node' and  columnname ='max_head';
UPDATE config_form_fields SET columnname ='head_min', label='head_min' WHERE formname = 'v_rpt_node' and  columnname ='min_head';
UPDATE config_form_fields SET columnname ='head_avg', label='head_avg' WHERE formname = 'v_rpt_node' and  columnname ='avg_head';


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
            datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate,  hidden)
 WITH
  t1 AS
(SELECT distinct formname, formtype, tabname, 'flow_max' as columnname, 'lyt_data_2' as layoutname, max(layoutorder)+1 as layoutorder, 
            'numeric' as datatype, 'text' as widgettype, 'flow_max' as label, 'flow_max' as tooltip,  false as ismandatory, 
            false as isparent, false as iseditable, false as isautoupdate, true as hidden
FROM config_form_fields
WHERE  formname ilike 've_arc%' group by formname,formtype, tabname),
  t2 AS
(SELECT distinct formname, formtype, tabname, 'flow_min', 'lyt_data_2', max(layoutorder)+2, 
            'numeric', 'text', 'flow_min', 'flow_min',  false, false, false, false, true
FROM config_form_fields
WHERE  formname ilike 've_arc%' group by formname,formtype, tabname),
t3 AS
(SELECT distinct formname, formtype, tabname, 'flow_avg', 'lyt_data_2', max(layoutorder)+3, 
            'numeric', 'text', 'flow_avg', 'flow_avg',  false, false, false, false, true
FROM config_form_fields
WHERE  formname ilike 've_arc%' group by formname,formtype, tabname),
t4 AS
(SELECT distinct formname, formtype, tabname, 'vel_max', 'lyt_data_2', max(layoutorder)+4, 
            'numeric', 'text', 'vel_max', 'vel_max',  false, false, false, false, true
FROM config_form_fields
WHERE  formname ilike 've_arc%' group by formname,formtype, tabname),
t5 AS
(SELECT distinct formname, formtype, tabname, 'vel_min', 'lyt_data_2', max(layoutorder)+5, 
            'numeric', 'text', 'vel_min', 'vel_min',  false, false, false, false, true
FROM config_form_fields
WHERE  formname ilike 've_arc%' group by formname,formtype, tabname),
t6 AS
(SELECT distinct formname, formtype, tabname, 'vel_avg', 'lyt_data_2', max(layoutorder)+6, 
            'numeric', 'text', 'vel_avg', 'vel_avg',  false, false, false, false, true
FROM config_form_fields
WHERE  formname ilike 've_arc%' group by formname,formtype, tabname)
select * from t1
  union select * from t2
  union select * from t3 
  union select * from t4 
  union select * from t5 
  union select * from t6 order by formname, layoutorder ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
            datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate,  hidden)
 WITH
  t1 AS
(SELECT distinct formname, formtype, tabname, 'press_max' as columnname, 'lyt_data_2' as layoutname, max(layoutorder)+1 as layoutorder, 
            'numeric' as datatype, 'text' as widgettype, 'press_max' as label, 'press_max' as tooltip,  false as ismandatory, 
            false as isparent, false as iseditable, false as isautoupdate, true as hidden
FROM config_form_fields
WHERE  formname ilike 've_connec%' group by formname,formtype, tabname),
  t2 AS
(SELECT distinct formname, formtype, tabname, 'press_min', 'lyt_data_2', max(layoutorder)+2, 
            'numeric', 'text', 'press_min', 'press_min',  false, false, false, false, true
FROM config_form_fields
WHERE  formname ilike 've_connec%' group by formname,formtype, tabname),
t3 AS
(SELECT distinct formname, formtype, tabname, 'press_avg', 'lyt_data_2', max(layoutorder)+3, 
            'numeric', 'text', 'press_avg', 'press_avg',  false, false, false, false, true
FROM config_form_fields
WHERE  formname ilike 've_connec%' group by formname,formtype, tabname),
t4 AS
(SELECT distinct formname, formtype, tabname, 'demand', 'lyt_data_2', max(layoutorder)+4, 
            'numeric', 'text', 'demand', 'demand',  false, false, false, false, true
FROM config_form_fields
WHERE  formname ilike 've_connec%' group by formname,formtype, tabname)
select * from t1
  union select * from t2
  union select * from t3 
  union select * from t4 order by formname, layoutorder ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


  
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
            datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate,  hidden)
 WITH
  t1 AS
(SELECT distinct formname, formtype, tabname, 'demand_max' as columnname, 'lyt_data_2' as layoutname, max(layoutorder)+1 as layoutorder, 
            'numeric' as datatype, 'text' as widgettype, 'demand_max' as label, 'demand_max' as tooltip,  false as ismandatory, 
            false as isparent, false as iseditable, false as isautoupdate, true as hidden
FROM config_form_fields
WHERE  formname ilike 've_node%' group by formname,formtype, tabname),
  t2 AS
(SELECT distinct formname, formtype, tabname, 'demand_min', 'lyt_data_2', max(layoutorder)+2, 
            'numeric', 'text', 'demand_min', 'demand_min',  false, false, false, false, true
FROM config_form_fields
WHERE  formname ilike 've_node%' group by formname,formtype, tabname),
t3 AS
(SELECT distinct formname, formtype, tabname, 'demand_avg', 'lyt_data_2', max(layoutorder)+3, 
            'numeric', 'text', 'demand_avg', 'demand_avg',  false, false, false, false, true
FROM config_form_fields
WHERE  formname ilike 've_node%' group by formname,formtype, tabname),
t4 AS
(SELECT distinct formname, formtype, tabname, 'press_max', 'lyt_data_2', max(layoutorder)+4, 
            'numeric', 'text', 'press_max', 'press_max',  false, false, false, false, true
FROM config_form_fields
WHERE  formname ilike 've_node%' group by formname,formtype, tabname),
t5 AS
(SELECT distinct formname, formtype, tabname, 'press_min', 'lyt_data_2', max(layoutorder)+5, 
            'numeric', 'text', 'press_min', 'press_min',  false, false, false, false, true
FROM config_form_fields
WHERE  formname ilike 've_node%' group by formname,formtype, tabname),
t6 AS
(SELECT distinct formname, formtype, tabname, 'press_avg', 'lyt_data_2', max(layoutorder)+6, 
            'numeric', 'text', 'press_avg', 'press_avg',  false, false, false, false, true
FROM config_form_fields
WHERE  formname ilike 've_node%' group by formname,formtype, tabname),
t7 AS
(SELECT distinct formname, formtype, tabname, 'head_max', 'lyt_data_2', max(layoutorder)+7, 
            'numeric', 'text', 'head_max', 'head_max',  false, false, false, false, true
FROM config_form_fields
WHERE  formname ilike 've_node%' group by formname,formtype, tabname),
t8 AS
(SELECT distinct formname, formtype, tabname, 'head_min', 'lyt_data_2', max(layoutorder)+8, 
            'numeric', 'text', 'head_min', 'head_min',  false, false, false, false, true
FROM config_form_fields
WHERE  formname ilike 've_node%' group by formname,formtype, tabname),
t9 AS
(SELECT distinct formname, formtype, tabname, 'head_avg', 'lyt_data_2', max(layoutorder)+9, 
            'numeric', 'text', 'head_avg', 'head_avg',  false, false, false, false, true
FROM config_form_fields
WHERE  formname ilike 've_node%' group by formname,formtype, tabname),
t10 AS
(SELECT distinct formname, formtype, tabname, 'quality_max', 'lyt_data_2', max(layoutorder)+10, 
            'numeric', 'text', 'quality_max', 'quality_max',  false, false, false, false, true
FROM config_form_fields
WHERE  formname ilike 've_node%' group by formname,formtype, tabname),
t11 AS
(SELECT distinct formname, formtype, tabname, 'quality_min', 'lyt_data_2', max(layoutorder)+11, 
            'numeric', 'text', 'quality_min', 'quality_min',  false, false, false, false, true
FROM config_form_fields
WHERE  formname ilike 've_node%' group by formname,formtype, tabname),
t12 AS
(SELECT distinct formname, formtype, tabname, 'quality_avg', 'lyt_data_2', max(layoutorder)+12, 
            'numeric', 'text', 'quality_avg', 'quality_avg',  false, false, false, false, true
FROM config_form_fields
WHERE  formname ilike 've_node%' group by formname,formtype, tabname)
select * from t1
  union select * from t2
  union select * from t3 
  union select * from t4 
  union select * from t5 
  union select * from t6 
  union select * from t7
  union select * from t8
  union select * from t9
  union select * from t10
  union select * from t11
  union select * from t12
  order by formname, layoutorder ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3180, 'gw_fct_epa2data', 'ws', 'function', 'json', 'json', 'Function that copies model results into *_add tables in order to show the information in the info form.',
'role_epa',null,'core')  ON CONFLICT (id) DO NOTHING;

DELETE FROM config_form_fields WHERE columnname='to_arc' AND formname ilike '%virtualvalve';

ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
UPDATE inp_typevalue SET typevalue = '_inp_options_networkmode' where typevalue = 'inp_options_networkmode' and id ='3';
ALTER TABLE inp_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;


DELETE FROM sys_table WHERE id = 'v_arc_x_vnode';
DELETE FROM sys_table WHERE id = 'v_vnode';

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 'v_edit_inp_junction', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields WHERE formname = 'v_edit_inp_tank' and columnname = 'expl_id' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate,  hidden)
 WITH
  t1 AS
(SELECT distinct formname, formtype, tabname, 'om_state' as columnname, 'lyt_data_1' as layoutname, max(layoutorder)+1 as layoutorder, 
            'string' as datatype, 'text' as widgettype, 'om_state' as label, 'om_state' as tooltip,  false as ismandatory, 
            false as isparent, true as iseditable, false as isautoupdate, true as hidden
FROM config_form_fields
WHERE  formname ilike 've_arc%' or formname ilike 'v_edit_arc' group by formname,formtype, tabname),
  t2 AS
(SELECT distinct formname, formtype, tabname, 'conserv_state', 'lyt_data_1', max(layoutorder)+2, 
            'string', 'text', 'conserv_state', 'conserv_state',  false, false, true, false, true
FROM config_form_fields
WHERE  formname ilike 've_arc%' or formname ilike 'v_edit_arc' group by formname,formtype, tabname)
select * from t1
union select * from t2
order by formname, layoutorder ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate,  hidden)
WITH
t1 AS
(SELECT distinct formname, formtype, tabname, 'om_state' as columnname, 'lyt_data_1' as layoutname, max(layoutorder)+1 as layoutorder, 
            'string' as datatype, 'text' as widgettype, 'om_state' as label, 'om_state' as tooltip,  false as ismandatory, 
            false as isparent, true as iseditable, false as isautoupdate, true as hidden
FROM config_form_fields
WHERE  formname ilike 've_node%' or formname ilike 'v_edit_node' group by formname,formtype, tabname),
t2 AS
(SELECT distinct formname, formtype, tabname, 'conserv_state', 'lyt_data_1', max(layoutorder)+2, 
            'string', 'text', 'conserv_state', 'conserv_state',  false, false, true, false, true
FROM config_form_fields
WHERE  formname ilike 've_node%' or formname ilike 'v_edit_node' group by formname,formtype, tabname),
t3 AS
(SELECT distinct formname, formtype, tabname, 'access_type', 'lyt_data_1', max(layoutorder)+3, 
            'string', 'text', 'access_type', 'access_type',  false, false, true, false, true
FROM config_form_fields
WHERE  formname ilike 've_node%' or formname ilike 'v_edit_node' group by formname,formtype, tabname),
t4 AS
(SELECT distinct formname, formtype, tabname, 'placement_type', 'lyt_data_1', max(layoutorder)+4, 
            'string', 'text', 'placement_type', 'placement_type',  false, false, true, false, true
FROM config_form_fields
WHERE  formname ilike 've_node%' or formname ilike 'v_edit_node' group by formname,formtype, tabname)
select * from t1
union select * from t2
union select * from t3
union select * from t4
order by formname, layoutorder ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate,  hidden)
WITH
t1 AS
(SELECT distinct formname, formtype, tabname, 'om_state' as columnname, 'lyt_data_1' as layoutname, max(layoutorder)+1 as layoutorder, 
            'string' as datatype, 'text' as widgettype, 'om_state' as label, 'om_state' as tooltip,  false as ismandatory, 
            false as isparent, true as iseditable, false as isautoupdate, true as hidden
FROM config_form_fields
WHERE  formname ilike 've_connec%' or formname ilike 'v_edit_connec' group by formname,formtype, tabname),
t2 AS
(SELECT distinct formname, formtype, tabname, 'conserv_state', 'lyt_data_1', max(layoutorder)+2, 
            'string', 'text', 'conserv_state', 'conserv_state',  false, false, true, false, true
FROM config_form_fields
WHERE  formname ilike 've_connec%' or formname ilike 'v_edit_connec' group by formname,formtype, tabname),
t3 AS
(SELECT distinct formname, formtype, tabname, 'access_type', 'lyt_data_1', max(layoutorder)+3, 
            'string', 'text', 'access_type', 'access_type',  false, false, true, false, true
FROM config_form_fields
WHERE  formname ilike 've_connec%' or formname ilike 'v_edit_connec' group by formname,formtype, tabname),
t4 AS
(SELECT distinct formname, formtype, tabname, 'placement_type', 'lyt_data_1', max(layoutorder)+4, 
            'string', 'text', 'placement_type', 'placement_type',  false, false, true, false, true
FROM config_form_fields
WHERE  formname ilike 've_connec%' or formname ilike 'v_edit_connec' group by formname,formtype, tabname),
t5 AS
(SELECT distinct formname, formtype, tabname, 'priority', 'lyt_data_1', max(layoutorder)+5, 
            'string', 'text', 'priority', 'priority',  false, false, true, false, true
FROM config_form_fields
WHERE  formname ilike 've_connec%' or formname ilike 'v_edit_connec' group by formname,formtype, tabname),
t6 AS
(SELECT distinct formname, formtype, tabname, 'valve_location', 'lyt_data_1', max(layoutorder)+6, 
            'string', 'text', 'valve_location', 'valve_location',  false, false, true, false, true
FROM config_form_fields
WHERE  formname ilike 've_connec%' or formname ilike 'v_edit_connec' group by formname,formtype, tabname),
t7 AS
(SELECT distinct formname, formtype, tabname, 'valve_type', 'lyt_data_1', max(layoutorder)+7, 
            'string', 'text', 'valve_type', 'valve_type',  false, false, true, false, true
FROM config_form_fields
WHERE  formname ilike 've_connec%' or formname ilike 'v_edit_connec' group by formname,formtype, tabname),
t8 AS
(SELECT distinct formname, formtype, tabname, 'shutoff_valve', 'lyt_data_1', max(layoutorder)+8, 
            'string', 'text', 'shutoff_valve', 'shutoff_valve',  false, false, true, false, true
FROM config_form_fields
WHERE  formname ilike 've_connec%' or formname ilike 'v_edit_connec' group by formname,formtype, tabname),
t9 AS
(SELECT distinct formname, formtype, tabname, 'crmzone_name', 'lyt_data_1', max(layoutorder)+9, 
            'string', 'text', 'crmzone_name', 'crmzone_name',  false, false, true, false, true
FROM config_form_fields
WHERE  formname ilike 've_connec%' or formname ilike 'v_edit_connec' group by formname,formtype, tabname)
select * from t1
union select * from t2
union select * from t3
union select * from t4
union select * from t5
union select * from t6
union select * from t7
union select * from t8
union select * from t9
order by formname, layoutorder ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate,  hidden)
SELECT distinct child_layer, formtype, tabname, 'valve_type', 'lyt_data_2', max(layoutorder)+1, 
'string', 'text', 'valve_type', 'valve_type',  false, false, true, false, true
FROM cat_feature
join config_form_fields on formname = child_layer
WHERE  system_id ilike 'VALVE' group by child_layer,formname,formtype, tabname ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate,  hidden)
SELECT distinct child_layer, formtype, tabname, 'wjoin_type', 'lyt_data_2', max(layoutorder)+1, 
'string', 'text', 'wjoin_type', 'wjoin_type',  false, false, true, false, true
FROM cat_feature
join config_form_fields on formname = child_layer
WHERE  system_id ilike 'WJOIN' group by child_layer,formname,formtype, tabname ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate,  hidden)
WITH
t1 AS (SELECT distinct child_layer, formtype, tabname, 'greentap_type', 'lyt_data_2', max(layoutorder)+1 AS layoutorder,  
'string', 'text', 'greentap_type', 'greentap_type',  false, false, true, false, true
FROM cat_feature
join config_form_fields on formname = child_layer
WHERE  system_id ilike 'GREENTAP' group by formname,formtype, tabname, child_layer),
t2 AS (SELECT distinct child_layer, formtype, tabname, 'cat_valve', 'lyt_data_2', max(layoutorder)+2, 
'string', 'text', 'cat_valve', 'cat_valve',  false, false, true, false, true
FROM cat_feature
join config_form_fields on formname = child_layer
WHERE  system_id ilike 'GREENTAP' group by formname,formtype, tabname,child_layer)
select * from t1
union select * from t2
order by child_layer, layoutorder ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate,  hidden)
SELECT distinct child_layer, formtype, tabname, 'hydrant_type', 'lyt_data_2', max(layoutorder)+1, 
'string', 'text', 'hydrant_type', 'hydrant_type',  false, false, true, false, true
FROM cat_feature
join config_form_fields on formname = child_layer
WHERE  system_id ilike 'HYDRANT' group by child_layer,formname,formtype, tabname ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json, 'manageAll','true'::bool) WHERE parameter = 'basic_selector_tab_mincut';

UPDATE link SET dma_id = c.dma_id, sector_id = c.sector_id, presszone_id = c.presszone_id, dqa_id = c.dqa_id, minsector_id = c.minsector_id FROM connec c WHERE feature_id = connec_id;

DELETE FROM sys_table WHERE id = 'v_rtc_period_node';
DELETE FROM sys_table WHERE id = 'v_rtc_period_pjointpattern';
DELETE FROM sys_table WHERE id = 'v_rtc_period_pjoint';
DELETE FROM sys_table WHERE id = 'v_rtc_interval_nodepattern';
DELETE FROM sys_table WHERE id = 'v_rtc_period_nodepattern';
DELETE FROM sys_table WHERE id = 'v_rtc_period_dma';


UPDATE sys_param_user SET label  ='Pattern for null values:' WHERE id  = 'inp_options_patternmethod';
UPDATE sys_param_user SET label  ='Global pattern:' WHERE id  = 'inp_options_pattern';

UPDATE inp_typevalue SET idval  ='KEEP NULL VALUES' WHERE id  = '14'  AND typevalue  ='inp_value_patternmethod';
UPDATE inp_typevalue SET idval  ='GLOBAL PATTERN' WHERE id  =  '11' AND typevalue  ='inp_value_patternmethod';

delete from config_form_fields where formname='v_edit_link' and columnname in ('userdefined_geom', 'psector_rowid', 'ispsectorgeom');

INSERT INTO config_form_fields VALUES('v_edit_link', 'form_feature', 'main', 'presszone_id', 'lyt_data_1', 13, 'integer', 'text', 'presszone_id', NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES('v_edit_link', 'form_feature', 'main', 'dqa_id', 'lyt_data_1', 14, 'integer', 'text', 'dqa_id', NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES('v_edit_link', 'form_feature', 'main', 'minsector_id', 'lyt_data_1', 15, 'integer', 'text', 'minsector_id', NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES('v_edit_link', 'form_feature', 'main', 'exit_topelev', 'lyt_data_1', 16, 'double', 'text', 'exit_topelev', NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES('v_edit_link', 'form_feature', 'main', 'exit_elev', 'lyt_data_1', 17, 'double', 'text', 'exit_elev', NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES('v_edit_link', 'form_feature', 'main', 'sector_name', 'lyt_data_1', 18, 'string', 'text', 'sector_name', NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES('v_edit_link', 'form_feature', 'main', 'dma_name', 'lyt_data_1', 19, 'string', 'text', 'dma_name', NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES('v_edit_link', 'form_feature', 'main', 'dqa_name', 'lyt_data_1', 20, 'string', 'text', 'dqa_name', NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES('v_edit_link', 'form_feature', 'main', 'presszone_name', 'lyt_data_1', 21, 'string', 'text', 'presszone_name', NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES('v_edit_link', 'form_feature', 'main', 'macrodqa_id', 'lyt_data_1', 22, 'integer', 'text', 'macrodqa_id', NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL)ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES('v_edit_link', 'form_feature', 'main', 'fluid_type', 'lyt_data_1', 23, 'string', 'text', 'fluid_type', NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, dv_querytext, dv_orderby_id, dv_isnullvalue, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate,  hidden)
SELECT distinct formname, formtype, tabname, 'crmzone_id', 'lyt_data_2', max(layoutorder)+1, 
'string', 'combo', 'SELECT id, name as idval FROM crm_zone WHERE id IS NOT NULL AND active IS TRUE ', true, true,
'crmzone_id', 'crmzone_id',  false, false, true, false, true
FROM config_form_fields
WHERE  formname ilike 've_connec%' or formname ilike 'v_edit_connec' group by formname,formtype, tabname ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE config_form_fields SET label='Sector name' WHERE label='Dma name' AND columnname='sector_name';

DELETE FROM config_param_system WHERE "parameter"='edit_connect_autoupdate_dma';
DELETE FROM config_param_system WHERE "parameter"='edit_connect_autoupdate_fluid';

ALTER TABLE arc DISABLE TRIGGER gw_trg_arc_link_update;
ALTER TABLE arc DISABLE TRIGGER gw_trg_arc_noderotation_update;
ALTER TABLE arc DISABLE TRIGGER gw_trg_topocontrol_arc;

UPDATE arc SET nodetype_1 = node_type FROM vu_node WHERE node_id = node_1;
UPDATE arc SET nodetype_2 = node_type FROM vu_node WHERE node_id = node_2;
UPDATE arc SET elevation1 = elevation FROM vu_node WHERE node_id = node_1;
UPDATE arc SET elevation2 = elevation FROM vu_node WHERE node_id = node_2;
UPDATE arc SET depth1 = vu_node.depth FROM vu_node WHERE node_id = node_1;
UPDATE arc SET depth2 = vu_node.depth FROM vu_node WHERE node_id = node_2;
UPDATE arc SET staticpress1 = vu_node.staticpressure FROM vu_node WHERE node_id = node_1;
UPDATE arc SET staticpress2 = vu_node.staticpressure FROM vu_node WHERE node_id = node_2;

ALTER TABLE arc ENABLE TRIGGER gw_trg_arc_link_update;
ALTER TABLE arc ENABLE TRIGGER gw_trg_arc_noderotation_update;
ALTER TABLE arc ENABLE TRIGGER gw_trg_topocontrol_arc;


SELECT gw_fct_connect_link_refactor();