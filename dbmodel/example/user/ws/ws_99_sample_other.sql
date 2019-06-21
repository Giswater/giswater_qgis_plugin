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



SELECT setval('SCHEMA_NAME.man_addfields_parameter_id_seq', (SELECT max(id) FROM man_addfields_parameter), true);
INSERT INTO man_addfields_parameter (param_name, cat_feature_id, is_mandatory, datatype_id, field_length, num_decimals, default_value, form_label, widgettype_id) 
VALUES ('minsector', 'PIPE', true, 'integer', NULL, NULL, '{"fprocesscat_id":"34"}', 'as', 'QTextEdit');
INSERT INTO man_addfields_parameter (param_name, cat_feature_id, is_mandatory, datatype_id, field_length, num_decimals, default_value, form_label, widgettype_id) 
VALUES ('minsector', 'JUNCTION', true, 'integer', NULL, NULL, '{"fprocesscat_id":"34"}', 'AS', 'QTextEdit');
INSERT INTO man_addfields_parameter (param_name, cat_feature_id, is_mandatory, datatype_id, field_length, num_decimals, default_value, form_label, widgettype_id) 
VALUES ('dqa', 'PIPE', true, 'integer', NULL, NULL, '{"fprocesscat_id":"44"}', 'as', 'QTextEdit');
INSERT INTO man_addfields_parameter (param_name, cat_feature_id, is_mandatory, datatype_id, field_length, num_decimals, default_value, form_label, widgettype_id) 
VALUES ('dqa', 'JUNCTION', true, 'integer', NULL, NULL, '{"fprocesscat_id":"44"}', 'AS', 'QTextEdit');
INSERT INTO man_addfields_parameter (param_name, cat_feature_id, is_mandatory, datatype_id, field_length, num_decimals, default_value, form_label, widgettype_id) 
VALUES ('staticpressure', 'PIPE', true, 'integer', NULL, NULL, '{"fprocesscat_id":"47"}', 'as', 'QTextEdit');
INSERT INTO man_addfields_parameter (param_name, cat_feature_id, is_mandatory, datatype_id, field_length, num_decimals, default_value, form_label, widgettype_id) 
VALUES ('staticpressure', 'JUNCTION', true, 'integer', NULL, NULL, '{"fprocesscat_id":"47"}', 'AS', 'QTextEdit');




refresh MATERIALIZED VIEW v_ui_workcat_polygon_aux;


update ext_rtc_hydrometer SET state_id=1;

INSERT INTO selector_hydrometer (state_id, cur_user) VALUES (1, 'postgres');

update ext_rtc_hydrometer set connec_id=b.customer_code from rtc_hydrometer_x_connec  a 
join connec b on a.connec_id = b.connec_id
where ext_rtc_hydrometer.id = a.hydrometer_id;


select gw_fct_audit_check_project(1);



