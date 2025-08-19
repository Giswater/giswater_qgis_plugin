/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = 'SCHEMA_NAME', public, pg_catalog;


INSERT INTO selector_sector SELECT sector_id, current_user from sector where sector_id > 0 ON CONFLICT (sector_id, cur_user) DO NOTHING;
DELETE FROM selector_psector;

INSERT INTO selector_municipality SELECT muni_id,current_user FROM ext_municipality ON CONFLICT (muni_id, cur_user) DO NOTHING;

UPDATE cat_arc SET active=TRUE WHERE arc_type = 'VARC' AND id = 'VIRTUAL';

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

INSERT INTO om_waterbalance_dma_graph VALUES('111111', 5, 1);
INSERT INTO om_waterbalance_dma_graph VALUES('113952', 5, -1);
INSERT INTO om_waterbalance_dma_graph VALUES('113952', 3, 1);

UPDATE config_param_user SET value = replace(value, '"removeDemandOnDryNodes":false', '"delDryNetwork":false, "removeDemandOnDryNodes":true')
WHERE parameter = 'inp_options_debug';

UPDATE cat_feature_node SET graph_delimiter = '{MINSECTOR}' WHERE id = 'SHUTOFF_VALVE';
UPDATE cat_feature_node SET graph_delimiter = '{MINSECTOR}' WHERE id = 'CHECK_VALVE';
UPDATE cat_feature_node SET graph_delimiter = '{PRESSZONE}' WHERE id IN ('PUMP', 'PR_REDUC_VALVE','PR_BREAK_VALVE','PR_SUSTA_VALVE');
UPDATE cat_feature_node SET graph_delimiter='{SECTOR,DMA}' WHERE id='TANK';

-- 01/05/2024
UPDATE config_param_system SET value =
'{"status":true, "values":[
{"sourceTable":"ve_node_pr_reduc_valve", "query":"UPDATE presszone t SET head=top_elev + pressure_exit FROM ve_node_pr_reduc_valve s "},
{"sourceTable":"ve_node_tank", "query":"UPDATE presszone t SET head=top_elev + hmax/2  FROM ve_node_tank s "}]}'
WHERE parameter = 'epa_automatic_man2graph_values';


UPDATE config_param_system SET value =
'{"status":true, "values":[
{"sourceTable":"ve_node_tank", "query":"UPDATE inp_inlet t SET maxlevel = hmax, diameter=sqrt(4*area/3.14159) FROM ve_node_tank s "},
{"sourceTable":"ve_node_pr_reduc_valve", "query":"UPDATE inp_valve t SET setting = pressure_exit FROM ve_node_pr_reduc_valve s "}]}'
WHERE parameter = 'epa_automatic_man2inp_values';


UPDATE config_param_system SET value = '{"setArcObsolete":"true","setOldCode":"false"}' WHERE parameter = 'edit_arc_divide';

SELECT gw_fct_setchangefeaturetype($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{"type":"node"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"1082", "feature_type_new":"SHUTOFF_VALVE", "featurecat_id":"SHTFF-VALVE110-PN16"}}$$);

UPDATE cat_feature set active=true where id = 'THROTTLE_VALVE';
INSERT INTO cat_node (id, node_type, matcat_id, pnom, dnom, dint, dext, shape, descript, link, brand_id, model_id, svg, estimated_depth, cost_unit, "cost", active, "label", ischange, acoeff)
VALUES('THROTTLE_VALVE_200', 'THROTTLE_VALVE', 'FD', '16', '200', 200.00000, NULL, NULL, 'THROTTLE VALVE 200mm', 'c:\users\users\catalog.pdf', NULL, NULL, NULL, 1, 'u', 'N_CHKVAL200_PN10', true, NULL, 2, NULL);

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
INSERT INTO man_type_location (location_type, feature_type, featurecat_id) VALUES ('location_hydrant2','NODE','{HYDRANT}');

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

UPDATE om_visit SET ext_code = concat('EXT', 1000 + id);

UPDATE ext_plot set muni_id = 2 where id::integer < 40;

UPDATE macroexploitation SET name ='macroexpl-01', lock_level = 1 WHERE macroexpl_id = 1;
INSERT INTO macroexploitation (macroexpl_id, "name", descript, lock_level, active, the_geom) VALUES(2, 'Other', 'Macroexploitation used for test', 1, true, NULL);

UPDATE config_param_system SET isenabled = false where parameter = ' basic_selector_tab_municipality';

