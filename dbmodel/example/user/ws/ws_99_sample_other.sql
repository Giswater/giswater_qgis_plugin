/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

UPDATE inp_shortpipe SET to_arc='2092' WHERE node_id='1080';
UPDATE inp_shortpipe SET to_arc=null WHERE node_id='114254';


INSERT INTO cat_users VALUES ('user1','user1');
INSERT INTO cat_users VALUES ('user2','user2');
INSERT INTO cat_users VALUES ('user3','user3');
INSERT INTO cat_users VALUES ('user4','user4');

INSERT INTO cat_manager (idval, expl_id, username, active) VALUES ('general manager', '{1,2}', concat('{',current_user,'}')::text[], true);


INSERT INTO anl_mincut_inlet_x_exploitation VALUES (2, 113766, 1, '{113906}');
INSERT INTO anl_mincut_inlet_x_exploitation VALUES (3, 113952, 2, '{114146}');


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

SELECT gw_fct_connect_to_network($${"client":{"device":3, "infoType":100,"lang":"ES"},"feature":{"id":
"SELECT array_to_json(array_agg(connec_id::text)) FROM v_edit_connec WHERE connec_id IS NOT NULL AND state=1"},
"data":{"feature_type":"CONNEC"}}$$);

-- for connec 3014 that stays outside the selectors and doesn't connect to network with fct
INSERT INTO vnode VALUES ((SELECT nextval('vnode_vnode_id_seq')), 'AUTO', NULL, 3, 2, 1, 1, '0101000020E7640000198F5EB77093194113A8AB6482755141');
INSERT INTO link VALUES ((SELECT nextval('link_link_id_seq')), '3014', 'CONNEC', 483, 'VNODE', FALSE, 1, 1, '0102000020E7640000020000006CAAF3ACD4931941988F62837F755141198F5EB77093194113A8AB6482755141');

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
update rtc_hydrometer set link='https://www.giswater.org';

update node_type SET isarcdivide=FALSE, num_arcs=0 WHERE id='AIR_VALVE';
UPDATE node_type SET graf_delimiter='NONE';
UPDATE node_type SET graf_delimiter='MINSECTOR' WHERE id IN('CHECK_VALVE', 'FL_CONTR_VALVE', 'GEN_PURP_VALVE', 'SHUTOFF_VALVE', 'THROTTLE_VALVE');
UPDATE node_type SET graf_delimiter='PRESSZONE' WHERE id IN('PR_BREAK_VALVE', 'PR_REDUC_VALVE', 'PR_SUSTA_VALVE');
UPDATE node_type SET graf_delimiter='DQA' WHERE id IN('CLORINATHOR');
UPDATE node_type SET graf_delimiter='DMA' WHERE id IN('FLOWMETER');
UPDATE node_type SET graf_delimiter='SECTOR' WHERE id IN('SOURCE','TANK','WATERWELL','WTP');

INSERT INTO anl_mincut_selector_valve VALUES('CHECK_VALVE');
INSERT INTO anl_mincut_selector_valve VALUES('FL_CONTR_VALVE');
INSERT INTO anl_mincut_selector_valve VALUES('GEN_PURP_VALVE');
INSERT INTO anl_mincut_selector_valve VALUES('THROTTLE_VALVE');


update ext_rtc_hydrometer SET state_id=1;

INSERT INTO selector_hydrometer (state_id, cur_user) VALUES (1, 'postgres');

update ext_rtc_hydrometer set connec_id=b.customer_code from rtc_hydrometer_x_connec  a 
join connec b on a.connec_id = b.connec_id
where ext_rtc_hydrometer.id = a.hydrometer_id;


SELECT gw_fct_audit_check_project($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "version":"0", "fprocesscat_id":1}}$$)::text;

SELECT 	gw_fct_admin_manage_child_views($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"catFeature":"PIPE"},
 "data":{"filterFields":{}, "pageInfo":{}, "multi_create":"TRUE" }}$$);


SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"OUTFALL_VALVE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"outfallvalve_param_1", "datatype":"string", 
"widgettype":"text", "label":"Outvalve param_1","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True","isenabled":"True"}}}$$);


SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"OUTFALL_VALVE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"outfallvalve_param_2", "datatype":"boolean", 
"widgettype":"check", "label":"Outvalve param_2","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"SHUTOFF_VALVE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"shtvalve_param_1", "datatype":"string", 
"widgettype":"combo", "label":"Shtvalve param_1","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "dv_isnullvalue":"True",
"isenabled":"True","dv_querytext":"SELECT id as id, idval as idval  FROM edit_typevalue WHERE typevalue='shtvalve_param_1'"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"SHUTOFF_VALVE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"shtvalve_param_2", "datatype":"string", 
"widgettype":"text", "label":"Shtvalve param_2","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"GREEN_VALVE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"greenvalve_param_1", "datatype":"boolean", 
"widgettype":"check", "label":"Gvalve param_1","ismandatory":"False",
"fieldLength":null, "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"GREEN_VALVE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"greenvalve_param_2", "datatype":"string", 
"widgettype":"text", "label":"Gvalve param_2","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"AIR_VALVE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"airvalve_param_1", "datatype":"string", 
"widgettype":"text", "label":"Airvalve param_1","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"AIR_VALVE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"airvalve_param_2", "datatype":"integer", 
"widgettype":"text", "label":"Airvalve param_2","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"CHECK_VALVE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"checkvalve_param_1", "datatype":"integer", 
"widgettype":"text", "label":"Check param_1","ismandatory":"False",
"fieldLength":null, "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"CHECK_VALVE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"checkvalve_param_2", "datatype":"string", 
"widgettype":"text", "label":"Check param_2","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"PIPE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"pipe_param_1", "datatype":"string", 
"widgettype":"text", "label":"Pipe param_1","ismandatory":"False",
"fieldLength":"150", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"PRESSURE_METER"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"pressmeter_param_1", "datatype":"string", 
"widgettype":"combo", "label":"Pressmeter param_1","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "dv_isnullvalue":"True",
"isenabled":"True","dv_querytext":"SELECT id as id, idval as idval  FROM edit_typevalue WHERE typevalue='pressmeter_param_1'"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"PRESSURE_METER"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"pressmeter_param_2", "datatype":"date", 
"widgettype":"datepickertime", "label":"Pressmeter param_2","ismandatory":"False",
"fieldLength":null, "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"FILTER"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"filter_param_1", "datatype":"integer", 
"widgettype":"text", "label":"Filter param_1","ismandatory":"False",
"fieldLength":null, "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"FILTER"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"filter_param_2", "datatype":"string", 
"widgettype":"text", "label":"Filter param_2","ismandatory":"False",
"fieldLength":"200", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"TANK"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"tank_param_1", "datatype":"integer", 
"widgettype":"text", "label":"Tank param_1","ismandatory":"False",
"fieldLength":null, "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"TANK"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"tank_param_2", "datatype":"date", 
"widgettype":"datepickertime", "label":"Tank param_2","ismandatory":"False",
"fieldLength":null, "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"HYDRANT"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"hydrant_param_1", "datatype":"string", 
"widgettype":"combo", "label":"Hydrant param_1","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "dv_isnullvalue":"True",
"isenabled":"True","dv_querytext":"SELECT id as id, idval as idval  FROM edit_typevalue WHERE typevalue='hydrant_param_1'"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"HYDRANT"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"column_id":"hydrant_param_2", "datatype":"integer", 
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

INSERT INTO typevalue_fk(typevalue_table, typevalue_name, target_table, target_field, parameter_id) 
SELECT 'edit_typevalue','hydrant_param_1','man_addfields_value','value_param',id FROM man_addfields_parameter WHERE param_name='hydrant_param_1';
INSERT INTO typevalue_fk(typevalue_table, typevalue_name, target_table, target_field, parameter_id) 
SELECT 'edit_typevalue','shtvalve_param_1','man_addfields_value','value_param',id FROM man_addfields_parameter WHERE param_name='shtvalve_param_1';
INSERT INTO typevalue_fk(typevalue_table, typevalue_name, target_table, target_field, parameter_id) 
SELECT 'edit_typevalue','pressmeter_param_1','man_addfields_value','value_param',id FROM man_addfields_parameter WHERE param_name='pressmeter_param_1';

-- rotate vnodes and connec labels
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('edit_link_connecrotation_update', TRUE, current_user) ON CONFLICT (parameter, cur_user) DO NOTHING;
UPDATE link SET the_geom=the_geom;


