/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE sys_csv2pg_cat SET functionname='gw_fct_utils_csv2pg_import_timeseries', name='Import timeseries', name_i18n='Import timeseries', sys_role='role_edit'
WHERE functionname='gw_fct_utils_csv2pg_import_patterns';

INSERT INTO sys_fprocess_cat VALUES (48, 'Pipe leak probability', 'om', 'Pipe leak probability', 'ws');
INSERT INTO sys_fprocess_cat VALUES (49, 'EPA calibration', 'epa', 'EPA calibration', 'utils');
INSERT INTO sys_fprocess_cat VALUES (50, 'EPA vnodes trim arcs' , 'epa', 'EPA vnodes trim arcs', 'ws');
INSERT INTO sys_fprocess_cat VALUES (51, 'Set feature relations', 'edit', 'Set feature relations', 'utils');
INSERT INTO sys_fprocess_cat VALUES (52, 'Delete feature', 'edit', 'Delete feature', 'utils');

UPDATE audit_cat_error SET error_message = 'Node with state 2 over another node with state=2 on same alternative it is not allowed. The node is:' 
WHERE id=1096;

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2725, 'gw_fct_get_feature_relation', 'utils', 'function', 'Function get the informations about all the relations that feature has', 'role_edit',false,false,false);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2736, 'gw_fct_set_delete_feature', 'utils', 'function', 'Delete feature and all relations that it has', 'role_edit',false,false,false);

INSERT INTO audit_cat_function 
VALUES (2728, 'gw_fct_pg2epa_vnodetrimarcs', 'ws', 'function', NULL, NULL, NULL, 'Function to trim arcs on model using vnodes', 'role_epa', false, false, NULL, false);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2732, 'gw_trg_connect_update', 'utils', 'trigger function', 'Manage capabilities after update fields on connect (connec & gullt)', 'role_edit',false,false,false);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2734, 'gw_fct_duplicate_psector', 'utils', 'function', 'Create a copy of existing psector', 'role_master',false,false,false);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2735, 'gw_fct_admin_manage_child_config', 'utils', 'function', 'Create custom form configuration for child views', 'role_master',false,false,false);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2738, 'gw_fct_utils_csv2pg_import_timeseries', 'utils', 'function', 'Import any timeseries as you want', 'role_edit',false,false,false);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2740, 'gw_api_get_visit', 'api', 'function', 'FUnction to build the form of visits', 'role_om',false,false,false);

UPDATE audit_cat_function SET return_type='[{"widgetname":"exploitation", "label":"Exploitation ( id ):", "widgettype":"text", "datatype":"integer","layoutname":"grl_option_parameters","layout_order":1,"value":null},
											{"widgetname":"insertIntoNode", "label":"Direct insert into node table:", "widgettype":"check", "datatype":"boolean","layoutname":"grl_option_parameters","layout_order":2,"value":"true"},
											{"widgetname":"nodeTolerance", "label":"Node tolerance:", "widgettype":"spinbox","datatype":"float","layoutname":"grl_option_parameters","layout_order":3,"value":0.01},
											{"widgetname":"saveOnDatabase", "label":"Save on database:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":9, "value":"FALSE"}]'
where id=2118;


UPDATE audit_cat_function SET isdeprecated=TRUE where id=2688;
UPDATE audit_cat_function SET isdeprecated=TRUE where id=1108;

