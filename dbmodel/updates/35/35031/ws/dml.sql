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
(SELECT distinct formname, formtype, tabname, 'flow_max' as columnname, 'lyt_data_1' as layoutname, max(layoutorder)+1 as layoutorder, 
            'numeric' as datatype, 'text' as widgettype, 'flow_max' as label, 'flow_max' as tooltip,  false as ismandatory, 
            false as isparent, false as iseditable, false as isautoupdate, false as hidden
FROM config_form_fields
WHERE  formname ilike 've_arc%' group by formname,formtype, tabname),
  t2 AS
(SELECT distinct formname, formtype, tabname, 'flow_min', 'lyt_data_1', max(layoutorder)+2, 
            'numeric', 'text', 'flow_min', 'flow_min',  false, false, false, false, false
FROM config_form_fields
WHERE  formname ilike 've_arc%' group by formname,formtype, tabname),
t3 AS
(SELECT distinct formname, formtype, tabname, 'flow_avg', 'lyt_data_1', max(layoutorder)+3, 
            'numeric', 'text', 'flow_avg', 'flow_avg',  false, false, false, false, false
FROM config_form_fields
WHERE  formname ilike 've_arc%' group by formname,formtype, tabname),
t4 AS
(SELECT distinct formname, formtype, tabname, 'vel_max', 'lyt_data_1', max(layoutorder)+4, 
            'numeric', 'text', 'vel_max', 'vel_max',  false, false, false, false, false
FROM config_form_fields
WHERE  formname ilike 've_arc%' group by formname,formtype, tabname),
t5 AS
(SELECT distinct formname, formtype, tabname, 'vel_min', 'lyt_data_1', max(layoutorder)+5, 
            'numeric', 'text', 'vel_min', 'vel_min',  false, false, false, false, false
FROM config_form_fields
WHERE  formname ilike 've_arc%' group by formname,formtype, tabname),
t6 AS
(SELECT distinct formname, formtype, tabname, 'vel_avg', 'lyt_data_1', max(layoutorder)+6, 
            'numeric', 'text', 'vel_avg', 'vel_avg',  false, false, false, false, false
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
(SELECT distinct formname, formtype, tabname, 'press_max' as columnname, 'lyt_data_1' as layoutname, max(layoutorder)+1 as layoutorder, 
            'numeric' as datatype, 'text' as widgettype, 'press_max' as label, 'press_max' as tooltip,  false as ismandatory, 
            false as isparent, false as iseditable, false as isautoupdate, false as hidden
FROM config_form_fields
WHERE  formname ilike 've_connec%' group by formname,formtype, tabname),
  t2 AS
(SELECT distinct formname, formtype, tabname, 'press_min', 'lyt_data_1', max(layoutorder)+2, 
            'numeric', 'text', 'press_min', 'press_min',  false, false, false, false, false
FROM config_form_fields
WHERE  formname ilike 've_connec%' group by formname,formtype, tabname),
t3 AS
(SELECT distinct formname, formtype, tabname, 'press_avg', 'lyt_data_1', max(layoutorder)+3, 
            'numeric', 'text', 'press_avg', 'press_avg',  false, false, false, false, false
FROM config_form_fields
WHERE  formname ilike 've_connec%' group by formname,formtype, tabname)
select * from t1
  union select * from t2
  union select * from t3  order by formname, layoutorder ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;



  
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
            datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate,  hidden)
 WITH
  t1 AS
(SELECT distinct formname, formtype, tabname, 'demand_max' as columnname, 'lyt_data_1' as layoutname, max(layoutorder)+1 as layoutorder, 
            'numeric' as datatype, 'text' as widgettype, 'demand_max' as label, 'demand_max' as tooltip,  false as ismandatory, 
            false as isparent, false as iseditable, false as isautoupdate, false as hidden
FROM config_form_fields
WHERE  formname ilike 've_node%' group by formname,formtype, tabname),
  t2 AS
(SELECT distinct formname, formtype, tabname, 'demand_min', 'lyt_data_1', max(layoutorder)+2, 
            'numeric', 'text', 'demand_min', 'demand_min',  false, false, false, false, false
FROM config_form_fields
WHERE  formname ilike 've_node%' group by formname,formtype, tabname),
t3 AS
(SELECT distinct formname, formtype, tabname, 'demand_avg', 'lyt_data_1', max(layoutorder)+3, 
            'numeric', 'text', 'demand_avg', 'demand_avg',  false, false, false, false, false
FROM config_form_fields
WHERE  formname ilike 've_node%' group by formname,formtype, tabname),
t4 AS
(SELECT distinct formname, formtype, tabname, 'press_max', 'lyt_data_1', max(layoutorder)+4, 
            'numeric', 'text', 'press_max', 'press_max',  false, false, false, false, false
FROM config_form_fields
WHERE  formname ilike 've_node%' group by formname,formtype, tabname),
t5 AS
(SELECT distinct formname, formtype, tabname, 'press_min', 'lyt_data_1', max(layoutorder)+5, 
            'numeric', 'text', 'press_min', 'press_min',  false, false, false, false, false
FROM config_form_fields
WHERE  formname ilike 've_node%' group by formname,formtype, tabname),
t6 AS
(SELECT distinct formname, formtype, tabname, 'press_avg', 'lyt_data_1', max(layoutorder)+6, 
            'numeric', 'text', 'press_avg', 'press_avg',  false, false, false, false, false
FROM config_form_fields
WHERE  formname ilike 've_node%' group by formname,formtype, tabname),
t7 AS
(SELECT distinct formname, formtype, tabname, 'head_max', 'lyt_data_1', max(layoutorder)+7, 
            'numeric', 'text', 'head_max', 'head_max',  false, false, false, false, false
FROM config_form_fields
WHERE  formname ilike 've_node%' group by formname,formtype, tabname),
t8 AS
(SELECT distinct formname, formtype, tabname, 'head_min', 'lyt_data_1', max(layoutorder)+8, 
            'numeric', 'text', 'head_min', 'head_min',  false, false, false, false, false
FROM config_form_fields
WHERE  formname ilike 've_node%' group by formname,formtype, tabname),
t9 AS
(SELECT distinct formname, formtype, tabname, 'head_avg', 'lyt_data_1', max(layoutorder)+9, 
            'numeric', 'text', 'head_avg', 'head_avg',  false, false, false, false, false
FROM config_form_fields
WHERE  formname ilike 've_node%' group by formname,formtype, tabname),
t10 AS
(SELECT distinct formname, formtype, tabname, 'quality_max', 'lyt_data_1', max(layoutorder)+10, 
            'numeric', 'text', 'quality_max', 'quality_max',  false, false, false, false, false
FROM config_form_fields
WHERE  formname ilike 've_node%' group by formname,formtype, tabname),
t11 AS
(SELECT distinct formname, formtype, tabname, 'quality_min', 'lyt_data_1', max(layoutorder)+11, 
            'numeric', 'text', 'quality_min', 'quality_min',  false, false, false, false, false
FROM config_form_fields
WHERE  formname ilike 've_node%' group by formname,formtype, tabname),
t12 AS
(SELECT distinct formname, formtype, tabname, 'quality_avg', 'lyt_data_1', max(layoutorder)+12, 
            'numeric', 'text', 'quality_avg', 'quality_avg',  false, false, false, false, false
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


