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
VALUES ('config_function', 'Table with the layers and styles of them, which are needed to handle other functions', 'role_basic', 0) ON CONFLICT (id) DO NOTHING;


INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role)
VALUES (2976, 'gw_fct_json_create_return', 'utils', 'function', 'json, integer', 'json', 'Handles styles according to config_function', 'role_basic') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role)
VALUES (2978, 'gw_fct_get_style', 'utils', 'function', 'json', 'json', 'Retun styles', 'role_basic')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role)
VALUES (2982, 'gw_fct_getgeomfield', 'utils', 'function', 'character varying', 'character varying', 'Returns the geometry field of a table or view', 'role_basic')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role)
VALUES (2984, 'gw_fct_getpkeyfield', 'utils', 'function', 'character varying', 'character varying', 'Returns the geometry field of a table or view', 'role_basic')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2102,'gw_fct_anl_arc_no_startend_node','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2104,'gw_fct_anl_arc_same_startend','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2106,'gw_fct_anl_connec_duplicated','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2108,'gw_fct_anl_node_duplicated','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2110,'gw_fct_anl_node_orphan','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2112,'gw_fct_arc_fusion',NULL,'{"visible": ["v_edit_arc", "v_edit_node"],"index": ["v_edit_node" ]}',NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2114,'gw_fct_arc_divide',NULL,'{"visible": ["v_edit_arc", "v_edit_node"],"index": ["v_edit_node" ]}',NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2118,'gw_fct_node_builtfromarc','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2436,'gw_fct_plan_check_data','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2580,'gw_fct_getinfofromcoordinates','{"style":{"ruberband":{"width":3, "color":[255,0,0], "transparency":0.5}}}',NULL,NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2582,'gw_fct_getinfofromid','{"style":{"ruberband":{"width":3, "color":[255,0,0], "transparency":0.5}}, "zoom":{"margin":50}}',NULL,NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2584,'gw_fct_getinfofromlist','{"style":{"ruberband":{"width":3, "color":[255,0,0], "transparency":0.5}}}',NULL,NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2590,'gw_fct_getlayersfromcoordinates','{"style":{"ruberband":{"width":3, "color":[255,0,0], "transparency":0.5}}}',NULL,NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2618,'gw_fct_setsearch','{"style":{"ruberband":{"width":3, "color":[255,0,0], "transparency":0.5}}}',NULL,NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2620,'gw_fct_setsearchadd','{"style":{"ruberband":{"width":3, "color":[255, 0,0], "transparency":0.5}}, "zoom":{"margin":50}}',NULL,NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2670,'gw_fct_om_check_data','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', NULL,NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2680,'gw_fct_pg2epa_check_network','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2734,'gw_fct_psector_duplicate','{"zoom":{"margin":20}}',NULL,NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2772,'gw_fct_grafanalytics_flowtrace','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2776,'gw_fct_admin_check_data', '{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL)  ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2790,'gw_fct_grafanalytics_check_data','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL)  ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2824,'gw_fct_getdimensioning',NULL,'{"visible": ["v_edit_dimensions"],"zoom": {"layer":"v_edit_arc", "margin":20}}',NULL)  ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2826,'gw_fct_grafanalytics_lrs','{"style":{"point":{"style":"random","field":"fid","width":2,"transparency":0.5}},
"line":{"style":"random","field":"fid","width":2,"transparency":0.5},
"polygon":{"style":"random","field":"fid","width":2,"transparency":0.5}}',NULL,NULL)  ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2914,'gw_fct_anl_node_proximity', '{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', NULL, NULL)  ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2980,'gw_fct_setmincut',NULL,'{"visible": ["v_om_mincut_arc", "v_om_mincut_connec", "v_om_mincut_initpoint", "v_om_mincut_node"], "zoom":{"layer":"v_om_mincut_arc", "margin":20}}',NULL)
 ON CONFLICT (id) DO NOTHING;



-- 21/02/2020
UPDATE config_form_fields SET dv_querytext = 'SELECT id, idval FROM config_visit_class WHERE feature_type=''ARC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))' WHERE formname = 'visit_singlevent' AND columnname = 'class_id';

UPDATE config_form_fields SET dv_querytext = 'SELECT id, idval FROM config_visit_class WHERE feature_type=''ARC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))' WHERE formname = 'visit_multievent' AND columnname = 'class_id';

UPDATE config_form_fields SET dv_querytext = 'SELECT id, idval FROM (SELECT node_1 AS id, node_1 AS idval FROM arc UNION SELECT DISTINCT node_2 AS id, node_2 AS idval FROM arc)c WHERE id IS NOT NULL' WHERE formname = 'visit_singlevent' AND columnname = 'position_id';

UPDATE sys_param_user SET formname = 'hidden' WHERE formname = 'hidden_value';

-- 2020/07/24
UPDATE config_param_system set isenabled = true, layoutorder = 6, widgettype='check', ismandatory = false, iseditable = true, layoutname='lyt_system',
dv_isparent=false, isautoupdate=false where parameter='edit_topocontrol_disable_error';

UPDATE config_param_system set  layoutorder = 7 where parameter='admin_currency';


UPDATE sys_table SET notify_action = '[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"muni_id, name","featureType":["arc", "node", "connec", "v_ext_plot","v_ext_streetaxis", "v_ext_address"]}]' 
WHERE id = 'ext_municipality';

UPDATE sys_table SET notify_action = '[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"expl_id, name","featureType":["arc", "node", "connec","v_edit_element", "v_edit_samplepoint","v_edit_pond", "v_edit_pool", "v_edit_dma", "v_ext_plot","v_ext_streetaxis", "v_ext_address"]}]' 
WHERE id = 'exploitation';

UPDATE sys_table SET notify_action = '[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc", "node", "connec","v_ext_plot","v_ext_address"]}]'
WHERE id = 'ext_streetaxis';

UPDATE sys_table SET notify_action = '[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc", "node", "connec", "v_ext_address"]}]'
WHERE id = 'ext_plot';

--2020/07/27
UPDATE config_form_tabs SET orderby = 1 WHERE formname = 'selector_basic' AND tabname = 'tab_exploitation';
UPDATE config_form_tabs SET orderby = 2 WHERE formname = 'selector_basic' AND tabname = 'tab_network_state';
UPDATE config_form_tabs SET orderby = 3 WHERE formname = 'selector_basic' AND tabname = 'tab_hydro_state';
UPDATE config_form_tabs SET orderby = 4 WHERE formname = 'selector_basic' AND tabname = 'tab_psector';
UPDATE config_form_tabs SET orderby = 5 WHERE formname = 'selector_basic' AND tabname = 'tab_sector';

UPDATE config_form_tabs SET orderby = 1 WHERE formname='search' AND tabname='tab_network';
UPDATE config_form_tabs SET orderby = 2 WHERE formname='search' AND tabname='tab_add_network';
UPDATE config_form_tabs SET orderby = 3 WHERE formname='search' AND tabname='tab_address';
UPDATE config_form_tabs SET orderby = 4 WHERE formname='search' AND tabname='tab_hydro';
UPDATE config_form_tabs SET orderby = 5 WHERE formname='search' AND tabname='tab_workcat';
UPDATE config_form_tabs SET orderby = 6 WHERE formname='search' AND tabname='tab_psector';
UPDATE config_form_tabs SET orderby = 7 WHERE formname='search' AND tabname='tab_visit';

UPDATE config_form_tabs SET orderby = 1 WHERE formname='lot' AND tabname='tab_data';

UPDATE config_form_tabs SET orderby = 1 WHERE formname='selector_mincut' AND tabname='tab_mincut';

UPDATE config_form_tabs SET orderby = 1 WHERE formname='config' AND tabname='tab_user';
UPDATE config_form_tabs SET orderby = 2 WHERE formname='config' AND tabname='tab_admin';

UPDATE config_form_tabs SET orderby = 1 WHERE formname='visit' AND tabname='tab_data';
UPDATE config_form_tabs SET orderby = 2 WHERE formname='visit' AND tabname='tab_file';

UPDATE config_form_tabs SET orderby = 1 WHERE formname='visit_manager' AND tabname='tab_data';
UPDATE config_form_tabs SET orderby = 2 WHERE formname='visit_manager' AND tabname='tab_done';
UPDATE config_form_tabs SET orderby = 3 WHERE formname='visit_manager' AND tabname='tab_lot';

UPDATE config_form_tabs SET orderby = 1 WHERE formname ='v_edit_node' AND tabname='tab_data';
UPDATE config_form_tabs SET orderby = 2 WHERE formname ='v_edit_node' AND tabname='tab_elements';
UPDATE config_form_tabs SET orderby = 3 WHERE formname ='v_edit_node' AND (tabname='tab_relations' or tabname='tab_connections');
UPDATE config_form_tabs SET orderby = 4 WHERE formname ='v_edit_node' AND tabname='tab_om';
UPDATE config_form_tabs SET orderby = 5 WHERE formname ='v_edit_node' AND tabname='tab_visit';
UPDATE config_form_tabs SET orderby = 6 WHERE formname ='v_edit_node' AND tabname='tab_documents';
UPDATE config_form_tabs SET orderby = 7 WHERE formname ='v_edit_node' AND tabname='tab_plan';
UPDATE config_form_tabs SET orderby = 8 WHERE formname ='v_edit_node' AND tabname='tab_epa';

UPDATE config_form_tabs SET orderby = 1 WHERE formname ='v_edit_arc' AND tabname='tab_data';
UPDATE config_form_tabs SET orderby = 2 WHERE formname ='v_edit_arc' AND tabname='tab_elements';
UPDATE config_form_tabs SET orderby = 3 WHERE formname ='v_edit_arc' AND tabname='tab_relations';
UPDATE config_form_tabs SET orderby = 4 WHERE formname ='v_edit_arc' AND tabname='tab_om';
UPDATE config_form_tabs SET orderby = 5 WHERE formname ='v_edit_arc' AND tabname='tab_visit';
UPDATE config_form_tabs SET orderby = 6 WHERE formname ='v_edit_arc' AND tabname='tab_documents';
UPDATE config_form_tabs SET orderby = 7 WHERE formname ='v_edit_arc' AND tabname='tab_plan';
UPDATE config_form_tabs SET orderby = 8 WHERE formname ='v_edit_arc' AND tabname='tab_epa';


UPDATE config_form_tabs SET orderby = 1 WHERE formname ='v_edit_connec' AND tabname='tab_data';
UPDATE config_form_tabs SET orderby = 2 WHERE formname ='v_edit_connec' AND tabname='tab_elements';
UPDATE config_form_tabs SET orderby = 3 WHERE formname ='v_edit_connec' AND tabname='tab_hydrometer';
UPDATE config_form_tabs SET orderby = 4 WHERE formname ='v_edit_connec' AND tabname='tab_hydrometer_val';
UPDATE config_form_tabs SET orderby = 5 WHERE formname ='v_edit_connec' AND tabname='tab_om';
UPDATE config_form_tabs SET orderby = 6 WHERE formname ='v_edit_connec' AND tabname='tab_visit';
UPDATE config_form_tabs SET orderby = 7 WHERE formname ='v_edit_connec' AND tabname='tab_documents';
UPDATE config_form_tabs SET orderby = 8 WHERE formname ='v_edit_connec' AND tabname='tab_epa';

UPDATE sys_table SET sys_role = 'role_master' WHERE id  ='v_ui_plan_psector';

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role)
VALUES (2986, 'gw_fct_anl_slope_consistency', 'ud', 'function', 'json', 'json', 'Identifies arcs that have a drawing direction opposite to the water flow. Calculation based on sys_elev values of arc',
'role_edit') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (250, 'Slope consistency', 'ud') ON CONFLICT (fid) DO NOTHING;

