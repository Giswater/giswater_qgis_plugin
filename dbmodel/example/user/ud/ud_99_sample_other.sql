/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

INSERT INTO inp_gully (gully_id, outlet_type, method, weir_cd, orifice_cd, efficiency)
SELECT gully_id, 'To_network', 'W_O', 1.6, 0.7, 90 FROM gully;

UPDATE man_netgully set gratecat_id = 'SGRT3';

UPDATE gully set connec_matcat_id = 'Concret';

INSERT INTO sys_function VALUES (2916, 'gw_fct_fill_doc_tables','ud','function','void','void','Create example documents (used on sample creation)','role_admin',false);
INSERT INTO sys_function VALUES (2886, 'gw_fct_fill_om_tables','ud','function','void','void','Create example visits (used on sample creation)','role_admin',false);
UPDATE sys_function SET input_params ='void', return_type ='void' WHERE id =2916;
UPDATE sys_function SET input_params ='void', return_type ='void' WHERE id =2886;

INSERT INTO inp_dwf (node_id, value, dwfscenario_id) SELECT node_id, 0.001, 1 FROM node WHERE state > 0;

INSERT INTO cat_users VALUES ('user1','user1');
INSERT INTO cat_users VALUES ('user2','user2');
INSERT INTO cat_users VALUES ('user3','user3');
INSERT INTO cat_users VALUES ('user4','user4');

INSERT INTO cat_manager (idval, expl_id, username, active) VALUES ('general manager', '{1,2}', concat('{',current_user,'}')::text[], true);

UPDATE config_param_user SET value='false' WHERE "parameter"='edit_plan_order_control' AND cur_user=current_user;

TRUNCATE plan_psector_x_node;
INSERT INTO plan_psector_x_node (id, node_id, psector_id, state, doable, descript,active) VALUES (1, '20599', 1, 1, true, NULL, true);
INSERT INTO plan_psector_x_node (id, node_id, psector_id, state, doable, descript,active) VALUES (2, '20596', 1, 1, true, NULL, true);
INSERT INTO plan_psector_x_node (id, node_id, psector_id, state, doable, descript,active) VALUES (3, '20597', 1, 1, true, NULL, true);
INSERT INTO plan_psector_x_node (id, node_id, psector_id, state, doable, descript,active) VALUES (4, '20598', 1, 1, true, NULL, true);
INSERT INTO plan_psector_x_node (id, node_id, psector_id, state, doable, descript,active) VALUES (7, '94', 1, 0, false, NULL, true);
INSERT INTO plan_psector_x_node (id, node_id, psector_id, state, doable, descript,active) VALUES (6, '92', 1, 0, false, NULL, true);
INSERT INTO plan_psector_x_node (id, node_id, psector_id, state, doable, descript,active) VALUES (5, '91', 1, 0, false, NULL, true);

INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, link_id, active) VALUES('3182', '20606', 1, 1, false, 708, true);
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, link_id, active) VALUES('3182', '179', 1, 0, false, 314, true);
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, link_id, active) VALUES('3183', '20606', 1, 1, false, 707, true);
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, link_id, active) VALUES('3183', '179', 1, 0, false, 315, true);
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, link_id, active) VALUES('3184', '20606', 1, 1, false, 709, true);
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, link_id, active) VALUES('3184', '179', 1, 0, false, 316, true);
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, link_id, active) VALUES('3181', '20606', 1, 1, false, 710, true);
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, link_id, active) VALUES('3181', '339', 1, 0, false, 443, true);
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, link_id, active) VALUES('3174', '20603', 1, 1, false, 711, true);
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, link_id, active) VALUES('3174', '178', 1, 0, false, 313, true);
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, link_id, active) VALUES('3175', '20604', 1, 1, false, 712, true);
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, link_id, active) VALUES('3175', '339', 1, 0, false, 444, true);

INSERT INTO plan_psector_x_gully (gully_id, arc_id, psector_id, state, doable, link_id, active) VALUES('30056', '339', 1, 0, false, 526, true);
INSERT INTO plan_psector_x_gully (gully_id, arc_id, psector_id, state, doable, link_id, active) VALUES('30057', '178', 1, 0, false, 527, true);
INSERT INTO plan_psector_x_gully (gully_id, arc_id, psector_id, state, doable, link_id, active) VALUES('30058', '178', 1, 0, false, 528, true);
INSERT INTO plan_psector_x_gully (gully_id, arc_id, psector_id, state, doable, link_id, active) VALUES('30059', '177', 1, 0, false, 529, true);
INSERT INTO plan_psector_x_gully (gully_id, arc_id, psector_id, state, doable, link_id, active) VALUES('30053', '179', 1, 0, false, 523, true);