INSERT INTO sys_csv2pg_cat VALUES (21, 'Import visit lot', 'Import visit lot', 'The csv file must contains next columns on same position: feature_id, 
feature_type, visitclass_id, lot_id, status (4 is finished), date (AAAA/MM/DD), param1, param2', 'role_om', 'importcsv', 'gw_fct_utils_csv2pg_import_omvisitlot', NULL, NULL, false);

INSERT INTO sys_fprocess_cat VALUES (54, 'Import lot visits', 'om', 'Import lot visits', 'utils');

INSERT INTO sys_fprocess_cat VALUES (55, 'Nodes single capacity', 'epa', 'Nodes single capacity', 'ws');
INSERT INTO sys_fprocess_cat VALUES (56, 'Nodes double capacity', 'epa', 'Nodes double capacity', 'ws');
INSERT INTO sys_fprocess_cat VALUES (57, 'Nodes single capacity but not double', 'epa', 'Nodes single capacity but not double', 'ws');
INSERT INTO sys_fprocess_cat VALUES (58, 'Nodes coupled capacity', 'epa', 'Nodes coupled capacity', 'ws');
INSERT INTO sys_fprocess_cat VALUES (59, 'EPA check vnodes over nod2arc', 'epa', 'EPA check vnodes over nod2arc', 'ws');
INSERT INTO sys_fprocess_cat VALUES (60, 'EPA connecs with no hydrometer', 'epa', 'EPA connecs with no hydrometer', 'ws');
INSERT INTO sys_fprocess_cat VALUES (61, 'Check pattern related to dma', 'epa', 'Check pattern related to dma', 'ws');
INSERT INTO sys_fprocess_cat VALUES (62, 'Check pattern related to hydro', 'epa', 'Check pattern related to hydro', 'ws');


INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3020,'This planified feature (state=2) is already used in another psector','Create a new feature in order to assign it.', 2, true,'utils',false);

--UPDATE config_param_system SET context=null, parameter='_api_search_visit' WHERE parameter='api_search_visit';

UPDATE audit_cat_param_user  SET isparent= TRUE WHERE id='state_vdefault';
UPDATE audit_cat_param_user  SET dv_parent_id= 'state_vdefault', 
dv_querytext = 'SELECT id as id, name as idval FROM value_state_type WHERE id IS NOT NULL ', dv_querytext_filterc = ' AND state = '
WHERE id='statetype_vdefault';

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type,isdeprecated)
VALUES (3022, 'The inserted value is not present in a catalog. Catalog, field:', 'Add it to the corresponding typevalue table in order to use it.', 2, true, 'utils', false);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2744, 'gw_trg_typevalue_fk', 'utils', 'trigger', 'Control foreign keys created in typevalue tables', 'role_edit',false, false, false);

UPDATE audit_cat_function SET   
return_type='[{"widgetname":"exploitation", "label":"Exploitation:", "widgettype":"text", "datatype":"integer","layoutname":"grl_option_parameters","layout_order":1,"value":null},{"widgetname":"inserIntoNode", "label":"Direct insert into node table:", "widgettype":"check", "datatype":"boolean","layoutname":"grl_option_parameters","layout_order":2,"value":"true"},{"widgetname":"nodeTolerance", "label":"Node tolerance:", "widgettype":"spinbox","datatype":"float","layoutname":"grl_option_parameters","layout_order":3,"value":0.01}]'
WHERE function_name='gw_fct_built_nodefromarc';


UPDATE audit_cat_function SET isparametric = TRUE, istoolbox = TRUE,
return_type = '[{"widgetname":"resultId", "label":"Result Id:","widgettype":"text","datatype":"string","layoutname":"grl_option_parameters","layout_order":1,"value":""},{"widgetname":"saveOnDatabase", "label":"Save on database:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":9, "value":"FALSE"}]'
WHERE function_name = 'gw_fct_plan_audit_check_data';

UPDATE audit_cat_function SET isparametric = TRUE, istoolbox = TRUE,
return_type = '[{"widgetname":"saveOnDatabase", "label":"Save on database:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":9, "value":"FALSE"}]'
WHERE function_name = 'gw_fct_anl_arc_intersection';

UPDATE audit_cat_table SET notify_action = '[{"action":"web","name":"refresh_canvas", "enabled":"true", "trg_fields":"the_geom","featureType":["arc"]},
{"action":"desktop","name":"refresh_canvas", "enabled":"true", "trg_fields":"the_geom","featureType":["arc"]}]' WHERE id ='arc';

UPDATE audit_cat_table SET notify_action = '[{"action":"web","name":"refresh_canvas", "enabled":"true", "trg_fields":"the_geom","featureType":["node"]},
{"action":"desktop","name":"refresh_canvas", "enabled":"true", "trg_fields":"the_geom","featureType":["node"]}]' WHERE id = 'node';

