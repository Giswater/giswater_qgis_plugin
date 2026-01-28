/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO minsector (minsector_id) VALUES(0) ON CONFLICT (minsector_id) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3530, 'gw_fct_exception_others', 'utils', 'function', 'text, text, text, text, text', 'json', 'Function to return exception information.', NULL, NULL, 'core', NULL) ON CONFLICT DO NOTHING;

-- 08/01/2026
UPDATE config_form_list
	SET addparam='{
  "enableGlobalFilter": false,
  "enableStickyHeader": true,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": true,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": true,
  "multipleRowSelection": true,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "id",
        "desc": false
      }
    ]
  },
  "modifyTopToolBar": true,
  "renderTopToolbarCustomActions": [
    {
      "name": "btn_create_empty",
      "widgetfunction": {
        "functionName": "getCreateFunctions",
        "params": {}
      },
      "color": "success",
      "text": "Create empty Dscenario",
      "disableOnSelect": false,
      "moreThanOneDisable": false
    },
    {
      "name": "btn_toggle_active",
      "widgetfunction": {
        "functionName": "toggle_active",
        "params": {}
      },
      "color": "default",
      "text": "Toggle active",
      "disableOnSelect": true,
      "moreThanOneDisable": true
    },
    {
      "name": "btn_create_crm",
      "widgetfunction": {
        "functionName": "create_crm",
        "params": {}
      },
      "color": "success",
      "text": "Create from CRM",
      "disableOnSelect": false,
      "moreThanOneDisable": false
    },
    {
      "name": "btn_create_mincut",
      "widgetfunction": {
        "functionName": "create_mincut",
        "params": {}
      },
      "color": "success",
      "text": "Create from Mincut",
      "disableOnSelect": false,
      "moreThanOneDisable": false
    },
    {
      "name": "btn_delete",
      "widgetfunction": {
        "functionName": "delete",
        "params": {}
      },
      "color": "error",
      "text": "Delete",
      "disableOnSelect": true,
      "moreThanOneDisable": false
    }
  ],
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json
	WHERE listname='dscenario_results' AND device=5;

UPDATE sys_function SET "source"='cm' WHERE id=3426;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3532, 'gw_fct_getfeaturesfrompolygon', 'utils', 'function', 'json', 'json', 'Function to return the feature id that intersect with a given polygon', 'role_basic', NULL, 'core', NULL) ON CONFLICT DO NOTHING;

-- 13/01/2026
UPDATE sys_fprocess SET except_level = 3 WHERE fid = 153;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3534, 'gw_fct_getarcauditvalues', 'utils', 'function', 'json', 'json', 'Function to return the arc divides and arc fusion within a given period of time.', 'role_basic', NULL, 'core', NULL) ON CONFLICT DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3536, 'gw_fct_getmincutminsector', 'utils', 'function', 'json', 'json', 'Function to return stats from a mincut minsector', 'role_basic', NULL, 'core', NULL) ON CONFLICT DO NOTHING;

INSERT INTO inp_family (family_id, descript, age) VALUES('METAL', 'Metallic pipes', NULL);
INSERT INTO inp_family (family_id, descript, age) VALUES('PLASTIC', 'Plastic pipes', NULL);
INSERT INTO inp_family (family_id, descript, age) VALUES('OTHER', 'Other', NULL);

UPDATE sys_fprocess SET project_type='utils', query_text='select link_id as arc_id, linkcat_id as arccat_id, a.expl_id, l.the_geom FROM t_link l, temp_t_arc a WHERE st_dwithin(st_endpoint(l.the_geom), a.the_geom, 0.001) AND a.epa_type NOT IN (''CONDUIT'', ''PIPE'', ''VIRTUALVALVE'', ''VIRTUALPUMP'')', active=true, function_name='[gw_fct_pg2epa_check_networkmode_connec]' WHERE fid=404;

DELETE FROM sys_function WHERE function_name = 'gw_fct_graphanalytics_create_temptables';
DELETE FROM sys_function WHERE function_name = 'gw_fct_graphanalytics_delete_temptables';
DELETE FROM sys_function WHERE function_name = 'gw_fct_graphanalytics_settempgeom';