TRUNCATE plan_psector_x_arc;
INSERT INTO plan_psector_x_arc VALUES (1, '20603', 1, 1, true, NULL, NULL, true);
INSERT INTO plan_psector_x_arc VALUES (2, '20604', 1, 1, true, NULL, NULL, true);
INSERT INTO plan_psector_x_arc VALUES (3, '20605', 1, 1, true, NULL, NULL, true);
INSERT INTO plan_psector_x_arc VALUES (5, '20602', 1, 1, true, NULL, NULL, true);
INSERT INTO plan_psector_x_arc VALUES (6, '20606', 1, 1, true, NULL, NULL, true);
INSERT INTO plan_psector_x_arc VALUES (4, '252', 2, 1, true, NULL, NULL, true);
INSERT INTO plan_psector_x_arc VALUES (7, '251', 2, 1, true, NULL, NULL, true);
INSERT INTO plan_psector_x_arc VALUES (8, '20608', 2, 0, false, NULL, NULL, true);
INSERT INTO plan_psector_x_arc VALUES (9, '157', 2, 0, false, NULL, NULL, true);
INSERT INTO plan_psector_x_arc VALUES (10, '177', 1, 0, false, NULL, NULL, true);
INSERT INTO plan_psector_x_arc VALUES (11, '178', 1, 0, false, NULL, NULL, true);
INSERT INTO plan_psector_x_arc VALUES (13, '179', 1, 0, false, NULL, NULL, true);
INSERT INTO plan_psector_x_arc VALUES (12, '339', 1, 0, false, NULL, NULL, true);

SELECT setval('SCHEMA_NAME.link_link_id_seq', (SELECT max(link_id) FROM link), true);

INSERT INTO doc VALUES ('Demo document 1', 'OTHER', 'https://github.com/Giswater/docs/blob/master/user/manual_usuario_giswater3.doc', NULL, '2018-03-11 19:40:20.449663', current_user, '2018-03-11 19:40:20.449663');
INSERT INTO doc VALUES ('Demo document 3', 'OTHER', 'https://github.com/Giswater/giswater/blob/master-2.1/legal/Licensing.txt', NULL, '2018-03-14 17:09:59.762257', current_user, '2018-03-14 17:09:59.762257');
INSERT INTO doc VALUES ('Demo document 2', 'OTHER', 'https://github.com/Giswater/giswater/blob/master-2.1/legal/Readme.txt', NULL, '2018-03-14 17:09:19.852804', current_user, '2018-03-14 17:09:19.852804');

-- rotate vnodes and connec labels
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('edit_link_connecrotation_update', TRUE, current_user);
UPDATE link SET the_geom=the_geom;

SELECT gw_fct_fill_doc_tables();
SELECT gw_fct_fill_om_tables();  -- 6 segons

INSERT INTO doc_x_visit (doc_id, visit_id)
SELECT 
doc.id,
om_visit.id
FROM doc, om_visit;


UPDATE config_form_fields set layoutorder = layoutorder+1 WHERE formname in ('ve_arc', 've_node', 've_connec','ve_gully')
AND columnname in ('streetname','streetname2', 'postnumber','postnumber2','postcomplement','postcomplement2');

UPDATE config_form_fields set hidden = false  WHERE formname in ('ve_arc', 've_node', 've_connec','ve_gully')
AND columnname = 'district_id';

UPDATE config_form_fields set layoutorder = 2 WHERE formname in ('ve_arc', 've_node','ve_gully') AND columnname = 'district_id';

UPDATE config_form_fields set layoutorder = 3 WHERE formname in ('ve_connec') AND columnname = 'district_id';

SELECT gw_fct_setcheckproject($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "version":"0", "fid":1}}$$)::text;

SELECT 	gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{"catFeature":"CONDUIT"},
 "data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-DELETE"  }}$$);

SELECT 	gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{"catFeature":"CONDUIT"},
 "data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-CREATE" }}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"CHAMBER"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"chamber_param_1", "datatype":"string", 