UPDATE audit_cat_table SET notify_action = '[{"action":"web","name":"refresh_canvas", "enabled":"true", "trg_fields":"the_geom","featureType":["connec"]},
{"action":"desktop","name":"refresh_canvas", "enabled":"true", "trg_fields":"the_geom","featureType":["connec"]}]' WHERE id = 'connec';

UPDATE audit_cat_table SET notify_action = '[{"action":"web","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["node"]},
{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["node"]}]' WHERE id ='cat_node';

UPDATE audit_cat_table SET notify_action = '[{"action":"web","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc"]},
{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc"]}]' WHERE id ='cat_arc';

UPDATE audit_cat_table SET notify_action = '[{"action":"web","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["connec"]},
{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["connec"]}]' WHERE id ='cat_connec';

SELECT SCHEMA_NAME.gw_fct_admin_schema_manage_triggers('notify',null);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type,descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2746, 'gw_fct_admin_manage_visit', 'utils', 'function', 'Create new visit class with parameters and form configuration',
'role_om', FALSE, FALSE, FALSE);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type,descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2748, 'gw_fct_admin_manage_visit_view', 'utils', 'function', 'Create view for a new multievent visit class',
'role_om', FALSE, FALSE, FALSE);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type,descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2750, 'gw_trg_typevalue_config_fk', 'utils', 'trigger function', 'Control foreign keys created in typevalue tables from the side of configuration',
'role_edit', FALSE, FALSE, FALSE);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type,descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2752, 'gw_fct_admin_manage_child_views_view', 'utils', 'function', 'Create child custom views','role_admin', FALSE, FALSE, FALSE);

INSERT INTO audit_cat_error(id, error_message, log_level, show_user, project_type, isdeprecated)
VALUES (3024, 'Can''t delete the parameter. There is at least one event related to it', 2, true,'utils',false);

INSERT INTO audit_cat_error(id, error_message,hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3026, 'Can''t delete the class. There is at least one visit related to it','The class will be set to unactive.', 
1, true,'utils',false);

INSERT INTO audit_cat_error(id, error_message,hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3028, 'Can''t modify typevalue:','It''s impossible to change system values.', 
2, true,'utils',false);

INSERT INTO audit_cat_error(id, error_message,hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3030, 'Can''t delete typevalue:','It''s being used in a table.', 
2, true,'utils',false);

INSERT INTO audit_cat_error(id, error_message,hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3032, 'Can''t apply the foreign key','there are values already inserted that are not present in the catalog', 
2, true,'utils',false);

