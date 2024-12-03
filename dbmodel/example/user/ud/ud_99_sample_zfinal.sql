/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = 'SCHEMA_NAME', public, pg_catalog;


INSERT INTO selector_sector SELECT sector_id, current_user from sector where sector_id > 0 ON CONFLICT (sector_id, cur_user) DO NOTHING;
DELETE FROM selector_psector;

INSERT INTO selector_municipality SELECT muni_id,current_user FROM ext_municipality where muni_id > 0 ON CONFLICT (muni_id, cur_user) DO NOTHING;

UPDATE cat_feature SET id = 'OVERFLOW_STORAGE' WHERE id = 'OWERFLOW_STORAGE';

INSERT INTO cat_node (id, matcat_id, shape, geom1, geom2, geom3, descript, link, brand_id, model_id, svg, estimated_y, cost_unit, "cost", active, "label", node_type, acoeff) VALUES('CHANGE_1', NULL, NULL, 1.00, 1.00, NULL, 'Change', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRD100-H160', true, NULL, 'CHANGE', NULL);
INSERT INTO cat_node (id, matcat_id, shape, geom1, geom2, geom3, descript, link, brand_id, model_id, svg, estimated_y, cost_unit, "cost", active, "label", node_type, acoeff) VALUES('OVERFLOW_STORAGE_1', NULL, NULL, 1.00, 1.00, NULL, 'Overflow storage', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_OF_STR', true, NULL, 'OVERFLOW_STORAGE', NULL);
INSERT INTO cat_node (id, matcat_id, shape, geom1, geom2, geom3, descript, link, brand_id, model_id, svg, estimated_y, cost_unit, "cost", active, "label", node_type, acoeff) VALUES('SANDBOX_1', NULL, NULL, 1.00, 1.00, NULL, 'Sandbox', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PRD100-H160', true, NULL, 'SANDBOX', NULL);
INSERT INTO cat_node (id, matcat_id, shape, geom1, geom2, geom3, descript, link, brand_id, model_id, svg, estimated_y, cost_unit, "cost", active, "label", node_type, acoeff) VALUES('PUMP_STATION', NULL, NULL, 1.00, 1.00, NULL, 'Pump station', NULL, NULL, NULL, NULL, 2.00, 'u', 'N_PUMP_STN', true, NULL, 'PUMP_STATION', NULL);

INSERT INTO cat_gully (id, matcat_id, length, width, total_area, effective_area, n_barr_l, n_barr_w, n_barr_diag, a_param, b_param, descript, link, brand_id, model_id, svg, active, "label", gully_type) VALUES('PGULLY', 'FD', 50.0000, 25.0000, 860.0000, 400.0000, 3.0000, 1.0000, 0.0000, 0.3485, 0.6580, NULL, NULL, NULL, NULL, NULL, true, NULL, 'PGULLY');


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

DELETE FROM arc WHERE node_1 = '250';
DELETE FROM arc WHERE node_2 = '250';
DELETE FROM node WHERE node_id  = '250';

INSERT INTO arc VALUES ('100014','300','237','239',3.150,2.700,null,null,null,null,null,null,15.200,17.050,'CONDUIT','RC200','Virtual','CONDUIT',1,1,2,null,null,
null,-0.0446,FALSE,null,1,'soil1','St. Function','St. Category','St. Fluid','St. Location','work2',null,'builder1','1993-05-23',null,'owner1',1,'08830','1-10000C',null,null,null,null,null,null
,'https://www.giswater.org','0','0102000020E76400000300000040CF5EE0369C1941973AF7283375514195560A733A9C19410D57FE0533755141DE1F148CC49C19412135B3BE2D755141',
null,null,null,null,null,TRUE,null,1,null,'ARC','2021-09-05 15:42:47.93697',null,null,'postgres',1,null,null,'Asphalt',1,'CHAMBER',19.750,16.750,'RECT_MANHOLE',18.350,15.200);
INSERT INTO man_conduit VALUES ('100014');
INSERT INTO inp_conduit VALUES ('100014');


INSERT INTO inp_flwreg_weir VALUES(1,'237', '100014',1,0.5,'TRANSVERSE', 16.35,1.5,null,null, 'NO', 2,1,0,0,null,null,null,null,'237WE1');


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

SELECT gw_fct_graphanalytics_mapzones_advanced($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"graphClass":"DRAINZONE", "exploitation":"1", "floodOnlyMapzone":null, "forceOpen":null, "forceClosed":null, "usePlanPsector":"false", "commitChanges":"true", "valueForDisconnected":null, "updateMapZone":"2", "geomParamUpdate":"8"}, "aux_params":null}}$$);

UPDATE arc SET muni_id = 1, streetaxis_id  ='1-9150C' WHERE arc_id = '179';