--update audit_cat_param_user with cat_feature vdefaults
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
UPDATE config_api_form_fields SET layoutname='lyt_data_2', layout_order=0 WHERE column_id = 'closed' AND formname like '%_valve';
UPDATE config_api_form_fields SET layoutname='lyt_data_2', layout_order=1 WHERE column_id = 'broken' AND formname like '%_valve';
UPDATE config_api_form_fields SET layoutname='lyt_data_2', layout_order=2 WHERE column_id = 'arc_id' AND formname like '%_valve';
UPDATE config_api_form_fields SET layoutname='lyt_data_2', layout_order=3 WHERE column_id = 'parent_id' AND formname like '%_valve';
UPDATE config_api_form_fields SET layoutname='lyt_data_2', layout_order=4 WHERE column_id = 'soilcat_id' AND formname like '%_valve';
UPDATE config_api_form_fields SET layoutname='lyt_data_2', layout_order=5 WHERE column_id = 'fluid_type' AND formname like '%_valve';
UPDATE config_api_form_fields SET layoutname='lyt_data_2', layout_order=6 WHERE column_id = 'function_type' AND formname like '%_valve';
UPDATE config_api_form_fields SET layoutname='lyt_data_2', layout_order=7 WHERE column_id = 'category_type' AND formname like '%_valve';
UPDATE config_api_form_fields SET layoutname='lyt_data_2', layout_order=8 WHERE column_id = 'location_type' AND formname like '%_valve';
UPDATE config_api_form_fields SET layoutname='lyt_data_2', layout_order=9 WHERE column_id = 'annotation' AND formname like '%_valve';
UPDATE config_api_form_fields SET layoutname='lyt_data_2', layout_order=10 WHERE column_id = 'observ' AND formname like '%_valve';
UPDATE config_api_form_fields SET layoutname='lyt_data_2', layout_order=11 WHERE column_id = 'descript' AND formname like '%_valve';
UPDATE config_api_form_fields SET layoutname='lyt_data_2', layout_order=12 WHERE column_id = 'comment' AND formname like '%_valve';
UPDATE config_api_form_fields SET layoutname='lyt_data_2', layout_order=13 WHERE column_id = 'num_value' AND formname like '%_valve';
UPDATE config_api_form_fields SET layoutname='lyt_data_2', layout_order=14 WHERE column_id = 'svg' AND formname like '%_valve';
UPDATE config_api_form_fields SET layoutname='lyt_data_2', layout_order=15 WHERE column_id = 'rotation' AND formname like '%_valve';
UPDATE config_api_form_fields SET layoutname='lyt_data_2', layout_order=16 WHERE column_id = 'hemisphere' AND formname like '%_valve';
UPDATE config_api_form_fields SET layoutname='lyt_data_2', layout_order=17 WHERE column_id = 'label' AND formname like '%_valve';
UPDATE config_api_form_fields SET layoutname='lyt_data_2', layout_order=18 WHERE column_id = 'label_y' AND formname like '%_valve';
UPDATE config_api_form_fields SET layoutname='lyt_data_2', layout_order=19 WHERE column_id = 'label_x' AND formname like '%_valve';
UPDATE config_api_form_fields SET layoutname='lyt_data_2', layout_order=20 WHERE column_id = 'label_rotation' AND formname like '%_valve';
UPDATE config_api_form_fields SET layoutname='lyt_data_2', layout_order=21 WHERE column_id = 'publish' AND formname like '%_valve';
UPDATE config_api_form_fields SET layoutname='lyt_data_2', layout_order=22 WHERE column_id = 'undelete' AND formname like '%_valve';
UPDATE config_api_form_fields SET layoutname='lyt_data_2', layout_order=23 WHERE column_id = 'inventory' AND formname like '%_valve';

UPDATE ext_streetaxis SET muni_id = 2 WHERE expl_id  = 2;

-- hidden
UPDATE config_api_form_fields SET hidden = true WHERE column_id 
IN ('undelete', 'publish', 'buildercat_id', 'comment', 'num_value', 'svg', 'macrodqa_id', 'macrosector_id',
'macroexpl_id', 'custom_length', 'staticpressure1', 'staticpressure2', 'pipe_param_1');

UPDATE config_api_form_fields SET hidden = true WHERE column_id IN ('label_x', 'label_y') AND formname LIKE 've_arc%';


-- reorder sample
UPDATE config_api_form_fields SET layout_order =90, layoutname = 'lyt_data_1' WHERE column_id ='link';
UPDATE config_api_form_fields SET layout_order =2 , layoutname ='lyt_bot_2' WHERE column_id ='verified';
UPDATE config_api_form_fields SET layout_order =1 , layoutname ='lyt_bot_2' WHERE column_id ='sector_id';
UPDATE config_api_form_fields SET layout_order =4 , layoutname ='lyt_bot_1' , label = 'Dqa' WHERE column_id ='dqa_id';
UPDATE config_api_form_fields SET layout_order =70 , layoutname ='lyt_data_1' WHERE column_id ='macrosector_id';
UPDATE config_api_form_fields SET stylesheet ='{"label":"color:red; font-weight:bold"}' WHERE column_id IN ('expl_id', 'sector_id');



-- drop constraints
SELECT gw_fct_admin_schema_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"DROP"}}$$);

