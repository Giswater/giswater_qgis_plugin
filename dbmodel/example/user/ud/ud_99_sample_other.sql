/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

INSERT INTO cat_dwf_scenario VALUES (1, 'scenario1', '2017-01-01', '2017-12-31');

UPDATE inp_dwf SET dwfscenario_id=1;


INSERT INTO cat_users VALUES ('user1','user1');
INSERT INTO cat_users VALUES ('user2','user2');
INSERT INTO cat_users VALUES ('user3','user3');
INSERT INTO cat_users VALUES ('user4','user4');

INSERT INTO cat_manager (idval, expl_id, username, active) VALUES ('general manager', '{1,2}', concat('{',current_user,'}')::text[], true);

UPDATE plan_arc_x_pavement SET pavcat_id = 'Asphalt';
	
TRUNCATE plan_psector_x_arc;
INSERT INTO plan_psector_x_arc VALUES (1, '20603', 1, 1, true, NULL);
INSERT INTO plan_psector_x_arc VALUES (2, '20604', 1, 1, true, NULL);
INSERT INTO plan_psector_x_arc VALUES (3, '20605', 1, 1, true, NULL);
INSERT INTO plan_psector_x_arc VALUES (5, '20602', 1, 1, true, NULL);
INSERT INTO plan_psector_x_arc VALUES (6, '20606', 1, 1, true, NULL);
INSERT INTO plan_psector_x_arc VALUES (4, '252', 2, 1, true, NULL);
INSERT INTO plan_psector_x_arc VALUES (7, '251', 2, 1, true, NULL);
INSERT INTO plan_psector_x_arc VALUES (8, '20608', 2, 0, false, NULL);
INSERT INTO plan_psector_x_arc VALUES (9, '157', 2, 0, false, NULL);
INSERT INTO plan_psector_x_arc VALUES (10, '177', 1, 0, false, NULL);
INSERT INTO plan_psector_x_arc VALUES (11, '178', 1, 0, false, NULL);
INSERT INTO plan_psector_x_arc VALUES (13, '179', 1, 0, false, NULL);
INSERT INTO plan_psector_x_arc VALUES (12, '339', 1, 0, false, NULL);

-- redo values


TRUNCATE plan_psector_x_node;
INSERT INTO plan_psector_x_node (id, node_id, psector_id, state, doable, descript) VALUES (1, '20599', 1, 1, true, NULL);
INSERT INTO plan_psector_x_node (id, node_id, psector_id, state, doable, descript) VALUES (2, '20596', 1, 1, true, NULL);
INSERT INTO plan_psector_x_node (id, node_id, psector_id, state, doable, descript) VALUES (3, '20597', 1, 1, true, NULL);
INSERT INTO plan_psector_x_node (id, node_id, psector_id, state, doable, descript) VALUES (4, '20598', 1, 1, true, NULL);
INSERT INTO plan_psector_x_node (id, node_id, psector_id, state, doable, descript) VALUES (7, '94', 1, 0, false, NULL);
INSERT INTO plan_psector_x_node (id, node_id, psector_id, state, doable, descript) VALUES (6, '92', 1, 0, false, NULL);
INSERT INTO plan_psector_x_node (id, node_id, psector_id, state, doable, descript) VALUES (5, '91', 1, 0, false, NULL);
	
