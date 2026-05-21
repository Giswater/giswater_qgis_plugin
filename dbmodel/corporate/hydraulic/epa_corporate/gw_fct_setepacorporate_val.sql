/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3240
DROP FUNCTION IF EXISTS ws_corp.gw_fct_setepacorporate_val(json);
CREATE OR REPLACE FUNCTION ws_corp.gw_fct_setepacorporate_val(p_data json)
RETURNS json AS
$BODY$

/*

-- to config 
INSERT INTO ws_corp.sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3240, 'gw_fct_setepacorporate_val', 'utils', 'function', 'json', 'json', 'Function to move corporate values from productions schema to publish schema', 'role_admin', NULL, 'corporate');

INSERT INTO ws_corp.config_toolbox (id, alias, functionparams, inputparams, observ, active) VALUES(3234, 'Set EPA values from productions to publish', '{"featureType":[]}'::json, 
'[{"widgetname":"resultId", "label":"Result Id:","widgettype":"text","datatype":"text", "layoutname":"grl_option_parameters","layoutorder":1, "isMandatory":true, "value":""}]'::json, NULL, true);

INSERT INTO ws_corp.config_toolbox (id, alias, functionparams, inputparams, observ, active) VALUES(3234, 'Set EPA values from productions to publish', '{"featureType":[]}'::json, 
'[{"widgetname":"resultId", "label":"Result Id:","widgettype":"text","datatype":"text", "layoutname":"grl_option_parameters","layoutorder":1, "isMandatory":true, "value":""}]'::json, NULL, true);

INSERT INTO ws_corp.sys_fprocess
(fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam)
VALUES(489, 'Process to move corporate values from productions schema to publish schema', 'utils', NULL, 'core', true, 'Function process', NULL);

UPDATE ws_corp.config_toolbox SET active =  false where id not in (3234);
UPDATE ws_corp.config_report SET active =  false;

ALTER TABLE rpt_node ADD COLUMN custom_demand float;

drop view ws_corp.v_rpt_node;
CREATE OR REPLACE VIEW ws_corp.v_rpt_node AS 
 SELECT node.node_id,
    selector_rpt_main.result_id,
    node.node_type,
    node.nodecat_id,
    max(rpt_node.elevation) AS elevation,
    max(rpt_node.demand) AS max_demand,
    min(rpt_node.demand) AS min_demand,
    max(rpt_node.head) AS max_head,
    min(rpt_node.head) AS min_head,
    max(rpt_node.press) AS max_pressure,
    min(rpt_node.press) AS min_pressure,
    max(rpt_node.quality) AS max_quality,
    min(rpt_node.quality) AS min_quality,
    max(custom_demand) as max_custom_demand,
    node.the_geom
   FROM ws_corp.selector_rpt_main,
    ws_corp.rpt_inp_node node
     JOIN ws_corp.rpt_node ON rpt_node.node_id::text = node.node_id::text
  WHERE rpt_node.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND node.result_id::text = selector_rpt_main.result_id::text
  GROUP BY node.node_id, node.node_type, node.nodecat_id, selector_rpt_main.result_id, node.the_geom
  ORDER BY node.node_id;


UPDATE rpt_node SET custom_demand = 3600*24*demand/1000
select node_id, custom_demand from rpt_node order by 2 desc

-- to execute
SELECT gw_fct_setepacorporate_val('{"data":{"parameters":{"resultId":"gam_oeste_v11"}}}');
SELECT ws_corp.gw_fct_setepacorporate_val('{"data":{"parameters":{"resultId":"gam_este_v01"}}}');

*/

DECLARE

v_result text;
v_result_info json;
v_version text;
v_error_context text;
v_fid integer = 489;
v_arcs integer;
v_nodes integer;


BEGIN

	-- Search path
	SET search_path = "ws_corp", public;

	-- getting system parameters
	v_version = (SELECT giswater from sys_version order by date desc limit 1);

	-- getting parameter from function
	v_result = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'resultId');

	DELETE FROM audit_check_data WHERE fid = v_fid;

	-- start build log message
	INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('MOVING EPA-RESULT FROM PRODUCTION TO PUBLISH SCHEMA '));
	INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('------------------------------------------------------------------------'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('Result Id: ', v_result));

	-- start build log message
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 3, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 3, 'ERRORS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 3, '-----------');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 2, 'WARNINGS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 2, '--------------');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 1, 'INFO');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 1, '-------');

	DELETE FROM rpt_cat_result WHERE result_id = v_result;
	INSERT INTO rpt_cat_result SELECT * FROM ws.rpt_cat_result WHERE result_id = v_result;

	INSERT INTO rpt_inp_arc SELECT * from ws.rpt_inp_arc WHERE result_id = v_result;
	INSERT INTO rpt_inp_node SELECT * from ws.rpt_inp_node WHERE result_id = v_result;
	INSERT INTO rpt_arc SELECT * from ws.rpt_arc WHERE result_id = v_result;
	GET DIAGNOSTICS v_arcs = row_count;
	
	INSERT INTO rpt_energy_usage SELECT * from ws.rpt_energy_usage WHERE result_id = v_result;
	INSERT INTO rpt_hydraulic_status SELECT * from ws.rpt_hydraulic_status WHERE result_id = v_result;
	INSERT INTO rpt_inp_pattern_value SELECT * from ws.rpt_inp_pattern_value WHERE result_id = v_result;
	
	INSERT INTO rpt_node SELECT * from ws.rpt_node WHERE result_id = v_result;
	GET DIAGNOSTICS v_nodes = row_count;

	-- Upsert selector
	INSERT INTO selector_rpt_main 
	SELECT v_result, id FROM cat_users
	ON CONFLICT (result_id, cur_user) DO NOTHING;

	-- get log
	INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (v_fid, 1, 'INFO: Process have been executed');
	INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (v_fid, 1, concat('INFO: ', v_nodes, ' rows on nodes result table (rpt_node) have been imported from production enviroment'));
	INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (v_fid, 1, concat('INFO: ', v_arcs, ' rows on arc result table (rpt_arc) have been imported from production enviroment'));

	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid IN (v_fid) order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"values":',v_result, '}');
	
	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
		
	--  Return
	RETURN ('{"status":"Accepted", "message":{"level":1, "text":""}, "version":"'||v_version||'"'||',"body":{"form":{}, "data":{"info":'||v_result_info||'}}}')::json;


	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


  grant all on all functions in schema ws_corp to role_basic