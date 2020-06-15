/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

INSERT INTO sys_function VALUES (2888, 'gw_fct_fill_om_tables','ws','function','void','void','Create example visits (used on sample creation)','role_admin',false);
INSERT INTO sys_function VALUES (2918, 'gw_fct_fill_doc_tables','ws','function','void','void','Create example documents (used on sample creation)','role_admin',false);
UPDATE sys_function SET input_params ='void', return_type ='void' WHERE id =2888;
UPDATE sys_function SET input_params ='void', return_type ='void' WHERE id =2918;


UPDATE inp_shortpipe SET to_arc=null WHERE node_id='114254';

INSERT INTO cat_users VALUES ('user1','user1');
INSERT INTO cat_users VALUES ('user2','user2');
INSERT INTO cat_users VALUES ('user3','user3');
INSERT INTO cat_users VALUES ('user4','user4');

INSERT INTO cat_manager (idval, expl_id, username, active) VALUES ('general manager', '{1,2}', concat('{',current_user,'}')::text[], true);


INSERT INTO config_mincut_inlet VALUES (113766, 1);
INSERT INTO config_mincut_inlet VALUES (113952, 2);


UPDATE plan_arc_x_pavement SET pavcat_id = 'Asphalt';

UPDATE plan_psector_x_arc SET psector_id = 2 WHERE arc_id = '20651';

INSERT INTO plan_psector_x_arc VALUES (4, '2065', 2, 0, false, NULL);
INSERT INTO plan_psector_x_arc VALUES (5, '2085', 1, 0, false, NULL);
INSERT INTO plan_psector_x_arc VALUES (8, '2086', 1, 0, false, NULL);

INSERT INTO plan_psector_x_node VALUES (2, '1076', 1, 0, false, NULL);

INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, descript, link_geom, vnode_geom) VALUES ('3103', NULL, 1, 0, false, NULL, NULL, NULL);
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, descript, link_geom, vnode_geom) VALUES ('3104', NULL, 1, 0, false, NULL, NULL, NULL);
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, descript, link_geom, vnode_geom) VALUES ('3014', NULL, 2, 0, false, NULL, NULL, NULL);

INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, descript, link_geom, vnode_geom) VALUES ('114461', '20851', 1, 1, true, NULL, NULL, NULL);
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, descript, link_geom, vnode_geom) VALUES ('114462', '20851', 1, 1, true, NULL, NULL, NULL);
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, descript, link_geom, vnode_geom) VALUES ('114463', '20651', 2, 1, true, NULL, NULL, NULL);


INSERT INTO doc VALUES ('Demo document 1', 'OTHER', 'https://github.com/Giswater/docs/blob/master/user/manual_usuario_giswater3.doc', NULL, '2018-03-11 19:40:20.449663', current_user, '2018-03-11 19:40:20.449663');
INSERT INTO doc VALUES ('Demo document 3', 'OTHER', 'https://github.com/Giswater/giswater/blob/master-2.1/legal/Licensing.txt', NULL, '2018-03-14 17:09:59.762257', current_user, '2018-03-14 17:09:59.762257');
INSERT INTO doc VALUES ('Demo document 2', 'OTHER', 'https://github.com/Giswater/giswater/blob/master-2.1/legal/Readme.txt', NULL, '2018-03-14 17:09:19.852804', current_user, '2018-03-14 17:09:19.852804');

SELECT gw_fct_connect_to_network($${"client":{"device":4, "infoType":1,"lang":"ES"},"feature":{"id":
"SELECT array_to_json(array_agg(connec_id::text)) FROM v_edit_connec WHERE connec_id IS NOT NULL AND state=1"},
"data":{"feature_type":"CONNEC"}}$$);

-- for connec 3014 that stays outside the selectors and doesn't connect to network with fct
INSERT INTO vnode VALUES ((SELECT nextval('vnode_vnode_id_seq')), 'AUTO', NULL, 3, 2, 1, 1, '0101000020E7640000198F5EB77093194113A8AB6482755141');
INSERT INTO link VALUES ((SELECT nextval('link_link_id_seq')), '3014', 'CONNEC', 483, 'VNODE', FALSE, 1, 1, '0102000020E7640000020000006CAAF3ACD4931941988F62837F755141198F5EB77093194113A8AB6482755141');

