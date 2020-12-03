/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--31/10/2019
UPDATE audit_cat_function SET istoolbox=FALSE, sys_role_id ='role_om', alias=null, input_params=null, return_type=null
WHERE id=2710;

UPDATE audit_cat_table SET sys_role_id ='role_om' WHERE id='anl_graf';


-- 5/11/2019
INSERT INTO audit_cat_param_user(id, formname, description, sys_role_id, label, isenabled, layout_id, layout_order, 
project_type, isparent, isautoupdate, datatype, widgettype,ismandatory, isdeprecated)
VALUES ('qgis_qml_pointlayer_path','config','File path of qml point temporal layers loaded as results on ToC using toolbox functions',
'role_om', 'Point QML file (temporal layer):', true, 2,13,'ws',false,false,'text','text',false,false)
ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_param_user(id, formname, description, sys_role_id, label, isenabled, layout_id, layout_order, 
project_type, isparent, isautoupdate, datatype, widgettype,ismandatory, isdeprecated)
VALUES ('qgis_qml_linelayer_path','config','File path of qml line temporal layers loaded as results on ToC using toolbox functions',
'role_om', 'Line QML file (temporal layer):', true, 2,14,'ws',false,false,'text','text',false,false)
ON conflict (id) DO NOTHING;

INSERT INTO audit_cat_param_user(id, formname, description, sys_role_id, label, isenabled, layout_id, layout_order, 
project_type, isparent, isautoupdate, datatype, widgettype,ismandatory, isdeprecated)
VALUES ('qgis_qml_polygonlayer_path','config','File path of qml polygon temporal layers loaded as results on ToC using toolbox functions',
'role_om', 'Polygon QML file (temporal layer):', true, 2,15,'ws',false,false,'text','text',false,false)
ON conflict (id) DO NOTHING;


INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role_id, isdeprecated, istoolbox, alias, isparametric)
VALUES (2766, 'gw_fct_grafanalytics_mapzones_basic', 'ws','function', '{"featureType":[]}',
'[{"widgetname":"grafClass", "label":"Graf class:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layout_order":1,"comboIds":["PRESSZONE","DQA","DMA","SECTOR"],
"comboNames":["Pressure Zonification (PRESSZONE)", "District Quality Areas (DQA) ", "District Metering Areas (DMA)", "Inlet Sectorization (SECTOR-HIGH / SECTOR-LOW)"], "selectedId":"DMA"}, 
{"widgetname":"exploitation", "label":"Exploitation id''s:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layout_order":2, 
"dvQueryText":"select expl_id as id, name as idval from exploitation where active is not false order by name", "selectedId":"1"},
{"widgetname":"updateFeature", "label":"Update feature attributes:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":7, "value":"FALSE"}]',
'Function to analyze graf of network. Multiple analysis is avaliable. On basic mode only one exploitation is avaliable and update mapzones geometry is disabled. Dynamic analisys to sectorize network using the flow traceability function. 
Before work with this funcion it is mandatory to configurate field graf_delimiter on node_type and field grafconfig on [dma, sector, cat_presszone and dqa] tables'
,'role_om',FALSE, TRUE, 'Mapzones analysis (basic)', TRUE)
ON conflict (id) DO NOTHING;


INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role_id, isdeprecated, istoolbox, alias, isparametric)
VALUES (2768, 'gw_fct_grafanalytics_mapzones_advanced', 'ws','function', '{"featureType":[]}',
'[{"widgetname":"grafClass", "label":"Graf class:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layout_order":1,"comboIds":["PRESSZONE","DQA","DMA","SECTOR"],
"comboNames":["Pressure Zonification (PRESSZONE)", "District Quality Areas (DQA) ", "District Metering Areas (DMA)", "Inlet Sectorization (SECTOR-HIGH / SECTOR-LOW)"], "selectedId":"DMA"}, 
{"widgetname":"exploitation", "label":"Exploitation id''s:","widgettype":"text","datatype":"json","layoutname":"grl_option_parameters","layout_order":2, "placeholder":"[1,2]", "value":""},
{"widgetname":"updateFeature", "label":"Update feature attributes:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":7, "value":"FALSE"},
{"widgetname":"updateMapZone", "label":"Update mapzone geometry:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":8, "value":"FALSE"},
{"widgetname":"concaveHullParam", "label":"Concave hull (mapzone geometry):","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layout_order":9, "ismandatory":false, "placeholder":"0.9", "value":""}]',
'Function to analyze graf of network. Multiple analysis is avaliable.  On advanced mode multi exploitation is avaliable and update mapzones geometry is enabled. Dynamic analisys to sectorize network using the flow traceability function. 
Before work with this funcion it is mandatory to configurate field graf_delimiter on node_type and field grafconfig on [dma, sector, cat_presszone and dqa] tables'
,'role_master',FALSE, TRUE, 'Mapzones analysis (advanced)', TRUE)
ON conflict (id) DO NOTHING;

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2770, 'gw_api_gettoolbox', 'utils','api function', 'Get toolbox', 'role_master',FALSE, FALSE, FALSE)
ON conflict (id) DO NOTHING;


INSERT INTO sys_fprocess_cat VALUES (90,'Arcs with dma=0', 'om', 'Arcs with dma=0','ws') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_fprocess_cat VALUES (91,'Nodes with dma=0', 'om', 'Nodes with dma=0','ws') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_fprocess_cat VALUES (92,'Connecs with dma=0', 'om', 'Connecs with dma=0','ws') ON CONFLICT (id) DO NOTHING;


