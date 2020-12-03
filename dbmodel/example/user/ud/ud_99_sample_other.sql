/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


INSERT INTO sys_function VALUES (2916, 'gw_fct_fill_doc_tables','ud','function','void','void','Create example documents (used on sample creation)','role_admin',false);
INSERT INTO sys_function VALUES (2886, 'gw_fct_fill_om_tables','ud','function','void','void','Create example visits (used on sample creation)','role_admin',false);
UPDATE sys_function SET input_params ='void', return_type ='void' WHERE id =2916;
UPDATE sys_function SET input_params ='void', return_type ='void' WHERE id =2886;


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

TRUNCATE plan_psector_x_node;
INSERT INTO plan_psector_x_node (id, node_id, psector_id, state, doable, descript) VALUES (1, '20599', 1, 1, true, NULL);
INSERT INTO plan_psector_x_node (id, node_id, psector_id, state, doable, descript) VALUES (2, '20596', 1, 1, true, NULL);
INSERT INTO plan_psector_x_node (id, node_id, psector_id, state, doable, descript) VALUES (3, '20597', 1, 1, true, NULL);
INSERT INTO plan_psector_x_node (id, node_id, psector_id, state, doable, descript) VALUES (4, '20598', 1, 1, true, NULL);
INSERT INTO plan_psector_x_node (id, node_id, psector_id, state, doable, descript) VALUES (7, '94', 1, 0, false, NULL);
INSERT INTO plan_psector_x_node (id, node_id, psector_id, state, doable, descript) VALUES (6, '92', 1, 0, false, NULL);
INSERT INTO plan_psector_x_node (id, node_id, psector_id, state, doable, descript) VALUES (5, '91', 1, 0, false, NULL);

INSERT INTO plan_psector_x_connec VALUES (1, '3174', '178', 1, 0, false, NULL, '0102000020E76400000200000071E182D2E8941941ADDF47B1067551415778FF7BBC941941539C918B04755141', '0101000020E76400005778FF7BBC941941539C918B04755141', false);
INSERT INTO plan_psector_x_connec VALUES (2, '3175', '339', 1, 0, false, NULL, '0102000020E764000002000000046B75D5FE9419414AF99C8FFB74514187BF4D741C951941E2C4E01EFD745141', '0101000020E764000087BF4D741C951941E2C4E01EFD745141', false);
INSERT INTO plan_psector_x_connec VALUES (3, '3181', '339', 1, 0, false, NULL, '0102000020E76400000200000030544DCF389619412E91C1AEF4745141B04AF06CF5951941E505873AFD745141', '0101000020E7640000B04AF06CF5951941E505873AFD745141', false);
INSERT INTO plan_psector_x_connec VALUES (4, '3182', '179', 1, 0, false, NULL, '0102000020E764000002000000CC1A77AA4B96194179A847BEF57451412F9AE8F608961941169357D9FD745141', '0101000020E76400002F9AE8F608961941169357D9FD745141', false);
INSERT INTO plan_psector_x_connec VALUES (5, '3183', '179', 1, 0, false, NULL, '0102000020E764000002000000BC063C5982961941272C83B0F8745141EA43A061479619418070F7DAFF745141', '0101000020E7640000EA43A061479619418070F7DAFF745141', false);
INSERT INTO plan_psector_x_connec VALUES (6, '3184', '179', 1, 0, false, NULL, '0102000020E764000002000000A3561C17979619416E3409C0F97451414CA3BCAF5E9619411831BE9A00755141', '0101000020E76400004CA3BCAF5E9619411831BE9A00755141', false);
INSERT INTO plan_psector_x_connec VALUES (8, '3029', '158', 2, 0, false, NULL, '0102000020E76400000200000050AF19AEE0931941D07042A06A75514174A28732C89319411CE10E0263755141', '0101000020E764000074A28732C89319411CE10E0263755141', false);
INSERT INTO plan_psector_x_connec VALUES (10, '100014', '252', 2, 1, true, NULL, '0102000020E7640000020000003A3AFDE9A7931941047959F36875514164C4E4443E931941CC4795396A755141', '0101000020E764000064C4E4443E931941CC4795396A755141', false);

