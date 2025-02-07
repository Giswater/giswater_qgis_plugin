/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = 'SCHEMA_NAME', public, pg_catalog;

UPDATE config_param_system SET VALUE = '{"SECTOR":true, "PRESSZONE":true, "DQA":true, "MINSECTOR":true, "DMA":true}' WHERE parameter = 'utils_graphanalytics_status';

INSERT INTO sys_function VALUES (2888, 'gw_fct_fill_om_tables','ws','function','void','void','Create example visits (used on sample creation)','role_admin',false);
INSERT INTO sys_function VALUES (2918, 'gw_fct_fill_doc_tables','ws','function','void','void','Create example documents (used on sample creation)','role_admin',false);
UPDATE sys_function SET input_params ='void', return_type ='void' WHERE id =2888;
UPDATE sys_function SET input_params ='void', return_type ='void' WHERE id =2918;

INSERT INTO cat_users VALUES ('user1','user1');
INSERT INTO cat_users VALUES ('user2','user2');
INSERT INTO cat_users VALUES ('user3','user3');
INSERT INTO cat_users VALUES ('user4','user4');

INSERT INTO cat_manager (idval, expl_id, rolename, active) VALUES ('general manager', '{1,2}', '{role_master}', true);

INSERT INTO config_graph_mincut VALUES (113766);
INSERT INTO config_graph_mincut VALUES (113952);

INSERT INTO plan_psector_x_node VALUES (2, '1076', 1, 0, false, NULL, NULL, true);

INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, link_id, active) VALUES ('3103', '2087', 1, 0, false, 480, true);
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, link_id, active) VALUES ('3104', '2078', 1, 0, false, 479, true);
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, link_id, active) VALUES ('114461', '20851', 1, 1, true, 483, true);
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, link_id, active) VALUES ('114462', '20851', 1, 1, true, 484, true);

INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, link_id, active) VALUES ('3014', '2065', 2, 0, false, 473, true);
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, link_id, active) VALUES ('114463', '20651', 2, 1, true, 474, true);

UPDATE plan_psector_x_arc SET psector_id = 2 WHERE arc_id = '20651';

INSERT INTO plan_psector_x_arc VALUES (7, '2065', 2, 0, false, NULL, NULL, true);
INSERT INTO plan_psector_x_arc VALUES (8, '2085', 1, 0, false, NULL, NULL, true);
INSERT INTO plan_psector_x_arc VALUES (9, '2086', 1, 0, false, NULL, NULL, true);

INSERT INTO doc (id, "name", doc_type, "path", observ, "date", user_name, tstamp, the_geom) VALUES('Demo document 1', 'Demo document 1', 'OTHER', 'https://github.com/Giswater/docs/blob/master/user/manual_usuario_giswater3.doc', NULL, '2018-03-11 19:40:20.449', current_user, '2018-03-11 19:40:20.449', NULL);
INSERT INTO doc (id, "name", doc_type, "path", observ, "date", user_name, tstamp, the_geom) VALUES('Demo document 3', 'Demo document 2', 'OTHER', 'https://github.com/Giswater/giswater/blob/master-2.1/legal/Licensing.txt', NULL, '2018-03-14 17:09:59.762', current_user, '2018-03-14 17:09:59.762', NULL);
INSERT INTO doc (id, "name", doc_type, "path", observ, "date", user_name, tstamp, the_geom) VALUES('Demo document 2', 'Demo document 3', 'OTHER', 'https://github.com/Giswater/giswater/blob/master-2.1/legal/Readme.txt', NULL, '2018-03-14 17:09:19.852', current_user, '2018-03-14 17:09:19.852', NULL);

SELECT gw_fct_fill_doc_tables();
SELECT gw_fct_fill_om_tables();

INSERT INTO doc_x_visit (doc_id, visit_id)
SELECT
doc.id,
om_visit.id
FROM doc, om_visit;

INSERT INTO selector_hydrometer (state_id, cur_user) VALUES (1, current_user);

INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('hydrant_param_1','combo1','combo1');
INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('hydrant_param_1','combo2','combo2');
INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('hydrant_param_1','combo3','combo3');
INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('hydrant_param_1','combo4','combo4');

INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('pressmeter_param_1','1','combo1');
INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('pressmeter_param_1','2','combo2');
INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('pressmeter_param_1','3','combo3');

INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('shtvalve_param_1','1','combo1');
INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('shtvalve_param_1','2','combo2');
INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('shtvalve_param_1','3','combo3');
INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('shtvalve_param_1','4','combo4');

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"OUTFALL_VALVE"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"outfallvalve_param_1", "datatype":"text",
"widgettype":"text", "label":"Outvalve param_1","ismandatory":"False",
"active":"True", "iseditable":"True","layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"OUTFALL_VALVE"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"outfallvalve_param_2", "datatype":"boolean",
"widgettype":"check", "label":"Outvalve param_2","ismandatory":"False",
"active":"True", "iseditable":"True","layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"SHUTOFF_VALVE"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"shtvalve_param_1", "datatype":"text",
"widgettype":"combo", "label":"Shtvalve param_1","ismandatory":"False",
"active":"True", "iseditable":"True", "dv_isnullvalue":"True","layoutname":"lyt_data_1",
"dv_querytext":"SELECT id as id, idval as idval  FROM edit_typevalue WHERE typevalue='shtvalve_param_1'"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"SHUTOFF_VALVE"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"shtvalve_param_2", "datatype":"text",
"widgettype":"text", "label":"Shtvalve param_2","ismandatory":"False",
"active":"True", "iseditable":"True","layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"GREEN_VALVE"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"greenvalve_param_1", "datatype":"boolean",
"widgettype":"check", "label":"Gvalve param_1","ismandatory":"False",
"active":"True", "iseditable":"True","layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"GREEN_VALVE"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"greenvalve_param_2", "datatype":"text",
"widgettype":"text", "label":"Gvalve param_2","ismandatory":"False",
"active":"True", "iseditable":"True","layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"AIR_VALVE"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"airvalve_param_1", "datatype":"text",
"widgettype":"text", "label":"Airvalve param_1","ismandatory":"False",
"active":"True", "iseditable":"True","layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"AIR_VALVE"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"airvalve_param_2", "datatype":"integer",
"widgettype":"text", "label":"Airvalve param_2","ismandatory":"False",
"active":"True", "iseditable":"True","layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"CHECK_VALVE"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"checkvalve_param_1", "datatype":"integer",
"widgettype":"text", "label":"Check param_1","ismandatory":"False",
"active":"True", "iseditable":"True","layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"CHECK_VALVE"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"checkvalve_param_2", "datatype":"text",
"widgettype":"text", "label":"Check param_2","ismandatory":"False",
"active":"True", "iseditable":"True","layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"PIPE"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"pipe_param_1", "datatype":"text",
"widgettype":"text", "label":"Pipe param_1","ismandatory":"False",
"active":"True", "iseditable":"True","layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"PRESSURE_METER"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"pressmeter_param_1", "datatype":"text",
"widgettype":"combo", "label":"Pressmeter param_1","ismandatory":"False",
"active":"True", "iseditable":"True", "dv_isnullvalue":"True","layoutname":"lyt_data_1",
"dv_querytext":"SELECT id as id, idval as idval  FROM edit_typevalue WHERE typevalue='pressmeter_param_1'"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"PRESSURE_METER"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"pressmeter_param_2", "datatype":"date",
"widgettype":"datetime", "label":"Pressmeter param_2","ismandatory":"False",
"active":"True", "iseditable":"True","layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"FILTER"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"filter_param_1", "datatype":"integer",
"widgettype":"text", "label":"Filter param_1","ismandatory":"False",
"active":"True", "iseditable":"True","layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"FILTER"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"filter_param_2", "datatype":"text",
"widgettype":"text", "label":"Filter param_2","ismandatory":"False",
"active":"True", "iseditable":"True","layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"TANK"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"tank_param_1", "datatype":"integer",
"widgettype":"text", "label":"Tank param_1","ismandatory":"False",
"active":"True", "iseditable":"True","layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"TANK"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"tank_param_2", "datatype":"date",
"widgettype":"datetime", "label":"Tank param_2","ismandatory":"False",
"active":"True", "iseditable":"True","layoutname":"lyt_data_1"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"HYDRANT"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"hydrant_param_1", "datatype":"text",
"widgettype":"combo", "label":"Hydrant param_1","ismandatory":"False",
"active":"True", "iseditable":"True", "dv_isnullvalue":"True","layoutname":"lyt_data_1",
"dv_querytext":"SELECT id as id, idval as idval  FROM edit_typevalue WHERE typevalue='hydrant_param_1'"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"HYDRANT"},
"data":{"action":"CREATE", "multiCreate":"false", "parameters":{"columnname":"hydrant_param_2", "datatype":"integer",
"widgettype":"text", "label":"Hydrant param_2","ismandatory":"False",
"active":"True", "iseditable":"True","layoutname":"lyt_data_1"}}}$$);

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field) VALUES ('edit_typevalue','hydrant_param_1','man_node_hydrant','hydrant_param_1');
INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field) VALUES ('edit_typevalue','shtvalve_param_1','man_node_shutoff_valve','shtvalve_param_1');
INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field) VALUES ('edit_typevalue','pressmeter_param_1','man_node_pressure_meter','pressmeter_param_1');

-- rotate vnodes and connec labels
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('edit_link_connecrotation_update', TRUE, current_user) ON CONFLICT (parameter, cur_user) DO NOTHING;

--move closed and broken to the top of lyt_data_2
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=0 WHERE columnname = 'closed' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=1 WHERE columnname = 'broken' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=2 WHERE columnname = 'to_arc' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=3 WHERE columnname = 'arc_id' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=4 WHERE columnname = 'parent_id' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=5 WHERE columnname = 'soilcat_id' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=6 WHERE columnname = 'fluid_type' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=7 WHERE columnname = 'function_type' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=8 WHERE columnname = 'category_type' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=9 WHERE columnname = 'location_type' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=10 WHERE columnname = 'comment' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=11 WHERE columnname = 'num_value' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=12 WHERE columnname = 'svg' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=13 WHERE columnname = 'rotation' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=14 WHERE columnname = 'hemisphere' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=15 WHERE columnname = 'label' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=16 WHERE columnname = 'label_y' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=17 WHERE columnname = 'label_x' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=18 WHERE columnname = 'label_rotation' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=19 WHERE columnname = 'publish' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=20 WHERE columnname = 'undelete' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=21 WHERE columnname = 'inventory' AND formname like '%_valve';

-- hidden
UPDATE config_form_fields SET hidden = true WHERE columnname
IN ('undelete', 'publish', 'buildercat_id', 'comment', 'num_value', 'svg', 'macrodqa_id', 'macrosector_id',
'macroexpl_id', 'custom_length', 'staticpressure1', 'staticpressure2', 'pipe_param_1') and (formname ILIKE 've_arc%' or formname ILIKE 've_node%' or formname ILIKE 've_connec%');

UPDATE config_form_fields SET hidden = true WHERE columnname='arc_id' and formname LIKE 've_node_%';

