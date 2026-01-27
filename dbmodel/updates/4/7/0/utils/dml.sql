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

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4472, 'Unable to find the path between both nodes. Check network continuity', 'Check network continuity', 2, true, 'ud', 'core', 'UI') ON CONFLICT DO NOTHING;

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


INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg,
query_text, info_msg, function_name, active)
VALUES(643, 'PROCESS_NAME_1', 'ws', NULL, 'core', true, 'Check mapzones', NULL, 3, 'ERROR_MESSAGE_1', NULL, NULL,
'SELECT g.graph_type, g.mapzone_id , g.pgr_node_id AS nodeParent
		FROM temp_pgr_graphconfig g
		LEFT JOIN temp_pgr_node n USING (pgr_node_id)
		WHERE n.pgr_node_id IS NULL
		ORDER BY g.graph_type desc, g.mapzone_id,  g.pgr_node_id','INFO_MESSAGE_1', '[gw_fct_graphanalytics_mapzones_v1]', true);

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg,
query_text, info_msg, function_name, active)
VALUES(644, 'PROCESS_NAME_2', 'ws', NULL, 'core', true, 'Check mapzones', NULL, 3, 'ERROR_MESSAGE_2', NULL, NULL,
'SELECT g.graph_type, g.mapzone_id , g.pgr_node_id AS nodeParent, g.pgr_arc_id AS toArc
		FROM temp_pgr_graphconfig g
		LEFT JOIN temp_pgr_arc a USING (pgr_arc_id)
		WHERE g.graph_type = ''use'' AND a.pgr_arc_id IS NULL
		ORDER BY g.graph_type desc, g.mapzone_id,  g.pgr_node_id', 'INFO_MESSAGE_2', '[gw_fct_graphanalytics_mapzones_v1]', true);

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg,
query_text, info_msg, function_name, active)
VALUES(645, 'PROCESS_NAME_3', 'ws', NULL, 'core', true, 'Check mapzones', NULL, 3, 'ERROR_MESSAGE_3', NULL, NULL,
'SELECT g.pgr_node_id AS nodeParent, array_agg(g.graph_type) AS graph_type_set, array_agg(g.mapzone_id) AS mapzone_id_set
		FROM temp_pgr_graphconfig g
		JOIN temp_pgr_node n USING (pgr_node_id)
		GROUP BY g.pgr_node_id
		HAVING  count(*) > 1
		ORDER BY g.pgr_node_id', 'INFO_MESSAGE_3', '[gw_fct_graphanalytics_mapzones_v1]', true);

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg,
query_text, info_msg, function_name, active)
VALUES(646, 'PROCESS_NAME_4', 'ws', NULL, 'core', true, 'Check mapzones', NULL, 3, 'ERROR_MESSAGE_4', NULL, NULL,
'SELECT g.pgr_arc_id AS toArc, array_agg(g.pgr_node_id) AS node_parent_set, array_agg(g.mapzone_id) AS mapzone_id_set
		FROM temp_pgr_graphconfig g
		JOIN temp_pgr_arc a USING (pgr_arc_id)
		WHERE g.graph_type = ''use'' 
		GROUP BY g.pgr_arc_id
		HAVING  count(*) > 1
		ORDER BY g.pgr_arc_id', 'INFO_MESSAGE_4', '[gw_fct_graphanalytics_mapzones_v1]', true);

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg,
query_text, info_msg, function_name, active)
VALUES(647, 'PROCESS_NAME_5', 'ws', NULL, 'core', true, 'Check mapzones', NULL, 3, 'ERROR_MESSAGE_5', NULL, NULL,
'SELECT g.graph_type, g.mapzone_id , g.pgr_node_id AS nodeParent, g.pgr_arc_id AS toArc
		FROM temp_pgr_graphconfig g
		JOIN temp_pgr_arc a USING (pgr_arc_id)
		WHERE g.graph_type = ''use'' 
		AND NOT EXISTS (
			SELECT 1 FROM temp_pgr_node n 
			WHERE n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
		)
		ORDER BY g.mapzone_id,  g.pgr_node_id', 'INFO_MESSAGE_5', '[gw_fct_graphanalytics_mapzones_v1]', true);

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg,
query_text, info_msg, function_name, active)
VALUES(648, 'PROCESS_NAME_6', 'ws', NULL, 'core', true, 'Check mapzones', NULL, 3, 'ERROR_MESSAGE_6', NULL, NULL,
'WITH 
			meter_pump AS (
				SELECT node_id, to_arc FROM man_meter
				UNION ALL 
				SELECT node_id, to_arc FROM man_pump		
			)
		SELECT g.graph_type, g.mapzone_id , g.pgr_node_id AS nodeParent, g.pgr_arc_id AS toArc
		FROM temp_pgr_graphconfig g
		WHERE g.graph_type = ''use'' 
		AND EXISTS (
			SELECT 1 FROM meter_pump m
			WHERE m.node_id = g.pgr_node_id
			AND m.to_arc <> g.pgr_arc_id
		)
		ORDER BY g.mapzone_id,  g.pgr_node_id', 'INFO_MESSAGE_6', '[gw_fct_graphanalytics_mapzones_v1]', true);

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg,
query_text, info_msg, function_name, active)
VALUES(649, 'PROCESS_NAME_7', 'ws', NULL, 'core', true, 'Check mapzones', NULL, 3, 'ERROR_MESSAGE_7', NULL, NULL,
'WITH
			inlet AS (
				SELECT node_id, unnest(inlet_arc) AS arc_id FROM man_tank
				UNION ALL SELECT node_id, unnest(inlet_arc) AS arc_id FROM man_source
				UNION ALL SELECT node_id, unnest(inlet_arc) AS arc_id FROM man_waterwell
				UNION ALL SELECT node_id, unnest(inlet_arc) AS arc_id FROM man_wtp
			)
		SELECT g.graph_type, g.mapzone_id , g.pgr_node_id AS nodeParent, g.pgr_arc_id AS toArc
		FROM temp_pgr_graphconfig g
		WHERE g.graph_type = ''use'' 
		AND EXISTS (
			SELECT 1 FROM inlet i
			WHERE i.node_id = g.pgr_node_id
			AND i.arc_id = g.pgr_arc_id
		)
		ORDER BY g.mapzone_id,  g.pgr_node_id', 'INFO_MESSAGE_7', '[gw_fct_graphanalytics_mapzones_v1]', true);

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg,
query_text, info_msg, function_name, active)
VALUES(650, 'PROCESS_NAME_8', 'ws', NULL, 'core', true, 'Check mapzones', NULL, 3, 'ERROR_MESSAGE_8', NULL, NULL,
'SELECT g.graph_type, g.mapzone_id , g.pgr_node_id AS nodeParent, g.pgr_arc_id AS toArc
		FROM temp_pgr_graphconfig g
		WHERE g.graph_type = ''use'' 
		AND (g.pgr_node_id IS NULL OR g.pgr_arc_id IS NULL) 
		ORDER BY g.mapzone_id,  g.pgr_node_id', 'INFO_MESSAGE_8', '[gw_fct_graphanalytics_mapzones_v1]', true);

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg,
query_text, info_msg, function_name, active)
VALUES(651, 'PROCESS_NAME_9', 'ud', NULL, 'core', true, 'Check mapzones', NULL, 3, 'ERROR_MESSAGE_9', NULL, NULL,
'SELECT g.graph_type, g.mapzone_id , g.pgr_node_id AS nodeParent
		FROM temp_pgr_graphconfig g
		LEFT JOIN temp_pgr_node n USING (pgr_node_id)
		WHERE WHERE g.graph_type = ''use'' 
		AND n.pgr_node_id IS NULL
		ORDER BY g.graph_type desc, g.mapzone_id,  g.pgr_node_id', 'INFO_MESSAGE_9', '[gw_fct_graphanalytics_mapzones_v1]', true);

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg,
query_text, info_msg, function_name, active)
VALUES(652, 'PROCESS_NAME_10', 'ud', NULL, 'core', true, 'Check mapzones', NULL, 3, 'ERROR_MESSAGE_10', NULL, NULL,
'SELECT g.graph_type, g.mapzone_id , g.pgr_node_id AS nodeParent, g.pgr_arc_id AS toArc
		FROM temp_pgr_graphconfig g
		LEFT JOIN temp_pgr_arc a USING (pgr_arc_id)
		WHERE g.graph_type IN (''forceClosed'', ''forceOpen'')
		AND a.pgr_arc_id IS NULL
		ORDER BY g.graph_type desc, g.mapzone_id,  g.pgr_node_id', 'INFO_MESSAGE_10', '[gw_fct_graphanalytics_mapzones_v1]', true);

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg,
query_text, info_msg, function_name, active)
VALUES(653, 'PROCESS_NAME_11', 'ud', NULL, 'core', true, 'Check mapzones', NULL, 3, 'ERROR_MESSAGE_11', NULL, NULL,
'SELECT g.pgr_node_id AS nodeParent, array_agg(g.graph_type) AS graph_type_set, array_agg(g.mapzone_id) AS mapzone_id_set
		FROM temp_pgr_graphconfig g
		JOIN temp_pgr_node n USING (pgr_node_id)
		GROUP BY g.pgr_node_id
		HAVING  count(*) > 1
		ORDER BY g.pgr_node_id', 'INFO_MESSAGE_11', '[gw_fct_graphanalytics_mapzones_v1]', true);

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg,
query_text, info_msg, function_name, active)
VALUES(654, 'PROCESS_NAME_12', 'ud', NULL, 'core', true, 'Check mapzones', NULL, 3, 'ERROR_MESSAGE_12', NULL, NULL,
'SELECT g.pgr_node_id AS nodeParent, array_agg(g.graph_type) AS graph_type_set, array_agg(g.mapzone_id) AS mapzone_id_set
		FROM temp_pgr_graphconfig g
		JOIN temp_pgr_arc a USING (pgr_arc_id)
		GROUP BY g.pgr_arc_id
		HAVING  count(*) > 1
		ORDER BY g.pgr_node_id', 'INFO_MESSAGE_12', '[gw_fct_graphanalytics_mapzones_v1]', true);

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg,
query_text, info_msg, function_name, active)
VALUES(655, 'PROCESS_NAME_13', 'ud', NULL, 'core', true, 'Check mapzones', NULL, 3, 'ERROR_MESSAGE_13', NULL, NULL,
'SELECT lg.SOURCE AS arc_1, lg.target AS arc_2
		FROM pgr_linegraph(
			''SELECT pgr_arc_id AS id, pgr_node_1 AS source, pgr_node_2 AS target, 1::float8 AS cost, -1::float8 AS reverse_cost
			FROM temp_pgr_arc'',
			directed := TRUE
		) AS lg
		WHERE reverse_cost =  1', 'INFO_MESSAGE_13', '[gw_fct_graphanalytics_mapzones_v1]', true);

-- 27/01/2026
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4478, 'There are no exploitations in your exploitation selection', 'Change your exploitation selection', 2, true, 'utils', 'core', 'UI');

UPDATE sys_function SET return_type = 'integer[]' WHERE id = 3510;