TRUNCATE plan_psector_x_connec;
--PSECTOR 1
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, descript, link_geom, vnode_geom) VALUES ('3174', '178', 1, 0, false, NULL, NULL, NULL);
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, descript, link_geom, vnode_geom) VALUES ('3175', '339', 1, 0, false, NULL, NULL, NULL);
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, descript, link_geom, vnode_geom) VALUES ('3181', '339', 1, 0, false, NULL, NULL, NULL);
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, descript, link_geom, vnode_geom) VALUES ('3182', '179', 1, 0, false, NULL, NULL, NULL);
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, descript, link_geom, vnode_geom) VALUES ('3183', '179', 1, 0, false, NULL, NULL, NULL);
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, descript, link_geom, vnode_geom) VALUES ('3184', '179', 1, 0, false, NULL, NULL, NULL);
INSERT INTO plan_psector_x_gully (gully_id, arc_id, psector_id, state, doable, descript, link_geom, vnode_geom) VALUES ('30053', '179', 1, 0, false, NULL, NULL, NULL);
INSERT INTO plan_psector_x_gully (gully_id, arc_id, psector_id, state, doable, descript, link_geom, vnode_geom) VALUES ('30056', '339', 1, 0, false, NULL, NULL, NULL);
INSERT INTO plan_psector_x_gully (gully_id, arc_id, psector_id, state, doable, descript, link_geom, vnode_geom) VALUES ('30057', '178', 1, 0, false, NULL, NULL, NULL);
INSERT INTO plan_psector_x_gully (gully_id, arc_id, psector_id, state, doable, descript, link_geom, vnode_geom) VALUES ('30058', '178', 1, 0, false, NULL, NULL, NULL);
INSERT INTO plan_psector_x_gully (gully_id, arc_id, psector_id, state, doable, descript, link_geom, vnode_geom) VALUES ('30059', '177', 1, 0, false, NULL, NULL, NULL);

--PSECTOR 2
INSERT INTO plan_psector_x_gully (gully_id, arc_id, psector_id, state, doable, descript, link_geom, vnode_geom) VALUES ('30070', '157', 2, 0, false, NULL, NULL, NULL);
INSERT INTO plan_psector_x_gully (gully_id, arc_id, psector_id, state, doable, descript, link_geom, vnode_geom) VALUES ('30110', '157', 2, 0, false, NULL, NULL, NULL);
INSERT INTO plan_psector_x_gully (gully_id, arc_id, psector_id, state, doable, descript, link_geom, vnode_geom) VALUES ('30072', '20608', 2, 0, false, NULL, NULL, NULL);
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, descript, link_geom, vnode_geom) VALUES ('3080', '157', 2, 0, false, NULL, NULL, NULL);
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, descript, link_geom, vnode_geom) VALUES ('3029', '158', 2, 0, false, NULL, NULL, NULL);
INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, descript, link_geom, vnode_geom) VALUES ('100018', '251', 2, 1, true, NULL, '0102000020E76400000200000002A4D88FD6931941A9D45FDE6A755141736891EDB39319413333334363755141', '0101000020E7640000736891EDB39319413333334363755141');
INSERT INTO plan_psector_x_gully (gully_id, arc_id, psector_id, state, doable, descript, link_geom, vnode_geom) VALUES ('100012', '252', 2, 1, true, NULL, NULL, NULL);
INSERT INTO plan_psector_x_gully (gully_id, arc_id, psector_id, state, doable, descript, link_geom, vnode_geom) VALUES ('100013', '156', 2, 1, true, NULL, NULL, NULL);


INSERT INTO doc VALUES ('Demo document 1', 'OTHER', 'https://github.com/Giswater/docs/blob/master/user/manual_usuario_giswater3.doc', NULL, '2018-03-11 19:40:20.449663', current_user, '2018-03-11 19:40:20.449663');
INSERT INTO doc VALUES ('Demo document 3', 'OTHER', 'https://github.com/Giswater/giswater/blob/master-2.1/legal/Licensing.txt', NULL, '2018-03-14 17:09:59.762257', current_user, '2018-03-14 17:09:59.762257');
INSERT INTO doc VALUES ('Demo document 2', 'OTHER', 'https://github.com/Giswater/giswater/blob/master-2.1/legal/Readme.txt', NULL, '2018-03-14 17:09:19.852804', current_user, '2018-03-14 17:09:19.852804');

DELETE FROM selector_psector;

UPDATE connec SET state=2, state_type=3 WHERE connec_id='3080';
UPDATE gully SET state=2, state_type=3 WHERE gully_id IN ('30070','30072','30110');

