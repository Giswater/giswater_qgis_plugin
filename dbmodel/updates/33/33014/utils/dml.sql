/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--7/11/2019
UPDATE config_param_system SET parameter='crm_daily_script_folderpath' WHERE parameter='crm_dailyscript_folderpath';

SELECT setval('config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);
INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
VALUES ('python_folderpath','c:/program files/qgis 3.4/apps/Python37','text', 'crm', 'Folder to path for python')
ON CONFLICT (parameter) DO NOTHING;


UPDATE audit_cat_function SET function_name='gw_trg_cat_feature'
WHERE id=2758;


--12/11/2019
UPDATE audit_cat_param_user SET ismandatory=true WHERE formname = 'epaoptions';


INSERT INTO audit_cat_table(id, context, description, sys_role_id, sys_criticity, qgis_criticity,  isdeprecated)
    VALUES ('ext_cat_raster', 'external catalog', 'Catalog of rasters', 'role_edit', 0, 0, false)
    ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_table(id, context, description, sys_role_id, sys_criticity, qgis_criticity,  isdeprecated)
    VALUES ('ext_raster_dem', 'external table', 'Table to store raster DEM', 'role_edit', 0, 0, false)
    ON CONFLICT (id) DO NOTHING;


INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role_id, isdeprecated, istoolbox, alias, isparametric)
VALUES (2772, 'gw_fct_grafanalytics_flowtrace', 'utils','function', '{"featureType":[]}',
'[{"widgetname":"grafClass", "label":"Graf class:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layout_order":1,"comboIds":["DISCONNECTEDARCS","CONNECTEDARCS"],
"comboNames":["DISCONNECTED ARCS","CONNECTED ARCS"], "selectedId":"CONNECTEDARCS"}, 
{"widgetname":"nodeId", "label":"Node id:","widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layout_order":2, "value":""}]',
'Function to analyze flow trace of network from one node. Arcs connected and arcs disconnected must be analyzed', 'role_om',FALSE, TRUE, 'Flow trace analytics', TRUE)
ON conflict (id) DO NOTHING;


--15/11/2019
INSERT INTO sys_fprocess_cat VALUES (93,'Flowtrace disconnected arcs', 'edit', 'Flowtrace disconnected arcs','ws') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_fprocess_cat VALUES (94,'Flowtrace connected arcs', 'edit', 'Flowtrace connected arcs','ws') ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_table(id, context, description, sys_role_id, sys_criticity, qgis_criticity,  isdeprecated)
    VALUES ('temp_anlgraf', 'temporal table', 'Temporal tabl to store the grafanalytics process', 'role_basic', 0, 0, false)
    ON CONFLICT (id) DO NOTHING;

--16/11/2019
UPDATE audit_cat_table SET isdeprecated = TRUE WHERE id='anl_graf';

UPDATE sys_feature_type SET net_category=2 WHERE id='ELEMENT';
UPDATE sys_feature_type SET net_category=3 WHERE id='LINK';
UPDATE sys_feature_type SET net_category=4 WHERE id='VNODE';

INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
VALUES ('inp_fast_builddup',
'{"nullElevBuffer":100, "tank":{"distVirtualReservoir":1}, "pressGroup":{"status":"ACTIVE", "forceStatus":"ACTIVE"}, "pumpStation":{"status":"CLOSED", "forceStatus":"CLOSED"},	"PRV":{"status":"ACTIVE", "forceStatus":"ACTIVE"}}'
,'json', 'epa', 'Parameters for buildup a fast EPA model')
ON CONFLICT (parameter) DO NOTHING;


INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, alias, isparametric)
VALUES (2774, 'gw_fct_go2epa_fast_buildup', 'ws','function', 'Function to generate a fast buildup of EPANET model assuming simplifications from inp_fast_builddup stored on config_param_system', 
'role_epa',FALSE, TRUE, 'Flow trace analytics', TRUE)
ON conflict (id) DO NOTHING;

