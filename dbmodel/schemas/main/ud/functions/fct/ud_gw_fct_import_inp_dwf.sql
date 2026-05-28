/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3298
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_import_inp_dwf(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$


/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_import_inp_dwf($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{}}$$)

--fid:527

*/

DECLARE

rec_csv record;
v_result_id text= 'import inp dwf';
v_result json;
v_result_info json;
v_project_type text;
v_version text;
v_fid integer = 527;
v_timsertype text;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system parameters
	SELECT project_type, giswater  INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- manage log (fid: v_fid)
	DELETE FROM audit_check_data WHERE fid = v_fid AND cur_user=current_user;

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('IMPORT INP DWF'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('----------------------------------'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, concat('Reading values from temp_csv table -> Done'));

  	-- starting process
 	FOR rec_csv IN SELECT * FROM temp_csv WHERE cur_user=current_user AND fid = v_fid
	LOOP
		IF rec_csv.csv1 IS NOT NULL THEN -- to control those null rows because user has a bad structured csv file (common last lines)

			-- insert log
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message, table_id)
			VALUES (v_fid, v_result_id, 1, concat('INFO: Node ',rec_csv.csv2,' in DWF Scenario ',rec_csv.csv1,' have been imported succesfully'), rec_csv.csv1);

			-- insert inp_dwf
			INSERT INTO inp_dwf (dwfscenario_id, node_id, value, pat1, pat2, pat3, pat4)
			VALUES (rec_csv.csv1::integer, rec_csv.csv2::integer, rec_csv.csv3::numeric, rec_csv.csv4, rec_csv.csv5, rec_csv.csv6, rec_csv.csv7);
		END IF;
	END LOOP;

	-- setting current dwf for user
	UPDATE config_param_user SET value = rec_csv.csv1::integer WHERE cur_user = current_user AND parameter = 'inp_options_dwfscenario_current';

	-- manage log (fid: v_fid)
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 1, concat('This DWF scenario is now your current scenario'));

	-- manage log (fid: v_fid)
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 1, concat('Process finished'));

	-- get log (fid: v_fid)
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message AS message FROM audit_check_data WHERE cur_user="current_user"() AND fid = v_fid ORDER BY criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

	-- Control nulls
	v_version := COALESCE(v_version, '');
	v_result_info := COALESCE(v_result_info, '{}');

	-- Return
	RETURN ('{"status":"Accepted", "message":{"level":0, "text":"Process executed"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||'}}'||
	    '}')::json;

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	RETURN json_build_object('status', 'Failed', 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'version', v_version, 'SQLSTATE', SQLSTATE)::json;



END;
$function$
;
