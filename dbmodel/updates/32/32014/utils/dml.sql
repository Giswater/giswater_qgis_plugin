/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE audit_cat_function SET isdeprecated=true WHERE function_name='gw_trg_arc_orphannode_delete';

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2704, 'gw_fct_grafanalytics_engine', 'ws','function', 'Engine function of grafanalytics', 'role_om',FALSE, FALSE,FALSE);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2706, 'gw_fct_grafanalytics_minsector', 'ws','function', 'Function of grafanalytics for minimun sector', 'role_om',FALSE, FALSE,FALSE);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2708, 'gw_fct_grafanalytics_mincut', 'ws','function', 'Function of grafanalytics for mincut', 'role_om',FALSE, FALSE,FALSE);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2710, 'gw_fct_grafanalytics_mapzones', 'ws','function', '{"featureType":""}',
'[{"widgetname":"grafClass", "label":"Graf class:", "widgettype":"combo","datatype":"string","layoutname":"grl_option_parameters","layout_order":1,"value":"SECTORA"},
{"widgetname":"arc", "label":"Arcid:","widgettype":"combo","datatype":"string","comboIds":["PZONE","DQA","DMA","SECTOR"], 
"comboNames":["Pressure Zonification", "District Quality Areas", "District Metering Areas", "Inlet Sectorization"], "selectedId":!a",
 "layoutname":"grl_option_parameters","layout_order":2,"value":null},
{"widgetname":"node", "label":"Nodeid:","widgettype":"text","datatype":"string","layoutname":"grl_option_parameters","layout_order":3,"value":null}]',
'Function to analyze graf of network. Multiple analysis is avaliable' ,'role_om',FALSE, TRUE, TRUE);


UPDATE config_param_system SET isenabled=false, isdeprecated='true' WHERE parameter='gw_trg_arc_orphannode_delete';

UPDATE audit_cat_function SET isdeprecated=TRUE WHERE id='2306';
UPDATE audit_cat_function SET isdeprecated=TRUE WHERE id='2540';
UPDATE audit_cat_function SET isdeprecated=TRUE WHERE id='2322';

UPDATE node_type SET graf_delimiter = 'NONE';
UPDATE node_type SET graf_delimiter = 'MINSECTOR' WHERE type='VALVE';
UPDATE node_type SET graf_delimiter = 'PRESSZONE' WHERE type=NULL;
UPDATE node_type SET graf_delimiter = 'DQA' WHERE type=NULL;
UPDATE node_type SET graf_delimiter = 'DMA' WHERE type=NULL;
UPDATE node_type SET graf_delimiter = 'SECTOR' WHERE type IN ('TANK', 'WATERWELL', 'WTP', 'SOURCE');

DELETE FROM dattrib_type;

UPDATE sys_fprocess_cat SET fprocess_name='Inlet Sectorization' WHERE id=30;

INSERT INTO sys_fprocess_cat VALUES (44, 'District Quality Areas', 'om', '', 'ws');
INSERT INTO sys_fprocess_cat VALUES (45, 'District Metering Areas', 'om', '', 'ws');
INSERT INTO sys_fprocess_cat VALUES (46, 'Static pressure', 'om', '', 'ws');
INSERT INTO sys_fprocess_cat VALUES (47, 'Pipe capacity', 'om', '', 'ws');
INSERT INTO sys_fprocess_cat VALUES (48, 'Pressure Zonification', 'om', '', 'ws');

INSERT INTO macroexploitation VALUES (-1, 'Undefined marcroexploitation');
INSERT INTO exploitation VALUES (-1, 'Undefined exploitation',-1);
INSERT INTO dma VALUES (-1, 'Undefined dma');
INSERT INTO sector VALUES (-1, 'Undefined sector');
INSERT INTO cat_presszone VALUES (-1, 'Undefined presszone',-1);

-- 19/06/2019

INSERT INTO config_client_forms VALUES(19065, 'update_fields', 'utils', 'config_api_form_fields', 'layout_id', 5, FALSE);
INSERT INTO config_client_forms VALUES(19066, 'update_fields', 'utils', 'config_api_form_fields', 'layout_order', 6, FALSE);
INSERT INTO config_client_forms VALUES(19067, 'update_fields', 'utils', 'config_api_form_fields', 'layout_name', 32, FALSE);
