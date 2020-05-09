/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--30/10/2019
UPDATE audit_cat_function SET return_type='[{"widgetname":"grafClass", "label":"Graf class:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layout_order":1,"comboIds":["PRESSZONE","DQA","DMA","SECTOR"],
"comboNames":["Pressure Zonification (PRESSZONE)", "District Quality Areas (DQA) ", "District Metering Areas (DMA)", "Inlet Sectorization (SECTOR-HIGH / SECTOR-LOW)"], "selectedId":"DMA"}, 
{"widgetname":"exploitation", "label":"Exploitation id''s:","widgettype":"text","datatype":"json","layoutname":"grl_option_parameters","layout_order":2, "placeholder":"[1,2]", "value":""},
{"widgetname":"updateFeature", "label":"Update feature attributes:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":7, "value":"FALSE"},
{"widgetname":"updateMapZone", "label":"Update mapzone geometry:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":8, "value":"FALSE"},
{"widgetname":"concaveHullParam", "label":"Concave hull (mapzone geometry):","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layout_order":9, "ismandatory":false, "placeholder":"0.9", "value":""}]'
WHERE id=2710;

SELECT setval('config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);
INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
VALUES ('crm_dailyscript_folderpath','c:\\gis\\dailyscript','text', 'crm', 'Folder to store scripts to execute daily')
ON CONFLICT (parameter) DO NOTHING;

--31/10/2019
UPDATE audit_cat_table SET notify_action = replace(notify_action::text,'refresh_canvas','indexing_spatial_layer')::json WHERE 
notify_action::text ilike '%refresh_canvas%';


INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2762, 'gw_fct_odbc2pg_main', 'utils', 'function', 'Main function to return with values from ODBC systems','role_om',FALSE, FALSE,FALSE)
ON CONFLICT (id) DO NOTHING;


INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2764, 'gw_fct_odbc2pg_check_data', 'utils', 'function', 'Function to check data when returning from ODBC systems','role_om',FALSE, FALSE,FALSE)
ON CONFLICT (id) DO NOTHING;


--05/11/2019
UPDATE audit_cat_param_user SET vdefault = replace (vdefault,']', ',18]')
WHERE id='qgis_toolbar_hidebuttons';

UPDATE config_param_user SET value = replace (value,']', ',18]')
WHERE parameter='qgis_toolbar_hidebuttons';
