/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3158

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_create_dscenario_from_mincut(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE

-- fid: 461
SELECT SCHEMA_NAME.gw_fct_create_dscenario_from_mincut($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":SRID_VALUE},"data":{"parameters":{"name":"TEST", "descript":"TEST", "mincutId":"3"}}}$$);
*/


DECLARE

v_version text;
v_result json;
v_result_info json;
v_error_context text;
v_count integer;
v_count2 integer;
v_fid integer = 461;
v_action text;
v_querytext text;
v_name text;
v_descript text;
v_scenarioid integer;
v_mincut integer;
v_networkmode integer;
v_valvetype text;
v_expl integer;

BEGIN


	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- get values from system
	v_valvetype = (SELECT value FROM config_param_system WHERE parameter = 'epa_shutoffvalve');

	-- getting input data
	-- parameters of action CREATE
	v_name :=  ((p_data ->>'data')::json->>'parameters')::json->>'name';
	v_descript :=  ((p_data ->>'data')::json->>'parameters')::json->>'descript';
	v_mincut :=  ((p_data ->>'data')::json->>'parameters')::json->>'mincutId';

	v_expl := (SELECT expl_id FROM om_mincut WHERE id  = v_mincut);

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;

	-- create log
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3158", "fid":"'||v_fid||'", "criticity":"4", "is_process":true, "is_header":"true"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3158", "fid":"'||v_fid||'", "criticity":"3", "is_process":true, "is_header":"true", "label_id":"3003", "separator_id":"2008"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3158", "fid":"'||v_fid||'", "criticity":"2", "is_process":true, "is_header":"true", "label_id":"3002", "separator_id":"2010"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3158", "fid":"'||v_fid||'", "criticity":"1", "is_process":true, "is_header":"true", "label_id":"3001", "separator_id":"2009"}}$$)';


	-- inserting on catalog table
	PERFORM setval('SCHEMA_NAME.cat_dscenario_dscenario_id_seq'::regclass,(SELECT max(dscenario_id) FROM cat_dscenario) ,true);

	INSERT INTO cat_dscenario ( name, descript, dscenario_type, expl_id, log)
	VALUES ( v_name, v_descript, v_valvetype, v_expl, concat('Insert by ',current_user,' on ', substring(now()::text,0,20), ' from mincut Id: ',v_mincut)) ON CONFLICT (name) DO NOTHING
	RETURNING dscenario_id INTO v_scenarioid;

	IF v_scenarioid IS NULL THEN
		SELECT dscenario_id INTO v_scenarioid FROM cat_dscenario where name = v_name;
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3696", "function":"3158", "parameters":{"v_scenarioid":"'||v_scenarioid||'", "v_name":"'||v_name||'"}, "fid":"'||v_fid||'", "criticity":"3", "prefix_id":"1003", "is_process":true}}$$)';

	ELSE

		-- insert process
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3954", "function":"3158", "parameters":{"v_scenarioid":"'||v_scenarioid||'", "v_name":"'||v_name||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';


		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Mincut id: ',v_mincut));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat(''));
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3700", "function":"3158", "fid":"'||v_fid||'", "criticity":"1", "prefix_id":"1001", "is_process":true}}$$)';

		IF v_valvetype = 'SHORTPIPE' THEN

			INSERT INTO inp_dscenario_shortpipe (dscenario_id,node_id, status) SELECT v_scenarioid, node_id, 'CLOSED' FROM om_mincut_valve WHERE result_id = v_mincut AND (proposed IS TRUE OR closed IS TRUE);

			-- log
			GET DIAGNOSTICS v_count = row_count;
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3956", "function":"3158", "parameters":{"v_count":"'||v_count||'"}, "fid":"'||v_fid||'", "criticity":"1", "prefix_id":"1001", "is_process":true}}$$)';

		ELSIF  v_valvetype = 'VALVE' THEN

			INSERT INTO inp_dscenario_valve (dscenario_id,node_id, status) SELECT v_scenarioid, node_id, 'CLOSED' FROM om_mincut_valve WHERE result_id = v_mincut AND (proposed IS TRUE OR closed IS TRUE);

			-- log
			GET DIAGNOSTICS v_count = row_count;
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3958", "function":"3158", "parameters":{"v_count":"'||v_count||'"}, "fid":"'||v_fid||'", "criticity":"1", "prefix_id":"1001", "is_process":true}}$$)';

		END IF;

		-- set selector
		INSERT INTO selector_inp_dscenario (dscenario_id,cur_user) VALUES (v_scenarioid, current_user) ON CONFLICT (dscenario_id,cur_user) DO NOTHING ;

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

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}');

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||
			'}}'||
	    '}')::json, 3158, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;