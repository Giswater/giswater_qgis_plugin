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

select gw_fct_connect_to_network((select array_agg(connec_id)from connec ), 'CONNEC');

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


refresh MATERIALIZED VIEW v_ui_workcat_polygon_aux;


update ext_rtc_hydrometer SET state_id=1;

INSERT INTO selector_hydrometer (state_id, cur_user) VALUES (1, 'postgres');

update ext_rtc_hydrometer set connec_id=b.customer_code from rtc_hydrometer_x_connec  a 
join connec b on a.connec_id = b.connec_id
where ext_rtc_hydrometer.id = a.hydrometer_id;


select gw_fct_audit_check_project(1);

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
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('edit_link_connecrotation_update', TRUE, current_user);
UPDATE link SET the_geom=the_geom;