--SELECT gw_fct_plan_result($${"client":{"device":4, "infoType":1, "lang":"ES"},
--"feature":{},"data":{"parameters":{"coefficient":1, "description":"Demo prices for reconstruction", "resultType":1, "resultId":"Starting prices","saveOnDatabase":true}}}$$);

SELECT gw_fct_fill_doc_tables();
SELECT gw_fct_fill_om_tables();

INSERT INTO doc_x_visit (doc_id, visit_id)
SELECT 
doc.id,
om_visit.id
FROM doc, om_visit;

update node set link='https://www.giswater.org';
update arc set link='https://www.giswater.org';
update connec set link='https://www.giswater.org';
update rtc_hydrometer set link='https://www.giswater.org';

update cat_feature_node SET isarcdivide=FALSE, num_arcs=0 WHERE id='AIR_VALVE';
UPDATE cat_feature_node SET graf_delimiter='NONE';
UPDATE cat_feature_node SET graf_delimiter='MINSECTOR' WHERE id IN('CHECK_VALVE', 'FL_CONTR_VALVE', 'GEN_PURP_VALVE', 'SHUTOFF_VALVE', 'THROTTLE_VALVE');
UPDATE cat_feature_node SET graf_delimiter='PRESSZONE' WHERE id IN('PR_BREAK_VALVE', 'PR_REDUC_VALVE', 'PR_SUSTA_VALVE');
UPDATE cat_feature_node SET graf_delimiter='DQA' WHERE id IN('CLORINATHOR');
UPDATE cat_feature_node SET graf_delimiter='DMA' WHERE id IN('FLOWMETER');
UPDATE cat_feature_node SET graf_delimiter='SECTOR' WHERE id IN('SOURCE','TANK','WATERWELL','WTP');

INSERT INTO config_mincut_valve VALUES('CHECK_VALVE');
INSERT INTO config_mincut_valve VALUES('FL_CONTR_VALVE');
INSERT INTO config_mincut_valve VALUES('GEN_PURP_VALVE');
INSERT INTO config_mincut_valve VALUES('THROTTLE_VALVE');


update ext_rtc_hydrometer SET state_id=1;

INSERT INTO selector_hydrometer (state_id, cur_user) VALUES (1, 'postgres');

update ext_rtc_hydrometer set connec_id=b.customer_code from rtc_hydrometer_x_connec  a 
join connec b on a.connec_id = b.connec_id
where ext_rtc_hydrometer.id = a.hydrometer_id;


SELECT gw_fct_audit_check_project($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "version":"0", "fid":1}}$$)::text;


SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"OUTFALL_VALVE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"outfallvalve_param_1", "datatype":"string", 
"widgettype":"text", "label":"Outvalve param_1","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True","isenabled":"True"}}}$$);


SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"OUTFALL_VALVE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"outfallvalve_param_2", "datatype":"boolean", 
"widgettype":"check", "label":"Outvalve param_2","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"SHUTOFF_VALVE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"shtvalve_param_1", "datatype":"string", 
"widgettype":"combo", "label":"Shtvalve param_1","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "dv_isnullvalue":"True",
"isenabled":"True","dv_querytext":"SELECT id as id, idval as idval  FROM edit_typevalue WHERE typevalue='shtvalve_param_1'"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"SHUTOFF_VALVE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"shtvalve_param_2", "datatype":"string", 
"widgettype":"text", "label":"Shtvalve param_2","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"GREEN_VALVE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"greenvalve_param_1", "datatype":"boolean", 
"widgettype":"check", "label":"Gvalve param_1","ismandatory":"False",
"fieldLength":null, "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"GREEN_VALVE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"greenvalve_param_2", "datatype":"string", 
"widgettype":"text", "label":"Gvalve param_2","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"AIR_VALVE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"airvalve_param_1", "datatype":"string", 
"widgettype":"text", "label":"Airvalve param_1","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"AIR_VALVE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"airvalve_param_2", "datatype":"integer", 
"widgettype":"text", "label":"Airvalve param_2","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"CHECK_VALVE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"checkvalve_param_1", "datatype":"integer", 
"widgettype":"text", "label":"Check param_1","ismandatory":"False",
"fieldLength":null, "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"CHECK_VALVE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"checkvalve_param_2", "datatype":"string", 
"widgettype":"text", "label":"Check param_2","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"PIPE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"pipe_param_1", "datatype":"string", 
"widgettype":"text", "label":"Pipe param_1","ismandatory":"False",
"fieldLength":"150", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"PRESSURE_METER"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"pressmeter_param_1", "datatype":"string", 
"widgettype":"combo", "label":"Pressmeter param_1","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "dv_isnullvalue":"True",
"isenabled":"True","dv_querytext":"SELECT id as id, idval as idval  FROM edit_typevalue WHERE typevalue='pressmeter_param_1'"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"PRESSURE_METER"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"pressmeter_param_2", "datatype":"date", 
"widgettype":"datetime", "label":"Pressmeter param_2","ismandatory":"False",
"fieldLength":null, "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"FILTER"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"filter_param_1", "datatype":"integer", 
"widgettype":"text", "label":"Filter param_1","ismandatory":"False",
"fieldLength":null, "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"FILTER"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"filter_param_2", "datatype":"string", 
"widgettype":"text", "label":"Filter param_2","ismandatory":"False",
"fieldLength":"200", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"TANK"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"tank_param_1", "datatype":"integer", 
"widgettype":"text", "label":"Tank param_1","ismandatory":"False",
"fieldLength":null, "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"TANK"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"tank_param_2", "datatype":"date", 
"widgettype":"datetime", "label":"Tank param_2","ismandatory":"False",
"fieldLength":null, "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"HYDRANT"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"hydrant_param_1", "datatype":"string", 
"widgettype":"combo", "label":"Hydrant param_1","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "dv_isnullvalue":"True",
"isenabled":"True","dv_querytext":"SELECT id as id, idval as idval  FROM edit_typevalue WHERE typevalue='hydrant_param_1'"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"HYDRANT"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"hydrant_param_2", "datatype":"integer", 
"widgettype":"text", "label":"Hydrant param_2","ismandatory":"False",
"fieldLength":null, "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

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

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, parameter_id)
SELECT 'edit_typevalue','hydrant_param_1','man_addfields_value','value_param',id FROM sys_addfields WHERE param_name='hydrant_param_1';
INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, parameter_id)
SELECT 'edit_typevalue','shtvalve_param_1','man_addfields_value','value_param',id FROM sys_addfields WHERE param_name='shtvalve_param_1';
INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, parameter_id)
SELECT 'edit_typevalue','pressmeter_param_1','man_addfields_value','value_param',id FROM sys_addfields WHERE param_name='pressmeter_param_1';

-- rotate vnodes and connec labels
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('edit_link_connecrotation_update', TRUE, current_user) ON CONFLICT (parameter, cur_user) DO NOTHING;
UPDATE link SET the_geom=the_geom;


--update sys_param_user with cat_feature vdefaults
UPDATE cat_feature SET id=id;

--set enddate NULL for on service features
UPDATE node SET enddate=NULL WHERE state=1;
UPDATE arc SET enddate=NULL WHERE state=1;
UPDATE connec SET enddate=NULL WHERE state=1;

UPDATE cat_node SET ischange=2 WHERE id IN ('TDN160-63 PN16', 'XDN110-90 PN16');
UPDATE cat_node SET ischange=0 WHERE id LIKE '%JUNCTION%';
UPDATE cat_node SET ischange=0 WHERE id LIKE '%ENDLINE%';
UPDATE cat_node SET ischange=1 WHERE id LIKE '%JUNCTION CHNG%';

UPDATE node SET enddate = '2017-12-06' WHERE node_id='18';
UPDATE arc SET enddate = '2017-12-06' WHERE arc_id='113913';

UPDATE cat_arc SET cost = 'VIRTUAL_M', m2bottom_cost = 'VIRTUAL_M2', m3protec_cost = 'VIRTUAL_M3' WHERE id = 'VIRTUAL';

UPDATE connec SET the_geom  = '0101000020E764000044D7D93156941941F95742A672755141' 
WHERE connec_id ='3024';

UPDATE inp_valve SET diameter = 100;

