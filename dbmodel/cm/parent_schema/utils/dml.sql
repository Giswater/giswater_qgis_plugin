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

The available lots for the analysis are the ones that take part into de SELECTED CAMPAIGN.', 'role_om', NULL, 'core', NULL);

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device) VALUES(3542, '[CM] Visualize Lot topology', '{"featureType":[]}'::json, '[
  {
    "widgetname": "lotId",
    "label": "Lot ID:",
    "widgettype": "combo",
    "datatype": "text",
    "tooltip": "Choose a Lot which status is ASSIGNED, IN PROGRESS or EXECUTED",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
    "dvQueryText": "select a.lot_id as id, concat(a.name, '' - '', b.idval, '''') as idval from cm.om_campaign_lot a join cm.sys_typevalue b on a.status=b.id::int join cm.selector_campaign c using (campaign_id) where b.typevalue = ''lot_status'' and a.status in (3,4,6) and c.cur_user = current_user order by a.status, a.name asc",
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


Only available for those Lots that have state ASSIGNED, IN PROGRESS or EXECUTED.', 'role_om', NULL, 'core', NULL);

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device) VALUES(3540, '[CM] Reconnect Lot topology', '{"featureType":[]}'::json, '[
  {
    "widgetname": "lotId",
    "label": "Lot ID:",
    "widgettype": "combo",
    "datatype": "text",
    "tooltip": "Choose a Lot ASSIGNED, IN PROGRESS or EXECUTED",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
    "dvQueryText": "select a.lot_id as id, concat(a.name, '' - '', b.idval, '''') as idval from cm.om_campaign_lot a join cm.sys_typevalue b on a.status=b.id::int where b.typevalue = ''lot_status'' and a.status in (3,4,6) order by a.status, a.name asc",
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