INSERT INTO plan_psector_x_gully VALUES (1, '30053', '179', 1, 0, false, NULL, '0102000020E764000002000000BCB9BE0B5996194125D47F89F7745141933718381F9619417B5C7990FE745141', '0101000020E7640000933718381F9619417B5C7990FE745141', false);
INSERT INTO plan_psector_x_gully VALUES (2, '30056', '339', 1, 0, false, NULL, '0102000020E764000002000000C9CE8A002F9519414D50F69AF8745141FD947A9B3E9519416A41C44BFB745141', '0101000020E7640000FD947A9B3E9519416A41C44BFB745141', false);
INSERT INTO plan_psector_x_gully VALUES (3, '30057', '178', 1, 0, false, NULL, '0102000020E7640000020000006D67FE5DF8941941313447A80275514141155E93E1941941F02BB48D01755141', '0101000020E764000041155E93E1941941F02BB48D01755141', false);
INSERT INTO plan_psector_x_gully VALUES (4, '30058', '178', 1, 0, false, NULL, '0102000020E764000002000000657E1E6ECB9419412635F3C800755141B7609638DF9419410E7152BE01755141', '0101000020E7640000B7609638DF9419410E7152BE01755141', false);
INSERT INTO plan_psector_x_gully VALUES (5, '30059', '177', 1, 0, false, NULL, '0102000020E764000002000000381E1D8A469419416EA9DE4C11755141170CBCC42F941941FE4DB33F10755141', '0101000020E7640000170CBCC42F941941FE4DB33F10755141', false);
INSERT INTO plan_psector_x_gully VALUES (11, '100012', '252', 2, 1, true, NULL, '0102000020E764000002000000E1A04978289319411915328C697551416EB749783B93194130F3855169755141', '0101000020E76400006EB749783B93194130F3855169755141', false);
INSERT INTO plan_psector_x_gully VALUES (12, '100013', '251', 2, 1, true, NULL, '0102000020E764000002000000DEB292FD4A9319413F1519DF62755141EB2CC71750931941468E795864755141', '0101000020E7640000EB2CC71750931941468E795864755141', false);



INSERT INTO doc VALUES ('Demo document 1', 'OTHER', 'https://github.com/Giswater/docs/blob/master/user/manual_usuario_giswater3.doc', NULL, '2018-03-11 19:40:20.449663', current_user, '2018-03-11 19:40:20.449663');
INSERT INTO doc VALUES ('Demo document 3', 'OTHER', 'https://github.com/Giswater/giswater/blob/master-2.1/legal/Licensing.txt', NULL, '2018-03-14 17:09:59.762257', current_user, '2018-03-14 17:09:59.762257');
INSERT INTO doc VALUES ('Demo document 2', 'OTHER', 'https://github.com/Giswater/giswater/blob/master-2.1/legal/Readme.txt', NULL, '2018-03-14 17:09:19.852804', current_user, '2018-03-14 17:09:19.852804');



-- rotate vnodes and connec labels
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('edit_link_connecrotation_update', TRUE, current_user);
UPDATE link SET the_geom=the_geom;


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
 "data":{"filterFields":{}, "pageInfo":{}, "multi_create":"TRUE" }}$$);


SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"CHAMBER"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"chamber_param_1", "datatype":"string", 
"widgettype":"combo", "label":"Chamber param_1","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True",  "dv_isnullvalue":"True",
"isenabled":"True","dv_querytext":"SELECT id as id, idval as idval  FROM edit_typevalue WHERE typevalue='chamber_param_1'"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"CHAMBER"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"chamber_param_2", "datatype":"date", 
"widgettype":"datetime", "label":"Chamber param_2","ismandatory":"False",
"fieldLength":null, "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"CIRC_MANHOLE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"cirmanhole_param_1", "datatype":"integer", 
"widgettype":"text", "label":"Cmanhole param_1","ismandatory":"False",
"fieldLength":"10", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"CIRC_MANHOLE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"cirmanhole_param_2", "datatype":"string", 
"widgettype":"text", "label":"Cmanhole param_2","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"PGULLY"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"grate_param_1", "datatype":"string", 
"widgettype":"combo", "label":"Grate param_1","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True",  "dv_isnullvalue":"True",
"isenabled":"True","dv_querytext":"SELECT id as id, idval as idval  FROM edit_typevalue WHERE typevalue='grate_param_1'"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"PGULLY"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"grate_param_2", "datatype":"boolean", 
"widgettype":"check", "label":"Grate param_2","ismandatory":"False",
"fieldLength":null, "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"OWERFLOW_STORAGE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"owestorage_param_1", "datatype":"integer", 
"widgettype":"text", "label":"Owstorage param_1","ismandatory":"False",
"fieldLength":"10", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"OWERFLOW_STORAGE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"owestorage_param_2", "datatype":"string", 
"widgettype":"text", "label":"Owstorage param_2","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"PUMP_PIPE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"pumpipe_param_1", "datatype":"boolean", 
"widgettype":"check", "label":"Ppipe param_1","ismandatory":"False",
"fieldLength":null, "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"PUMP_PIPE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"pumpipe_param_2", "datatype":"string", 
"widgettype":"text", "label":"Ppipe param_2","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"RECT_MANHOLE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"recmanhole_param_1", "datatype":"string", 
"widgettype":"text", "label":"Rect. mhole param_1","ismandatory":"False",
"fieldLength":"500", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"RECT_MANHOLE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"recmanhole_param_2", "datatype":"string", 
"widgettype":"text", "label":"Rect. mhole param_2","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"REGISTER"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"register_param_1", "datatype":"string", 
"widgettype":"text", "label":"Register param_1","ismandatory":"False",
"fieldLength":"500", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"REGISTER"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"register_param_2", "datatype":"string", 
"widgettype":"text", "label":"Register param_2","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"SEWER_STORAGE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"sewstorage_param_1", "datatype":"string", 
"widgettype":"combo", "label":"Sstorage param_1","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True",  "dv_isnullvalue":"True",
"isenabled":"True","dv_querytext":"SELECT id as id, idval as idval  FROM edit_typevalue WHERE typevalue='sewstorage_param_1'"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"SEWER_STORAGE"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"sewstorage_param_2", "datatype":"string", 
"widgettype":"text", "label":"Sstorage param_1","ismandatory":"False",
"fieldLength":"250", "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"WEIR"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"weir_param_1", "datatype":"integer", 
"widgettype":"text", "label":"Weir param_1","ismandatory":"False",
"fieldLength":null, "numDecimals" :null,"addfield_active":"True", "iseditable":"True", "isenabled":"True"}}}$$);

