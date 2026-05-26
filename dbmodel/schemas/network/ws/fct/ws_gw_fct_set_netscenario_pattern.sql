/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE:3258


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_set_netscenario_pattern(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_set_netscenario_pattern($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},"data":{}}$$)

--fid:v_fid

*/

DECLARE

v_fid integer =502;
v_netscenario_mapzone integer;
v_dscenario_demand integer;

v_result_id text= 'Set patterns using netscenarios';
v_result json;
v_result_info json;
v_project_type text;
v_version text;


v_count integer;

v_error_context text;
v_level integer;
v_status text;
v_message text;
v_audit_result text;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system parameters
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

  v_netscenario_mapzone = (((p_data ->>'data')::json->>'parameters')::json->>'dscenario_mapzone')::text;
  v_dscenario_demand = (((p_data ->>'data')::json->>'parameters')::json->>'dscenario_demand')::integer;

	-- manage log (fid:  v_fid)
	DELETE FROM audit_check_data WHERE fid = v_fid AND cur_user=current_user;
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3258", "fid":"'||v_fid||'", "result_id":"'||quote_nullable(v_result_id)||'", "is_process":true, "is_header":"true"}}$$)';

	--check if all mapzones have assigned pattern_id

	EXECUTE 'SELECT count(*) FROM plan_netscenario WHERE netscenario_type = ''DMA'' AND netscenario_id = '||quote_nullable(v_netscenario_mapzone)||'
	and parent_id IS NULL;'
	INTO v_count;

	IF v_count = 0 THEN

		EXECUTE 'INSERT INTO inp_dscenario_demand(dscenario_id, feature_id, feature_type, pattern_id)
		SELECT '||v_dscenario_demand||', connec_id, ''CONNEC'', pattern_id FROM plan_netscenario_connec
		WHERE netscenario_id = '||quote_nullable(v_netscenario_mapzone)||';';

		EXECUTE 'SELECT count(*) from inp_dscenario_demand
		WHERE dscenario_id =  '||v_dscenario_demand||' AND feature_type = ''CONNEC'''
		INTO v_count;

		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3756", "function":"3258", "parameters":{"v_count":"'||v_count||'"}, "fid":"'||v_fid||'", "result_id":"'||quote_nullable(v_result_id)||'", "is_process":true}}$$)';

		EXECUTE 'INSERT INTO inp_dscenario_demand( dscenario_id, feature_id, feature_type, pattern_id)
		SELECT '||v_dscenario_demand||', node_id, ''NODE'', pattern_id FROM plan_netscenario_node
		WHERE  netscenario_id = '||quote_nullable(v_netscenario_mapzone)||';';

		EXECUTE 'SELECT count(*) from inp_dscenario_demand
		WHERE dscenario_id =  '||v_dscenario_demand||' AND feature_type = ''NODE'''
		INTO v_count;

		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3758", "function":"3258", "parameters":{"v_count":"'||v_count||'"}, "fid":"'||v_fid||'", "result_id":"'||quote_nullable(v_result_id)||'", "is_process":true}}$$)';
	ELSE
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3760", "function":"3258", "parameters":{"v_count":"'||v_count||'"}, "fid":"'||v_fid||'", "result_id":"'||quote_nullable(v_result_id)||'", "is_process":true}}$$)';
	END IF;
	-- get log (fid: v_fid)
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message AS message FROM audit_check_data WHERE cur_user="current_user"() AND fid = v_fid) row;

	IF v_audit_result is null THEN
        v_status = 'Accepted';
        v_level = 3;
        v_message = 'Process done successfully';
    ELSE

        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text INTO v_status;
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer INTO v_level;
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text INTO v_message;

    END IF;


	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

	-- Control nulls
	v_version := COALESCE(v_version, '');
	v_result_info := COALESCE(v_result_info, '{}');

	-- Return
	RETURN ('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
            ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||'}}'||
	    '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