--move closed and broken to the top of lyt_data_2
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=0 WHERE columnname = 'closed' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=1 WHERE columnname = 'broken' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=2 WHERE columnname = 'arc_id' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=3 WHERE columnname = 'parent_id' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=4 WHERE columnname = 'soilcat_id' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=5 WHERE columnname = 'fluid_type' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=6 WHERE columnname = 'function_type' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=7 WHERE columnname = 'category_type' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=8 WHERE columnname = 'location_type' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=9 WHERE columnname = 'annotation' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=10 WHERE columnname = 'observ' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=11 WHERE columnname = 'descript' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=12 WHERE columnname = 'comment' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=13 WHERE columnname = 'num_value' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=14 WHERE columnname = 'svg' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=15 WHERE columnname = 'rotation' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=16 WHERE columnname = 'hemisphere' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=17 WHERE columnname = 'label' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=18 WHERE columnname = 'label_y' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=19 WHERE columnname = 'label_x' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=20 WHERE columnname = 'label_rotation' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=21 WHERE columnname = 'publish' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=22 WHERE columnname = 'undelete' AND formname like '%_valve';
UPDATE config_form_fields SET layoutname='lyt_data_2', layoutorder=23 WHERE columnname = 'inventory' AND formname like '%_valve';

UPDATE ext_streetaxis SET muni_id = 2 WHERE expl_id  = 2;

-- hidden
UPDATE config_form_fields SET hidden = true WHERE columnname 
IN ('undelete', 'publish', 'buildercat_id', 'comment', 'num_value', 'svg', 'macrodqa_id', 'macrosector_id',
'macroexpl_id', 'custom_length', 'staticpressure1', 'staticpressure2', 'pipe_param_1');

UPDATE config_form_fields SET hidden = true WHERE columnname IN ('label_x', 'label_y') AND formname LIKE 've_arc%';


-- reorder sample
UPDATE config_form_fields SET layoutorder =90, layoutname = 'lyt_data_1' WHERE columnname ='link';
UPDATE config_form_fields SET layoutorder =2 , layoutname ='lyt_bot_2' WHERE columnname ='verified';
UPDATE config_form_fields SET layoutorder =1 , layoutname ='lyt_bot_2' WHERE columnname ='sector_id';
UPDATE config_form_fields SET layoutorder =4 , layoutname ='lyt_bot_1' , label = 'Dqa' WHERE columnname ='dqa_id';
UPDATE config_form_fields SET layoutorder =70 , layoutname ='lyt_data_1' WHERE columnname ='macrosector_id';
UPDATE config_form_fields SET stylesheet ='{"label":"color:red; font-weight:bold"}' WHERE columnname IN ('expl_id', 'sector_id');


-- drop constraints
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"DROP"}}$$);

delete from presszone;
INSERT INTO presszone VALUES ('1', 'pzone1-1s', 1, NULL, NULL,  '{"use":[{"nodeParent":"1097", "toArc":[2207]}], "ignore":[]}');
INSERT INTO presszone VALUES ('2', 'pzone1-2s', 2, NULL, NULL, '{"use":[{"nodeParent":"1101", "toArc":[2205]}], "ignore":[]}');
INSERT INTO presszone VALUES ('3', 'pzone1-1d', 1, NULL, NULL, '{"use":[{"nodeParent":"113766", "toArc":[113906]}], "ignore":[]}');
INSERT INTO presszone VALUES ('4', 'pzone1-2d', 1, NULL, NULL, '{"use":[{"nodeParent":"1083", "toArc":[2095]}], "ignore":[]}');
INSERT INTO presszone VALUES ('5', 'pzone2-1s', 2, NULL, NULL, '{"use":[{"nodeParent":"111111", "toArc":[114025]}], "ignore":[]}');
INSERT INTO presszone VALUES ('6', 'pzone2-2d', 2,  NULL, NULL, '{"use":[{"nodeParent":"113952", "toArc":[114146]}], "ignore":[]}');