"widgettype":"combo", "label":"Chamber param_1","ismandatory":"False",
"active":"True", "iseditable":"True",  "dv_isnullvalue":"True","layoutname":"lyt_data_1",
"dv_querytext":"SELECT id as id, idval as idval  FROM edit_typevalue WHERE typevalue='chamber_param_1'"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"CHAMBER"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"chamber_param_2", "datatype":"date", 
"widgettype":"datetime", "label":"Chamber param_2","ismandatory":"False",
"active":"True", "iseditable":"True", "layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"CIRC_MANHOLE"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"cirmanhole_param_1", "datatype":"integer", 
"widgettype":"text", "label":"Cmanhole param_1","ismandatory":"False",
"fieldLength":"10", "numDecimals" :null,"active":"True", "iseditable":"True", "layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"CIRC_MANHOLE"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"cirmanhole_param_2", "datatype":"string", 
"widgettype":"text", "label":"Cmanhole param_2","ismandatory":"False",
"active":"True", "iseditable":"True", "layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"PGULLY"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"grate_param_1", "datatype":"string", 
"widgettype":"combo", "label":"Grate param_1","ismandatory":"False",
"active":"True", "iseditable":"True",  "dv_isnullvalue":"True","layoutname":"lyt_data_1",
"dv_querytext":"SELECT id as id, idval as idval  FROM edit_typevalue WHERE typevalue='grate_param_1'"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"PGULLY"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"grate_param_2", "datatype":"boolean", 
"widgettype":"check", "label":"Grate param_2","ismandatory":"False",
"active":"True", "iseditable":"True", "layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"OWERFLOW_STORAGE"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"owestorage_param_1", "datatype":"integer", 
"widgettype":"text", "label":"Owstorage param_1","ismandatory":"False",
"fieldLength":"10", "numDecimals" :null,"active":"True", "iseditable":"True", "layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"OWERFLOW_STORAGE"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"owestorage_param_2", "datatype":"string", 
"widgettype":"text", "label":"Owstorage param_2","ismandatory":"False",
"active":"True", "iseditable":"True", "layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"PUMP_PIPE"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"pumpipe_param_1", "datatype":"boolean", 
"widgettype":"check", "label":"Ppipe param_1","ismandatory":"False",
"active":"True", "iseditable":"True", "layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"PUMP_PIPE"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"pumpipe_param_2", "datatype":"string", 
"widgettype":"text", "label":"Ppipe param_2","ismandatory":"False",
"active":"True", "iseditable":"True", "layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"RECT_MANHOLE"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"recmanhole_param_1", "datatype":"string", 
"widgettype":"text", "label":"Rect. mhole param_1","ismandatory":"False",
"fieldLength":"500", "numDecimals" :null,"active":"True", "iseditable":"True", "layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"RECT_MANHOLE"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"recmanhole_param_2", "datatype":"string", 
"widgettype":"text", "label":"Rect. mhole param_2","ismandatory":"False",
"active":"True", "iseditable":"True", "layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"REGISTER"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"register_param_1", "datatype":"string", 
"widgettype":"text", "label":"Register param_1","ismandatory":"False",
"fieldLength":"500", "numDecimals" :null,"active":"True", "iseditable":"True", "layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"REGISTER"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"register_param_2", "datatype":"string", 
"widgettype":"text", "label":"Register param_2","ismandatory":"False",
"active":"True", "iseditable":"True", "layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"SEWER_STORAGE"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"sewstorage_param_1", "datatype":"string", 
"widgettype":"combo", "label":"Sstorage param_1","ismandatory":"False",
"active":"True", "iseditable":"True",  "dv_isnullvalue":"True","layoutname":"lyt_data_1",
"dv_querytext":"SELECT id as id, idval as idval  FROM edit_typevalue WHERE typevalue='sewstorage_param_1'"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"SEWER_STORAGE"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"sewstorage_param_2", "datatype":"string", 
"widgettype":"text", "label":"Sstorage param_1","ismandatory":"False",
"active":"True", "iseditable":"True", "layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"WEIR"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"weir_param_1", "datatype":"integer", 
"widgettype":"text", "label":"Weir param_1","ismandatory":"False",
"active":"True", "iseditable":"True", "layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"WEIR"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"weir_param_2", "datatype":"string", 
"widgettype":"text", "label":"Weir param_2","ismandatory":"False",
"active":"True", "iseditable":"True", "layoutname":"lyt_data_1"}}}$$);


INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('sewstorage_param_1','combo1','combo1');
INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('sewstorage_param_1','combo2','combo2');
INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('sewstorage_param_1','combo3','combo3');
INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('sewstorage_param_1','combo4','combo4');

INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('grate_param_1','1','combo1');
INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('grate_param_1','2','combo2');
INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('grate_param_1','3','combo3');

INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('chamber_param_1','1','combo1');
INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('chamber_param_1','2','combo2');
INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('chamber_param_1','3','combo3');
INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('chamber_param_1','4','combo4');

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, parameter_id)
SELECT 'edit_typevalue','sewstorage_param_1','man_addfields_value','value_param',id FROM sys_addfields WHERE param_name='sewstorage_param_1';
INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, parameter_id)
SELECT 'edit_typevalue','grate_param_1','man_addfields_value','value_param',id FROM sys_addfields WHERE param_name='grate_param_1';
INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, parameter_id)
SELECT 'edit_typevalue','chamber_param_1','man_addfields_value','value_param',id FROM sys_addfields WHERE param_name='chamber_param_1';


INSERT INTO selector_sector (sector_id, cur_user)
SELECT sector_id, current_user FROM sector
ON CONFLICT (sector_id, cur_user) DO NOTHING;

SELECT gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES"},
"data":{"resultId":"test1", "useNetworkGeom":"false", "dumpSubcatch":"true"}}$$);

UPDATE config_param_user SET value = 'TRUE' WHERE parameter = 'audit_project_user_control';

UPDATE cat_arc SET cost = 'VIRTUAL_M', m2bottom_cost = 'VIRTUAL_M2', m3protec_cost = 'VIRTUAL_M3' WHERE id = 'VIRTUAL';

UPDATE element SET code = concat ('E',element_id);

UPDATE cat_feature SET id=id;


-- hidden
UPDATE config_form_fields SET hidden = true WHERE columnname 
IN ('undelete', 'publish', 'buildercat_id', 'comment', 'num_value', 'svg', 'macrodqa_id', 'macrosector_id',
'macroexpl_id', 'custom_length', 'staticpressure1', 'staticpressure2', 'pipe_param_1');

UPDATE config_form_fields SET hidden = true WHERE columnname IN ('label_x', 'label_y') AND formname LIKE 've_arc%';

