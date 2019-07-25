/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

INSERT INTO cat_users VALUES (1,'user1');
INSERT INTO cat_users VALUES (2,'user2');
INSERT INTO cat_users VALUES (3,'user3');
INSERT INTO cat_users VALUES (4,'user4');


INSERT INTO anl_mincut_inlet_x_exploitation VALUES (2, 113766, 1, '[113906]');
INSERT INTO anl_mincut_inlet_x_exploitation VALUES (3, 113952, 2, '[114146]');


UPDATE plan_arc_x_pavement SET pavcat_id = 'Asphalt';

UPDATE plan_psector_x_arc SET psector_id = 2 WHERE arc_id = '20651';

INSERT INTO plan_psector_x_arc VALUES (4, '2065', 2, 0, false, NULL);
INSERT INTO plan_psector_x_arc VALUES (5, '2085', 1, 0, false, NULL);
INSERT INTO plan_psector_x_arc VALUES (8, '2086', 1, 0, false, NULL);

INSERT INTO plan_psector_x_node VALUES (2, '1076', 1, 0, false, NULL);


INSERT INTO doc VALUES ('Demo document 1', 'OTHER', 'https://github.com/Giswater/docs/blob/master/user/manual_usuario_giswater3.doc', NULL, '2018-03-11 19:40:20.449663', current_user, '2018-03-11 19:40:20.449663');
INSERT INTO doc VALUES ('Demo document 3', 'OTHER', 'https://github.com/Giswater/giswater/blob/master-2.1/legal/Licensing.txt', NULL, '2018-03-14 17:09:59.762257', current_user, '2018-03-14 17:09:59.762257');
INSERT INTO doc VALUES ('Demo document 2', 'OTHER', 'https://github.com/Giswater/giswater/blob/master-2.1/legal/Readme.txt', NULL, '2018-03-14 17:09:19.852804', current_user, '2018-03-14 17:09:19.852804');

select gw_fct_connect_to_network((select array_agg(connec_id)from connec ), 'CONNEC')


SELECT gw_fct_plan_result($${"client":{"device":3, "infoType":100, "lang":"ES"},
							"feature":{},"data":{"parameters":{"coefficient":1, "description":"Demo prices for reconstruction", "resultType":1, "resultId":"Starting prices"},"saveOnDatabase":true}}$$);

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
UPDATE node_type SET graf_delimiter='MINSECTOR' WHERE id IN('CHECK-VALVE', 'FL-CONTR.VALVE', 'GEN-PURP.VALVE', 'SHUTOFF-VALVE', 'THROTTLE-VALVE');
UPDATE node_type SET graf_delimiter='PRESSZONE' WHERE id IN('PR-BREAK.VALVE', 'PR-REDUC.VALVE', 'PR-SUSTA.VALVE');
UPDATE node_type SET graf_delimiter='DQA' WHERE id IN('CLORINATHOR');
UPDATE node_type SET graf_delimiter='DMA' WHERE id IN('FLOWMETER');
UPDATE node_type SET graf_delimiter='SECTOR' WHERE id IN('SOURCE','TANK','WATERWELL','WTP');

INSERT INTO anl_mincut_selector_valve VALUES('CHECK-VALVE');
INSERT INTO anl_mincut_selector_valve VALUES('FL-CONTR.VALVE');
INSERT INTO anl_mincut_selector_valve VALUES('GEN-PURP.VALVE');
INSERT INTO anl_mincut_selector_valve VALUES('THROTTLE-VALVE');


INSERT INTO dqa (dqa_id, name) select dma_id, name from dma;

UPDATE dma SET nodeparent = '[-1]' WHERE dma_id=-1;
UPDATE dma SET nodeparent = '[113766]' WHERE dma_id=1;
UPDATE dma SET nodeparent = '[113952]' WHERE dma_id=2;
UPDATE dma SET nodeparent = '[1080]' WHERE dma_id=3;

UPDATE sector SET nodeparent = '[-1]' WHERE sector_id=-1;
UPDATE sector SET nodeparent = '[113766]' WHERE sector_id=1;
UPDATE sector SET nodeparent = '[113952]' WHERE sector_id=2;
UPDATE sector SET nodeparent = '[1097]' WHERE sector_id=3;
UPDATE sector SET nodeparent = '[1101]' WHERE sector_id=4;
UPDATE sector SET nodeparent = '[2001]' WHERE sector_id=5;

UPDATE dqa SET nodeparent = '[-1]' WHERE dqa_id=-1;
UPDATE dqa SET nodeparent = '[113766]' WHERE dqa_id=1;
UPDATE dqa SET nodeparent = '[113952]' WHERE dqa_id=2;

UPDATE cat_presszone SET nodeparent = '[-1]' WHERE id='-1';
UPDATE cat_presszone SET nodeparent = '[113766]', id='1' WHERE id='High-Expl_01';
UPDATE cat_presszone SET nodeparent = '[113952]', id='2' WHERE id='High-Expl_02';
UPDATE cat_presszone SET nodeparent = '[1083]', id='3' WHERE id='Medium-Expl_01';
UPDATE cat_presszone SET id='4' WHERE id='Low-Expl_01';
UPDATE cat_presszone SET id='5' WHERE id='Medium-Expl_02';
UPDATE cat_presszone SET id='6' WHERE id='Low-Expl_02';



refresh MATERIALIZED VIEW v_ui_workcat_polygon_aux;


update ext_rtc_hydrometer SET state_id=1;

INSERT INTO selector_hydrometer (state_id, cur_user) VALUES (1, 'postgres');

update ext_rtc_hydrometer set connec_id=b.customer_code from rtc_hydrometer_x_connec  a 
join connec b on a.connec_id = b.connec_id
where ext_rtc_hydrometer.id = a.hydrometer_id;