insert into sys_style select 've_node', 106, 'qml', stylevalue, true from sys_style where layername = 've_node' and styleconfig_id = 101 ON CONFLICT (layername, styleconfig_id) DO NOTHING;
insert into sys_style select 've_node', 107, 'qml', stylevalue, true from sys_style where layername = 've_node' and styleconfig_id = 101 ON CONFLICT (layername, styleconfig_id) DO NOTHING;;
insert into sys_style select 've_node', 108, 'qml', stylevalue, true from sys_style where layername = 've_node' and styleconfig_id = 101 ON CONFLICT (layername, styleconfig_id) DO NOTHING;;

UPDATE ext_cat_period b SET end_date = a.end_date FROM (
	SELECT id, end_date + INTERVAL '1 day' AS end_date FROM ext_cat_period
)a WHERE a.id = b.id;

UPDATE ext_cat_period b SET period_seconds = a.period_seconds FROM (
	SELECT id, LEFT((end_date::TIMESTAMP - start_date::TIMESTAMP)::TEXT, 2)::integer * 24 * 3600 AS period_seconds FROM ext_cat_period
)a WHERE a.id = b.id;

UPDATE connec SET connec_length = st_length(l.the_geom) FROM link l WHERE connec_id = l.feature_id;

INSERT INTO man_genelem (element_id)
SELECT e.element_id
FROM element e
JOIN cat_element ce ON ce.id::text = e.elementcat_id::text
LEFT JOIN cat_feature cf ON ce.element_type::text = cf.id::text
WHERE cf.feature_class='GENELEM';



INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('sys_table_context', '{"levels": ["INVENTORY", "NETWORK", "FRELEMENT"]}', NULL, NULL, '{
  "orderBy": 9
}'::json);
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":30}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["OM", "ANALYTICS"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":29}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["BASEMAP", "CARTO"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":28}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["BASEMAP", "ADDRESS"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":27}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["MASTERPLAN", "NETSCENARIO"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":26}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["MASTERPLAN", "TRACEABILITY"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":25}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["MASTERPLAN", "PRICES"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":24}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["MASTERPLAN", "PSECTOR"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":23}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["EPA", "COMPARE"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":22}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["EPA", "RESULTS"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":21}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["EPA", "DSCENARIO"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":20}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["EPA", "FLOWREG"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":19}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["EPA", "HYDRAULICS"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":18}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["EPA", "HYDROLOGY"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":17}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["EPA", "CATALOGS"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":16}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["OM", "VISIT"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":15}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["OM", "FLOWTRACE"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":14}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["OM", "MINCUT"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":13}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "VALUE DOMAIN"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":12}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "AUXILIAR"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{
  "orderBy": 11
}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "OTHER"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{
  "orderBy": 5}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "POLYGON"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{
  "orderBy": 4
}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "ELEMENT"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{
  "orderBy": 3
}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "FRELEMENT"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{
  "orderBy": 3
}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "LINK"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{
  "orderBy": 3
}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "NODE"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{
  "orderBy": 3
}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "ARC"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{
  "orderBy": 3
}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "GULLY"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{
  "orderBy": 3
}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "NETWORK", "CONNEC"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":2}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "MAP ZONES"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":1}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["INVENTORY", "CATALOGS"]}';
UPDATE config_typevalue SET idval=NULL, camelstyle=NULL, addparam='{"orderBy":0}'::json WHERE typevalue='sys_table_context' AND id='{"levels": ["HIDDEN"]}';

UPDATE sys_table SET context = '{"levels": ["INVENTORY", "NETWORK", "FRELEMENT"]}' WHERE id = 've_element_epump';
UPDATE sys_table SET context = '{"levels": ["INVENTORY", "NETWORK", "FRELEMENT"]}' WHERE id = 've_element_evalve';
UPDATE sys_table SET context = '{"levels": ["INVENTORY", "NETWORK", "FRELEMENT"]}' WHERE id = 've_element_emeter';
UPDATE sys_table SET project_template = '{"template": [1], "visibility": true, "levels_to_read": 2}'::jsonb, context = '{"levels": ["INVENTORY", "NETWORK", "FRELEMENT"]}' WHERE id = 've_man_frelem';

UPDATE sys_table SET project_template = '{"template": [1], "visibility": true, "levels_to_read": 3}'::jsonb WHERE id = 've_element';

UPDATE sys_table SET orderby=1 WHERE id='ve_node';
UPDATE sys_table SET orderby=2 WHERE id='ve_man_frelem';
UPDATE sys_table SET orderby=2 WHERE id='ve_element';
UPDATE sys_table SET orderby=3 WHERE id='ve_arc';
UPDATE sys_table SET orderby=4 WHERE id='ve_connec';
UPDATE sys_table SET orderby=5 WHERE id='ve_link';


update plan_psector set active = true;