SELECT gw_fct_connect_to_network($${"client":{"device":3, "infoType":100,"lang":"ES"},"feature":{"id":
"SELECT array_to_json(array_agg(connec_id::text)) FROM v_edit_connec WHERE connec_id IS NOT NULL AND state=1"},
"data":{"feature_type":"CONNEC"}}$$);

SELECT gw_fct_connect_to_network($${"client":{"device":3, "infoType":100,"lang":"ES"},"feature":{"id":
"SELECT array_to_json(array_agg(gully_id::text)) FROM v_edit_gully WHERE gully_id IS NOT NULL AND state=1"},
"data":{"feature_type":"GULLY"}}$$);

-- rotate vnodes and connec labels
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('edit_link_connecrotation_update', TRUE, current_user);
UPDATE link SET the_geom=the_geom;

SELECT gw_fct_plan_result($${"client":{"device":3, "infoType":100, "lang":"ES"},
							"feature":{},"data":{"parameters":{"coefficient":1, "description":"Demo prices for reconstruction", "resultType":1, "resultId":"Starting prices","saveOnDatabase":true}}}$$);
							
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
update gully set link='https://www.giswater.org';


SELECT gw_fct_audit_check_project($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "version":"0", "fprocesscat_id":1}}$$)::text;

SELECT 	gw_fct_admin_manage_child_views($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"catFeature":"CONDUIT"},
 "data":{"filterFields":{}, "pageInfo":{}, "multi_create":"TRUE" }}$$);


SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"CHAMBER"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"chamber_param_1", "datatype":"string", 
"widgettype":"combo", "label":"Chamber param_1","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True",  "dv_isnullvalue":"True",
"isenabled":"True","dv_querytext":"SELECT id as id, idval as idval  FROM edit_typevalue WHERE typevalue='chamber_param_1'"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"CHAMBER"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"chamber_param_2", "datatype":"date", 
"widgettype":"datepickertime", "label":"Chamber param_2","ismandatory":"False",
"fieldLength":null, "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"CIRC_MANHOLE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"cirmanhole_param_1", "datatype":"integer", 
"widgettype":"text", "label":"Cmanhole param_1","ismandatory":"False",
"fieldLength":"10", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"CIRC_MANHOLE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"cirmanhole_param_2", "datatype":"string", 
"widgettype":"text", "label":"Cmanhole param_2","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"PGULLY"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"grate_param_1", "datatype":"string", 
"widgettype":"combo", "label":"Grate param_1","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True",  "dv_isnullvalue":"True",
"isenabled":"True","dv_querytext":"SELECT id as id, idval as idval  FROM edit_typevalue WHERE typevalue='grate_param_1'"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"PGULLY"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"grate_param_2", "datatype":"boolean", 
"widgettype":"check", "label":"Grate param_2","ismandatory":"False",
"fieldLength":null, "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"OWERFLOW_STORAGE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"owestorage_param_1", "datatype":"integer", 
"widgettype":"text", "label":"Owstorage param_1","ismandatory":"False",
"fieldLength":"10", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"OWERFLOW_STORAGE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"owestorage_param_2", "datatype":"string", 
"widgettype":"text", "label":"Owstorage param_2","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"PUMP_PIPE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"pumpipe_param_1", "datatype":"boolean", 
"widgettype":"check", "label":"Ppipe param_1","ismandatory":"False",
"fieldLength":null, "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"PUMP_PIPE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"pumpipe_param_2", "datatype":"string", 
"widgettype":"text", "label":"Ppipe param_2","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"RECT_MANHOLE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"recmanhole_param_1", "datatype":"string", 
"widgettype":"text", "label":"Rect. mhole param_1","ismandatory":"False",
"fieldLength":"500", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"RECT_MANHOLE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"recmanhole_param_2", "datatype":"string", 
"widgettype":"text", "label":"Rect. mhole param_2","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"REGISTER"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"register_param_1", "datatype":"string", 
"widgettype":"text", "label":"Register param_1","ismandatory":"False",
"fieldLength":"500", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"REGISTER"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"register_param_2", "datatype":"string", 
"widgettype":"text", "label":"Register param_2","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"SEWER_STORAGE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"sewstorage_param_1", "datatype":"string", 
"widgettype":"combo", "label":"Sstorage param_1","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True",  "dv_isnullvalue":"True",
"isenabled":"True","dv_querytext":"SELECT id as id, idval as idval  FROM edit_typevalue WHERE typevalue='sewstorage_param_1'"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"SEWER_STORAGE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"sewstorage_param_2", "datatype":"string", 
"widgettype":"text", "label":"Sstorage param_1","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"WEIR"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"weir_param_1", "datatype":"integer", 
"widgettype":"text", "label":"Weir param_1","ismandatory":"False",
"fieldLength":null, "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"WEIR"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"weir_param_2", "datatype":"string", 
"widgettype":"text", "label":"Weir param_2","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);


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