delete from dma;
INSERT INTO dma VALUES (1, 'dma1-1d', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"use":[{"nodeParent":"113766", "toArc":[113906]}], "ignore":[]}');
INSERT INTO dma VALUES (2, 'dma1-2d', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'dma02_estimated', NULL,'{"use":[{"nodeParent":"1080", "toArc":[2092]}], "ignore":[]}');
INSERT INTO dma VALUES (3, 'dma2-1d', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'dma03_estimated', NULL,'{"use":[{"nodeParent":"113952", "toArc":[114146]}], "ignore":[]}');
INSERT INTO dma VALUES (4, 'source-1', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"use":[{"nodeParent":"1101", "toArc":[2205]},{"nodeParent":"1097", "toArc":[2207]}], "ignore":[]}');
INSERT INTO dma VALUES (5, 'source-2', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"use":[{"nodeParent":"111111", "toArc":[114025]}], "ignore":[]}');


delete from dqa;
INSERT INTO dqa VALUES (1, 'dqa1-1d', 1, NULL, NULL, NULL, NULL, NULL, NULL, 'chlorine','{"use":[{"nodeParent":"113766", "toArc":[113906]}], "ignore":[]}');
INSERT INTO dqa VALUES (2, 'dqa2-1d', 2, NULL, NULL, NULL, NULL, NULL, NULL, 'chlorine','{"use":[{"nodeParent":"113952", "toArc":[114146]}], "ignore":[]}');
INSERT INTO dqa VALUES (3, 'dqa1-1s', 1, NULL, NULL, NULL, NULL, NULL, NULL, 'chlorine','{"use":[{"nodeParent":"1101", "toArc":[2205]},{"nodeParent":"1097", "toArc":[2207]}], "ignore":[]}');
INSERT INTO dqa VALUES (4, 'dqa2-1s', 2, NULL, NULL, NULL, NULL, NULL, NULL, 'chlorine','{"use":[{"nodeParent":"111111", "toArc":[114025]}], "ignore":[]}');


delete from sector;
INSERT INTO sector VALUES (1, 'sector1-1s', 1, NULL, NULL, NULL, 'source','{"use":[{"nodeParent":"1097", "toArc":[2207]}], "ignore":[]}');
INSERT INTO sector VALUES (2, 'sector1-2s', 1, NULL, NULL, NULL, 'source','{"use":[{"nodeParent":"1101", "toArc":[2205]}], "ignore":[]}');
INSERT INTO sector VALUES (3, 'sector1-1d', 1, NULL, NULL, NULL , 'distribution','{"use":[{"nodeParent":"113766", "toArc":[113906]}], "ignore":[]}');
INSERT INTO sector VALUES (4, 'sector2-1s', 2, NULL, NULL, NULL, 'source','{"use":[{"nodeParent":"111111", "toArc":[114025]}], "ignore":[]}');
INSERT INTO sector VALUES (5, 'sector2-1d', 2, NULL, NULL, NULL , 'distribution','{"use":[{"nodeParent":"113952", "toArc":[114146]}], "ignore":[]}');

delete from inp_inlet;
INSERT INTO inp_inlet VALUES ('113766', 1.0000, 0.0000, 3.5000, 12.0000, 0.0000, NULL, NULL);
INSERT INTO inp_inlet VALUES ('113952', 1.0000, 0.0000, 3.5000, 12.0000, 0.0000, NULL, NULL);

UPDATE node SET epa_type='INLET' WHERE node_id IN ('113766', '113952');

delete from inp_reservoir;
INSERT INTO inp_reservoir  VALUES ('111111', NULL);
INSERT INTO inp_reservoir  VALUES ('1097', NULL);
INSERT INTO inp_reservoir  VALUES ('1101', NULL);

update arc set sector_id=0, dma_id=0, dqa_id=0, presszone_id=0;
update node set sector_id=0, dma_id=0, dqa_id=0,  presszone_id=0;
update connec set sector_id=0, dma_id=0, dqa_id=0, presszone_id=0;

INSERT INTO dma VALUES (0, 'Undefined', 0);
INSERT INTO dqa VALUES (0, 'Undefined', 0);
INSERT INTO sector VALUES (0, 'Undefined', 0);
INSERT INTO presszone VALUES (0, 'Undefined',0);

-- add constraints
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"ADD"}}$$);

-- dynamic sectorization
SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"SECTOR", "exploitation": "[1,2]", 
"updateFeature":"TRUE", "updateMapZone":"1","geomParamUpdate":0.85}}}');

SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"DQA", "exploitation": "[1,2]", 
"updateFeature":"TRUE", "updateMapZone":"2","geomParamUpdate":30}}}');

SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"PRESSZONE","exploitation":"[1,2]",
"updateFeature":"TRUE","updateMapZone":"2","geomParamUpdate":20}}}');

SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"DMA", "exploitation": "[1,2]", 
"updateFeature":"TRUE", "updateMapZone":"2","geomParamUpdate":15}}}');

SELECT gw_fct_grafanalytics_minsector('{"data":{"parameters":{"exploitation":"[1,2]", 
"updateFeature":"TRUE", "updateMapZone":"2","geomParamUpdate":10}}}');



-- lastprocess
delete from link where link_id=197;
delete from link where link_id=211;

--select gw_fct_connect_to_network((select array_agg(connec_id)from connec where connec_id IN ('3076', '3177')), 'CONNEC');

update connec set pjoint_id = exit_id, pjoint_type='VNODE' FROM link WHERE link.feature_id=connec_id;

UPDATE connec SET label_rotation=24.5, label_x=3 WHERE connec_id='3014';

INSERT INTO selector_sector (sector_id, cur_user)
SELECT sector_id, current_user FROM sector
ON CONFLICT (sector_id, cur_user) DO NOTHING;

SELECT gw_fct_pg2epa_main($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"data":{"resultId":"gw_check_project", "useNetworkGeom":"false"}}$$);

UPDATE config_param_user SET value = 'TRUE' WHERE parameter = 'audit_project_user_control';

--deprecated fields
UPDATE arc SET _sys_length=NULL;


-- adjustment of ischange
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='1006';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='1025';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='1039';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='1040';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='1057';


UPDATE node SET nodecat_id='TDN63-63 PN16' WHERE node_id='1044';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='1063';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='1067';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='1069';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='1044';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='1063';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='1067';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='1069';
UPDATE node SET nodecat_id='REDUC_200-110 PN16' WHERE node_id='113873';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='113880';
UPDATE node SET nodecat_id='REDUC_160-110 PN16' WHERE node_id='113883';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='113954';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='113955';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='113994';
UPDATE node SET nodecat_id='JUNCTION CHNGMAT' WHERE node_id='114016';

UPDATE man_valve SET closed = TRUE WHERE node_id = '1115';
UPDATE man_valve SET broken = TRUE WHERE node_id IN ('1112', '1093');

UPDATE config_param_system SET value = '{"SECTOR":true, "DMA":true, "PRESSZONE":true, "DQA":true, "MINSECTOR":true}'
WHERE parameter = 'om_dynamicmapzones_status';

UPDATE element SET code = concat ('E',element_id);

UPDATE config_mincut_inlet SET parameters = '{"inletArc":["113907", "113905"]}'
WHERE node_id = '113766';

UPDATE config_mincut_inlet SET parameters = '{"inletArc":["114145"]}'
WHERE node_id = '113952';

UPDATE config_form_fields SET label = 'Presszone' WHERE columnname = 'presszone_id';

update config_form_fields SET layoutorder = 3 where columnname='state' and formname like '%ve_connec_%';
update config_form_fields SET layoutorder = 4 where columnname='state_type' and formname like '%ve_connec_%';

UPDATE cat_feature_node set isprofilesurface = true;

--refactor of forms
UPDATE config_form_fields SET layoutname = 'lyt_data_3', layoutorder = 11 where columnname ='pjoint_id';
UPDATE config_form_fields SET layoutname = 'lyt_data_3', layoutorder = 12 where columnname ='pjoint_type';
UPDATE config_form_fields SET layoutname = 'lyt_data_3', layoutorder = 13 where columnname ='descript';
UPDATE config_form_fields SET layoutname = 'lyt_data_3', layoutorder = 14 where columnname = 'annotation';
UPDATE config_form_fields SET layoutname = 'lyt_data_3', layoutorder = 15 where columnname = 'observ';
UPDATE config_form_fields SET layoutname = 'lyt_data_3', layoutorder = 16 where columnname = 'lastupdate';
UPDATE config_form_fields SET layoutname ='lyt_data_3' , layoutorder = 17 where columnname = 'lastupdate_user';
UPDATE config_form_fields SET layoutname = 'lyt_data_3', layoutorder = 18 where columnname ='link';

