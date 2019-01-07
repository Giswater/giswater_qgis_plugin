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


INSERT INTO anl_mincut_inlet_x_exploitation VALUES (2, 113766, 1);
INSERT INTO anl_mincut_inlet_x_exploitation VALUES (3, 113952, 2);


UPDATE plan_arc_x_pavement SET pavcat_id = 'Asphalt';


UPDATE plan_psector_x_arc SET psector_id = 2 WHERE arc_id = '20651';

INSERT INTO plan_psector_x_arc VALUES (4, '2065', 2, 0, false, NULL);
INSERT INTO plan_psector_x_arc VALUES (5, '2085', 1, 0, false, NULL);
INSERT INTO plan_psector_x_arc VALUES (8, '2086', 1, 0, false, NULL);

INSERT INTO plan_psector_x_node VALUES (2, '1076', 1, 0, false, NULL);


INSERT INTO doc VALUES ('Demo document 1', 'OTHER', 'https://github.com/Giswater/docs/blob/master/user/manual_usuario_giswater3.doc', NULL, '2018-03-11 19:40:20.449663', current_user, '2018-03-11 19:40:20.449663');
INSERT INTO doc VALUES ('Demo document 3', 'OTHER', 'https://github.com/Giswater/giswater/blob/master-2.1/legal/Licensing.txt', NULL, '2018-03-14 17:09:59.762257', current_user, '2018-03-14 17:09:59.762257');
INSERT INTO doc VALUES ('Demo document 2', 'OTHER', 'https://github.com/Giswater/giswater/blob/master-2.1/legal/Readme.txt', NULL, '2018-03-14 17:09:19.852804', current_user, '2018-03-14 17:09:19.852804');


SELECT gw_fct_plan_result( 'Starting prices', 1, 1, 'Demo prices for reconstruction');
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


refresh MATERIALIZED VIEW v_ui_workcat_polygon_aux;


update ext_rtc_hydrometer SET state_id=1;

INSERT INTO selector_hydrometer (state_id, cur_user) VALUES (1, 'postgres');

update ext_rtc_hydrometer set connec_id=b.customer_code from rtc_hydrometer_x_connec  a 
join connec b on a.connec_id = b.connec_id
where ext_rtc_hydrometer.id = a.hydrometer_id;


select gw_fct_audit_check_project(1);