-- reorder sample
UPDATE config_form_fields SET layoutorder =90, layoutname = 'lyt_data_1' WHERE columnname ='link' AND (formname not in ('v_edit_link'));
UPDATE config_form_fields SET layoutorder =1 , layoutname ='lyt_bot_2' WHERE columnname ='sector_id' AND (formname not in ('v_edit_link','v_edit_inp_subcatchment'));
UPDATE config_form_fields SET layoutorder =4 , layoutname ='lyt_bot_1' , label = 'Dqa' WHERE columnname ='dqa_id' AND (formname not in ('v_edit_link'));
UPDATE config_form_fields SET layoutorder =70 , layoutname ='lyt_data_1' WHERE columnname ='macrosector_id' AND (formname not in ('v_edit_link'));
UPDATE config_form_fields SET stylesheet ='{"label":"color:red; font-weight:bold"}' WHERE columnname IN ('expl_id', 'sector_id') AND (formname not in ('v_edit_link'));

update config_form_fields SET layoutorder = 3 where columnname='state' and formname like '%ve_connec_%';
update config_form_fields SET layoutorder = 4 where columnname='state_type' and formname like '%ve_connec_%';

UPDATE cat_feature_node set isprofilesurface = true;

--refactor of forms
UPDATE config_form_fields SET layoutname = 'lyt_data_3', layoutorder = 11 where columnname ='pjoint_id';
UPDATE config_form_fields SET layoutname = 'lyt_data_3', layoutorder = 12 where columnname ='pjoint_type';
UPDATE config_form_fields SET layoutname = 'lyt_data_3', layoutorder = 13 where columnname ='descript' AND (formname not in ('v_edit_link','v_edit_inp_subcatchment'));
UPDATE config_form_fields SET layoutname = 'lyt_data_3', layoutorder = 14 where columnname = 'annotation';
UPDATE config_form_fields SET layoutname = 'lyt_data_3', layoutorder = 15 where columnname = 'observ' AND formname <> 'v_edit_dimensions';
UPDATE config_form_fields SET layoutname = 'lyt_data_3', layoutorder = 16 where columnname = 'lastupdate';
UPDATE config_form_fields SET layoutname ='lyt_data_3' , layoutorder = 17 where columnname = 'lastupdate_user';
UPDATE config_form_fields SET layoutname = 'lyt_data_3', layoutorder = 18 where columnname ='link';

UPDATE config_form_fields SET  hidden = true where columnname = 'macrodma_id';
UPDATE config_form_fields SET  hidden = true where columnname = 'inventory';
UPDATE config_form_fields SET  hidden = true where columnname = 'feature_id' and formname !='v_edit_link';
UPDATE config_form_fields SET  hidden = true where columnname = 'featurecat_id';
UPDATE config_form_fields SET  hidden = true where columnname = 'connec_length';

UPDATE config_form_fields SET  hidden = true where columnname = 'cmanhole_param_1';
UPDATE config_form_fields SET  hidden = true where columnname = 'cmanhole_param_2';


UPDATE config_form_fields SET  hidden = true where columnname IN ('accessibility', 'inlet');

UPDATE config_form_fields SET layoutname = 'lyt_data_2',  layoutorder = 50 where columnname ='bottom_channel' AND formname LIKE '%_node_%';
UPDATE config_form_fields SET layoutname = 'lyt_data_2' , layoutorder = 51 where columnname ='sander_depth' AND formname LIKE '%_node_%';
UPDATE config_form_fields SET layoutname = 'lyt_data_2' , layoutorder = 52 where columnname ='length' AND formname LIKE '%_node_%';
UPDATE config_form_fields SET layoutname = 'lyt_data_2' , layoutorder = 53 where columnname ='width' AND formname LIKE '%_node_%';

UPDATE config_form_fields SET layoutname = 'lyt_data_2',  layoutorder = 40 where columnname ='workcat_id_end' AND formname LIKE '%_connec_%';
UPDATE config_form_fields SET layoutname = 'lyt_data_2' , layoutorder = 40 where columnname ='workcat_id_end' AND formname LIKE '%_gully_%';
UPDATE config_form_fields SET layoutname = 'lyt_data_2' , layoutorder = 40 where columnname ='workcat_id_end' AND formname LIKE '%_arc_%';


UPDATE config_form_fields SET  hidden = true where columnname = 'z1';
UPDATE config_form_fields SET  hidden = true where columnname = 'z2';
UPDATE config_form_fields SET  hidden = true where columnname = 'cat_geom2' AND formname LIKE '%_arc_%';
UPDATE config_form_fields SET  hidden = true where columnname = 'cat_shape' AND formname LIKE '%_arc_%';
UPDATE config_form_fields SET  hidden = true where columnname = 'soilcat_id' AND formname LIKE '%_arc_%';


UPDATE config_form_fields SET  hidden = true where columnname = 'depth' AND formname LIKE '%_connec_%';
UPDATE config_form_fields SET  hidden = true where columnname = 'function_type' AND formname LIKE '%_connec_%';
UPDATE config_form_fields SET  hidden = true where columnname = 'descript' AND formname LIKE '%_connec_%';
UPDATE config_form_fields SET  hidden = true where columnname = 'annotation' AND formname LIKE '%_connec_%';

UPDATE config_form_fields SET layoutname = 'lyt_bot_1', layoutorder = 3 where columnname ='state' AND (formname not in ('v_edit_dimensions','v_edit_link'));
UPDATE config_form_fields SET layoutname = 'lyt_bot_1', layoutorder = 4 where columnname ='state_type';
UPDATE config_form_fields SET layoutname = 'lyt_bot_1' where columnname ='sector_id';
UPDATE config_form_fields SET layoutname = 'lyt_data_1',layoutorder = 997 where columnname ='hemisphere';
UPDATE config_form_fields SET layoutorder = 2 where columnname ='dma_id' and formname !='v_edit_link';

