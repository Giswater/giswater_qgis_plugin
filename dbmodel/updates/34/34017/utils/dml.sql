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

UPDATE sys_table SET(geom_field, pkey_field) = ('the_geom', 'arc_id') WHERE id = 'v_edit_arc';
UPDATE sys_table SET(geom_field, pkey_field) = ('the_geom', 'connec_id') WHERE id = 'v_edit_connec';
UPDATE sys_table SET(geom_field, pkey_field) = ('the_geom', 'link_id') WHERE id = 'v_edit_link';
UPDATE sys_table SET(geom_field, pkey_field) = ('the_geom', 'node_id') WHERE id = 'v_edit_node';
UPDATE sys_table SET(geom_field, pkey_field) = ('the_geom', 'id') WHERE id = 'v_edit_dimensions';


INSERT INTO sys_table(id, descript, sys_role, sys_criticity, sys_sequence, sys_sequence_field, pkey_field)
VALUES ('config_function', 'Table with the layers and styles of them, which are needed to handle other functions', 'role_om', 0, NULL, NULL, 'id');
INSERT INTO sys_table(id, descript, sys_role, sys_criticity, sys_sequence, sys_sequence_field, pkey_field)
VALUES ('config_function', 'Tabla con los estilos de las capas', 'role_edit', 0, NULL, NULL, 'id');


INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role)
VALUES (2976, 'gw_fct_json_create_return', 'utils', 'function', 'json, integer', 'json', 'Handles styles according to config_function', 'role_edit');
INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role)
VALUES (2978, 'gw_fct_get_style', 'utils', 'function', 'json', 'json', 'Retun styles', 'role_edit');


INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2431,'gw_fct_pg2epa_check_data', '{"style":{"point":{"style":"random","field":"fid","width":2,"transparency":0.5}},
"line":{"style":"random","field":"fid","width":2,"transparency":0.5},
"polygon":{"style":"random","field":"fid","width":2,"transparency":0.5}}', NULL, NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2914,'gw_fct_anl_node_proximity', '{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', NULL, NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2858,'gw_fct_pg2epa_check_result','{"style":{"point":{"style":"random","field":"fid","width":2,"transparency":0.5}},
"line":{"style":"random","field":"fid","width":2,"transparency":0.5},
"polygon":{"style":"random","field":"fid","width":2,"transparency":0.5}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2860,'gw_fct_pg2epa_check_options','{"style":{"point":{"style":"random","field":"fid","width":2,"transparency":0.5}},
"line":{"style":"random","field":"fid","width":2,"transparency":0.5},
"polygon":{"style":"random","field":"fid","width":2,"transparency":0.5}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2772,'gw_fct_grafanalytics_flowtrace','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2790,'gw_fct_grafanalytics_check_data','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

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
VALUES(2124,'gw_fct_connect_to_network',NULL,'{"visible": ["v_edit_arc", "v_edit_node", "v_edit_connec", "v_edit_arc", "v_edit_gully", "v_edit_link"]}',NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2202,'gw_fct_anl_arc_intersection','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2204,'gw_fct_anl_arc_inverted','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2206,'gw_fct_anl_node_exit_upper_intro','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2208,'gw_fct_anl_node_flowregulator','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2210,'gw_fct_anl_node_sink','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2212,'gw_fct_anl_node_topological_consistency','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2214,'gw_fct_flow_exit','{"style":{"point":{"style":"qml", "id":"2214"},  "line":{"style":"qml", "id":"2214"}}}','{"visible": ["v_anl_flow_node", "v_anl_flow_gully", "v_anl_flow_connec", "v_anl_flow_arc"]}',NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2218,'gw_fct_flow_trace','{"style":{"point":{"style":"qml", "id":"2218"},  "line":{"style":"qml", "id":"2218"}}}','{"visible": ["v_anl_flow_node", "v_anl_flow_gully", "v_anl_flow_connec", "v_anl_flow_arc"]}',NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2244,'gw_fct_mincut_result_overlap','{"style":{"point":{"style":"qml", "id":"106"},  "line":{"style":"qml", "id":"105"}, "polygon":{"style":"qml", "id":"107"}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2302,'gw_fct_anl_node_topological_consistency','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2436,'gw_fct_plan_check_data','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2522,'gw_fct_import_epanet_inp',NULL,'{"visible": ["v_edit_arc", "v_edit_node"],"zoom": {"layer":"v_edit_arc", "margin":20}}',NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2524,'gw_fct_import_swmm_inp',NULL,'{"visible": ["v_edit_arc", "v_edit_node"],"zoom": {"layer":"v_edit_arc", "margin":20}}',NULL);

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
VALUES(2706,'gw_fct_grafanalytics_minsector','{"style":{"point":{"style":"random","field":"fid","width":2,"transparency":0.5}},
"line":{"style":"random","field":"fid","width":2,"transparency":0.5},
"polygon":{"style":"random","field":"fid","width":2,"transparency":0.5}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2710,'gw_fct_grafanalytics_mapzones',NULL, NULL,'["style_mapzones"]');

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2734,'gw_fct_psector_duplicate','{"zoom":{"margin":20}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2776,'gw_fct_admin_check_data', '{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

--INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
--VALUES(2784,'gw_fct_insert_importdxf',NULL,NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2824,'gw_fct_getdimensioning',NULL,'{"visible": ["v_edit_dimensions"],"zoom": {"layer":"v_edit_arc", "margin":20}}',NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2826,'gw_fct_grafanalytics_lrs','{"style":{"point":{"style":"random","field":"fid","width":2,"transparency":0.5}},
"line":{"style":"random","field":"fid","width":2,"transparency":0.5},
"polygon":{"style":"random","field":"fid","width":2,"transparency":0.5}}',NULL,NULL);

--INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
--VALUES(2870,'gw_fct_setselectors',NULL,NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2118,'gw_fct_node_builtfromarc','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2848,'gw_fct_pg2epa_check_result','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL, NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2850,'gw_fct_pg2epa_check_options','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', '{"zoom": {"layer":"v_edit_arc", "margin":20}}',NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2430,'gw_fct_pg2epa_check_data','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', '{"zoom": {"layer":"v_edit_arc", "margin":20}}',NULL);

-- 21/02/2020
UPDATE config_form_fields SET dv_querytext = 'SELECT id, idval FROM config_visit_class WHERE feature_type=''ARC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))' WHERE formname = 'visit_singlevent' AND columnname = 'class_id';

UPDATE config_form_fields SET dv_querytext = 'SELECT id, idval FROM (SELECT node_1 AS id, node_1 AS idval FROM arc UNION SELECT DISTINCT node_2 AS id, node_2 AS idval FROM arc)c WHERE id IS NOT NULL' WHERE formname = 'visit_singlevent' AND columnname = 'position_id';

UPDATE config_form_fields SET dv_querytext = 'SELECT id, idval FROM config_visit_class WHERE feature_type=''ARC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))' WHERE formname = 'visit_node_inspeccio' AND columnname = 'class_id';

UPDATE config_form_fields SET dv_querytext = 'SELECT id, idval FROM config_visit_class WHERE feature_type=''ARC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))' WHERE formname = 'visit_node_revisio' AND columnname = 'class_id';