SELECT gw_fct_admin_manage_addfields($${"client":{"lang":"ES"}, "feature":{"catFeature":"WEIR"},
"data":{"action":"CREATE", "multi_create":"false", "parameters":{"columnname":"weir_param_2", "datatype":"string", 
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

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, parameter_id)
SELECT 'edit_typevalue','sewstorage_param_1','man_addfields_value','value_param',id FROM sys_addfields WHERE param_name='sewstorage_param_1';
INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, parameter_id)
SELECT 'edit_typevalue','grate_param_1','man_addfields_value','value_param',id FROM sys_addfields WHERE param_name='grate_param_1';
INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, parameter_id)
SELECT 'edit_typevalue','chamber_param_1','man_addfields_value','value_param',id FROM sys_addfields WHERE param_name='chamber_param_1';


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


INSERT INTO selector_sector (sector_id, cur_user)
SELECT sector_id, current_user FROM sector
ON CONFLICT (sector_id, cur_user) DO NOTHING;


SELECT gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES"},
"data":{"resultId":"test1", "useNetworkGeom":"false", "dumpSubcatch":"true"}}$$);

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
UPDATE config_form_fields SET hidden = true WHERE columnname 
IN ('undelete', 'publish', 'buildercat_id', 'comment', 'num_value', 'svg', 'macrodqa_id', 'macrosector_id',
'macroexpl_id', 'custom_length', 'staticpressure1', 'staticpressure2', 'pipe_param_1');

UPDATE config_form_fields SET hidden = true WHERE columnname IN ('label_x', 'label_y') AND formname LIKE 've_arc%';

-- reorder sample
UPDATE config_form_fields SET layoutorder =90, layoutname = 'lyt_data_1' WHERE columnname ='link';
UPDATE config_form_fields SET layoutorder =1 , layoutname ='lyt_bot_2' WHERE columnname ='sector_id';
UPDATE config_form_fields SET layoutorder =4 , layoutname ='lyt_bot_1' , label = 'Dqa' WHERE columnname ='dqa_id';
UPDATE config_form_fields SET layoutorder =70 , layoutname ='lyt_data_1' WHERE columnname ='macrosector_id';
UPDATE config_form_fields SET stylesheet ='{"label":"color:red; font-weight:bold"}' WHERE columnname IN ('expl_id', 'sector_id');

update config_form_fields SET layoutorder = 3 where columnname='state' and formname like '%ve_connec_%';
update config_form_fields SET layoutorder = 4 where columnname='state_type' and formname like '%ve_connec_%';

UPDATE cat_feature_node set isprofilesurface = true;

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
UPDATE config_form_fields SET  hidden = true where columnname = 'feature_id';
UPDATE config_form_fields SET  hidden = true where columnname = 'featurecat_id';
UPDATE config_form_fields SET  hidden = true where columnname = 'connec_length';

