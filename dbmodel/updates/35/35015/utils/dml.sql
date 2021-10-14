/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/10/14
INSERT INTO sys_function VALUES (3080, 'gw_fct_repair_node_duplicated', 'utils', 'function', 'json', 'json' , 'Function to repair nodes duplicated', 'role_edit')
ON CONFLICT (id) DO UPDATE SET function_name = 'gw_fct_repair_node_duplicated', project_type ='utils', function_type='function', input_params='json', return_type='json';

INSERT INTO config_toolbox(id, alias, functionparams, inputparams, observ, active)
VALUES (3080,'Repair nodes duplicated', '{"featureType":[]}', 
'[{"widgetname":"node", "label":"Node:", "widgettype":"text", "datatype":"text", "layoutname":"grl_option_parameters","layoutorder":1, "value":null},
  {"widgetname":"action", "label":"Action:", "widgettype":"combo", "datatype":"text", "comboIds":["DELETE", "DOWNGRADE", "MOVE-LOSE-TOPO", "MOVE-KEEP-TOPO", "MOVE-GET-TOPO"], "comboNames":["DELETE", "DOWNGRADE", "MOVE & LOSE TOPOLOGY", "MOVE & KEEP TOPOLOGY", "MOVE & GET TOPOLOGY"], "layoutname":"grl_option_parameters","layoutorder":2, "selectedId":null},
  {"widgetname":"targetNode", "label":"Target node (transfer topology):", "label": "Value for target node is optative. If null system will try to check closest node.", "widgettype":"text", "datatype":"text", "layoutname":"grl_option_parameters","layoutorder":3, "value":null},
  {"widgetname":"dx", "label":"Movement on X axis (m):", "tooltip": "Node displacement on X axis (m)", "widgettype":"text", "datatype":"float", "layoutname":"grl_option_parameters","layoutorder":4, "value":null},
  {"widgetname":"dy", "label":"Movement on Y axis (m):", "tooltip": "Node displacement on Y axis (m)", "widgettype":"text", "datatype":"float", "layoutname":"grl_option_parameters","layoutorder":5, "value":null}
  ]', NULL, TRUE) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess VALUES (405, 'Repair nodes duplicated', 'utils')
ON CONFLICT (fid) DO NOTHING;

UPDATE sys_function SET sys_role = 'role_epa' WHERE id  = 3032;