INSERT INTO typevalue_fk(typevalue_table, typevalue_name, target_table, target_field, parameter_id) 
SELECT 'edit_typevalue','sewstorage_param_1','man_addfields_value','value_param',id FROM man_addfields_parameter WHERE param_name='sewstorage_param_1';
INSERT INTO typevalue_fk(typevalue_table, typevalue_name, target_table, target_field, parameter_id) 
SELECT 'edit_typevalue','grate_param_1','man_addfields_value','value_param',id FROM man_addfields_parameter WHERE param_name='grate_param_1';
INSERT INTO typevalue_fk(typevalue_table, typevalue_name, target_table, target_field, parameter_id) 
SELECT 'edit_typevalue','chamber_param_1','man_addfields_value','value_param',id FROM man_addfields_parameter WHERE param_name='chamber_param_1';


-- redo missed values for some arcs
UPDATE arc SET sys_elev1=56.76 , sys_elev2=56.45 WHERE arc_id='100003';
UPDATE arc SET sys_elev1=56.45 , sys_elev2=53.15 WHERE arc_id='100004';
UPDATE arc SET sys_elev1=53.15 , sys_elev2=53 WHERE arc_id='100005';
UPDATE arc SET sys_elev1=53 , sys_elev2=51.15 WHERE arc_id='100009';
UPDATE arc SET sys_elev1=51.15 , sys_elev2=48.95 WHERE arc_id='100010';
UPDATE arc SET sys_elev1=46.92 , sys_elev2=48.95 WHERE arc_id='100011';

-- calculate values for connecs and gullys
-- connec y1 & y2
UPDATE connec c SET y1=vnode_ymax FROM v_arc_x_vnode v WHERE v.feature_id=c.connec_id;
UPDATE connec c SET y2=vnode_ymax-0.4 FROM v_arc_x_vnode v WHERE v.feature_id=c.connec_id AND c.y1>1.2;
UPDATE connec c SET y2=vnode_ymax-0.2 FROM v_arc_x_vnode v WHERE v.feature_id=c.connec_id AND c.y1<1.2;
-- connec_length
UPDATE connec SET connec_length=ST_Length(link.the_geom) FROM link WHERE link.feature_id=connec_id AND link.feature_type='CONNEC';
UPDATE gully SET connec_length=ST_Length(link.the_geom) FROM link WHERE link.feature_id=gully_id AND link.feature_type='GULLY';

-- gully connec_depth
UPDATE gully SET connec_depth='1.2';

--set enddate NULL for on service features
UPDATE node SET enddate=NULL WHERE state=1;
UPDATE arc SET enddate=NULL WHERE state=1;
UPDATE connec SET enddate=NULL WHERE state=1;
UPDATE gully SET enddate=NULL WHERE state=1;

-- set customer_code NULL
UPDATE connec SET customer_code=NULL;


INSERT INTO inp_selector_sector (sector_id, cur_user)
SELECT sector_id, current_user FROM sector
ON CONFLICT (sector_id, cur_user) DO NOTHING;


SELECT gw_fct_pg2epa_main($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"data":{"iterative":"off", "resultId":"gw_check_project", "useNetworkGeom":"false"}}$$);