INSERT INTO audit_cat_table VALUES ('om_visit_type', 'O&M', 'Catalog of visit types', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('om_visit_class', 'O&M', 'Catalog of visit classes', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('om_visit_class_x_parameter', 'O&M', 'Table that relates visit parameters with visit classes', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('om_visit_lot', 'O&M', 'Table with all lots that took place', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('om_visit_lot_x_arc', 'O&M', 'Table of arcs related to lots', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('om_visit_lot_x_node', 'O&M', 'Table of nodes related to lots', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('om_visit_lot_x_connec', 'O&M', 'Table of connecs related to lots', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('selector_lot', 'Selector', 'Selector of lots', 'role_basic', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('cat_team', 'Catalog', 'Catalog of teams', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('om_visit_team_x_user', 'O&M', 'Table that relates users with teams', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('om_visit_filetype_x_extension', 'O&M', 'Catalog of diferent filetypes and their extensions used in visits', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('om_visit_lot_x_user', 'O&M', 'Table that saves information about works made by a user in relation to one lot', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('ve_visit_arc_singlevent', 'O&M', 'Editable view that saves visits to arcs and its event data', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('ve_visit_connec_singlevent', 'O&M', 'Editable view that saves visits to connecs and its event data', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('ve_visit_node_singlevent', 'O&M', 'Editable view that saves visits to nodes and its event data', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('audit_cat_column', 'System', 'Catalog of columns', 'role_admin', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('edit_typevalue', 'value domain', 'Value domain of edit tables', 'role_admin', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('v_ui_plan_node_cost', 'User interface view', 'User interface view for nodes and its prices', 'role_master', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('v_ui_plan_arc_cost', 'User interface view', 'User interface view for nodes and its prices', 'role_master', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('vp_basic_arc', 'Auxiliar view', 'Auxiliar view for arcs with id and type', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('vp_basic_node', 'Auxiliar view', 'Auxiliar view for nodes with id and type', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('vp_basic_connec', 'Auxiliar view', 'Auxiliar view for connecs with id and type', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('vp_epa_arc', 'Auxiliar view', 'Auxiliar view for arcs with id, type and epa view', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('vp_epa_node', 'Auxiliar view', 'Auxiliar view for nodes with id, type and epa view', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('ext_hydrometer_category_x_pattern', 'external table', 'Table that related hydrometer category with its pattern', 'role_edit', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('ext_cat_period_type', 'external table', 'Catalog of different types of periods', 'role_edit', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('plan_typevalue', 'value domain', 'Value domain of plan tables', 'role_admin', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('om_typevalue', 'value domain', 'Value domain of om tables', 'role_admin', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('plan_psector_x_connec', 'masterplan', 'Table of connecs related to plan sectors', 'role_master', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('v_ui_event_x_arc', 'User interface view', 'User interface view for arcs related to its events', 'role_edit', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('v_ui_event_x_connec', 'User interface view', 'User interface view for connecs related to its events', 'role_edit', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('v_ui_event_x_node', 'User interface view', 'User interface view for nodes related to its events', 'role_edit', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('v_ui_hydroval_x_connec', 'User interface view', 'User interface view for connecs related to its hydrometer and data', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('v_ui_doc', 'User interface view', 'User interface view for docs', 'role_edit', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('ve_arc', 'Editable view', 'Editable view for arcs', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('ve_node', 'Editable view', 'Editable view for nodes', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('ve_connec', 'Editable view', 'Editable view for conncs', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('ext_timeseries', 'external table', 'Table of timeseries', 'role_edit', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('ext_workorder_class', 'external table', 'Table of workorders related to its classes', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('ext_workorder_type', 'external table', 'Table of workorders related to its types', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('om_visit_class_x_wo', 'O&M', 'Table of visit classes related to its workorders', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('ext_workorder', 'external table', 'External table of workorders', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('typevalue_fk', 'System', NULL, 'role_admin', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('vi_parent_arc', 'Hydraulic input data', 'Parent table of arcs filtered by inp selector', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('vi_parent_node', 'Hydraulic input data', 'Parent table of nodes filtered by inp selector', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('v_rtc_period_dma', 'Real time control', 'View of the relation between dma and period', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('v_rtc_period_node', 'Real time control', 'View of the relation between node and period', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('v_rtc_period_pjoint', 'Real time control', NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('v_plan_psector_arc_affect', 'masterplan', 'View with arcs which will be removed by a psector', 'role_master', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('v_plan_psector_arc_current', 'masterplan', 'View with arcs which will be affected by a psector but they remain untouched', 'role_master', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('v_plan_psector_arc_planif', 'masterplan', 'View with arcs which will be new in a psector', 'role_master', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('v_ui_om_visit_lot', 'User interface view', 'User interface view for lots', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('v_res_lot_x_user', 'O&M', 'View with the results of a work realised by a user in relation with one lot', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('ve_lot_x_arc', 'O&M', 'View that relates arcs and lots', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('ve_lot_x_node', 'O&M', 'View that relates nodes and lots', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('ve_lot_x_connec', 'O&M', 'View that relates connecs and lots', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('v_visit_lot_user', 'O&M', 'View for lots and users', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);

INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('plan_typevalue', 'psector_status', 'plan_psector', 'status');

UPDATE audit_cat_table SET isdeprecated=TRUE WHERE id='om_psector';
UPDATE audit_cat_table SET isdeprecated=TRUE WHERE id='om_psector_cat_type';
UPDATE audit_cat_table SET isdeprecated=TRUE WHERE id='om_psector_selector';
UPDATE audit_cat_table SET isdeprecated=TRUE WHERE id='om_psector_x_arc';
UPDATE audit_cat_table SET isdeprecated=TRUE WHERE id='om_psector_x_connec';
UPDATE audit_cat_table SET isdeprecated=TRUE WHERE id='om_psector_x_node';
UPDATE audit_cat_table SET isdeprecated=TRUE WHERE id='om_psector_x_other';