UPDATE config_form_fields SET hidden = true WHERE columnname IN ('label_x', 'label_y') AND formname LIKE 've_arc%';

-- special changes for air_valve
UPDATE config_form_fields SET hidden=true WHERE columnname = 'to_arc' AND formname like '%air_valve';
UPDATE config_form_fields SET hidden=false WHERE columnname = 'arc_id' AND formname like '%air_valve';


-- reorder sample
UPDATE config_form_fields SET layoutorder =90, layoutname = 'lyt_data_1' WHERE columnname ='link' AND (formname not in ('v_edit_link'));;
UPDATE config_form_fields SET layoutorder =2 , layoutname ='lyt_bot_2' WHERE columnname ='verified';
UPDATE config_form_fields SET layoutorder =1 , layoutname ='lyt_bot_2' WHERE columnname ='sector_id' AND (formname not in ('v_edit_link'));;
UPDATE config_form_fields SET layoutorder =4 , layoutname ='lyt_bot_1' , label = 'Dqa' WHERE columnname ='dqa_id';
UPDATE config_form_fields SET layoutorder =70 , layoutname ='lyt_data_1' WHERE columnname ='macrosector_id' AND (formname not in ('v_edit_link'));;
UPDATE config_form_fields SET stylesheet ='{"label":"color:red; font-weight:bold"}' WHERE columnname IN ('expl_id', 'sector_id');

SELECT gw_fct_admin_manage_triggers('fk','ALL');

UPDATE config_param_user SET value = 'TRUE' WHERE parameter = 'audit_project_user_control';

UPDATE config_param_system SET value = '{"SECTOR":true, "DMA":true, "PRESSZONE":true, "DQA":true, "MINSECTOR":true}'
WHERE parameter = 'om_dynamicmapzones_status';

UPDATE element SET code = concat ('E',element_id);

UPDATE config_graph_mincut SET parameters = '{"inletArc":["113907", "113905"]}'
WHERE node_id = '113766';

UPDATE config_graph_mincut SET parameters = '{"inletArc":["114145"]}'
WHERE node_id = '113952';

UPDATE config_form_fields SET label = 'Presszone' WHERE columnname = 'presszone_id';

update config_form_fields SET layoutorder = 3 where columnname='state' and formname like '%ve_connec_%';
update config_form_fields SET layoutorder = 4 where columnname='state_type' and formname like '%ve_connec_%';

--refactor of forms
UPDATE config_form_fields SET layoutname = 'lyt_data_3', layoutorder = 11 where columnname ='pjoint_id';
UPDATE config_form_fields SET layoutname = 'lyt_data_3', layoutorder = 12 where columnname ='pjoint_type';
UPDATE config_form_fields SET layoutname = 'lyt_data_3', layoutorder = 13 where columnname ='descript';
UPDATE config_form_fields SET layoutname = 'lyt_data_3', layoutorder = 14 where columnname = 'annotation';
UPDATE config_form_fields SET layoutname = 'lyt_data_3', layoutorder = 15 where columnname = 'observ' AND formname <> 'v_edit_dimensions';
UPDATE config_form_fields SET layoutname = 'lyt_data_3', layoutorder = 16 where columnname = 'lastupdate';
UPDATE config_form_fields SET layoutname ='lyt_data_3' , layoutorder = 17 where columnname = 'lastupdate_user';
UPDATE config_form_fields SET layoutname = 'lyt_data_3', layoutorder = 18 where columnname ='link';

UPDATE config_form_fields SET  hidden = true where columnname = 'macrodma_id';
UPDATE config_form_fields SET  hidden = true where columnname = 'inventory';
UPDATE config_form_fields SET  hidden = true where columnname = 'feature_id' AND (formname not in ('v_edit_link'));;
UPDATE config_form_fields SET  hidden = true where columnname = 'featurecat_id';
UPDATE config_form_fields SET  hidden = true where columnname = 'connec_length';

UPDATE config_form_fields SET  hidden = true where columnname = 'depth' AND formname LIKE '%_connec_%';
UPDATE config_form_fields SET  hidden = true where columnname = 'function_type' AND formname LIKE '%_connec_%';
UPDATE config_form_fields SET  hidden = true where columnname = 'descript' AND formname LIKE '%_connec_%';
UPDATE config_form_fields SET  hidden = true where columnname = 'annotation' AND formname LIKE '%_connec_%';

UPDATE config_form_fields SET layoutname = 'lyt_bot_1' where columnname ='state' AND (formname not in ('v_edit_link','v_edit_dimensions','mincut_manager'));
UPDATE config_form_fields SET layoutname = 'lyt_bot_1' where columnname ='state_type';
UPDATE config_form_fields SET layoutname = 'lyt_bot_1' where columnname ='sector_id' AND (formname not in ('v_edit_link','v_edit_dimensions'));
UPDATE config_form_fields SET layoutname = 'lyt_data_1',layoutorder = 997 where columnname ='hemisphere';
UPDATE config_form_fields SET layoutorder = 2 where columnname ='dma_id' AND (formname not in ('v_edit_link','v_edit_dimensions'));


UPDATE config_form_fields SET layoutname = 'lyt_data_2', layoutorder = 30 where columnname ='verified' AND (formname LIKE '%_connec_%' OR formname LIKE '%_node_%' OR formname LIKE '%_arc_%');
UPDATE config_form_fields SET layoutname = 'lyt_data_2', layoutorder = 31 where columnname ='presszone_id' AND (formname LIKE '%_connec_%' OR formname LIKE '%_node_%' OR formname LIKE '%_arc_%');
UPDATE config_form_fields SET layoutname = 'lyt_data_2', layoutorder = 32 where columnname ='dqa_id' AND (formname LIKE '%_connec_%' OR formname LIKE '%_node_%' OR formname LIKE '%_arc_%');
UPDATE config_form_fields SET layoutname = 'lyt_data_2', layoutorder = 33 where columnname ='expl_id' AND (formname not in ('v_edit_link','v_edit_dimensions'));
UPDATE config_form_fields SET layoutname = 'lyt_data_1', layoutorder = 998 where columnname ='parent_id' AND (formname LIKE '%_connec_%' OR formname LIKE '%_node_%' OR formname LIKE '%_arc_%');


-- refactor of type's
UPDATE man_type_fluid SET fluid_type = replace (fluid_type, 'Standard', 'St.');
UPDATE man_type_category SET category_type = replace (category_type, 'Standard', 'St.');
UPDATE man_type_location SET location_type = replace (location_type, 'Standard', 'St.');
UPDATE man_type_function SET function_type = replace (function_type, 'Standard', 'St.');

update config_form_fields SET widgettype = 'text' WHERE columnname  = 'macrosector_id' AND dv_querytext = null;

UPDATE v_edit_node SET nodecat_id = 'CHK-VALVE100-PN16' WHERE node_id = '1092';

--add tooltips for specific fields
UPDATE config_form_fields SET tooltip = 'broken - Para establecer si la válvula esta rota o no' WHERE columnname = 'broken' AND tooltip IS NULL;
UPDATE config_form_fields SET tooltip = 'buried - Para establecer si la válvula esta enterrada o no' WHERE columnname = 'buried' AND tooltip IS NULL;
UPDATE config_form_fields SET tooltip = 'cat_valve2 - Catálogo para una segunda válvula en el mismo elemento' WHERE columnname = 'cat_valve2' AND tooltip IS NULL;
UPDATE config_form_fields SET tooltip = 'closed - Para establecer si la válvula se encuentra cerrada o no' WHERE columnname = 'closed' AND tooltip IS NULL;
UPDATE config_form_fields SET tooltip = 'depth_valveshaft - Profundidad del eje de la válvula' WHERE columnname = 'depth_valveshaft' AND tooltip IS NULL;
UPDATE config_form_fields SET tooltip = 'drive_type - Tipo de conducción para desague' WHERE columnname = 'drive_type' AND tooltip IS NULL;
UPDATE config_form_fields SET tooltip = 'exit_code - Identificador del elemento dónde desagua' WHERE columnname = 'exit_code' AND tooltip IS NULL;
UPDATE config_form_fields SET tooltip = 'exit_type - Tipo de salida para desague' WHERE columnname = 'exit_type' AND tooltip IS NULL;
UPDATE config_form_fields SET tooltip = 'irrigation_indicator - Para establecer si tiene indicador de riego o no' WHERE columnname = 'irrigation_indicator' AND tooltip IS NULL;
UPDATE config_form_fields SET tooltip = 'lin_meters - Longitud del desague en metros' WHERE columnname = 'lin_meters' AND tooltip IS NULL;
UPDATE config_form_fields SET tooltip = 'pression_entry - Pressión de entrada (habitualmente en  kg/cm2)' WHERE columnname = 'pression_entry' AND tooltip IS NULL;
UPDATE config_form_fields SET tooltip = 'pression_exit - Pressión de salida (habitualmente en  kg/cm2)' WHERE columnname = 'pression_exit' AND tooltip IS NULL;
UPDATE config_form_fields SET tooltip = 'regulator_location - Localización concreta de la válvula de regulación' WHERE columnname = 'regulator_location' AND tooltip IS NULL;
UPDATE config_form_fields SET tooltip = 'regulator_observ - Observaciones asociadas a la válvula de regulación' WHERE columnname = 'regulator_observ' AND tooltip IS NULL;
UPDATE config_form_fields SET tooltip = 'regulator_situation - Calle dónde de situa la válvula de regulación' WHERE columnname = 'regulator_situation' AND tooltip IS NULL;
UPDATE config_form_fields SET tooltip = 'arq_patrimony - Para establecer si la fuente es patrimonio arquitectónico o no' WHERE columnname = 'arq_patrimony' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'chlorinator - Para establecer si tiene clorador o no' WHERE columnname = 'chlorinator' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'container_number - Número de contenedores de agua de la fuente' WHERE columnname = 'container_number' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'linked_connec - Identificador de la acometida asociada' WHERE columnname = 'linked_connec' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'power - Potencia total' WHERE columnname = 'power' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'pump_number - Número de bombas' WHERE columnname = 'pump_number' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'regulation_tank - Para establecer la existencia o no de un depósito de regulación' WHERE columnname = 'regulation_tank' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'vmax - Volumen máximo' WHERE columnname = 'vmax' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'vtotal - Volumen total' WHERE columnname = 'vtotal' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'communication - Para establecer si se ha comunicado la información del hidrante' WHERE columnname = 'communication' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'fire_code - Código para bomberos' WHERE columnname = 'fire_code' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'valve - Válvula vinculada con el hidrante' WHERE columnname = 'valve' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'serial_number - Número de serie del elemento' WHERE columnname = 'serial_number' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'lab_code - Código para laboratorio' WHERE columnname = 'lab_code' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'elev_height - Altura de la bomba' WHERE columnname = 'elev_height' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'max_flow - Flujo máximo' WHERE columnname = 'max_flow' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'min_flow - Flujo mínimo' WHERE columnname = 'min_flow' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'nom_flow - Flujo óptimo' WHERE columnname = 'nom_flow' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'pressure - Pressión' WHERE columnname = 'pressure' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'diam1 - Diámetro inicial' WHERE columnname = 'diam1' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'diam2 - Diámetro final' WHERE columnname = 'diam2' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'area - Área del depósito en m2' WHERE columnname = 'area' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'chlorination - Para establecer si tiene clorador o no' WHERE columnname = 'chlorination' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'vutil - Volumen útil' WHERE columnname = 'vutil' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'cat_valve - Catálogo de la válvula asociada' WHERE columnname = 'cat_valve' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'com_state - Para establecer si se ha comunicado o no si el agua es potable' WHERE columnname = 'com_state' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'drain_diam - Diámetro del tubo de drenaje' WHERE columnname = 'drain_diam' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'drain_distance - Distancia del desague' WHERE columnname = 'drain_distance' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'drain_exit - Tipo de salida del desague' WHERE columnname = 'drain_exit' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'drain_gully - Identificador de la reja de desague' WHERE columnname = 'drain_gully' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'customer_code - Código comercial' WHERE columnname = 'customer_code' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'top_floor - Número máximo de plantas del edificio a abastecer' WHERE columnname = 'top_floor' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'pol_id - Identificador del polígono relacionado' WHERE columnname = 'pol_id' AND tooltip IS NULL AND formtype='feature';
UPDATE config_form_fields SET tooltip = 'name - Nombre específico del elemento' WHERE columnname = 'name' AND tooltip IS NULL AND formtype='feature';

