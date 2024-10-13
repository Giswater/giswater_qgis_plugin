/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = 'SCHEMA_NAME', public, pg_catalog;


INSERT INTO selector_sector SELECT sector_id, current_user from sector where sector_id > 0 ON CONFLICT (sector_id, cur_user) DO NOTHING;
DELETE FROM selector_psector;

INSERT INTO selector_municipality SELECT muni_id,current_user FROM ext_municipality ON CONFLICT (muni_id, cur_user) DO NOTHING;

UPDATE cat_arc SET active=TRUE WHERE arctype_id='VARC' AND id='VIRTUAL';

UPDATE om_visit SET startdate = startdate -  random() * (startdate - timestamp '2022-01-01 10:00:00');
UPDATE om_visit SET enddate = startdate;

UPDATE arc SET builtdate = now() -  random() * (now() - timestamp '1990-01-01 00:00:00');
UPDATE node SET builtdate = now() -  random() * (now() - timestamp '1990-01-01 00:00:00');
UPDATE connec SET builtdate = now() -  random() * (now() - timestamp '1990-01-01 00:00:00');
UPDATE link SET builtdate = c.builtdate FROM connec c WHERE feature_id = connec_id;
UPDATE element SET builtdate = now() -  random() * (now() - timestamp '1990-01-01 00:00:00');

INSERT INTO om_waterbalance_dma_graph VALUES ('1080',1,-1);
INSERT INTO om_waterbalance_dma_graph VALUES ('1080',2,1);
INSERT INTO om_waterbalance_dma_graph VALUES ('1097',4,1);
INSERT INTO om_waterbalance_dma_graph VALUES ('1101',4,1);
INSERT INTO om_waterbalance_dma_graph VALUES ('113766',1,1);
INSERT INTO om_waterbalance_dma_graph VALUES ('113766',4,-1);


UPDATE config_param_user SET value = replace(value, '"removeDemandOnDryNodes":false', '"delDryNetwork":false, "removeDemandOnDryNodes":true') 
WHERE parameter = 'inp_options_debug';

UPDATE cat_feature_node SET graph_delimiter ='MINSECTOR' WHERE id = 'SHUTOFF_VALVE';
UPDATE cat_feature_node SET graph_delimiter ='MINSECTOR' WHERE id = 'CHECK_VALVE';
UPDATE cat_feature_node SET graph_delimiter ='PRESSZONE' WHERE id in('PUMP', 'PR_REDUC_VALVE','PR_BREAK_VALVE','PR_SUSTA_VALVE');

-- 01/05/2024
UPDATE config_param_system SET value = 
'{"status":true, "values":[
{"sourceTable":"ve_node_pr_reduc_valve", "query":"UPDATE presszone t SET head=elevation + pression_exit FROM ve_node_pr_reduc_valve s "},
{"sourceTable":"ve_node_tank", "query":"UPDATE presszone t SET head=elevation + hmax/2  FROM ve_node_tank s "}]}'
WHERE parameter = 'epa_automatic_man2graph_values';


UPDATE config_param_system SET value = 
'{"status":true, "values":[
{"sourceTable":"ve_node_tank", "query":"UPDATE inp_inlet t SET maxlevel = hmax, diameter=sqrt(4*area/3.14159) FROM ve_node_tank s "},
{"sourceTable":"ve_node_pr_reduc_valve", "query":"UPDATE inp_valve t SET pressure = pression_exit FROM ve_node_pr_reduc_valve s "}]}'
WHERE parameter = 'epa_automatic_man2inp_values';


UPDATE config_param_system SET value = '{"setArcObsolete":"true","setOldCode":"false"}' WHERE parameter = 'edit_arc_divide';

SELECT gw_fct_setchangefeaturetype($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{"type":"node"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"1082", "feature_type_new":"SHUTOFF_VALVE", "featurecat_id":"SHTFF-VALVE110-PN16"}}$$);

UPDATE cat_feature set active=true where id = 'THROTTLE_VALVE';
INSERT INTO cat_node VALUES ('THROTTLE_VALVE_200','THROTTLE_VALVE','FD','16','200',200, null, null, 'THROTTLE VALVE 200mm','c:\users\users\catalog.pdf');

SELECT gw_fct_setchangefeaturetype($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{"type":"node"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"1107", "feature_type_new":"THROTTLE_VALVE", "featurecat_id":"THROTTLE_VALVE_200"}}$$);