--2020/07/28
UPDATE sys_function SET descript = 'Massive builder assistant. Builds as many nodes as needed to complete the topologic rules of the network. 
All nodes are inserted using the values selected by user (state, workcat, etc). Default values for node type and node catalog are taken from the default values setted by user in a config as generic type for node.
Before executing, check if all new nodes will be inserted into mapzones boudaries. 
Uncheck direct insert into node table if you want to use intermediate table (anl_node).'
WHERE id = 2118;


--2020/07/29
UPDATE om_typevalue SET addparam = '{"go2plan":false}' WHERE typevalue = 'visit_param_type';
UPDATE om_typevalue SET addparam = '{"go2plan":true}' WHERE typevalue = 'visit_param_type' and id = 'REHABIT';

UPDATE config_user_x_expl SET active = TRUE;
UPDATE config_visit_class_x_feature SET active = TRUE;
UPDATE config_visit_class_x_parameter SET active = TRUE;
UPDATE config_visit_parameter SET active = TRUE;
UPDATE sys_foreignkey SET active = TRUE;


INSERT INTO config_csv(fid, alias, descript, functionname, active)
VALUES (141, 'Export inp', 'The csv file generated is according standard INP file of EPA software','role_epa', TRUE)
on conflict (fid) do nothing;

--2020/10/19
INSERT INTO config_fprocess(fid, tablename, target, fields, orderby, addparam)
SELECT 239, tablename, target, fields,orderby, addparam FROM config_fprocess WHERE fid2 = 239 ON CONFLICT (fid, tablename, target) DO NOTHING;