UPDATE ext_rtc_dma_period SET minc = null, maxc = null, pattern_volume = 32;

UPDATE v_edit_arc SET arccat_id = 'VIRTUAL' WHERE arc_type = 'VARC';

UPDATE cat_mat_roughness set roughness  = 0.003;
DELETE FROM cat_arc WHERE arc_type = 'VARC' AND id !='VIRTUAL';

UPDATE config_form_fields SET dv_querytext_filterc  = ' AND id '
WHERE formname IN ('upsert_catalog_node', 'upsert_catalog_arc', 'upsert_catalog_connec') AND columnname ='matcat_id' AND dv_parent_id IS NOT NULL;

UPDATE config_param_system SET value='TRUE' WHERE parameter='sys_raster_dem';

INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('edit_insert_elevation_from_dem', 'true', current_user)
ON CONFLICT (parameter, cur_user) DO NOTHING;

INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('edit_update_elevation_from_dem', 'true', current_user)
ON CONFLICT (parameter, cur_user) DO NOTHING;

UPDATE config_param_user SET value = 'TRUE' WHERE parameter = 'qgis_form_docker' AND cur_user = current_user;

UPDATE config_form_fields SET  layoutname = 'lyt_top_1' where columnname = 'arc_id'AND formname LIKE '%_arc_%' and formname not LIKE 'visit_arc_%';

UPDATE config_form_fields SET layoutorder = 20 where columnname ='minsector_id' and formname like '%_node_%';
UPDATE config_form_fields SET layoutorder = 23 where columnname ='rotation' and formname like '%_node_%';
UPDATE config_form_fields SET layoutorder = 24 where columnname ='svg' and formname like '%_node_%';

UPDATE config_form_fields SET layoutorder = 20 where columnname ='minsector_id'and formname like '%_connec_%';
UPDATE config_form_fields SET layoutorder = 23 where columnname ='rotation'and formname like '%_connec_%';
UPDATE config_form_fields SET layoutorder = 24 where columnname ='svg' and formname like '%_connec_%';

UPDATE config_form_fields set layoutorder = layoutorder+1 WHERE (formname ilike 've_arc_%' or
 formname ilike 've_node_%' or  formname ilike  've_connec_%')
AND columnname in ('streetname','streetname2', 'postnumber','postnumber2','postcomplement','postcomplement2');

UPDATE config_form_fields set hidden = false  WHERE (formname in ('ve_arc', 've_node', 've_connec')
or (formname ilike 've_arc_%' or  formname ilike 've_node_%' or  formname ilike  've_connec_%'))
AND columnname = 'district_id';

UPDATE config_form_fields set layoutorder = 2 WHERE (formname in ('ve_node', 've_connec')
or  (formname ilike 've_node_%' or  formname ilike  've_connec_%')) AND columnname = 'district_id';

UPDATE config_form_fields set layoutorder = 3 WHERE (formname in ('ve_arc') or (formname ilike 've_arc_%')) AND columnname = 'district_id';

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

--placeholders
UPDATE config_form_fields SET placeholder = 'Only when state is obsolete' where columnname = 'workcat_id_end';
UPDATE config_form_fields SET placeholder = 'Top floor of the building (ex: 3)' where columnname = 'top_floor' AND formname like '%ve_connec%';
UPDATE config_form_fields SET placeholder = 'Optional: Arc_id of related arc' where columnname = 'arc_id' AND formname like '%ve_node%';
UPDATE config_form_fields SET placeholder = 'Optional: Node_id of the parent node' where columnname = 'parent_id' AND formname like '%ve_node%';


-- 2020/12/07
UPDATE sys_param_user SET vdefault ='{"reservoir":{"switch2Junction":["WTP", "WATERWELL", "SOURCE"]},
"tank":{"distVirtualReservoir":0.01}, 
"pressGroup":{"status":"ACTIVE", "forceStatus":"ACTIVE", "defaultCurve":"GP30"}, 
"pumpStation":{"status":"CLOSED", "forceStatus":"CLOSED", "defaultCurve":"IM00"}, 
"PRV":{"status":"ACTIVE", "forceStatus":"ACTIVE", "pressure":"30"}, 
"PSV":{"status":"ACTIVE", "forceStatus":"ACTIVE", "pressure":"30"}
}'
WHERE id = 'inp_options_buildup_supply';


UPDATE config_param_system SET value = 'false' WHERE parameter = 'admin_utils_schema';

UPDATE config_info_layer SET addparam = '{"forceWhenActive":true}' WHERE layer_id IN ('v_edit_dimensions','v_edit_om_visit');

UPDATE config_param_system SET value = '{"activated" : "TRUE", "updateField" : "top_elev"}' WHERE parameter  = 'admin_raster_dem';

INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('om_visit_status_vdefault', '4', current_user) ON CONFLICT (parameter, cur_user) DO NOTHING;

-- fill missed data for connecs
UPDATE v_edit_connec SET epa_type = 'JUNCTION';
UPDATE connec SET epa_type = 'UNDEFINED' where epa_type is null;
ALTER TABLE connec ALTER COLUMN epa_type SET NOT NULL;

UPDATE cat_mat_roughness SET roughness = 0.0025 WHERE matcat_id IN ('PVC', 'PE-HD', 'PE-LD');
UPDATE cat_mat_roughness SET roughness = 0.025 WHERE matcat_id IN ('FC');

SELECT setval('SCHEMA_NAME.urn_id_seq', gw_fct_setvalurn(),true);

INSERT INTO config_param_user VALUES ('edit_pavement_vdefault','Asphalt',current_user);

INSERT INTO plan_arc_x_pavement (arc_id, pavcat_id, percent) VALUES ('2001', 'Slab', 0.5);
INSERT INTO plan_arc_x_pavement (arc_id, pavcat_id, percent) VALUES ('2001', 'Concrete', 0.5);

SELECT gw_fct_admin_schema_lastprocess($${"client":{"lang":"ES"},
"data":{"isNewProject":"FALSE", "projectType":"WS", "epsg":25831, "isSample":"TRUE"}}$$);

INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('1', '10240C', NULL, 'Calle de la Mare de Deu de Montserrat', NULL, '0105000020E7640000010000000102000000140000001B100C6B6A991941DFEB69D952755141E2F80131EA981941D1D777B5497551414AF890C3B898194130F24C4346755141AE94C41E9F9819413053B08B44755141F03517FF84981941D99C90DB42755141E2C0688540981941021414F13E755141820FFC619D97194157F27B0136755141A726769C7297194106F1BEA9337551419CB6B622489719415088454D317551416B2475C13E971941AE0BA4CF30755141387077EB349719418E27F259307551418FBBEEA82A9719414B50C3EC2F75514107DD2A07209719414EFAAA882F7551410787751215971941AA372C2E2F755141FB6B18D709971941FF55A9DD2E75514191626362FE96194157DE63972E7551414E9CD147EF961941C817DF4C2E75514124CC840ED7961941A2C128182E7551418CAFC115BB961941A79349F82D755141A6CB3FA438961941D8E10D682E755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('2', '10222C', NULL, 'Calle de Menorca', NULL, '0105000020E7640000010000000102000000020000005D078893C89219412E2FCA23A17551413CAC9708CB9119411C0093E588755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('3', '9120C', NULL, 'Calle de Narcis Monturiol', NULL, '0105000020E764000001000000010200000002000000800E100D9D921941217BA4DD677551414C31EF5247921941982B5D944D755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('4', '10120C', NULL, 'Calle de Galicia', NULL, '0105000020E76400000100000001020000000200000010EEF0EDDB9419419ABAFD8060755141BCE65DF967941941DA65B2893D755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('5', '10110C', NULL, 'Calle de Federico Garcia Lorca', NULL, '0105000020E7640000010000000102000000140000002CE506F7F39419415A28873A3E7551413F1567D4D494194137F48E0434755141ABAFC137D39419413D280F8733755141654E216AD1941941EA825E0A33755141441BE06BCF94194178D28A8E327551411940583DCD94194113E5A11332755141BFE6E3DECA941941F188B199317551410E39DD50C8941941458CC72031755141D9609E93C594194147BDF1A830755141F78781A7C29419411DEA3D323075514142D8E08CBF94194106E1B9BC2F7551418E7B1644BC9419412E7073482F755141B39B7CCDB8941941C96578D52E75514187626D29B59419410B90D6632E755141E3F94258B194194127BD9BF32D7551419A8B575AAD94194150BBD5842D75514184410530A9941941B75892172D7551417945A6D9A49419419063DFAB2C755141C145A6D9A49419418D63DFAB2C755141EA8DCDC4D2931941273B8CF318755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('6', '9110C', NULL, 'Calle de Josep Trueta', NULL, '0105000020E764000001000000010200000002000000BF04B100CB9219412566A62A487551413468CCBDBF9119417157E5072F755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('7', '11011C', NULL, 'Calle de Salvador Seguí', NULL, '0105000020E76400000100000001020000000300000090AA14799F961941F6BB84D4777551414219E1DA5F96194151BDE6C25E755141F60D831258961941ECDBCDB15B755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('8', '11011C', NULL, 'Calle de Salvador Seguí', NULL, '0105000020E764000001000000010200000003000000F60D831258961941ECDBCDB15B75514119F927FB55961941343BC69758755141B33E760F44961941F92064033E755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('9', '11011C', NULL, 'Calle de Salvador Seguí', NULL, '0105000020E764000001000000010200000003000000B33E760F44961941F92064033E75514149DD61FC419619412624B4EF3A755141A6CB3FA438961941D8E10D682E755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('10', '11011C', NULL, 'Calle de Salvador Seguí', NULL, '0105000020E764000001000000010200000002000000A6CB3FA438961941D8E10D682E755141286A6F7E12961941473470D5F7745141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('11', '10000C', NULL, 'Ronda de Sant Ramon', NULL, '0105000020E76400000100000001020000002300000062E62BFDBC911941523E6A1AAF755141CCE42BFDBC911941423E6A1AAF755141D4493088BF91194125A5C2D6AE755141AB038821C29119411CECB793AE755141601A14C9C49119413F234C51AE755141FE95B57EC7911941A85A810FAE755141917E4D42CA91194173A259CEAD75514120DCBC13CD911941B20AD78DAD755141BCB6E4F2CF91194183A3FB4DAD7551416C16A6DFD2911941FC7CC90EAD7551413C03E2D9D59119413AA742D0AC755141368579E1D89119414D326992AC75514169A44DF6DB911941532E3F55AC755141DA683F18DF91194168ABC618AC7551419BDA2F47E2911941A0B901DDAB755141B2010083E59119411469F2A1AB7551412CE690CBE8911941DEC99A67AB7551411590C320EC91194116ECFC2DAB75514174077982EF911941D4DF1AF5AA7551415A5492F0F291194132B5F6BCAA755141D07EF06AF6911941497C9285AA755141E08E74F1F99119413045F04EAA755141958CFF83FD91194100201219AA755141FB7F722201921941D21CFAE3A97551411B71AECC04921941BF4BAAAFA97551410268948208921941E0BC247CA9755141BC6C05440C9219414A806B49A97551415387E210109219411FA68017A9755141D3BF0CE9139219416E3E66E6A8755141441E65CC1792194152591EB6A8755141B6AACCBA1B921941E506AB86A8755141316D24B41F92194143570E58A8755141C06D4DB8239219417D5A4A2AA875514170B428C727921941B12061FDA77551415D078893C89219412E2FCA23A1755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('12', '10000C', NULL, 'Ronda de Sant Ramon', NULL, '0105000020E764000001000000010200000003000000E09D7E3A2B941941D9A68927927551419619A4F4899519415ED072658375514190AA14799F961941F6BB84D477755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('13', '10000C', NULL, 'Ronda de Sant Ramon', NULL, '0105000020E76400000100000001020000000400000090AA14799F961941F6BB84D4777551419F37A4F7489719418D1ECB84707551410DEDAD31D0971941E3C34E6F69755141E6D9A197879819418D3FA3515F755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('14', '10000C', NULL, 'Ronda de Sant Ramon', NULL, '0105000020E764000001000000010200000002000000E6D9A197879819418D3FA3515F7551411B100C6B6A991941DFEB69D952755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('15', '10000C', NULL, 'Ronda de Sant Ramon', NULL, '0105000020E7640000010000000102000000050000001B100C6B6A991941DFEB69D952755141FFED9533AE991941CDB6D44A4F755141CA5F099EC099194143BF686B4E755141941BDC47029A1941679266854B755141D0665324279B1941EF8568543F755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('16', '10000C', NULL, 'Ronda de Sant Ramon', NULL, '0105000020E7640000010000000102000000020000005D078893C89219412E2FCA23A1755141E09D7E3A2B941941D9A6892792755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('17', '9150C', NULL, 'Avenida de la Torre de la Vila', NULL, '0105000020E764000001000000010200000007000000D0665324279B1941EF8568543F755141DE2CF73C6B9A194180F66EFD34755141A1618D4689991941F9F95F8328755141CD79AB21DB981941A9AADCF41E755141A4060C86F19719418B40D836127551411A5C5476BB961941CC8CE52B01755141286A6F7E12961941473470D5F7745141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('18', '9150C', NULL, 'Avenida de la Torre de la Vila', NULL, '0105000020E764000001000000010200000002000000286A6F7E12961941473470D5F77451416C9A075CC99519415751C7CAF3745141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('19', '10100C', NULL, 'Calle Legalitat', NULL, '0105000020E764000001000000010200000005000000B7370B5483901941F2C101E75E755141CD9EAC72A7901941F07410645E7551419166F054B79019416C97B6075E7551414EF2115CC6901941AC2896875D7551414C31EF5247921941982B5D944D755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('20', '10100C', NULL, 'Calle Legalitat', NULL, '0105000020E7640000010000000102000000020000004C31EF5247921941982B5D944D755141BF04B100CB9219412566A62A48755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('21', '10100C', NULL, 'Calle Legalitat', NULL, '0105000020E764000001000000010200000006000000BF04B100CB9219412566A62A487551416C1029506F931941BE13389A417551412DE90DA3839319413B2F010141755141B8FFF922A3931941F8ACAB4240755141D23DC4A93B9419418168090A3E755141BCE65DF967941941DA65B2893D755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('22', '10100C', NULL, 'Calle Legalitat', NULL, '0105000020E764000001000000010200000002000000BCE65DF967941941DA65B2893D7551412CE506F7F39419415A28873A3E755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('23', '10100C', NULL, 'Calle Legalitat', NULL, '0105000020E7640000010000000102000000030000002CE506F7F39419415A28873A3E7551413C8DCAEF4995194129C91FA73E755141B33E760F44961941F92064033E755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('24', '11000C', NULL, 'Avenida del General Prim', NULL, '0105000020E764000001000000010200000003000000E6D9A197879819418D3FA3515F7551415A87A044B196194108E22BE85B755141F60D831258961941ECDBCDB15B755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('25', '11000C', NULL, 'Avenida del General Prim', NULL, '0105000020E764000001000000010200000002000000F60D831258961941ECDBCDB15B75514110EEF0EDDB9419419ABAFD8060755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('26', '11000C', NULL, 'Avenida del General Prim', NULL, '0105000020E76400000100000001020000000200000010EEF0EDDB9419419ABAFD8060755141309A57A831931941977E6CF965755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('27', '11000C', NULL, 'Avenida del General Prim', NULL, '0105000020E764000001000000010200000002000000309A57A831931941977E6CF965755141800E100D9D921941217BA4DD67755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('28', '11000C', NULL, 'Avenida del General Prim', NULL, '0105000020E764000001000000010200000002000000800E100D9D921941217BA4DD677551418DA0BB7289901941FAACF9B96E755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('29', '10230C', NULL, 'Calle de Francesc Layret', NULL, '0105000020E764000001000000010200000004000000E09D7E3A2B941941D9A6892792755141903A2D02959319416344324884755141F62A94128E9319413487A7738375514178CDD6728C931941E4C12A3483755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('30', '10230C', NULL, 'Calle de Francesc Layret', NULL, '0105000020E76400000100000001020000000400000078CDD6728C931941E4C12A3483755141F23B2DD688931941BC3E04938275514100AD85648593194118A9A8AB81755141309A57A831931941977E6CF965755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('31', '10220C', NULL, 'Calle de Salvador Espriu', NULL, '0105000020E76400000100000001020000000300000078CDD6728C931941E4C12A3483755141FCFC6E08CB911941101E8FE5887551418D9F5708CB9119412A6A8FE588755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('32', '10220C', NULL, 'Calle de Salvador Espriu', NULL, '0105000020E7640000010000000102000000020000008D9F5708CB9119412A6A8FE588755141296CDFA595901941385F3AD58C755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('33', '9100C', NULL, 'Avenida de Aragó', NULL, '0105000020E76400000100000001020000000F00000062E62BFDBC911941523E6A1AAF755141305BD9D090911941F29C07B9AD7551416EA023D66E91194151CDBEFAAC755141B898EE6435911941D1200EC9AB755141366233181A9119418DA4681DAB755141CFD48F4F00911941872D693DAA755141D0E0659BE8901941C320A12EA97551418ECC1FE4DF9019411ADD07A5A875514130059D7FCB9019411B8CEE24A77551418BC6CFD2BA901941292C1A95A57551414B630485AF90194148B0E138A4755141B3D14439A59019411F43992CA275514140DFBD4C9F901941E44D0D0DA075514190B30758999019416CCECB6396755141296CDFA595901941385F3AD58C755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('34', '9100C', NULL, 'Avenida de Aragó', NULL, '0105000020E764000001000000010200000002000000296CDFA595901941385F3AD58C7551418DA0BB7289901941FAACF9B96E755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('35', '9100C', NULL, 'Avenida de Aragó', NULL, '0105000020E7640000010000000102000000020000008DA0BB7289901941FAACF9B96E755141B7370B5483901941F2C101E75E755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('36', '9100C', NULL, 'Avenida de Aragó', NULL, '0105000020E764000001000000010200000016000000B7370B5483901941F2C101E75E755141A3A2A9167890194122FF4CC03F75514111A5946879901941CEE8D0703E755141C8E497697E901941192E92433D75514180B2A04083901941E0BDC7C93C7551413C7B998E84901941071FADA73C755141321F5FEB85901941860539863C755141EB10AD56879019411ED76F653C755141C44B40D088901941C1FA55453C75514117CBD5578A90194158D7EF253C755141418A2AED8B901941D9D341073C7551419D84FB8F8D9019412F5750E93B75514187B505408F90194150C81FCC3B7551415A1806FD90901941228EB4AF3B75514173A8B9C692901941A10F13943B7551412D61DD9C94901941B0B33F793B755141E03D2E7F9690194146E13E5F3B755141ED39696D9890194150FF14463B755141AD504B679A901941BD74C62D3B755141797D916C9C9019417FA857163B755141B2BBF87C9E9019418201CDFF3A7551419567CCBDBF9119415357E5072F755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('37', '9100C', NULL, 'Avenida de Aragó', NULL, '0105000020E7640000010000000102000000040000009567CCBDBF9119415357E5072F7551415F7A4D5CB993194108B25F3F1A7551410CD8EAF7C6931941F53ABA9B197551414B8DCDC4D2931941093B8CF318755141', 1, 1);
INSERT INTO om_streetaxis (id, code, type, name, text, the_geom, expl_id, muni_id) VALUES ('38', '9100C', NULL, 'Avenida de Aragó', NULL, '0105000020E7640000010000000102000000250000004B8DCDC4D2931941093B8CF318755141BE8443B3D99319419C401D84187551414D5C32DCE4931941C325D8B5177551410A478F655095194146A2C822FA745141FC87F663969519416987A796F4745141D7441A8D97951941F7331980F47451417F0EF3C2989519417CE77F6AF47451414547F2049A9519416CDCDD55F4745141755189529B951941444D3542F47451415F8F29AB9C9519417574882FF47451414D63440E9E951941758CD91DF4745141922F4B7B9F951941BFCF2A0DF47451417B56AFF1A0951941C6787EFDF3745141533AE270A295194102C2D6EEF37451416A3D55F8A3951941ECE535E1F37451410CC27987A5951941F31E9ED4F3745141892AC11DA795194196A711C9F374514130D99CBAA895194149BA92BEF37451414B307E5DAA951941809123B5F37451412992D605AC951941B267C6ACF37451411C6117B3AD9519415C777DA5F37451416DFFB164AF951941EBFA4A9FF37451416DCF171AB1951941DE2C319AF37451416933BAD2B2951941A5473296F3745141AD8D0A8EB4951941BF855093F374514189407A4BB695194198218E91F37451414BAE7A0AB8951941AE55ED90F374514140397DCAB9951941795C7091F3745141B743F38ABB95194167701993F3745141FF2F4E4BBD951941F5CBEA95F37451416160FF0ABF9519419AA9E699F3745141313778C9C0951941CA430F9FF3745141B9162A86C295194100D566A5F374514147618640C4951941AB97EFACF37451412C79FEF7C59519414BC6ABB5F3745141B1C003ACC79519414C9B9DBFF37451416C8E045CC9951941063DC7CAF3745141', 1, 1);


UPDATE config_toolbox SET inputparams='[
{"widgetname":"graphClass", "label":"Graph class:", "widgettype":"combo","datatype":"text","tooltip": "Graphanalytics method used", "layoutname":"grl_option_parameters","layoutorder":1,"comboIds":["PRESSZONE","DQA","DMA","SECTOR"],
"comboNames":["Pressure Zonification (PRESSZONE)", "District Quality Areas (DQA) ", "District Metering Areas (DMA)", "Inlet Sectorization (SECTOR-HIGH / SECTOR-LOW)"], "selectedId":""}, 
{"widgetname":"exploitation", "label":"Exploitation:","widgettype":"combo","datatype":"text","tooltip": "Choose exploitation to work with", "layoutname":"grl_option_parameters","layoutorder":2, 
"dvQueryText":"SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC", "selectedId":"$userExploitation"},
{"widgetname":"floodOnlyMapzone", "label":"Flood only one mapzone: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Flood only identified mapzones. The purpose of this is update only network elements affected by this flooding keeping rest of network as is. Recommended to gain performance when mapzones ecosystem is under work", "placeholder":"1001", "layoutname":"grl_option_parameters","layoutorder":3, "value":""},
{"widgetname":"forceOpen", "label":"Force open nodes: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Optative node id(s) to temporary open closed node(s) in order to force algorithm to continue there", "placeholder":"1015,2231,3123", "layoutname":"grl_option_parameters","layoutorder":5, "value":""},
{"widgetname":"forceClosed", "label":"Force closed nodes: (*)","widgettype":"text","datatype":"text", "isMandatory":false, "tooltip":"Optative node id(s) to temporary close open node(s) to force algorithm to stop there","placeholder":"1015,2231,3123", "layoutname":"grl_option_parameters","layoutorder":6,"value":""},
{"widgetname":"usePlanPsector", "label":"Use selected psectors:", "widgettype":"check","datatype":"boolean","tooltip":"If true, use selected psectors. If false ignore selected psectors and only works with on-service network" , "layoutname":"grl_option_parameters","layoutorder":7,"value":""},
{"widgetname":"commitChanges", "label":"Commit changes:", "widgettype":"check","datatype":"boolean","tooltip":"If true, changes will be applied to DB. If false, algorithm results will be saved in anl tables" , "layoutname":"grl_option_parameters","layoutorder":8,"value":""},
{"widgetname":"valueForDisconnected", "label":"Value for disconn. and conflict: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Value to use for disconnected features. Usefull for work in progress with dynamic mpzonesnode" , "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":9, "value":""},
{"widgetname":"updateMapZone", "label":"Mapzone constructor method:","widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layoutorder":10,
"comboIds":[0,1,2,3,4], "comboNames":["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "PLOT & PIPE BUFFER", "LINK & PIPE BUFFER"], "selectedId":""}, 
{"widgetname":"geomParamUpdate", "label":"Pipe buffer","widgettype":"text","datatype":"float","tooltip":"Buffer from arcs to create mapzone geometry using [PIPE BUFFER] options. Normal values maybe between 3-20 mts.", "layoutname":"grl_option_parameters","layoutorder":11, "isMandatory":false, "placeholder":"5-30", "value":""}
]'::json WHERE id=2768;

UPDATE config_csv SET active = true WHERE fid in (469,470);

UPDATE config_param_system SET value = '{"usePsectors":false, "ignoreGraphanalytics":false, "ignoreEpa":false, "ignorePlan":false}'
WHERE parameter = 'admin_checkproject';


UPDATE ext_rtc_dma_period set avg_press = 30;

UPDATE plan_psector_x_arc SET active = true WHERE arc_id in ('20861', '20851', '20651');
UPDATE plan_psector_x_node SET active = true WHERE node_id in ('10761');
UPDATE plan_psector_x_connec SET active = true WHERE connec_id in ('3103', '3104', '3014', '3014');

SELECT setval('SCHEMA_NAME.urn_id_seq', 114465, true);

UPDATE config_form_fields
SET widgetcontrols = '{"labelPosition": "top"}'
WHERE formname LIKE 've_%' AND (layoutname LIKE 'lyt_top%' OR layoutname LIKE 'lyt_bot%') AND widgetcontrols IS NULL;

UPDATE config_form_fields
SET widgetcontrols = jsonb_set(widgetcontrols::jsonb, '{labelPosition}', '"top"', true)
WHERE formname LIKE 've_%' AND (layoutname LIKE 'lyt_top%' OR layoutname LIKE 'lyt_bot%');

UPDATE config_form_fields SET web_layoutorder=NULL
	WHERE columnname='asset_id';
UPDATE config_form_fields SET web_layoutorder=4
	WHERE columnname='connec_id';

UPDATE config_form_tabs SET device = '{4,5}' where formname = 've_node_water_connection';
UPDATE config_form_tabs SET device = '{5}' where formname like 'visit_%';
UPDATE config_form_tabs SET device = '{5}' where formname like 'incident_%';
UPDATE config_form_tabs SET device = '{4}' where formname like 'v_edit_%' and tabname = 'tab_plan';

-- 01/08/23

UPDATE config_form_fields
SET layoutorder = (SELECT attnum FROM pg_attribute WHERE attrelid = formname::regclass AND attname = columnname and attnum > 0 AND NOT attisdropped ORDER BY attnum LIMIT 1)
WHERE formname IN ('v_edit_inp_flwreg_orifice', 'v_edit_inp_dscenario_flwreg_orifice', 'v_edit_inp_flwreg_outlet', 'v_edit_inp_dscenario_flwreg_outlet', 'v_edit_inp_flwreg_pump', 'v_edit_inp_dscenario_flwreg_pump', 'v_edit_inp_flwreg_weir', 'v_edit_inp_dscenario_flwreg_weir', 'v_edit_inp_dscenario_demand', 'v_edit_inp_dscenario_pump_additional', 'v_edit_inp_dscenario_pump','v_edit_inp_pump_additional', 'v_edit_inp_dscenario_virtualvalve', 'v_edit_inp_dscenario_virtualpump', 'v_edit_inp_dscenario_valve', 'v_edit_inp_dscenario_tank', 'v_edit_inp_dscenario_shortpipe', 'v_edit_inp_dscenario_rules', 'v_edit_inp_dscenario_reservoir', 'v_edit_inp_dscenario_pipe', 'v_edit_inp_dscenario_junction', 'v_edit_inp_dscenario_inlet', 'v_edit_inp_dscenario_controls', 'v_edit_inp_dscenario_connec', 'inp_dscenario_virtualvalve', 'v_edit_inp_dscenario_conduit', 'v_edit_inp_dscenario_inflows', 'v_edit_inp_dscenario_inflows_poll', 'v_edit_inp_dscenario_lids', 'v_edit_inp_dscenario_outfall', 'v_edit_inp_dscenario_raingage', 'v_edit_inp_dscenario_storage', 'v_edit_inp_dscenario_treatment');

-- set hiden and iseditable for dscenario arc_id/node_id/connec_id/feature_id
UPDATE config_form_fields
SET iseditable = false, hidden = false
WHERE formname IN ('v_edit_inp_flwreg_orifice', 'v_edit_inp_dscenario_flwreg_orifice', 'v_edit_inp_flwreg_outlet', 'v_edit_inp_dscenario_flwreg_outlet', 'v_edit_inp_flwreg_pump', 'v_edit_inp_dscenario_flwreg_pump', 'v_edit_inp_flwreg_weir', 'v_edit_inp_dscenario_flwreg_weir', 'v_edit_inp_dscenario_demand', 'v_edit_inp_dscenario_pump_additional', 'v_edit_inp_dscenario_pump','v_edit_inp_pump_additional', 'v_edit_inp_dscenario_virtualvalve', 'v_edit_inp_dscenario_virtualpump', 'v_edit_inp_dscenario_valve', 'v_edit_inp_dscenario_tank', 'v_edit_inp_dscenario_shortpipe', 'v_edit_inp_dscenario_rules', 'v_edit_inp_dscenario_reservoir', 'v_edit_inp_dscenario_pipe', 'v_edit_inp_dscenario_junction', 'v_edit_inp_dscenario_inlet', 'v_edit_inp_dscenario_controls', 'v_edit_inp_dscenario_connec', 'inp_dscenario_virtualvalve', 'v_edit_inp_dscenario_conduit', 'v_edit_inp_dscenario_inflows', 'v_edit_inp_dscenario_inflows_poll', 'v_edit_inp_dscenario_lids', 'v_edit_inp_dscenario_outfall', 'v_edit_inp_dscenario_raingage', 'v_edit_inp_dscenario_storage', 'v_edit_inp_dscenario_treatment') AND columnname IN ('arc_id', 'node_id', 'connec_id','feature_id');

UPDATE config_form_fields
SET columnname = 'tbl_inp_inlet' WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='tbl_inp_tank' AND tabname='tab_epa';

UPDATE config_form_fields
SET hidden=true
WHERE formname='v_edit_inp_dscenario_junction' AND formtype='form_feature' AND columnname='peak_factor' AND tabname='tab_none';

DELETE FROM config_form_fields
WHERE formname='v_edit_inp_dscenario_pump_additional' AND formtype='form_feature' AND columnname='overflow' AND tabname='tab_none';

UPDATE config_form_fields
SET ismandatory=true
WHERE columnname='speed' AND tabname='tab_none' AND formname ilike 'v_edit_inp_dscenario%';

UPDATE config_form_fields SET iseditable = true WHERE layoutname = 'lyt_epa_dsc_1' AND widgettype = 'button';

UPDATE config_form_fields
SET  ismandatory=false
WHERE formname='v_edit_inp_dscenario_pump' AND formtype='form_feature' AND columnname='speed' AND tabname='tab_none';
UPDATE config_form_fields
SET  ismandatory=false
WHERE formname='v_edit_inp_dscenario_pump_additional' AND formtype='form_feature' AND columnname='speed' AND tabname='tab_none';

UPDATE config_form_fields
SET  ismandatory=false
WHERE formname='v_edit_inp_dscenario_pipe' AND formtype='form_feature' AND columnname='roughness' AND tabname='tab_none';
UPDATE config_form_fields
SET ismandatory=false
WHERE formname='v_edit_inp_dscenario_pipe' AND formtype='form_feature' AND columnname='dint' AND tabname='tab_none';

UPDATE config_form_fields
SET ismandatory=false
WHERE formname='v_edit_inp_dscenario_connec' AND formtype='form_feature' AND columnname='custom_roughness' AND tabname='tab_none';
UPDATE config_form_fields
SET ismandatory=false
WHERE formname='v_edit_inp_dscenario_connec' AND formtype='form_feature' AND columnname='custom_length' AND tabname='tab_none';
UPDATE config_form_fields
SET ismandatory=false
WHERE formname='v_edit_inp_dscenario_connec' AND formtype='form_feature' AND columnname='custom_dint' AND tabname='tab_none';

UPDATE config_form_fields SET layoutname = 'lyt_data_1' where formname = 'v_edit_sector';
UPDATE config_form_fields SET layoutorder =1 WHERE  formname = 'v_edit_sector' AND columnname = 'sector_id';
UPDATE config_form_fields SET layoutorder =2 WHERE  formname = 'v_edit_sector' AND columnname = 'name';
UPDATE config_form_fields SET layoutorder =3 WHERE  formname = 'v_edit_sector' AND columnname = 'macrosector_id';
UPDATE config_form_fields SET layoutorder =4 WHERE  formname = 'v_edit_sector' AND columnname = 'descript';
UPDATE config_form_fields SET layoutorder =5 WHERE  formname = 'v_edit_sector' AND columnname = 'undelete';
UPDATE config_form_fields SET layoutorder =6 WHERE  formname = 'v_edit_sector' AND columnname = 'parent_id';
UPDATE config_form_fields SET layoutorder =7 WHERE  formname = 'v_edit_sector' AND columnname = 'pattern_id';
UPDATE config_form_fields SET layoutorder =8, iseditable=false WHERE  formname = 'v_edit_sector' AND columnname = 'graphconfig';
UPDATE config_form_fields SET layoutorder =9 WHERE  formname = 'v_edit_sector' AND columnname = 'stylesheet';
UPDATE config_form_fields SET layoutorder =10 WHERE  formname = 'v_edit_sector' AND columnname = 'active';

UPDATE config_form_fields SET layoutname = 'lyt_data_1' where formname = 'v_edit_dma';
UPDATE config_form_fields SET layoutorder =1 WHERE  formname = 'v_edit_dma' AND columnname = 'dma_id';
UPDATE config_form_fields SET layoutorder =2 WHERE  formname = 'v_edit_dma' AND columnname = 'name';
UPDATE config_form_fields SET layoutorder =3 WHERE  formname = 'v_edit_dma' AND columnname = 'macrodma_id';
UPDATE config_form_fields SET layoutorder =4 WHERE  formname = 'v_edit_dma' AND columnname = 'descript';
UPDATE config_form_fields SET layoutorder =5 WHERE  formname = 'v_edit_dma' AND columnname = 'undelete';
UPDATE config_form_fields SET layoutorder =6 WHERE  formname = 'v_edit_dma' AND columnname = 'expl_id';
UPDATE config_form_fields SET layoutorder =7 WHERE  formname = 'v_edit_dma' AND columnname = 'pattern_id';
UPDATE config_form_fields SET layoutorder =8 WHERE  formname = 'v_edit_dma' AND columnname = 'dma_type';
UPDATE config_form_fields SET layoutorder =9 WHERE  formname = 'v_edit_dma' AND columnname = 'link';
UPDATE config_form_fields SET layoutorder =10 WHERE  formname = 'v_edit_dma' AND columnname = 'effc';
UPDATE config_form_fields SET layoutorder =11 WHERE  formname = 'v_edit_dma' AND columnname = 'avg_press';
UPDATE config_form_fields SET layoutorder =12, iseditable=false WHERE  formname = 'v_edit_dma' AND columnname = 'graphconfig';
UPDATE config_form_fields SET layoutorder =13 WHERE  formname = 'v_edit_dma' AND columnname = 'stylesheet';
UPDATE config_form_fields SET layoutorder =14 WHERE  formname = 'v_edit_dma' AND columnname = 'active';

UPDATE config_form_fields SET layoutname = 'lyt_data_1' where formname = 'v_edit_presszone';
UPDATE config_form_fields SET layoutorder =1 WHERE  formname = 'v_edit_presszone' AND columnname = 'presszone_id';
UPDATE config_form_fields SET layoutorder =2 WHERE  formname = 'v_edit_presszone' AND columnname = 'name';
UPDATE config_form_fields SET layoutorder =3 WHERE  formname = 'v_edit_presszone' AND columnname = 'expl_id';
UPDATE config_form_fields SET layoutorder =4 WHERE  formname = 'v_edit_presszone' AND columnname = 'descript';
UPDATE config_form_fields SET layoutorder =5 WHERE  formname = 'v_edit_presszone' AND columnname = 'head';
UPDATE config_form_fields SET layoutorder =6 WHERE  formname = 'v_edit_presszone' AND columnname = 'presszone_type';
UPDATE config_form_fields SET layoutorder =7, iseditable=false WHERE  formname = 'v_edit_presszone' AND columnname = 'graphconfig';
UPDATE config_form_fields SET layoutorder =8 WHERE  formname = 'v_edit_presszone' AND columnname = 'stylesheet';
UPDATE config_form_fields SET layoutorder =9 WHERE  formname = 'v_edit_presszone' AND columnname = 'active';

UPDATE config_form_fields SET layoutname = 'lyt_data_1' where formname = 'v_edit_dqa';
UPDATE config_form_fields SET layoutorder =1 WHERE  formname = 'v_edit_dqa' AND columnname = 'dqa_id';
UPDATE config_form_fields SET layoutorder =2 WHERE  formname = 'v_edit_dqa' AND columnname = 'name';
UPDATE config_form_fields SET layoutorder =3 WHERE  formname = 'v_edit_dqa' AND columnname = 'expl_id';
UPDATE config_form_fields SET layoutorder =4 WHERE  formname = 'v_edit_dqa' AND columnname = 'macrodqa_id';
UPDATE config_form_fields SET layoutorder =5 WHERE  formname = 'v_edit_dqa' AND columnname = 'descript';
UPDATE config_form_fields SET layoutorder =6 WHERE  formname = 'v_edit_dqa' AND columnname = 'undelete';
UPDATE config_form_fields SET layoutorder =7 WHERE  formname = 'v_edit_dqa' AND columnname = 'pattern_id';
UPDATE config_form_fields SET layoutorder =8 WHERE  formname = 'v_edit_dqa' AND columnname = 'dqa_type';
UPDATE config_form_fields SET layoutorder =9 WHERE  formname = 'v_edit_dqa' AND columnname = 'link';
UPDATE config_form_fields SET layoutorder =10 WHERE  formname = 'v_edit_dqa' AND columnname = 'avg_press';
UPDATE config_form_fields SET layoutorder =11, iseditable=false WHERE  formname = 'v_edit_dqa' AND columnname = 'graphconfig';
UPDATE config_form_fields SET layoutorder =12 WHERE  formname = 'v_edit_dqa' AND columnname = 'stylesheet';
UPDATE config_form_fields SET layoutorder =13 WHERE  formname = 'v_edit_dqa' AND columnname = 'active';

UPDATE config_param_system SET value = (replace(value, 'Disable', 'Random')) WHERE parameter='utils_graphanalytics_style';

UPDATE man_hydrant set customer_code = concat('cc', node_id);

INSERT INTO sys_style (layername, styleconfig_id, styletype) VALUES ('v_edit_arc', 106, 'qml') ON CONFLICT (layername, styleconfig_id) DO NOTHING;
INSERT INTO sys_style (layername, styleconfig_id, styletype) VALUES ('v_edit_arc', 107, 'qml') ON CONFLICT (layername, styleconfig_id) DO NOTHING;
INSERT INTO sys_style (layername, styleconfig_id, styletype) VALUES ('v_edit_arc', 108, 'qml') ON CONFLICT (layername, styleconfig_id) DO NOTHING;

UPDATE config_form_fields SET hidden=false WHERE formtype='form_featuretype_change' AND columnname='featurecat_id';

UPDATE config_form_fields SET layoutname='lyt_nvo_roughness_1', layoutorder= 6 WHERE formtype='nvo_roughness' AND columnname = 'descript';
UPDATE config_form_fields SET layoutname='lyt_nvo_curves_1', layoutorder= 2, stylesheet= NULL WHERE formtype='nvo_curves' AND columnname = 'expl_id';
UPDATE config_form_fields SET layoutname='lyt_nvo_curves_2', layoutorder= 0, stylesheet= NULL WHERE formtype='nvo_curves' AND columnname = 'descript';
UPDATE config_form_fields SET layoutname='lyt_nvo_patterns_1', layoutorder= 2, stylesheet= NULL WHERE formtype='nvo_patterns' AND columnname = 'expl_id';
UPDATE config_form_fields SET layoutname='lyt_nvo_patterns_1', layoutorder= 1, stylesheet= NULL WHERE formtype='nvo_patterns' AND columnname = 'observ';
UPDATE config_form_fields SET layoutname='lyt_nvo_controls_1', layoutorder= 0, stylesheet= NULL WHERE formtype='nvo_controls' AND columnname = 'sector_id';
UPDATE config_form_fields SET layoutname='lyt_nvo_rules_1', layoutorder= 0, stylesheet= NULL WHERE formtype='nvo_rules' AND columnname = 'sector_id';

update node set verified=2 where node_id in ('1084', '113957', '114227', '114230', '42');

UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=1 WHERE formname='v_ui_sector' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=2 WHERE formname='v_ui_sector' AND formtype='form_feature' AND columnname='name' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=3 WHERE formname='v_ui_sector' AND formtype='form_feature' AND columnname='sector_type' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=4 WHERE formname='v_ui_sector' AND formtype='form_feature' AND columnname='macrosector' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=5 WHERE formname='v_ui_sector' AND formtype='form_feature' AND columnname='descript' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=6 WHERE formname='v_ui_sector' AND formtype='form_feature' AND columnname='active' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=7 WHERE formname='v_ui_sector' AND formtype='form_feature' AND columnname='undelete' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=8 WHERE formname='v_ui_sector' AND formtype='form_feature' AND columnname='graphconfig' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=9 WHERE formname='v_ui_sector' AND formtype='form_feature' AND columnname='stylesheet' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=10 WHERE formname='v_ui_sector' AND formtype='form_feature' AND columnname='parent_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=11 WHERE formname='v_ui_sector' AND formtype='form_feature' AND columnname='pattern_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=12 WHERE formname='v_ui_sector' AND formtype='form_feature' AND columnname='avg_press' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_3', layoutorder=13 WHERE formname='v_ui_sector' AND formtype='form_feature' AND columnname='link' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=14 WHERE formname='v_ui_sector' AND formtype='form_feature' AND columnname='muni_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=15 WHERE formname='v_ui_sector' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_none';

UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=1 WHERE formname='v_ui_dma' AND formtype='form_feature' AND columnname='dma_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=2 WHERE formname='v_ui_dma' AND formtype='form_feature' AND columnname='name' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=3 WHERE formname='v_ui_dma' AND formtype='form_feature' AND columnname='dma_type' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=4 WHERE formname='v_ui_dma' AND formtype='form_feature' AND columnname='macrodma' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=5 WHERE formname='v_ui_dma' AND formtype='form_feature' AND columnname='descript' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=6 WHERE formname='v_ui_dma' AND formtype='form_feature' AND columnname='active' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=7 WHERE formname='v_ui_dma' AND formtype='form_feature' AND columnname='undelete' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=8 WHERE formname='v_ui_dma' AND formtype='form_feature' AND columnname='graphconfig' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=9 WHERE formname='v_ui_dma' AND formtype='form_feature' AND columnname='stylesheet' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=10 WHERE formname='v_ui_dma' AND formtype='form_feature' AND columnname='pattern_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=11 WHERE formname='v_ui_dma' AND formtype='form_feature' AND columnname='minc' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=12 WHERE formname='v_ui_dma' AND formtype='form_feature' AND columnname='maxc' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=13 WHERE formname='v_ui_dma' AND formtype='form_feature' AND columnname='effc' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=14 WHERE formname='v_ui_dma' AND formtype='form_feature' AND columnname='avg_press' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=15 WHERE formname='v_ui_dma' AND formtype='form_feature' AND columnname='link' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=16 WHERE formname='v_ui_dma' AND formtype='form_feature' AND columnname='muni_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=17 WHERE formname='v_ui_dma' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=18 WHERE formname='v_ui_dma' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_none';

UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=1 WHERE formname='v_ui_presszone' AND formtype='form_feature' AND columnname='presszone_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=2 WHERE formname='v_ui_presszone' AND formtype='form_feature' AND columnname='name' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=3 WHERE formname='v_ui_presszone' AND formtype='form_feature' AND columnname='presszone_type' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=4 WHERE formname='v_ui_presszone' AND formtype='form_feature' AND columnname='descript' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=5 WHERE formname='v_ui_presszone' AND formtype='form_feature' AND columnname='active' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=6 WHERE formname='v_ui_presszone' AND formtype='form_feature' AND columnname='undelete' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=7 WHERE formname='v_ui_presszone' AND formtype='form_feature' AND columnname='graphconfig' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=8 WHERE formname='v_ui_presszone' AND formtype='form_feature' AND columnname='stylesheet' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=9 WHERE formname='v_ui_presszone' AND formtype='form_feature' AND columnname='head' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=10 WHERE formname='v_ui_presszone' AND formtype='form_feature' AND columnname='avg_press' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_3', layoutorder=11 WHERE formname='v_ui_presszone' AND formtype='form_feature' AND columnname='link' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=12 WHERE formname='v_ui_presszone' AND formtype='form_feature' AND columnname='muni_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=13 WHERE formname='v_ui_presszone' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=14 WHERE formname='v_ui_presszone' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_none';

UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=1 WHERE formname='v_ui_dqa' AND formtype='form_feature' AND columnname='dqa_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=2 WHERE formname='v_ui_dqa' AND formtype='form_feature' AND columnname='name' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=3 WHERE formname='v_ui_dqa' AND formtype='form_feature' AND columnname='dqa_type' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=4 WHERE formname='v_ui_dqa' AND formtype='form_feature' AND columnname='macrodqa' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=5 WHERE formname='v_ui_dqa' AND formtype='form_feature' AND columnname='descript' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=6 WHERE formname='v_ui_dqa' AND formtype='form_feature' AND columnname='active' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=7 WHERE formname='v_ui_dqa' AND formtype='form_feature' AND columnname='undelete' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=8 WHERE formname='v_ui_dqa' AND formtype='form_feature' AND columnname='graphconfig' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=9 WHERE formname='v_ui_dqa' AND formtype='form_feature' AND columnname='stylesheet' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=10 WHERE formname='v_ui_dqa' AND formtype='form_feature' AND columnname='pattern_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=11 WHERE formname='v_ui_dqa' AND formtype='form_feature' AND columnname='avg_press' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=12 WHERE formname='v_ui_dqa' AND formtype='form_feature' AND columnname='link' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=13 WHERE formname='v_ui_dqa' AND formtype='form_feature' AND columnname='muni_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=14 WHERE formname='v_ui_dqa' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=15 WHERE formname='v_ui_dqa' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_none';





UPDATE config_form_fields SET layoutname='lyt_workspace_open_1', layoutorder= 1, stylesheet= NULL WHERE formtype='workspace_open' AND columnname = 'descript';

UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=1 WHERE formname='v_ui_supplyzone' AND formtype='form_feature' AND columnname='supplyzone_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=2 WHERE formname='v_ui_supplyzone' AND formtype='form_feature' AND columnname='name' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=3 WHERE formname='v_ui_supplyzone' AND formtype='form_feature' AND columnname='supplyzone_type' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=4 WHERE formname='v_ui_supplyzone' AND formtype='form_feature' AND columnname='macrosector' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=5 WHERE formname='v_ui_supplyzone' AND formtype='form_feature' AND columnname='descript' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=6 WHERE formname='v_ui_supplyzone' AND formtype='form_feature' AND columnname='active' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=7 WHERE formname='v_ui_supplyzone' AND formtype='form_feature' AND columnname='undelete' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=8 WHERE formname='v_ui_supplyzone' AND formtype='form_feature' AND columnname='graphconfig' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=9 WHERE formname='v_ui_supplyzone' AND formtype='form_feature' AND columnname='stylesheet' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=10 WHERE formname='v_ui_supplyzone' AND formtype='form_feature' AND columnname='parent_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=11 WHERE formname='v_ui_supplyzone' AND formtype='form_feature' AND columnname='pattern_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=12 WHERE formname='v_ui_supplyzone' AND formtype='form_feature' AND columnname='avg_press' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=13 WHERE formname='v_ui_supplyzone' AND formtype='form_feature' AND columnname='link' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=14 WHERE formname='v_ui_supplyzone' AND formtype='form_feature' AND columnname='muni_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=15 WHERE formname='v_ui_supplyzone' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_none';

UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=1, hidden=false WHERE formname='v_ui_macrodma' AND formtype='form_feature' AND columnname='macrodma_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=2 WHERE formname='v_ui_macrodma' AND formtype='form_feature' AND columnname='name' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=3 WHERE formname='v_ui_macrodma' AND formtype='form_feature' AND columnname='descript' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=4 WHERE formname='v_ui_macrodma' AND formtype='form_feature' AND columnname='active' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=5 WHERE formname='v_ui_macrodma' AND formtype='form_feature' AND columnname='undelete' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=6 WHERE formname='v_ui_macrodma' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_none';

UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=1 WHERE formname='v_ui_macrosector' AND formtype='form_feature' AND columnname='macrosector_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=2 WHERE formname='v_ui_macrosector' AND formtype='form_feature' AND columnname='name' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=3 WHERE formname='v_ui_macrosector' AND formtype='form_feature' AND columnname='descript' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=4 WHERE formname='v_ui_macrosector' AND formtype='form_feature' AND columnname='active' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=5 WHERE formname='v_ui_macrosector' AND formtype='form_feature' AND columnname='undelete' AND tabname='tab_none';


-- 04/02/2025

UPDATE config_toolbox
	SET inputparams='[
{"widgetname":"graphClass", "label":"Graph class:", "widgettype":"combo","datatype":"text","tooltip": "Graphanalytics method used", "layoutname":"grl_option_parameters","layoutorder":1,"comboIds":["PRESSZONE","DQA","DMA","SECTOR","SUPPLYZONE","MACRODMA","MACROSECTOR"],
"comboNames":["Pressure Zonification (PRESSZONE)", "District Quality Areas (DQA) ", "District Metering Areas (DMA)", "Inlet Sectorization (SECTOR-HIGH / SECTOR-LOW)","(SUPPLYZONE)","(MACRODMA)","(MACROSECTOR)"], "selectedId":""}, 
{"widgetname":"exploitation", "label":"Exploitation:","widgettype":"combo","datatype":"text","tooltip": "Choose exploitation to work with", "layoutname":"grl_option_parameters","layoutorder":2, 
"dvQueryText":"SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC", "selectedId":"$userExploitation"},
{"widgetname":"floodOnlyMapzone", "label":"Flood only one mapzone: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Flood only identified mapzones. The purpose of this is update only network elements affected by this flooding keeping rest of network as is. Recommended to gain performance when mapzones ecosystem is under work", "placeholder":"1001", "layoutname":"grl_option_parameters","layoutorder":3, "value":""},
{"widgetname":"forceOpen", "label":"Force open nodes: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Optative node id(s) to temporary open closed node(s) in order to force algorithm to continue there", "placeholder":"1015,2231,3123", "layoutname":"grl_option_parameters","layoutorder":5, "value":""},
{"widgetname":"forceClosed", "label":"Force closed nodes: (*)","widgettype":"text","datatype":"text", "isMandatory":false, "tooltip":"Optative node id(s) to temporary close open node(s) to force algorithm to stop there","placeholder":"1015,2231,3123", "layoutname":"grl_option_parameters","layoutorder":6,"value":""},
{"widgetname":"usePlanPsector", "label":"Use selected psectors:", "widgettype":"check","datatype":"boolean","tooltip":"If true, use selected psectors. If false ignore selected psectors and only works with on-service network" , "layoutname":"grl_option_parameters","layoutorder":7,"value":""},
{"widgetname":"commitChanges", "label":"Commit changes:", "widgettype":"check","datatype":"boolean","tooltip":"If true, changes will be applied to DB. If false, algorithm results will be saved in anl tables" , "layoutname":"grl_option_parameters","layoutorder":8,"value":""},
{"widgetname":"valueForDisconnected", "label":"Value for disconn. and conflict: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Value to use for disconnected features. Usefull for work in progress with dynamic mpzonesnode" , "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":9, "value":""},
{"widgetname":"updateMapZone", "label":"Mapzone constructor method:","widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layoutorder":10,
"comboIds":[0,1,2,3,4], "comboNames":["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "PLOT & PIPE BUFFER", "LINK & PIPE BUFFER"], "selectedId":""}, 
{"widgetname":"geomParamUpdate", "label":"Pipe buffer","widgettype":"text","datatype":"float","tooltip":"Buffer from arcs to create mapzone geometry using [PIPE BUFFER] options. Normal values maybe between 3-20 mts.", "layoutname":"grl_option_parameters","layoutorder":11, "isMandatory":false, "placeholder":"5-30", "value":""}
]'::json
	WHERE id=2768;


-- 07/02/2025
UPDATE config_form_fields SET columnname='top_elev', label='top_elev', tooltip='top_elev' WHERE formname='v_edit_inp_inlet' AND formtype='form_feature' AND columnname='elevation' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='top_elev', label='top_elev', tooltip='top_elev' WHERE formname='v_edit_inp_junction' AND formtype='form_feature' AND columnname='elevation' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='top_elev', label='top_elev', tooltip='top_elev' WHERE formname='v_edit_inp_pump' AND formtype='form_feature' AND columnname='elevation' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='top_elev', label='top_elev', tooltip='top_elev' WHERE formname='v_edit_inp_reservoir' AND formtype='form_feature' AND columnname='elevation' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='top_elev', label='top_elev', tooltip='top_elev' WHERE formname='v_edit_inp_shortpipe' AND formtype='form_feature' AND columnname='elevation' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='top_elev', label='top_elev', tooltip='top_elev' WHERE formname='v_edit_inp_tank' AND formtype='form_feature' AND columnname='elevation' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='top_elev', label='top_elev', tooltip='top_elev' WHERE formname='v_edit_inp_valve' AND formtype='form_feature' AND columnname='elevation' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='top_elev', label='top_elev', tooltip='top_elev' WHERE formname='v_edit_node' AND formtype='form_feature' AND columnname='elevation' AND tabname='tab_data';
UPDATE config_form_fields SET columnname='top_elev', label='top_elev', tooltip='top_elev' WHERE formname='v_edit_element' AND formtype='form_feature' AND columnname='elevation' AND tabname='tab_data';
UPDATE config_form_fields SET columnname='top_elev', label='top_elev', tooltip='top_elev' WHERE formname='v_edit_review_node' AND formtype='form_feature' AND columnname='elevation' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='top_elev', label='top_elev', tooltip='top_elev' WHERE formname='v_rpt_node' AND formtype='form_feature' AND columnname='elevation' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='top_elev', label='top_elev', tooltip='top_elev' WHERE formname='v_rpt_node_stats' AND formtype='form_feature' AND columnname='elevation' AND tabname='tab_none';
UPDATE config_form_fields SET columnname='top_elev', label='top_elev', tooltip='top_elev' WHERE formname='ve_node' AND formtype='form_feature' AND columnname='elevation' AND tabname='tab_data';

UPDATE config_form_fields SET layoutorder=29 WHERE formname='ve_node' AND formtype='form_feature' AND columnname='macroexpl_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=28 WHERE formname='ve_node' AND formtype='form_feature' AND columnname='tstamp' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=27 WHERE formname='ve_node' AND formtype='form_feature' AND columnname='hemisphere' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=26 WHERE formname='ve_node' AND formtype='form_feature' AND columnname='macrosector_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=25 WHERE formname='ve_node' AND formtype='form_feature' AND columnname='placement_type' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=24 WHERE formname='ve_node' AND formtype='form_feature' AND columnname='access_type' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=23 WHERE formname='ve_node' AND formtype='form_feature' AND columnname='conserv_state' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=22 WHERE formname='ve_node' AND formtype='form_feature' AND columnname='om_state' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=21 WHERE formname='ve_node' AND formtype='form_feature' AND columnname='dma_name' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=20 WHERE formname='ve_node' AND formtype='form_feature' AND columnname='sector_name' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=19 WHERE formname='ve_node' AND formtype='form_feature' AND columnname='macrodma_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=18 WHERE formname='ve_node' AND formtype='form_feature' AND columnname='staticpressure' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=18 WHERE formname='ve_node' AND formtype='form_feature' AND columnname='macrodqa_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=16 WHERE formname='ve_node' AND formtype='form_feature' AND columnname='minsector_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=15 WHERE formname='ve_node' AND formtype='form_feature' AND columnname='enddate' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=14 WHERE formname='ve_node' AND formtype='form_feature' AND columnname='workcat_id_end' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=13 WHERE formname='ve_node' AND formtype='form_feature' AND columnname='ownercat_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=12 WHERE formname='ve_node' AND formtype='form_feature' AND columnname='buildercat_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=11 WHERE formname='ve_node' AND formtype='form_feature' AND columnname='builtdate' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=10 WHERE formname='ve_node' AND formtype='form_feature' AND columnname='workcat_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=9 WHERE formname='ve_node' AND formtype='form_feature' AND columnname='cat_dnom' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=8 WHERE formname='ve_node' AND formtype='form_feature' AND columnname='cat_pnom' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=7 WHERE formname='ve_node' AND formtype='form_feature' AND columnname='cat_matcat_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=6 WHERE formname='ve_node' AND formtype='form_feature' AND columnname='sys_type' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=5 WHERE formname='ve_node' AND formtype='form_feature' AND columnname='depth' AND tabname='tab_data';

-- reorder config_form_fields
DELETE FROM config_form_fields WHERE formtype='form_feature' AND columnname='elevation' AND tabname='tab_data';

UPDATE config_form_fields SET layoutorder=16 WHERE formname ILIKE '%node%' AND formtype='form_feature' AND columnname='macrodqa_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=15 WHERE formname ILIKE '%node%' AND formtype='form_feature' AND columnname='enddate' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=14 WHERE formname ILIKE '%node%' AND formtype='form_feature' AND columnname='workcat_id_end' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=13 WHERE formname ILIKE '%node%' AND formtype='form_feature' AND columnname='ownercat_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=12 WHERE formname ILIKE '%node%' AND formtype='form_feature' AND columnname='buildercat_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=11 WHERE formname ILIKE '%node%' AND formtype='form_feature' AND columnname='builtdate' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=10 WHERE formname ILIKE '%node%' AND formtype='form_feature' AND columnname='workcat_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=9 WHERE formname ILIKE '%node%' AND formtype='form_feature' AND columnname='cat_dnom' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=8 WHERE formname ILIKE '%node%' AND formtype='form_feature' AND columnname='cat_pnom' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=7 WHERE formname ILIKE '%node%' AND formtype='form_feature' AND columnname='cat_matcat_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=6 WHERE formname ILIKE '%node%' AND formtype='form_feature' AND columnname='datasource' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=5 WHERE formname ILIKE '%node%' AND formtype='form_feature' AND columnname='sys_type' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=4 WHERE formname ILIKE '%node%' AND formtype='form_feature' AND columnname='depth' AND tabname='tab_data';

-- fix order on ve_arc and tab_data
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=1 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='node_1' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=2 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='nodetype_1' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=3 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='elevation1' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=4 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='depth1' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=5 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='sys_type' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=6 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='code' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=7 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='datasource' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=8 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='cat_matcat_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=9 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='cat_pnom' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=10 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='cat_dnom' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=11 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='workcat_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=12 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='gis_length' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=13 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='custom_length' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=14 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='builtdate' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=15 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='buildercat_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=16 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='ownercat_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=17 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='workcat_id_end' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=18 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='enddate' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=19 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='macrodqa_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=20 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='minsector_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=21 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='dqa_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=22 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='staticpress1' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=23 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='staticpress2' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=24 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='macrodma_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=25 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='link' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=26 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='sector_name' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=27 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='dma_name' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=28 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='om_state' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=29 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='conserv_state' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=30 WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='parent_id' AND tabname='tab_data';

-- on ve_arc_%
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=1 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='node_1' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=2 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='nodetype_1' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=3 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='elevation1' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=4 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='depth1' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=5 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='sys_type' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=6 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='code' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=7 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='datasource' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=8 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='cat_matcat_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=9 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='cat_pnom' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=10 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='cat_dnom' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=11 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='workcat_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=12 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='gis_length' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=13 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='custom_length' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=14 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='builtdate' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=15 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='buildercat_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=16 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='ownercat_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=17 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='workcat_id_end' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=18 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='enddate' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=19 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='macrodqa_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=20 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='minsector_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=21 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='dqa_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=22 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='staticpress1' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=23 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='staticpress2' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=24 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='macrodma_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=25 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='link' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=26 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='sector_name' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=27 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='dma_name' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=28 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='om_state' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=29 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='conserv_state' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=30 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='parent_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=31 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='brand_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=32 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='model_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=33 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='serial_number' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=34 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='label_quadrant' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=35 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='macrominsector_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=36 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='cat_dint' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=37 WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='supplyzone_id' AND tabname='tab_data';

-- ve_connec
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=1 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='code' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=2 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='top_elev' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=3 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='depth' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=4 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='sys_type' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=5 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='datasource' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=6 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='cat_matcat_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=7 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='connec_length' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=8 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='cat_pnom' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=9 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='cat_dnom' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=10 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='workcat_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=11 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='builtdate' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=12 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='buildercat_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=13 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='ownercat_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=14 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='workcat_id_end' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=15 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='minsector_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=16 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='enddate' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=17 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='macrodqa_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=18 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='dqa_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=19 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='staticpressure' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=20 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='macrodma_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=21 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='macrosector_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=22 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='link' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=23 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='n_hydrometer' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=24 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='lastupdate' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=25 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='lastupdate_user' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=26 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='sector_name' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=27 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='dma_name' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=28 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='om_state' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=29 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='conserv_state' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=30 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='access_type' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=31 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='placement_type' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=32 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='priority' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=33 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='valve_location' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=34 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='valve_type' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=35 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='shutoff_valve' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=36 WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='crmzone_name' AND tabname='tab_data';

-- ve_connec_%
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=1 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='code' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=2 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='top_elev' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=3 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='depth' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=4 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='sys_type' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=5 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='datasource' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=6 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='cat_matcat_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=7 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='connec_length' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=8 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='cat_pnom' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=9 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='cat_dnom' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=10 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='workcat_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=11 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='builtdate' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=12 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='buildercat_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=13 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='ownercat_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=14 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='workcat_id_end' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=15 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='enddate' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=16 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='minsector_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=17 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='macrodqa_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=18 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='dqa_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=19 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='staticpressure' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=20 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='macrodma_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=21 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='macrosector_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=22 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='link' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=23 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='n_hydrometer' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=24 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='lastupdate' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=25 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='lastupdate_user' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=26 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='sector_name' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=27 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='dma_name' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=28 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='om_state' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=29 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='conserv_state' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=30 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='access_type' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=31 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='placement_type' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=32 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='priority' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=33 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='valve_location' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=34 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='valve_type' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=35 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='shutoff_valve' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=36 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='crmzone_name' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=37 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='arq_patrimony' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=38 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='chlorinator' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=39 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='container_number' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=40 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='linked_connec' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=41 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='name' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=42 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='power' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=43 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='pump_number' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=44 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='regulation_tank' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=45 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='vmax' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=46 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='vtotal' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=47 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='plot_code' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=48 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='brand_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=49 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='model_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=50 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='serial_number' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=51 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='label_quadrant' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=52 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='cat_valve' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=53 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='macrominsector_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=54 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='cat_dint' AND tabname='tab_data';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=55 WHERE formname ILIKE 've_connec_%' AND formtype='form_feature' AND columnname='supplyzone_id' AND tabname='tab_data';

-- update datasource to v_edit_arc, ve_arc, v_edit_connec, ve_connec and ve_element
UPDATE config_form_fields SET "datatype"='integer', widgettype='combo', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_datasource''', dv_orderby_id=true, dv_isnullvalue=true, dv_querytext_filterc=NULL WHERE formname='v_edit_arc' AND formtype='form_feature' AND columnname='datasource' AND tabname='tab_data';
UPDATE config_form_fields SET "datatype"='integer', widgettype='combo', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_datasource''', dv_orderby_id=true, dv_isnullvalue=true, dv_querytext_filterc=NULL WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='datasource' AND tabname='tab_data';
UPDATE config_form_fields SET "datatype"='integer', widgettype='combo', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_datasource''', dv_orderby_id=true, dv_isnullvalue=true, dv_querytext_filterc=NULL WHERE formname='v_edit_connec' AND formtype='form_feature' AND columnname='datasource' AND tabname='tab_data';
UPDATE config_form_fields SET "datatype"='integer', widgettype='combo', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_datasource''', dv_orderby_id=true, dv_isnullvalue=true, dv_querytext_filterc=NULL WHERE formname ILIKE 've_connec_%*' AND formtype='form_feature' AND columnname='datasource' AND tabname='tab_data';