UPDATE config_form_fields SET  hidden = true where columnname = 'macrodma_id';
UPDATE config_form_fields SET  hidden = true where columnname = 'inventory';
UPDATE config_form_fields SET  hidden = true where columnname = 'feature_id';
UPDATE config_form_fields SET  hidden = true where columnname = 'featurecat_id';
UPDATE config_form_fields SET  hidden = true where columnname = 'connec_length';

UPDATE config_form_fields SET  hidden = true where columnname = 'depth' AND formname LIKE '%_connec_%';
UPDATE config_form_fields SET  hidden = true where columnname = 'function_type' AND formname LIKE '%_connec_%';
UPDATE config_form_fields SET  hidden = true where columnname = 'descript' AND formname LIKE '%_connec_%';
UPDATE config_form_fields SET  hidden = true where columnname = 'annotation' AND formname LIKE '%_connec_%';

UPDATE config_form_fields SET layoutname = 'lyt_bot_1' where columnname ='state';
UPDATE config_form_fields SET layoutname = 'lyt_bot_1' where columnname ='state_type';
UPDATE config_form_fields SET layoutname = 'lyt_bot_1' where columnname ='sector_id';
UPDATE config_form_fields SET layoutname = 'lyt_data_1',layoutorder = 997 where columnname ='hemisphere';
UPDATE config_form_fields SET layoutorder = 2 where columnname ='dma_id';


UPDATE config_form_fields SET layoutname = 'lyt_data_2', layoutorder = 30 where columnname ='verified';
UPDATE config_form_fields SET layoutname = 'lyt_data_2', layoutorder = 31 where columnname ='presszone_id';
UPDATE config_form_fields SET layoutname = 'lyt_data_2', layoutorder = 32 where columnname ='dqa_id';
UPDATE config_form_fields SET layoutname = 'lyt_data_2', layoutorder = 33 where columnname ='expl_id';
UPDATE config_form_fields SET layoutname = 'lyt_data_1', layoutorder = 998 where columnname ='parent_id';


-- refactor of type's
UPDATE man_type_fluid SET fluid_type = replace (fluid_type, 'Standard', 'St.');
UPDATE man_type_category SET category_type = replace (category_type, 'Standard', 'St.');
UPDATE man_type_location SET location_type = replace (location_type, 'Standard', 'St.');
UPDATE man_type_function SET function_type = replace (function_type, 'Standard', 'St.');

update config_form_fields SET widgettype = 'text' WHERE columnname  = 'macrosector_id' AND dv_querytext = null AND placeholder  ='Ex.macrosector_id';

UPDATE v_edit_node SET nodecat_id = 'CHK-VALVE100-PN16' WHERE node_id = '1092';

INSERT INTO config_mincut_checkvalve (node_id, to_arc) VALUES ('1092', '2104');

UPDATE inp_connec SET demand  = 0.01;

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
UPDATE v_edit_node SET epa_type = 'NOT DEFINED' WHERE node_id = '1007';

-- reconnect connecs
DELETE FROM selector_psector;