DROP FUNCTION IF EXISTS gw_fct_graphanalytics_create_temptables(json);
DROP FUNCTION IF EXISTS gw_fct_graphanalytics_delete_temptables(json);
DROP FUNCTION IF EXISTS gw_fct_graphanalytics_settempgeom(json);

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3538, 'gw_fct_getdmagraph', 'ws', 'function', 'json', 'json', 'Function to return and generate a graph for the calculated DMAs of a exploitation', 'role_om', NULL, 'core', NULL) ON CONFLICT DO NOTHING;

UPDATE sys_fprocess SET query_text='SELECT array_agg(a.list::text) AS arr_list FROM (
	SELECT concat(''Formname: '',formname, '', layoutname: '',layoutname, '', layoutorder: '',layoutorder) as list 
	FROM config_form_fields 
	WHERE formtype = ''form_feature'' AND hidden is FALSE AND tabname <> ''tab_none''
	group by layoutorder,formname,layoutname having count(*)>1)a HAVING count(*)>0' WHERE fid=322;

UPDATE sys_fprocess SET query_text='SELECT string_agg(concat(formname, '': '', columnname), ''; '') FROM config_form_fields WHERE datatype IS NULL AND formtype=''form_feature'' AND widgettype NOT IN (''hspacer'', ''tableview'', ''button'') HAVING count(*)>0' 
WHERE fid=318;

UPDATE sys_fprocess SET query_text='WITH subq_1 as (
SELECT a.id, feature_class, a.feature_type, child_layer from cat_feature a JOIN sys_addfields b ON a.id = b.cat_feature_id
), subq_2 as (
select*from information_schema.views a join subq_1 m on m.child_layer = a.table_name
where a.table_schema = current_schema
), subq_3 as (
select *, concat(''man_'',lower(feature_type)), position(concat(''man_'',lower(feature_type)) in view_definition) from subq_2
)
select*from subq_3 where position = 0' WHERE fid=311;

UPDATE sys_fprocess SET query_text='SELECT c.connec_id FROM plan_psector_x_connec c JOIN connec b USING (connec_id) WHERE link_id IS NULL AND pjoint_id IS NULL' WHERE fid=356;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4466, 'Start/End nodes is/are not valid(s)', 'Check elev data. Only NOT start/end nodes may have missed elev data', 2, true, 'ud', 'core', 'UI') ON CONFLICT DO NOTHING;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES (4468, 'Cannot delete %mapzone_name% (%mapzone_id%): operative elements exist for this mapzone.', 'Deactivate or move the operative elements first.', 2, true, 'utils', 'core', 'UI') ON CONFLICT DO NOTHING;

-- 20/01/2026
DROP FUNCTION IF EXISTS gw_fct_graphanalytics_arrangenetwork(json);
DROP FUNCTION IF EXISTS gw_fct_graphanalytics_initnetwork(json);
DELETE FROM sys_function WHERE function_name = 'gw_fct_graphanalytics_arrangenetwork';
DELETE FROM sys_function WHERE function_name = 'gw_fct_graphanalytics_initnetwork';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4474, 'Non-existing feature_type in table sys_feature_type', NULL, 2, true, 'utils', 'core', 'UI') ON CONFLICT DO NOTHING;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4476, 'Input geometry is not valid.', 'Check geometry type or validity', 2, true, 'utils', 'core', 'UI') ON CONFLICT DO NOTHING;

-- 22/01/2026
UPDATE config_function
	SET "style"='{
  "style": {
    "point": {
      "style": "categorized",
      "field": "descript",
      "transparency": 0.5,
      "width": 2.5,
      "values": [
        {
          "id": "Disconnected",
          "color": [
            255,
            124,
            64
          ]
        },
        {
          "id": "Conflict",
          "color": [
            14,
            206,
            253
          ]
        }
      ]
    },
    "line": {
      "style": "categorized",
      "field": "descript",
      "transparency": 0.5,
      "width": 2.5,
      "values": [
        {
          "id": "Disconnected",
          "color": [
            255,
            124,
            64
          ]
        },
        {
          "id": "Conflict",
          "color": [
            14,
            206,
            253
          ]
        }
      ]
    },
    "polygon": {
      "style": "categorized",
      "field": "descript",
      "transparency": 0.5
    },
    "graphconfig": {
      "style": "qml",
      "id": "103"
    }
  }
}'::json,actions='[
  {
    "funcName": "set_style_mapzones",
    "params": {}
  }
]'::json
WHERE id=3508;


