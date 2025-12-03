/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 3352

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_get_epa_selector(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_set_epa_selector(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
/*EXAMPLE:

SELECT SCHEMA_NAME.gw_fct_set_epa_selector($${"client":{"device":5, "lang":"es_ES", "cur_user": "bgeo", "infoType":1, "epsg":SRID_VALUE},
"form":{"resultNameShow": "test1","resultNameCompare":"test2","selectorDate":"test3","compareDate":"test4","selectorTime":"test5","compareTime":"test6"},
"feature":{}, "data":{"filterFields":{}, "pageInfo":{}}}$$);

*/
DECLARE
v_error_context text;
v_cur_user text;
v_result_name_to_show text;
v_result_name_to_compare text;
v_selector_date text;
v_compare_date text;
v_selector_time text;
v_compare_time text;
v_time_to_show text;
v_time_to_compare text;
v_version text;
BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- Get api version
    SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

    -- Get parameters from input
	v_result_name_to_show = ((p_data ->>'form')::json->>'tab_result_result_name_show');
	v_result_name_to_compare = ((p_data ->>'form')::json->>'tab_result_result_name_compare');

	-- ud combos:
	v_selector_date = ((p_data ->>'form')::json->>'tab_time_selector_date');
	v_compare_date = ((p_data ->>'form')::json->>'tab_time_compare_date');
	v_selector_time = ((p_data ->>'form')::json->>'tab_time_selector_time');
	v_compare_time = ((p_data ->>'form')::json->>'tab_time_compare_time');

	-- ws combos:
	v_time_to_show = ((p_data ->>'form')::json->>'tab_time_time_show');
	v_time_to_compare = ((p_data ->>'form')::json->>'tab_time_time_compare');

    -- Set project user
	v_cur_user = ((p_data ->>'client')::json->>'cur_user');

	-- Delete values from the selector_* tables
	DELETE FROM selector_rpt_main WHERE cur_user = v_cur_user;
	DELETE FROM selector_rpt_compare WHERE cur_user = v_cur_user;
	DELETE FROM selector_rpt_main_tstep WHERE cur_user = v_cur_user;
	DELETE FROM selector_rpt_compare_tstep WHERE cur_user = v_cur_user;

	-- Update current values to the table """
	IF v_result_name_to_show IS NOT NULL AND v_result_name_to_show != '-1' AND v_result_name_to_show != '' THEN
		INSERT INTO selector_rpt_main (result_id, cur_user)
		VALUES (v_result_name_to_show, v_cur_user);
	END IF;

	IF v_result_name_to_compare IS NOT NULL AND v_result_name_to_compare != '-1' AND v_result_name_to_compare != '' THEN
	    INSERT INTO selector_rpt_compare (result_id, cur_user)
		VALUES (v_result_name_to_compare, v_cur_user);
	END IF;

	IF v_selector_date IS NOT NULL AND v_selector_date != '-1' AND v_selector_date != '' THEN
	    INSERT INTO selector_rpt_main_tstep (resultdate, resulttime, cur_user)
		VALUES (v_selector_date, v_selector_time , v_cur_user);
	END IF;

	IF v_compare_date IS NOT NULL AND v_compare_date != '-1' AND v_compare_date != '' THEN
	    INSERT INTO selector_rpt_compare_tstep (resultdate, resulttime, cur_user)
		VALUES (v_compare_date, v_compare_time , v_cur_user);
	END IF;

	IF v_time_to_show IS NOT NULL AND v_time_to_show != '-1' AND v_time_to_show != '' THEN
	    INSERT INTO selector_rpt_main_tstep (timestep, cur_user)
		VALUES (v_time_to_show, v_cur_user);
	END IF;

	IF v_time_to_compare IS NOT NULL AND v_time_to_compare != '-1' AND v_time_to_compare != '' THEN
	    INSERT INTO selector_rpt_compare_tstep (timestep, cur_user)
		VALUES (v_time_to_compare, v_cur_user);
	END IF;

	-- Return JSON
	RETURN gw_fct_json_create_return(('{
        "status": "Accepted",
        "version": "' || v_version || '",
        "body": {}
    }')::json, 3348, null, null, null)::json;


	--    Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = pg_exception_context;
	RETURN ('{"status":"Failed", "SQLERR":' || to_json(SQLERRM) || ',"SQLCONTEXT":' || to_json(v_error_context) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$function$
;