select gw_fct_audit_check_project(1);

SELECT 	gw_fct_admin_manage_child_views($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"catFeature":"PIPE"},
 "data":{"filterFields":{}, "pageInfo":{}, "multi_create":"TRUE" }}$$);





INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('SHUTOFF-VALVE', 've_node_shutoffvalve');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('CHECK-VALVE', 've_node_checkvalve');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('PR-BREAK.VALVE', 've_node_prbkvalve');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('FL-CONTR.VALVE', 've_node_flcontrvalve');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('GEN-PURP.VALVE', 've_node_genpurpvalve');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('THROTTLE-VALVE', 've_node_throttlevalve');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('PR-REDUC.VALVE', 've_node_prreducvalve');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('PR-SUSTA.VALVE', 've_node_prsustavalve');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('AIR-VALVE', 've_node_airvalve');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('GREEN-VALVE', 've_node_greenvalve');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('OUTFALL-VALVE', 've_node_outfallvalve');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('REGISTER', 've_node_register');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('BYPASS-REGISTER', 've_node_bypassregister');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('VALVE-REGISTER', 've_node_valveregister');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('CONTROL-REGISTER', 've_node_controlregister');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('EXPANTANK', 've_node_expantank');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('FILTER', 've_node_filter');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('FLEXUNION', 've_node_flexunion');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('HYDRANT', 've_node_hydrant');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('X', 've_node_x');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('ADAPTATION', 've_node_adaptation');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('ENDLINE', 've_node_endline');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('T', 've_node_t');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('CURVE', 've_node_curve');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('JUNCTION', 've_node_junction');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('MANHOLE', 've_node_manhole');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('FLOWMETER', 've_node_flowmeter');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('PRESSURE-METER', 've_node_pressuremeter');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('NETELEMENT', 've_node_netelement');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('NETSAMPLEPOINT', 've_node_netsamplepoint');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('WATER-CONNECTION', 've_node_waterconnection');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('PUMP', 've_node_pump');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('REDUCTION', 've_node_reduction');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('SOURCE', 've_node_source');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('TANK', 've_node_tank');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('WATERWELL', 've_node_waterwell');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('WTP', 've_node_wtp');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('PIPE', 've_arc_pipe');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('VARC', 've_arc_varc');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('WJOIN', 've_connec_wjoin');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('FOUNTAIN', 've_connec_fountain');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('TAP', 've_connec_tap');
INSERT INTO config_api_layer_child (featurecat_id, tableinfo_id) VALUES ('GREENTAP', 've_connec_greentap');


INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (1, 've_node_shutoffvalve', 100, 've_node_shutoffvalve');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (2, 've_node_checkvalve', 100, 've_node_checkvalve');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (3, 've_node_prbreakvalve', 100, 've_node_prbreakvalve');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (4, 've_node_flcontrvalve', 100, 've_node_flcontrvalve');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (5, 've_node_genpurpvalve', 100, 've_node_genpurpvalve');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (6, 've_node_throttlevalve', 100, 've_node_throttlevalve');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (7, 've_node_prreducvalve', 100, 've_node_prreducvalve');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (8, 've_node_prsustavalve', 100, 've_node_prsustavalve');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (9, 've_node_airvalve', 100, 've_node_airvalve');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (10, 've_node_greenvalve', 100, 've_node_greenvalve');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (11, 've_node_outfallvalve', 100, 've_node_outfallvalve');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (12, 've_node_register', 100, 've_node_register');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (13, 've_node_bypassregister', 100, 've_node_bypassregister');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (14, 've_node_valveregister', 100, 've_node_valveregister');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (15, 've_node_controlregister', 100, 've_node_controlregister');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (16, 've_node_expantank', 100, 've_node_expantank');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (17, 've_node_filter', 100, 've_node_filter');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (18, 've_node_flexunion', 100, 've_node_flexunion');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (19, 've_node_hydrant', 100, 've_node_hydrant');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (20, 've_node_x', 100, 've_node_x');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (21, 've_node_adaptation', 100, 've_node_adaptation');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (22, 've_node_endline', 100, 've_node_endline');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (23, 've_node_t', 100, 've_node_t');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (24, 've_node_curve', 100, 've_node_curve');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (25, 've_node_junction', 100, 've_node_junction');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (26, 've_node_manhole', 100, 've_node_manhole');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (27, 've_node_flowmeter', 100, 've_node_flowmeter');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (28, 've_node_pressuremeter', 100, 've_node_pressuremeter');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (29, 've_node_netelement', 100, 've_node_netelement');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (30, 've_node_netsamplepoint', 100, 've_node_netsamplepoint');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (31, 've_node_waterconnection', 100, 've_node_waterconnection');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (32, 've_node_pump', 100, 've_node_pump');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (33, 've_node_reduction', 100, 've_node_reduction');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (34, 've_node_source', 100, 've_node_source');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (35, 've_node_tank', 100, 've_node_tank');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (36, 've_node_waterwell', 100, 've_node_waterwell');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (37, 've_node_wtp', 100, 've_node_wtp');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (38, 've_arc_pipe', 100, 've_arc_pipe');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (39, 've_arc_varc', 100, 've_arc_varc');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (40, 've_connec_wjoin', 100, 've_connec_wjoin');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (41, 've_connec_fountain', 100, 've_connec_fountain');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (42, 've_connec_tap', 100, 've_connec_tap');
INSERT INTO config_api_tableinfo_x_infotype (id, tableinfo_id, infotype_id, tableinfotype_id) VALUES (43, 've_connec_greentap', 100, 've_connec_greentap');


