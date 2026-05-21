/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3156

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_duplicate_dscenario(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_duplicate_dscenario($${"client":{"device":4, "infoType":1, "lang":"ES"}, "data":{"parameters":{"target":"1", "copyFrom":"2", "action":"DELETE-COPY"}}}$$)

SELECT SCHEMA_NAME.gw_fct_duplicate_dscenario($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":SRID_VALUE}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"test", "descript":null, "parent":null, "type":"DEMAND", "active":"true", "expl":"1", "copyFrom": 1}}}$$)

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

v_name text;
v_descript text;
v_parent_id integer;
v_dscenario_type text;
v_active boolean;
v_expl_id integer;
v_scenarioid integer;


BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data
	v_name :=  ((p_data ->>'data')::json->>'parameters')::json->>'name';
	v_descript :=  ((p_data ->>'data')::json->>'parameters')::json->>'descript';
	v_parent_id :=  ((p_data ->>'data')::json->>'parameters')::json->>'parent';
	v_dscenario_type :=  ((p_data ->>'data')::json->>'parameters')::json->>'type';
	v_active :=  ((p_data ->>'data')::json->>'parameters')::json->>'active';
	v_expl_id :=  ((p_data ->>'data')::json->>'parameters')::json->>'expl';
    v_copyfrom := ((p_data ->>'data')::json->>'parameters')::json->>'copyFrom';
    v_action := 'KEEP-COPY';


	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3156", "fid":"'||v_fid||'", "criticity":"4", "is_process":true, "is_header":"true"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3714", "function":"3156", "parameters":{"v_copyfrom":"'||v_copyfrom||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3662", "function":"3156", "parameters":{"v_name":"'||v_name||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3664", "function":"3156", "parameters":{"v_descript":"'||quote_nullable(v_descript)||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3666", "function":"3156", "parameters":{"v_parent_id":"'||quote_nullable(v_parent_id)||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3668", "function":"3156", "parameters":{"v_dscenario_type":"'||v_dscenario_type||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3670", "function":"3156", "parameters":{"v_active":"'||v_active||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3716", "function":"3156", "parameters":{"v_expl_id":"'||v_expl_id||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat(''));

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3156", "fid":"'||v_fid||'", "criticity":"3", "is_process":true, "is_header":"true", "label_id":"1004", "separator_id":"2008"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3156", "fid":"'||v_fid||'", "criticity":"2", "is_process":true, "is_header":"true", "label_id":"3002", "separator_id":"2009"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3156", "fid":"'||v_fid||'", "criticity":"1", "is_process":true, "is_header":"true", "label_id":"3001", "separator_id":"2009"}}$$)';

	-- process
	-- Create empty dscenario
	EXECUTE 'SELECT gw_fct_create_dscenario_empty($$'||p_data||'$$);';
	SELECT dscenario_id INTO v_scenarioid FROM cat_dscenario where name = v_name;

		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3718", "function":"3156", "parameters":{"v_name":"'||v_name||'", "v_copyfrom":"'||v_copyfrom||'"}, "fid":"'||v_fid||'", "criticity":"1", "prefix_id":"1001", "is_process":true}}$$)';


	-- Copy values from dscenario to copy from
	EXECUTE 'SELECT gw_fct_manage_dscenario_values($${"client": '||(p_data ->>'client')::json||', "data": {"parameters": {"target": '||v_scenarioid||', "copyFrom": '||v_copyfrom||', "action": '||quote_ident(v_action)||'}}}$$);';

		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3720", "function":"3156", "parameters":{"v_scenarioid":"'||v_scenarioid||'", "v_copyfrom":"'||v_copyfrom||'"}, "fid":"'||v_fid||'", "criticity":"1", "prefix_id":"1001", "is_process":true}}$$)';


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
