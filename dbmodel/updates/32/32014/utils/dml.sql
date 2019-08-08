/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE audit_cat_function SET return_type=replace (return_type, ']', ',{"widgetname":"saveOnDatabase", "label":"Save on database:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":9, "value":"FALSE"}]') where return_type is not null;

UPDATE audit_cat_function SET isdeprecated=true WHERE function_name='gw_trg_arc_orphannode_delete';

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, alias, isparametric)
VALUES (2704, 'gw_fct_grafanalytics_engine', 'ws','function', 'Engine function of grafanalytics', 'role_om', TRUE, FALSE, null, FALSE); -- this function was born deprecated!!!

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role_id, isdeprecated, istoolbox, alias, isparametric)
VALUES (2706, 'gw_fct_grafanalytics_minsector', 'ws','function', '{"featureType":""}', 
'[{"widgetname":"exploitation", "label":"Exploitation id''s:","widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layout_order":1, "placeholder":"[1,2]", "value":""},
{"widgetname":"updateFeature", "label":"Update feature attributes:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":7, "value":"FALSE"},
{"widgetname":"updateMapZone", "label":"Update mapzone geometry:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":8, "value":"FALSE"},
{"widgetname":"concaveHullParam", "label":"ConcaveHull factor (for update geometry):","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layout_order":9, "placeholder":"0.9", "value":"FALSE}]',
'Function of grafanalytics for minimun sector', 'role_om',FALSE, TRUE, 'Minsector analysis', TRUE);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2708, 'gw_fct_grafanalytics_mincut', 'ws','function', 'Function of grafanalytics for mincut', 'role_om',FALSE, FALSE, FALSE);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role_id, isdeprecated, istoolbox, alias, isparametric)
VALUES (2710, 'gw_fct_grafanalytics_mapzones', 'ws','function', '{"featureType":""}',
'[{"widgetname":"grafClass", "label":"Graf class:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layout_order":1,"comboIds":["PRESSZONE","DQA","DMA","SECTOR"],
"comboNames":["Pressure Zonification (PRESSZONE)", "District Quality Areas (DQA) ", "District Metering Areas (DMA)", "Inlet Sectorization (SECTOR-HIGH / SECTOR-LOW)"], "selectedId":"PRESSZONE"}, 
{"widgetname":"exploitation", "label":"Exploitation id''s:","widgettype":"text","datatype":"json","layoutname":"grl_option_parameters","layout_order":2, "placeholder":"[1,2]", "value":""},
{"widgetname":"updateFeature", "label":"Update feature attributes:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":7, "value":"FALSE"},
{"widgetname":"updateMapZone", "label":"Update mapzone geometry:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":8, "value":"FALSE"},
{"widgetname":"concaveHullParam", "label":"Concave hull parameter (in case of update geometry):","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layout_order":9, "placeholder":"0.9", "value":"FALSE}]',
'Function to analyze graf of network. Multiple analysis is avaliable. Dynamic analisys to sectorize network using the flow traceability function. 
Before work with this funcion it is mandatory to configurate the system:
- field nodeparent on [dma, sector, cat_presszone and dqa] tables
- field to_arc on [inp_shortpipe, inp_inlet, inp_reservoir, inp_valve, inp_pump] tables' ,'role_om',FALSE, TRUE, 'Mapzones analysis', TRUE);

INSERT INTO audit_cat_function 
(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role_id, isdeprecated, istoolbox, alias, isparametric)
VALUES 
(2712, 'gw_fct_grafanalytics_mincutzones', 'ws','function', '{"featureType":""}',
'[{"widgetname":"exploitation", "label":"Exploitation id''s:","widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layout_order":1, "placeholder":"[1,2]", "value":""},{"widgetname":"updateFeature", "label":"Upsert feature attributes:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":9, "value":"FALSE"}]',
'Function of grafanalytics for massive mincutzones identification. Multiple analysis is avaliable. It works applying massive mincut for the whole network of selected exploitation. It can take a lot of time. Be patient!!!'
,'role_om',FALSE, TRUE, 'Massive mincut analysis', TRUE);

UPDATE config_param_system SET isenabled=false, isdeprecated='true' WHERE parameter='gw_trg_arc_orphannode_delete';

UPDATE audit_cat_function SET isdeprecated=TRUE WHERE id='2306';
UPDATE audit_cat_function SET isdeprecated=TRUE WHERE id='2540';
UPDATE audit_cat_function SET isdeprecated=TRUE WHERE id='2322';

DELETE FROM dattrib_type;

UPDATE sys_fprocess_cat SET fprocess_name='Inlet Sectorization' WHERE id=30;

UPDATE sys_fprocess_cat SET fprocess_name='Mincutzones identification' WHERE id=29;


INSERT INTO sys_fprocess_cat VALUES (44, 'District Quality Areas', 'om', '', 'ws');
INSERT INTO sys_fprocess_cat VALUES (45, 'District Metering Areas', 'om', '', 'ws');
INSERT INTO sys_fprocess_cat VALUES (46, 'Pressure Zonification', 'om', '', 'ws');
INSERT INTO sys_fprocess_cat VALUES (47, 'Static pressure value', 'om', '', 'ws');

-- 19/06/2019

INSERT INTO config_client_forms VALUES(19065, 'update_fields', 'utils', 'config_api_form_fields', 'layout_id', 5, FALSE);
INSERT INTO config_client_forms VALUES(19066, 'update_fields', 'utils', 'config_api_form_fields', 'layout_order', 6, FALSE);
INSERT INTO config_client_forms VALUES(19067, 'update_fields', 'utils', 'config_api_form_fields', 'layout_name', 32, FALSE);

-- deprecate variables due new approach of grafanalytics faster an simple
UPDATE audit_cat_param_user SET isdeprecated = true WHERE id='om_mincut_analysis_dminsector';
UPDATE audit_cat_param_user SET isdeprecated = true WHERE id='om_mincut_analysis_pipehazard';
UPDATE audit_cat_param_user SET isdeprecated = true WHERE id='om_mincut_analysis_dinletsector';


--27/06/2019
UPDATE audit_cat_function SET isdeprecated=true WHERE function_name = 'gw_fct_node_replace';

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2714, 'gw_fct_feature_replace', 'utils', 'function', 
'Replace one node, connec or gully on service for another one, copying all attributes, setting old one on obsolete and reconnecting other features with the new one',
'role_edit', false, false,false);