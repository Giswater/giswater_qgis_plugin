/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3134

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_create_dwf_scenario_empty(p_data json)
RETURNS json AS
$BODY$


/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_create_dwf_scenario_empty($${"client":{"device":4, "infoType":1, "lang":"ES"}, "data":{"parameters":{"target":"1", "copyFrom":"2", "action":"DELETE-COPY"}}}$$)
-- fid: 438
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
v_fid integer = 524;
v_source_name text;
v_target_name text;
v_action text;
v_querytext text;
v_result_id text = null;
v_idval text;
v_startdate date;
v_enddate date;
v_observ text;
v_expl_id integer;
v_scenarioid text;
v_aux_params json;
v_inp_dwf text;


BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting variables
	v_inp_dwf = (SELECT value FROM config_param_user WHERE parameter = 'inp_options_dwfscenario_current' AND cur_user = current_user limit 1);

	-- getting input data
	v_idval :=  ((p_data ->>'data')::json->>'parameters')::json->>'idval';
	v_startdate :=  ((p_data ->>'data')::json->>'parameters')::json->>'startdate';
	v_enddate :=  ((p_data ->>'data')::json->>'parameters')::json->>'enddate';
	v_observ :=  ((p_data ->>'data')::json->>'parameters')::json->>'observ';
	v_expl_id :=  ((p_data ->>'data')::json->>'parameters')::json->>'expl';
	v_aux_params := ((p_data ->>'data')::json->>'aux_params')::json;

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{}, 
						"data":{"function":"3134", "fid":"'||v_fid||'", "criticity":"4", "is_process":true, "is_header":"true"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"}, "feature":{}, 
                        "data":{"function":"3134", "fid":"'||v_fid||'", "criticity":"3", "is_process":true, "is_header":"true", "prefix_id":"3003"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"}, "feature":{}, 
                        "data":{"function":"3134", "fid":"'||v_fid||'", "criticity":"2", "is_process":true, "is_header":"true", "prefix_id":"3002"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"}, "feature":{}, 
                        "data":{"function":"3134", "fid":"'||v_fid||'", "criticity":"1", "is_process":true, "is_header":"true", "prefix_id":"3001"}}$$)';

	-- process
	-- inserting on catalog table
	PERFORM setval('SCHEMA_NAME.cat_dwf_id_seq'::regclass,(SELECT max(id) FROM cat_dwf) ,true);

	INSERT INTO cat_dwf (idval, startdate, enddate, observ, active, expl_id,log)
	VALUES (v_idval, v_startdate, v_enddate, v_observ, true, v_expl_id, concat('Created by ',current_user,' on ',substring(now()::text,0,20)))
	ON CONFLICT (idval) DO NOTHING
	RETURNING id INTO v_scenarioid;

	IF v_scenarioid IS NULL THEN
		SELECT id INTO v_scenarioid FROM cat_dwf where idval = v_idval;
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{}, 
							"data":{"message":"3880", "function":"3134", "parameters":{"v_idval":"'||v_idval||'"}, "fid":"'||v_fid||'", "criticity":"3", "prefix_id":"1003", "is_process":true}}$$)';
	ELSE

		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{}, 
							"data":{"message":"3882", "function":"3134", "parameters":{"v_idval":"'||v_idval||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
							"data":{"message":"3884", "function":"3134", "parameters":{"v_startdate":"'||quote_nullable(v_startdate)||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
							"data":{"message":"3886", "function":"3134", "parameters":{"v_enddate":"'||quote_nullable(v_enddate)||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
							"data":{"message":"3888", "function":"3134", "parameters":{"v_observ":"'||quote_nullable(v_observ)||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
							"data":{"message":"3890", "function":"3134", "parameters":{"v_active":"true"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
							"data":{"message":"3892", "function":"3134", "parameters":{"v_expl_id":"'||v_expl_id||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat(''));
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
							"data":{"message":"3894", "function":"3134", "parameters":{"v_scenarioid":"'||v_scenarioid||'"}, "fid":"'||v_fid||'", "criticity":"1", "is_process":true}}$$)';
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
							"data":{"message":"3896", "function":"3134", "fid":"'||v_fid||'", "criticity":"1", "is_process":true}}$$)';

		-- setting current dwf for user
		UPDATE config_param_user SET value = v_scenarioid WHERE cur_user = current_user AND parameter = 'inp_options_dwfscenario_current';
	END IF;

	-- insert spacers
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, concat(''));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, concat(''));

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

	-- Execute aux_func
	if v_aux_params->>'aux_fct'::text = '3102' then
		execute 'SELECT gw_fct_manage_dwf_values($${"client":{"device":4, "lang":"", "infoType":1, "epsg":SRID_VALUE}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"target":"'||
		v_scenarioid||'", "sector":"-999", "action":"KEEP-COPY", "copyFrom":"'||v_inp_dwf||'"}}}$$);';
	end if;

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}');

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||
			'}}'||
	    '}')::json, 3042, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;