/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3156

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_duplicate_dwf_scenario(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_duplicate_dwf_scenario($${"client":{"device":4, "lang":"ca_ES", "infoType":1, "epsg":SRID_VALUE}, "form":{}, "feature":{}, "data":{"filterFields":{},
"pageInfo":{}, "parameters":{"copyFrom":"2", "idval":"SGASGA", "startdate":"2024/10/16", "enddate":"2024/10/16", "observ":"SDGA", "expl":"1", "active":"true"}, "aux_params":null}}$$);

-- fid: 459

*/


DECLARE

object_rec record;

v_version text;
v_result json;
v_result_info json;
v_copyfrom integer;
v_target integer;
v_error_context text;
v_count integer;
v_count2 integer;
v_projecttype text;
v_fid integer = 459;
v_source_name text;
v_target_name text;
v_action text;
v_querytext text;
v_result_id text = null;
v_idval text;
v_descript text;
v_parent_id integer;
v_scenarioid text;
v_aux_params json;
v_inp_dwf text;
v_startdate date;
v_enddate date;
v_observ text;
v_expl_id integer;
v_active boolean;


BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data
	v_idval :=  ((p_data ->>'data')::json->>'parameters')::json->>'idval';
	v_startdate :=  ((p_data ->>'data')::json->>'parameters')::json->>'startdate';
	v_enddate :=  ((p_data ->>'data')::json->>'parameters')::json->>'enddate';
	v_observ :=  ((p_data ->>'data')::json->>'parameters')::json->>'observ';
	v_expl_id :=  ((p_data ->>'data')::json->>'parameters')::json->>'expl';
	v_active :=  ((p_data ->>'data')::json->>'parameters')::json->>'active';
	v_aux_params := ((p_data ->>'data')::json->>'aux_params')::json;
	v_copyfrom := ((p_data ->>'data')::json->>'parameters')::json->>'copyFrom';
	v_action := 'KEEP-COPY';

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
						"data":{"function":"3156", "fid":"'||v_fid||'", "criticity":"4", "is_process":true, "is_header":"true"}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
						"data":{"message":"3882", "function":"3156", "parameters":{"v_idval":"'||v_idval||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
						"data":{"message":"3884", "function":"3156", "parameters":{"v_startdate":"'||quote_nullable(v_startdate)||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
						"data":{"message":"3886", "function":"3156", "parameters":{"v_enddate":"'||quote_nullable(v_enddate)||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
						"data":{"message":"3888", "function":"3156", "parameters":{"v_observ":"'||quote_nullable(v_observ)||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
						"data":{"message":"3890", "function":"3156", "parameters":{"v_active":"'||v_active||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
						"data":{"message":"3892", "function":"3156", "parameters":{"v_expl_id":"'||v_expl_id||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat(''));

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                        "data":{"function":"3156", "fid":"'||v_fid||'", "criticity":"3", "is_process":true,"is_header":"true", "prefix_id":"3003"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                        "data":{"function":"3156", "fid":"'||v_fid||'", "criticity":"2", "is_process":true,"is_header":"true", "prefix_id":"3002"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                        "data":{"function":"3156", "fid":"'||v_fid||'", "criticity":"2", "is_process":true,"is_header":"true", "prefix_id":"3001"}}$$)';

	-- process
	-- Create empty dwf scenario
	EXECUTE 'SELECT gw_fct_create_dwf_scenario_empty($$'||p_data||'$$);';
	SELECT id INTO v_scenarioid FROM cat_dwf where idval = v_idval;
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
						"data":{"message":"3898", "function":"3156", "parameters":{"v_idval":"'||v_idval||'", "v_copyfrom":"'||v_copyfrom||'"}, "fid":"'||v_fid||'", "criticity":"1", "is_process":true}}$$)';

	-- Copy values from Dwf scenario to copy from
	EXECUTE 'SELECT gw_fct_manage_dwf_values($${"client": '||(p_data ->>'client')::json||', "data": {"parameters": {"target": '||v_scenarioid||', "copyFrom": '||v_copyfrom||', "action": '||quote_ident(v_action)||', "sector":-998}}}$$);';
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4,"infoType":1,"lang":"ES"},"feature":{},
						"data":{"message":"3900","function":"3156","parameters":{"v_copyfrom":"'||v_copyfrom||'","v_scenarioid":"'||v_scenarioid||'"},"fid":"'||v_fid||'","criticity":"1","is_process":true, "prefix_id":"1001"}}$$)';

	-- setting current dwf for user
	UPDATE config_param_user SET value = v_scenarioid WHERE cur_user = current_user AND parameter = 'inp_options_dwfscenario_current';

	-- manage log (fid: v_fid)
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4,"infoType":1,"lang":"ES"},"feature":{}, 
						"data":{"message":"4302","function":"3156", "fid":"'||v_fid||'", "result_id":"'||quote_nullable(v_result_id)||'", "criticity":"1","is_process":true}}$$)';

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
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||
			'}}'||
	    '}')::json, 3156, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