-- 27/01/2026
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4478, 'There are no exploitations in your exploitation selection', 'Change your exploitation selection', 2, true, 'utils', 'core', 'UI');

UPDATE sys_function SET return_type = 'integer[]' WHERE id = 3510;

-- massive update of cat_workspace to remove selector_hydrometer
UPDATE cat_workspace
SET
  config = (
    jsonb_set(
      config::jsonb,
      '{selectors}',
      (
        SELECT COALESCE(jsonb_agg(elem), '[]'::jsonb)
        FROM jsonb_array_elements((config::jsonb)->'selectors') AS elem
        WHERE NOT (elem ? 'selector_hydrometer')
      )
    )
  )::json,
  lastupdate_timestamp = now(),
  lastupdate_user = CURRENT_USER;

-- 28/01/2026
-- Check mapzones v1
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4480, 'The following nodes don''t exist in the operative network: %node_list%', 'Check nodes in graphconfigs', 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4482, 'All nodes in graphconfigs exist in the operative network', NULL, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4484, 'The following to_arcs don''t exist in the operative network: %arc_list%', 'Check arcs in graphconfigs', 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4486, 'All arcs in graphconfigs exist in the operative network', NULL, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4488, 'The following nodes are set in multiple mapzones: %node_list%', 'Check nodes in graphconfigs', 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4490, 'There are no nodes set on multiple mapzones', NULL, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4492, 'The following arcs are set in more than one nodeParent: %arc_list%', 'Check arcs in graphconfigs', 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4494, 'There are no arcs set in more than one nodeParent', NULL, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4496, 'The following arcs are not connected to its nodeParent: %arc_list%', 'Check arcs in graphconfigs', 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4498, 'There are no arcs not connected to its nodeParent', NULL, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4500, 'The folowing pump/meter nodeParents don''t have the same to_arc on their graphconfig and man_table: %node_list%', 'Check for different to_arc in man_table and graphconfig', 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4502, 'There are no pump/meter nodeParents with different to_arc on their graphconfig and man_table', NULL, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4504, 'The folowing tank/source/waterwell/wtp nodeParents don''t have the same inlet_arc on their graphconfig and man_table: %node_list%', 'Check for different inlet_arc in man_table and graphconfig', 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4506, 'There are no tank/source/waterwell/wtp nodeParents with different inlet_arc on their graphconfig and man_table', NULL, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4508, 'The following nodeParent/to_arc are null: %feature_list%', 'Check for nulls in graphconfigs', 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4510, 'There are no nodeParent or to_arc null', NULL, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4512, 'The following nodeParents don''t exist in the operative network: %node_list%', 'Check nodeParents in graphconfigs', 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4514, 'All nodeParents in graphconfigs exist in the operative network', NULL, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4516, 'The following forceClosed/forceOpen don''t exist in the operative network: %node_list%', 'Check forceClosed/forceOpen in graphconfigs', 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4518, 'All forceClosed/forceOpen in graphconfigs exist in the operative network', NULL, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4520, 'The following nodeParents are set in multiple mapzones: %node_list%', 'Check nodeParents in graphconfigs', 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4522, 'There are no nodeParents set on multiple mapzones', NULL, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4524, 'The following forceClosed/forceOpen are set in multiple mapzones: %arc_list%', 'Check forceClosed/forceOpen in graphconfigs', 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4526, 'There are no forceClosed/forceOpen set on multiple mapzones', NULL, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) 
VALUES(4528, 'Some nodes are not connected in the routing graph (state > 0 filter). Disconnected nodes: %v_disconnected%', NULL, 0, true, 'utils', 'core', 'UI') ON CONFLICT DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) 
VALUES(4430, 'Unable to create a Profile. Check your path continuity before continue!', NULL, 0, true, 'utils', 'core', 'UI') ON CONFLICT DO NOTHING;

