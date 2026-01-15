/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO minsector (minsector_id) VALUES(0) ON CONFLICT (minsector_id) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3530, 'gw_fct_exception_others', 'utils', 'function', 'text, text, text, text, text', 'json', 'Function to return exception information.', NULL, NULL, 'core', NULL);

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

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3532, 'gw_fct_getfeaturesfrompolygon', 'utils', 'function', 'json', 'json', 'Function to return the feature id that intersect with a given polygon', 'role_basic', NULL, 'core', NULL);

-- 13/01/2026
UPDATE sys_fprocess SET except_level = 3 WHERE fid = 153;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3534, 'gw_fct_getarcauditvalues', 'utils', 'function', 'json', 'json', 'Function to return the arc divides and arc fusion within a given period of time.', 'role_basic', NULL, 'core', NULL);

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3536, 'gw_fct_getmincutminsector', 'utils', 'function', 'json', 'json', 'Function to return stats from a mincut minsector', 'role_basic', NULL, 'core', NULL);

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

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3538, 'gw_fct_getdmagraph', 'ws', 'function', 'json', 'json', 'Function to return and generate a graph for the calculated DMAs of a exploitation', 'role_om', NULL, 'core', NULL);