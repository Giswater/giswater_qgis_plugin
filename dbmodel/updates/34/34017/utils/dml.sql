/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/07/14

update sys_function set input_params = null, return_type = null where id = 2718;

UPDATE config_form_fields SET formtype = 'form_list_header' where formtype = 'listfilter';
DELETE FROM config_typevalue WHERE id = 'listfilter';
DELETE FROM config_typevalue WHERE id IN (select id FROM config_typevalue WHERE id = 'tabData' LIMIT 1);


INSERT INTO sys_table(id, descript, sys_role, sys_criticity)
VALUES ('config_function', 'Table with the layers and styles of them, which are needed to handle other functions', 'role_basic', 0);


INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role)
VALUES (2976, 'gw_fct_json_create_return', 'utils', 'function', 'json, integer', 'json', 'Handles styles according to config_function', 'role_basic');

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role)
VALUES (2978, 'gw_fct_get_style', 'utils', 'function', 'json', 'json', 'Retun styles', 'role_basic');

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role)
VALUES (2982, 'gw_fct_getgeomfield', 'utils', 'function', 'character varying', 'character varying', 'Returns the geometry field of a table or view', 'role_basic');

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role)
VALUES (2984, 'gw_fct_getpkeyfield', 'utils', 'function', 'character varying', 'character varying', 'Returns the geometry field of a table or view', 'role_basic');


INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2102,'gw_fct_anl_arc_no_startend_node','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2104,'gw_fct_anl_arc_same_startend','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2106,'gw_fct_anl_connec_duplicated','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2108,'gw_fct_anl_node_duplicated','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2110,'gw_fct_anl_node_orphan','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2112,'gw_fct_arc_fusion',NULL,'{"visible": ["v_edit_arc", "v_edit_node"],"index": ["v_edit_node" ]}',NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2114,'gw_fct_arc_divide',NULL,'{"visible": ["v_edit_arc", "v_edit_node"],"index": ["v_edit_node" ]}',NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2118,'gw_fct_node_builtfromarc','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2124,'gw_fct_connect_to_network',NULL,'{"visible": ["v_edit_arc", "v_edit_node", "v_edit_connec", "v_edit_arc", "v_edit_gully", "v_edit_link"]}',NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2436,'gw_fct_plan_check_data','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2580,'gw_fct_getinfofromcoordinates','{"style":{"ruberband":{"width":3, "color":[255,0,0], "transparency":0.5}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2582,'gw_fct_getinfofromid','{"style":{"ruberband":{"width":3, "color":[255,0,0], "transparency":0.5}}, "zoom":{"margin":50}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2584,'gw_fct_getinfofromlist','{"style":{"ruberband":{"width":3, "color":[255,0,0], "transparency":0.5}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2590,'gw_fct_getlayersfromcoordinates','{"style":{"ruberband":{"width":3, "color":[255,0,0], "transparency":0.5}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2618,'gw_fct_setsearch','{"style":{"ruberband":{"width":3, "color":[255,0,0], "transparency":0.5}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2620,'gw_fct_setsearchadd','{"style":{"ruberband":{"width":3, "color":[255, 0,0], "transparency":0.5}}, "zoom":{"margin":50}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2670,'gw_fct_om_check_data','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2680,'gw_fct_pg2epa_check_network','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2734,'gw_fct_psector_duplicate','{"zoom":{"margin":20}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2772,'gw_fct_grafanalytics_flowtrace','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2776,'gw_fct_admin_check_data', '{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2790,'gw_fct_grafanalytics_check_data','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2824,'gw_fct_getdimensioning',NULL,'{"visible": ["v_edit_dimensions"],"zoom": {"layer":"v_edit_arc", "margin":20}}',NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2826,'gw_fct_grafanalytics_lrs','{"style":{"point":{"style":"random","field":"fid","width":2,"transparency":0.5}},
"line":{"style":"random","field":"fid","width":2,"transparency":0.5},
"polygon":{"style":"random","field":"fid","width":2,"transparency":0.5}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2914,'gw_fct_anl_node_proximity', '{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', NULL, NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2980,'gw_fct_setmincut',NULL,'{"visible": ["v_om_mincut_arc", "v_om_mincut_connec", "v_om_mincut_initpoint", "v_om_mincut_node"], "zoom":{"layer":"v_om_mincut_arc", "margin":20}}',NULL);



-- 21/02/2020
UPDATE config_form_fields SET dv_querytext = 'SELECT id, idval FROM config_visit_class WHERE feature_type=''ARC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))' WHERE formname = 'visit_singlevent' AND columnname = 'class_id';

UPDATE config_form_fields SET dv_querytext = 'SELECT id, idval FROM config_visit_class WHERE feature_type=''ARC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))' WHERE formname = 'visit_multievent' AND columnname = 'class_id';

UPDATE config_form_fields SET dv_querytext = 'SELECT id, idval FROM (SELECT node_1 AS id, node_1 AS idval FROM arc UNION SELECT DISTINCT node_2 AS id, node_2 AS idval FROM arc)c WHERE id IS NOT NULL' WHERE formname = 'visit_singlevent' AND columnname = 'position_id';

UPDATE sys_param_user SET formname = 'hidden' WHERE formname = 'hidden_value';

-- 2020/07/24
UPDATE config_param_system set isenabled = true, layoutorder = 6, widgettype='check', ismandatory = false, iseditable = true, layoutname='lyt_system',
dv_isparent=false, isautoupdate=false where parameter='edit_topocontrol_disable_error';

UPDATE config_param_system set  layoutorder = 7 where parameter='admin_currency';
