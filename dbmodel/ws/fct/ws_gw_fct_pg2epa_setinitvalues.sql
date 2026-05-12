/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3268

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_pg2epa_setinitvalues(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE

-- fid: 508
SELECT SCHEMA_NAME.gw_fct_pg2epa_setinitvalues($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":SRID_VALUE}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "result_id":"result1"}}$$);
*/

DECLARE

v_version text;
v_result json;
v_result_info json;
v_error_context text;
v_projecttype text;
v_fid integer = 510;
v_result_id text;
v_time text;
v_count integer;
v_query text;
BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data
	v_result_id :=  json_extract_path_text(p_data, 'data', 'parameters', 'resultId')::text;

	-- Reset values
		DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;

	-- create log

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3268", "fid":"'||v_fid||'", "criticity":"4", "is_process":true, "is_header":"true"}}$$)';


	EXECUTE 'SELECT time FROM rpt_node ORDER BY split_part(time,'':'',1)::integer desc LIMIT 1' INTO v_time;

	EXECUTE 'SELECT count(distinct node_id) FROM inp_inlet JOIN rpt_node USING (node_id) WHERE result_id='||quote_literal(v_result_id)||';'
	INTO v_count;

	EXECUTE 'UPDATE inp_inlet SET initlevel = press FROM rpt_node WHERE inp_inlet.node_id = rpt_node.node_id AND result_id='||quote_literal(v_result_id)||' AND time ='||quote_literal(v_time)||';';

	
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4002", "function":"3268", "parameters":{"v_count":"'||v_count||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';

	EXECUTE 'SELECT count(distinct node_id) FROM inp_tank JOIN rpt_node USING (node_id) WHERE result_id='||quote_literal(v_result_id)||';'
	INTO v_count;

	EXECUTE 'UPDATE inp_tank SET initlevel = press FROM rpt_node WHERE inp_tank.node_id = rpt_node.node_id AND result_id='||quote_literal(v_result_id)||' AND time ='||quote_literal(v_time)||';';



EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4004", "function":"3268", "parameters":{"v_count":"'||v_count||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';
	-- insert spacers
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, concat(''));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, concat(''));

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}');

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Process done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||
			'}}'||
	    '}')::json, 3268, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