UPDATE config_form_fields SET  hidden = true where columnname = 'cmanhole_param_1';
UPDATE config_form_fields SET  hidden = true where columnname = 'cmanhole_param_2';


UPDATE config_form_fields SET  hidden = true where columnname IN ('accessibility', 'inlet');

UPDATE config_form_fields SET  layoutname = 'lyt_data_2' where columnname IN ('bottom_channel','sander_depth','length', 'width') AND formname LIKE '%_node_%';

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

UPDATE config_form_fields SET layoutname = 'lyt_bot_1', layoutorder = 3 where columnname ='state' AND formname <> 'v_edit_dimensions';
UPDATE config_form_fields SET layoutname = 'lyt_bot_1', layoutorder = 4 where columnname ='state_type';
UPDATE config_form_fields SET layoutname = 'lyt_bot_1' where columnname ='sector_id';
UPDATE config_form_fields SET layoutname = 'lyt_data_1',layoutorder = 997 where columnname ='hemisphere';
UPDATE config_form_fields SET layoutorder = 2 where columnname ='dma_id';

UPDATE config_form_fields SET layoutname = 'lyt_data_2', layoutorder = 30 where columnname ='verified';
UPDATE config_form_fields SET layoutname = 'lyt_data_2', layoutorder = 32 where columnname ='dqa_id';
UPDATE config_form_fields SET layoutname = 'lyt_data_2', layoutorder = 33 where columnname ='expl_id' AND formname <> 'v_edit_dimensions';
UPDATE config_form_fields SET layoutname = 'lyt_data_1', layoutorder = 998 where columnname ='parent_id';


-- refactor of type's
UPDATE man_type_fluid SET fluid_type = replace (fluid_type, 'Standard', 'St.');
UPDATE man_type_category SET category_type = replace (category_type, 'Standard', 'St.');
UPDATE man_type_location SET location_type = replace (location_type, 'Standard', 'St.');
UPDATE man_type_function SET function_type = replace (function_type, 'Standard', 'St.');

update config_form_fields SET widgettype = 'text', dv_querytext = null, placeholder  ='Ex.macrosector_id' WHERE columnname  = 'macrosector_id';

UPDATE connec SET connec_depth = 1.5;


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

UPDATE node SET nodecat_id='C_MANHOLE_100', matcat_id='Brick' WHERE nodecat_id='C_MANHOLE-BR100';
UPDATE node SET nodecat_id='C_MANHOLE_100', matcat_id='Concret' WHERE nodecat_id='C_MANHOLE-CON100';
UPDATE node SET nodecat_id='C_MANHOLE_80', matcat_id='Concret' WHERE nodecat_id='C_MANHOLE-CON80';
UPDATE node SET matcat_id='Concret' WHERE nodecat_id='CHAMBER-01';
UPDATE node SET matcat_id='Brick' WHERE nodecat_id='HIGH POINT-01';
UPDATE node SET matcat_id='Concret' WHERE nodecat_id='JUMP-01';
UPDATE node SET matcat_id='Concret' WHERE nodecat_id='NETGULLY-01';
UPDATE node SET nodecat_id='R_MANHOLE_100', matcat_id='Brick' WHERE nodecat_id='R_MANHOLE-BR100';
UPDATE node SET nodecat_id='R_MANHOLE_100', matcat_id='Concret' WHERE nodecat_id='R_MANHOLE-CON100';
UPDATE node SET nodecat_id='R_MANHOLE_150', matcat_id='Concret' WHERE nodecat_id='R_MANHOLE-CON150';
UPDATE node SET nodecat_id='R_MANHOLE_200', matcat_id='Concret' WHERE nodecat_id='R_MANHOLE-CON200';
UPDATE node SET matcat_id='Concret' WHERE nodecat_id='SEW_STORAGE-01';
UPDATE node SET matcat_id='Brick' WHERE nodecat_id='VALVE-01';
UPDATE node SET matcat_id='Concret' WHERE nodecat_id='WEIR-01';
UPDATE node SET matcat_id='Brick' WHERE nodecat_id='NETINIT-01';
UPDATE node SET matcat_id='Brick' WHERE nodecat_id='NETELEMENT-01';
UPDATE node SET matcat_id='Brick' WHERE nodecat_id='JUNCTION-01';
UPDATE node SET matcat_id='Concret' WHERE nodecat_id='OUTFALL-01';
UPDATE node SET matcat_id='Concret' WHERE nodecat_id='NODE-01';
UPDATE node SET matcat_id='Brick' WHERE nodecat_id='VIR_NODE-01';
UPDATE node SET matcat_id='Concret' WHERE nodecat_id='WWTP-01';