UPDATE config_form_fields SET layoutname = 'lyt_data_2', layoutorder = 30 where columnname ='verified';
UPDATE config_form_fields SET layoutname = 'lyt_data_2', layoutorder = 32 where columnname ='dqa_id';
UPDATE config_form_fields SET layoutname = 'lyt_data_2', layoutorder = 33 where columnname ='expl_id' AND (formname not in ('v_edit_dimensions','v_edit_link','v_edit_inp_subcatchment','v_edit_raingage'));
UPDATE config_form_fields SET layoutname = 'lyt_data_1', layoutorder = 998 where columnname ='parent_id';


update config_form_fields SET widgettype = 'text', dv_querytext = null, placeholder  ='Ex.macrosector_id' WHERE columnname  = 'macrosector_id';


-- add tooltips for specific fields
UPDATE config_form_fields SET tooltip = 'accessibility - Para establecer si es accesible o no' WHERE columnname = 'accessibility' AND tooltip IS NULL;
UPDATE config_form_fields SET tooltip = 'bottom_channel - Para establecer si tiene canal al fondo o no' WHERE columnname = 'bottom_channel' AND tooltip IS NULL;
UPDATE config_form_fields SET tooltip = 'length - Longitud total' WHERE columnname = 'length' AND tooltip IS NULL;
UPDATE config_form_fields SET tooltip = 'max_volume - Volumen máximo' WHERE columnname = 'max_volume' AND tooltip IS NULL;
UPDATE config_form_fields SET tooltip = 'sander_depth - Profundidad del arenero' WHERE columnname = 'sander_depth' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'util_volume - Volumen útil' WHERE columnname = 'util_volume' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'width - Anchura total' WHERE columnname = 'width' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'prot_surface - Para establecer si existe un protector en superfície' WHERE columnname = 'prot_surface' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'serial_number - Número de serie del elemento' WHERE columnname = 'serial_number' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'siphon - Para establecer si tiene sifón o no' WHERE columnname = 'siphon' AND (tooltip IS NULL OR tooltip='siphon') AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'units - Número de rejas' WHERE columnname = 'units' AND (tooltip IS NULL OR tooltip = 'units') AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'sander_length - Longitud del arenero' WHERE columnname = 'sander_length' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'min_height - Altura mínima' WHERE columnname = 'min_height' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'custom_area - Area útil del depósito' WHERE columnname = 'custom_area' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'groove - Para establecer si hay ranura en el encintado' WHERE columnname = 'groove' AND tooltip = 'groove' AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'inlet - Elemento con aportaciones' WHERE columnname = 'inlet' AND tooltip IS NULL;

UPDATE cat_feature_node SET isexitupperintro = 2 WHERE id = 'VIRTUAL_NODE';

UPDATE config_form_fields set layoutname = 'lyt_data_1' WHERE columnname = 'width' AND formname ='ve_node_chamber';
UPDATE config_form_fields set layoutname = 'lyt_data_1' WHERE columnname = 'width' AND formname ='ve_node_pump_station';
UPDATE config_form_fields set layoutname = 'lyt_data_1' WHERE columnname = 'width' AND formname ='ve_node_weir';

UPDATE config_param_system SET value='TRUE' WHERE parameter='sys_raster_dem';
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('edit_insert_elevation_from_dem', 'true', current_user)
ON CONFLICT (parameter, cur_user) DO NOTHING;

INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('edit_update_elevation_from_dem', 'true', current_user)
ON CONFLICT (parameter, cur_user) DO NOTHING;

UPDATE config_param_user SET value = 'TRUE' WHERE parameter = 'qgis_form_docker' AND cur_user = current_user;

-- updates to manage matcat_id separately from catalog
UPDATE config_form_fields SET iseditable=TRUE, widgettype='combo', dv_isnullvalue=TRUE, dv_querytext='SELECT id, id AS idval FROM cat_mat_node' 
WHERE columnname='matcat_id' AND formname LIKE 've_node%';

UPDATE config_form_fields SET iseditable=TRUE, widgettype='combo', dv_isnullvalue=TRUE, dv_querytext='SELECT id, id AS idval FROM cat_mat_arc' 
WHERE columnname='matcat_id' AND formname LIKE 've_connec%';

UPDATE config_form_fields SET iseditable=TRUE, widgettype='combo', dv_isnullvalue=TRUE, dv_querytext='SELECT id, id AS idval FROM cat_mat_arc' 
WHERE columnname='matcat_id' AND formname LIKE 've_arc%';

DELETE FROM cat_node WHERE id IN ('C_MANHOLE-BR100','C_MANHOLE-CON100','C_MANHOLE-CON80','R_MANHOLE-BR100','R_MANHOLE-CON100','R_MANHOLE-CON150',
'R_MANHOLE-CON200');

DELETE FROM cat_arc WHERE id IN ('CON-CC100','PVC-CC040','PVC-CC060','PVC-CC080','PVC-CC020','CON-CC040','CON-CC060','CON-CC080','CON-EG150','CON-RC150',
'CON-RC200','PE-PP020','PEC-CC040','PEC-CC315');

