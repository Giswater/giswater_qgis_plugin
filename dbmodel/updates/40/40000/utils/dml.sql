/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3326, 'gw_fct_graphanalytics_arrangenetwork', 'utils', 'function', NULL, 'json', 'Function to arrenge the network in graphanalytics', 'role_basic', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3328, 'gw_fct_graphanalytics_initnetwork', 'utils', 'function', 'json', 'json', 'Function to init the network in graphanalytics', 'role_basic', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3330, 'gw_fct_graphanalytics_temptables', 'utils', 'function', 'json', 'json', 'Function to create temporal tables for graphanalytics', 'role_basic', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3332, 'gw_fct_graphanalytics_settempgeom', 'utils', 'function', 'json', 'json', 'Function to update the geometry of the mapzones in the temp_minsector table for graphanalytics', 'role_basic', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3334, 'gw_fct_graphanalytics_macrominsector', 'utils', 'function', 'json', 'json', 'Function to create macrominsectors', 'role_master', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

-- update graphanalytic_minsector description to include explotation id description
UPDATE sys_function SET descript='Dynamic analisys to sectorize network using the flow traceability function and establish Minimum Sectors. 
Before start you need to configure:
- Field graph_delimiter on [cat_feature_node] table to establish which elements will be used to sectorize. 
- Enable status for minsector on utils_graphanalytics_status variable from [config_param_system] table.

In explotation id you can use ''-9'' to select all explotations, or a list of explotations separated by comma.'
WHERE id=2706;

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device)
VALUES(3334, 'Macrominsector analysis', '{"featureType":[]}'::json,
'[{"widgetname":"commitChanges", "label":"Commit changes:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":1, "value":"", "tooltip": "Commit changes"}]'::json,
NULL, true, '{4}');

INSERT INTO sys_param_user VALUES ('utils_psector_strategy', 'config', 'Psector strategy', 'role_master', null, 'Value for psector_strategy', null, null, TRUE,
20, 'utils', FALSE, null, null, null, FALSE, 'text', 'check', TRUE, null, 'true', 'lyt_other', TRUE, null, null, null, null, 'core') ON CONFLICT (id) DO NOTHING;

--24/09/2024
INSERT INTO sys_function (id,function_name,project_type,function_type,input_params,return_type,descript,sys_role,"source")
VALUES (3336,'gw_fct_getgraphinundation','utils','function',NULL,'json','Retrieves GeoJSON data representing the inundation (flooding) graph for a specific area','role_edit','core');