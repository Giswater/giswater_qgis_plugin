/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT setval('SCHEMA_NAME.config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);


INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, context, descript, sys_role_id, 
isdeprecated, istoolbox, alias, isparametric)
VALUES (2780, 'gw_fct_odbc2pg_hydro_filldata', 'utils', 'function', null, null, null,'Function to assist the odbc2pg process', 'role_om',
false, false, null, false) ON CONFLICT (id) DO NOTHING;

UPDATE audit_cat_function SET istoolbox=false, isparametric=false, alias=null WHERE id=2774;

--11/12/2019
INSERT INTO sys_fprocess_cat(id, fprocess_name, context, fprocess_i18n, project_type)
VALUES (106, 'Manage dxf file', 'Edit','Manage dxf file','utils')
ON CONFLICT (id) DO NOTHING;

UPDATE audit_cat_function SET return_type = '[{"widgetname":"grafClass", "label":"Graf class:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layout_order":1,"comboIds":["PRESSZONE","DQA","DMA","SECTOR"],
"comboNames":["Pressure Zonification (PRESSZONE)", "District Quality Areas (DQA) ", "District Metering Areas (DMA)", "Inlet Sectorization (SECTOR-HIGH / SECTOR-LOW)"], "selectedId":"DMA"}, 
{"widgetname":"exploitation", "label":"Exploitation id''s:","widgettype":"text","datatype":"json","layoutname":"grl_option_parameters","layout_order":2, "placeholder":"[1,2]", "value":""},
{"widgetname":"updateFeature", "label":"Update feature attributes:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":7, "value":"FALSE"},
{"widgetname":"updateMapZone", "label":"Update geom (if true fill one param below)","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":8, "value":"FALSE"},
{"widgetname":"buffer", "label":"1: Buffer for arc disolve:","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layout_order":9, "isMandatory":false, "placeholder":"10", "value":""},
{"widgetname":"concaveHullParam", "label":"2: Hull parameter for concave polygon:","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layout_order":10, "isMandatory":false, "placeholder":"0.9", "value":""}]' 
WHERE function_name ='gw_fct_grafanalytics_mapzones_advanced';


INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, context, descript, sys_role_id, 
isdeprecated, istoolbox, alias, isparametric)
VALUES (2782, 'gw_fct_rpt2pg_log', 'utils', 'function', null, null, null,'Function to create log for results on import epa files', 'role_epa',
false, false, null, false) ON CONFLICT (id) DO NOTHING;

-- 16/12/2019
UPDATE audit_cat_param_user SET dv_querytext = 'SELECT UNNEST(ARRAY (select (text_column::json->>''list_tables_name'')::text[] from temp_table where fprocesscat_id = 63 and user_name = current_user)) as id, 
UNNEST(ARRAY (select (text_column::json->>''list_layers_name'')::text[] FROM temp_table WHERE fprocesscat_id = 63 and user_name = current_user)) as idval ' WHERE id = 'cad_tools_base_layer_vdefault';


UPDATE config_api_form_fields set label='Unitary cost' where formname='infoplan' and column_id='initial_cost';
UPDATE config_api_form_fields set column_id='length', label='Length' where formname='infoplan' and column_id='other_cost';
UPDATE config_api_form_fields set column_id='total_cost', label='Total cost' where formname='infoplan' and column_id='intermediate_cost';