UPDATE config_form_fields SET dv_querytext = replace (dv_querytext, ' arc_type', ' cat_feature_arc') WHERE dv_querytext like'% arc_type%';
UPDATE config_form_fields SET dv_querytext = replace (dv_querytext, ' node_type', ' cat_feature_node') WHERE dv_querytext like'% node_type%';
UPDATE config_form_fields SET dv_querytext = replace (dv_querytext, ' connec_type', ' cat_feature_connec') WHERE dv_querytext like'% connec_type%';
UPDATE config_form_fields SET dv_querytext = replace (dv_querytext, ' gully_type', ' cat_feature_gully') WHERE dv_querytext like'% gully_type%';

UPDATE sys_param_user SET dv_querytext = replace (dv_querytext, ' arc_type', ' cat_feature_arc') WHERE dv_querytext like'% arc_type%';
UPDATE sys_param_user SET dv_querytext = replace (dv_querytext, ' node_type', ' cat_feature_node') WHERE dv_querytext like'% node_type%';
UPDATE sys_param_user SET dv_querytext = replace (dv_querytext, ' connec_type', ' cat_feature_connec') WHERE dv_querytext like'% connec_type%';
UPDATE sys_param_user SET dv_querytext = replace (dv_querytext, ' gully_type', ' cat_feature_gully') WHERE dv_querytext like'% gully_type%';

--arc
UPDATE config_form_fields SET layoutname = 'lyt_none' where columnname = 'arc_id' and formname like '%ve_arc_%';
UPDATE config_form_fields SET layoutname = 'lyt_none' where columnname = 'arc_id' and formname like '%v_edit_arc%';
UPDATE config_form_fields SET placeholder = NULL where formname like '%v_edit_arc%';
UPDATE config_form_fields SET placeholder = NULL where formname like '%ve_arc%';
UPDATE config_form_fields SET layoutorder = layoutorder +1  where (formname ilike 've_arc%' or formname='v_edit_arc') AND 
layoutname='lyt_data_2' and layoutorder > 12 and columnname!='fluid_type';

--node
UPDATE config_form_fields SET layoutname = 'lyt_none' where columnname = 'node_id' and formname like '%ve_node_%';
UPDATE config_form_fields SET layoutname = 'lyt_none' where columnname = 'node_id' and formname like '%v_edit_node%';
UPDATE config_form_fields SET placeholder = NULL where formname like '%v_edit_node%';
UPDATE config_form_fields SET placeholder = NULL where formname like '%ve_node%';

--connec
UPDATE config_form_fields SET layoutname = 'lyt_none' where columnname = 'connec_id' and formname like '%ve_connec_%';
UPDATE config_form_fields SET layoutname = 'lyt_none' where columnname = 'connec_id' and formname like '%v_edit_connec%';
UPDATE config_form_fields SET layoutname = 'lyt_top_1', layoutorder = 9 where columnname = 'arc_id' and formname like '%ve_connec_%';
UPDATE config_form_fields SET layoutname = 'lyt_top_1', layoutorder = 9 where columnname = 'arc_id' and formname like '%v_edit_connec%';
update config_form_fields SET layoutorder = 1 where columnname = 'soilcat_id' and formname like '%ve_connec_%';
update config_form_fields SET layoutorder = 1 where columnname = 'soilcat_id' and formname like '%v_edit_connec%';
UPDATE config_form_fields SET placeholder = NULL where formname like '%v_edit_connec%';
UPDATE config_form_fields SET placeholder = NULL where formname like '%ve_connec%';

--gully
UPDATE config_form_fields SET layoutname = 'lyt_none' where columnname = 'gully_id' and formname like '%ve_gully_%';
UPDATE config_form_fields SET layoutname = 'lyt_none' where columnname = 'gully_id' and formname like '%v_edit_gully%';
UPDATE config_form_fields SET layoutname = 'lyt_top_1', layoutorder = 9 where columnname = 'arc_id' and formname like '%ve_gully_%';
UPDATE config_form_fields SET layoutname = 'lyt_top_1', layoutorder = 9 where columnname = 'arc_id' and formname like '%v_edit_gully%';
update config_form_fields SET layoutorder = 1 where columnname = 'soilcat_id' and formname like '%ve_gully_%';
update config_form_fields SET layoutorder = 1 where columnname = 'soilcat_id' and formname like '%ve_gully_%';
UPDATE config_form_fields SET placeholder = NULL where formname like '%v_edit_gully%';
UPDATE config_form_fields SET placeholder = NULL where formname like '%ve_gully%';

UPDATE cat_feature_node SET isexitupperintro = 1 WHERE id = 'CIRC_MANHOLE';

UPDATE config_form_fields SET widgettype = 'typeahead',
dv_querytext = 'SELECT id, id as idval FROM cat_grate WHERE id IS NOT NULL' FROM cat_feature WHERE 
system_id = 'NETGULLY' AND formname = child_layer and columnname = 'gratecat_id';

--placeholder
UPDATE config_form_fields SET placeholder = 'Only when state is obsolete' where columnname = 'workcat_id_end';
UPDATE config_form_fields SET placeholder = 'Catalog of the private part of connection' where columnname = 'private_connecat_id' AND formname like '%ve_connec%';