UPDATE config_param_user SET value = 'TRUE' WHERE parameter = 'audit_project_user_control';

--deprecated fields
UPDATE arc SET _sys_length=NULL;
UPDATE node SET _sys_elev=NULL;
UPDATE node SET elev = null WHERE top_elev IS NOT NULL AND ymax IS NOT NULL;

UPDATE connec SET customer_code = concat('cc',connec_id);

UPDATE cat_grate SET cost_ut = 'N_BGRT1' WHERE id='N/I';

UPDATE cat_arc SET cost = 'VIRTUAL_M', m2bottom_cost = 'VIRTUAL_M2', m3protec_cost = 'VIRTUAL_M3' WHERE id = 'VIRTUAL';

UPDATE element SET code = concat ('E',element_id);

UPDATE cat_feature SET id=id;


UPDATE connec SET the_geom  = '0101000020E764000044D7D93156941941F95742A672755141' 
WHERE connec_id ='3024';

UPDATE ext_streetaxis SET muni_id = 2 WHERE expl_id  = 2;


-- hidden
UPDATE config_api_form_fields SET hidden = true WHERE column_id 
IN ('undelete', 'publish', 'buildercat_id', 'comment', 'num_value', 'svg', 'macrodqa_id', 'macrosector_id',
'macroexpl_id', 'custom_length', 'staticpressure1', 'staticpressure2', 'pipe_param_1');

UPDATE config_api_form_fields SET hidden = true WHERE column_id IN ('label_x', 'label_y') AND formname LIKE 've_arc%';

-- reorder sample
UPDATE config_api_form_fields SET layout_order =90, layoutname = 'lyt_data_1' WHERE column_id ='link';
UPDATE config_api_form_fields SET layout_order =1 , layoutname ='lyt_bot_2' WHERE column_id ='sector_id';
UPDATE config_api_form_fields SET layout_order =4 , layoutname ='lyt_bot_1' , label = 'Dqa' WHERE column_id ='dqa_id';
UPDATE config_api_form_fields SET layout_order =70 , layoutname ='lyt_data_1' WHERE column_id ='macrosector_id';
UPDATE config_api_form_fields SET stylesheet ='{"label":"color:red; font-weight:bold"}' WHERE column_id IN ('expl_id', 'sector_id');

update config_api_form_fields SET layout_order = 3 where column_id='state' and formname like '%ve_connec_%';
update config_api_form_fields SET layout_order = 4 where column_id='state_type' and formname like '%ve_connec_%';

UPDATE node_type set isprofilesurface = true;

--refactor of forms
UPDATE config_api_form_fields SET layoutname = 'lyt_data_3', layout_order = 11 where column_id ='pjoint_id';
UPDATE config_api_form_fields SET layoutname = 'lyt_data_3', layout_order = 12 where column_id ='pjoint_type';
UPDATE config_api_form_fields SET layoutname = 'lyt_data_3', layout_order = 13 where column_id ='descript';
UPDATE config_api_form_fields SET layoutname = 'lyt_data_3', layout_order = 14 where column_id = 'annotation';
UPDATE config_api_form_fields SET layoutname = 'lyt_data_3', layout_order = 15 where column_id = 'observ';
UPDATE config_api_form_fields SET layoutname = 'lyt_data_3', layout_order = 16 where column_id = 'lastupdate';
UPDATE config_api_form_fields SET layoutname ='lyt_data_3' , layout_order = 17 where column_id = 'lastupdate_user';
UPDATE config_api_form_fields SET layoutname = 'lyt_data_3', layout_order = 18 where column_id ='link';

UPDATE config_api_form_fields SET  hidden = true where column_id = 'macrodma_id';
UPDATE config_api_form_fields SET  hidden = true where column_id = 'inventory';
UPDATE config_api_form_fields SET  hidden = true where column_id = 'feature_id';
UPDATE config_api_form_fields SET  hidden = true where column_id = 'featurecat_id';
UPDATE config_api_form_fields SET  hidden = true where column_id = 'connec_length';