INSERT INTO man_type_category (category_type, feature_type, featurecat_id) VALUES ('category_junction1','NODE','{JUNCTION}');
INSERT INTO man_type_category (category_type, feature_type, featurecat_id) VALUES ('category_junction2','NODE','{JUNCTION}');
INSERT INTO man_type_category (category_type, feature_type, featurecat_id) VALUES ('category_manhole1','NODE','{CIRC_MANHOLE}');
INSERT INTO man_type_category (category_type, feature_type, featurecat_id) VALUES ('category_manhole2','NODE','{CIRC_MANHOLE}');

INSERT INTO man_type_location (location_type, feature_type, featurecat_id) VALUES ('location_junction1','NODE','{JUNCTION}');
INSERT INTO man_type_location (location_type, feature_type, featurecat_id) VALUES ('location_junction2','NODE','{JUNCTION}');
INSERT INTO man_type_location (location_type, feature_type, featurecat_id) VALUES ('location_manhole1','NODE','{CIRC_MANHOLE}');
INSERT INTO man_type_location (location_type, feature_type, featurecat_id) VALUES ('location_manhole2','NODE','{CIRC_MANHOLE}');

INSERT INTO man_type_fluid (fluid_type, feature_type, featurecat_id) VALUES ('fluid_junction1','NODE','{JUNCTION}');
INSERT INTO man_type_fluid (fluid_type, feature_type, featurecat_id) VALUES ('fluid_junction2','NODE','{JUNCTION}');
INSERT INTO man_type_fluid (fluid_type, feature_type, featurecat_id) VALUES ('fluid_manhole1','NODE','{CIRC_MANHOLE}');
INSERT INTO man_type_fluid (fluid_type, feature_type, featurecat_id) VALUES ('fluid_manhole2','NODE','{CIRC_MANHOLE}');

INSERT INTO man_type_function (function_type, feature_type, featurecat_id) VALUES ('function_junction1','NODE','{JUNCTION}');
INSERT INTO man_type_function (function_type, feature_type, featurecat_id) VALUES ('function_junction2','NODE','{JUNCTION}');
INSERT INTO man_type_function (function_type, feature_type, featurecat_id) VALUES ('function_manhole1','NODE','{CIRC_MANHOLE}');
INSERT INTO man_type_function (function_type, feature_type, featurecat_id) VALUES ('function_manhole2','NODE','{CIRC_MANHOLE}');

UPDATE node SET category_type = 'category_junction1' where nodecat_id like 'JUNCT%';
UPDATE node SET location_type = 'location_junction1' where nodecat_id like 'JUNCT%';
UPDATE node SET fluid_type = 'fluid_junction1' where nodecat_id like 'JUNCT%';
UPDATE node SET function_type = 'function_junction1' where nodecat_id like 'JUNCT%';

UPDATE node SET category_type = 'category_manhole1' where nodecat_id like 'CIRC_MANHOLE%';
UPDATE node SET location_type = 'location_manhole1' where nodecat_id like 'CIRC_MANHOLE%';
UPDATE node SET fluid_type = 'fluid_manhole1' where nodecat_id like 'CIRC_MANHOLE%';
UPDATE node SET function_type = 'function_manhole1' where nodecat_id like 'CIRC_MANHOLE%';

UPDATE om_visit SET ext_code = concat('EXT', 1000 + id);

UPDATE cat_arc SET geom2 = 0 WHERE id = 'EG150';

UPDATE inp_junction SET ysur=999 WHERE node_id= '302';

UPDATE cat_arc SET id = 'PP030', geom1 = 0.25 WHERE id = 'PP020';

UPDATE inp_dwf SET value = value*6*random();

UPDATE inp_dwf SET pat1 = 'pattern_12';

UPDATE node set ymax = 2 WHERE node_id = '301';

UPDATE inp_subcatchment SET outlet_id = 95 where subc_id IN ('S91','S92','S94');

UPDATE ext_plot set muni_id = 2 where id::integer < 40;

UPDATE config_form_fields SET iseditable = true where columnname = 'to_arc';

UPDATE config_form_fields SET iseditable = true where columnname like '%road%';

UPDATE config_form_fields SET iseditable = true where columnname like 'coef_curve';

UPDATE config_form_fields SET hidden = true where columnname in ('geom3', 'geom4') and formname like '%orifice%';

UPDATE config_form_fields SET linkedobject='tbl_event_x_gully' WHERE formname='gully' AND formtype='form_feature' AND tabname='tab_event' AND linkedobject = 'tbl_visit_x_gully';

UPDATE config_form_fields SET dv_querytext = 'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL' WHERE columnname  = 'muni_id' AND widgettype = 'combo';

UPDATE config_form_fields SET hidden = true where columnname in ('apond') and formname like '%storage%';

UPDATE arc SET y1 = 3, y2 = 3, matcat_id = 'Concret' WHERE arc_id = '100012';
UPDATE arc SET y1 = 2.2, y2 = 3, matcat_id = 'Concret' WHERE arc_id = '100014';

update cat_feature_node set isexitupperintro=2 where id in ('VIRTUAL_NODE', 'RECT_MANHOLE', 'CIRC_MANHOLE');