DELETE FROM config_info_layer_x_type where tableinfo_id = 'v_edit_om_visit';

UPDATE config_param_system SET value = 'false' WHERE parameter = 'admin_utils_schema';

UPDATE config_info_layer SET addparam = '{"forceWhenActive":true}' WHERE layer_id IN ('v_edit_dimensions','v_edit_om_visit');

UPDATE config_param_system SET value = '{"activated" : "TRUE", "updateField" : "top_elev"}' WHERE parameter  = 'admin_raster_dem';

UPDATE gully SET siphon = false where siphon is null;
UPDATE gully SET groove = false where groove is null;
UPDATE gully SET publish = true where publish is null;
UPDATE gully SET uncertain = false where uncertain is null;

UPDATE gully SET connec_arccat_id = 'PVC-CC025_D' where connec_arccat_id is null;
UPDATE gully SET fluid_type = 'St. Fluid' where fluid_type is null;
UPDATE gully SET location_type = 'St. Location' where location_type is null;
UPDATE gully SET function_type = 'St. Function' where function_type is null;
UPDATE gully SET category_type = 'St. Category' where category_type is null;
UPDATE gully SET builtdate = '2017-12-05' where builtdate is null;
UPDATE gully SET category_type = 'St. Category' where category_type is null;

UPDATE gully SET top_elev= 46.4, ymax=0.8, sandbox=0 WHERE gully_id = '100013';
UPDATE gully SET code = '100012', top_elev= 47.4, ymax=0.8, sandbox=0 WHERE gully_id = '100012';

INSERT INTO cat_dscenario VALUES (1, 'Demo1', 'Demo1', NULL, 'OTHER');
INSERT INTO cat_dscenario VALUES (2, 'Demo2', 'Demo2', NULL, 'OTHER');
INSERT INTO cat_dscenario VALUES (3, 'Demo3', 'Demo3', NULL, 'OTHER');

INSERT INTO inp_dscenario_conduit VALUES (1,'242', 'CC100', 'PEAD', 2, null, 0.1, 0.1, 0.1);
INSERT INTO inp_dscenario_conduit VALUES (1,'217', 'CC100', 'Concret', 0.016, 2, null,0.1, 0.1, 0.1);
INSERT INTO inp_dscenario_conduit VALUES (1,'175', 'CC060', 'Concret', null, 2, null,0.1, 0.1, 0.1);
INSERT INTO inp_dscenario_conduit VALUES (1,'216', 'CC040', NULL, 0.020, 2, null,0.1, 0.1, 0.1);

INSERT INTO inp_dscenario_junction VALUES (1,'235',1);
INSERT INTO inp_dscenario_junction VALUES (1,'250',1);
INSERT INTO inp_dscenario_junction VALUES (1,'301',1);
INSERT INTO inp_dscenario_junction VALUES (1,'50',1);

INSERT INTO inp_dscenario_raingage VALUES (1,'RG-01',null,null,null,null,'T10-5m');
INSERT INTO inp_dscenario_raingage VALUES (2,'RG-01',null,null,null,null,'T10-5m');
INSERT INTO inp_dscenario_raingage VALUES (3,'RG-01',null,null,null,null,'T10-5m');

DELETE FROM selector_inp_dscenario; -- delete selectors because of trigger on cat_dscenario it inserts

UPDATE inp_dwf SET value = 0.0001;

UPDATE config_param_user SET value = null WHERE value ='COVER' and parameter = 'edit_elementcat_vdefault';

UPDATE cat_feature_node SET double_geom = '{"activated":true,"value":4}' WHERE id IN ('SEWER_STORAGE');
UPDATE cat_feature_node SET double_geom = '{"activated":true,"value":2}' WHERE id IN ('REGISTER');
UPDATE cat_feature_gully SET double_geom = '{"activated":true,"value":1}' WHERE id = 'GULLY';

INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('om_visit_status_vdefault', '4', current_user) ON CONFLICT (parameter, cur_user) DO NOTHING;

SELECT setval('SCHEMA_NAME.urn_id_seq', gw_fct_setvalurn(),true);

UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json, 'sectorFromExpl', false) WHERE parameter = 'basic_selector_tab_exploitation';
UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json, 'explFromSector', false) WHERE parameter = 'basic_selector_tab_sector';
UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json,'explFromMacroexpl', false) WHERE parameter = 'basic_selector_tab_macroexploitation';

UPDATE config_param_user SET value = gw_fct_json_object_set_key(value::json, 'autoRepair', 'true'::boolean) WHERE parameter = 'inp_options_debug';
UPDATE sys_param_user SET vdefault = gw_fct_json_object_set_key(vdefault::json, 'autoRepair', 'true'::boolean) WHERE id = 'inp_options_debug';

UPDATE inp_flwreg_orifice SET nodarc_id = concat(node_id,'OR',order_id);
UPDATE inp_flwreg_weir SET nodarc_id = concat(node_id,'WE',order_id);
UPDATE inp_flwreg_outlet SET nodarc_id = concat(node_id,'OT',order_id);
UPDATE inp_flwreg_pump SET nodarc_id = concat(node_id,'PU',order_id);

UPDATE inp_flwreg_pump SET to_arc = '18966' WHERE node_id = '18828';

UPDATE arc SET pavcat_id = 'Asphalt';