DELETE FROM cat_node WHERE id IN ('C_MANHOLE-BR100','C_MANHOLE-CON100','C_MANHOLE-CON80','R_MANHOLE-BR100','R_MANHOLE-CON100','R_MANHOLE-CON150',
'R_MANHOLE-CON200');

UPDATE arc SET arccat_id='CC100', matcat_id='Concret' WHERE arccat_id='CON-CC100';
UPDATE arc SET matcat_id='Concret' WHERE arccat_id='SIPHON-CC100';
UPDATE arc SET arccat_id='CC040', matcat_id='PVC' WHERE arccat_id='PVC-CC040';
UPDATE arc SET arccat_id='CC060', matcat_id='PVC' WHERE arccat_id='PVC-CC060';
UPDATE arc SET arccat_id='CC080', matcat_id='PVC' WHERE arccat_id='PVC-CC080';
UPDATE arc SET matcat_id='PVC' WHERE arccat_id='WACCEL-CC020';
UPDATE arc SET arccat_id='CC020', matcat_id='PVC' WHERE arccat_id='PVC-CC020';
UPDATE arc SET arccat_id='CC040', matcat_id='Concret' WHERE arccat_id='CON-CC040';
UPDATE arc SET arccat_id='CC060', matcat_id='Concret' WHERE arccat_id='CON-CC060';
UPDATE arc SET arccat_id='CC080', matcat_id='Concret' WHERE arccat_id='CON-CC080';
UPDATE arc SET arccat_id='EG150', matcat_id='Concret' WHERE arccat_id='CON-EG150';
UPDATE arc SET arccat_id='RC150', matcat_id='Concret' WHERE arccat_id='CON-RC150';
UPDATE arc SET arccat_id='RC200', matcat_id='Concret' WHERE arccat_id='CON-RC200';
UPDATE arc SET arccat_id='PP020', matcat_id='PEAD' WHERE arccat_id='PE-PP020';
UPDATE arc SET arccat_id='CC040', matcat_id='PEC' WHERE arccat_id='PEC-CC040';
UPDATE arc SET matcat_id='Virtual' WHERE arccat_id='WEIR_60';
UPDATE arc SET matcat_id='Virtual' WHERE arccat_id='PUMP_01';
UPDATE arc SET arccat_id='CC315', matcat_id='PEC' WHERE arccat_id='PEC-CC315';
UPDATE arc SET matcat_id='Virtual' WHERE arccat_id='VIRTUAL';

DELETE FROM cat_arc WHERE id IN ('CON-CC100','PVC-CC040','PVC-CC060','PVC-CC080','PVC-CC020','CON-CC040','CON-CC060','CON-CC080','CON-EG150','CON-RC150',
'CON-RC200','PE-PP020','PEC-CC040','PEC-CC315');

UPDATE connec SET connecat_id='CC025_D', matcat_id='PVC' WHERE connecat_id='PVC-CC025_D';
UPDATE connec SET connecat_id='CC040_I', matcat_id='Concret' WHERE connecat_id='CON-CC040_I';
UPDATE connec SET connecat_id='CC025_T', matcat_id='PVC' WHERE connecat_id='PVC-CC025_T';
UPDATE connec SET connecat_id='CC030_D', matcat_id='PVC' WHERE connecat_id='PVC-CC030_D';
UPDATE connec SET connecat_id='CC020_D', matcat_id='Concret' WHERE connecat_id='CON-CC020_D';
UPDATE connec SET connecat_id='CC030_D', matcat_id='Concret' WHERE connecat_id='CON-CC030_D';
UPDATE connec SET matcat_id='Virtual' WHERE connecat_id='VIRTUAL';


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

UPDATE gully SET district_id =1 WHERE expl_id=1;
UPDATE gully SET district_id =2 WHERE expl_id=2;


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

-- to clean trash must be executed 2 times
SELECT gw_fct_setvnoderepair($${ "client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"parameters":{"tolerance":"0.01", "forceNodes":true}}}$$);
SELECT gw_fct_setvnoderepair($${ "client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"parameters":{"tolerance":"0.01", "forceNodes":true}}}$$);

UPDATE config_param_system SET value = '
{"table":"exploitation", "selector":"selector_expl", "table_id":"expl_id",  "selector_id":"expl_id",  "label":"expl_id, '' - '', name", "orderBy":"expl_id", 
"manageAll":true, "query_filter":"AND expl_id > 0", "typeaheadFilter":" AND lower(concat(expl_id, '' - '', name))"}'
WHERE parameter = 'basic_selector_tab_exploitation';