UPDATE config_api_form_fields SET  hidden = true where column_id = 'cmanhole_param_1';
UPDATE config_api_form_fields SET  hidden = true where column_id = 'cmanhole_param_2';


UPDATE config_api_form_fields SET  hidden = true where column_id IN ('accessibility', 'inlet');

UPDATE config_api_form_fields SET  layoutname = 'lyt_data_2' where column_id IN ('bottom_channel','sander_depth','length', 'width') AND formname LIKE '%_node_%';

UPDATE config_api_form_fields SET layoutname = 'lyt_data_2',  layout_order = 40 where column_id ='workcat_id_end' AND formname LIKE '%_connec_%';
UPDATE config_api_form_fields SET layoutname = 'lyt_data_2' , layout_order = 40 where column_id ='workcat_id_end' AND formname LIKE '%_gully_%';
UPDATE config_api_form_fields SET layoutname = 'lyt_data_2' , layout_order = 40 where column_id ='workcat_id_end' AND formname LIKE '%_arc_%';


UPDATE config_api_form_fields SET  hidden = true where column_id = 'z1';
UPDATE config_api_form_fields SET  hidden = true where column_id = 'z2';
UPDATE config_api_form_fields SET  hidden = true where column_id = 'cat_geom2' AND formname LIKE '%_arc_%';
UPDATE config_api_form_fields SET  hidden = true where column_id = 'cat_shape' AND formname LIKE '%_arc_%';
UPDATE config_api_form_fields SET  hidden = true where column_id = 'soilcat_id' AND formname LIKE '%_arc_%';


UPDATE config_api_form_fields SET  hidden = true where column_id = 'depth' AND formname LIKE '%_connec_%';
UPDATE config_api_form_fields SET  hidden = true where column_id = 'function_type' AND formname LIKE '%_connec_%';
UPDATE config_api_form_fields SET  hidden = true where column_id = 'descript' AND formname LIKE '%_connec_%';
UPDATE config_api_form_fields SET  hidden = true where column_id = 'annotation' AND formname LIKE '%_connec_%';

UPDATE config_api_form_fields SET layoutname = 'lyt_bot_1', layout_order = 3 where column_id ='state';
UPDATE config_api_form_fields SET layoutname = 'lyt_bot_1', layout_order = 4 where column_id ='state_type';
UPDATE config_api_form_fields SET layoutname = 'lyt_bot_1' where column_id ='sector_id';
UPDATE config_api_form_fields SET layoutname = 'lyt_data_1',layout_order = 997 where column_id ='hemisphere';
UPDATE config_api_form_fields SET layout_order = 2 where column_id ='dma_id';

UPDATE config_api_form_fields SET layoutname = 'lyt_data_2', layout_order = 30 where column_id ='verified';
UPDATE config_api_form_fields SET layoutname = 'lyt_data_2', layout_order = 31 where column_id ='presszonecat_id';
UPDATE config_api_form_fields SET layoutname = 'lyt_data_2', layout_order = 32 where column_id ='dqa_id';
UPDATE config_api_form_fields SET layoutname = 'lyt_data_2', layout_order = 33 where column_id ='expl_id';
UPDATE config_api_form_fields SET layoutname = 'lyt_data_1', layout_order = 998 where column_id ='parent_id';


-- refactor of type's
UPDATE man_type_fluid SET fluid_type = replace (fluid_type, 'Standard', 'St.');
UPDATE man_type_category SET category_type = replace (category_type, 'Standard', 'St.');
UPDATE man_type_location SET location_type = replace (location_type, 'Standard', 'St.');
UPDATE man_type_function SET function_type = replace (function_type, 'Standard', 'St.');

update config_api_form_fields SET widgettype = 'text', dv_querytext = null, placeholder  ='Ex.macrosector_id' WHERE column_id  = 'macrosector_id';

UPDATE connec SET connec_depth = 1.5;