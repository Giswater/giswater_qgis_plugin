/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = PARENT_SCHEMA, public, pg_catalog;

INSERT INTO config_param_system (parameter, value, descript, isenabled, project_type, datatype) VALUES
('plugin_campaign', '{"campaignManage":"TRUE"}', 'External plugin to use functionality of planified campaign/lots review/visits', FALSE, 'utils', 'json') ON CONFLICT (parameter) DO NOTHING;

INSERT INTO cm.cat_pschema (name) VALUES ('PARENT_SCHEMA');

UPDATE PARENT_SCHEMA.config_param_system
   SET value = '{"schemaName":"cm"}'
 WHERE parameter = 'admin_schema_cm';

UPDATE cm.sys_version AS dst
   SET
     giswater  = src.giswater,
     "language" = src."language",
     epsg      = src.epsg
  FROM (
    SELECT giswater, "language", epsg
      FROM PARENT_SCHEMA.sys_version
     ORDER BY date DESC
     LIMIT 1
  ) AS src;

-- topological trace
INSERT INTO sys_message
(id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4444, 'There is no topology from the selected node.', 'The node is isolated or it does not exist in the selected lot_id.', 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) 
VALUES(3542, 'gw_fct_cm_topological_trace', 'ws', 'function', 'json', 'json', 'Function to visualize the topology of the lot from a SELECTED NODE.

The available lots for the analysis are the ones that take part into de SELECTED CAMPAIGN.', 'role_om', NULL, 'cm', NULL);

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device) VALUES(3542, '[CM] Visualize Lot topology', '{"featureType":[]}'::json, '[
  {
    "widgetname": "lotId",
    "label": "Lot ID:",
    "widgettype": "combo",
    "datatype": "text",
    "tooltip": "Choose a Lot which status is ASSIGNED, IN PROGRESS or EXECUTED",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
    "dvQueryText": "SELECT a.lot_id AS id, concat(a.name, '' - '', b.idval, '''') AS idval FROM cm.om_campaign_lot a JOIN cm.om_campaign c USING (campaign_id) JOIN cm.sys_typevalue b ON a.status = b.id::int WHERE b.typevalue = ''lot_status'' AND a.status IN (3,4,6) AND (EXISTS (SELECT 1 FROM cm.cat_user cu JOIN cm.cat_team ct ON ct.team_id = cu.team_id JOIN cm.cat_organization co ON co.organization_id = ct.organization_id WHERE cu.username = current_user) OR c.organization_id IN (SELECT co.organization_id FROM cm.cat_user cu JOIN cm.cat_team ct ON ct.team_id = cu.team_id JOIN cm.cat_organization co ON co.organization_id = ct.organization_id WHERE cu.username = current_user)) ORDER BY a.status, a.name ASC",
    "selectedId": null
  },
  {
    "widgetname": "nodeId",
    "widgettype": "text",
    "datatype": "integer",
    "label": "Node id:",
    "layoutname": "grl_option_parameters",
    "isMandatory": true,
    "layoutorder": 5
  }
]'::json, NULL, true, '{4}');

INSERT INTO sys_function
(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias)
VALUES(3540, 'gw_fct_cm_build_topology', 'ws', 'function', 'json', 'json', 'Function to build or update the topology of a Lot. 


Only available for those Lots that have state ASSIGNED, IN PROGRESS or EXECUTED.', 'role_om', NULL, 'cm', NULL);

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device) VALUES(3540, '[CM] Reconnect Lot topology', '{"featureType":[]}'::json, '[
  {
    "widgetname": "lotId",
    "label": "Lot ID:",
    "widgettype": "combo",
    "datatype": "text",
    "tooltip": "Choose a Lot ASSIGNED, IN PROGRESS or EXECUTED",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
    "dvQueryText": "SELECT a.lot_id AS id, concat(a.name, '' - '', b.idval, '''') AS idval FROM cm.om_campaign_lot a JOIN cm.om_campaign c USING (campaign_id) JOIN cm.sys_typevalue b ON a.status = b.id::int WHERE b.typevalue = ''lot_status'' AND a.status IN (3,4,6) AND (EXISTS (SELECT 1 FROM cm.cat_user cu JOIN cm.cat_team ct ON ct.team_id = cu.team_id JOIN cm.cat_organization co ON co.organization_id = ct.organization_id WHERE cu.username = current_user) OR c.organization_id IN (SELECT co.organization_id FROM cm.cat_user cu JOIN cm.cat_team ct ON ct.team_id = cu.team_id JOIN cm.cat_organization co ON co.organization_id = ct.organization_id WHERE cu.username = current_user)) ORDER BY a.status, a.name ASC",
    "selectedId": null
  },
  {
      "widgetname": "updateType",
    "widgettype": "combo",
    "label": "Type of process:",
    "comboIds": [1,2],
    "datatype": "text",
    "comboNames": [
      "Update topology (for all arcs)",
      "Build topology (for arcs without topology)"
    ],
    "layoutname": "grl_option_parameters",
    "isMandatory": true,
    "layoutorder": 5
  }
]'::json, NULL, true, '{4}');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3544, 'gw_fct_cm_check_node_orphan', 'ws', 'function', 'json', 'json', 'Function to show orphan nodes of the selected lot. That is: the nodes that are neither node_1 nor node_2 or any arc.', 'role_om', NULL, 'cm', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3546, 'gw_fct_cm_check_node_duplicated', 'ws', 'function', 'json', 'json', 'Funcion to show duplicated nodes of the selected lot 3.

The tolerance from which nodes are detected is 10 cm.', 'role_om', NULL, 'cm', NULL);

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3548, 'gw_fct_cm_check_arc_duplicated', 'ws', 'function', 'json', 'json', 'Function to show duplicated arcs in the lot.', 'role_om', NULL, 'cm', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3550, 'gw_fct_cm_check_node_document', 'ws', 'function', 'json', 'json', 'Function to show the nodes that do not have related documents. 

Specific node type can be excluded from the search.', 'role_om', NULL, 'cm', NULL);

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(-3, 'There are ', NULL, 0, true, 'utils', 'core', 'UI') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(-2, 'There is ', NULL, 0, true, 'utils', 'core', 'UI') ON CONFLICT (id) DO NOTHING;