/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3326

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_epa_hydraulic_performance(p_data json);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_epa_hydraulic_performance(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE

SELECT SCHEMA_NAME.gw_fct_epa_hydraulic_performance($${"data":{"parameters":{"resultId":"t2", "wwtpOutfalls":"236"}, "aux_params":null}}$$);

fid = 531

*/

DECLARE

v_version text;
v_result json;
v_result_info json;
v_id json;
v_selectionmode text;
v_saveondatabase boolean;
v_worklayer text;
v_array text;
v_error_context text;
v_count integer;
v_eparesult text;
v_inf float = 0;
v_wwtp float = 0;
v_rain float = 0;
v_dwf float = 0;
v_performance float = 0;
v_wwtpoutfalls text;
v_fid integer = 531;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

   	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data
	v_eparesult :=  (((p_data ->>'data')::json->>'parameters')::json->>'resultId');
	v_wwtpoutfalls :=  (((p_data ->>'data')::json->>'parameters')::json->>'wwtpOutfalls');

	DELETE FROM audit_check_data where fid = v_fid AND cur_user = current_user;

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3326", "fid":"'||v_fid||'", "criticity":"4", "is_process":true, "is_header":"true"}}$$)';

	-- get wwtp volume
	EXECUTE 'SELECT total_vol FROM rpt_outfallflow_sum WHERE result_id = '||quote_literal(v_eparesult)||' AND node_id !=''System'' AND node_id::integer IN ('||v_wwtpoutfalls||')'	INTO v_wwtp;

	IF v_wwtp IS NULL THEN
		RAISE EXCEPTION 'This result does not have the specified nodes as outfalls. Please check your data before continue';
	END IF;

	v_inf = 10*(SELECT infil_loss FROM rpt_runoff_quant WHERE result_id = v_eparesult);
	v_rain = 10*(SELECT total_prec FROM rpt_runoff_quant WHERE result_id = v_eparesult);
	v_dwf = 10*(SELECT dryw_inf FROM rpt_flowrouting_cont WHERE result_id = v_eparesult);

	v_performance = (v_inf + v_wwtp)/(v_rain + v_dwf);

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4006", "function":"3326", "parameters":{"v_eparesult":"'||v_eparesult||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4008", "function":"3326", "parameters":{"v_wwtpoutfalls":"'||v_wwtpoutfalls||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('--------------------------'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '');

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4010", "function":"3326", "parameters":{"v_rain":"'||v_rain||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4012", "function":"3326", "parameters":{"v_dwf":"'||v_dwf||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4014", "function":"3326", "parameters":{"v_inf":"'||v_inf||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4016", "function":"3326", "parameters":{"v_wwtp":"'||v_wwtp||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '');
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4018", "function":"3326", "parameters":{"(100*v_performance)::numeric(12,2)":"'||(100*v_performance)::numeric(12,2)||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by id) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}');

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||'}}'||
	    '}')::json, 2204, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;