/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE:3254


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_import_dscenario_demands(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_import_dscenario_demands($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},"data":{}}$$)

--fid:v_fid

*/

DECLARE


v_result_id text= 'import dscenario demand';
v_result json;
v_result_info json;
v_project_type text;
v_version text;
v_count integer;
v_label text;
v_error_context text;
v_level integer;
v_status text;
v_message text;
v_audit_result text;
v_fid integer;
v_dscenario_id integer;
v_dscenario_name text;
BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system parameters
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	v_fid = ((p_data ->>'data')::json->>'fid')::text;

	-- manage log (fid:  v_fid)
	DELETE FROM audit_check_data WHERE fid = v_fid AND cur_user=current_user;
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3254", "fid":"'||v_fid||'", "result_id":"'||v_result_id||'", "is_process":true, "is_header":"true"}}$$)';



	-- control of rows
	SELECT count(*) INTO v_count FROM temp_csv WHERE cur_user=current_user AND fid = v_fid;

	IF v_count =0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3920", "function":"3254", "fid":"'||v_fid||'", "result_id":"'||v_result_id||'", "is_process":true}}$$)';

	ELSE
		SELECT DISTINCT csv1 INTO v_dscenario_name FROM temp_csv WHERE cur_user=current_user AND fid = v_fid LIMIT 1;
		SELECT dscenario_id INTO v_dscenario_id FROM cat_dscenario WHERE name = v_dscenario_name;

		IF v_dscenario_id is null THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
   		"data":{"message":"3238", "function":"3254","parameters":null}}$$);';
		ELSE

			DELETE FROM inp_dscenario_demand WHERE dscenario_id = v_dscenario_id;

			INSERT INTO inp_dscenario_demand(
			dscenario_id, feature_id, feature_type, demand, pattern_id, demand_type, source)
			SELECT v_dscenario_id, csv2, 'CONNEC',csv4::float, csv5, substring(csv6,1,18), csv7 FROM temp_csv JOIN connec ON csv2 = connec_id WHERE cur_user=current_user AND fid = v_fid;

			INSERT INTO inp_dscenario_demand(
			dscenario_id, feature_id, feature_type, demand, pattern_id, demand_type, source)
			SELECT v_dscenario_id, csv2, 'NODE',csv4::float, csv5, substring(csv6,1,18), csv7 FROM temp_csv JOIN man_netwjoin ON csv2 = node_id WHERE cur_user=current_user AND fid = v_fid;

			-- manage log (fid: v_fid)
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3922", "function":"3254", "fid":"'||v_fid||'", "result_id":"'||v_result_id||'", "is_process":true}}$$)';

			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3924", "function":"3254", "fid":"'||v_fid||'", "result_id":"'||v_result_id||'", "is_process":true}}$$)';

			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3926", "function":"3254", "fid":"'||v_fid||'", "result_id":"'||v_result_id||'", "is_process":true}}$$)';

		END IF;
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
