/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = 'SCHEMA_NAME', public, pg_catalog;


INSERT INTO selector_sector SELECT sector_id, current_user from sector where sector_id > 0 ON CONFLICT (sector_id, cur_user) DO NOTHING;
DELETE FROM selector_psector;

INSERT INTO selector_municipality SELECT muni_id,current_user FROM ext_municipality ON CONFLICT (muni_id, cur_user) DO NOTHING;

UPDATE cat_feature SET id = 'OVERFLOW_STORAGE' WHERE id = 'OWERFLOW_STORAGE';

INSERT INTO cat_node (id, matcat_id, shape, geom1, geom2, geom3, descript, link, brand, model, svg, estimated_y, cost_unit, "cost", active, "label", node_type, acoeff) VALUES('CHANGE_1', NULL, NULL, 1.00, 1.00, NULL, 'Change', NULL, NULL, NULL, NULL, 2.00, 'u', NULL, true, NULL, 'CHANGE', NULL);
INSERT INTO cat_node (id, matcat_id, shape, geom1, geom2, geom3, descript, link, brand, model, svg, estimated_y, cost_unit, "cost", active, "label", node_type, acoeff) VALUES('OVERFLOW_STORAGE_1', NULL, NULL, 1.00, 1.00, NULL, 'Overflow storage', NULL, NULL, NULL, NULL, 2.00, 'u', NULL, true, NULL, 'OVERFLOW_STORAGE', NULL);
INSERT INTO cat_node (id, matcat_id, shape, geom1, geom2, geom3, descript, link, brand, model, svg, estimated_y, cost_unit, "cost", active, "label", node_type, acoeff) VALUES('SANDBOX_1', NULL, NULL, 1.00, 1.00, NULL, 'Sandbox', NULL, NULL, NULL, NULL, 2.00, 'u', NULL, true, NULL, 'SANDBOX', NULL);
INSERT INTO cat_node (id, matcat_id, shape, geom1, geom2, geom3, descript, link, brand, model, svg, estimated_y, cost_unit, "cost", active, "label", node_type, acoeff) VALUES('PUMP_STATION', NULL, NULL, 1.00, 1.00, NULL, 'Pump station', NULL, NULL, NULL, NULL, 2.00, 'u', NULL, true, NULL, 'PUMP_STATION', NULL);

INSERT INTO cat_grate (id, matcat_id, length, width, total_area, effective_area, n_barr_l, n_barr_w, n_barr_diag, a_param, b_param, descript, link, brand, model, svg, active, "label", gully_type) VALUES('PGULLY', 'FD', 50.0000, 25.0000, 860.0000, 400.0000, 3.0000, 1.0000, 0.0000, 0.3485, 0.6580, NULL, NULL, NULL, NULL, NULL, true, NULL, 'PGULLY');

UPDATE om_visit SET startdate = startdate -  random() * (startdate - timestamp '2022-01-01 10:00:00');
UPDATE om_visit SET enddate = startdate;

UPDATE arc SET builtdate = now() -  random() * (now() - timestamp '1990-01-01 00:00:00');
UPDATE node SET builtdate = now() -  random() * (now() - timestamp '1990-01-01 00:00:00');
UPDATE connec SET builtdate = now() -  random() * (now() - timestamp '1990-01-01 00:00:00');
UPDATE gully SET builtdate = now() -  random() * (now() - timestamp '1990-01-01 00:00:00');
UPDATE link SET builtdate = c.builtdate FROM connec c WHERE feature_id = connec_id;
UPDATE link SET builtdate = g.builtdate FROM gully g WHERE feature_id = gully_id;
UPDATE element SET builtdate = now() -  random() * (now() - timestamp '1990-01-01 00:00:00');

UPDATE config_param_system SET value = '{"setArcObsolete":"true","setOldCode":"false"}' WHERE parameter = 'edit_arc_divide';

UPDATE cat_arc SET geom2 = null WHERE id = 'EG150';


-- refactoring flowregulators for node pump station on expl_1
DELETE FROM inp_flwreg_weir where node_id = '238';
DELETE FROM inp_flwreg_pump where node_id = '238';
UPDATE v_edit_arc SET epa_type = 'PUMP' WHERE arc_id = '303';
UPDATE inp_pump set curve_id = 'PUMP-01', status='OFF', startup=2, shutoff=0.4 WHERE arc_id = '303';
UPDATE v_edit_arc SET epa_type = 'WEIR' WHERE arc_id = '342';
UPDATE inp_weir SET weir_type ='TRANSVERSE', offsetval = 17, cd=1.5, geom1=1, geom2=1;


-- refactoring flowregulators form node weir of expl_1
DELETE FROM inp_flwreg_weir where to_arc = '242';
SELECT gw_fct_setarcfusion('{"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{"id":[20587]},
"data":{"workcatId":"work1","enddate":"2020-02-05", "arccat_id":"RC200", "action_mode": 2, "arc_type":"CONDUIT"}}'::json);
SELECT gw_fct_setarcfusion('{"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{"id":[20590]},
"data":{"workcatId":"work1","enddate":"2020-02-05", "arccat_id":"RC200", "action_mode": 2, "arc_type":"CONDUIT"}}'::json);
SELECT gw_fct_setarcfusion('{"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{"id":[250]},
"data":{"workcatId":"work1","enddate":"2020-02-05", "arccat_id":"RC200", "action_mode": 2, "arc_type":"CONDUIT"}}'::json);

INSERT INTO inp_flwreg_weir VALUES(1,'237','100014',1,0.5,'TRANSVERSE', 16.35,1.5,null,null, 'NO', 2,1,0,0,null,null,null,null,'237WE1');

UPDATE config_param_user SET value ='PARTIAL' WHERE parameter = 'inp_options_inertial_damping';

-- add example for specific sequence on circ_manhole
UPDATE cat_feature SET addparam='{"code_prefix":"CM_"}' WHERE id='CIRC_MANHOLE';

CREATE SEQUENCE circ_manhole_code_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1000
	CACHE 1
	NO CYCLE;

-- 12/08/2024
UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json, 'sys_geom', 'the_geom'::text)
	WHERE parameter IN (
		'basic_search_v2_tab_network_arc',
		'basic_search_v2_tab_network_connec',
		'basic_search_v2_tab_network_gully',
		'basic_search_v2_tab_network_node'
	);

UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json, 'sys_geom', 's.the_geom'::text)
	WHERE parameter ='basic_search_v2_tab_address';

-- change default visitability_vdef for cat_arc
UPDATE cat_arc SET visitability_vdef = 1 WHERE geom1 <= 1.2; -- NO VISITABLE
UPDATE cat_arc SET visitability_vdef = 2 WHERE geom1 > 1.2 AND geom1 < 1.6; -- SEMI VISITABLE
UPDATE cat_arc SET visitability_vdef = 3 WHERE geom1 >= 1.6; -- VISITABLE

UPDATE config_param_system SET isenabled = true WHERE parameter = 'basic_selector_tab_municipality';

UPDATE link SET muni_id = c.muni_id FROM connec c WHERE connec_id =  feature_id;
UPDATE link SET muni_id = g.muni_id FROM gully g WHERE gully_id =  feature_id;