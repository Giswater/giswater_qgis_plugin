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
VALUES(4576, 'There is no topology from the selected node.', 'The node is isolated or it does not exist in the selected lot_id.', 0, true, 'utils', 'core', 'AUDIT');

-- setarcdivide_massive Set mode audit messages (fid 2114)
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4578, 'Node %node_id% has been moved to arc %arc_id%.', NULL, 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4580, 'Arc %arc_id% has been divided.', NULL, 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4582, 'Arcs %arc_id1% and %arc_id2% have been created (replacing arc %arc_id%).', NULL, 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4584, 'There are %v_count% orphan nodes.', NULL, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) 
VALUES(3542, 'gw_fct_cm_topological_trace', 'ws', 'function', 'json', 'json', 'Function to visualize the topology of the lot from a SELECTED NODE.

The available lots for the analysis are the ones that take part into de SELECTED CAMPAIGN.', 'role_om', NULL, 'cm', NULL);

INSERT INTO sys_function
(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias)
VALUES(3540, 'gw_fct_cm_build_topology', 'ws', 'function', 'json', 'json', 'Function to build or update the topology of a Lot. 


Only available for those Lots that have state ASSIGNED, IN PROGRESS or EXECUTED.', 'role_om', NULL, 'cm', NULL);

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3544, 'gw_fct_cm_check_node_orphan', 'ws', 'function', 'json', 'json', 'Function to show orphan nodes of the selected lot. That is: the nodes that are neither node_1 nor node_2 or any arc.', 'role_om', NULL, 'cm', NULL);


INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3546, 'gw_fct_cm_check_node_duplicated', 'ws', 'function', 'json', 'json', 'Funcion to show duplicated nodes of the selected lot 3.

The tolerance from which nodes are detected is 10 cm.', 'role_om', NULL, 'cm', NULL);

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3548, 'gw_fct_cm_check_arc_duplicated', 'ws', 'function', 'json', 'json', 'Function to show duplicated arcs in the lot.', 'role_om', NULL, 'cm', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3550, 'gw_fct_cm_check_node_document', 'ws', 'function', 'json', 'json', 'Function to show the nodes that do not have related documents. 

Specific node type can be excluded from the search.', 'role_om', NULL, 'cm', NULL);

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(-3, 'There are ', NULL, 0, true, 'utils', 'core', 'UI') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(-2, 'There is ', NULL, 0, true, 'utils', 'core', 'UI') ON CONFLICT (id) DO NOTHING;


INSERT INTO sys_function
(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias)
VALUES(3552, 'gw_fct_cm_setarcdivide_massive', 'ws', 'function', 'json', 'json', 'Function to set the arc divide of a node. 


Only available for those Lots that have state ASSIGNED, IN PROGRESS or EXECUTED.', 'role_om', NULL, 'cm', 'SETARCDIVIDE_MASSIVE');


INSERT INTO config_function
(id, function_name, "style", layermanager, actions)
VALUES(3552, 'gw_fct_cm_setarcdivide_massive', '{
  "style": {
    "point": {
      "style": "categorized",
      "field": "descript",
      "transparency": 0.5,
      "width": 2.5,
      "values": [
        {
          "id": "Node T candidate",
          "color": [
            0,
            250,
            255
          ]
        },
        {
          "id": "Orphan node",
          "color": [
            0,
            95,
            253
          ]
        }
      ]
    }
  }
}'::json, NULL, NULL);

INSERT INTO config_toolbox
(id, alias, functionparams, inputparams, observ, active, device)
VALUES(3552, '6- [CM] Massive arc divide', '{"featureType":[]}'::json, '[{
    "widgetname": "campaignId",
    "label": "Campaign Id:",
    "widgettype": "combo",
    "isparent": "true",
    "datatype": "text",
    "tooltip": "Choose a campaign",
    "layoutname": "grl_option_parameters",
    "layoutorder": 1,
    "dvQueryText": "SELECT c.campaign_id as id, name as idval FROM cm.om_campaign c JOIN (SELECT t.organization_id, bool_or(o.orgname =  ''OWNER'') AS is_admin FROM cm.cat_user u JOIN cm.cat_team t ON t.team_id = u.team_id JOIN cm.cat_organization o ON o.organization_id = t.organization_id WHERE u.username = current_user GROUP BY t.organization_id) ctx ON (c.organization_id = ctx.organization_id OR ctx.is_admin) WHERE exists (select 1 from cm.om_campaign_lot l where status in (3,4,6) and l.campaign_id = c.campaign_id)"
  },
  {
    "widgetname": "lotId",
    "label": "Lot Id:",
    "widgettype": "combo",
    "parentname": "campaignId",
    "datatype": "text",
    "tooltip": "Choose a lot",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
    "dvQueryText": "select null as id, '''' as idval union all select lot_id as id, concat(a.name, '' - '', b.idval, '''') AS idval FROM cm.om_campaign_lot a JOIN cm.sys_typevalue b ON a.status = b.id::int WHERE b.typevalue = ''lot_status'' and status in (3,4,6)",
    "filterquery": "select null as id, '''' as idval union all select lot_id as id, concat(a.name, '' - '', b.idval, '''') AS idval FROM cm.om_campaign_lot a JOIN cm.sys_typevalue b ON a.status = b.id::int WHERE b.typevalue = ''lot_status'' and status in (3,4,6) and a.campaign_id = {parent_value}"
  },
  {
    "widgetname": "mode",
    "label": "Mode:",
    "widgettype": "combo",
    "datatype": "text",
    "tooltip": "Choose the mode of the process execution",
    "layoutname": "grl_option_parameters",
    "layoutorder": 3,
    "dvQueryText": "SELECT ''CHECK'' AS id, ''CHECK'' AS idval UNION ALL SELECT ''SET'' AS id, ''SET'' AS idval",
    "selectedId": "1"
  }
]'::json, NULL, true, '{4}');
INSERT INTO config_toolbox
(id, alias, functionparams, inputparams, observ, active, device)
VALUES(3550, '0- [CM] Verificar nodos sin documento de un lote', '{"featureType":[]}'::json, '[
  {
    "widgetname": "campaignId",
    "label": "Campaign Id:",
    "widgettype": "combo",
    "isparent": "true",
    "datatype": "text",
    "tooltip": "Choose a campaign",
    "layoutname": "grl_option_parameters",
    "layoutorder": 1,
    "dvQueryText": "SELECT c.campaign_id as id, name as idval FROM cm.om_campaign c JOIN (SELECT t.organization_id, bool_or(o.orgname =  ''OWNER'') AS is_admin FROM cm.cat_user u JOIN cm.cat_team t ON t.team_id = u.team_id JOIN cm.cat_organization o ON o.organization_id = t.organization_id WHERE u.username = current_user GROUP BY t.organization_id) ctx ON (c.organization_id = ctx.organization_id OR ctx.is_admin) WHERE exists (select 1 from cm.om_campaign_lot l where status in (3,4,6) and l.campaign_id = c.campaign_id)"
  },
  {
    "widgetname": "lotId",
    "label": "Lot Id:",
    "widgettype": "combo",
    "parentname": "campaignId",
    "datatype": "text",
    "tooltip": "Choose a lot",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
    "dvQueryText": "select null as id, '''' as idval union all select lot_id as id, concat(a.name, '' - '', b.idval, '''') AS idval FROM cm.om_campaign_lot a JOIN cm.sys_typevalue b ON a.status = b.id::int WHERE b.typevalue = ''lot_status'' and status in (3,4,6)",
    "filterquery": "select null as id, '''' as idval union all select lot_id as id, concat(a.name, '' - '', b.idval, '''') AS idval FROM cm.om_campaign_lot a JOIN cm.sys_typevalue b ON a.status = b.id::int WHERE b.typevalue = ''lot_status'' and status in (3,4,6) and a.campaign_id = {parent_value}"
  },
  {
    "widgetname": "excludeNodecatId",
    "widgettype": "text",
    "datatype": "numeric",
    "label": "Excluded node types:",
    "layoutname": "grl_option_parameters",
    "placeholder": "JUNCTION, HYDRANT",
    "isMandatory": false,
    "layoutorder": 5
  }
]'::json, NULL, true, '{4}');
INSERT INTO config_toolbox
(id, alias, functionparams, inputparams, observ, active, device)
VALUES(3548, '[CM] Check duplicated arcs of a lot', '{"featureType":[]}'::json, '[
  {
    "widgetname": "campaignId",
    "label": "Campaign Id:",
    "widgettype": "combo",
    "isparent": "true",
    "datatype": "text",
    "tooltip": "Choose a campaign",
    "layoutname": "grl_option_parameters",
    "layoutorder": 1,
    "dvQueryText": "SELECT c.campaign_id as id, name as idval FROM cm.om_campaign c JOIN (SELECT t.organization_id, bool_or(o.orgname =  ''OWNER'') AS is_admin FROM cm.cat_user u JOIN cm.cat_team t ON t.team_id = u.team_id JOIN cm.cat_organization o ON o.organization_id = t.organization_id WHERE u.username = current_user GROUP BY t.organization_id) ctx ON (c.organization_id = ctx.organization_id OR ctx.is_admin) WHERE exists (select 1 from cm.om_campaign_lot l where status in (3,4,6) and l.campaign_id = c.campaign_id)"
  },
  {
    "widgetname": "lotId",
    "label": "Lot Id:",
    "widgettype": "combo",
    "parentname": "campaignId",
    "datatype": "text",
    "tooltip": "Choose a lot",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
    "dvQueryText": "select null as id, '''' as idval union all select lot_id as id, concat(a.name, '' - '', b.idval, '''') AS idval FROM cm.om_campaign_lot a JOIN cm.sys_typevalue b ON a.status = b.id::int WHERE b.typevalue = ''lot_status'' and status in (3,4,6)",
    "filterquery": "select null as id, '''' as idval union all select lot_id as id, concat(a.name, '' - '', b.idval, '''') AS idval FROM cm.om_campaign_lot a JOIN cm.sys_typevalue b ON a.status = b.id::int WHERE b.typevalue = ''lot_status'' and status in (3,4,6) and a.campaign_id = {parent_value}"
  }
]'::json, NULL, false, '{4}');
INSERT INTO config_toolbox
(id, alias, functionparams, inputparams, observ, active, device)
VALUES(3546, '1- [CM] Check duplicated nodes of a lot', '{"featureType":[]}'::json, '[
  {
    "widgetname": "campaignId",
    "label": "Campaign Id:",
    "widgettype": "combo",
    "isparent": "true",
    "datatype": "text",
    "tooltip": "Choose a campaign",
    "layoutname": "grl_option_parameters",
    "layoutorder": 1,
    "dvQueryText": "SELECT c.campaign_id as id, name as idval FROM cm.om_campaign c JOIN (SELECT t.organization_id, bool_or(o.orgname =  ''OWNER'') AS is_admin FROM cm.cat_user u JOIN cm.cat_team t ON t.team_id = u.team_id JOIN cm.cat_organization o ON o.organization_id = t.organization_id WHERE u.username = current_user GROUP BY t.organization_id) ctx ON (c.organization_id = ctx.organization_id OR ctx.is_admin) WHERE exists (select 1 from cm.om_campaign_lot l where status in (3,4,6) and l.campaign_id = c.campaign_id)"
  },
  {
    "widgetname": "lotId",
    "label": "Lot Id:",
    "widgettype": "combo",
    "parentname": "campaignId",
    "datatype": "text",
    "tooltip": "Choose a lot",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
    "dvQueryText": "select null as id, '''' as idval union all select lot_id as id, concat(a.name, '' - '', b.idval, '''') AS idval FROM cm.om_campaign_lot a JOIN cm.sys_typevalue b ON a.status = b.id::int WHERE b.typevalue = ''lot_status'' and status in (3,4,6)",
    "filterquery": "select null as id, '''' as idval union all select lot_id as id, concat(a.name, '' - '', b.idval, '''') AS idval FROM cm.om_campaign_lot a JOIN cm.sys_typevalue b ON a.status = b.id::int WHERE b.typevalue = ''lot_status'' and status in (3,4,6) and a.campaign_id = {parent_value}"
  },
  {
    "widgetname": "searchTolerance",
    "widgettype": "text",
    "datatype": "numeric",
    "label": "Search tolerance (in meters):",
    "layoutname": "grl_option_parameters",
    "isMandatory": true,
    "layoutorder": 5
  }
]'::json, NULL, true, '{4}');
INSERT INTO config_toolbox
(id, alias, functionparams, inputparams, observ, active, device)
VALUES(3544, '5- [CM] Check orphan nodes of a lot', '{"featureType":[]}'::json, '[
  {
    "widgetname": "campaignId",
    "label": "Campaign Id:",
    "widgettype": "combo",
    "isparent": "true",
    "datatype": "text",
    "tooltip": "Choose a campaign",
    "layoutname": "grl_option_parameters",
    "layoutorder": 1,
    "dvQueryText": "SELECT c.campaign_id as id, name as idval FROM cm.om_campaign c JOIN (SELECT t.organization_id, bool_or(o.orgname =  ''OWNER'') AS is_admin FROM cm.cat_user u JOIN cm.cat_team t ON t.team_id = u.team_id JOIN cm.cat_organization o ON o.organization_id = t.organization_id WHERE u.username = current_user GROUP BY t.organization_id) ctx ON (c.organization_id = ctx.organization_id OR ctx.is_admin) WHERE exists (select 1 from cm.om_campaign_lot l where status in (3,4,6) and l.campaign_id = c.campaign_id)"
  },
  {
    "widgetname": "lotId",
    "label": "Lot Id:",
    "widgettype": "combo",
    "parentname": "campaignId",
    "datatype": "text",
    "tooltip": "Choose a lot",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
    "dvQueryText": "select null as id, '''' as idval union all select lot_id as id, concat(a.name, '' - '', b.idval, '''') AS idval FROM cm.om_campaign_lot a JOIN cm.sys_typevalue b ON a.status = b.id::int WHERE b.typevalue = ''lot_status'' and status in (3,4,6)",
    "filterquery": "select null as id, '''' as idval union all select lot_id as id, concat(a.name, '' - '', b.idval, '''') AS idval FROM cm.om_campaign_lot a JOIN cm.sys_typevalue b ON a.status = b.id::int WHERE b.typevalue = ''lot_status'' and status in (3,4,6) and a.campaign_id = {parent_value}"
  }
]'::json, NULL, true, '{4}');
INSERT INTO config_toolbox
(id, alias, functionparams, inputparams, observ, active, device)
VALUES(3542, '4- [CM] Visualize lot topology', '{"featureType":[]}'::json, '[
  {
    "widgetname": "campaignId",
    "label": "Campaign Id:",
    "widgettype": "combo",
    "isparent": "true",
    "datatype": "text",
    "tooltip": "Choose a campaign",
    "layoutname": "grl_option_parameters",
    "layoutorder": 1,
    "dvQueryText": "SELECT c.campaign_id as id, name as idval FROM cm.om_campaign c JOIN (SELECT t.organization_id, bool_or(o.orgname =  ''OWNER'') AS is_admin FROM cm.cat_user u JOIN cm.cat_team t ON t.team_id = u.team_id JOIN cm.cat_organization o ON o.organization_id = t.organization_id WHERE u.username = current_user GROUP BY t.organization_id) ctx ON (c.organization_id = ctx.organization_id OR ctx.is_admin) WHERE exists (select 1 from cm.om_campaign_lot l where status in (3,4,6) and l.campaign_id = c.campaign_id)"
  },
  {
    "widgetname": "lotId",
    "label": "Lot Id:",
    "widgettype": "combo",
    "parentname": "campaignId",
    "datatype": "text",
    "tooltip": "Choose a lot",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
    "dvQueryText": "select null as id, '''' as idval union all select lot_id as id, concat(a.name, '' - '', b.idval, '''') AS idval FROM cm.om_campaign_lot a JOIN cm.sys_typevalue b ON a.status = b.id::int WHERE b.typevalue = ''lot_status'' and status in (3,4,6)",
    "filterquery": "select null as id, '''' as idval union all select lot_id as id, concat(a.name, '' - '', b.idval, '''') AS idval FROM cm.om_campaign_lot a JOIN cm.sys_typevalue b ON a.status = b.id::int WHERE b.typevalue = ''lot_status'' and status in (3,4,6) and a.campaign_id = {parent_value}"
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
INSERT INTO config_toolbox
(id, alias, functionparams, inputparams, observ, active, device)
VALUES(3540, '3- [CM] Reconnect lot topology', '{"featureType":[]}'::json, '[
  {
    "widgetname": "campaignId",
    "label": "Campaign Id:",
    "widgettype": "combo",
    "isparent": "true",
    "datatype": "text",
    "tooltip": "Choose a campaign",
    "layoutname": "grl_option_parameters",
    "layoutorder": 1,
    "dvQueryText": "SELECT c.campaign_id as id, name as idval FROM cm.om_campaign c JOIN (SELECT t.organization_id, bool_or(o.orgname =  ''OWNER'') AS is_admin FROM cm.cat_user u JOIN cm.cat_team t ON t.team_id = u.team_id JOIN cm.cat_organization o ON o.organization_id = t.organization_id WHERE u.username = current_user GROUP BY t.organization_id) ctx ON (c.organization_id = ctx.organization_id OR ctx.is_admin) WHERE exists (select 1 from cm.om_campaign_lot l where status in (3,4,6) and l.campaign_id = c.campaign_id)"
  },
  {
    "widgetname": "lotId",
    "label": "Lot Id:",
    "widgettype": "combo",
    "parentname": "campaignId",
    "datatype": "text",
    "tooltip": "Choose a lot",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
    "dvQueryText": "select null as id, '''' as idval union all select lot_id as id, concat(a.name, '' - '', b.idval, '''') AS idval FROM cm.om_campaign_lot a JOIN cm.sys_typevalue b ON a.status = b.id::int WHERE b.typevalue = ''lot_status'' and status in (3,4,6)",
    "filterquery": "select null as id, '''' as idval union all select lot_id as id, concat(a.name, '' - '', b.idval, '''') AS idval FROM cm.om_campaign_lot a JOIN cm.sys_typevalue b ON a.status = b.id::int WHERE b.typevalue = ''lot_status'' and status in (3,4,6) and a.campaign_id = {parent_value}"
  },
  {
    "widgetname": "updateType",
    "widgettype": "combo",
    "label": "Reconnection type:",
    "comboIds": [
      1,
      2
    ],
    "datatype": "text",
    "comboNames": [
      "Update topology (all arcs)",
      "Build topology (arcs without topology)"
    ],
    "layoutname": "grl_option_parameters",
    "isMandatory": true,
    "layoutorder": 5
  }
]'::json, NULL, true, '{4}');