UPDATE man_valve set broken=false where node_id = '1093';

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
	
UPDATE config_param_system SET isenabled = true WHERE parameter = 'basic_selector_tab_municipality';

UPDATE link SET muni_id = c.muni_id FROM connec c WHERE connec_id =  feature_id;

-- run graphanalytics for presszone
SELECT gw_fct_graphanalytics_mapzones_advanced($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"graphClass":"PRESSZONE", "exploitation":"1", "floodOnlyMapzone":null, "forceOpen":null, "forceClosed":null, "usePlanPsector":"false", "commitChanges":"true", "valueForDisconnected":null, "updateMapZone":"2", "geomParamUpdate":"8"}, "aux_params":null}}$$);

SELECT gw_fct_graphanalytics_mapzones_advanced($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"graphClass":"PRESSZONE", "exploitation":"2", "floodOnlyMapzone":null, "forceOpen":null, "forceClosed":null, "usePlanPsector":"false", "commitChanges":"true", "valueForDisconnected":null, "updateMapZone":"2", "geomParamUpdate":"8"}, "aux_params":null}}$$);


UPDATE ext_rtc_hydrometer SET is_waterbal = false WHERE  id::integer in (3,4);

INSERT INTO man_type_category (category_type, feature_type, featurecat_id) VALUES ('category_junction1','NODE','{JUNCTION}');
INSERT INTO man_type_category (category_type, feature_type, featurecat_id) VALUES ('category_junction2','NODE','{JUNCTION}');
INSERT INTO man_type_category (category_type, feature_type, featurecat_id) VALUES ('category_hydrant1','NODE','{HYDRANT}');
INSERT INTO man_type_category (category_type, feature_type, featurecat_id) VALUES ('category_hydrant2','NODE','{HYDRANT}');

INSERT INTO man_type_location (location_type, feature_type, featurecat_id) VALUES ('location_junction1','NODE','{JUNCTION}');
INSERT INTO man_type_location (location_type, feature_type, featurecat_id) VALUES ('location_junction2','NODE','{JUNCTION}');
INSERT INTO man_type_location (location_type, feature_type, featurecat_id) VALUES ('location_hydrant1','NODE','{HYDRANT}');
INSERT INTO man_location_type (location_type, feature_type, featurecat_id) VALUES ('location_hydrant2','NODE','{HYDRANT}');

INSERT INTO man_type_fluid (fluid_type, feature_type, featurecat_id) VALUES ('fluid_junction1','NODE','{JUNCTION}');
INSERT INTO man_type_fluid (fluid_type, feature_type, featurecat_id) VALUES ('fluid_junction2','NODE','{JUNCTION}');
INSERT INTO man_type_fluid (fluid_type, feature_type, featurecat_id) VALUES ('fluid_hydrant1','NODE','{HYDRANT}');
INSERT INTO man_type_fluid (fluid_type, feature_type, featurecat_id) VALUES ('fluid_hydrant2','NODE','{HYDRANT}');

INSERT INTO man_type_function (function_type, feature_type, featurecat_id) VALUES ('function_junction1','NODE','{JUNCTION}');
INSERT INTO man_type_function (function_type, feature_type, featurecat_id) VALUES ('function_junction2','NODE','{JUNCTION}');
INSERT INTO man_type_function (function_type, feature_type, featurecat_id) VALUES ('function_hydrant1','NODE','{HYDRANT}');
INSERT INTO man_type_function (function_type, feature_type, featurecat_id) VALUES ('function_hydrant2','NODE','{HYDRANT}');

UPDATE node SET category_type = 'category_junction1' where nodecat_id like 'JUNCT%';
UPDATE node SET location_type = 'location_junction1' where nodecat_id like 'JUNCT%';
UPDATE node SET fluid_type = 'fluid_junction1' where nodecat_id like 'JUNCT%';
UPDATE node SET function_type = 'function_junction1' where nodecat_id like 'JUNCT%';

UPDATE node SET category_type = 'category_hydrant1' where nodecat_id like 'HYDR%';
UPDATE node SET location_type = 'location_hydrant1' where nodecat_id like 'HYDR%';
UPDATE node SET fluid_type = 'fluid_hydrant1' where nodecat_id like 'HYDR%';
UPDATE node SET function_type = 'function_hydrant1' where nodecat_id like 'HYDR%';