UPDATE cat_arc SET connect_cost = 'N_CONNECTION';

INSERT INTO inp_lid VALUES ('BIO-RETENTION','BC');
INSERT INTO inp_lid VALUES ('VEGE-SWALE','VS');
INSERT INTO inp_lid VALUES ('RAIN-GARDEN','RG');
INSERT INTO inp_lid VALUES ('PAV-PERMEABLE','PP');
INSERT INTO inp_lid VALUES ('GREEN-ROOF','GR');
INSERT INTO inp_lid VALUES ('INFIL-TRENCH','IT');
INSERT INTO inp_lid VALUES ('RAIN-BARREL','RB');

INSERT INTO inp_lid_value VALUES (1,'GREEN-ROOF','SURFACE',3,0,0,0,0);
INSERT INTO inp_lid_value VALUES (2,'GREEN-ROOF','SOIL',3,0.5,0.1,0.05,1.2,2.4,0);
INSERT INTO inp_lid_value VALUES (4,'GREEN-ROOF','DRAINMAT',5,0.5,0);
INSERT INTO inp_lid_value VALUES (5,'PAV-PERMEABLE','SURFACE',3,0,0,0,0);
INSERT INTO inp_lid_value VALUES (6,'PAV-PERMEABLE','PAVEMENT',40,0.5,0.1,0.5,0);
INSERT INTO inp_lid_value VALUES (7,'PAV-PERMEABLE','STORAGE',30,0.5,0,0);
INSERT INTO inp_lid_value VALUES (8,'INFIL-TRENCH','SURFACE',3,0,0,0,0);
INSERT INTO inp_lid_value VALUES (9,'INFIL-TRENCH','STORAGE',30,0.5,0,0);
INSERT INTO inp_lid_value VALUES (10,'RAIN-GARDEN','SURFACE',3,0,0,0,0);
INSERT INTO inp_lid_value VALUES (11,'RAIN-GARDEN','SOIL',3,0.5,0.1,0.05,1.2,2.4,0);
INSERT INTO inp_lid_value VALUES (12,'VEGE-SWALE','SURFACE',3,0.5,0.03,0.5,0.5);
INSERT INTO inp_lid_value VALUES (14,'BIO-RETENTION','SURFACE',3,0,0,0,0);
INSERT INTO inp_lid_value VALUES (15,'BIO-RETENTION','SOIL',3,0.5,0.1,0.05,1.2,2.4,0);
INSERT INTO inp_lid_value VALUES (16,'BIO-RETENTION','STORAGE',30,0.5,0,0);
INSERT INTO inp_lid_value VALUES (17,'RAIN-BARREL','STORAGE',30,1,0,0);
INSERT INTO inp_lid_value VALUES (18,'RAIN-BARREL','DRAIN',5,0.5,0,6);

SELECT gw_fct_admin_schema_lastprocess($${"client":{"lang":"ES"},
"data":{"isNewProject":"FALSE", "projectType":"UD", "epsg":25831, "isSample":"TRUE"}}$$);

UPDATE config_param_system SET value = '{"usePsectors":false, "ignoreGraphanalytics":false, "ignoreEpa":false, "ignorePlan":false}'
WHERE parameter = 'admin_checkproject';

UPDATE connec SET pjoint_id = arc_id WHERE pjoint_type = 'ARC';
UPDATE gully SET pjoint_id = arc_id WHERE pjoint_type = 'ARC';

update link set exit_id = arc_id FROM connec where feature_id = connec_id and exit_type = 'ARC';
update link set exit_id = arc_id FROM gully where feature_id = gully_id and exit_type = 'ARC';

UPDATE arc SET node_sys_top_elev_1 = sys_top_elev FROM vu_node WHERE node_id = node_1;
UPDATE arc SET node_sys_elev_1 = sys_elev FROM vu_node WHERE node_id = node_1;
UPDATE arc SET node_sys_top_elev_2 = sys_top_elev FROM vu_node WHERE node_id = node_2;
UPDATE arc SET node_sys_elev_2 = sys_elev FROM vu_node WHERE node_id = node_2;
UPDATE arc SET nodetype_1 = node_type FROM vu_node WHERE node_id = node_1;
UPDATE arc SET nodetype_2 = node_type FROM vu_node WHERE node_id = node_2;

UPDATE link SET dma_id = c.dma_id, sector_id = c.sector_id FROM connec c WHERE feature_id = connec_id;
UPDATE link SET dma_id = c.dma_id, sector_id = c.sector_id FROM gully c WHERE feature_id = gully_id;

UPDATE inp_gully SET method = 'W_O' WHERE method = 'W/O';

UPDATE config_form_fields
SET widgetcontrols = '{"labelPosition": "top"}'
WHERE formname LIKE 've_%' AND (layoutname LIKE 'lyt_top%' OR layoutname LIKE 'lyt_bot%') AND widgetcontrols IS NULL;

UPDATE config_form_fields
SET widgetcontrols = jsonb_set(widgetcontrols::jsonb, '{labelPosition}', '"top"', true)
WHERE formname LIKE 've_%' AND (layoutname LIKE 'lyt_top%' OR layoutname LIKE 'lyt_bot%');

UPDATE config_param_user SET value='true' WHERE "parameter"='edit_plan_order_control' AND cur_user=current_user;