-- deprecated on psector 1 and 2
SELECT gw_fct_connect_to_network($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{"id":"[3104, 3103, 3076, 3177]"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_type":"CONNEC"}}$$);


-- update demands and patterns for connec
UPDATE inp_connec SET pattern_id = 'pattern_01', demand = demand*0.5 FROM (SELECT * FROM connec LIMIT 100 OFFSET 0) a WHERE a.connec_id = inp_connec.connec_id;
UPDATE inp_connec SET pattern_id = 'pattern_02', demand = demand*0.3 FROM (SELECT * FROM connec LIMIT 100 OFFSET 100) a WHERE a.connec_id = inp_connec.connec_id;
UPDATE inp_connec SET pattern_id = 'pattern_03', demand = demand*0.25 FROM (SELECT * FROM connec LIMIT 100 OFFSET 200) a WHERE a.connec_id = inp_connec.connec_id;
UPDATE inp_connec SET pattern_id = 'pattern_01', demand = demand*0.5 FROM (SELECT * FROM connec LIMIT 300 OFFSET 300) a WHERE a.connec_id = inp_connec.connec_id;


UPDATE v_edit_arc SET arccat_id = 'VIRTUAL' WHERE arc_type = 'VARC';

UPDATE cat_mat_roughness set roughness  = 0.003;
UPDATE cat_arc SET dint = null, dext = null, dnom = null, descript = 'Virtual arc' WHERE arctype_id = 'VARC';
DELETE FROM cat_arc  WHERE arctype_id = 'VARC' AND id !='VIRTUAL';


UPDATE config_form_fields SET dv_querytext_filterc  = ' AND id ' 
WHERE formname IN ('upsert_catalog_node', 'upsert_catalog_arc', 'upsert_catalog_connec') AND columnname ='matcat_id';

UPDATE inp_junction SET demand = 0 WHERE demand = 16.000000;
UPDATE inp_junction SET demand = 0 , pattern_id  = 'pattern_02' WHERE pattern_id = 'pattern_hydrant';

UPDATE config_param_system SET value='TRUE' WHERE parameter='sys_raster_dem';
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('edit_upsert_elevation_from_dem', 'true', current_user)
ON CONFLICT (parameter, cur_user) DO NOTHING;

UPDATE config_param_user SET value = 'TRUE' WHERE parameter = 'qgis_form_docker' AND cur_user = current_user;

UPDATE presszone SET head=0, stylesheet='{}'  where presszone_id = '0';
UPDATE presszone SET head=100, stylesheet='{"color":[251,181,174]}'  where presszone_id = '1';
UPDATE presszone SET head=100, stylesheet='{"color":[179,205,227]}'  where presszone_id = '2';
UPDATE presszone SET head=100, stylesheet='{"color":[204,235,197]}'  where presszone_id = '3';
UPDATE presszone SET head=100, stylesheet='{"color":[222,203,228]}'  where presszone_id = '4';
UPDATE presszone SET head=100, stylesheet='{"color":[254,217,166]}'  where presszone_id = '5';
UPDATE presszone SET head=100, stylesheet='{"color":[255,255,204]}'  where presszone_id = '6';

UPDATE dma SET stylesheet='{}'  where dma_id = 0;
UPDATE dma SET stylesheet='{"color":[251,181,174]}'  where dma_id = 1;
UPDATE dma SET stylesheet='{"color":[179,205,227]}'  where dma_id = 2;
UPDATE dma SET stylesheet='{"color":[204,235,197]}'  where dma_id = 3;
UPDATE dma SET stylesheet='{"color":[222,203,228]}'  where dma_id = 4;
UPDATE dma SET stylesheet='{"color":[255,255,204]}'  where dma_id = 5;

UPDATE dqa SET stylesheet='{}'  where dqa_id = 0;
UPDATE dqa SET stylesheet='{"color":[251,181,174]}'  where dqa_id = 1;
UPDATE dqa SET stylesheet='{"color":[179,205,227]}'  where dqa_id = 2;
UPDATE dqa SET stylesheet='{"color":[204,235,197]}'  where dqa_id = 3;
UPDATE dqa SET stylesheet='{"color":[222,203,228]}'  where dqa_id = 4;

UPDATE sector SET stylesheet='{}'  where sector_id = 0;
UPDATE sector SET stylesheet='{"color":[251,181,174]}'  where sector_id = 1;
UPDATE sector SET stylesheet='{"color":[179,205,227]}'  where sector_id = 2;
UPDATE sector SET stylesheet='{"color":[204,235,197]}'  where sector_id = 3;
UPDATE sector SET stylesheet='{"color":[222,203,228]}'  where sector_id = 4;
UPDATE sector SET stylesheet='{"color":[255,255,204]}'  where sector_id = 5;

UPDATE config_form_fields SET  layoutname = 'lyt_top_1' where columnname = 'arc_id'AND formname LIKE '%_arc_%';

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



INSERT INTO ext_district (district_id,name, muni_id,active)
values(1,'Camps Blancs',1, true);
INSERT INTO ext_district (district_id,name, muni_id,active)
values(2,'Marianao',1, true);

UPDATE node SET district_id =1 WHERE expl_id=1;
UPDATE node SET district_id =2 WHERE expl_id=2;

UPDATE arc SET district_id =1 WHERE expl_id=1;
UPDATE arc SET district_id =2 WHERE expl_id=2;

UPDATE connec SET district_id =1 WHERE expl_id=1;
UPDATE connec SET district_id =2 WHERE expl_id=2;