delete from cat_presszone;
INSERT INTO cat_presszone VALUES ('1', 'pzone1-1s', 1, NULL, NULL,  '{"use":[{"nodeParent":"1097", "toArc":[2207]}], "ignore":[]}');
INSERT INTO cat_presszone VALUES ('2', 'pzone1-2s', 2, NULL, NULL, '{"use":[{"nodeParent":"1101", "toArc":[2205]}], "ignore":[]}');
INSERT INTO cat_presszone VALUES ('3', 'pzone1-1d', 1, NULL, NULL, '{"use":[{"nodeParent":"113766", "toArc":[113906]}], "ignore":[]}');
INSERT INTO cat_presszone VALUES ('4', 'pzone1-2d', 1, NULL, NULL, '{"use":[{"nodeParent":"1083", "toArc":[2095]}], "ignore":[]}');
INSERT INTO cat_presszone VALUES ('5', 'pzone2-1s', 2, NULL, NULL, '{"use":[{"nodeParent":"111111", "toArc":[114025]}], "ignore":[]}');
INSERT INTO cat_presszone VALUES ('6', 'pzone2-2d', 2,  NULL, NULL, '{"use":[{"nodeParent":"113952", "toArc":[114146]}], "ignore":[]}');


delete from dma;
INSERT INTO dma VALUES (1, 'dma1-1d', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"use":[{"nodeParent":"113766", "toArc":[113906]}], "ignore":[]}');
INSERT INTO dma VALUES (2, 'dma1-2d', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"use":[{"nodeParent":"1080", "toArc":[2092]}], "ignore":[]}');
INSERT INTO dma VALUES (3, 'dma2-1d', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'{"use":[{"nodeParent":"113952", "toArc":[114146]}], "ignore":[]}');
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

update arc set sector_id=0, dma_id=0, dqa_id=0, presszonecat_id=0;
update node set sector_id=0, dma_id=0, dqa_id=0,  presszonecat_id=0;
update connec set sector_id=0, dma_id=0, dqa_id=0, presszonecat_id=0;

INSERT INTO dma VALUES (0, 'Undefined', 0);
INSERT INTO dqa VALUES (0, 'Undefined', 0);
INSERT INTO sector VALUES (0, 'Undefined', 0);
INSERT INTO cat_presszone VALUES (0, 'Undefined',0);

-- add constraints
SELECT gw_fct_admin_schema_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"ADD"}}$$);


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

INSERT INTO inp_selector_sector (sector_id, cur_user)
SELECT sector_id, current_user FROM sector
ON CONFLICT (sector_id, cur_user) DO NOTHING;

SELECT gw_fct_pg2epa_main($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"data":{"iterative":"off", "resultId":"gw_check_project", "useNetworkGeom":"false"}}$$);

UPDATE config_param_user SET value = 'TRUE' WHERE parameter = 'audit_project_user_control';

--deprecated fields
UPDATE arc SET _sys_length=NULL;
UPDATE anl_mincut_inlet_x_exploitation SET _to_arc= NULL;


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

UPDATE anl_mincut_inlet_x_exploitation SET config = '{"inletArc":["113907", "113905"]}'
WHERE node_id = '113766';

UPDATE anl_mincut_inlet_x_exploitation SET config = '{"inletArc":["114145"]}'
WHERE node_id = '113952';

UPDATE config_api_form_fields SET label = 'Presszone' WHERE column_id = 'presszonecat_id';

update config_api_form_fields SET layout_order = 3 where column_id='state' and formname like '%ve_connec_%';
update config_api_form_fields SET layout_order = 4 where column_id='state_type' and formname like '%ve_connec_%';

-- reconnect planned connecs
SELECT gw_fct_connect_to_network($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"id":"[114462, 114461]"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_type":"CONNEC"}}$$);

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

UPDATE config_api_form_fields SET  hidden = true where column_id = 'depth' AND formname LIKE '%_connec_%';
UPDATE config_api_form_fields SET  hidden = true where column_id = 'function_type' AND formname LIKE '%_connec_%';
UPDATE config_api_form_fields SET  hidden = true where column_id = 'descript' AND formname LIKE '%_connec_%';
UPDATE config_api_form_fields SET  hidden = true where column_id = 'annotation' AND formname LIKE '%_connec_%';

UPDATE config_api_form_fields SET layoutname = 'lyt_bot_1' where column_id ='state';
UPDATE config_api_form_fields SET layoutname = 'lyt_bot_1' where column_id ='state_type';
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

update config_api_form_fields SET widgettype = 'text' WHERE column_id  = 'macrosector_id' AND dv_querytext = null AND placeholder  ='Ex.macrosector_id';

UPDATE v_edit_node SET nodecat_id = 'CHK-VALVE100-PN16' WHERE node_id = '1092';

INSERT INTO anl_mincut_checkvalve (node_id, to_arc) VALUES ('1092', '2104');
