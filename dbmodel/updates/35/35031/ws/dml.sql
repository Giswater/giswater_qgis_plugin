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