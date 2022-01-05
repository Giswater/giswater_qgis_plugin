/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/12/29
INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, 
return_type, descript, sys_role, sample_query, source)
VALUES (3118, 'gw_fct_create_dscenario_from_toc', 'utils', 'function', 'json', 
'json', 'Function to create dscenario getting values from some layer of ToC, including inp layers of EPA group', 'role_epa', null, null) ON CONFLICT (id) DO NOTHING;

DELETE FROM config_toolbox WHERE id = 3118;
INSERT INTO config_toolbox VALUES (3118, 'Create Dscenario with values from ToC','{"featureType":["node", "arc"]}',
'[{"widgetname":"name", "label":"Scenario name:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"value":""},
  {"widgetname":"type", "label":"Scenario type:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":2, "dvQueryText":"SELECT id, idval FROM inp_typevalue where typevalue = ''inp_typevalue_dscenario''", "selectedId":""},
{"widgetname":"exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":4, "dvQueryText":"SELECT expl_id as id, name as idval FROM v_edit_exploitation", "selectedId":""}]' ,
  NULL,TRUE)  ON CONFLICT (id) DO NOTHING;


INSERT INTO ws_sample.sys_table (id, descript, sys_role, context, alias, orderby, source) VALUES('v_edit_cat_dwf_dscenario', 'Table to manage scenario for dwf', 'role_epa', '{"level_1":"EPA", "level_2":"CATALOG"}','Hydrology catalog',1,'core');
INSERT INTO ws_sample.sys_table (id, descript, sys_role, context, alias, orderby, source) VALUES('v_edit_cat_hydrology', 'Table to manage scenario for hydrology','role_epa', '{"level_1":"EPA", "level_2":"CATALOG"}','DWF catalog', 2 ,'core');